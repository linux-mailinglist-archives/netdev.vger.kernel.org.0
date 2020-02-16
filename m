Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4644816034D
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgBPKBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44749 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726020AbgBPKBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce0007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 04/16] net: sched: Support specifying a starting chain via tc skb ext
Date:   Sun, 16 Feb 2020 12:01:24 +0200
Message-Id: <1581847296-19194-5-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the starting chain from the tc skb ext chain value. Once we read
the tc skb ext, delete it, so cloned/redirect packets won't inherit it.

In order to lookup a chain by the chain index on the ingress block
at ingress classification, provide a lookup function.

Co-developed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Changelog:
   v2->v3
       Split from v2 first patch
       Do skb extension processing for ingress classification only
       Consume skb extension

 net/sched/cls_api.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 79c4503..5331ad3 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -454,6 +454,20 @@ static struct tcf_chain *tcf_chain_lookup(struct tcf_block *block,
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+static struct tcf_chain *tcf_chain_lookup_rcu(const struct tcf_block *block,
+					      u32 chain_index)
+{
+	struct tcf_chain *chain;
+
+	list_for_each_entry_rcu(chain, &block->chain_list, list) {
+		if (chain->index == chain_index)
+			return chain;
+	}
+	return NULL;
+}
+#endif
+
 static int tc_chain_notify(struct tcf_chain *chain, struct sk_buff *oskb,
 			   u32 seq, u16 flags, int event, bool unicast);
 
@@ -1562,13 +1576,13 @@ static int tcf_block_setup(struct tcf_block *block,
  */
 static inline int __tcf_classify(struct sk_buff *skb,
 				 const struct tcf_proto *tp,
+				 const struct tcf_proto *orig_tp,
 				 struct tcf_result *res,
 				 bool compat_mode,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	const int max_reclassify_loop = 4;
-	const struct tcf_proto *orig_tp = tp;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
@@ -1619,7 +1633,7 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 {
 	u32 last_executed_chain = 0;
 
-	return __tcf_classify(skb, tp, res, compat_mode,
+	return __tcf_classify(skb, tp, tp, res, compat_mode,
 			      &last_executed_chain);
 }
 EXPORT_SYMBOL(tcf_classify);
@@ -1632,14 +1646,31 @@ int tcf_classify_ingress(struct sk_buff *skb,
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 last_executed_chain = 0;
 
-	return __tcf_classify(skb, tp, res, compat_mode,
+	return __tcf_classify(skb, tp, tp, res, compat_mode,
 			      &last_executed_chain);
 #else
 	u32 last_executed_chain = tp ? tp->chain->index : 0;
+	const struct tcf_proto *orig_tp = tp;
 	struct tc_skb_ext *ext;
 	int ret;
 
-	ret = __tcf_classify(skb, tp, res, compat_mode, &last_executed_chain);
+	ext = skb_ext_find(skb, TC_SKB_EXT);
+
+	if (ext && ext->chain) {
+		struct tcf_chain *fchain;
+
+		fchain = tcf_chain_lookup_rcu(ingress_block, ext->chain);
+		if (!fchain)
+			return TC_ACT_SHOT;
+
+		/* Consume, so cloned/redirect skbs won't inherit ext */
+		skb_ext_del(skb, TC_SKB_EXT);
+
+		tp = rcu_dereference_bh(fchain->filter_chain);
+	}
+
+	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
+			     &last_executed_chain);
 
 	/* If we missed on some chain */
 	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
-- 
1.8.3.1

