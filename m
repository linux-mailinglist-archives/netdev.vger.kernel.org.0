Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12575145732
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAVNxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:53:16 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41168 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726099AbgAVNxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:53:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Jan 2020 15:53:04 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00MDr4f8013119;
        Wed, 22 Jan 2020 15:53:04 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v2 01/13] net: sched: support skb chain ext in tc classification path
Date:   Wed, 22 Jan 2020 15:52:46 +0200
Message-Id: <1579701178-24624-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To handle the case where we offload tc chains, and might have a miss in
hardware after jumping to some chain, we would want to continue in the
correct chain in software and not start classification again. Tc
classification will start from the chain that is specified in the
TC_SKB_EXT skb extension which can be set by drivers.

Implement tcf_classify_ingress() wrapper that lookups the first tp on chain
specified by skb extension and calls tcf_classify() with the result. The
wrapper implementation requires obtaining ingress queue block and a helper
function to lookup chain by id on the ingress block. Implement the required
functions in following way:

- Extend tcf_chain_head_change_t function typedef with additional tcf_block
argument and modify mini_Qdisc to include pointer to tcf_block. Set block
pointer passed as an argument to ingress chain head change callback as
mini_Qdisc->block and read it in tcf_classify_ingress() to obtain ingress
block.

- In order to allow searching for chain by index from atomic context,
implement tcf_chain_lookup_rcu() that lookups chain by index under rcu
read lock protection. Change tcf_block->chain_list type to rcu list to
allow tcf_chain_lookup_rcu() implementation. Use this new helper to
obtain chain by index from ingress block in tcf_classify_ingress().

Pass tp list of chain obtained by new functionality described in previous
paragraph to tcf_classify(). Extend tcf_classify() with 'orig_tp' argument
which is used to correctly implement TC_ACT_RECLASSIFY action when tp was
substituted by tcf_classify_ingress() according to skb chain extension.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h     | 17 ++++++++++++-
 include/net/sch_generic.h |  6 +++--
 net/core/dev.c            |  6 +++--
 net/sched/cls_api.c       | 64 ++++++++++++++++++++++++++++++++++++++++-------
 net/sched/sch_atm.c       |  2 +-
 net/sched/sch_cake.c      |  2 +-
 net/sched/sch_cbq.c       |  2 +-
 net/sched/sch_drr.c       |  2 +-
 net/sched/sch_dsmark.c    |  2 +-
 net/sched/sch_fq_codel.c  |  2 +-
 net/sched/sch_generic.c   |  3 ++-
 net/sched/sch_hfsc.c      |  3 ++-
 net/sched/sch_htb.c       |  3 ++-
 net/sched/sch_ingress.c   |  5 ++--
 net/sched/sch_multiq.c    |  2 +-
 net/sched/sch_prio.c      |  2 +-
 net/sched/sch_qfq.c       |  2 +-
 net/sched/sch_sfb.c       |  2 +-
 net/sched/sch_sfq.c       |  2 +-
 19 files changed, 99 insertions(+), 30 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 47b115e..b2fe323 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -71,7 +71,12 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 }
 
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		 struct tcf_result *res, bool compat_mode);
+		 const struct tcf_proto *orig_tp, struct tcf_result *res,
+		 bool compat_mode);
+int tcf_classify_ingress(struct sk_buff *skb,
+			 const struct tcf_block *ingress_block,
+			 const struct tcf_proto *tp, struct tcf_result *res,
+			 bool compat_mode);
 
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
@@ -129,10 +134,20 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, flow_setup_cb_t *cb,
 }
 
 static inline int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+			       const struct tcf_proto *orig_tp,
 			       struct tcf_result *res, bool compat_mode)
 {
 	return TC_ACT_UNSPEC;
 }
+
+static inline int tcf_classify_ingress(struct sk_buff *skb,
+				       const struct tcf_block *ingress_block,
+				       const struct tcf_proto *tp,
+				       struct tcf_result *res, bool compat_mode)
+{
+	return TC_ACT_UNSPEC;
+}
+
 #endif
 
 static inline unsigned long
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fceddf8..d86bba1 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -381,7 +381,8 @@ struct qdisc_skb_cb {
 	unsigned char		data[QDISC_CB_PRIV_LEN];
 };
 
