Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288772C91EC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgK3XDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbgK3XDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:03:11 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5395C0617A6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:21 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ClLMl01xCzQlNH;
        Tue,  1 Dec 2020 00:01:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chWU38kLcerTJjMXqQeMLEKaJM446jsKMfUYfmQRBq4=;
        b=t99+hLXxPz1tNCgZKL0eVZygbjVUK3I4+8gGAwtjFrNjNdYlm2ITXuIqUMh4OdfHDjhxas
        grFqCnRD9BCxGnE0zjM4ZTWcXASf+2+5o0cFsF0qTF4a+moCxTlSHhYiTBYb4c9Z7uaoQV
        khDxkuZqmaSnw0amCHYSoGtMCLQ4k22h3rcT+sWMUE/foBS4dd5M1BwpBhXoBIS4kKfgvP
        /p6E3x0e/5lxmmrW4MjQF5r85CKVsmGw89bnr+JLh2pSCE7/16NgZ4agWheMxdzss5MWzd
        ViHon0RQyRX900CuhLz6EM9kgWSGgmkQzLLpBbZ6EQnWtodZl/EjDnIwX7z5ag==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id TQfRo8aUR4sv; Tue,  1 Dec 2020 00:01:50 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 3/6] lib: Move sprint_size() from tc here, add print_size()
Date:   Mon, 30 Nov 2020 23:59:39 +0100
Message-Id: <96d90dc75f2c1676b03a119307f068d818b35798.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.64 / 15.00 / 15.00
X-Rspamd-Queue-Id: C38F61833
X-Rspamd-UID: 82eebd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When displaying sizes of various sorts, tc commonly uses the function
sprint_size() to format the size into a buffer as a human-readable string.
This string is then displayed either using print_string(), or in some code
even fprintf(). As a result, a typical sequence of code when formatting a
size is something like the following:

	SPRINT_BUF(b);
	print_uint(PRINT_JSON, "foo", NULL, foo);
	print_string(PRINT_FP, NULL, "foo %s ", sprint_size(foo, b));

For a concept as broadly useful as size, it would be better to have a
dedicated function in json_print.

To that end, move sprint_size() from tc_util to json_print. Add helpers
print_size() and print_color_size() that wrap arount sprint_size() and
provide the JSON dispatch as appropriate.

Since print_size() should be the preferred interface, convert vast majority
of uses of sprint_size() to print_size(). Two notable exceptions are:

- q_tbf, which does not show the size as such, but uses the string
  "$human_readable_size/$cell_size" even in JSON. There is simply no way to
  have print_size() emit the same text, because print_size() in JSON mode
  should of course just use the raw number, without human-readable frills.

- q_cake, which relies on the existence of sprint_size() in its macro-based
  formatting helpers. There might be ways to convert this particular case,
  but given q_tbf simply cannot be converted, leave it as is.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/json_print.h |  4 ++++
 lib/json_print.c     | 28 ++++++++++++++++++++++++++++
 tc/m_gate.c          |  6 ++----
 tc/m_police.c        |  5 ++---
 tc/q_cake.c          | 16 ++++++----------
 tc/q_drr.c           | 10 +++-------
 tc/q_fifo.c          | 10 +++-------
 tc/q_fq.c            |  9 +++------
 tc/q_fq_codel.c      |  5 ++---
 tc/q_fq_pie.c        |  9 +++------
 tc/q_gred.c          | 39 ++++++++-------------------------------
 tc/q_hhf.c           |  9 +++------
 tc/q_htb.c           | 19 ++++++++-----------
 tc/q_red.c           | 13 +++----------
 tc/q_sfq.c           | 15 +++------------
 tc/q_tbf.c           | 25 +++++++------------------
 tc/tc_util.c         | 29 +++--------------------------
 tc/tc_util.h         |  1 -
 18 files changed, 91 insertions(+), 161 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index b6c4c0c80833..1a1ad5ffa552 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -69,6 +69,7 @@ _PRINT_FUNC(on_off, bool)
 _PRINT_FUNC(null, const char*)
 _PRINT_FUNC(string, const char*)
 _PRINT_FUNC(uint, unsigned int)
