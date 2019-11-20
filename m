Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B46103D0C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbfKTOPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:15:01 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36912 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbfKTOPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 09:15:01 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so14304149pfn.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 06:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MmI0hnhc27sYDvlVHdbiJ6XF6H6kmLslrp3yVgVhJok=;
        b=IzXUQt2mSgrQJZYvwmZ7TtTPEH27a36CTnNrDU9YwqChMh4b2EERjCL7R+8IN6W+Gk
         I5KOQv0EJTiVVWCiKrUtmzo0o/4Un4z+19eQWSQdgHkX02ZmN7i0KkNC7tdqhzLGJLQo
         25V7eIvF8m24of0tHc2FcgSxDnMcUjoCGWU5Ukk0eiHPXkWQYXIbC7SaCBxMDyuaUgJ2
         lk6y1uiO24szSPEdEdLIo+tHHIuuMOktzraJHCNyJx6msUHoA8dog+AZEGD9yl3U2DU1
         fNELq61Xxj55alfgwwwjk8oHAhIiVzQEYdxFsPplRbfReUvKOwPKvqtgbYk+GcqlSaD6
         7Iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MmI0hnhc27sYDvlVHdbiJ6XF6H6kmLslrp3yVgVhJok=;
        b=Rs3V8HCu5MhYfL3ryqt/LR8ckvULVRHU0bkAsZIj9iFHCYZ+EJOya9icdCTNtA9koi
         zXRc8oqDP4ikwN+ES5Ru6fX4BhIKFztBkDvs1Y6FOve2NQxMjRNHJNeB+HmChiXHS5at
         VJwHc3TIR0iCcUiGQxaLdQfKBc/auQsJY8zXJbxQLtOfn0fj1dW9xlrZnUD9upLZ36/8
         Eofl6rf4cXfadmCuPrgEQyzQ+gXEXx2plOHq25IY8J0vAnHjKRo5jWqrDSBVirPrmg1C
         Tn0PErn4kdnrEUgO2+q2zmhlKSy3rbYIsO9QLRcA1yiyvlfvSJDY834ghMEYbHBKI4Jl
         TLfg==
X-Gm-Message-State: APjAAAUhSf3PI+lmNNWWbVOse1/YBgZgbqA4POBiW1kv1MBpCReeMBhw
        6zJGvqtOc4Tn0BqbYJriRRUCBugmRxQ=
X-Google-Smtp-Source: APXvYqw8DhfgwpTSSJdD5u3I6iXaVuJfA/orMWWPVs9aC93amS3lnzCC7f+hx8B0R+PQcEcFy67Ykg==
X-Received: by 2002:aa7:9618:: with SMTP id q24mr4342435pfg.229.1574259298846;
        Wed, 20 Nov 2019 06:14:58 -0800 (PST)
