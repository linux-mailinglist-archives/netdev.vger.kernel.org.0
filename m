Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5352C91EA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgK3XDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:02:59 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D868C0613D6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:19 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ClLMh420GzQlND;
        Tue,  1 Dec 2020 00:01:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwytWHVLFiRBoo8LzqQt5vaxmBblHvNz4t7hl4gnIiU=;
        b=Nj6wBF3Sbq/YiDTjZyUjkrFWbOR/VxsuK9c6MGQos7XSO5ZyVCs4CnVp+GC5yAFw8K62Mm
        Dqif9/Sw/3ADfsVmt5T3RwRTC4/nJtzhqg/vhxx8pnz24w9b9RVP5FryAyx96Jq8mK+nDQ
        YotMflZZWKKl0lTuk9uaNaW3Pl2IfNHP6ciKkKoH43PH7czJkck/24rLcgNW/XtyEe5Etc
        sVZF3eXIbP2vS4Z6ZW4QlbgevRBUvNAHmFCJKaBjSFbaZwt4mq7WdVdXGhgFC8vPzC8KLA
        mxZqFZCFZRl+2aJmBfesF8fGnoWXxCA3iMCGILCuvdltnQ4BcGwUm5rnLaI6pA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id Fh87pFaHGi0c; Tue,  1 Dec 2020 00:01:48 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 2/6] lib: Move print_rate() from tc here; modernize
Date:   Mon, 30 Nov 2020 23:59:38 +0100
Message-Id: <f2dd583ef64b64b95571b317c94802ff155ebc5d.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.64 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6FFA81863
X-Rspamd-UID: 306684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions print_rate() and sprint_rate() are useful for formatting
rate-like values. The DCB tool would find these useful in the maxrate
subtool. However, the current interface to these functions uses a global
variable use_iec as a flag indicating whether 1024- or 1000-based powers
should be used when formatting the rate value. For general use, a global
variable is not a great way of passing arguments to a function. Besides, it
is unlike most other printing functions in that it deals in buffers and
ignores JSON.

Therefore make the interface to print_rate() explicit by converting use_iec
to an ordinary parameter. Since the interface changes anyway, convert it to
follow the pattern of other json_print functions (except for the
now-explicit use_iec parameter). Move to json_print.c.

Add a wrapper to tc, so that all the call sites do not need to repeat the
use_iec global variable argument, and convert all call sites.

In q_cake.c, the conversion is not straightforward due to usage of a macro
that is shared across numerous data types. Simply hand-roll the
corresponding code, which seems better than making an extra helper for one
call site.

Drop sprint_rate() now that everybody just uses print_rate().

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/json_print.h | 10 ++++++++++
 lib/json_print.c     | 32 ++++++++++++++++++++++++++++++++
 tc/m_police.c        |  9 ++++-----
 tc/q_cake.c          | 28 ++++++++++++++++------------
 tc/q_cbq.c           | 14 ++++----------
 tc/q_fq.c            | 25 +++++++++----------------
 tc/q_hfsc.c          |  4 ++--
 tc/q_htb.c           |  4 ++--
 tc/q_mqprio.c        |  8 ++++----
 tc/q_netem.c         |  4 +---
 tc/q_tbf.c           |  7 ++-----
 tc/tc_util.c         | 37 +++++++------------------------------
 tc/tc_util.h         |  4 ++--
 13 files changed, 95 insertions(+), 91 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 096a999a4de4..b6c4c0c80833 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -86,4 +86,14 @@ _PRINT_NAME_VALUE_FUNC(uint, unsigned int, u);
 _PRINT_NAME_VALUE_FUNC(string, const char*, s);
 #undef _PRINT_NAME_VALUE_FUNC
 
+int print_color_rate(bool use_iec, enum output_type t, enum color_attr color,
+		     const char *key, const char *fmt, unsigned long long rate);
+
+static inline int print_rate(bool use_iec, enum output_type t,
+			     const char *key, const char *fmt,
+			     unsigned long long rate)
+{
+	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
+}
+
 #endif /* _JSON_PRINT_H_ */
diff --git a/lib/json_print.c b/lib/json_print.c
index 62eeb1f1fb31..9ab0f86b83df 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -308,3 +308,35 @@ void print_nl(void)
 	if (!_jw)
 		printf("%s", _SL_);
 }