+_PRINT_FUNC(size, __u32)
 _PRINT_FUNC(u64, uint64_t)
 _PRINT_FUNC(hhu, unsigned char)
 _PRINT_FUNC(hu, unsigned short)
@@ -96,4 +97,7 @@ static inline int print_rate(bool use_iec, enum output_type t,
 	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
 }
 
+/* A backdoor to the size formatter. Please use print_size() instead. */
+char *sprint_size(__u32 sz, char *buf);
+
 #endif /* _JSON_PRINT_H_ */
diff --git a/lib/json_print.c b/lib/json_print.c
index 9ab0f86b83df..c1df637642fd 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -11,6 +11,7 @@
 
 #include <stdarg.h>
 #include <stdio.h>
+#include <math.h>
 
 #include "utils.h"
 #include "json_print.h"
@@ -340,3 +341,30 @@ int print_color_rate(bool use_iec, enum output_type type, enum color_attr color,
 	free(buf);
 	return rc;
 }
+
+char *sprint_size(__u32 sz, char *buf)
+{
+	size_t len = SPRINT_BSIZE - 1;
+	double tmp = sz;
+
+	if (sz >= 1024*1024 && fabs(1024*1024*rint(tmp/(1024*1024)) - sz) < 1024)
+		snprintf(buf, len, "%gMb", rint(tmp/(1024*1024)));
+	else if (sz >= 1024 && fabs(1024*rint(tmp/1024) - sz) < 16)
+		snprintf(buf, len, "%gKb", rint(tmp/1024));
+	else
+		snprintf(buf, len, "%ub", sz);
+
+	return buf;
+}
+
+int print_color_size(enum output_type type, enum color_attr color,
+		     const char *key, const char *fmt, __u32 sz)
+{
+	SPRINT_BUF(buf);
+
+	if (_IS_JSON_CONTEXT(type))
+		return print_color_uint(type, color, key, "%u", sz);
+
+	sprint_size(sz, buf);
+	return print_color_string(type, color, key, fmt, buf);
+}
diff --git a/tc/m_gate.c b/tc/m_gate.c
index 4bae86edb58c..892775a35e28 100644
--- a/tc/m_gate.c
+++ b/tc/m_gate.c
@@ -465,10 +465,8 @@ static int print_gate_list(struct rtattr *list)
 		}
 
 		if (maxoctets != -1) {
-			memset(buf, 0, sizeof(buf));
-			print_uint(PRINT_JSON, "max_octets", NULL, maxoctets);
-			print_string(PRINT_FP, NULL, "\t max-octets %s",
-				     sprint_size(maxoctets, buf));
+			print_size(PRINT_ANY, "max_octets", "\t max-octets %s",
+				   maxoctets);
 		} else {
 			print_string(PRINT_FP, NULL,
 				     "\t max-octets %s", "wildcard");
diff --git a/tc/m_police.c b/tc/m_police.c
index 64068fcc4a42..bb51df686288 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -238,7 +238,6 @@ int parse_police(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
 
 static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 {
-	SPRINT_BUF(b1);
 	SPRINT_BUF(b2);
 	struct tc_police *p;
 	struct rtattr *tb[TCA_POLICE_MAX+1];
@@ -271,8 +270,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	fprintf(f, " police 0x%x ", p->index);
 	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
-	fprintf(f, "burst %s ", sprint_size(buffer, b1));
-	fprintf(f, "mtu %s ", sprint_size(p->mtu, b1));
+	print_size(PRINT_FP, NULL, "burst %s ", buffer);
+	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
 	if (show_raw)
 		fprintf(f, "[%08x] ", p->burst);
 
diff --git a/tc/q_cake.c b/tc/q_cake.c
index ab9233a04f39..b7da731b5510 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -434,7 +434,6 @@ static int cake_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	int atm = 0;
 	int nat = 0;
 
-	SPRINT_BUF(b1);
 	SPRINT_BUF(b2);
 
 	if (opt == NULL)
@@ -573,11 +572,8 @@ static int cake_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (mpu)
 		print_uint(PRINT_ANY, "mpu", "mpu %u ", mpu);
 
-	if (memlimit) {
-		print_uint(PRINT_JSON, "memlimit", NULL, memlimit);
-		print_string(PRINT_FP, NULL, "memlimit %s ",
-			     sprint_size(memlimit, b1));
-	}
+	if (memlimit)
+		print_size(PRINT_ANY, "memlimit", "memlimit %s ", memlimit);
 
 	if (fwmark)
 		print_uint(PRINT_FP, NULL, "fwmark 0x%x ", fwmark);
@@ -637,11 +633,11 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	if (st[TCA_CAKE_STATS_MEMORY_USED] &&
 	    st[TCA_CAKE_STATS_MEMORY_LIMIT]) {
-		print_string(PRINT_FP, NULL, " memory used: %s",
-			sprint_size(GET_STAT_U32(MEMORY_USED), b1));
+		print_size(PRINT_FP, NULL, " memory used: %s",
+			   GET_STAT_U32(MEMORY_USED));
 
-		print_string(PRINT_FP, NULL, " of %s\n",
-			sprint_size(GET_STAT_U32(MEMORY_LIMIT), b1));
+		print_size(PRINT_FP, NULL, " of %s\n",
+			   GET_STAT_U32(MEMORY_LIMIT));
 
 		print_uint(PRINT_JSON, "memory_used", NULL,
 			GET_STAT_U32(MEMORY_USED));
diff --git a/tc/q_drr.c b/tc/q_drr.c
index f9c90f3035f3..4e829ce3331d 100644
--- a/tc/q_drr.c
+++ b/tc/q_drr.c
@@ -84,16 +84,14 @@ static int drr_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_DRR_MAX + 1];
 
-	SPRINT_BUF(b1);
-
 	if (opt == NULL)
 		return 0;
 
 	parse_rtattr_nested(tb, TCA_DRR_MAX, opt);
 
 	if (tb[TCA_DRR_QUANTUM])
-		fprintf(f, "quantum %s ",
-			sprint_size(rta_getattr_u32(tb[TCA_DRR_QUANTUM]), b1));
+		print_size(PRINT_FP, NULL, "quantum %s ",
+			   rta_getattr_u32(tb[TCA_DRR_QUANTUM]));
 	return 0;
 }
 
@@ -101,15 +99,13 @@ static int drr_print_xstats(struct qdisc_util *qu, FILE *f, struct rtattr *xstat
 {
 	struct tc_drr_stats *x;
 
-	SPRINT_BUF(b1);
-
 	if (xstats == NULL)
 		return 0;
 	if (RTA_PAYLOAD(xstats) < sizeof(*x))
 		return -1;
 	x = RTA_DATA(xstats);
 
-	fprintf(f, " deficit %s ", sprint_size(x->deficit, b1));
+	print_size(PRINT_FP, NULL, " deficit %s ", x->deficit);
 	return 0;
 }
 
diff --git a/tc/q_fifo.c b/tc/q_fifo.c
index 61493fbbc5bc..ce82e74dcc5e 100644
--- a/tc/q_fifo.c
+++ b/tc/q_fifo.c
@@ -67,14 +67,10 @@ static int fifo_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (RTA_PAYLOAD(opt)  < sizeof(*qopt))
 		return -1;
 	qopt = RTA_DATA(opt);
-	if (strcmp(qu->id, "bfifo") == 0) {
-		SPRINT_BUF(b1);
-		print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
-		print_string(PRINT_FP, NULL, "limit %s",
-			     sprint_size(qopt->limit, b1));
-	} else {
+	if (strcmp(qu->id, "bfifo") == 0)
+		print_size(PRINT_ANY, "limit", "limit %s", qopt->limit);
+	else
 		print_uint(PRINT_ANY, "limit", "limit %up", qopt->limit);
-	}
 	return 0;
 }
 
diff --git a/tc/q_fq.c b/tc/q_fq.c
index 71a513fb3c72..cff21975b897 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -315,16 +315,13 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_FQ_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_FQ_QUANTUM]);
-		print_uint(PRINT_JSON, "quantum", NULL, quantum);
-		print_string(PRINT_FP, NULL, "quantum %s ",
-			     sprint_size(quantum, b1));
+		print_size(PRINT_ANY, "quantum", "quantum %s ", quantum);
 	}
 	if (tb[TCA_FQ_INITIAL_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_INITIAL_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
-		print_uint(PRINT_JSON, "initial_quantum", NULL, quantum);
-		print_string(PRINT_FP, NULL, "initial_quantum %s ",
-			     sprint_size(quantum, b1));
+		print_size(PRINT_ANY, "initial_quantum", "initial_quantum %s ",
+			   quantum);
 	}
 	if (tb[TCA_FQ_FLOW_MAX_RATE] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_FLOW_MAX_RATE]) >= sizeof(__u32)) {
diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 1a51302e0e2b..300980652243 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -221,9 +221,8 @@ static int fq_codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt
 	if (tb[TCA_FQ_CODEL_MEMORY_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_MEMORY_LIMIT]) >= sizeof(__u32)) {
 		memory_limit = rta_getattr_u32(tb[TCA_FQ_CODEL_MEMORY_LIMIT]);
-		print_uint(PRINT_JSON, "memory_limit", NULL, memory_limit);
-		print_string(PRINT_FP, NULL, "memory_limit %s ",
-			     sprint_size(memory_limit, b1));
+		print_size(PRINT_ANY, "memory_limit", "memory_limit %s ",
+			   memory_limit);
 	}
 	if (tb[TCA_FQ_CODEL_ECN] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_ECN]) >= sizeof(__u32)) {
diff --git a/tc/q_fq_pie.c b/tc/q_fq_pie.c
index c136cd1af124..9cbef47eef88 100644
--- a/tc/q_fq_pie.c
+++ b/tc/q_fq_pie.c
@@ -232,16 +232,13 @@ static int fq_pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_FQ_PIE_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_PIE_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_FQ_PIE_QUANTUM]);
-		print_uint(PRINT_JSON, "quantum", NULL, quantum);
-		print_string(PRINT_FP, NULL, "quantum %s ",
-			     sprint_size(quantum, b1));
+		print_size(PRINT_ANY, "quantum", "quantum %s ", quantum);
 	}
 	if (tb[TCA_FQ_PIE_MEMORY_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_PIE_MEMORY_LIMIT]) >= sizeof(__u32)) {
 		memory_limit = rta_getattr_u32(tb[TCA_FQ_PIE_MEMORY_LIMIT]);
-		print_uint(PRINT_JSON, "memory_limit", NULL, memory_limit);
-		print_string(PRINT_FP, NULL, "memory_limit %s ",
-			     sprint_size(memory_limit, b1));
+		print_size(PRINT_ANY, "memory_limit", "memory_limit %s ",
+			   memory_limit);
 	}
 	if (tb[TCA_FQ_PIE_ECN_PROB] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_PIE_ECN_PROB]) >= sizeof(__u32)) {
diff --git a/tc/q_gred.c b/tc/q_gred.c
index 8a1cecffc126..89aeb086038f 100644
--- a/tc/q_gred.c
+++ b/tc/q_gred.c
@@ -373,18 +373,11 @@ gred_print_stats(struct tc_gred_info *info, struct tc_gred_qopt *qopt)
 {
 	__u64 bytes = info ? info->bytes : qopt->bytesin;
 
-	SPRINT_BUF(b1);
-
 	if (!is_json_context())
 		printf("\n  Queue size: ");
 
-	print_uint(PRINT_JSON, "qave", NULL, qopt->qave);
-	print_string(PRINT_FP, NULL, "average %s ",
-		     sprint_size(qopt->qave, b1));
-
-	print_uint(PRINT_JSON, "backlog", NULL, qopt->backlog);
-	print_string(PRINT_FP, NULL, "current %s ",
-		     sprint_size(qopt->backlog, b1));
+	print_size(PRINT_ANY, "qave", "average %s ", qopt->qave);
+	print_size(PRINT_ANY, "backlog", "current %s ", qopt->backlog);
 
 	if (!is_json_context())
 		printf("\n  Dropped packets: ");
@@ -415,9 +408,7 @@ gred_print_stats(struct tc_gred_info *info, struct tc_gred_qopt *qopt)
 		printf("\n  Total packets: ");
 
 	print_uint(PRINT_ANY, "packets", "%u ", qopt->packets);
-
-	print_uint(PRINT_JSON, "bytes", NULL, bytes);
-	print_string(PRINT_FP, NULL, "(%s) ", sprint_size(bytes, b1));
+	print_size(PRINT_ANY, "bytes", "(%s) ", bytes);
 }
 
 static int gred_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
@@ -431,8 +422,6 @@ static int gred_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	__u32 *limit = NULL;
 	unsigned int i;
 
-	SPRINT_BUF(b1);
-
 	if (opt == NULL)
 		return 0;
 
@@ -470,11 +459,8 @@ static int gred_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	else
 		print_bool(PRINT_ANY, "grio", NULL, false);
 
-	if (limit) {
-		print_uint(PRINT_JSON, "limit", NULL, *limit);
-		print_string(PRINT_FP, NULL, "limit %s ",
-			     sprint_size(*limit, b1));
-	}
+	if (limit)
+		print_size(PRINT_ANY, "limit", "limit %s ", *limit);
 
 	tc_red_print_flags(sopt->flags);
 
@@ -487,18 +473,9 @@ static int gred_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 		print_uint(PRINT_ANY, "vq", "\n vq %u ", qopt->DP);
 		print_hhu(PRINT_ANY, "prio", "prio %hhu ", qopt->prio);
-
-		print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
-		print_string(PRINT_FP, NULL, "limit %s ",
-			     sprint_size(qopt->limit, b1));
-
-		print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
-		print_string(PRINT_FP, NULL, "min %s ",
-			     sprint_size(qopt->qth_min, b1));
-
-		print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-		print_string(PRINT_FP, NULL, "max %s ",
-			     sprint_size(qopt->qth_max, b1));
+		print_size(PRINT_ANY, "limit", "limit %s ", qopt->limit);
+		print_size(PRINT_ANY, "min", "min %s ", qopt->qth_min);
+		print_size(PRINT_ANY, "max", "max %s ", qopt->qth_max);
 
 		if (infos[i].flags_present)
 			tc_red_print_flags(infos[i].flags);
diff --git a/tc/q_hhf.c b/tc/q_hhf.c
index f88880117bee..95e49f3dd720 100644
--- a/tc/q_hhf.c
+++ b/tc/q_hhf.c
@@ -143,9 +143,7 @@ static int hhf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_HHF_QUANTUM] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_QUANTUM]) >= sizeof(__u32)) {
 		quantum = rta_getattr_u32(tb[TCA_HHF_QUANTUM]);
-		print_uint(PRINT_JSON, "quantum", NULL, quantum);
-		print_string(PRINT_FP, NULL, "quantum %s ",
-			     sprint_size(quantum, b1));
+		print_size(PRINT_ANY, "quantum", "quantum %s ", quantum);
 	}
 	if (tb[TCA_HHF_HH_FLOWS_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_HH_FLOWS_LIMIT]) >= sizeof(__u32)) {
@@ -162,9 +160,8 @@ static int hhf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_HHF_ADMIT_BYTES] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_ADMIT_BYTES]) >= sizeof(__u32)) {
 		admit_bytes = rta_getattr_u32(tb[TCA_HHF_ADMIT_BYTES]);
-		print_uint(PRINT_JSON, "admit_bytes", NULL, admit_bytes);
-		print_string(PRINT_FP, NULL, "admit_bytes %s ",
-			     sprint_size(admit_bytes, b1));
+		print_size(PRINT_ANY, "admit_bytes", "admit_bytes %s ",
+			   admit_bytes);
 	}
 	if (tb[TCA_HHF_EVICT_TIMEOUT] &&
 	    RTA_PAYLOAD(tb[TCA_HHF_EVICT_TIMEOUT]) >= sizeof(__u32)) {
diff --git a/tc/q_htb.c b/tc/q_htb.c
index 10030a8741fa..c609e9749c2c 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -269,7 +269,6 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	__u64 rate64, ceil64;
 
 	SPRINT_BUF(b1);
-	SPRINT_BUF(b2);
 	SPRINT_BUF(b3);
 
 	if (opt == NULL)
@@ -310,18 +309,16 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
 			fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
 		if (show_details) {
-			fprintf(f, "burst %s/%u mpu %s ",
-				sprint_size(buffer, b1),
-				1<<hopt->rate.cell_log,
-				sprint_size(hopt->rate.mpu, b2));
-			fprintf(f, "cburst %s/%u mpu %s ",
-				sprint_size(cbuffer, b1),
-				1<<hopt->ceil.cell_log,
-				sprint_size(hopt->ceil.mpu, b2));
+			print_size(PRINT_FP, NULL, "burst %s/", buffer);
+			fprintf(f, "%u ", 1<<hopt->rate.cell_log);
+			print_size(PRINT_FP, NULL, "mpu %s ", hopt->rate.mpu);
+			print_size(PRINT_FP, NULL, "cburst %s/", cbuffer);
+			fprintf(f, "%u ", 1<<hopt->ceil.cell_log);
+			print_size(PRINT_FP, NULL, "mpu %s ", hopt->ceil.mpu);
 			fprintf(f, "level %d ", (int)hopt->level);
 		} else {
-			fprintf(f, "burst %s ", sprint_size(buffer, b1));
-			fprintf(f, "cburst %s ", sprint_size(cbuffer, b1));
+			print_size(PRINT_FP, NULL, "burst %s ", buffer);
+			print_size(PRINT_FP, NULL, "cburst %s ", cbuffer);
 		}
 		if (show_raw)
 			fprintf(f, "buffer [%08x] cbuffer [%08x] ",
diff --git a/tc/q_red.c b/tc/q_red.c
index df788f8fc5da..fd50d37d31cb 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -192,10 +192,6 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct tc_red_qopt *qopt;
 	__u32 max_P = 0;
 
-	SPRINT_BUF(b1);
-	SPRINT_BUF(b2);
-	SPRINT_BUF(b3);
-
 	if (opt == NULL)
 		return 0;
 
@@ -217,12 +213,9 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		qopt->flags = flags_bf->value;
 	}
 
-	print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
-	print_string(PRINT_FP, NULL, "limit %s ", sprint_size(qopt->limit, b1));
-	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
-	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
-	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
+	print_size(PRINT_ANY, "limit", "limit %s ", qopt->limit);
+	print_size(PRINT_ANY, "min", "min %s ", qopt->qth_min);
+	print_size(PRINT_ANY, "max", "max %s ", qopt->qth_max);
 
 	tc_red_print_flags(qopt->flags);
 
diff --git a/tc/q_sfq.c b/tc/q_sfq.c
index 2b9bbcd230b9..d04a440cece7 100644
--- a/tc/q_sfq.c
+++ b/tc/q_sfq.c
@@ -206,9 +206,6 @@ static int sfq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	struct tc_sfq_qopt *qopt;
 	struct tc_sfq_qopt_v1 *qopt_ext = NULL;
 
-	SPRINT_BUF(b1);
-	SPRINT_BUF(b2);
-	SPRINT_BUF(b3);
 	if (opt == NULL)
 		return 0;
 
@@ -219,9 +216,7 @@ static int sfq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	qopt = RTA_DATA(opt);
 
 	print_uint(PRINT_ANY, "limit", "limit %up ", qopt->limit);
-	print_uint(PRINT_JSON, "quantum", NULL, qopt->quantum);
-	print_string(PRINT_FP, NULL, "quantum %s ",
-		     sprint_size(qopt->quantum, b1));
+	print_size(PRINT_ANY, "quantum", "quantum %s ", qopt->quantum);
 
 	if (qopt_ext && qopt_ext->depth)
 		print_uint(PRINT_ANY, "depth", "depth %u ", qopt_ext->depth);
@@ -237,12 +232,8 @@ static int sfq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			   qopt->perturb_period);
 	if (qopt_ext && qopt_ext->qth_min) {
 		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt_ext->Wlog);