Received: from localhost.localdomain ([223.186.193.244])
        by smtp.gmail.com with ESMTPSA id k14sm28742980pgt.54.2019.11.20.06.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 06:14:57 -0800 (PST)
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
To:     jhs@mojatatu.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Gautam Ramakrishnan <gautamramk@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Subject: [PATCH net-next v2] net: sched: pie: enable timestamp based delay calculation
Date:   Wed, 20 Nov 2019 19:43:54 +0530
Message-Id: <20191120141354.17050-1-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8033 suggests an alternative approach to calculate the queue
delay in PIE by using a timestamp on every enqueued packet. This
patch adds an implementation of that approach and sets it as the
default method to calculate queue delay. The previous method (based
on Little's law) to calculate queue delay is set as optional.

Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Acked-by: Dave Taht <dave.taht@gmail.com>
---
Changes from v1 to v2:
- Made timestamp feature default and made average dequeue
  rate estimator optional as Recommended by Dave.
- Changed the position of the timestamp qdelay calculation
  inside pie_process_dequeue().

 include/uapi/linux/pkt_sched.h |  22 +++---
 net/sched/sch_pie.c            | 120 +++++++++++++++++++++++++++------
 2 files changed, 113 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 5011259b8f67..9f1a72876212 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -950,19 +950,25 @@ enum {
 	TCA_PIE_BETA,
 	TCA_PIE_ECN,
 	TCA_PIE_BYTEMODE,
+	TCA_PIE_DQ_RATE_ESTIMATOR,
 	__TCA_PIE_MAX
 };
 #define TCA_PIE_MAX   (__TCA_PIE_MAX - 1)
 
 struct tc_pie_xstats {
-	__u64 prob;             /* current probability */
-	__u32 delay;            /* current delay in ms */
-	__u32 avg_dq_rate;      /* current average dq_rate in bits/pie_time */
-	__u32 packets_in;       /* total number of packets enqueued */
-	__u32 dropped;          /* packets dropped due to pie_action */
-	__u32 overlimit;        /* dropped due to lack of space in queue */
-	__u32 maxq;             /* maximum queue size */
-	__u32 ecn_mark;         /* packets marked with ecn*/
+	__u64 prob;			/* current probability */
+	__u32 delay;			/* current delay in ms */
+	__u32 avg_dq_rate;		/* current average dq_rate in
+					 * bits/pie_time
+					 */
+	__u32 dq_rate_estimating;	/* is avg_dq_rate being calculated? */
+	__u32 packets_in;		/* total number of packets enqueued */
+	__u32 dropped;			/* packets dropped due to pie_action */
+	__u32 overlimit;		/* dropped due to lack of space
+					 * in queue
+					 */
+	__u32 maxq;			/* maximum queue size */
+	__u32 ecn_mark;			/* packets marked with ecn*/
 };
 
 /* CBS */
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index df98a887eb89..b0b0dc46af61 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -22,6 +22,7 @@
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
+#define DTIME_INVALID 0xffffffffffffffff
 #define MAX_PROB 0xffffffffffffffff
 #define PIE_SCALE 8
 
@@ -34,6 +35,7 @@ struct pie_params {
 	u32 beta;		/* and are used for shift relative to 1 */
 	bool ecn;		/* true if ecn is enabled */
 	bool bytemode;		/* to scale drop early prob based on pkt size */
+	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
 };
 
 /* variables used */
@@ -77,11 +79,34 @@ static void pie_params_init(struct pie_params *params)
 	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
 	params->ecn = false;
 	params->bytemode = false;
+	params->dq_rate_estimator = false;
+}
+
+/* private skb vars */
+struct pie_skb_cb {
+	psched_time_t enqueue_time;
+};
+
+static struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
+	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static psched_time_t pie_get_enqueue_time(const struct sk_buff *skb)
+{
+	return get_pie_cb(skb)->enqueue_time;
+}
+
+static void pie_set_enqueue_time(struct sk_buff *skb)
+{
+	get_pie_cb(skb)->enqueue_time = psched_get_time();
 }
 
 static void pie_vars_init(struct pie_vars *vars)
 {
 	vars->dq_count = DQCOUNT_INVALID;
+	vars->dq_tstamp = DTIME_INVALID;
 	vars->accu_prob = 0;
 	vars->avg_dq_rate = 0;
 	/* default of 150 ms in pschedtime */
@@ -172,6 +197,10 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* we can enqueue the packet */
 	if (enqueue) {
+		/* Set enqueue time only when dq_rate_estimator is disabled. */
+		if (!q->params.dq_rate_estimator)
+			pie_set_enqueue_time(skb);
+
 		q->stats.packets_in++;
 		if (qdisc_qlen(sch) > q->stats.maxq)
 			q->stats.maxq = qdisc_qlen(sch);
@@ -194,6 +223,7 @@ static const struct nla_policy pie_policy[TCA_PIE_MAX + 1] = {
 	[TCA_PIE_BETA] = {.type = NLA_U32},
 	[TCA_PIE_ECN] = {.type = NLA_U32},
 	[TCA_PIE_BYTEMODE] = {.type = NLA_U32},
+	[TCA_PIE_DQ_RATE_ESTIMATOR] = {.type = NLA_U32},
 };
 
 static int pie_change(struct Qdisc *sch, struct nlattr *opt,
@@ -247,6 +277,10 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_PIE_BYTEMODE])
 		q->params.bytemode = nla_get_u32(tb[TCA_PIE_BYTEMODE]);
 
+	if (tb[TCA_PIE_DQ_RATE_ESTIMATOR])
+		q->params.dq_rate_estimator =
+				nla_get_u32(tb[TCA_PIE_DQ_RATE_ESTIMATOR]);
+
 	/* Drop excess packets if new limit is lower */
 	qlen = sch->q.qlen;
 	while (sch->q.qlen > sch->limit) {
@@ -266,6 +300,28 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
 	int qlen = sch->qstats.backlog;	/* current queue size in bytes */
+	psched_time_t now = psched_get_time();
+	u32 dtime = 0;
+
+	/* If dq_rate_estimator is disabled, calculate qdelay using the
+	 * packet timestamp.
+	 */
+	if (!q->params.dq_rate_estimator) {
+		q->vars.qdelay = now - pie_get_enqueue_time(skb);
+
+		if (q->vars.dq_tstamp != DTIME_INVALID)
+			dtime = now - q->vars.dq_tstamp;
+
+		q->vars.dq_tstamp = now;
+
+		if (qlen == 0)
+			q->vars.qdelay = 0;
+
+		if (dtime == 0)
+			return;
+
+		goto burst_allowance_reduction;
+	}
 
 	/* If current queue is about 10 packets or more and dq_count is unset
 	 * we have enough packets to calculate the drain rate. Save
@@ -289,10 +345,10 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 		q->vars.dq_count += skb->len;
 
 		if (q->vars.dq_count >= QUEUE_THRESHOLD) {
-			psched_time_t now = psched_get_time();
-			u32 dtime = now - q->vars.dq_tstamp;
 			u32 count = q->vars.dq_count << PIE_SCALE;
 
+			dtime = now - q->vars.dq_tstamp;
+
 			if (dtime == 0)
 				return;
 
@@ -317,14 +373,19 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 				q->vars.dq_tstamp = psched_get_time();
 			}
 
-			if (q->vars.burst_time > 0) {
-				if (q->vars.burst_time > dtime)
-					q->vars.burst_time -= dtime;
-				else
-					q->vars.burst_time = 0;
-			}
+			goto burst_allowance_reduction;
 		}
 	}
+
+	return;
+
+burst_allowance_reduction:
+	if (q->vars.burst_time > 0) {
+		if (q->vars.burst_time > dtime)
+			q->vars.burst_time -= dtime;
+		else
+			q->vars.burst_time = 0;
+	}
 }
 
 static void calculate_probability(struct Qdisc *sch)
@@ -332,19 +393,25 @@ static void calculate_probability(struct Qdisc *sch)
 	struct pie_sched_data *q = qdisc_priv(sch);
 	u32 qlen = sch->qstats.backlog;	/* queue size in bytes */
 	psched_time_t qdelay = 0;	/* in pschedtime */
-	psched_time_t qdelay_old = q->vars.qdelay;	/* in pschedtime */
+	psched_time_t qdelay_old = 0;	/* in pschedtime */
 	s64 delta = 0;		/* determines the change in probability */
 	u64 oldprob;
 	u64 alpha, beta;
 	u32 power;
 	bool update_prob = true;
 
-	q->vars.qdelay_old = q->vars.qdelay;
+	if (q->params.dq_rate_estimator) {
+		qdelay_old = q->vars.qdelay;
+		q->vars.qdelay_old = q->vars.qdelay;
 
-	if (q->vars.avg_dq_rate > 0)
-		qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
-	else
-		qdelay = 0;
+		if (q->vars.avg_dq_rate > 0)
+			qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
+		else
+			qdelay = 0;
+	} else {
+		qdelay = q->vars.qdelay;
+		qdelay_old = q->vars.qdelay_old;
+	}
 
 	/* If qdelay is zero and qlen is not, it means qlen is very small, less
 	 * than dequeue_rate, so we do not update probabilty in this round
@@ -430,14 +497,18 @@ static void calculate_probability(struct Qdisc *sch)
 	/* We restart the measurement cycle if the following conditions are met
 	 * 1. If the delay has been low for 2 consecutive Tupdate periods
 	 * 2. Calculated drop probability is zero
-	 * 3. We have atleast one estimate for the avg_dq_rate ie.,
-	 *    is a non-zero value
+	 * 3. If average dq_rate_estimator is enabled, we have atleast one
+	 *    estimate for the avg_dq_rate ie., is a non-zero value
 	 */
 	if ((q->vars.qdelay < q->params.target / 2) &&
 	    (q->vars.qdelay_old < q->params.target / 2) &&
 	    q->vars.prob == 0 &&
-	    q->vars.avg_dq_rate > 0)
+	    (!q->params.dq_rate_estimator || q->vars.avg_dq_rate > 0)) {
 		pie_vars_init(&q->vars);
+	}
+
+	if (!q->params.dq_rate_estimator)
+		q->vars.qdelay_old = qdelay;
 }
 
 static void pie_timer(struct timer_list *t)
