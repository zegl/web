resource "aws_s3_bucket" "kube_score" {
  bucket = "kube-score.com"
  acl    = "private"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket        = "${aws_s3_bucket.kube_score.bucket}"
  key           = "index.html"
  source        = "../frontend/index.html"
  etag          = "${filemd5("../frontend/index.html")}"
  content_type  = "text/html"
  cache_control = "max-age=300"
}

resource "aws_s3_bucket_policy" "kube_score" {
  bucket = "${aws_s3_bucket.kube_score.id}"

  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EPWSTV8SWLQGI"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::kube-score.com/*"
        }
    ]
}
POLICY
}