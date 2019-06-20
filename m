Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878774DA93
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfFTTtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:39 -0400
Received: from mail.us.es ([193.147.175.20]:53894 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfFTTti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDB5DB6B98
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9AD2DA70E
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8912DA70B; Thu, 20 Jun 2019 21:49:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2523FDA705;
        Thu, 20 Jun 2019 21:49:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E415D4265A2F;
        Thu, 20 Jun 2019 21:49:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 01/12] net: sched: move tcf_block_cb before indr_block
Date:   Thu, 20 Jun 2019 21:49:06 +0200
Message-Id: <20190620194917.2298-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The indr_block infrastructure will depend on the tcf_block_cb object,
move this code on top to avoid forward declarations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/cls_api.c | 484 ++++++++++++++++++++++++++--------------------------
 1 file changed, 242 insertions(+), 242 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ad36bbcc583e..b2417fda26ec 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -565,6 +565,248 @@ static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
 	return cops->tcf_block(qdisc, TC_H_MIN_INGRESS, NULL);
 }
 
+static struct tcf_chain *
+__tcf_get_next_chain(struct tcf_block *block, struct tcf_chain *chain)
+{
+	mutex_lock(&block->lock);
+	if (chain)
+		chain = list_is_last(&chain->list, &block->chain_list) ?
+			NULL : list_next_entry(chain, list);
+	else
+		chain = list_first_entry_or_null(&block->chain_list,
+						 struct tcf_chain, list);
+
+	/* skip all action-only chains */
+	while (chain && tcf_chain_held_by_acts_only(chain))
+		chain = list_is_last(&chain->list, &block->chain_list) ?
+			NULL : list_next_entry(chain, list);
+
+	if (chain)
+		tcf_chain_hold(chain);
+	mutex_unlock(&block->lock);
+
+	return chain;
+}
+
+/* Function to be used by all clients that want to iterate over all chains on
+ * block. It properly obtains block->lock and takes reference to chain before
+ * returning it. Users of this function must be tolerant to concurrent chain
+ * insertion/deletion or ensure that no concurrent chain modification is
+ * possible. Note that all netlink dump callbacks cannot guarantee to provide
+ * consistent dump because rtnl lock is released each time skb is filled with
+ * data and sent to user-space.
+ */
+
+struct tcf_chain *
+tcf_get_next_chain(struct tcf_block *block, struct tcf_chain *chain)
+{
+	struct tcf_chain *chain_next = __tcf_get_next_chain(block, chain);
+
+	if (chain)
+		tcf_chain_put(chain);
+
+	return chain_next;
+}
+EXPORT_SYMBOL(tcf_get_next_chain);
+
+static struct tcf_proto *
+__tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	u32 prio = 0;
+
+	ASSERT_RTNL();
+	mutex_lock(&chain->filter_chain_lock);
+
+	if (!tp) {
+		tp = tcf_chain_dereference(chain->filter_chain, chain);
+	} else if (tcf_proto_is_deleting(tp)) {
+		/* 'deleting' flag is set and chain->filter_chain_lock was
+		 * unlocked, which means next pointer could be invalid. Restart
+		 * search.
+		 */
+		prio = tp->prio + 1;
+		tp = tcf_chain_dereference(chain->filter_chain, chain);
+
+		for (; tp; tp = tcf_chain_dereference(tp->next, chain))
+			if (!tp->deleting && tp->prio >= prio)
+				break;
+	} else {
+		tp = tcf_chain_dereference(tp->next, chain);
+	}
+
+	if (tp)
+		tcf_proto_get(tp);
+
+	mutex_unlock(&chain->filter_chain_lock);
+
+	return tp;
+}
+
+/* Function to be used by all clients that want to iterate over all tp's on
+ * chain. Users of this function must be tolerant to concurrent tp
+ * insertion/deletion or ensure that no concurrent chain modification is
+ * possible. Note that all netlink dump callbacks cannot guarantee to provide
+ * consistent dump because rtnl lock is released each time skb is filled with
+ * data and sent to user-space.
+ */
+
+struct tcf_proto *
+tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp,
+		   bool rtnl_held)
+{
+	struct tcf_proto *tp_next = __tcf_get_next_proto(chain, tp);
+
+	if (tp)
+		tcf_proto_put(tp, rtnl_held, NULL);
+
+	return tp_next;
+}
+EXPORT_SYMBOL(tcf_get_next_proto);
+
+static int
+tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
+			    void *cb_priv, bool add, bool offload_in_use,
+			    struct netlink_ext_ack *extack)
+{
+	struct tcf_chain *chain, *chain_prev;
+	struct tcf_proto *tp, *tp_prev;
+	int err;
+
+	for (chain = __tcf_get_next_chain(block, NULL);
+	     chain;
+	     chain_prev = chain,
+		     chain = __tcf_get_next_chain(block, chain),
+		     tcf_chain_put(chain_prev)) {
+		for (tp = __tcf_get_next_proto(chain, NULL); tp;
+		     tp_prev = tp,
+			     tp = __tcf_get_next_proto(chain, tp),
+			     tcf_proto_put(tp_prev, true, NULL)) {
+			if (tp->ops->reoffload) {
+				err = tp->ops->reoffload(tp, add, cb, cb_priv,
+							 extack);
+				if (err && add)
+					goto err_playback_remove;
+			} else if (add && offload_in_use) {
+				err = -EOPNOTSUPP;
+				NL_SET_ERR_MSG(extack, "Filter HW offload failed - classifier without re-offloading support");
+				goto err_playback_remove;
+			}
+		}
+	}
+
+	return 0;
+
+err_playback_remove:
+	tcf_proto_put(tp, true, NULL);
+	tcf_chain_put(chain);
+	tcf_block_playback_offloads(block, cb, cb_priv, false, offload_in_use,
+				    extack);
+	return err;
+}
+
+static bool tcf_block_offload_in_use(struct tcf_block *block)
+{
+	return block->offloadcnt;
+}
+
+struct tcf_block_cb {
+	struct list_head list;
+	tc_setup_cb_t *cb;
+	void *cb_ident;
+	void *cb_priv;
+	unsigned int refcnt;
+};
+
+void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
+{
+	return block_cb->cb_priv;
+}
+EXPORT_SYMBOL(tcf_block_cb_priv);
+
+struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
+					 tc_setup_cb_t *cb, void *cb_ident)
+{	struct tcf_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, &block->cb_list, list)
+		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
+			return block_cb;
+	return NULL;
+}
+EXPORT_SYMBOL(tcf_block_cb_lookup);
+
+void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
+{
+	block_cb->refcnt++;
+}
+EXPORT_SYMBOL(tcf_block_cb_incref);
+
+unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
+{
+	return --block_cb->refcnt;
+}
+EXPORT_SYMBOL(tcf_block_cb_decref);
+
+struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
+					     tc_setup_cb_t *cb, void *cb_ident,
+					     void *cb_priv,
+					     struct netlink_ext_ack *extack)
+{
+	struct tcf_block_cb *block_cb;
+	int err;
+
+	/* Replay any already present rules */
+	err = tcf_block_playback_offloads(block, cb, cb_priv, true,
+					  tcf_block_offload_in_use(block),
+					  extack);
+	if (err)
+		return ERR_PTR(err);
+
+	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
+	if (!block_cb)
+		return ERR_PTR(-ENOMEM);
+	block_cb->cb = cb;
+	block_cb->cb_ident = cb_ident;
+	block_cb->cb_priv = cb_priv;
+	list_add(&block_cb->list, &block->cb_list);
+	return block_cb;
+}
+EXPORT_SYMBOL(__tcf_block_cb_register);
+
+int tcf_block_cb_register(struct tcf_block *block,
+			  tc_setup_cb_t *cb, void *cb_ident,
+			  void *cb_priv, struct netlink_ext_ack *extack)
+{
+	struct tcf_block_cb *block_cb;
+
+	block_cb = __tcf_block_cb_register(block, cb, cb_ident, cb_priv,
+					   extack);
+	return PTR_ERR_OR_ZERO(block_cb);
+}
+EXPORT_SYMBOL(tcf_block_cb_register);
+
+void __tcf_block_cb_unregister(struct tcf_block *block,
+			       struct tcf_block_cb *block_cb)
+{
+	tcf_block_playback_offloads(block, block_cb->cb, block_cb->cb_priv,
+				    false, tcf_block_offload_in_use(block),
+				    NULL);
+	list_del(&block_cb->list);
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(__tcf_block_cb_unregister);
+
+void tcf_block_cb_unregister(struct tcf_block *block,
+			     tc_setup_cb_t *cb, void *cb_ident)
+{
+	struct tcf_block_cb *block_cb;
+
+	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
+	if (!block_cb)
+		return;
+	__tcf_block_cb_unregister(block, block_cb);
+}
+EXPORT_SYMBOL(tcf_block_cb_unregister);
+
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
@@ -782,11 +1024,6 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 				  &bo);
 }
 
