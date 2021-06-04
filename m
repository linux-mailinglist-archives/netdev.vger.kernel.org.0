Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2140639BC78
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhFDQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:03:46 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39714 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFDQDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:03:45 -0400
Received: by mail-pl1-f170.google.com with SMTP id q16so4871561pls.6
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xx1Z3AA+ArGBlKxMGhFW4xdB9t5fochT0OrB1eX69XQ=;
        b=UWgXEe584ebc7HqUm2mFxcEp4fbJqpI8VbRf7fVPzyNGPTgdhk9/QHStW9o7ft5691
         p6uKgpho+jyGQJOCPyvKFg//RuUrAgy9qKnzMUso6aysCceG43RHUbPXrO9T2bxWSnZb
         XUBjzti4lKAoDtqQL+GPG6QwmC3OYq6+Hwb3ZXqW9ANsfz890z3G2vU3FN05naZbQeYQ
         V/UT0wTFLdDFNozKCeKaYYgCsNk25SMO5LWMaXEZAQmFe+VBh5nClCchr6ZsC7gmtfcW
         N6jBeniRjhRfJZkd8wD3a8Rtg2lcwAMwOHt6lWxzMYpRDbwao1ZgGp0mNN1kLhKziDmQ
         h7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xx1Z3AA+ArGBlKxMGhFW4xdB9t5fochT0OrB1eX69XQ=;
        b=LnCyfnrr+NpzaNSTX4XrubCKsMRgoNuw0cqpcFS82/3tnVUinNjZI9eXYdqYWhPtlY
         KERM1TFI8MtVTennwGYTDiK4xZ1YCf2q44M3DVKiM9Le1lZYI9CT2IwxsAHV1yIfYb0s
         3V+mSnQ6Rtde8JuBbmj7o0t8Winl5rF1/+sEBEVXiF9A8a8BI3yu+ygAc1jLt2Jq6wFV
         wLukNgDY5N9O/z7TLTOlJddEHNMGk0hHGFKeoNNuT/ZnH7GTNYwq7U28/8PwTUDLqWGK
         Lq0W29HCdGVhp5bT943AVcn+7My4HOhNgLz5lYiABxFbfTBnGdUf9Q2K+WeUwXTr+lv0
         Ynlg==
X-Gm-Message-State: AOAM533MoWJho1PPx4ZF1hZZdEl6GgbIuyRrMkt40vHOXfUdVeZVqQYp
        J56J/qZCR1SkQIsNEPm1DU8=
X-Google-Smtp-Source: ABdhPJxbzD/dXGXJhQuMItTjWeHUNe7oUwgzWjFYxB2e6E46VtzKAErul2I09TMPTI9wDydpIVPE2g==
X-Received: by 2002:a17:90a:8582:: with SMTP id m2mr1905171pjn.146.1622822445988;
        Fri, 04 Jun 2021 09:00:45 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fa9c:6f03:fb6b:28ef])
        by smtp.gmail.com with ESMTPSA id t12sm5017803pjw.57.2021.06.04.09.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 09:00:45 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH iproute2] tc: fq: add horizon attributes
Date:   Fri,  4 Jun 2021 09:00:41 -0700
Message-Id: <20210604160041.3877465-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit 39d010504e6b ("net_sched: sch_fq: add horizon attribute")
added kernel support for horizon attributes in linux-5.8

$ tc -s -d qd sh dev wlp2s0
qdisc fq 8006: root refcnt 2 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon 10s horizon_drop
 Sent 690924 bytes 3234 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
  flows 112 (inactive 104 throttled 0)
  gc 0 highprio 0 throttled 2 latency 8.25us

$ tc qd change dev wlp2s0 root fq horizon 500ms horizon_cap

$ tc -s -d qd sh dev wlp2s0
qdisc fq 8006: root refcnt 2 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon 500ms horizon_cap
 Sent 831220 bytes 3844 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
  flows 122 (inactive 120 throttled 0)
  gc 0 highprio 0 throttled 2 latency 8.25us

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tc/q_fq.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/tc/q_fq.c b/tc/q_fq.c
index cff21975b89789321af76579db119bcad8508a96..8dbfc41a1e05b46cda6ccaa3e36c43de805ba169 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -58,7 +58,9 @@ static void explain(void)
 		"		[ low_rate_threshold RATE ]\n"
 		"		[ orphan_mask MASK]\n"
 		"		[ timer_slack TIME]\n"
-		"		[ ce_threshold TIME ]\n");
+		"		[ ce_threshold TIME ]\n"
+		"		[ horizon TIME ]\n"
+		"		[ horizon_{cap|drop} ]\n");
 }
 
 static unsigned int ilog2(unsigned int val)
