Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32C7160340
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBPKBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:48 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52945 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726787AbgBPKBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:46 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:38 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1cdv007834;
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
Subject: [PATCH net-next v3 01/16] net: sched: Introduce ingress classification function
Date:   Sun, 16 Feb 2020 12:01:21 +0200
Message-Id: <1581847296-19194-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC multi chain configuration can cause offloaded tc chains to miss in
hardware after jumping to some chain. In such cases the software should
continue from the chain that missed in hardware, as the hardware may
have manipulated the packet and updated some counters.

Currently a single tcf classification function serves both ingress and
egress. However, multi chain miss processing (get tc skb extension on
hw miss, set tc skb extension on tc miss) should happen only on
ingress.

Refactor the code to use ingress classification function, and move setting
the tc skb extension from general classification to it, as a prestep
for supporting the hw miss scenario.

Co-developed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Changelog:
   v2->v3
       Split from v2 first patch
       Defined tcf_classify_ingress so we only affect ingress classification
       Move setting the skb extension to ingress classification
       
 include/net/pkt_cls.h | 10 +++++++++
 net/core/dev.c        |  3 ++-
 net/sched/cls_api.c   | 58 ++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a972244..3d51a2d 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -72,6 +72,8 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
+int tcf_classify_ingress(struct sk_buff *skb, const struct tcf_proto *tp,
+			 struct tcf_result *res, bool compat_mode);
 
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
@@ -133,6 +135,14 @@ static inline int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 {
 	return TC_ACT_UNSPEC;
 }
+
+static inline int tcf_classify_ingress(struct sk_buff *skb,
+				       const struct tcf_proto *tp,
+				       struct tcf_result *res, bool compat_mode)
+{
+	return TC_ACT_UNSPEC;
+}
+
 #endif
 
 static inline unsigned long
diff --git a/net/core/dev.c b/net/core/dev.c
index a6316b3..107af00 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4860,7 +4860,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
+	switch (tcf_classify_ingress(skb, miniq->filter_list, &cl_res,
+				     false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c2cdd0f..7652e0e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1559,8 +1559,11 @@ static int tcf_block_setup(struct tcf_block *block,
  * to this qdisc, (optionally) tests for protocol and asks
  * specific classifiers.
  */
-int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		 struct tcf_result *res, bool compat_mode)
+static inline int __tcf_classify(struct sk_buff *skb,
+				 const struct tcf_proto *tp,
+				 struct tcf_result *res,
+				 bool compat_mode,
+				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	const int max_reclassify_loop = 4;
@@ -1582,21 +1585,11 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 #ifdef CONFIG_NET_CLS_ACT
 		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
 			first_tp = orig_tp;
+			*last_executed_chain = first_tp->chain->index;
 			goto reset;
 		} else if (unlikely(TC_ACT_EXT_CMP(err, TC_ACT_GOTO_CHAIN))) {
 			first_tp = res->goto_tp;
-
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-			{
-				struct tc_skb_ext *ext;
-
-				ext = skb_ext_add(skb, TC_SKB_EXT);
-				if (WARN_ON_ONCE(!ext))
-					return TC_ACT_SHOT;
-
-				ext->chain = err & TC_ACT_EXT_VAL_MASK;
-			}
-#endif
+			*last_executed_chain = err & TC_ACT_EXT_VAL_MASK;
 			goto reset;
 		}
 #endif
@@ -1619,8 +1612,45 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	goto reclassify;
 #endif
 }
+
+int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+		 struct tcf_result *res, bool compat_mode)
+{
+	u32 last_executed_chain = 0;
+
+	return __tcf_classify(skb, tp, res, compat_mode,
+			      &last_executed_chain);
+}
 EXPORT_SYMBOL(tcf_classify);
 
+int tcf_classify_ingress(struct sk_buff *skb, const struct tcf_proto *tp,
+			 struct tcf_result *res, bool compat_mode)
+{
+#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	u32 last_executed_chain = 0;
+
+	return __tcf_classify(skb, tp, res, compat_mode,
+			      &last_executed_chain);
+#else
+	u32 last_executed_chain = tp ? tp->chain->index : 0;
+	struct tc_skb_ext *ext;
+	int ret;
+
+	ret = __tcf_classify(skb, tp, res, compat_mode, &last_executed_chain);
+
+	/* If we missed on some chain */
+	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
+		ext = skb_ext_add(skb, TC_SKB_EXT);
+		if (WARN_ON_ONCE(!ext))
+			return TC_ACT_SHOT;
+		ext->chain = last_executed_chain;
+	}
+
+	return ret;
+#endif
+}
+EXPORT_SYMBOL(tcf_classify_ingress);
+
 struct tcf_chain_info {
 	struct tcf_proto __rcu **pprev;
 	struct tcf_proto __rcu *next;
-- 
1.8.3.1

