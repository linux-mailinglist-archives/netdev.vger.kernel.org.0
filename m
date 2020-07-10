Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70521B74F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgGJN6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:00 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38125 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726965AbgGJN6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E2BB758046E;
        Fri, 10 Jul 2020 09:57:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YdYs9IdfpiQfZnUf6YPsWJw90mFjLasPJpvtGeRzDcs=; b=BVGDUL/V
        XMc6BtRqSks+m51L8oREsSWK+kUT605BeLfh4T8jJ0007Y/esCSwI9tyHr9qt6tf
        XfmAVPMHveVqY6xeD0cPdsXymds3XbBT3oaJOtEwVAeZ25f8S0FEA/ct2gFFD7ec
        i5cUQbNU0umgp9OmL7xkYG7ovG3XoOyEZJD/hMjoRMWudYLZpy24aqjhOqFETmH2
        LMGulEfV7M0+cOxTqzBo1HnpabLgZsSwSyfuv8raRLX/tePzk096jSXX+d/jW3Iq
        PxfOhRZw6pAk7+Y65VvbbgxkLweelYxL39KkKnMzIn7o+ckQzMfaJ+OxWci5ZUsO
        LowF0v/gRdxRWg==
X-ME-Sender: <xms:5XMIX6INywHA1pXiORomxwetrK55mD5OWb-BQkgkSPKrgs3AVOVt3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5XMIXyJ2AofBofJciaxPbF4vEj4dy2-fItkHwXpDageKNubyNYx-Ew>
    <xmx:5XMIX6sw5wxMlj9MuG0YR_nqWVUarMya0bO_thXXWvyO76lEZn2FVg>
    <xmx:5XMIX_bGsKA9lgFm6zYTgjcb-R_S8sIDewkKnS2YkB7H8wZ7dW6Qdg>
    <xmx:5XMIX3Ab_pLGsR-po2pOT-uPKaH7uX5WB5OvgMQAG5A8IlP3aXEhLA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91034328005A;
        Fri, 10 Jul 2020 09:57:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
Date:   Fri, 10 Jul 2020 16:56:54 +0300
Message-Id: <20200710135706.601409-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Previously, shared blocks were only relevant for the pseudo-qdiscs ingress
and clsact. Recently, a qevent facility was introduced, which allows to
bind blocks to well-defined slots of a qdisc instance. RED in particular
got two qevents: early_drop and mark. Drivers that wish to offload these
blocks will be sent the usual notification, and need to know which qdisc it
is related to.

To that end, extend flow_block_offload with a "sch" pointer, and initialize
as appropriate. This prompts changes in the indirect block facility, which
now tracks the scheduler instead of the netdevice. Update signatures of
several functions similarly. Deduce the device from the scheduler when
necessary.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 11 ++++++----
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 11 +++++-----
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +-
 .../ethernet/netronome/nfp/flower/offload.c   | 11 ++++++----
 include/net/flow_offload.h                    |  9 ++++----
 net/core/flow_offload.c                       | 12 +++++------
 net/netfilter/nf_flow_table_offload.c         | 17 +++++++--------
 net/netfilter/nf_tables_offload.c             | 20 ++++++++++--------
 net/sched/cls_api.c                           | 21 +++++++++++--------
 9 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0a9a4467d7c7..fd016adfde5d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1888,10 +1888,11 @@ static void bnxt_tc_setup_indr_rel(void *cb_priv)
 	kfree(priv);
 }
 
-static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
+static int bnxt_tc_setup_indr_block(struct Qdisc *sch, struct bnxt *bp,
 				    struct flow_block_offload *f, void *data,
 				    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	struct net_device *netdev = sch->dev_queue->dev;
 	struct bnxt_flower_indr_block_cb_priv *cb_priv;
 	struct flow_block_cb *block_cb;
 
@@ -1911,7 +1912,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    bnxt_tc_setup_indr_rel, f,
-						    netdev, data, bp, cleanup);
+						    sch, data, bp, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1946,17 +1947,19 @@ static bool bnxt_is_netdev_indr_offload(struct net_device *netdev)
 	return netif_is_vxlan(netdev);
 }
 
