Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4671E7162
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438111AbgE2A0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:10 -0400
Received: from correo.us.es ([193.147.175.20]:44330 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438110AbgE2A0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:26:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5242EE7815
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4313EDA71A
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 40CB5DA717; Fri, 29 May 2020 02:25:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92912DA723;
        Fri, 29 May 2020 02:25:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 254C8426CCB9;
        Fri, 29 May 2020 02:25:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 8/8] net: remove indirect block netdev event registration
Date:   Fri, 29 May 2020 02:25:41 +0200
Message-Id: <20200529002541.19743-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers do not register to netdev events to set up indirect blocks
anymore. Remove __flow_indr_block_cb_register() and
__flow_indr_block_cb_unregister().

The frontends set up the callbacks through flow_indr_dev_setup_block()

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h            |   9 -
 net/core/flow_offload.c               | 238 --------------------------
 net/netfilter/nf_flow_table_offload.c |  66 -------
 net/netfilter/nf_tables_offload.c     |  53 +-----
 net/sched/cls_api.c                   |  79 ---------
 5 files changed, 1 insertion(+), 444 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 5493282348fa..69e13c8b6b3a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -546,15 +546,6 @@ typedef void flow_indr_block_cmd_t(struct net_device *dev,
 				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
 				   enum flow_block_command command);
 
-struct flow_indr_block_entry {
-	flow_indr_block_cmd_t *cb;
-	struct list_head	list;
-};
-
-void flow_indr_add_block_cb(struct flow_indr_block_entry *entry);
-
-void flow_indr_del_block_cb(struct flow_indr_block_entry *entry);
-
 int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				  flow_indr_block_bind_cb_t *cb,
 				  void *cb_ident);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 8cd7da2586ae..0cfc35e6be28 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -473,241 +473,3 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
