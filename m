Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667E8465C0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFNR24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:28:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38052 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfFNR2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:28:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so3375349qtl.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 10:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+43Y+rgPNVQRQmI/h6SkgRjixnzUhCABvM0NCx8CzA=;
        b=EhG0zokhNvNq9kFEZ+EPx9gMjcKl0YOdzbh5iflgkUR6cFztPH9NFhwDqFVkvZ7kI4
         TI00bi4W+ZCIKVG3KlJjLQssNbb9IRJX+LnqdYOA/kgOmpsL4r7bfyeWE+LW0Az7lWlq
         6AXSF/tz1sNlHgSHyEDNMBRRzs99whOR47AtlySPWxXHETiZ4LTK4b6yfoM98l49VH1B
         YtIuGfXaOC/khFDvmzexth9pdfXl7NbyIR0OPjUZERnV3MNO7ILQ//1xbAwc9kb3/3x5
         Qsa2WQLAM3hRelw9uBEJk5n8LCLGeVRodL3guueAirzHi1nubkMbuIwPrPtIMT8HbW8a
         Ez5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+43Y+rgPNVQRQmI/h6SkgRjixnzUhCABvM0NCx8CzA=;
        b=jvCBaeFQTdEEQgwH/4BuzjXWs/a7nYdPdiTZJpLQ1p78Qi2c5jaumD2lH2+TtFNfu0
         v//gSKDpFAajCyc+KbYu9Ptbq1GQSglfSwI0SLMkraHCQGZyXNZuJrFLsCdKkyfUKEPj
         MXoHyqSm2ENxkqU2tHJsEYlnT8lU2yJCYqaNq2gWtrU7qIf7t35ON77aYkb5zvJRtBrl
         9ronYhPqUDEgFEfnRcFtDwAPQeaXYXgCuy7SoHsq9tN1Qirm/EKcE+RMv3Pn1hxgmrlt
         MTJ7to1y7MsT/2CIq6jtEkeuFUDK4ExcCZ6EgMyBbMJrrMckyHA9agXuxlwr7oWX0gY8
         Lydg==
X-Gm-Message-State: APjAAAX3lglfo1D39lU8NT4KTSYXDhcWbV9QCDWj+gQZbJVUVFt8h5OJ
        fZ+v0G9Z+hTLaQwTVakJBaEpgg==
X-Google-Smtp-Source: APXvYqwlauM6af4P4uZp4c98fQCkwII2Qy7TW9hESnMjgEc7MICxaK8jjd83P8mb/y4b4IXGoInouQ==
X-Received: by 2002:ac8:2cba:: with SMTP id 55mr65001352qtw.260.1560533334000;
        Fri, 14 Jun 2019 10:28:54 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f68sm1883045qtb.83.2019.06.14.10.28.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 10:28:53 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH iproute2-next] tc: q_netem: JSON-ify the output
Date:   Fri, 14 Jun 2019 10:28:17 -0700
Message-Id: <20190614172817.14817-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add JSON output support to q_netem.

The normal output is untouched.

In JSON output always use seconds as the base of time units,
and non-percentage numbers (0.01 instead of 1%). Try to always
report the fields, even if they are zero.
All this should make the output more machine-friendly.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tc/q_netem.c | 174 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 107 insertions(+), 67 deletions(-)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 59fb8efae399..aaaaee49de25 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -58,6 +58,35 @@ static void explain1(const char *arg)
  */
 #define MAX_DIST	(16*1024)
 
+/* Percent print prints normally in percentage points, but for JSON prints
+ * an absolute value (1% vs 0.01).
+ */
+#define __PRINT_PERCENT(label_json, label_fp, per)			\
+	({								\
+		print_float(PRINT_FP, NULL, label_fp " %g%%",		\
+			    (100. * (per)) / UINT32_MAX);		\
+		print_float(PRINT_JSON, label_json, NULL,		\
+			    (1. * (per)) / UINT32_MAX);			\
+	})
+#define PRINT_PERCENT(label, per) __PRINT_PERCENT(label, " " label, (per))
+
+/* Time print prints normally with varying units, but for JSON prints
+ * in seconds (1ms vs 0.001).
+ */
+#define __PRINT_TIME64(label_json, label_fp, val)			\
+	({								\
+		SPRINT_BUF(b1);						\
+		print_string(PRINT_FP, NULL, label_fp " %s",		\
+			     sprint_time64((val), b1));			\
+		print_float(PRINT_JSON, label_json, NULL, (val) /	\
+			    1000000000.);				\
+	})
+#define PRINT_TIME64(label, val) __PRINT_TIME64(label, " " label, (val))
+
+/* Print values only if they are non-zero */
+#define PRINT_INT_OPT(label, val)		\
+	print_int(PRINT_ANY, label, (val) ? " " label " %d" : "", (val))
+
 /* scaled value used to percent of maximum. */
 static void set_percent(__u32 *percent, double per)
 {
@@ -75,15 +104,14 @@ static int get_percent(__u32 *percent, const char *str)
 	return 0;
 }
 
