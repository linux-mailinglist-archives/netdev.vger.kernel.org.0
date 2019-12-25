Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33A12A903
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfLYTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43474 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so11890324pga.10
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HCvDnd7fT6xG8rVYm75P2CW0sx9MupXZHTgbQNylMfo=;
        b=MZxAKKE5QeQJPV4v+EBP+m3JnoCQL4C6jgU8XBJ1SnroVaRUSkS6H0YHPtAs/p4ZQx
         X0ZY9X65It3WtdMBlyCWHCgJB/QUdH5xRUcdiLRPWg5JT3vVoTcI76yBuZ40gw7lrcAV
         0xpgoknTKswPSZDadrj5QL7yRIMfzNf05bilzMEq56hHyt811SoN5meCzgQyg/OwHyBl
         sF8ih56/u/BKUUwWTLklT2Xj7uaU1nLywdh0mdayV6ZRnt/7lqA0VfBktIfp4ngv1BvU
         ecKz5tDQIbOu8jJYJ0e/Jl2wIMbTLzhtd6xnSwnub5K/qp0Ubo0tMO/m/b+2tW1IOAmh
         St6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HCvDnd7fT6xG8rVYm75P2CW0sx9MupXZHTgbQNylMfo=;
        b=TjwdZQoxro5hpNJsOy1Fxjm0QqR7uBjUR14r29CTocPrcCUcYWjfZp8MvziVk7EQZG
         s1zLHSSlMySufxwwG3nCQ5dYs53igw1CgFMzLZRnr4HqTNS4dEbjUsFlqXQXTFsUMTYl
         7f0QnlCu6l1Bab2cfwIVdYo93/4i5iHeYakit5EE+iOOf37/tKrpvvzV4tzJf95VPj1Q
         synGKKp2h5T0PR1Qixh1o6ZgeDeik5U3FzDfh3cTWBgkvXlgXvhBVfEyGLzk3F/mfGBn
         K2+kFVr6DbAQ6XXzoTfzD093QKgi12n3bq7BNqHbV9Hrc0wpOe5jVTZeVldQtLyYybCi
         2yKA==
X-Gm-Message-State: APjAAAVzFygwj6w9jdQGnkOMLru8h3s3AvpNg6ImuNlP5CCk7FZojTOo
        FRKxAVevNsx2DeupPY5oW8V85YtL6gg=
X-Google-Smtp-Source: APXvYqzzt3y0i+OlA5dIq2OuxF/Wuz9sAnGVQlrDOkffuC5qjE03ViVz02E++wYVee1C2mOziJUClQ==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr46288438pfi.10.1577300692028;
        Wed, 25 Dec 2019 11:04:52 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:51 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 09/10] tc: tbf: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:17 +0530
Message-Id: <20191225190418.8806-10-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the TBF Qdisc.
Also, fix the style of the statement that's calculating "latency" in
tbf_print_opt().

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_tbf.c | 68 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index 57a9736c..5135b1d6 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -264,7 +264,7 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct tc_tbf_qopt *qopt;
 	unsigned int linklayer;
 	double buffer, mtu;
-	double latency;
+	double latency, lat2;
 	__u64 rate64 = 0, prate64 = 0;
 
 	SPRINT_BUF(b1);
@@ -286,53 +286,79 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_TBF_RATE64] &&
 	    RTA_PAYLOAD(tb[TCA_TBF_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_TBF_RATE64]);
-	fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+	print_u64(PRINT_JSON, "rate", NULL, rate64);
+	print_string(PRINT_FP, NULL, "rate %s ", sprint_rate(rate64, b1));
 	buffer = tc_calc_xmitsize(rate64, qopt->buffer);
 	if (show_details) {
-		fprintf(f, "burst %s/%u mpu %s ", sprint_size(buffer, b1),
-			1<<qopt->rate.cell_log, sprint_size(qopt->rate.mpu, b2));
+		sprintf(b1, "%s/%u",  sprint_size(buffer, b2),
+			1 << qopt->rate.cell_log);
+		print_string(PRINT_ANY, "burst", "burst %s ", b1);
+		print_uint(PRINT_JSON, "mpu", NULL, qopt->rate.mpu);
+		print_string(PRINT_FP, NULL, "mpu %s ",
+			     sprint_size(qopt->rate.mpu, b1));
 	} else {
-		fprintf(f, "burst %s ", sprint_size(buffer, b1));
+		print_u64(PRINT_JSON, "burst", NULL, buffer);
+		print_string(PRINT_FP, NULL, "burst %s ",
+			     sprint_size(buffer, b1));
 	}
 	if (show_raw)
