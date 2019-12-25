Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20C812A8FE
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLYTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37007 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so11905508pga.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J7CQlcXpOUjeb/5cC8Zez9CmZ6l4f1wFJfw0kZ5ngE4=;
        b=hOnSdPGhahgH0Bm8SJeM3zJJqK6X4rHMH7Q2CRT8d6Nf0+f72zjqm2HMFRG39gzlo4
         DmEU6B2O8F0WT3feQj3MZRNdmTjBuu0zGUtew1TvfBk9+BEnSrPWk//IHUmY2lUcsOMa
         vXrX5JY1GEbksgIypaOqgI2HbN96PucSju7ajgBiYFANX8BeOAISPfkoY6ze5jcqVzfQ
         8tQpeWq0AvqtvgkEXuhSUYKIFH+72+f4jsRf8DXlUm3m05yP9a087vLZwMyQFvu5bBPM
         S9B2D4M7SPIU5AzCBhgEW5TnZcktuQJUnoHQWFDArekWmlxqgHcPPMx+JVF+bvyusAz8
         0L1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J7CQlcXpOUjeb/5cC8Zez9CmZ6l4f1wFJfw0kZ5ngE4=;
        b=TKJDtqj7jUG8bp9yQd9E25v0z++YHKMsDXwkQXOvSmbJY1+ydPaLs2e5+s5l2IHi4e
         rFTgxz/zE5zxfg0fuwhKMGFGzizIh7u2eghdPd+3tCBd5vF5gIT5tu0qQ4NRD2d5Lp6E
         CT1IW1iC30nwIq8NJwU8y4TbsFajsevnAIjLZKY/xyyp28xXIuZLJ+76aQ0WBBAeepg4
         0KTQ3kYAXf7OamrgsEKFchITJ2C1WUoUKDu+ZZBM8U0o8G+2D7T6L+H6akEZurCMORzA
         gIEAMCgb6eI7aCOhrjzezCFczHrIQXDnQ6ouC+82EaGGx9Dwulnl+dea7g7ib8TZ2UKJ
         agyQ==
X-Gm-Message-State: APjAAAV4FH9pwY7TL2T064li/J1L86W8IMl/IXZkOYTJDdeZu83YxgdK
        TtKvvdemog+hcr/0Pc/69n6a7jZQ+KE=
X-Google-Smtp-Source: APXvYqwFu3B4T7d0/Ij+yjmzL6DG63srm1G0wHDfOhbABqpprA75Q2M534VeVm+eKHoiUhrqgUJXjA==
X-Received: by 2002:a63:7d8:: with SMTP id 207mr44700372pgh.154.1577300676426;
        Wed, 25 Dec 2019 11:04:36 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:35 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH iproute2-next 04/10] tc: fq: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:12 +0530
Message-Id: <20191225190418.8806-5-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the FQ Qdisc.
Use the "KEY VALUE" format for oneline output of statistics instead of
"VALUE KEY", and remove unnecessary commas from the output.
Use sprint_size() to print size values in fq_print_opt().
Use sprint_time64() to print time values in fq_print_xstats().
Also, update the man page to reflect the changes in the output format.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 man/man8/tc-fq.8 |  14 +++---
 tc/q_fq.c        | 108 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 83 insertions(+), 39 deletions(-)

diff --git a/man/man8/tc-fq.8 b/man/man8/tc-fq.8
index 1febe62b..27385aae 100644
--- a/man/man8/tc-fq.8
+++ b/man/man8/tc-fq.8
@@ -90,15 +90,15 @@ Experienced. This is useful for DCTCP-style congestion control algorithms that
 require marking at very shallow queueing thresholds.
 
 .SH EXAMPLES
-#tc qdisc add dev eth0 root est 1sec 4sec fq ce_threshold 4ms
+#tc qdisc add dev eth0 root fq ce_threshold 4ms
 .br
-#tc -s -d qdisc sh dev eth0
+#tc -s -d qdisc show dev eth0
 .br
-qdisc fq 800e: root refcnt 9 limit 10000p flow_limit 1000p buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140 low_rate_threshold 550Kbit refill_delay 40.0ms ce_threshold 4.0ms
- Sent 533368436185 bytes 352296695 pkt (dropped 0, overlimits 0 requeues 1339864)
- rate 39220Mbit 3238202pps backlog 12417828b 358p requeues 1339864
-  1052 flows (852 inactive, 0 throttled)
-  112 gc, 0 highprio, 212 throttled, 21501 ns latency, 470241 ce_mark
+qdisc fq 8001: dev eth0 root refcnt 2 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b low_rate_threshold 550Kbit refill_delay 40.0ms ce_threshold 4.0ms
+ Sent 72149092 bytes 48062 pkt (dropped 2176, overlimits 0 requeues 0)
+ backlog 1937920b 1280p requeues 0
+  flows 34 (inactive 17 throttled 0)
+  gc 0 highprio 0 throttled 0 ce_mark 47622 flows_plimit 2176
 .br
 .SH SEE ALSO
 .BR tc (8),