-		print_uint(PRINT_JSON, "min", NULL, qopt_ext->qth_min);
-		print_string(PRINT_FP, NULL, "min %s ",
-			     sprint_size(qopt_ext->qth_min, b2));
-		print_uint(PRINT_JSON, "max", NULL, qopt_ext->qth_max);
-		print_string(PRINT_FP, NULL, "max %s ",
-			     sprint_size(qopt_ext->qth_max, b3));
+		print_size(PRINT_ANY, "min", "min %s ", qopt_ext->qth_min);
+		print_size(PRINT_ANY, "max", "max %s ", qopt_ext->qth_max);
 		print_float(PRINT_ANY, "probability", "probability %lg ",
 			    qopt_ext->max_P / pow(2, 32));
 		tc_red_print_flags(qopt_ext->flags);
diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index 9d4833385521..4e5bf382fd03 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -292,13 +292,9 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		sprintf(b1, "%s/%u",  sprint_size(buffer, b2),
 			1 << qopt->rate.cell_log);
 		print_string(PRINT_ANY, "burst", "burst %s ", b1);
-		print_uint(PRINT_JSON, "mpu", NULL, qopt->rate.mpu);
-		print_string(PRINT_FP, NULL, "mpu %s ",
-			     sprint_size(qopt->rate.mpu, b1));
+		print_size(PRINT_ANY, "mpu", "mpu %s ", qopt->rate.mpu);
 	} else {
-		print_u64(PRINT_JSON, "burst", NULL, buffer);
-		print_string(PRINT_FP, NULL, "burst %s ",
-			     sprint_size(buffer, b1));
+		print_size(PRINT_ANY, "burst", "burst %s ", buffer);
 	}
 	if (show_raw)
 		print_hex(PRINT_ANY, "burst_raw", "[%08x] ", qopt->buffer);
