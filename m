Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7051BA7A2
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgD0POM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:14:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32891 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728168AbgD0PNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 30EEE5C00A1;
        Mon, 27 Apr 2020 11:13:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=kCINnyleb/VT9Mpu5TkZ8XO3cn3xsHFlrr+gXbeRmfA=; b=XUPuotrw
        BxPSOBrZ1mmDoW2qVwEOCuEBLyKhhcL3iG2yRInZn4NRMqOlkPTqN32jrPsTDF7l
        uAIo/tGowUe23q4P5xj2GhPg+sR+oKLZ/Zr300S+qqMP1f2fZ26YtiZrMYLokwwz
        MKpO3uDqGDxrsqqIjbydMeQztrgSB+39WxZmANX1f+7L83alc0k2bpXkrzzlKI1n
        fqC/2UfeyWHpZOc/+H96duZyu0voU4mtn7L/vFJZqjT6qpxn/lUJqRWAOpIFvgZo
        FWpJeIXe396O40ui8oVkh3/6hFVE5FcyAQ+8jdXTfU/Lzkf9p9kbfTPk6sMuzUMX
        wYG04MzcwpKn2g==
X-ME-Sender: <xms:qfamXhyCAKvQKMqKhLwkX4zriqxBjG3h0kjhzKDxbY6bk2LgFLEFkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:qvamXgDzz9FDZJvF1VBKZT_cwNSXBpuA3gejb5bJlmnjGYKUdFOwrA>
    <xmx:qvamXv5tXIS0v24wDoIwqeMDL28ENByhP5bm-b9MUKnRuNcoaZFNWQ>
    <xmx:qvamXvn9NuUQ_mM88fjyg0RRcF6ra-k1jLB28IAtVfAJRRK9dRX7wA>
    <xmx:qvamXhcuKSYrcMtMxzNMK7pOQN_F_Wycl-zunHbb20mMV6QqLJ8BBA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2DA43280059;
        Mon, 27 Apr 2020 11:13:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/13] mlxsw: spectrum_matchall: Process matchall events from the same cb as flower
Date:   Mon, 27 Apr 2020 18:13:08 +0300
Message-Id: <20200427151310.3950411-12-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently there are two callbacks registered: one for matchall,
one for flower. This causes the user to see "in_hw_count 2" in TC filter
dump. Because of this and also as a preparation for future matchall
offload for rules equivalent to flower-all-match, move the processing of
shared block into matchall.c. Leave only one cb for mlxsw driver
per-block.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 125 ++++--------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |  17 ++-
 .../mellanox/mlxsw/spectrum_matchall.c        |  90 ++++++++++---
 4 files changed, 124 insertions(+), 120 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5952ec26c169..ceaf73ac2008 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1350,15 +1350,15 @@ static int mlxsw_sp_port_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static int mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
