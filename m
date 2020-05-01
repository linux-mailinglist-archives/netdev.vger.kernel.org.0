Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23E1C175C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgEAOHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgEAOHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:07:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165B3C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 07:07:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e2so12075974ybm.19
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 07:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8Y5aNd44J9eyb5XFaYXY8MOrjirh66aa5xiLVDvzzDo=;
        b=N5Ol/OaMVberKgGLdYADe2Dn+4ppALoeFxBZsNitrMl3mF6Pf/u1sKcpq9sEFNtOYQ
         lHtUXGY9MWicLJKfjM1Ls/YImwh4AnLD92Pv+AH1ujw6xtgM6yLcS1RihKCBnR11EstO
         ULvwoq3XzsxVivpxeLH/TWl8UIXS/QXaTxJ98tgzoWadiKti8ctxYv+iFtGWo5oedO2/
         BWp0v3h/NLueTBfLlyaVlK7GI5IfiMpZyB6ot3cO+SosQ/njwC4xJ1+Eco6tsVOo4rxu
         6TnmdwU2FI11v8O2/J1rrZo/wyjA5VyY6f6VbBOFPrcoNkXR3dG1HW4qE1WXitf0PG+b
         gBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8Y5aNd44J9eyb5XFaYXY8MOrjirh66aa5xiLVDvzzDo=;
        b=ewXeQph7qjzh17URYpUrQrByN2IWF6DR8mfv97ZqW9CoqZ2X2d3xlcLt+SSl77r0aQ
         93BQrADbgVIXihe7cJYctsDk5nXT0LGCKTDhjuur1de1D1a9eWMRgaynbybgR4bH/Kbt
         dqCfbH5hKo1T2rgj+TZKR1ymBfkzMmuLPaKTNYce/Skdzp8Za79g/+XV6gjUyMxGMoKh
         E4Img5qcz9ozSwcy+kh7M0c+cbcMbt6ME0+EdK0nSH4/UNfWjQhX0qVcJg4NQ85qvjzJ
         P+Cf/itRMgpbCiFoOapmE4hdrHrAM0jrPy8OVvcKKbdQwYWpgYWL4H/ZHxIpMzRfpYXx
         vNOw==
X-Gm-Message-State: AGi0PubpItHrYWgbQxd8Zmtd5iTepAiz8ofATjITVmNPXOQ9WxTUavwh
        m0+dzroz29JzdEW/fPMQalaT8cqF45TjJw==
X-Google-Smtp-Source: APiQypJ3LOAN51rDOJAYNXhmdlK3yusWBWFdO4xuslkrNKo4MoL+5Zb9CNrpbfQxt7UlL31hyRgG9oo7gRWxRA==
X-Received: by 2002:a5b:b92:: with SMTP id l18mr6776515ybq.7.1588342064169;
 Fri, 01 May 2020 07:07:44 -0700 (PDT)
Date:   Fri,  1 May 2020 07:07:41 -0700
Message-Id: <20200501140741.161104-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH v2 net-next] net_sched: sch_fq: add horizon attribute
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QUIC servers would like to use SO_TXTIME, without having CAP_NET_ADMIN,
to efficiently pace UDP packets.

As far as sch_fq is concerned, we need to add safety checks, so
that a buggy application does not fill the qdisc with packets
having delivery time far in the future.

This patch adds a configurable horizon (default: 10 seconds),
and a configurable policy when a packet is beyond the horizon
at enqueue() time:
- either drop the packet (default policy)
- or cap its delivery time to the horizon.

$ tc -s -d qd sh dev eth0
qdisc fq 8022: root refcnt 257 limit 10000p flow_limit 100p buckets 1024
 orphan_mask 1023 quantum 10Kb initial_quantum 51160b low_rate_threshold 550Kbit
 refill_delay 40.0ms timer_slack 10.000us horizon 10.000s
 Sent 1234215879 bytes 837099 pkt (dropped 21, overlimits 0 requeues 6)
 backlog 0b 0p requeues 6
  flows 1191 (inactive 1177 throttled 0)
  gc 0 highprio 0 throttled 692 latency 11.480us
  pkts_too_long 0 alloc_errors 0 horizon_drops 21 horizon_caps 0