+
+int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
+		     const char *key, const char *fmt, unsigned long long rate)
+{
+	unsigned long kilo = use_iec ? 1024 : 1000;
+	const char *str = use_iec ? "i" : "";
+	static char *units[5] = {"", "K", "M", "G", "T"};
+	char *buf;
+	int rc;
+	int i;
+
+	if (_IS_JSON_CONTEXT(type))
+		return print_color_lluint(type, color, key, "%llu", rate);
+
+	rate <<= 3; /* bytes/sec -> bits/sec */
+
+	for (i = 0; i < ARRAY_SIZE(units) - 1; i++)  {
+		if (rate < kilo)
+			break;
+		if (((rate % kilo) != 0) && rate < 1000*kilo)
+			break;
+		rate /= kilo;
+	}
+
+	rc = asprintf(&buf, "%.0f%s%sbit", (double)rate, units[i], str);
+	if (rc < 0)
+		return -1;
+
+	rc = print_color_string(type, color, key, fmt, buf);
+	free(buf);
+	return rc;
+}
diff --git a/tc/m_police.c b/tc/m_police.c
index 83b25db49f21..64068fcc4a42 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -269,7 +269,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
 
 	fprintf(f, " police 0x%x ", p->index);
-	fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
 	fprintf(f, "burst %s ", sprint_size(buffer, b1));
 	fprintf(f, "mtu %s ", sprint_size(p->mtu, b1));
@@ -282,12 +282,11 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		prate64 = rta_getattr_u64(tb[TCA_POLICE_PEAKRATE64]);
 
 	if (prate64)
-		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
+		tc_print_rate(PRINT_FP, NULL, "peakrate %s ", prate64);
 
 	if (tb[TCA_POLICE_AVRATE])
-		fprintf(f, "avrate %s ",
-			sprint_rate(rta_getattr_u32(tb[TCA_POLICE_AVRATE]),
-				    b1));
+		tc_print_rate(PRINT_FP, NULL, "avrate %s ",
+			      rta_getattr_u32(tb[TCA_POLICE_AVRATE]));
 
 	print_action_control(f, "action ", p->action, "");
 
diff --git a/tc/q_cake.c b/tc/q_cake.c
index bf116e80316c..ab9233a04f39 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -445,11 +445,10 @@ static int cake_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_CAKE_BASE_RATE64] &&
 	    RTA_PAYLOAD(tb[TCA_CAKE_BASE_RATE64]) >= sizeof(bandwidth)) {
 		bandwidth = rta_getattr_u64(tb[TCA_CAKE_BASE_RATE64]);
-		if (bandwidth) {
-			print_uint(PRINT_JSON, "bandwidth", NULL, bandwidth);
-			print_string(PRINT_FP, NULL, "bandwidth %s ",
-				     sprint_rate(bandwidth, b1));
-		} else
+		if (bandwidth)
+			tc_print_rate(PRINT_ANY, "bandwidth", "bandwidth %s ",
+				      bandwidth);
+		else
 			print_string(PRINT_ANY, "bandwidth", "bandwidth %s ",
 				     "unlimited");
 	}
@@ -650,12 +649,10 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 			GET_STAT_U32(MEMORY_LIMIT));
 	}
 
-	if (st[TCA_CAKE_STATS_CAPACITY_ESTIMATE64]) {
-		print_string(PRINT_FP, NULL, " capacity estimate: %s\n",
-			sprint_rate(GET_STAT_U64(CAPACITY_ESTIMATE64), b1));
-		print_uint(PRINT_JSON, "capacity_estimate", NULL,
-			GET_STAT_U64(CAPACITY_ESTIMATE64));
-	}
+	if (st[TCA_CAKE_STATS_CAPACITY_ESTIMATE64])
+		tc_print_rate(PRINT_ANY, "capacity_estimate",
+			      " capacity estimate: %s\n",
+			      GET_STAT_U64(CAPACITY_ESTIMATE64));
 
 	if (st[TCA_CAKE_STATS_MIN_NETLEN] &&
 	    st[TCA_CAKE_STATS_MAX_NETLEN]) {
@@ -790,7 +787,14 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 #define PRINT_TSTAT_U64(name, attr)	PRINT_TSTAT(			\
 			name, attr, "llu", rta_getattr_u64(GET_TSTAT(i, attr)))
 
