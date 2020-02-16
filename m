Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619D1160343
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgBPKBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:52 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44747 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726037AbgBPKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:47 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1cdw007834;
        Sun, 16 Feb 2020 12:01:38 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 02/16] net: sched: Pass ingress block to tcf_classify_ingress
Date:   Sun, 16 Feb 2020 12:01:22 +0200
Message-Id: <1581847296-19194-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ingress and cls_act qdiscs init, save the block on ingress
mini_Qdisc and and pass it on to ingress classification, so it
can be used for the looking up a specified chain index.

Co-developed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Changelog:
   v2->v3
       Split from v2 first patch
       Init mini qdisc pairs' block on ingress/cls_act qdiscs init instead of head chain

 include/net/pkt_cls.h     |  7 +++++--
 include/net/sch_generic.h |  3 +++
 net/core/dev.c            |  4 ++--
 net/sched/cls_api.c       |  4 +++-
 net/sched/sch_generic.c   |  8 ++++++++
 net/sched/sch_ingress.c   | 11 ++++++++++-
 6 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 3d51a2d..3595ec5 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -72,8 +72,10 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
-int tcf_classify_ingress(struct sk_buff *skb, const struct tcf_proto *tp,
-			 struct tcf_result *res, bool compat_mode);
+int tcf_classify_ingress(struct sk_buff *skb,
+			 const struct tcf_block *ingress_block,
+			 const struct tcf_proto *tp, struct tcf_result *res,
+			 bool compat_mode);
 
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
@@ -137,6 +139,7 @@ static inline int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 }
 
 static inline int tcf_classify_ingress(struct sk_buff *skb,
+				       const struct tcf_block *ingress_block,
 				       const struct tcf_proto *tp,
 				       struct tcf_result *res, bool compat_mode)
 {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1512087..bcdf98d 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1269,6 +1269,7 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
  */
 struct mini_Qdisc {
 	struct tcf_proto *filter_list;
+	struct tcf_block *block;
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
 	struct rcu_head rcu;
@@ -1295,6 +1296,8 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 			  struct tcf_proto *tp_head);
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq);
+void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
+				struct tcf_block *block);
 
 static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 107af00..4866e61 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4860,8 +4860,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify_ingress(skb, miniq->filter_list, &cl_res,
-				     false)) {
+	switch (tcf_classify_ingress(skb, miniq->block, miniq->filter_list,
+				     &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 7652e0e..0a29747 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1623,7 +1623,9 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tcf_classify);
 
-int tcf_classify_ingress(struct sk_buff *skb, const struct tcf_proto *tp,
+int tcf_classify_ingress(struct sk_buff *skb,
+			 const struct tcf_block *ingress_block,
+			 const struct tcf_proto *tp,
 			 struct tcf_result *res, bool compat_mode)
 {
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6c9595f..2efd5b6 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1391,6 +1391,14 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 }
 EXPORT_SYMBOL(mini_qdisc_pair_swap);
 
+void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
+				struct tcf_block *block)
+{
+	miniqp->miniq1.block = block;
+	miniqp->miniq2.block = block;
+}
+EXPORT_SYMBOL(mini_qdisc_pair_block_init);
+
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq)
 {
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index bf56aa5..8483812 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -78,6 +78,7 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	int err;
 
 	net_inc_ingress_queue();
 
@@ -87,7 +88,13 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 	q->block_info.chain_head_change = clsact_chain_head_change;
 	q->block_info.chain_head_change_priv = &q->miniqp;
 
-	return tcf_block_get_ext(&q->block, sch, &q->block_info, extack);
+	err = tcf_block_get_ext(&q->block, sch, &q->block_info, extack);
+	if (err)
+		return err;
+
+	mini_qdisc_pair_block_init(&q->miniqp, q->block);
+
+	return 0;
 }
 
 static void ingress_destroy(struct Qdisc *sch)
@@ -226,6 +233,8 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
+	mini_qdisc_pair_block_init(&q->miniqp_ingress, q->ingress_block);
+
 	mini_qdisc_pair_init(&q->miniqp_egress, sch, &dev->miniq_egress);
 
 	q->egress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS;
-- 
1.8.3.1