-static int bnxt_tc_setup_indr_cb(struct net_device *netdev, void *cb_priv,
+static int bnxt_tc_setup_indr_cb(struct Qdisc *sch, void *cb_priv,
 				 enum tc_setup_type type, void *type_data,
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	struct net_device *netdev = sch->dev_queue->dev;
+
 	if (!bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_tc_setup_indr_block(netdev, cb_priv, type_data, data,
+		return bnxt_tc_setup_indr_block(sch, cb_priv, type_data, data,
 						cleanup);
 	default:
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index eefeb1cdc2ee..4fc42c1955ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -404,7 +404,7 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 static LIST_HEAD(mlx5e_block_cb_list);
 
 static int
-mlx5e_rep_indr_setup_block(struct net_device *netdev,
+mlx5e_rep_indr_setup_block(struct Qdisc *sch,
 			   struct mlx5e_rep_priv *rpriv,
 			   struct flow_block_offload *f,
 			   flow_setup_cb_t *setup_cb,
@@ -412,6 +412,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 			   void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+	struct net_device *netdev = sch->dev_queue->dev;
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
 
@@ -442,7 +443,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 
 		block_cb = flow_indr_block_cb_alloc(setup_cb, indr_priv, indr_priv,
 						    mlx5e_rep_indr_block_unbind,
-						    f, netdev, data, rpriv,
+						    f, sch, data, rpriv,
 						    cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
@@ -472,18 +473,18 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 }
 
 static
-int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
+int mlx5e_rep_indr_setup_cb(struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+		return mlx5e_rep_indr_setup_block(sch, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_tc_cb,
 						  data, cleanup);
 	case TC_SETUP_FT:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+		return mlx5e_rep_indr_setup_block(sch, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_ft_cb,
 						  data, cleanup);
 	default:
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7f54a620acad..84f1b69bc6dd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -458,7 +458,7 @@ void nfp_flower_qos_cleanup(struct nfp_app *app);
 int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 				 struct tc_cls_matchall_offload *flow);
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
-int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
+int nfp_flower_indr_setup_tc_cb(struct Qdisc *sch, void *cb_priv,
 				enum tc_setup_type type, void *type_data,
 				void *data,
 				void (*cleanup)(struct flow_block_cb *block_cb));
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 3af27bb5f4b0..f2acce64613c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1646,10 +1646,11 @@ void nfp_flower_setup_indr_tc_release(void *cb_priv)
 }
 
 static int
-nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
+nfp_flower_setup_indr_tc_block(struct Qdisc *sch, struct nfp_app *app,
 			       struct flow_block_offload *f, void *data,
 			       void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	struct net_device *netdev = sch->dev_queue->dev;
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
 	struct flow_block_cb *block_cb;
@@ -1680,7 +1681,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		block_cb = flow_indr_block_cb_alloc(nfp_flower_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    nfp_flower_setup_indr_tc_release,
-						    f, netdev, data, app, cleanup);
+						    f, sch, data, app, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -1711,17 +1712,19 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 }
 
 int
-nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
+nfp_flower_indr_setup_tc_cb(struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	struct net_device *netdev = sch->dev_queue->dev;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_flower_setup_indr_tc_block(netdev, cb_priv,
+		return nfp_flower_setup_indr_tc_block(sch, cb_priv,
 						      type_data, data, cleanup);
 	default:
 		return -EOPNOTSUPP;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index de395498440d..fda29140bdc5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -444,6 +444,7 @@ struct flow_block_offload {
 	struct list_head cb_list;
 	struct list_head *driver_block_list;
 	struct netlink_ext_ack *extack;
+	struct Qdisc *sch;
 };
 
 enum tc_setup_type;
@@ -454,7 +455,7 @@ struct flow_block_cb;
 
 struct flow_block_indr {
 	struct list_head		list;
-	struct net_device		*dev;
+	struct Qdisc			*sch;
 	enum flow_block_binder_type	binder_type;
 	void				*data;
 	void				*cb_priv;
@@ -479,7 +480,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void *cb_ident, void *cb_priv,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
-					       struct net_device *dev, void *data,
+					       struct Qdisc *sch, void *data,
 					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
@@ -553,7 +554,7 @@ static inline void flow_block_init(struct flow_block *flow_block)
 	INIT_LIST_HEAD(&flow_block->cb_list);
 }
 
-typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
+typedef int flow_indr_block_bind_cb_t(struct Qdisc *sch, void *cb_priv,
 				      enum tc_setup_type type, void *type_data,
 				      void *data,
 				      void (*cleanup)(struct flow_block_cb *block_cb));
@@ -561,7 +562,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 			      void (*release)(void *cb_priv));
-int flow_indr_dev_setup_offload(struct net_device *dev,
+int flow_indr_dev_setup_offload(struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index b739cfab796e..9877c55f3e77 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -429,14 +429,14 @@ EXPORT_SYMBOL(flow_indr_dev_unregister);
 
 static void flow_block_indr_init(struct flow_block_cb *flow_block,
 				 struct flow_block_offload *bo,
-				 struct net_device *dev, void *data,
+				 struct Qdisc *sch, void *data,
 				 void *cb_priv,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	flow_block->indr.binder_type = bo->binder_type;
 	flow_block->indr.data = data;
 	flow_block->indr.cb_priv = cb_priv;
-	flow_block->indr.dev = dev;
+	flow_block->indr.sch = sch;
 	flow_block->indr.cleanup = cleanup;
 }
 
@@ -444,7 +444,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void *cb_ident, void *cb_priv,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
-					       struct net_device *dev, void *data,
+					       struct Qdisc *sch, void *data,
 					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb))
 {
@@ -454,7 +454,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 	if (IS_ERR(block_cb))
 		goto out;
 
-	flow_block_indr_init(block_cb, bo, dev, data, indr_cb_priv, cleanup);
+	flow_block_indr_init(block_cb, bo, sch, data, indr_cb_priv, cleanup);
 	list_add(&block_cb->indr.list, &flow_block_indr_list);
 
 out:
@@ -462,7 +462,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 }
 EXPORT_SYMBOL(flow_indr_block_cb_alloc);
 
-int flow_indr_dev_setup_offload(struct net_device *dev,
+int flow_indr_dev_setup_offload(struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb))
@@ -471,7 +471,7 @@ int flow_indr_dev_setup_offload(struct net_device *dev,
 
 	mutex_lock(&flow_indr_block_lock);
 	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, this->cb_priv, type, bo, data, cleanup);
+		this->cb(sch, this->cb_priv, type, bo, data, cleanup);
 
 	mutex_unlock(&flow_indr_block_lock);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 5fff1e040168..2319190b1364 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -928,26 +928,27 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 }
 
 static void nf_flow_table_block_offload_init(struct flow_block_offload *bo,
-					     struct net *net,
+					     struct net_device *dev,
 					     enum flow_block_command cmd,
 					     struct nf_flowtable *flowtable,
 					     struct netlink_ext_ack *extack)
 {
 	memset(bo, 0, sizeof(*bo));
-	bo->net		= net;
+	bo->net		= dev_net(dev);
 	bo->block	= &flowtable->flow_block;
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->sch		= dev_ingress_queue(dev)->qdisc_sleeping;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
 static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
 {
 	struct nf_flowtable *flowtable = block_cb->indr.data;
-	struct net_device *dev = block_cb->indr.dev;
+	struct Qdisc *sch = block_cb->indr.sch;
 
-	nf_flow_table_gc_cleanup(flowtable, dev);
+	nf_flow_table_gc_cleanup(flowtable, sch->dev_queue->dev);
 	down_write(&flowtable->flow_block_lock);
 	list_del(&block_cb->list);
 	list_del(&block_cb->driver_list);
@@ -961,10 +962,9 @@ static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 					  enum flow_block_command cmd,
 					  struct netlink_ext_ack *extack)
 {
-	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
-					 extack);
+	nf_flow_table_block_offload_init(bo, dev, cmd, flowtable, extack);
 
-	return flow_indr_dev_setup_offload(dev, TC_SETUP_FT, flowtable, bo,
+	return flow_indr_dev_setup_offload(bo->sch, TC_SETUP_FT, flowtable, bo,
 					   nf_flow_table_indr_cleanup);
 }
 
@@ -976,8 +976,7 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
-					 extack);
+	nf_flow_table_block_offload_init(bo, dev, cmd, flowtable, extack);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index c7cf1cde46de..78dc93607d09 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -254,17 +254,18 @@ static int nft_block_setup(struct nft_base_chain *basechain,
 }
 
 static void nft_flow_block_offload_init(struct flow_block_offload *bo,
-					struct net *net,
+					struct net_device *dev,
 					enum flow_block_command cmd,
 					struct nft_base_chain *basechain,
 					struct netlink_ext_ack *extack)
 {
 	memset(bo, 0, sizeof(*bo));
-	bo->net		= net;
+	bo->net		= dev_net(dev);
 	bo->block	= &basechain->flow_block;
 	bo->command	= cmd;
 	bo->binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	bo->extack	= extack;
+	bo->sch		= dev_ingress_queue(dev)->qdisc_sleeping;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
@@ -276,7 +277,7 @@ static int nft_block_offload_cmd(struct nft_base_chain *chain,
 	struct flow_block_offload bo;
 	int err;
 
-	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
+	nft_flow_block_offload_init(&bo, dev, cmd, chain, &extack);
 
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 	if (err < 0)
@@ -288,13 +289,14 @@ static int nft_block_offload_cmd(struct nft_base_chain *chain,
 static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 {
 	struct nft_base_chain *basechain = block_cb->indr.data;
-	struct net_device *dev = block_cb->indr.dev;
+	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
-	struct net *net = dev_net(dev);
+	struct net *net = qdisc_net(sch);
 	struct flow_block_offload bo;
+	struct net_device *dev;
 
-	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
-				    basechain, &extack);
+	dev = sch->dev_queue->dev;
+	nft_flow_block_offload_init(&bo, dev, FLOW_BLOCK_UNBIND, basechain, &extack);
 	mutex_lock(&net->nft.commit_mutex);
 	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
@@ -310,9 +312,9 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 	struct flow_block_offload bo;
 	int err;
 
-	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, basechain, &extack);
+	nft_flow_block_offload_init(&bo, dev, cmd, basechain, &extack);
 
-	err = flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, basechain, &bo,
+	err = flow_indr_dev_setup_offload(bo.sch, TC_SETUP_BLOCK, basechain, &bo,
 					  nft_indr_block_cleanup);
 	if (err < 0)
 		return err;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e9e119ea6813..0e80b4a7f5fd 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -622,18 +622,21 @@ static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
 static void tcf_block_offload_init(struct flow_block_offload *bo,
-				   struct net_device *dev,
+				   struct Qdisc *sch,
 				   enum flow_block_command command,
 				   enum flow_block_binder_type binder_type,
 				   struct flow_block *flow_block,
 				   bool shared, struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = sch->dev_queue->dev;
+
 	bo->net = dev_net(dev);
 	bo->command = command;
 	bo->binder_type = binder_type;
 	bo->block = flow_block;
 	bo->block_shared = shared;
 	bo->extack = extack;
+	bo->sch = sch;
 	INIT_LIST_HEAD(&bo->cb_list);
 }
 
@@ -643,11 +646,11 @@ static void tcf_block_unbind(struct tcf_block *block,
 static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 {
 	struct tcf_block *block = block_cb->indr.data;
-	struct net_device *dev = block_cb->indr.dev;
+	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
 	struct flow_block_offload bo;
 
-	tcf_block_offload_init(&bo, dev, FLOW_BLOCK_UNBIND,
+	tcf_block_offload_init(&bo, sch, FLOW_BLOCK_UNBIND,
 			       block_cb->indr.binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
@@ -666,14 +669,15 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 }
 
 static int tcf_block_offload_cmd(struct tcf_block *block,
-				 struct net_device *dev,
+				 struct Qdisc *sch,
 				 struct tcf_block_ext_info *ei,
 				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = sch->dev_queue->dev;
 	struct flow_block_offload bo = {};
 
-	tcf_block_offload_init(&bo, dev, command, ei->binder_type,
+	tcf_block_offload_init(&bo, sch, command, ei->binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       extack);
 
@@ -690,7 +694,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 		return tcf_block_setup(block, &bo);
 	}
 
-	flow_indr_dev_setup_offload(dev, TC_SETUP_BLOCK, block, &bo,
+	flow_indr_dev_setup_offload(sch, TC_SETUP_BLOCK, block, &bo,
 				    tc_block_indr_cleanup);
 	tcf_block_setup(block, &bo);
 
@@ -717,7 +721,7 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 		goto err_unlock;
 	}
 
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, extack);
+	err = tcf_block_offload_cmd(block, q, ei, FLOW_BLOCK_BIND, extack);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
@@ -740,11 +744,10 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 				     struct tcf_block_ext_info *ei)
 {
-	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
 	down_write(&block->cb_lock);
-	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
+	err = tcf_block_offload_cmd(block, q, ei, FLOW_BLOCK_UNBIND, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
 	up_write(&block->cb_lock);
-- 
2.26.2