@@ -497,7 +568,9 @@ static int pie_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_PIE_ALPHA, q->params.alpha) ||
 	    nla_put_u32(skb, TCA_PIE_BETA, q->params.beta) ||
 	    nla_put_u32(skb, TCA_PIE_ECN, q->params.ecn) ||
-	    nla_put_u32(skb, TCA_PIE_BYTEMODE, q->params.bytemode))
+	    nla_put_u32(skb, TCA_PIE_BYTEMODE, q->params.bytemode) ||
+	    nla_put_u32(skb, TCA_PIE_DQ_RATE_ESTIMATOR,
+			q->params.dq_rate_estimator))
 		goto nla_put_failure;
 
 	return nla_nest_end(skb, opts);
@@ -514,9 +587,6 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		.prob		= q->vars.prob,
 		.delay		= ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
 				   NSEC_PER_USEC,
-		/* unscale and return dq_rate in bytes per sec */
-		.avg_dq_rate	= q->vars.avg_dq_rate *
-				  (PSCHED_TICKS_PER_SEC) >> PIE_SCALE,
 		.packets_in	= q->stats.packets_in,
 		.overlimit	= q->stats.overlimit,
 		.maxq		= q->stats.maxq,
@@ -524,6 +594,14 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 		.ecn_mark	= q->stats.ecn_mark,
 	};
 
+	/* avg_dq_rate is only valid if dq_rate_estimator is enabled */
+	st.dq_rate_estimating = q->params.dq_rate_estimator;
+
+	/* unscale and return dq_rate in bytes per sec */
+	if (q->params.dq_rate_estimator)
+		st.avg_dq_rate = q->vars.avg_dq_rate *
+				 (PSCHED_TICKS_PER_SEC) >> PIE_SCALE;
+
 	return gnet_stats_copy_app(d, &st, sizeof(st));
 }
 
-- 
2.17.1

