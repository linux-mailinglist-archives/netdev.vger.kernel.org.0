Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBEA6C1A0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfGQTnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:43:08 -0400
Received: from mail.us.es ([193.147.175.20]:57764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfGQTnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 15:43:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAE09DA707
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 21:43:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99DA21150DD
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 21:43:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8F8E71150CE; Wed, 17 Jul 2019 21:43:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4161CDA732;
        Wed, 17 Jul 2019 21:43:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jul 2019 21:43:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0388F4265A31;
        Wed, 17 Jul 2019 21:42:59 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        jakub.kicinski@netronome.com
Subject: [PATCH net,v3 4/4] net: flow_offload: add flow_block structure and use it
Date:   Wed, 17 Jul 2019 21:42:48 +0200
Message-Id: <20190717194248.2522-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190717194248.2522-1-pablo@netfilter.org>
References: <20190717194248.2522-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This object stores the flow block callbacks that are attached to this
block. Update flow_block_cb_lookup() to take this new object.

This patch restores the block sharing feature.

Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: add flow_block_init() - Jiri Pirko.
    rename flow/flow_block/ - Jiri Pirko.
    fix documentation in nft_stats - Jiri Pirko.
    update flow_block_cb_lookup() argument to take flow_block
    and adapt callers - Jiri Pirko.

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  8 +++++---
 drivers/net/ethernet/mscc/ocelot_flower.c           |  8 ++++----
 drivers/net/ethernet/mscc/ocelot_tc.c               |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  5 +++--
 include/net/flow_offload.h                          | 12 +++++++++++-
 include/net/netfilter/nf_tables.h                   |  5 +++--
 include/net/sch_generic.h                           |  2 +-
 net/core/flow_offload.c                             |  6 +++---
 net/dsa/slave.c                                     |  2 +-
 net/netfilter/nf_tables_api.c                       |  2 +-
 net/netfilter/nf_tables_offload.c                   |  5 +++--
 net/sched/cls_api.c                                 | 10 +++++++---
 13 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2162412073c5..7f747cb1a4f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -752,7 +752,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f,
+		block_cb = flow_block_cb_lookup(f->block,
 						mlx5e_rep_indr_setup_block_cb,
 						indr_priv);
 		if (!block_cb)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 51cd0b6f1f3e..650638152bbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1604,7 +1604,8 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool register_block = false;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f->block,
+					mlxsw_sp_setup_tc_block_cb_flower,
 					mlxsw_sp);
 	if (!block_cb) {
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
@@ -1656,7 +1657,8 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f, mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f->block,
+					mlxsw_sp_setup_tc_block_cb_flower,
 					mlxsw_sp);
 	if (!block_cb)
 		return;
