Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09765FAECF
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJKJBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJKJBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:01:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EED74B9C
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 02:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665478911; x=1697014911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJtPTR0h/euSztMkexKDGtqAOvcU9wFFPmJ75diHEjY=;
  b=FmI3temDw/JSoHWh/4qGiQoA+BotCyodqzJSfqURBHXXOxLAutzcf7Yg
   zwaMKjCeMbtziyervoCFxXDLl3pKu+/WgiCxlvABiHng6gdweTRtuu6cH
   uat5p1iyz9gP6nQ9arddc6FvO+bfIUybhmEE0drXv9KG0nhz1e9iGATmX
   MMZqjCJ0ApVDEdgPCbwrpqcztgI8TC0Rw39oW8pXBzvSyOrvbf6XTHdtT
   hotXEUPQn84cdWXaLKJF+UPCC2T9xmI08jpDE6/zY9ANXPOdw+zDohyNr
   RZvwdJn/8GwnpcAMtTxVJFIMNNh/nf54ODFiFoxywk6tEGTR2KBZ4udN/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="284180731"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="284180731"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 02:01:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="659465805"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="659465805"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 02:01:48 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v5 1/4] devlink: Extend devlink-rate api with export functions and new params
Date:   Tue, 11 Oct 2022 11:01:10 +0200
Message-Id: <20221011090113.445485-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221011090113.445485-1-michal.wilczynski@intel.com>
References: <20221011090113.445485-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice driver needs an ability to create devlink-rate nodes from inside the
driver. We have default Tx-scheduler tree that we would like to
export as devlink-rate objects.

There is also a need to support additional parameters, besides two that
are supported currently:
tx_priority - priority among siblings (0-7)
tx_weight - weights for the WFQ algorithm (1-200)

Allow creation of nodes from the driver, and introduce new argument
to devl_rate_leaf_create, so the parent can be set during the creation
of the leaf node.

Implement new parameters - tx_priority, tx_weight.

Allow modification of the priv field in the devlink_rate from parent_set
callbacks. This is needed because creating nodes without parents doesn't
make any sense in ice driver case. It's much more elegant to actually
create a node when the parent is assigned.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   2 +-
 drivers/net/netdevsim/dev.c                   |  10 +-
 include/net/devlink.h                         |  21 ++-
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            | 145 ++++++++++++++++--
 7 files changed, 164 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 9bc7be95db54..084a910bb4e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -91,7 +91,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	if (err)
 		goto reg_err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
@@ -160,7 +160,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		return err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4f8a24d84a86..0b55a1e477f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -940,11 +940,11 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 
 int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
 				     struct devlink_rate *parent,
-				     void *priv, void *parent_priv,
+				     void **priv, void *parent_priv,
 				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_rate_group *group;
-	struct mlx5_vport *vport = priv;
+	struct mlx5_vport *vport = *priv;
 
 	if (!parent)
 		return mlx5_esw_qos_vport_update_group(vport->dev->priv.eswitch,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 0141e9d52037..d3b3ce26883b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -24,7 +24,7 @@ int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 				   struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
 				     struct devlink_rate *parent,
-				     void *priv, void *parent_priv,
+				     void **priv, void *parent_priv,
 				     struct netlink_ext_ack *extack);
 #endif
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 794fc0cc73b8..f5ae4aed8679 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1275,10 +1275,10 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
 
 static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
 				     struct devlink_rate *parent,
-				     void *priv_child, void *priv_parent,
+				     void **priv_child, void *priv_parent,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_dev_port *nsim_dev_port = priv_child;
+	struct nsim_dev_port *nsim_dev_port = *priv_child;
 
 	if (parent)
 		nsim_dev_port->parent_name = parent->name;
@@ -1289,10 +1289,10 @@ static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
 
 static int nsim_rate_node_parent_set(struct devlink_rate *child,
 				     struct devlink_rate *parent,
-				     void *priv_child, void *priv_parent,
+				     void **priv_child, void *priv_parent,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_rate_node *nsim_node = priv_child;
+	struct nsim_rate_node *nsim_node = *priv_child;
 
 	if (parent)
 		nsim_node->parent_name = parent->name;
@@ -1392,7 +1392,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
 		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
-					    nsim_dev_port);
+					    nsim_dev_port, NULL);
 		if (err)
 			goto err_nsim_destroy;
 	}
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b094943..37e73dcf2210 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -98,6 +98,8 @@ struct devlink_port_attrs {
 	};
 };
 
+#define DEVLINK_RATE_NAME_MAX_LEN 30
+
 struct devlink_rate {
 	struct list_head list;
 	enum devlink_rate_type type;
@@ -114,6 +116,9 @@ struct devlink_rate {
 			refcount_t refcnt;
 		};
 	};