-typedef void tcf_chain_head_change_t(struct tcf_proto *tp_head, void *priv);
+typedef void tcf_chain_head_change_t(struct tcf_block *block,
+				     struct tcf_proto *tp_head, void *priv);
 
 struct tcf_chain {
 	/* Protects filter_chain. */
@@ -1268,6 +1269,7 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
  */
 struct mini_Qdisc {
 	struct tcf_proto *filter_list;
+	struct tcf_block *block;
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
 	struct rcu_head rcu;
@@ -1291,7 +1293,7 @@ struct mini_Qdisc_pair {
 };
 
 void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
-			  struct tcf_proto *tp_head);
+			  struct tcf_block *block, struct tcf_proto *tp_head);
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 6368c94..214a5dfd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3743,7 +3743,8 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
+	switch (tcf_classify(skb, miniq->filter_list, miniq->filter_list,
+			     &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
@@ -4810,7 +4811,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 	skb->tc_at_ingress = 1;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
-	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
+	switch (tcf_classify_ingress(skb, miniq->block, miniq->filter_list,
+				     &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 76e0d12..b5314af 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -22,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/rculist.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -354,7 +355,7 @@ static struct tcf_chain *tcf_chain_create(struct tcf_block *block,
 	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 	if (!chain)
 		return NULL;
-	list_add_tail(&chain->list, &block->chain_list);
+	list_add_tail_rcu(&chain->list, &block->chain_list);
 	mutex_init(&chain->filter_chain_lock);
 	chain->block = block;
 	chain->index = chain_index;
@@ -365,10 +366,12 @@ static struct tcf_chain *tcf_chain_create(struct tcf_block *block,
 }
 
 static void tcf_chain_head_change_item(struct tcf_filter_chain_list_item *item,
+				       struct tcf_block *block,
 				       struct tcf_proto *tp_head)
 {
 	if (item->chain_head_change)
-		item->chain_head_change(tp_head, item->chain_head_change_priv);
+		item->chain_head_change(block, tp_head,
+					item->chain_head_change_priv);
 }
 
 static void tcf_chain0_head_change(struct tcf_chain *chain,
@@ -382,7 +385,7 @@ static void tcf_chain0_head_change(struct tcf_chain *chain,
 
 	mutex_lock(&block->lock);
 	list_for_each_entry(item, &block->chain0.filter_chain_list, list)
-		tcf_chain_head_change_item(item, tp_head);
+		tcf_chain_head_change_item(item, block, tp_head);
 	mutex_unlock(&block->lock);
 }
 
@@ -394,7 +397,7 @@ static bool tcf_chain_detach(struct tcf_chain *chain)
 
 	ASSERT_BLOCK_LOCKED(block);
 
-	list_del(&chain->list);
+	list_del_rcu(&chain->list);
 	if (!chain->index)
 		block->chain0.chain = NULL;
 
@@ -453,6 +456,20 @@ static struct tcf_chain *tcf_chain_lookup(struct tcf_block *block,
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
 
@@ -822,7 +839,7 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 
 		tp_head = tcf_chain_dereference(chain0->filter_chain, chain0);
 		if (tp_head)
-			tcf_chain_head_change_item(item, tp_head);
+			tcf_chain_head_change_item(item, block, tp_head);
 
 		mutex_lock(&block->lock);
 		list_add(&item->list, &block->chain0.filter_chain_list);
@@ -847,7 +864,7 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 		    (item->chain_head_change == ei->chain_head_change &&
 		     item->chain_head_change_priv == ei->chain_head_change_priv)) {
 			if (block->chain0.chain)
-				tcf_chain_head_change_item(item, NULL);
+				tcf_chain_head_change_item(item, NULL, NULL);
 			list_del(&item->list);
 			mutex_unlock(&block->lock);
 
@@ -1384,7 +1401,8 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
 }
 EXPORT_SYMBOL(tcf_block_get_ext);
 
-static void tcf_chain_head_change_dflt(struct tcf_proto *tp_head, void *priv)
+static void tcf_chain_head_change_dflt(struct tcf_block *block,
+				       struct tcf_proto *tp_head, void *priv)
 {
 	struct tcf_proto __rcu **p_filter_chain = priv;
 
@@ -1560,11 +1578,11 @@ static int tcf_block_setup(struct tcf_block *block,
  * specific classifiers.
  */
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-		 struct tcf_result *res, bool compat_mode)
+		 const struct tcf_proto *orig_tp, struct tcf_result *res,
+		 bool compat_mode)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	const int max_reclassify_loop = 4;
-	const struct tcf_proto *orig_tp = tp;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
@@ -1621,6 +1639,34 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tcf_classify);
 
+int tcf_classify_ingress(struct sk_buff *skb,
+			 const struct tcf_block *ingress_block,
+			 const struct tcf_proto *tp, struct tcf_result *res,
+			 bool compat_mode)
+{
+	const struct tcf_proto *orig_tp = tp;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	{
+		struct tc_skb_ext *ext = skb_ext_find(skb, TC_SKB_EXT);
+
+		if (ext && ext->chain && ingress_block) {
+			struct tcf_chain *fchain;
+
+			fchain = tcf_chain_lookup_rcu(ingress_block,
+						      ext->chain);
+			if (!fchain)
+				return TC_ACT_UNSPEC;
+
+			tp = rcu_dereference_bh(fchain->filter_chain);
+		}
+	}
+#endif
+
+	return tcf_classify(skb, tp, orig_tp, res, compat_mode);
+}
+EXPORT_SYMBOL(tcf_classify_ingress);
+
 struct tcf_chain_info {
 	struct tcf_proto __rcu **pprev;
 	struct tcf_proto __rcu *next;
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index f4f9b8c..f01d5881 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -393,7 +393,7 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		list_for_each_entry(flow, &p->flows, list) {
 			fl = rcu_dereference_bh(flow->filter_list);
 			if (fl) {
-				result = tcf_classify(skb, fl, &res, true);
+				result = tcf_classify(skb, fl, fl, &res, true);
 				if (result < 0)
 					continue;
 				flow = (struct atm_flow_data *)res.class;
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 1496e87..d7c9ae7 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1600,7 +1600,7 @@ static u32 cake_classify(struct Qdisc *sch, struct cake_tin_data **t,
 		goto hash;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, filter, &res, false);
+	result = tcf_classify(skb, filter, filter, &res, false);
 
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 39b427d..06670b4 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -228,7 +228,7 @@ struct cbq_sched_data {
 		/*
 		 * Step 2+n. Apply classifier.
 		 */
-		result = tcf_classify(skb, fl, &res, true);
+		result = tcf_classify(skb, fl, fl, &res, true);
 		if (!fl || result < 0)
 			goto fallback;
 
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 07a2b0b..cf4dc9a 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -316,7 +316,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, fl, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 05605b3..75cbe92 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -241,7 +241,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	else {
 		struct tcf_result res;
 		struct tcf_proto *fl = rcu_dereference_bh(p->filter_list);
-		int result = tcf_classify(skb, fl, &res, false);
+		int result = tcf_classify(skb, fl, fl, &res, false);
 
 		pr_debug("result %d class 0x%04x\n", result, res.classid);
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 968519f..2229720 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -91,7 +91,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return fq_codel_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, filter, &res, false);
+	result = tcf_classify(skb, filter, filter, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6c9595f..1bfddc4 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1355,7 +1355,7 @@ static void mini_qdisc_rcu_func(struct rcu_head *head)
 }
 
 void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
-			  struct tcf_proto *tp_head)
+			  struct tcf_block *block, struct tcf_proto *tp_head)
 {
 	/* Protected with chain0->filter_chain_lock.
 	 * Can't access chain directly because tp_head can be NULL.
@@ -1380,6 +1380,7 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 	 */
 	rcu_barrier();
 	miniq->filter_list = tp_head;
+	miniq->block = block;
 	rcu_assign_pointer(*miniqp->p_miniq, miniq);
 
 	if (miniq_old)
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 433f219..317a864 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1129,7 +1129,8 @@ struct hfsc_sched {
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	head = &q->root;
 	tcf = rcu_dereference_bh(q->root.filter_list);
-	while (tcf && (result = tcf_classify(skb, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify(skb, tcf, tcf, &res, false))
+	       >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8184c87..124b1b0 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -232,7 +232,8 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	while (tcf && (result = tcf_classify(skb, tcf, &res, false)) >= 0) {
+	while (tcf && (result = tcf_classify(skb, tcf, tcf, &res, false))
+	       >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index bf56aa5..5b0fe98 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -52,11 +52,12 @@ static struct tcf_block *ingress_tcf_block(struct Qdisc *sch, unsigned long cl,
 	return q->block;
 }
 
-static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)
+static void clsact_chain_head_change(struct tcf_block *block,
+				     struct tcf_proto *tp_head, void *priv)
 {
 	struct mini_Qdisc_pair *miniqp = priv;
 
-	mini_qdisc_pair_swap(miniqp, tp_head);
+	mini_qdisc_pair_swap(miniqp, block, tp_head);
 };
 
 static void ingress_ingress_block_set(struct Qdisc *sch, u32 block_index)
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 1330ad2..f2ca000 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -36,7 +36,7 @@ struct multiq_sched_data {
 	int err;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	err = tcf_classify(skb, fl, &res, false);
+	err = tcf_classify(skb, fl, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 	switch (err) {
 	case TC_ACT_STOLEN:
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 6479417..a28d05a 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -39,7 +39,7 @@ struct prio_sched_data {
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	if (TC_H_MAJ(skb->priority) != sch->handle) {
 		fl = rcu_dereference_bh(q->filter_list);
-		err = tcf_classify(skb, fl, &res, false);
+		err = tcf_classify(skb, fl, fl, &res, false);
 #ifdef CONFIG_NET_CLS_ACT
 		switch (err) {
 		case TC_ACT_STOLEN:
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 0b05ac7..e2033e5 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -691,7 +691,7 @@ static struct qfq_class *qfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	fl = rcu_dereference_bh(q->filter_list);
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, fl, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 4074c50..63672f3 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -257,7 +257,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 	struct tcf_result res;
 	int result;
 
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, fl, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index c787d4d..8763f09 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -178,7 +178,7 @@ static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		return sfq_hash(q, skb) + 1;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
-	result = tcf_classify(skb, fl, &res, false);
+	result = tcf_classify(skb, fl, fl, &res, false);
 	if (result >= 0) {
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
-- 
1.8.3.1