@@ -1717,7 +1719,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	case FLOW_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
-		block_cb = flow_block_cb_lookup(f, cb, mlxsw_sp_port);
+		block_cb = flow_block_cb_lookup(f->block, cb, mlxsw_sp_port);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 6a11aea8b186..59487d446a09 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -316,8 +316,8 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
-	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
-					port);
+	block_cb = flow_block_cb_lookup(f->block,
+					ocelot_setup_tc_block_cb_flower, port);
 	if (!block_cb) {
 		port_block = ocelot_port_block_create(port);
 		if (!port_block)
@@ -350,8 +350,8 @@ void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
 {
 	struct flow_block_cb *block_cb;
 
-	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
-					port);
+	block_cb = flow_block_cb_lookup(f->block,
+					ocelot_setup_tc_block_cb_flower, port);
 	if (!block_cb)
 		return;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index fba9512e9ca6..16a6db71ca5e 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -169,7 +169,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		list_add_tail(&block_cb->driver_list, f->driver_block_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f, cb, port);
+		block_cb = flow_block_cb_lookup(f->block, cb, port);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 93ab0db6c504..e209f150c5f2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1327,7 +1327,8 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 		list_add_tail(&block_cb->driver_list, &nfp_block_cb_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f, nfp_flower_setup_tc_block_cb,
+		block_cb = flow_block_cb_lookup(f->block,
+						nfp_flower_setup_tc_block_cb,
 						repr);
 		if (!block_cb)
 			return -ENOENT;
@@ -1440,7 +1441,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		if (!cb_priv)
 			return -ENOENT;
 
-		block_cb = flow_block_cb_lookup(f,
+		block_cb = flow_block_cb_lookup(f->block,
 						nfp_flower_setup_indr_block_cb,
 						cb_priv);
 		if (!block_cb)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 98bf3af5c84d..2b555ba78a02 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -248,6 +248,10 @@ enum flow_block_binder_type {
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 };
 
+struct flow_block {
+	struct list_head cb_list;
+};
+
 struct netlink_ext_ack;
 
 struct flow_block_offload {
@@ -255,6 +259,7 @@ struct flow_block_offload {
 	enum flow_block_binder_type binder_type;
 	bool block_shared;
 	struct net *net;
+	struct flow_block *block;
 	struct list_head cb_list;
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
@@ -279,7 +284,7 @@ struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void (*release)(void *cb_priv));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 
-struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *offload,
+struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
 					   flow_setup_cb_t *cb, void *cb_ident);
 
 void *flow_block_cb_priv(struct flow_block_cb *block_cb);
@@ -336,4 +341,9 @@ flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 	return flow_cmd->rule;
 }
 
+static inline void flow_block_init(struct flow_block *flow_block)
+{
+	INIT_LIST_HEAD(&flow_block->cb_list);
+}
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 35dfdd9f69b3..9b624566b82d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -11,6 +11,7 @@
 #include <linux/rhashtable.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
+#include <net/flow_offload.h>
 
 struct module;
 
@@ -951,7 +952,7 @@ struct nft_stats {
  *	@stats: per-cpu chain stats
  *	@chain: the chain
  *	@dev_name: device name that this base chain is attached to (if any)
- *	@cb_list: list of flow block callbacks (for hardware offload)
+ *	@flow_block: flow block (for hardware offload)
  */
 struct nft_base_chain {
 	struct nf_hook_ops		ops;
@@ -961,7 +962,7 @@ struct nft_base_chain {
 	struct nft_stats __percpu	*stats;
 	struct nft_chain		chain;
 	char 				dev_name[IFNAMSIZ];
-	struct list_head		cb_list;
+	struct flow_block		flow_block;
 };
 
 static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9482e060483b..6b6b01234dd9 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -399,7 +399,7 @@ struct tcf_block {
 	refcount_t refcnt;
 	struct net *net;
 	struct Qdisc *q;
-	struct list_head cb_list;
+	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
 	unsigned int offloadcnt; /* Number of oddloaded filters */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index a800fa78d96c..d63b970784dc 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -193,12 +193,12 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_free);
 
-struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
+struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
 					   flow_setup_cb_t *cb, void *cb_ident)
 {
 	struct flow_block_cb *block_cb;
 
-	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
+	list_for_each_entry(block_cb, &block->cb_list, list) {
 		if (block_cb->cb == cb &&
 		    block_cb->cb_ident == cb_ident)
 			return block_cb;
@@ -268,7 +268,7 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 		list_add_tail(&block_cb->driver_list, driver_block_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f, cb, cb_ident);
+		block_cb = flow_block_cb_lookup(f->block, cb, cb_ident);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d697a64fb564..33f41178afcc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -975,7 +975,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 		list_add_tail(&block_cb->driver_list, &dsa_slave_block_cb_list);
 		return 0;
 	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f, cb, dev);
+		block_cb = flow_block_cb_lookup(f->block, cb, dev);
 		if (!block_cb)
 			return -ENOENT;
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 014e06b0b5cf..605a7cfe7ca7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1662,7 +1662,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		chain->flags |= NFT_BASE_CHAIN | flags;
 		basechain->policy = NF_ACCEPT;
-		INIT_LIST_HEAD(&basechain->cb_list);
+		flow_block_init(&basechain->flow_block);
 	} else {
 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
 		if (chain == NULL)
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2c3302845f67..64f5fd5f240e 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -116,7 +116,7 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 	struct flow_block_cb *block_cb;
 	int err;
 
-	list_for_each_entry(block_cb, &basechain->cb_list, list) {
+	list_for_each_entry(block_cb, &basechain->flow_block.cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err < 0)
 			return err;
@@ -154,7 +154,7 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
 				 struct nft_base_chain *basechain)
 {
-	list_splice(&bo->cb_list, &basechain->cb_list);
+	list_splice(&bo->cb_list, &basechain->flow_block.cb_list);
 	return 0;
 }
 
@@ -198,6 +198,7 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
 		return -EOPNOTSUPP;
 
 	bo.command = cmd;
+	bo.block = &basechain->flow_block;
 	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo.extack = &extack;
 	INIT_LIST_HEAD(&bo.cb_list);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 51fbe6e95a92..3b9720fe1e60 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -691,6 +691,8 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 	if (!indr_dev->block)
 		return;
 
+	bo.block = &indr_dev->block->flow_block;
+
 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
 			  &bo);
 	tcf_block_setup(indr_dev->block, &bo);
@@ -775,6 +777,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.net		= dev_net(dev),
+		.block		= &block->flow_block,
 		.block_shared	= tcf_block_shared(block),
 		.extack		= extack,
 	};
@@ -810,6 +813,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 	bo.net = dev_net(dev);
 	bo.command = command;
 	bo.binder_type = ei->binder_type;
+	bo.block = &block->flow_block;
 	bo.block_shared = tcf_block_shared(block);
 	bo.extack = extack;
 	INIT_LIST_HEAD(&bo.cb_list);
@@ -987,8 +991,8 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&block->lock);
+	flow_block_init(&block->flow_block);
 	INIT_LIST_HEAD(&block->chain_list);
-	INIT_LIST_HEAD(&block->cb_list);
 	INIT_LIST_HEAD(&block->owner_list);
 	INIT_LIST_HEAD(&block->chain0.filter_chain_list);
 
@@ -1570,7 +1574,7 @@ static int tcf_block_bind(struct tcf_block *block,
 
 		i++;
 	}
-	list_splice(&bo->cb_list, &block->cb_list);
+	list_splice(&bo->cb_list, &block->flow_block.cb_list);
 
 	return 0;
 
@@ -3155,7 +3159,7 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 	if (block->nooffloaddevcnt && err_stop)
 		return -EOPNOTSUPP;
 
-	list_for_each_entry(block_cb, &block->cb_list, list) {
+	list_for_each_entry(block_cb, &block->flow_block.cb_list, list) {
 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
 		if (err) {
 			if (err_stop)
-- 
2.11.0