-		SPRINT_TSTAT(rate, u64, "  thresh  ", THRESHOLD_RATE64);
+		if (GET_TSTAT(0, THRESHOLD_RATE64)) {
+			fprintf(f, "  thresh  ");
+			for (i = 0; i < num_tins; i++)
+				tc_print_rate(PRINT_FP, NULL, " %12s",
+					      rta_getattr_u64(GET_TSTAT(i, THRESHOLD_RATE64)));
+			fprintf(f, "%s", _SL_);
+		}
+
 		SPRINT_TSTAT(time, u32, "  target  ", TARGET_US);
 		SPRINT_TSTAT(time, u32, "  interval", INTERVAL_US);
 		SPRINT_TSTAT(time, u32, "  pk_delay", PEAK_DELAY_US);
diff --git a/tc/q_cbq.c b/tc/q_cbq.c
index 6518ef46813b..4619a37b8160 100644
--- a/tc/q_cbq.c
+++ b/tc/q_cbq.c
@@ -497,10 +497,7 @@ static int cbq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	}
 
 	if (r) {
-		char buf[64];
-
-		print_rate(buf, sizeof(buf), r->rate);
-		fprintf(f, "rate %s ", buf);
+		tc_print_rate(PRINT_FP, NULL, "rate %s ", r->rate);
 		linklayer = (r->linklayer & TC_LINKLAYER_MASK);
 		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
 			fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b2));
@@ -533,13 +530,10 @@ static int cbq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		else
 			fprintf(f, "prio no-transmit");
 		if (show_details) {
-			char buf[64];
-
 			fprintf(f, "/%u ", wrr->cpriority);
-			if (wrr->weight != 1) {
-				print_rate(buf, sizeof(buf), wrr->weight);
-				fprintf(f, "weight %s ", buf);
-			}
+			if (wrr->weight != 1)
+				tc_print_rate(PRINT_FP, NULL, "weight %s ",
+					      wrr->weight);
 			if (wrr->allot)
 				fprintf(f, "allot %ub ", wrr->allot);
 		}
diff --git a/tc/q_fq.c b/tc/q_fq.c
index b10d01e901d8..71a513fb3c72 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -330,32 +330,25 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_MAX_RATE]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_FLOW_MAX_RATE]);
 
-		if (rate != ~0U) {
-			print_uint(PRINT_JSON, "maxrate", NULL, rate);
-			print_string(PRINT_FP, NULL, "maxrate %s ",
-				     sprint_rate(rate, b1));
-		}
+		if (rate != ~0U)
+			tc_print_rate(PRINT_ANY,
+				      "maxrate", "maxrate %s ", rate);
 	}
 	if (tb[TCA_FQ_FLOW_DEFAULT_RATE] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_DEFAULT_RATE]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]);
 
-		if (rate != 0) {
-			print_uint(PRINT_JSON, "defrate", NULL, rate);
-			print_string(PRINT_FP, NULL, "defrate %s ",
-				     sprint_rate(rate, b1));
-		}
+		if (rate != 0)
+			tc_print_rate(PRINT_ANY,
+				      "defrate", "defrate %s ", rate);
 	}
 	if (tb[TCA_FQ_LOW_RATE_THRESHOLD] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_LOW_RATE_THRESHOLD]) >= sizeof(__u32)) {
 		rate = rta_getattr_u32(tb[TCA_FQ_LOW_RATE_THRESHOLD]);
 
-		if (rate != 0) {
-			print_uint(PRINT_JSON, "low_rate_threshold", NULL,
-				   rate);
-			print_string(PRINT_FP, NULL, "low_rate_threshold %s ",
-				     sprint_rate(rate, b1));
-		}
+		if (rate != 0)
+			tc_print_rate(PRINT_ANY, "low_rate_threshold",
+				      "low_rate_threshold %s ", rate);
 	}
 	if (tb[TCA_FQ_FLOW_REFILL_DELAY] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_REFILL_DELAY]) >= sizeof(__u32)) {
diff --git a/tc/q_hfsc.c b/tc/q_hfsc.c
index f34b1b2fe2a9..81c10210c884 100644
--- a/tc/q_hfsc.c
+++ b/tc/q_hfsc.c
@@ -219,9 +219,9 @@ hfsc_print_sc(FILE *f, char *name, struct tc_service_curve *sc)
 	SPRINT_BUF(b1);
 
 	fprintf(f, "%s ", name);
-	fprintf(f, "m1 %s ", sprint_rate(sc->m1, b1));
+	tc_print_rate(PRINT_FP, NULL, "m1 %s ", sc->m1);
 	fprintf(f, "d %s ", sprint_time(tc_core_ktime2time(sc->d), b1));
-	fprintf(f, "m2 %s ", sprint_rate(sc->m2, b1));
+	tc_print_rate(PRINT_FP, NULL, "m2 %s ", sc->m2);
 }
 
 static int