diff --git a/tc/q_fq.c b/tc/q_fq.c
index caf232ec..44d8a7e0 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -265,71 +265,94 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_FQ_PLIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_PLIMIT]) >= sizeof(__u32)) {
 		plimit = rta_getattr_u32(tb[TCA_FQ_PLIMIT]);
-		fprintf(f, "limit %up ", plimit);
+		print_uint(PRINT_ANY, "limit", "limit %up ", plimit);
 	}
 	if (tb[TCA_FQ_FLOW_PLIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_PLIMIT]) >= sizeof(__u32)) {
 		flow_plimit = rta_getattr_u32(tb[TCA_FQ_FLOW_PLIMIT]);
-		fprintf(f, "flow_limit %up ", flow_plimit);
+		print_uint(PRINT_ANY, "flow_limit", "flow_limit %up ",
+			   flow_plimit);
 	}
 	if (tb[TCA_FQ_BUCKETS_LOG] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_BUCKETS_LOG]) >= sizeof(__u32)) {
 		buckets_log = rta_getattr_u32(tb[TCA_FQ_BUCKETS_LOG]);
-		fprintf(f, "buckets %u ", 1U << buckets_log);
+		print_uint(PRINT_ANY, "buckets", "buckets %u ",
+			   1U << buckets_log);
 	}
 	if (tb[TCA_FQ_ORPHAN_MASK] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_ORPHAN_MASK]) >= sizeof(__u32)) {
 		orphan_mask = rta_getattr_u32(tb[TCA_FQ_ORPHAN_MASK]);
-		fprintf(f, "orphan_mask %u ", orphan_mask);
+		print_uint(PRINT_ANY, "orphan_mask", "orphan_mask %u ",
+			   orphan_mask);
 	}
 	if (tb[TCA_FQ_RATE_ENABLE] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_RATE_ENABLE]) >= sizeof(int)) {
 		pacing = rta_getattr_u32(tb[TCA_FQ_RATE_ENABLE]);
 		if (pacing == 0)
-			fprintf(f, "nopacing ");
+			print_bool(PRINT_ANY, "pacing", "nopacing ", false);
 	}
 	if (tb[TCA_FQ_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_FQ_QUANTUM]);
-		fprintf(f, "quantum %u ", quantum);
+		print_uint(PRINT_JSON, "quantum", NULL, quantum);
+		print_string(PRINT_FP, NULL, "quantum %s ",
+			     sprint_size(quantum, b1));
 	}
 	if (tb[TCA_FQ_INITIAL_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_INITIAL_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
-		fprintf(f, "initial_quantum %u ", quantum);
+		print_uint(PRINT_JSON, "initial_quantum", NULL, quantum);
+		print_string(PRINT_FP, NULL, "initial_quantum %s ",
+			     sprint_size(quantum, b1));
 	}
 	if (tb[TCA_FQ_FLOW_MAX_RATE] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_MAX_RATE]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_FLOW_MAX_RATE]);
 
-		if (rate != ~0U)
-			fprintf(f, "maxrate %s ", sprint_rate(rate, b1));
+		if (rate != ~0U) {
+			print_uint(PRINT_JSON, "maxrate", NULL, rate);
+			print_string(PRINT_FP, NULL, "maxrate %s ",
+				     sprint_rate(rate, b1));
+		}
 	}
 	if (tb[TCA_FQ_FLOW_DEFAULT_RATE] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_DEFAULT_RATE]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]);
 
-		if (rate != 0)
-			fprintf(f, "defrate %s ", sprint_rate(rate, b1));
+		if (rate != 0) {
+			print_uint(PRINT_JSON, "defrate", NULL, rate);
+			print_string(PRINT_FP, NULL, "defrate %s ",
+				     sprint_rate(rate, b1));
+		}
 	}
 	if (tb[TCA_FQ_LOW_RATE_THRESHOLD] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_LOW_RATE_THRESHOLD]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_LOW_RATE_THRESHOLD]);
 