-		fprintf(f, "[%08x] ", qopt->buffer);
+		print_hex(PRINT_ANY, "burst_raw", "[%08x] ", qopt->buffer);
 	prate64 = qopt->peakrate.rate;
 	if (tb[TCA_TBF_PRATE64] &&
 	    RTA_PAYLOAD(tb[TCA_TBF_PRATE64]) >= sizeof(prate64))
 		prate64 = rta_getattr_u64(tb[TCA_TBF_PRATE64]);
 	if (prate64) {
-		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
+		print_u64(PRINT_JSON, "peakrate", NULL, prate64);
+		print_string(PRINT_FP, NULL, "peakrate %s ",
+			     sprint_rate(prate64, b1));
 		if (qopt->mtu || qopt->peakrate.mpu) {
 			mtu = tc_calc_xmitsize(prate64, qopt->mtu);
 			if (show_details) {
-				fprintf(f, "mtu %s/%u mpu %s ", sprint_size(mtu, b1),
-					1<<qopt->peakrate.cell_log, sprint_size(qopt->peakrate.mpu, b2));
+				sprintf(b1, "%s/%u",  sprint_size(mtu, b2),
+					1 << qopt->peakrate.cell_log);
+				print_string(PRINT_ANY, "mtu", "mtu %s ", b1);
+				print_uint(PRINT_JSON, "mpu", NULL,
+					   qopt->peakrate.mpu);
+				print_string(PRINT_FP, NULL, "mpu %s ",
+					     sprint_size(qopt->peakrate.mpu,
+							 b1));
 			} else {
-				fprintf(f, "minburst %s ", sprint_size(mtu, b1));
+				print_u64(PRINT_JSON, "minburst", NULL, mtu);
+				print_string(PRINT_FP, NULL, "minburst %s ",
+					     sprint_size(mtu, b1));
 			}
 			if (show_raw)
-				fprintf(f, "[%08x] ", qopt->mtu);
+				print_hex(PRINT_ANY, "mtu_raw", "[%08x] ",
+					    qopt->mtu);
 		}
 	}
 
-	latency = TIME_UNITS_PER_SEC*(qopt->limit/(double)rate64) - tc_core_tick2time(qopt->buffer);
+	latency = TIME_UNITS_PER_SEC * (qopt->limit / (double)rate64) -
+		  tc_core_tick2time(qopt->buffer);
 	if (prate64) {
-		double lat2 = TIME_UNITS_PER_SEC*(qopt->limit/(double)prate64) - tc_core_tick2time(qopt->mtu);
+		lat2 = TIME_UNITS_PER_SEC * (qopt->limit / (double)prate64) -
+		       tc_core_tick2time(qopt->mtu);
 
 		if (lat2 > latency)
 			latency = lat2;
 	}
-	if (latency >= 0.0)
-		fprintf(f, "lat %s ", sprint_time(latency, b1));
-	if (show_raw || latency < 0.0)
-		fprintf(f, "limit %s ", sprint_size(qopt->limit, b1));
-
-	if (qopt->rate.overhead) {
-		fprintf(f, "overhead %d", qopt->rate.overhead);
+	if (latency >= 0.0) {
+		print_u64(PRINT_JSON, "lat", NULL, latency);
+		print_string(PRINT_FP, NULL, "lat %s ",
+			     sprint_time(latency, b1));
+	}
+	if (show_raw || latency < 0.0) {
+		print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
+		print_string(PRINT_FP, NULL, "limit %s ",
+			     sprint_size(qopt->limit, b1));
 	}
+	if (qopt->rate.overhead)
+		print_int(PRINT_ANY, "overhead", "overhead %d ",
+			  qopt->rate.overhead);
 	linklayer = (qopt->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
-		fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
+		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
+			     sprint_linklayer(linklayer, b3));
 
 	return 0;
 }
-- 
2.17.1