@@ -314,15 +310,11 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 				sprintf(b1, "%s/%u",  sprint_size(mtu, b2),
 					1 << qopt->peakrate.cell_log);
 				print_string(PRINT_ANY, "mtu", "mtu %s ", b1);
-				print_uint(PRINT_JSON, "mpu", NULL,
+				print_size(PRINT_ANY, "mpu", "mpu %s ",
 					   qopt->peakrate.mpu);
-				print_string(PRINT_FP, NULL, "mpu %s ",
-					     sprint_size(qopt->peakrate.mpu,
-							 b1));
 			} else {
-				print_u64(PRINT_JSON, "minburst", NULL, mtu);
-				print_string(PRINT_FP, NULL, "minburst %s ",
-					     sprint_size(mtu, b1));
+				print_size(PRINT_ANY, "minburst",
+					   "minburst %s ", mtu);
 			}
 			if (show_raw)
 				print_hex(PRINT_ANY, "mtu_raw", "[%08x] ",
@@ -344,11 +336,8 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_string(PRINT_FP, NULL, "lat %s ",
 			     sprint_time(latency, b1));
 	}
-	if (show_raw || latency < 0.0) {
-		print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
-		print_string(PRINT_FP, NULL, "limit %s ",
-			     sprint_size(qopt->limit, b1));
-	}
+	if (show_raw || latency < 0.0)
+		print_size(PRINT_ANY, "limit", "limit %s ", qopt->limit);
 	if (qopt->rate.overhead)
 		print_int(PRINT_ANY, "overhead", "overhead %d ",
 			  qopt->rate.overhead);
