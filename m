Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561C54966F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 02:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFRAti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 20:49:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44865 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRAth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 20:49:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so13178359qtk.11
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 17:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NklABBVeQCRtY3cOSAQrGRPFluTSfTpHlj5PfVu49vc=;
        b=talfipuQkVmOG2BQt/3OgL89ZoMivZ7IIuLFxEsq1w4wrvUsputDorzBFHhot1uSyE
         CWrgJxaLkLw+HCITePat9bakR+28MLtL5teZba7myn2vZ/ilvEASxdN/pIV7ydkDrLhC
         fXLZGcWBdI98rvKeyYjHtkRHss8pqzjipBqd/tOIf1Ydw3JgcofKK0d02i6IjDJAajzF
         NFO3N78qPGAmyTuO5mUWTY8J18valzQ9LKXxH/VIhyjwSMYJ6/91D7bgaqiOJ7T+DN+9
         tiZ39zNuSmFsYp3Al60Ci/2ILjvAcsPe6/Yz9QMS5xIPYgfRBfVSIaN8N9xvO7NR7iOQ
         +oew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NklABBVeQCRtY3cOSAQrGRPFluTSfTpHlj5PfVu49vc=;
        b=t3B9/gdPNZ+Zagsw1ysAyEszC7hzo7D2NHHqAtwkDf6I7fNB7iWk+0pGl8rDR8FCN4
         3xeWLIcI1umbtWfoawUaqoEteZMFRUvV6uEqbtSvqpZpFs9R+gA4JtX4LmlxiN4+KJRG
         jx9hFZNh4nT+Cp+YZJ1PMsGDkhcgksmUU2Dn5nUyHbyfhEJf9LeteUnROKo0VA7M7Qqy
         lrxL71Ddfl392/SF8NiZSnZYQ47y34xYkkaYCvHSVHsM8i0UVavCOJpK+Um9OJqJSI46
         LRGgtJ1+B7T4eytNA+GWmyx9kW7XgvLr0nL63weV+3BjhoRq2PYa3mMXATsNjatH+Ujh
         pyYg==
X-Gm-Message-State: APjAAAUU5bVTe53Qe8PBtYTQXzdi/s0PeZDHh5cgC+TIsypyWZ3mKA8N
        2ErTDJc4KuzTTEN+JfNnhFos2g==
X-Google-Smtp-Source: APXvYqx1B4dfyhfg2Vfag4ON46jZtVTPKtHJ7MG4n6qVzgXVKQ5gnbq2C/7A419v1bhdfWHMEBa76w==
X-Received: by 2002:ac8:2f96:: with SMTP id l22mr48452133qta.188.1560818976406;
        Mon, 17 Jun 2019 17:49:36 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u4sm6948229qkb.16.2019.06.17.17.49.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 17:49:35 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH iproute2-next v2] tc: q_netem: JSON-ify the output
Date:   Mon, 17 Jun 2019 17:49:29 -0700
Message-Id: <20190618004929.11160-1-jakub.kicinski@netronome.com>
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

v2: less macroes

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tc/q_netem.c | 182 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 115 insertions(+), 67 deletions(-)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 59fb8efae399..b85938f4941b 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -58,6 +58,43 @@ static void explain1(const char *arg)
  */
 #define MAX_DIST	(16*1024)
 
+/* Print values only if they are non-zero */
+static void __print_int_opt(const char *label_json, const char *label_fp,
+			    int val)
+{
+	print_int(PRINT_ANY, label_json, val ? label_fp : "", val);
+}
+#define PRINT_INT_OPT(label, val)			\
+	__print_int_opt(label, " " label " %d", (val))
+
+/* Time print prints normally with varying units, but for JSON prints
+ * in seconds (1ms vs 0.001).
+ */
+static void __print_time64(const char *label_json, const char *label_fp,
+			   __u64 val)
+{
+	SPRINT_BUF(b1);
+
+	print_string(PRINT_FP, NULL, label_fp, sprint_time64(val, b1));
+	print_float(PRINT_JSON, label_json, NULL, val / 1000000000.);
+}
+#define __PRINT_TIME64(label_json, label_fp, val)	\
+	__print_time64(label_json, label_fp " %s", (val))
+#define PRINT_TIME64(label, val) __PRINT_TIME64(label, " " label, (val))
+
+/* Percent print prints normally in percentage points, but for JSON prints
+ * an absolute value (1% vs 0.01).
+ */
+static void __print_percent(const char *label_json, const char *label_fp,
+			    __u32 per)
+{
+	print_float(PRINT_FP, NULL, label_fp, (100. * per) / UINT32_MAX);
+	print_float(PRINT_JSON, label_json, NULL, (1. * per) / UINT32_MAX);
+}
+#define __PRINT_PERCENT(label_json, label_fp, per)		\
+	__print_percent(label_json, label_fp " %g%%", (per))
+#define PRINT_PERCENT(label, per) __PRINT_PERCENT(label, " " label, (per))
+
 /* scaled value used to percent of maximum. */
 static void set_percent(__u32 *percent, double per)
 {
@@ -75,15 +112,14 @@ static int get_percent(__u32 *percent, const char *str)
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
@@ -687,97 +723,109 @@ static int netem_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
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