-static void print_percent(char *buf, int len, __u32 per)
-{
-	snprintf(buf, len, "%g%%", (100. * per) / UINT32_MAX);
-}
-
-static char *sprint_percent(__u32 per, char *buf)
+static void print_corr(bool present, __u32 value)
 {
-	print_percent(buf, SPRINT_BSIZE-1, per);
-	return buf;
+	if (!is_json_context()) {
+		if (present)
+			__PRINT_PERCENT("", "", value);
+	} else {
+		PRINT_PERCENT("correlation", value);
+	}
 }
 
 /*
@@ -687,97 +715,109 @@ static int netem_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		}
 	}
 
-	fprintf(f, "limit %d", qopt.limit);
+	print_uint(PRINT_ANY, "limit", "limit %d", qopt.limit);
 
 	if (qopt.latency) {
-		fprintf(f, " delay %s", sprint_ticks(qopt.latency, b1));
-
-		if (qopt.jitter) {
-			fprintf(f, "  %s", sprint_ticks(qopt.jitter, b1));
-			if (cor && cor->delay_corr)
-				fprintf(f, " %s", sprint_percent(cor->delay_corr, b1));
+		open_json_object("delay");
+		if (!is_json_context()) {
+			print_string(PRINT_FP, NULL, " delay %s",
+				     sprint_ticks(qopt.latency, b1));
+
+			if (qopt.jitter)
+				print_string(PRINT_FP, NULL, "  %s",
+					     sprint_ticks(qopt.jitter, b1));
+		} else {
+			print_float(PRINT_JSON, "delay", NULL,
+				    tc_core_tick2time(qopt.latency) /
+				    1000000.);
+			print_float(PRINT_JSON, "jitter", NULL,
+				    tc_core_tick2time(qopt.jitter) /
+				    1000000.);
 		}
+		print_corr(qopt.jitter && cor && cor->delay_corr,
+			   cor ? cor->delay_corr : 0);
+		close_json_object();
 	}
 
 	if (qopt.loss) {
-		fprintf(f, " loss %s", sprint_percent(qopt.loss, b1));
-		if (cor && cor->loss_corr)
-			fprintf(f, " %s", sprint_percent(cor->loss_corr, b1));
+		open_json_object("loss-random");
+		PRINT_PERCENT("loss", qopt.loss);
+		print_corr(cor && cor->loss_corr, cor ? cor->loss_corr : 0);
+		close_json_object();
 	}
 
 	if (gimodel) {
-		fprintf(f, " loss state p13 %s", sprint_percent(gimodel->p13, b1));
-		fprintf(f, " p31 %s", sprint_percent(gimodel->p31, b1));
-		fprintf(f, " p32 %s", sprint_percent(gimodel->p32, b1));
-		fprintf(f, " p23 %s", sprint_percent(gimodel->p23, b1));
-		fprintf(f, " p14 %s", sprint_percent(gimodel->p14, b1));
+		open_json_object("loss-state");
+		__PRINT_PERCENT("p13", " loss state p13", gimodel->p13);
+		PRINT_PERCENT("p31", gimodel->p31);
+		PRINT_PERCENT("p32", gimodel->p32);
+		PRINT_PERCENT("p23", gimodel->p23);
+		PRINT_PERCENT("p14", gimodel->p14);
+		close_json_object();
 	}
 
 	if (gemodel) {
-		fprintf(f, " loss gemodel p %s",
-			sprint_percent(gemodel->p, b1));
-		fprintf(f, " r %s", sprint_percent(gemodel->r, b1));
-		fprintf(f, " 1-h %s", sprint_percent(UINT32_MAX -
-						     gemodel->h, b1));
-		fprintf(f, " 1-k %s", sprint_percent(gemodel->k1, b1));
+		open_json_object("loss-gemodel");
+		__PRINT_PERCENT("p", " loss gemodel p", gemodel->p);
+		PRINT_PERCENT("r", gemodel->r);
+		PRINT_PERCENT("1-h", UINT32_MAX - gemodel->h);
+		PRINT_PERCENT("1-k", gemodel->k1);
+		close_json_object();
 	}
 
 	if (qopt.duplicate) {
-		fprintf(f, " duplicate %s",
-			sprint_percent(qopt.duplicate, b1));
-		if (cor && cor->dup_corr)
-			fprintf(f, " %s", sprint_percent(cor->dup_corr, b1));
+		open_json_object("duplicate");
+		PRINT_PERCENT("duplicate", qopt.duplicate);
+		print_corr(cor && cor->dup_corr, cor ? cor->dup_corr : 0);
+		close_json_object();
 	}
 
 	if (reorder && reorder->probability) {
-		fprintf(f, " reorder %s",
-			sprint_percent(reorder->probability, b1));
-		if (reorder->correlation)
-			fprintf(f, " %s",
-				sprint_percent(reorder->correlation, b1));
+		open_json_object("reorder");
+		PRINT_PERCENT("reorder", reorder->probability);
+		print_corr(reorder->correlation, reorder->correlation);
+		close_json_object();
 	}
 
 	if (corrupt && corrupt->probability) {
-		fprintf(f, " corrupt %s",
-			sprint_percent(corrupt->probability, b1));
-		if (corrupt->correlation)
-			fprintf(f, " %s",
-				sprint_percent(corrupt->correlation, b1));
+		open_json_object("corrupt");
+		PRINT_PERCENT("corrupt", corrupt->probability);
+		print_corr(corrupt->correlation, corrupt->correlation);
+		close_json_object();
 	}
 
 	if (rate && rate->rate) {
-		if (rate64)
-			fprintf(f, " rate %s", sprint_rate(rate64, b1));
-		else
-			fprintf(f, " rate %s", sprint_rate(rate->rate, b1));
-		if (rate->packet_overhead)
-			fprintf(f, " packetoverhead %d", rate->packet_overhead);
-		if (rate->cell_size)
-			fprintf(f, " cellsize %u", rate->cell_size);
-		if (rate->cell_overhead)
-			fprintf(f, " celloverhead %d", rate->cell_overhead);
+		open_json_object("rate");
+		rate64 = rate64 ? : rate->rate;
+		print_string(PRINT_FP, NULL, " rate %s",
+			     sprint_rate(rate64, b1));
+		print_lluint(PRINT_JSON, "rate", NULL, rate64);
+		PRINT_INT_OPT("packetoverhead", rate->packet_overhead);
+		print_uint(PRINT_ANY, "cellsize",
+			   rate->cell_size ? " cellsize %u" : "",
+			   rate->cell_size);
+		PRINT_INT_OPT("celloverhead", rate->cell_overhead);
+		close_json_object();
 	}
 
 	if (slot) {
+		open_json_object("slot");
 		if (slot->dist_jitter > 0) {
-		    fprintf(f, " slot distribution %s", sprint_time64(slot->dist_delay, b1));
-		    fprintf(f, " %s", sprint_time64(slot->dist_jitter, b1));
+			__PRINT_TIME64("distribution", " slot distribution",
+				       slot->dist_delay);
+			__PRINT_TIME64("jitter", "", slot->dist_jitter);
 		} else {
-		    fprintf(f, " slot %s", sprint_time64(slot->min_delay, b1));
-		    fprintf(f, " %s", sprint_time64(slot->max_delay, b1));
+			__PRINT_TIME64("min-delay", " slot", slot->min_delay);
+			__PRINT_TIME64("max-delay", "", slot->max_delay);
 		}
-		if (slot->max_packets)
-			fprintf(f, " packets %d", slot->max_packets);
-		if (slot->max_bytes)
-			fprintf(f, " bytes %d", slot->max_bytes);
+		PRINT_INT_OPT("packets", slot->max_packets);
+		PRINT_INT_OPT("bytes", slot->max_bytes);
+		close_json_object();
 	}
 
-	if (ecn)
-		fprintf(f, " ecn ");
-
-	if (qopt.gap)
-		fprintf(f, " gap %lu", (unsigned long)qopt.gap);
-
+	print_bool(PRINT_ANY, "ecn", ecn ? " ecn " : "", ecn);
+	print_luint(PRINT_ANY, "gap", qopt.gap ? " gap %lu" : "",
+		    (unsigned long)qopt.gap);
 
 	return 0;
 }
-- 
2.21.0