diff --git a/tc/q_htb.c b/tc/q_htb.c
index 520522266e00..10030a8741fa 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -299,12 +299,12 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		    RTA_PAYLOAD(tb[TCA_HTB_CEIL64]) >= sizeof(ceil64))
 			ceil64 = rta_getattr_u64(tb[TCA_HTB_CEIL64]);
 
-		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+		tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 		if (hopt->rate.overhead)
 			fprintf(f, "overhead %u ", hopt->rate.overhead);
 		buffer = tc_calc_xmitsize(rate64, hopt->buffer);
 
-		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
+		tc_print_rate(PRINT_FP, NULL, "ceil %s ", ceil64);
 		cbuffer = tc_calc_xmitsize(ceil64, hopt->cbuffer);
 		linklayer = (hopt->rate.linklayer & TC_LINKLAYER_MASK);
 		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index f26ba8d7b708..123487fdf240 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -230,8 +230,6 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	__u64 max_rate64[TC_QOPT_MAX_QUEUE] = {0};
 	int len;
 
-	SPRINT_BUF(b1);
-
 	if (opt == NULL)
 		return 0;
 
@@ -289,7 +287,8 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			}
 			fprintf(f, "	min_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(min_rate64[i], b1));
+				tc_print_rate(PRINT_FP, NULL, "%s ",
+					      min_rate64[i]);
 		}
 
 		if (tb[TCA_MQPRIO_MAX_RATE64]) {
@@ -305,7 +304,8 @@ static int mqprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			}
 			fprintf(f, "	max_rate:");
 			for (i = 0; i < qopt->num_tc; i++)
-				fprintf(f, "%s ", sprint_rate(max_rate64[i], b1));
+				tc_print_rate(PRINT_FP, NULL, "%s ",
+					      max_rate64[i]);
 		}
 	}
 	return 0;
