Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A717F1C0DE4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEAFvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAFvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:51:49 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F0C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:51:49 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h186so9080921qkc.22
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uiRZQgq3cHo/fQOihPiB8gZr2uU08kOHBO4Un/VpiZo=;
        b=QMg299Ska6l7ONhNDI+0vyNJi0JRK5xqytkdjxUgLaJUdU47U4scVbG2vz0ngNJYtH
         nBMqSRu8zc5f39vML23jC1DM/KKjHbltqkzzdTnjRWHqaLAE/RBAlhZu8BAyNrzA7DH8
         GvOVhK+AAEbconRNQZLzjvtRWbIdjY3Vv+qN4MZCBWRsUD7YBew6wNideoRzY9ffNlo0
         ZfRLnVa9UA+Nx3lAWCi8sHu4RDN9V9CYHSddd45UFUcWHB4+gDZVRyfBdOQfJdM5Goas
         1ijjLCYGOv9t+pNHE/+fjN6JX2tLMqX+8//C+zhJ0KWqMsjxZHT64m3zFhc1lWViKbmf
         2MKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uiRZQgq3cHo/fQOihPiB8gZr2uU08kOHBO4Un/VpiZo=;
        b=WS0VnoHwNSyJwXi1AZipDEcedixAWh+qaGFapUPxBftHhxp7hK3hpHe+VyLcg+eMGj
         3JlZquZERDddj4dpeikA+1MfagdmHaLkkOjjWCiCpMSzeVz1WHqqQA0c9I3fRx1tjkGp
         4ckzEduyomjENmrRXpGd6Y5NQ2I2G9f8DB91E0nnLPuOusOuYBdKuubClPPZzc3L2ny1
         6MQwxMoLGrTINeyivhPQn/okJgikUcNSPSjW+tfKmGp5pbN3yB5NcDtZtcv8EfBR0QcN
         Kdcwfduca7f+qCymdLe5I+FytUvFe648miGEj1sPWRdJP17FGbeiVEY7l67mpeCvG/21
         HRRw==
X-Gm-Message-State: AGi0Pua2FLgkqUw/OA3yotjinwf4eeAVGkcu5Z2VRwup0T3E+iqE33VD
        x0lKHNqegVcX9KaDtGT78Lc4AEvjm7Iqaw==
X-Google-Smtp-Source: APiQypL23JFEgu62GPaWw5ly6jTh04lGP3Kbg1A6s/LFgAjX8lGv5PfIJBOG2VElu7Z9RPiTI2ZSsiBLEPHZ+A==
X-Received: by 2002:ad4:46b4:: with SMTP id br20mr2538398qvb.62.1588312308648;
 Thu, 30 Apr 2020 22:51:48 -0700 (PDT)
Date:   Thu, 30 Apr 2020 22:51:44 -0700
Message-Id: <20200501055144.24346-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next] net_sched: sch_fq: add horizon attribute
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
 Sent 1234215879 bytes 837099 pkt (dropped 0, overlimits 0 requeues 6)
 backlog 0b 0p requeues 6
  flows 1191 (inactive 1177 throttled 0)
  gc 0 highprio 0 throttled 692 latency 11.480us
  pkts_too_long 0 alloc_errors 0 horizon_drops 21 horizon_caps 0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 include/uapi/linux/pkt_sched.h |  6 ++++
 net/sched/sch_fq.c             | 59 +++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 0c02737c8f47921b807e52d6482ca9ff84e89268..b1acdd246cf90c9865b62eeb8a0f6735e66cb8e7 100644
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
index 4c060134c7362dcf0d049404cc65066d2c95cb90..7653b65598c48ced6127853b171b802046a317b2 100644
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
 
+	q->horizon = 10 * NSEC_PER_SEC; /* 10 seconds */
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