-
-static LIST_HEAD(block_cb_list);
-
-static struct rhashtable indr_setup_block_ht;
-
-struct flow_indr_block_cb {
-	struct list_head list;
-	void *cb_priv;
-	flow_indr_block_bind_cb_t *cb;
-	void *cb_ident;
-};
-
-struct flow_indr_block_dev {
-	struct rhash_head ht_node;
-	struct net_device *dev;
-	unsigned int refcnt;
-	struct list_head cb_list;
-};
-
-static const struct rhashtable_params flow_indr_setup_block_ht_params = {
-	.key_offset	= offsetof(struct flow_indr_block_dev, dev),
-	.head_offset	= offsetof(struct flow_indr_block_dev, ht_node),
-	.key_len	= sizeof(struct net_device *),
-};
-
-static struct flow_indr_block_dev *
-flow_indr_block_dev_lookup(struct net_device *dev)
-{
-	return rhashtable_lookup_fast(&indr_setup_block_ht, &dev,
-				      flow_indr_setup_block_ht_params);
-}
-
-static struct flow_indr_block_dev *
-flow_indr_block_dev_get(struct net_device *dev)
-{
-	struct flow_indr_block_dev *indr_dev;
-
-	indr_dev = flow_indr_block_dev_lookup(dev);
-	if (indr_dev)
-		goto inc_ref;
-
-	indr_dev = kzalloc(sizeof(*indr_dev), GFP_KERNEL);
-	if (!indr_dev)
-		return NULL;
-
-	INIT_LIST_HEAD(&indr_dev->cb_list);
-	indr_dev->dev = dev;
-	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
-				   flow_indr_setup_block_ht_params)) {
-		kfree(indr_dev);
-		return NULL;
-	}
-
-inc_ref:
-	indr_dev->refcnt++;
-	return indr_dev;
-}
-
-static void flow_indr_block_dev_put(struct flow_indr_block_dev *indr_dev)
-{
-	if (--indr_dev->refcnt)
-		return;
-
-	rhashtable_remove_fast(&indr_setup_block_ht, &indr_dev->ht_node,
-			       flow_indr_setup_block_ht_params);
-	kfree(indr_dev);
-}
-
-static struct flow_indr_block_cb *
-flow_indr_block_cb_lookup(struct flow_indr_block_dev *indr_dev,
-			  flow_indr_block_bind_cb_t *cb, void *cb_ident)
-{
-	struct flow_indr_block_cb *indr_block_cb;
-
-	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		if (indr_block_cb->cb == cb &&
-		    indr_block_cb->cb_ident == cb_ident)
-			return indr_block_cb;
-	return NULL;
-}
-
-static struct flow_indr_block_cb *
-flow_indr_block_cb_add(struct flow_indr_block_dev *indr_dev, void *cb_priv,
-		       flow_indr_block_bind_cb_t *cb, void *cb_ident)
-{
-	struct flow_indr_block_cb *indr_block_cb;
-
-	indr_block_cb = flow_indr_block_cb_lookup(indr_dev, cb, cb_ident);
-	if (indr_block_cb)
-		return ERR_PTR(-EEXIST);
-
-	indr_block_cb = kzalloc(sizeof(*indr_block_cb), GFP_KERNEL);
-	if (!indr_block_cb)
-		return ERR_PTR(-ENOMEM);
-
-	indr_block_cb->cb_priv = cb_priv;
-	indr_block_cb->cb = cb;
-	indr_block_cb->cb_ident = cb_ident;
-	list_add(&indr_block_cb->list, &indr_dev->cb_list);
-
-	return indr_block_cb;
-}
-
-static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
-{
-	list_del(&indr_block_cb->list);
-	kfree(indr_block_cb);
-}
-
-static DEFINE_MUTEX(flow_indr_block_cb_lock);
-
-static void flow_block_cmd(struct net_device *dev,
-			   flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			   enum flow_block_command command)
-{
-	struct flow_indr_block_entry *entry;
-
-	mutex_lock(&flow_indr_block_cb_lock);
-	list_for_each_entry(entry, &block_cb_list, list) {
-		entry->cb(dev, cb, cb_priv, command);
-	}
-	mutex_unlock(&flow_indr_block_cb_lock);
-}
-
-int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				  flow_indr_block_bind_cb_t *cb,
-				  void *cb_ident)
-{
-	struct flow_indr_block_cb *indr_block_cb;
-	struct flow_indr_block_dev *indr_dev;
-	int err;
-
-	indr_dev = flow_indr_block_dev_get(dev);
-	if (!indr_dev)
-		return -ENOMEM;
-
-	indr_block_cb = flow_indr_block_cb_add(indr_dev, cb_priv, cb, cb_ident);
-	err = PTR_ERR_OR_ZERO(indr_block_cb);
-	if (err)
-		goto err_dev_put;
-
-	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-		       FLOW_BLOCK_BIND);
-
-	return 0;
-
-err_dev_put:
-	flow_indr_block_dev_put(indr_dev);
-	return err;
-}
-EXPORT_SYMBOL_GPL(__flow_indr_block_cb_register);
-
-int flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
-				flow_indr_block_bind_cb_t *cb,
-				void *cb_ident)
-{
-	int err;
-
-	rtnl_lock();
-	err = __flow_indr_block_cb_register(dev, cb_priv, cb, cb_ident);
-	rtnl_unlock();
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(flow_indr_block_cb_register);
-
-void __flow_indr_block_cb_unregister(struct net_device *dev,
-				     flow_indr_block_bind_cb_t *cb,
-				     void *cb_ident)
-{
-	struct flow_indr_block_cb *indr_block_cb;
-	struct flow_indr_block_dev *indr_dev;
-
-	indr_dev = flow_indr_block_dev_lookup(dev);
-	if (!indr_dev)
-		return;
-
-	indr_block_cb = flow_indr_block_cb_lookup(indr_dev, cb, cb_ident);
-	if (!indr_block_cb)
-		return;
-
-	flow_block_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
-		       FLOW_BLOCK_UNBIND);
-
-	flow_indr_block_cb_del(indr_block_cb);
-	flow_indr_block_dev_put(indr_dev);
-}
-EXPORT_SYMBOL_GPL(__flow_indr_block_cb_unregister);
-
-void flow_indr_block_cb_unregister(struct net_device *dev,
-				   flow_indr_block_bind_cb_t *cb,
-				   void *cb_ident)
-{
-	rtnl_lock();
-	__flow_indr_block_cb_unregister(dev, cb, cb_ident);
-	rtnl_unlock();
-}
-EXPORT_SYMBOL_GPL(flow_indr_block_cb_unregister);
-
-void flow_indr_block_call(struct net_device *dev,
-			  struct flow_block_offload *bo,
-			  enum flow_block_command command,
-			  enum tc_setup_type type)
-{
-	struct flow_indr_block_cb *indr_block_cb;
-	struct flow_indr_block_dev *indr_dev;
-
-	indr_dev = flow_indr_block_dev_lookup(dev);
-	if (!indr_dev)
-		return;
-
-	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
-		indr_block_cb->cb(dev, indr_block_cb->cb_priv, type, bo);
-}
-EXPORT_SYMBOL_GPL(flow_indr_block_call);
-
-void flow_indr_add_block_cb(struct flow_indr_block_entry *entry)
-{
-	mutex_lock(&flow_indr_block_cb_lock);
-	list_add_tail(&entry->list, &block_cb_list);
-	mutex_unlock(&flow_indr_block_cb_lock);
-}
-EXPORT_SYMBOL_GPL(flow_indr_add_block_cb);
-
-void flow_indr_del_block_cb(struct flow_indr_block_entry *entry)
-{
-	mutex_lock(&flow_indr_block_cb_lock);
-	list_del(&entry->list);
-	mutex_unlock(&flow_indr_block_cb_lock);
-}
-EXPORT_SYMBOL_GPL(flow_indr_del_block_cb);
-
-static int __init init_flow_indr_rhashtable(void)
-{
-	return rhashtable_init(&indr_setup_block_ht,
-			       &flow_indr_setup_block_ht_params);
-}
-subsys_initcall(init_flow_indr_rhashtable);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 01cfa02c43bd..62651e6683f6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1008,69 +1008,6 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
-static void nf_flow_table_indr_block_ing_cmd(struct net_device *dev,
-					     struct nf_flowtable *flowtable,
-					     flow_indr_block_bind_cb_t *cb,
-					     void *cb_priv,
-					     enum flow_block_command cmd)
-{
-	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo;
-
-	if (!flowtable)
-		return;
-
-	nf_flow_table_block_offload_init(&bo, dev_net(dev), cmd, flowtable,
-					 &extack);
-
-	cb(dev, cb_priv, TC_SETUP_FT, &bo);
-
-	nf_flow_table_block_setup(flowtable, &bo, cmd);
-}
-
-static void nf_flow_table_indr_block_cb_cmd(struct nf_flowtable *flowtable,
-					    struct net_device *dev,
-					    flow_indr_block_bind_cb_t *cb,
-					    void *cb_priv,
-					    enum flow_block_command cmd)
-{
-	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
-		return;
-
-	nf_flow_table_indr_block_ing_cmd(dev, flowtable, cb, cb_priv, cmd);
-}
-
-static void nf_flow_table_indr_block_cb(struct net_device *dev,
-					flow_indr_block_bind_cb_t *cb,
-					void *cb_priv,
-					enum flow_block_command cmd)
-{
-	struct net *net = dev_net(dev);
-	struct nft_flowtable *nft_ft;
-	struct nft_table *table;
-	struct nft_hook *hook;
-
-	mutex_lock(&net->nft.commit_mutex);
-	list_for_each_entry(table, &net->nft.tables, list) {
-		list_for_each_entry(nft_ft, &table->flowtables, list) {
-			list_for_each_entry(hook, &nft_ft->hook_list, list) {
-				if (hook->ops.dev != dev)
-					continue;
-
-				nf_flow_table_indr_block_cb_cmd(&nft_ft->data,
-								dev, cb,
-								cb_priv, cmd);
-			}
-		}
-	}
-	mutex_unlock(&net->nft.commit_mutex);
-}
-
-static struct flow_indr_block_entry block_ing_entry = {
-	.cb	= nf_flow_table_indr_block_cb,
-	.list	= LIST_HEAD_INIT(block_ing_entry.list),
-};
-
 int nf_flow_table_offload_init(void)
 {
 	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
@@ -1078,13 +1015,10 @@ int nf_flow_table_offload_init(void)
 	if (!nf_flow_offload_wq)
 		return -ENOMEM;
 
-	flow_indr_add_block_cb(&block_ing_entry);
-
 	return 0;
 }
 
 void nf_flow_table_offload_exit(void)
 {
-	flow_indr_del_block_cb(&block_ing_entry);
 	destroy_workqueue(nf_flow_offload_wq);
 }
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 1960f11477e8..185fc82c99aa 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -285,25 +285,6 @@ static int nft_block_offload_cmd(struct nft_base_chain *chain,
 	return nft_block_setup(chain, &bo, cmd);
 }
 