-					  struct tc_cls_matchall_offload *f,
-					  bool ingress)
+static int
+mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_flow_block *flow_block,
+			       struct tc_cls_matchall_offload *f)
 {
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return mlxsw_sp_mall_replace(mlxsw_sp_port, f, ingress);
+		return mlxsw_sp_mall_replace(flow_block, f);
 	case TC_CLSMATCHALL_DESTROY:
-		mlxsw_sp_mall_destroy(mlxsw_sp_port, f);
+		mlxsw_sp_mall_destroy(flow_block, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1389,62 +1389,25 @@ mlxsw_sp_setup_tc_cls_flower(struct mlxsw_sp_flow_block *flow_block,
 	}
 }
 
-static int mlxsw_sp_setup_tc_block_cb_matchall(enum tc_setup_type type,
-					       void *type_data,
-					       void *cb_priv, bool ingress)
+static int mlxsw_sp_setup_tc_block_cb(enum tc_setup_type type,
+				      void *type_data, void *cb_priv)
 {
-	struct mlxsw_sp_port *mlxsw_sp_port = cb_priv;
-
-	switch (type) {
-	case TC_SETUP_CLSMATCHALL:
-		if (!tc_cls_can_offload_and_chain0(mlxsw_sp_port->dev,
-						   type_data))
-			return -EOPNOTSUPP;
+	struct mlxsw_sp_flow_block *flow_block = cb_priv;
 
-		return mlxsw_sp_setup_tc_cls_matchall(mlxsw_sp_port, type_data,
-						      ingress);
-	case TC_SETUP_CLSFLOWER:
-		return 0;
-	default:
+	if (mlxsw_sp_flow_block_disabled(flow_block))
 		return -EOPNOTSUPP;
-	}
-}
-
-static int mlxsw_sp_setup_tc_block_cb_matchall_ig(enum tc_setup_type type,
-						  void *type_data,
-						  void *cb_priv)
-{
-	return mlxsw_sp_setup_tc_block_cb_matchall(type, type_data,
-						   cb_priv, true);
-}
-
-static int mlxsw_sp_setup_tc_block_cb_matchall_eg(enum tc_setup_type type,
-						  void *type_data,
-						  void *cb_priv)
-{
-	return mlxsw_sp_setup_tc_block_cb_matchall(type, type_data,
-						   cb_priv, false);
-}
-
-static int mlxsw_sp_setup_tc_block_cb_flower(enum tc_setup_type type,
-					     void *type_data, void *cb_priv)
-{
-	struct mlxsw_sp_flow_block *flow_block = cb_priv;
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		return 0;
+		return mlxsw_sp_setup_tc_cls_matchall(flow_block, type_data);
 	case TC_SETUP_CLSFLOWER:
-		if (mlxsw_sp_flow_block_disabled(flow_block))
-			return -EOPNOTSUPP;
-
 		return mlxsw_sp_setup_tc_cls_flower(flow_block, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
+static void mlxsw_sp_tc_block_release(void *cb_priv)
 {
 	struct mlxsw_sp_flow_block *flow_block = cb_priv;
 
@@ -1453,9 +1416,9 @@ static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
 
 static LIST_HEAD(mlxsw_sp_block_cb_list);
 
-static int
-mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-			            struct flow_block_offload *f, bool ingress)
+static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f,
+					bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_flow_block *flow_block;
@@ -1463,16 +1426,15 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool register_block = false;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f->block,
-					mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_setup_tc_block_cb,
 					mlxsw_sp);
 	if (!block_cb) {
 		flow_block = mlxsw_sp_flow_block_create(mlxsw_sp, f->net);
 		if (!flow_block)
 			return -ENOMEM;
-		block_cb = flow_block_cb_alloc(mlxsw_sp_setup_tc_block_cb_flower,
+		block_cb = flow_block_cb_alloc(mlxsw_sp_setup_tc_block_cb,
 					       mlxsw_sp, flow_block,
-					       mlxsw_sp_tc_block_flower_release);
+					       mlxsw_sp_tc_block_release);
 		if (IS_ERR(block_cb)) {
 			mlxsw_sp_flow_block_destroy(flow_block);
 			err = PTR_ERR(block_cb);
@@ -1507,18 +1469,16 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static void
-mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct flow_block_offload *f,
-				      bool ingress)
+static void mlxsw_sp_setup_tc_block_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
+					   struct flow_block_offload *f,
+					   bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_flow_block *flow_block;
 	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = flow_block_cb_lookup(f->block,
-					mlxsw_sp_setup_tc_block_cb_flower,
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_setup_tc_block_cb,
 					mlxsw_sp);
 	if (!block_cb)
 		return;
@@ -1540,51 +1500,22 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct flow_block_offload *f)
 {
-	struct flow_block_cb *block_cb;
-	flow_setup_cb_t *cb;
 	bool ingress;
-	int err;
 
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
-		cb = mlxsw_sp_setup_tc_block_cb_matchall_ig;
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		ingress = true;
-	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
-		cb = mlxsw_sp_setup_tc_block_cb_matchall_eg;
+	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		ingress = false;
-	} else {
+	else
 		return -EOPNOTSUPP;
-	}
 
 	f->driver_block_list = &mlxsw_sp_block_cb_list;
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		if (flow_block_cb_is_busy(cb, mlxsw_sp_port,
-					  &mlxsw_sp_block_cb_list))
-			return -EBUSY;
-
-		block_cb = flow_block_cb_alloc(cb, mlxsw_sp_port,
-					       mlxsw_sp_port, NULL);
-		if (IS_ERR(block_cb))
-			return PTR_ERR(block_cb);
-		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
-							  ingress);
-		if (err) {
-			flow_block_cb_free(block_cb);
-			return err;
-		}
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
-		return 0;
+		return mlxsw_sp_setup_tc_block_bind(mlxsw_sp_port, f, ingress);
 	case FLOW_BLOCK_UNBIND:
-		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
-						      f, ingress);
-		block_cb = flow_block_cb_lookup(f->block, cb, mlxsw_sp_port);
-		if (!block_cb)
-			return -ENOENT;
-
-		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
+		mlxsw_sp_setup_tc_block_unbind(mlxsw_sp_port, f, ingress);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1621,8 +1552,7 @@ static int mlxsw_sp_feature_hw_tc(struct net_device *dev, bool enable)
 
 	if (!enable) {
 		if (mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->ing_flow_block) ||
-		    mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->eg_flow_block) ||
-		    !list_empty(&mlxsw_sp_port->mall_list)) {
+		    mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->eg_flow_block)) {
 			netdev_err(dev, "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 			return -EINVAL;
 		}
@@ -3518,7 +3448,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port->mapping = *port_mapping;
 	mlxsw_sp_port->link.autoneg = 1;
 	INIT_LIST_HEAD(&mlxsw_sp_port->vlans_list);
-	INIT_LIST_HEAD(&mlxsw_sp_port->mall_list);
 
 	mlxsw_sp_port->pcpu_stats =
 		netdev_alloc_pcpu_stats(struct mlxsw_sp_port_pcpu_stats);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 4cdb7f1d7436..57d320728914 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -255,7 +255,6 @@ struct mlxsw_sp_port {
 					       * the same localport can have
 					       * different mapping.
 					       */
-	struct list_head mall_list;
 	struct {
 		#define MLXSW_HW_STATS_UPDATE_TIME HZ
 		struct rtnl_link_stats64 stats;
@@ -637,6 +636,7 @@ struct mlxsw_sp_acl_rule_info {
 /* spectrum_flow.c */
 struct mlxsw_sp_flow_block {
 	struct list_head binding_list;
+	struct list_head mall_list;
 	struct mlxsw_sp_acl_ruleset *ruleset_zero;
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned int rule_count;
@@ -894,10 +894,14 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_matchall.c */
-int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct tc_cls_matchall_offload *f, bool ingress);
-void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
+			  struct tc_cls_matchall_offload *f);
+void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 			   struct tc_cls_matchall_offload *f);
+int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
+			    struct mlxsw_sp_port *mlxsw_sp_port);
+void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port);
 
 /* spectrum_flower.c */
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 655e1df5c95a..51de6aca1930 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -18,6 +18,7 @@ mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp, struct net *net)
 	if (!block)
 		return NULL;
 	INIT_LIST_HEAD(&block->binding_list);