+
+	u16 tx_priority;
+	u16 tx_weight;
 };
 
 struct devlink_port {
@@ -1493,21 +1498,29 @@ struct devlink_ops {
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_leaf_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
 	int (*rate_node_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
 	/**
 	 * selftests_check() - queries if selftest is supported
@@ -1589,7 +1602,9 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+int devl_rate_leaf_create(struct devlink_port *port, void *priv, char *parent_name);
+int devl_rate_node_create(struct devlink *devlink, void *priv,  char *node_name,
+			  char *parent_name);
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..9f3916e02a64 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..6cab70415dbd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1184,6 +1184,14 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
+			devlink_rate->tx_priority))
+		goto nla_put_failure;
+
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_WEIGHT,
+			devlink_rate->tx_weight))
+		goto nla_put_failure;
+
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1867,24 +1875,23 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 	int err = -EOPNOTSUPP;
 
 	parent = devlink_rate->parent;
-	if (parent && len) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
-		return -EBUSY;
-	} else if (parent && !len) {
+
+	/* if a parent is already set, just reassign the parent */
+	if (parent && !len) {
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
+							&devlink_rate->priv, NULL,
 							info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
+							&devlink_rate->priv, NULL,
 							info->extack);
 		if (err)
 			return err;
 
 		refcount_dec(&parent->refcnt);
 		devlink_rate->parent = NULL;
-	} else if (!parent && len) {
+	} else if (len) {
 		parent = devlink_rate_node_get_by_name(devlink, parent_name);
 		if (IS_ERR(parent))
 			return -ENODEV;
@@ -1902,15 +1909,19 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
+							&devlink_rate->priv, parent->priv,
 							info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
+							&devlink_rate->priv, parent->priv,
 							info->extack);
 		if (err)
 			return err;
 
+		if (devlink_rate->parent)
+			/* we're reassigning to other parent in this case */
+			refcount_dec(&devlink_rate->parent->refcnt);
+
 		refcount_inc(&parent->refcnt);
 		devlink_rate->parent = parent;
 	}
@@ -1924,6 +1935,8 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
+	u16 priority;
+	u16 weight;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1952,6 +1965,34 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_max = rate;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
+		priority = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_priority = priority;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]) {
+		weight = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_weight_set(devlink_rate, devlink_rate->priv,
+							 weight, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_weight_set(devlink_rate, devlink_rate->priv,
+							weight, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_weight = weight;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -1983,6 +2024,16 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the leafs");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_leaf_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -1997,6 +2048,16 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_node_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN(1, "Unknown type of rate object");
 		return false;
@@ -9172,6 +9233,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -10210,6 +10273,53 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
+/**
+ * devl_rate_node_create - create devlink rate node
+ * @devlink: devlink instance
+ * @priv: driver private data
+ * @node_name: name of the resulting node
+ * @parent_name: name of the parent of the resultion node
+ *
+ * Create devlink rate object of type node
+ */
+int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name, char *parent_name)
+{
+	struct devlink_rate *rate_node;
+	struct devlink_rate *parent;
+
+	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
+	if (!IS_ERR(rate_node))
+		return -EEXIST;
+
+	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
+	if (!rate_node)
+		return -ENOMEM;
+
+	if (parent_name) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent))
+			return -ENODEV;
+		rate_node->parent = parent;
+		refcount_inc(&rate_node->parent->refcnt);
+	}
+
+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
+	rate_node->devlink = devlink;
+	rate_node->priv = priv;
+
+	rate_node->name = kzalloc(DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
+	if (!rate_node->name)
+		return -ENOMEM;
+
+	strncpy(rate_node->name, node_name, DEVLINK_RATE_NAME_MAX_LEN);
+
+	refcount_set(&rate_node->refcnt, 1);
+	list_add(&rate_node->list, &devlink->rate_list);
+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_rate_node_create);
+
 /**
  * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
@@ -10217,10 +10327,11 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
  *
  * Create devlink rate object of type leaf on provided @devlink_port.
  */
-int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv, char *parent_name)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
+	struct devlink_rate *parent;
 
 	devl_assert_locked(devlink_port->devlink);
 
@@ -10231,6 +10342,16 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
+	if (parent_name) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent)) {
+			kfree(devlink_rate);
+			return -ENODEV;
+		}
+		devlink_rate->parent = parent;
+		refcount_inc(&devlink_rate->parent->refcnt);
+	}
+
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
@@ -10287,10 +10408,10 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 
 		refcount_dec(&devlink_rate->parent->refcnt);
 		if (devlink_rate_is_leaf(devlink_rate))
-			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
+			ops->rate_leaf_parent_set(devlink_rate, NULL, &devlink_rate->priv,
 						  NULL, NULL);
 		else if (devlink_rate_is_node(devlink_rate))
-			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
+			ops->rate_node_parent_set(devlink_rate, NULL, &devlink_rate->priv,
 						  NULL, NULL);
 	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
-- 
2.37.2

