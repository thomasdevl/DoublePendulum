// reference: https://www.myphysicslab.com/pendulum/double-pendulum-en.html

int numPendulums = 20; // Number of pendulums
float[] r1 = new float[numPendulums];
float[] r2 = new float[numPendulums];
float[] m1 = new float[numPendulums];
float[] m2 = new float[numPendulums];
float[] a1 = new float[numPendulums];
float[] a2 = new float[numPendulums];
float[] a1_v = new float[numPendulums];
float[] a2_v = new float[numPendulums];
float g = 1; //"accurate" simulation

float cx, cy;
float[] px2 = new float[numPendulums];
float[] py2 = new float[numPendulums];

PGraphics canvas;

void setup() {
  size(900, 800);
  cx = width/2;
  cy = height/2-50;
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();

  colorMode(HSB, 255); // Set color mode to HSB

  // Initialize pendulum variables
  for (int i = 0; i < numPendulums; i++) {
    r1[i] = 200;
    r2[i] = 200;
    m1[i] = 10;
    m2[i] = 10;
    a1[i] = PI/2 + random(-0.01, 0.01); // Small random deviation
    a2[i] = PI/2 + random(-0.01, 0.01); // Small random deviation
    a1_v[i] = 0;
    a2_v[i] = 0;
    px2[i] = -1;
    py2[i] = -1;
  }
}

void draw() {
  background(255);
  image(canvas, 0, 0);

  for (int i = 0; i < numPendulums; i++) {
    float num1 = -g * (2 * m1[i] + m2[i]) * sin(a1[i]);
    float num2 = -m2[i] * g * sin(a1[i] - 2 * a2[i]);
    float num3 = -2 * sin(a1[i] - a2[i]) * m2[i];
    float num4 = a2_v[i] * a2_v[i] * r2[i] + a1_v[i] * a1_v[i] * r1[i] * cos(a1[i] - a2[i]);
    float den = r1[i] * (2 * m1[i] + m2[i] - m2[i] * cos(2 * a1[i] - 2 * a2[i]));
    float a1_a = (num1 + num2 + num3 * num4) / den;
    
    num1 = 2 * sin(a1[i] - a2[i]);
    num2 = (a1_v[i] * a1_v[i] * r1[i] * (m1[i] + m2[i]));
    num3 = g * (m1[i] + m2[i]) * cos(a1[i]);
    num4 = a2_v[i] * a2_v[i] * r2[i] * m2[i] * cos(a1[i] - a2[i]);
    den = r2[i] * (2 * m1[i] + m2[i] - m2[i] * cos(2 * a1[i] - 2 * a2[i]));
    float a2_a = (num1 * (num2 + num3 + num4)) / den;
  
    float hue = map(i, 0, numPendulums - 1, 0, 255); // Generate a different hue for each pendulum

    color pendulumColor = color(hue, 255, 255); // Convert hue to color

    stroke(pendulumColor);
    strokeWeight(2);
  
    translate(cx, cy);
  
    float x1 = r1[i] * sin(a1[i]);
    float y1 = r1[i] * cos(a1[i]);
  
    float x2 = x1 + r2[i] * sin(a2[i]);
    float y2 = y1 + r2[i] * cos(a2[i]);
  
    line(0, 0, x1, y1);
    line(x1, y1, x2, y2);
  
    a1_v[i] += a1_a;
    a2_v[i] -= a2_a;
    a1[i] += a1_v[i];
    a2[i] -= a2_v[i];
  
    canvas.beginDraw();
    canvas.translate(cx, cy);
    canvas.stroke(pendulumColor);
    canvas.strokeWeight(1);
    if (frameCount > 1) {
      canvas.line(px2[i], py2[i], x2, y2);
    }
    canvas.endDraw();
  
    px2[i] = x2;
    py2[i] = y2;
    
    resetMatrix(); // Reset transformation for the next pendulum
  }
}