-static void nft_indr_block_ing_cmd(struct net_device *dev,
-				   struct nft_base_chain *chain,
-				   flow_indr_block_bind_cb_t *cb,
-				   void *cb_priv,
-				   enum flow_block_command cmd)
-{
-	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo;
-
-	if (!chain)
-		return;
-
-	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
-
-	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
-
-	nft_block_setup(chain, &bo, cmd);
-}
-
 static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 {
 	struct nft_base_chain *basechain = block_cb->indr.data;
@@ -575,24 +556,6 @@ static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 	return NULL;
 }
 
-static void nft_indr_block_cb(struct net_device *dev,
-			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      enum flow_block_command cmd)
-{
-	struct net *net = dev_net(dev);
-	struct nft_chain *chain;
-
-	mutex_lock(&net->nft.commit_mutex);
-	chain = __nft_offload_get_chain(dev);
-	if (chain && chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		struct nft_base_chain *basechain;
-
-		basechain = nft_base_chain(chain);
-		nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
-	}
-	mutex_unlock(&net->nft.commit_mutex);
-}
-
 static int nft_offload_netdev_event(struct notifier_block *this,
 				    unsigned long event, void *ptr)
 {
@@ -614,30 +577,16 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct flow_indr_block_entry block_ing_entry = {
-	.cb	= nft_indr_block_cb,
-	.list	= LIST_HEAD_INIT(block_ing_entry.list),
-};
-
 static struct notifier_block nft_offload_netdev_notifier = {
 	.notifier_call	= nft_offload_netdev_event,
 };
 
 int nft_offload_init(void)
 {
-	int err;
-
-	err = register_netdevice_notifier(&nft_offload_netdev_notifier);
-	if (err < 0)
-		return err;
-
-	flow_indr_add_block_cb(&block_ing_entry);
-
-	return 0;
+	return register_netdevice_notifier(&nft_offload_netdev_notifier);
 }
 
 void nft_offload_exit(void)
 {
-	flow_indr_del_block_cb(&block_ing_entry);
 	unregister_netdevice_notifier(&nft_offload_netdev_notifier);
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 760e51d852f5..a00a203b2ef5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -621,78 +621,6 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
-static void tc_indr_block_cmd(struct net_device *dev, struct tcf_block *block,
-			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      enum flow_block_command command, bool ingress)
-{
-	struct flow_block_offload bo = {
-		.command	= command,
-		.binder_type	= ingress ?
-				  FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS :
-				  FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
-		.net		= dev_net(dev),
-		.block_shared	= tcf_block_non_null_shared(block),
-	};
-	INIT_LIST_HEAD(&bo.cb_list);
-
-	if (!block)
-		return;
-
-	bo.block = &block->flow_block;
-
-	down_write(&block->cb_lock);
-	cb(dev, cb_priv, TC_SETUP_BLOCK, &bo);
-
-	tcf_block_setup(block, &bo);
-	up_write(&block->cb_lock);
-}
-
-static struct tcf_block *tc_dev_block(struct net_device *dev, bool ingress)
-{
-	const struct Qdisc_class_ops *cops;
-	const struct Qdisc_ops *ops;
-	struct Qdisc *qdisc;
-
-	if (!dev_ingress_queue(dev))
-		return NULL;
-
-	qdisc = dev_ingress_queue(dev)->qdisc_sleeping;
-	if (!qdisc)
-		return NULL;
-
-	ops = qdisc->ops;
-	if (!ops)
-		return NULL;
-
-	if (!ingress && !strcmp("ingress", ops->id))
-		return NULL;
-
-	cops = ops->cl_ops;
-	if (!cops)
-		return NULL;
-
-	if (!cops->tcf_block)
-		return NULL;
-
-	return cops->tcf_block(qdisc,
-			       ingress ? TC_H_MIN_INGRESS : TC_H_MIN_EGRESS,
-			       NULL);
-}
-
-static void tc_indr_block_get_and_cmd(struct net_device *dev,
-				      flow_indr_block_bind_cb_t *cb,
-				      void *cb_priv,
-				      enum flow_block_command command)
-{
-	struct tcf_block *block;
-
-	block = tc_dev_block(dev, true);
-	tc_indr_block_cmd(dev, block, cb, cb_priv, command, true);
-
-	block = tc_dev_block(dev, false);
-	tc_indr_block_cmd(dev, block, cb, cb_priv, command, false);
-}
-
 static void tcf_block_offload_init(struct flow_block_offload *bo,
 				   struct net_device *dev,
 				   enum flow_block_command command,
@@ -3836,11 +3764,6 @@ static struct pernet_operations tcf_net_ops = {
 	.size = sizeof(struct tcf_net),
 };
 
-static struct flow_indr_block_entry block_entry = {
-	.cb = tc_indr_block_get_and_cmd,
-	.list = LIST_HEAD_INIT(block_entry.list),
-};
-
 static int __init tc_filter_init(void)
 {
 	int err;
@@ -3853,8 +3776,6 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
-	flow_indr_add_block_cb(&block_entry);
-
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
2.20.1