-		if (rate != 0)
-			fprintf(f, "low_rate_threshold %s ", sprint_rate(rate, b1));
+		if (rate != 0) {
+			print_uint(PRINT_JSON, "low_rate_threshold", NULL,
+				   rate);
+			print_string(PRINT_FP, NULL, "low_rate_threshold %s ",
+				     sprint_rate(rate, b1));
+		}
 	}
 	if (tb[TCA_FQ_FLOW_REFILL_DELAY] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_REFILL_DELAY]) >= sizeof(__u32)) {
 		refill_delay = rta_getattr_u32(tb[TCA_FQ_FLOW_REFILL_DELAY]);
-		fprintf(f, "refill_delay %s ", sprint_time(refill_delay, b1));
+		print_uint(PRINT_JSON, "refill_delay", NULL, refill_delay);
+		print_string(PRINT_FP, NULL, "refill_delay %s ",
+			     sprint_time(refill_delay, b1));
 	}
 
 	if (tb[TCA_FQ_CE_THRESHOLD] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_CE_THRESHOLD]) >= sizeof(__u32)) {
 		ce_threshold = rta_getattr_u32(tb[TCA_FQ_CE_THRESHOLD]);
-		if (ce_threshold != ~0U)
-			fprintf(f, "ce_threshold %s ", sprint_time(ce_threshold, b1));
+		if (ce_threshold != ~0U) {
+			print_uint(PRINT_JSON, "ce_threshold", NULL,
+				   ce_threshold);
+			print_string(PRINT_FP, NULL, "ce_threshold %s ",
+				     sprint_time(ce_threshold, b1));
+		}
 	}
 
 	return 0;
@@ -340,6 +363,8 @@ static int fq_print_xstats(struct qdisc_util *qu, FILE *f,
 {
 	struct tc_fq_qd_stats *st, _st;
 
+	SPRINT_BUF(b1);
+
 	if (xstats == NULL)
 		return 0;
 
@@ -348,32 +373,51 @@ static int fq_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	st = &_st;
 
-	fprintf(f, "  %u flows (%u inactive, %u throttled)",
-		st->flows, st->inactive_flows, st->throttled_flows);
+	print_uint(PRINT_ANY, "flows", "  flows %u", st->flows);
+	print_uint(PRINT_ANY, "inactive", " (inactive %u", st->inactive_flows);
+	print_uint(PRINT_ANY, "throttled", " throttled %u)",
+		   st->throttled_flows);
 
-	if (st->time_next_delayed_flow > 0)
-		fprintf(f, ", next packet delay %llu ns", st->time_next_delayed_flow);
+	if (st->time_next_delayed_flow > 0) {
+		print_lluint(PRINT_JSON, "next_packet_delay", NULL,
+			     st->time_next_delayed_flow);
+		print_string(PRINT_FP, NULL, " next_packet_delay %s",
+			     sprint_time64(st->time_next_delayed_flow, b1));
+	}
 
-	fprintf(f, "\n  %llu gc, %llu highprio",
-		st->gc_flows, st->highprio_packets);
+	print_nl();
+	print_lluint(PRINT_ANY, "gc", "  gc %llu", st->gc_flows);
+	print_lluint(PRINT_ANY, "highprio", " highprio %llu",
+		     st->highprio_packets);
 
 	if (st->tcp_retrans)
-		fprintf(f, ", %llu retrans", st->tcp_retrans);
+		print_lluint(PRINT_ANY, "retrans", " retrans %llu",
+			     st->tcp_retrans);
 
-	fprintf(f, ", %llu throttled", st->throttled);
+	print_lluint(PRINT_ANY, "throttled", " throttled %llu", st->throttled);
 
-	if (st->unthrottle_latency_ns)
-		fprintf(f, ", %u ns latency", st->unthrottle_latency_ns);
+	if (st->unthrottle_latency_ns) {
+		print_uint(PRINT_JSON, "latency", NULL,
+			   st->unthrottle_latency_ns);
+		print_string(PRINT_FP, NULL, " latency %s",
+			     sprint_time64(st->unthrottle_latency_ns, b1));
+	}
 
 	if (st->ce_mark)
-		fprintf(f, ", %llu ce_mark", st->ce_mark);
+		print_lluint(PRINT_ANY, "ce_mark", " ce_mark %llu",
+			     st->ce_mark);
 
 	if (st->flows_plimit)
-		fprintf(f, ", %llu flows_plimit", st->flows_plimit);
-
-	if (st->pkts_too_long || st->allocation_errors)
-		fprintf(f, "\n  %llu too long pkts, %llu alloc errors\n",
-			st->pkts_too_long, st->allocation_errors);
+		print_lluint(PRINT_ANY, "flows_plimit", " flows_plimit %llu",
+			     st->flows_plimit);
+
+	if (st->pkts_too_long || st->allocation_errors) {
+		print_nl();
+		print_lluint(PRINT_ANY, "pkts_too_long",
+			     "  pkts_too_long %llu", st->pkts_too_long);
+		print_lluint(PRINT_ANY, "alloc_errors", " alloc_erros %llu",
+			     st->allocation_errors);
+	}
 
 	return 0;
 }
-- 
2.17.1