diff --git a/tc/tc_util.c b/tc/tc_util.c
index 40efaa9a4b8a..ff979c617b9b 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -412,24 +412,6 @@ void print_devname(enum output_type type, int ifindex)
 			   "dev", "%s ", ifname);
 }
 
-static void print_size(char *buf, int len, __u32 sz)
-{
-	double tmp = sz;
-
-	if (sz >= 1024*1024 && fabs(1024*1024*rint(tmp/(1024*1024)) - sz) < 1024)
-		snprintf(buf, len, "%gMb", rint(tmp/(1024*1024)));
-	else if (sz >= 1024 && fabs(1024*rint(tmp/1024) - sz) < 16)
-		snprintf(buf, len, "%gKb", rint(tmp/1024));
-	else
-		snprintf(buf, len, "%ub", sz);
-}
-
-char *sprint_size(__u32 size, char *buf)
-{
-	print_size(buf, SPRINT_BSIZE-1, size);
-	return buf;
-}
-
 static const char *action_n2a(int action)
 {
 	static char buf[64];
@@ -786,7 +768,6 @@ static void print_tcstats_basic_hw(struct rtattr **tbs, char *prefix)
 
 void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtattr **xstats)
 {
-	SPRINT_BUF(b1);
 	struct rtattr *tbs[TCA_STATS_MAX + 1];
 
 	parse_rtattr_nested(tbs, TCA_STATS_MAX, rta);
@@ -852,10 +833,8 @@ void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtat
 		       MIN(RTA_PAYLOAD(tbs[TCA_STATS_QUEUE]), sizeof(q)));
 		if (!tbs[TCA_STATS_RATE_EST])
 			print_nl();