-static bool tcf_block_offload_in_use(struct tcf_block *block)
-{
-	return block->offloadcnt;
-}
-
 static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev,
 				 struct tcf_block_ext_info *ei,
@@ -1003,104 +1240,6 @@ static struct tcf_block *tcf_block_refcnt_get(struct net *net, u32 block_index)
 	return block;
 }
 
-static struct tcf_chain *
-__tcf_get_next_chain(struct tcf_block *block, struct tcf_chain *chain)
-{
-	mutex_lock(&block->lock);
-	if (chain)
-		chain = list_is_last(&chain->list, &block->chain_list) ?
-			NULL : list_next_entry(chain, list);
-	else
-		chain = list_first_entry_or_null(&block->chain_list,
-						 struct tcf_chain, list);
-
-	/* skip all action-only chains */
-	while (chain && tcf_chain_held_by_acts_only(chain))
-		chain = list_is_last(&chain->list, &block->chain_list) ?
-			NULL : list_next_entry(chain, list);
-
-	if (chain)
-		tcf_chain_hold(chain);
-	mutex_unlock(&block->lock);
-
-	return chain;
-}
-
-/* Function to be used by all clients that want to iterate over all chains on
- * block. It properly obtains block->lock and takes reference to chain before
- * returning it. Users of this function must be tolerant to concurrent chain
- * insertion/deletion or ensure that no concurrent chain modification is
- * possible. Note that all netlink dump callbacks cannot guarantee to provide
- * consistent dump because rtnl lock is released each time skb is filled with
- * data and sent to user-space.
- */
-
-struct tcf_chain *
-tcf_get_next_chain(struct tcf_block *block, struct tcf_chain *chain)
-{
-	struct tcf_chain *chain_next = __tcf_get_next_chain(block, chain);
-
-	if (chain)
-		tcf_chain_put(chain);
-
-	return chain_next;
-}
-EXPORT_SYMBOL(tcf_get_next_chain);
-
-static struct tcf_proto *
-__tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp)
-{
-	u32 prio = 0;
-
-	ASSERT_RTNL();
-	mutex_lock(&chain->filter_chain_lock);
-
-	if (!tp) {
-		tp = tcf_chain_dereference(chain->filter_chain, chain);
-	} else if (tcf_proto_is_deleting(tp)) {
-		/* 'deleting' flag is set and chain->filter_chain_lock was
-		 * unlocked, which means next pointer could be invalid. Restart
-		 * search.
-		 */
-		prio = tp->prio + 1;
-		tp = tcf_chain_dereference(chain->filter_chain, chain);
-
-		for (; tp; tp = tcf_chain_dereference(tp->next, chain))
-			if (!tp->deleting && tp->prio >= prio)
-				break;
-	} else {
-		tp = tcf_chain_dereference(tp->next, chain);
-	}
-
-	if (tp)
-		tcf_proto_get(tp);
-
-	mutex_unlock(&chain->filter_chain_lock);
-
-	return tp;
-}
-
-/* Function to be used by all clients that want to iterate over all tp's on
- * chain. Users of this function must be tolerant to concurrent tp
- * insertion/deletion or ensure that no concurrent chain modification is
- * possible. Note that all netlink dump callbacks cannot guarantee to provide
- * consistent dump because rtnl lock is released each time skb is filled with
- * data and sent to user-space.
- */
-
-struct tcf_proto *
-tcf_get_next_proto(struct tcf_chain *chain, struct tcf_proto *tp,
-		   bool rtnl_held)
-{
-	struct tcf_proto *tp_next = __tcf_get_next_proto(chain, tp);
-
-	if (tp)
-		tcf_proto_put(tp, rtnl_held, NULL);
-
-	return tp_next;
-}
-EXPORT_SYMBOL(tcf_get_next_proto);
-
 static void tcf_block_flush_all_chains(struct tcf_block *block, bool rtnl_held)
 {
 	struct tcf_chain *chain;
@@ -1494,145 +1633,6 @@ void tcf_block_put(struct tcf_block *block)
 
 EXPORT_SYMBOL(tcf_block_put);
 
-struct tcf_block_cb {
-	struct list_head list;
-	tc_setup_cb_t *cb;
-	void *cb_ident;
-	void *cb_priv;
-	unsigned int refcnt;
-};
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return block_cb->cb_priv;
-}
-EXPORT_SYMBOL(tcf_block_cb_priv);
-
-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{	struct tcf_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &block->cb_list, list)
-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
-			return block_cb;
-	return NULL;
-}
-EXPORT_SYMBOL(tcf_block_cb_lookup);
-
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-	block_cb->refcnt++;
-}
-EXPORT_SYMBOL(tcf_block_cb_incref);
-
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return --block_cb->refcnt;
-}
-EXPORT_SYMBOL(tcf_block_cb_decref);
-
-static int
-tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
-			    void *cb_priv, bool add, bool offload_in_use,
-			    struct netlink_ext_ack *extack)
-{
-	struct tcf_chain *chain, *chain_prev;
-	struct tcf_proto *tp, *tp_prev;
-	int err;
-
-	for (chain = __tcf_get_next_chain(block, NULL);
-	     chain;
-	     chain_prev = chain,
-		     chain = __tcf_get_next_chain(block, chain),
-		     tcf_chain_put(chain_prev)) {
-		for (tp = __tcf_get_next_proto(chain, NULL); tp;
-		     tp_prev = tp,
-			     tp = __tcf_get_next_proto(chain, tp),
-			     tcf_proto_put(tp_prev, true, NULL)) {
-			if (tp->ops->reoffload) {
-				err = tp->ops->reoffload(tp, add, cb, cb_priv,
-							 extack);
-				if (err && add)
-					goto err_playback_remove;
-			} else if (add && offload_in_use) {
-				err = -EOPNOTSUPP;
-				NL_SET_ERR_MSG(extack, "Filter HW offload failed - classifier without re-offloading support");
-				goto err_playback_remove;
-			}
-		}
-	}
-
-	return 0;
-
-err_playback_remove:
-	tcf_proto_put(tp, true, NULL);
-	tcf_chain_put(chain);
-	tcf_block_playback_offloads(block, cb, cb_priv, false, offload_in_use,
-				    extack);
-	return err;
-}
-
-struct tcf_block_cb *__tcf_block_cb_register(struct tcf_block *block,
-					     tc_setup_cb_t *cb, void *cb_ident,
-					     void *cb_priv,
-					     struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-	int err;
-
-	/* Replay any already present rules */
-	err = tcf_block_playback_offloads(block, cb, cb_priv, true,
-					  tcf_block_offload_in_use(block),
-					  extack);
-	if (err)
-		return ERR_PTR(err);
-
-	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
-	if (!block_cb)
-		return ERR_PTR(-ENOMEM);
-	block_cb->cb = cb;
-	block_cb->cb_ident = cb_ident;
-	block_cb->cb_priv = cb_priv;
-	list_add(&block_cb->list, &block->cb_list);
-	return block_cb;
-}
-EXPORT_SYMBOL(__tcf_block_cb_register);
-
-int tcf_block_cb_register(struct tcf_block *block,
-			  tc_setup_cb_t *cb, void *cb_ident,
-			  void *cb_priv, struct netlink_ext_ack *extack)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = __tcf_block_cb_register(block, cb, cb_ident, cb_priv,
-					   extack);
-	return PTR_ERR_OR_ZERO(block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_register);
-
-void __tcf_block_cb_unregister(struct tcf_block *block,
-			       struct tcf_block_cb *block_cb)
-{
-	tcf_block_playback_offloads(block, block_cb->cb, block_cb->cb_priv,
-				    false, tcf_block_offload_in_use(block),
-				    NULL);
-	list_del(&block_cb->list);
-	kfree(block_cb);
-}
-EXPORT_SYMBOL(__tcf_block_cb_unregister);
-
-void tcf_block_cb_unregister(struct tcf_block *block,
-			     tc_setup_cb_t *cb, void *cb_ident)
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = tcf_block_cb_lookup(block, cb, cb_ident);
-	if (!block_cb)
-		return;
-	__tcf_block_cb_unregister(block, block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_unregister);
-
 /* Main classifier routine: scans classifier chain attached
  * to this qdisc, (optionally) tests for protocol and asks
  * specific classifiers.
-- 
2.11.0