+	INIT_LIST_HEAD(&block->mall_list);
 	block->mlxsw_sp = mlxsw_sp;
 	block->net = net;
 	return block;
@@ -70,9 +71,15 @@ int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 	}
 
+	err = mlxsw_sp_mall_port_bind(block, mlxsw_sp_port);
+	if (err)
+		return err;
+
 	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
-	if (!binding)
-		return -ENOMEM;
+	if (!binding) {
+		err = -ENOMEM;
+		goto err_binding_alloc;
+	}
 	binding->mlxsw_sp_port = mlxsw_sp_port;
 	binding->ingress = ingress;
 
@@ -91,6 +98,9 @@ int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
 
 err_ruleset_bind:
 	kfree(binding);
+err_binding_alloc:
+	mlxsw_sp_mall_port_unbind(block, mlxsw_sp_port);
+
 	return err;
 }
 
@@ -116,5 +126,8 @@ int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_acl_ruleset_unbind(mlxsw_sp, block, binding);
 
 	kfree(binding);
+
+	mlxsw_sp_mall_port_unbind(block, mlxsw_sp_port);
+
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index bda5fb34162a..889da63072be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -33,11 +33,11 @@ struct mlxsw_sp_mall_entry {
 };
 
 static struct mlxsw_sp_mall_entry *