@@ -88,6 +90,8 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	unsigned int orphan_mask;
 	unsigned int ce_threshold;
 	unsigned int timer_slack;
+	unsigned int horizon;
+	__u8 horizon_drop = 255;
 	bool set_plimit = false;
 	bool set_flow_plimit = false;
 	bool set_quantum = false;
@@ -99,6 +103,7 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	bool set_low_rate_threshold = false;
 	bool set_ce_threshold = false;
 	bool set_timer_slack = false;
+	bool set_horizon = false;
 	int pacing = -1;
 	struct rtattr *tail;
 
@@ -163,6 +168,17 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				return -1;
 			}
 			set_timer_slack = true;
+		} else if (strcmp(*argv, "horizon_drop") == 0) {
+			horizon_drop = 1;
+		} else if (strcmp(*argv, "horizon_cap") == 0) {
+			horizon_drop = 0;
+		} else if (strcmp(*argv, "horizon") == 0) {
+			NEXT_ARG();
+			if (get_time(&horizon, *argv)) {
+				fprintf(stderr, "Illegal \"horizon\"\n");
+				return -1;
+			}
+			set_horizon = true;
 		} else if (strcmp(*argv, "defrate") == 0) {
 			NEXT_ARG();
 			if (strchr(*argv, '%')) {
@@ -260,6 +276,12 @@ static int fq_parse_opt(struct qdisc_util *qu, int argc, char **argv,
     if (set_timer_slack)
 		addattr_l(n, 1024, TCA_FQ_TIMER_SLACK,
 			  &timer_slack, sizeof(timer_slack));
+    if (set_horizon)
+		addattr_l(n, 1024, TCA_FQ_HORIZON,
+			  &horizon, sizeof(horizon));
+    if (horizon_drop != 255)
+		addattr_l(n, 1024, TCA_FQ_HORIZON_DROP,
+			  &horizon_drop, sizeof(horizon_drop));
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -275,6 +297,8 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	unsigned int orphan_mask;
 	unsigned int ce_threshold;
 	unsigned int timer_slack;
+	unsigned int horizon;
+	__u8 horizon_drop;
 
 	SPRINT_BUF(b1);
 
@@ -374,6 +398,23 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			     sprint_time64(timer_slack, b1));
 	}
 
+	if (tb[TCA_FQ_HORIZON] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_HORIZON]) >= sizeof(__u32)) {
+		horizon = rta_getattr_u32(tb[TCA_FQ_HORIZON]);
+		print_uint(PRINT_JSON, "horizon", NULL, horizon);
+		print_string(PRINT_FP, NULL, "horizon %s ",
+			     sprint_time(horizon, b1));
+	}
+
+	if (tb[TCA_FQ_HORIZON_DROP] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_HORIZON_DROP]) >= sizeof(__u8)) {
+		horizon_drop = rta_getattr_u8(tb[TCA_FQ_HORIZON_DROP]);
+		if (!horizon_drop)
+			print_null(PRINT_ANY, "horizon_cap", "horizon_cap ", NULL);
+		else
+			print_null(PRINT_ANY, "horizon_drop", "horizon_drop ", NULL);
+	}
+
 	return 0;
 }
 
@@ -430,12 +471,25 @@ static int fq_print_xstats(struct qdisc_util *qu, FILE *f,
 		print_lluint(PRINT_ANY, "flows_plimit", " flows_plimit %llu",
 			     st->flows_plimit);
 
-	if (st->pkts_too_long || st->allocation_errors) {
+	if (st->pkts_too_long || st->allocation_errors ||
+	    st->horizon_drops || st->horizon_caps) {
 		print_nl();
-		print_lluint(PRINT_ANY, "pkts_too_long",
-			     "  pkts_too_long %llu", st->pkts_too_long);
-		print_lluint(PRINT_ANY, "alloc_errors", " alloc_errors %llu",
-			     st->allocation_errors);
+		if (st->pkts_too_long)
+			print_lluint(PRINT_ANY, "pkts_too_long",
+				     " pkts_too_long %llu",
+				     st->pkts_too_long);
+		if (st->allocation_errors)
+			print_lluint(PRINT_ANY, "alloc_errors",
+				     " alloc_errors %llu",
+				     st->allocation_errors);
+		if (st->horizon_drops)
+			print_lluint(PRINT_ANY, "horizon_drops",
+				     " horizon_drops %llu",
+				     st->horizon_drops);
+		if (st->horizon_caps)
+			print_lluint(PRINT_ANY, "horizon_caps",
+				     "  horizon_caps %llu",
+				     st->horizon_caps);
 	}
 
 	return 0;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