v2: fixed an overflow on 32bit kernels in fq_init(), reported
    by kbuild test robot <lkp@intel.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 include/uapi/linux/pkt_sched.h |  6 ++++
 net/sched/sch_fq.c             | 59 +++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 0c02737c8f47921b807e52d6482ca9ff84e89268..a95f3ae7ab37c857ff09cba39eca65fea9ce92aa 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -913,6 +913,10 @@ enum {
 
 	TCA_FQ_TIMER_SLACK,	/* timer slack */
 
+	TCA_FQ_HORIZON,		/* time horizon in us */
+
+	TCA_FQ_HORIZON_DROP,	/* drop packets beyond horizon, or cap their EDT */
+
 	__TCA_FQ_MAX
 };
 
@@ -932,6 +936,8 @@ struct tc_fq_qd_stats {
 	__u32	throttled_flows;
 	__u32	unthrottle_latency_ns;
 	__u64	ce_mark;		/* packets above ce_threshold */
+	__u64	horizon_drops;
+	__u64	horizon_caps;
 };
 
 /* Heavy-Hitter Filter */
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 4c060134c7362dcf0d049404cc65066d2c95cb90..fa228df22e5dbf3fb5eb18279b79ab397d36ac58 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -95,6 +95,7 @@ struct fq_sched_data {
 
 	struct rb_root	delayed;	/* for rate limited flows */
 	u64		time_next_delayed_flow;
+	u64		ktime_cache;	/* copy of last ktime_get_ns() */
 	unsigned long	unthrottle_latency_ns;
 
 	struct fq_flow	internal;	/* for non classified or high prio packets */
@@ -104,12 +105,13 @@ struct fq_sched_data {
 	u32		flow_plimit;	/* max packets per flow */
 	unsigned long	flow_max_rate;	/* optional max rate per flow */
 	u64		ce_threshold;
+	u64		horizon;	/* horizon in ns */
 	u32		orphan_mask;	/* mask for orphaned skb */
 	u32		low_rate_threshold;
 	struct rb_root	*fq_root;
 	u8		rate_enable;
 	u8		fq_trees_log;
-
+	u8		horizon_drop;
 	u32		flows;
 	u32		inactive_flows;
 	u32		throttled_flows;
@@ -118,6 +120,8 @@ struct fq_sched_data {
 	u64		stat_internal_packets;
 	u64		stat_throttled;
 	u64		stat_ce_mark;
+	u64		stat_horizon_drops;
+	u64		stat_horizon_caps;
 	u64		stat_flows_plimit;
 	u64		stat_pkts_too_long;
 	u64		stat_allocation_errors;
@@ -390,8 +394,6 @@ static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
 	struct rb_node **p, *parent;
 	struct sk_buff *head, *aux;
 
-	fq_skb_cb(skb)->time_to_send = skb->tstamp ?: ktime_get_ns();
-
 	head = flow->head;
 	if (!head ||
 	    fq_skb_cb(skb)->time_to_send >= fq_skb_cb(flow->tail)->time_to_send) {
@@ -419,6 +421,12 @@ static void flow_queue_add(struct fq_flow *flow, struct sk_buff *skb)
 	rb_insert_color(&skb->rbnode, &flow->t_root);
 }
 
+static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
+				    const struct fq_sched_data *q)
+{
+	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
+}
+
 static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		      struct sk_buff **to_free)
 {
@@ -428,6 +436,28 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (unlikely(sch->q.qlen >= sch->limit))
 		return qdisc_drop(skb, sch, to_free);
 
+	if (!skb->tstamp) {
+		fq_skb_cb(skb)->time_to_send = q->ktime_cache = ktime_get_ns();
+	} else {
+		/* Check if packet timestamp is too far in the future.
+		 * Try first if our cached value, to avoid ktime_get_ns()
+		 * cost in most cases.
+		 */
+		if (fq_packet_beyond_horizon(skb, q)) {
+			/* Refresh our cache and check another time */
+			q->ktime_cache = ktime_get_ns();
+			if (fq_packet_beyond_horizon(skb, q)) {
+				if (q->horizon_drop) {
+					q->stat_horizon_drops++;
+					return qdisc_drop(skb, sch, to_free);
+				}
+				q->stat_horizon_caps++;
+				skb->tstamp = q->ktime_cache + q->horizon;
+			}
+		}
+		fq_skb_cb(skb)->time_to_send = skb->tstamp;
+	}
+
 	f = fq_classify(skb, q);
 	if (unlikely(f->qlen >= q->flow_plimit && f != &q->internal)) {
 		q->stat_flows_plimit++;
@@ -498,7 +528,7 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 	if (skb)
 		goto out;
 
-	now = ktime_get_ns();
+	q->ktime_cache = now = ktime_get_ns();
 	fq_check_throttled(q, now);
 begin:
 	head = &q->new_flows;
@@ -753,6 +783,8 @@ static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
 	[TCA_FQ_LOW_RATE_THRESHOLD]	= { .type = NLA_U32 },
 	[TCA_FQ_CE_THRESHOLD]		= { .type = NLA_U32 },
 	[TCA_FQ_TIMER_SLACK]		= { .type = NLA_U32 },
+	[TCA_FQ_HORIZON]		= { .type = NLA_U32 },
+	[TCA_FQ_HORIZON_DROP]		= { .type = NLA_U8 },
 };
 
 static int fq_change(struct Qdisc *sch, struct nlattr *opt,
@@ -842,7 +874,15 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_FQ_TIMER_SLACK])
 		q->timer_slack = nla_get_u32(tb[TCA_FQ_TIMER_SLACK]);
 
+	if (tb[TCA_FQ_HORIZON])
+		q->horizon = (u64)NSEC_PER_USEC *
+				  nla_get_u32(tb[TCA_FQ_HORIZON]);
+
+	if (tb[TCA_FQ_HORIZON_DROP])
+		q->horizon_drop = nla_get_u8(tb[TCA_FQ_HORIZON_DROP]);
+
 	if (!err) {
+
 		sch_tree_unlock(sch);
 		err = fq_resize(sch, fq_log);
 		sch_tree_lock(sch);
@@ -895,6 +935,9 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt,
 
 	q->timer_slack = 10 * NSEC_PER_USEC; /* 10 usec of hrtimer slack */
 
+	q->horizon = 10ULL * NSEC_PER_SEC; /* 10 seconds */
+	q->horizon_drop = 1; /* by default, drop packets beyond horizon */
+
 	/* Default ce_threshold of 4294 seconds */
 	q->ce_threshold		= (u64)NSEC_PER_USEC * ~0U;
 
@@ -912,6 +955,7 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
 	u64 ce_threshold = q->ce_threshold;
+	u64 horizon = q->horizon;
 	struct nlattr *opts;
 
 	opts = nla_nest_start_noflag(skb, TCA_OPTIONS);
@@ -921,6 +965,7 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 	/* TCA_FQ_FLOW_DEFAULT_RATE is not used anymore */
 
 	do_div(ce_threshold, NSEC_PER_USEC);
+	do_div(horizon, NSEC_PER_USEC);
 
 	if (nla_put_u32(skb, TCA_FQ_PLIMIT, sch->limit) ||
 	    nla_put_u32(skb, TCA_FQ_FLOW_PLIMIT, q->flow_plimit) ||
@@ -936,7 +981,9 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 			q->low_rate_threshold) ||
 	    nla_put_u32(skb, TCA_FQ_CE_THRESHOLD, (u32)ce_threshold) ||
 	    nla_put_u32(skb, TCA_FQ_BUCKETS_LOG, q->fq_trees_log) ||
-	    nla_put_u32(skb, TCA_FQ_TIMER_SLACK, q->timer_slack))
+	    nla_put_u32(skb, TCA_FQ_TIMER_SLACK, q->timer_slack) ||
+	    nla_put_u32(skb, TCA_FQ_HORIZON, (u32)horizon) ||
+	    nla_put_u8(skb, TCA_FQ_HORIZON_DROP, q->horizon_drop))
 		goto nla_put_failure;
 
 	return nla_nest_end(skb, opts);
@@ -967,6 +1014,8 @@ static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.unthrottle_latency_ns  = min_t(unsigned long,
 					  q->unthrottle_latency_ns, ~0U);
 	st.ce_mark		  = q->stat_ce_mark;
+	st.horizon_drops	  = q->stat_horizon_drops;
+	st.horizon_caps		  = q->stat_horizon_caps;
 	sch_tree_unlock(sch);
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
-- 
2.26.2.526.g744177e7f7-goog