-		print_uint(PRINT_JSON, "backlog", NULL, q.backlog);
 		print_string(PRINT_FP, NULL, "%s", prefix);
-		print_string(PRINT_FP, NULL, "backlog %s",
-			     sprint_size(q.backlog, b1));
+		print_size(PRINT_ANY, "backlog", "backlog %s", q.backlog);
 		print_uint(PRINT_ANY, "qlen", " %up", q.qlen);
 		print_uint(PRINT_FP, NULL, " requeues %u", q.requeues);
 	}
@@ -867,8 +846,6 @@ void print_tcstats2_attr(FILE *fp, struct rtattr *rta, char *prefix, struct rtat
 void print_tcstats_attr(FILE *fp, struct rtattr *tb[], char *prefix,
 			struct rtattr **xstats)
 {
-	SPRINT_BUF(b1);
-
 	if (tb[TCA_STATS2]) {
 		print_tcstats2_attr(fp, tb[TCA_STATS2], prefix, xstats);
 		if (xstats && !*xstats)
@@ -901,8 +878,8 @@ void print_tcstats_attr(FILE *fp, struct rtattr *tb[], char *prefix,
 			if (st.qlen || st.backlog) {
 				fprintf(fp, "backlog ");
 				if (st.backlog)
-					fprintf(fp, "%s ",
-						sprint_size(st.backlog, b1));
+					print_size(PRINT_FP, NULL, "%s ",
+						   st.backlog);
 				if (st.qlen)
 					fprintf(fp, "%up ", st.qlen);
 			}
diff --git a/tc/tc_util.h b/tc/tc_util.h
index e5d533a44e10..d3b38c69155d 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -88,7 +88,6 @@ void tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate);
 void print_devname(enum output_type type, int ifindex);
 
-char *sprint_size(__u32 size, char *buf);
 char *sprint_tc_classid(__u32 h, char *buf);
 char *sprint_ticks(__u32 ticks, char *buf);
 char *sprint_linklayer(unsigned int linklayer, char *buf);
-- 
2.25.1