diff --git a/tc/q_netem.c b/tc/q_netem.c
index d01450fc59dc..d93e1c7315d2 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -800,9 +800,7 @@ static int netem_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (rate && rate->rate) {
 		open_json_object("rate");
 		rate64 = rate64 ? : rate->rate;
-		print_string(PRINT_FP, NULL, " rate %s",
-			     sprint_rate(rate64, b1));
-		print_lluint(PRINT_JSON, "rate", NULL, rate64);
+		tc_print_rate(PRINT_ANY, "rate", " rate %s", rate64);
 		PRINT_INT_OPT("packetoverhead", rate->packet_overhead);
 		print_uint(PRINT_ANY, "cellsize",
 			   rate->cell_size ? " cellsize %u" : "",
diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index 5135b1d670d6..9d4833385521 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -286,8 +286,7 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_TBF_RATE64] &&
 	    RTA_PAYLOAD(tb[TCA_TBF_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_TBF_RATE64]);
-	print_u64(PRINT_JSON, "rate", NULL, rate64);
-	print_string(PRINT_FP, NULL, "rate %s ", sprint_rate(rate64, b1));
+	tc_print_rate(PRINT_ANY, "rate", "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, qopt->buffer);
 	if (show_details) {
 		sprintf(b1, "%s/%u",  sprint_size(buffer, b2),
@@ -308,9 +307,7 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_TBF_PRATE64]) >= sizeof(prate64))
 		prate64 = rta_getattr_u64(tb[TCA_TBF_PRATE64]);
 	if (prate64) {
-		print_u64(PRINT_JSON, "peakrate", NULL, prate64);
-		print_string(PRINT_FP, NULL, "peakrate %s ",
-			     sprint_rate(prate64, b1));
+		tc_print_rate(PRINT_FP, "peakrate", "peakrate %s ", prate64);
 		if (qopt->mtu || qopt->peakrate.mpu) {
 			mtu = tc_calc_xmitsize(prate64, qopt->mtu);
 			if (show_details) {
diff --git a/tc/tc_util.c b/tc/tc_util.c
index b7ff911b63ed..40efaa9a4b8a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -326,31 +326,10 @@ int get_rate64(__u64 *rate, const char *str)
 	return 0;
 }
 
-void print_rate(char *buf, int len, __u64 rate)
+void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+		   unsigned long long rate)
 {
-	extern int use_iec;
-	unsigned long kilo = use_iec ? 1024 : 1000;
-	const char *str = use_iec ? "i" : "";
-	static char *units[5] = {"", "K", "M", "G", "T"};
-	int i;
-
-	rate <<= 3; /* bytes/sec -> bits/sec */
-
-	for (i = 0; i < ARRAY_SIZE(units) - 1; i++)  {
-		if (rate < kilo)
-			break;
-		if (((rate % kilo) != 0) && rate < 1000*kilo)
-			break;
-		rate /= kilo;
-	}
-
-	snprintf(buf, len, "%.0f%s%sbit", (double)rate, units[i], str);
-}
-
-char *sprint_rate(__u64 rate, char *buf)
-{
-	print_rate(buf, SPRINT_BSIZE-1, rate);
-	return buf;
+	print_rate(use_iec, t, key, fmt, rate);
 }
 
 char *sprint_ticks(__u32 ticks, char *buf)
@@ -853,8 +832,7 @@ void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtat
 			   sizeof(re)));
 		print_string(PRINT_FP, NULL, "\n%s", prefix);
 		print_lluint(PRINT_JSON, "rate", NULL, re.bps);
-		print_string(PRINT_FP, NULL, "rate %s",
-			     sprint_rate(re.bps, b1));
+		tc_print_rate(PRINT_FP, NULL, "rate %s", re.bps);
 		print_lluint(PRINT_ANY, "pps", " %llupps", re.pps);
 	} else if (tbs[TCA_STATS_RATE_EST]) {
 		struct gnet_stats_rate_est re = {0};
@@ -863,8 +841,7 @@ void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtat
 		       MIN(RTA_PAYLOAD(tbs[TCA_STATS_RATE_EST]), sizeof(re)));
 		print_string(PRINT_FP, NULL, "\n%s", prefix);
 		print_uint(PRINT_JSON, "rate", NULL, re.bps);
-		print_string(PRINT_FP, NULL, "rate %s",
-			     sprint_rate(re.bps, b1));
+		tc_print_rate(PRINT_FP, NULL, "rate %s", re.bps);
 		print_uint(PRINT_ANY, "pps", " %upps", re.pps);
 	}
 
@@ -916,8 +893,8 @@ void print_tcstats_attr(FILE *fp, struct rtattr *tb[], char *prefix,
 			if (st.bps || st.pps) {
 				fprintf(fp, "rate ");
 				if (st.bps)
-					fprintf(fp, "%s ",
-						sprint_rate(st.bps, b1));
+					tc_print_rate(PRINT_FP, NULL, "%s ",
+						      st.bps);
 				if (st.pps)
 					fprintf(fp, "%upps ", st.pps);
 			}
diff --git a/tc/tc_util.h b/tc/tc_util.h
index c8af4e952109..e5d533a44e10 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -84,10 +84,10 @@ int get_size(unsigned int *size, const char *str);
 int get_size_and_cell(unsigned int *size, int *cell_log, char *str);
 int get_linklayer(unsigned int *val, const char *arg);
 
-void print_rate(char *buf, int len, __u64 rate);
+void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+		   unsigned long long rate);
 void print_devname(enum output_type type, int ifindex);
 
-char *sprint_rate(__u64 rate, char *buf);
 char *sprint_size(__u32 size, char *buf);
 char *sprint_tc_classid(__u32 h, char *buf);
 char *sprint_ticks(__u32 ticks, char *buf);
-- 
2.25.1