-mlxsw_sp_mall_entry_find(struct mlxsw_sp_port *port, unsigned long cookie)
+mlxsw_sp_mall_entry_find(struct mlxsw_sp_flow_block *block, unsigned long cookie)
 {
 	struct mlxsw_sp_mall_entry *mall_entry;
 
-	list_for_each_entry(mall_entry, &port->mall_list, list)
+	list_for_each_entry(mall_entry, &block->mall_list, list)
 		if (mall_entry->cookie == cookie)
 			return mall_entry;
 
@@ -149,16 +149,27 @@ mlxsw_sp_mall_port_rule_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct tc_cls_matchall_offload *f, bool ingress)
+int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
+			  struct tc_cls_matchall_offload *f)
 {
+	struct mlxsw_sp_flow_block_binding *binding;
 	struct mlxsw_sp_mall_entry *mall_entry;
 	__be16 protocol = f->common.protocol;
 	struct flow_action_entry *act;
 	int err;
 
 	if (!flow_offload_has_one_action(&f->rule->action)) {
-		netdev_err(mlxsw_sp_port->dev, "only singular actions are supported\n");
+		NL_SET_ERR_MSG(f->common.extack, "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (f->common.chain_index) {
+		NL_SET_ERR_MSG(f->common.extack, "Only chain 0 is supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (mlxsw_sp_flow_block_is_mixed_bound(block)) {
+		NL_SET_ERR_MSG(f->common.extack, "Only not mixed bound blocks are supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -166,7 +177,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!mall_entry)
 		return -ENOMEM;
 	mall_entry->cookie = f->cookie;
-	mall_entry->ingress = ingress;
+	mall_entry->ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
 
 	act = &f->rule->action.entries[0];
 
@@ -176,7 +187,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
 		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
-			netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
+			NL_SET_ERR_MSG(f->common.extack, "Sample rate not supported");
 			err = -EOPNOTSUPP;
 			goto errout;
 		}
@@ -190,31 +201,78 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 		goto errout;
 	}
 
-	err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry);
-	if (err)
-		goto errout;
+	list_for_each_entry(binding, &block->binding_list, list) {
+		err = mlxsw_sp_mall_port_rule_add(binding->mlxsw_sp_port,
+						  mall_entry);
+		if (err)
+			goto rollback;
+	}
 
-	list_add_tail(&mall_entry->list, &mlxsw_sp_port->mall_list);
+	block->rule_count++;
+	if (mall_entry->ingress)
+		block->egress_blocker_rule_count++;
+	else
+		block->ingress_blocker_rule_count++;
+	list_add_tail(&mall_entry->list, &block->mall_list);
 	return 0;
 
+rollback:
+	list_for_each_entry_continue_reverse(binding, &block->binding_list,
+					     list)
+		mlxsw_sp_mall_port_rule_del(binding->mlxsw_sp_port, mall_entry);
 errout:
 	kfree(mall_entry);
 	return err;
 }
 
-void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 			   struct tc_cls_matchall_offload *f)
 {
+	struct mlxsw_sp_flow_block_binding *binding;
 	struct mlxsw_sp_mall_entry *mall_entry;
 
-	mall_entry = mlxsw_sp_mall_entry_find(mlxsw_sp_port, f->cookie);
+	mall_entry = mlxsw_sp_mall_entry_find(block, f->cookie);
 	if (!mall_entry) {
-		netdev_dbg(mlxsw_sp_port->dev, "tc entry not found on port\n");
+		NL_SET_ERR_MSG(f->common.extack, "Entry not found");
 		return;
 	}
 
-	mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
-
 	list_del(&mall_entry->list);
+	if (mall_entry->ingress)
+		block->egress_blocker_rule_count--;
+	else
+		block->ingress_blocker_rule_count--;
+	block->rule_count--;
+	list_for_each_entry(binding, &block->binding_list, list)
+		mlxsw_sp_mall_port_rule_del(binding->mlxsw_sp_port, mall_entry);
 	kfree_rcu(mall_entry, rcu); /* sample RX packets may be in-flight */
 }
+
+int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
+			    struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+	int err;
+
+	list_for_each_entry(mall_entry, &block->mall_list, list) {
+		err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry);
+		if (err)
+			goto rollback;
+	}
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(mall_entry, &block->mall_list,
+					     list)
+		mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
+	return err;
+}
+
+void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	list_for_each_entry(mall_entry, &block->mall_list, list)
+		mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
+}
-- 
2.24.1

