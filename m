Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647D85B9C2D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiIONoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiIONoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:44:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E417FFB9
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249436; x=1694785436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WHZp6cVPR9GYJRnzoze4HOZTgBCEkR9r+NncuXFCjdc=;
  b=EniC+sUNhz8q3CSg1NuzeypdZcKdUWlEhMyfHGnFTHV4cF2ca0+EUolo
   Teg7AdTw/7XXiUw0DHhl+7+ZFC19pHPLMKWQxyOxdKoq1YipsJd1LIIJG
   V50ZHNGXK/soblJMYhDz7Prf6NPToziWPdaDtAC3TM/CBYpxNN7LjG0i9
   2tYk93zk59q6HEmwIsDmUEDbLNiKupMOta2ad5qyxjzlToGfxiPGqZvhV
   BD/MvEBiP4KkmYv5aVFLNvnDp6a9rivBgP3H2hQrrB/LX6svRwPHjkswp
   CNDBM1efha0qlLaSPcD3rM3WCPwUrhXf1PW+pz06NxfKIYXqYqq10NBOG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100021"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100021"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617278953"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:53 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with queues and new parameters
Date:   Thu, 15 Sep 2022 15:42:35 +0200
Message-Id: <20220915134239.1935604-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently devlink-rate only have two types of objects: nodes and leafs.
There is a need to extend this interface to account for a third type of
scheduling elements - queues. In our use case customer is sending
different types of traffic on each queue, which requires an ability to
assign rate parameters to individual queues.

Also, besides two basic parameters provided currently: tx_share and tx_max
we also need two additional parameters to utilize the WFQ (Weighted Fair
Queueing) algorithm.

tx_priority - priority among siblings (0-7)
tx_weight - weights for the WFQ algorithm (1-200)

The whole lifecycle of the queue is being managed from the driver.
User using the 'devlink' utility might reconfigure the queue parent to a
different node, or change it's parameters.

Example:
devlink port function rate set pci/0000:4b:00.0/queue/91 parent node_custom

Rename the current 'leaf' node to 'vport', since the old name doesn't make
any sense anymore. And the only use case for the leaf nodes so far seem to
be a 'vport' or 'VF'.

Allow creation of the node elements from the driver. This is needed,
since in our use case it makes sense that the driver first exports it's
initial TX topology.

Rearrange elements in devlink_rate struct to remove holes.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |  10 +-
 drivers/net/netdevsim/dev.c                   |  32 +-
 include/net/devlink.h                         |  56 ++-
 include/uapi/linux/devlink.h                  |   8 +-
 net/core/devlink.c                            | 407 +++++++++++++++---
 8 files changed, 436 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 66c6a7017695..754318ea8cf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -311,13 +311,13 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
-	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
-	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
+	.rate_vport_tx_share_set = mlx5_esw_devlink_rate_vport_tx_share_set,
+	.rate_vport_tx_max_set = mlx5_esw_devlink_rate_vport_tx_max_set,
 	.rate_node_tx_share_set = mlx5_esw_devlink_rate_node_tx_share_set,
 	.rate_node_tx_max_set = mlx5_esw_devlink_rate_node_tx_max_set,
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
-	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
+	.rate_vport_parent_set = mlx5_esw_devlink_rate_parent_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 9bc7be95db54..cafd3bdcabc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -91,7 +91,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	if (err)
 		goto reg_err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_vport_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
@@ -118,7 +118,7 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 
 	if (vport->dl_port->devlink_rate) {
 		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
-		devl_rate_leaf_destroy(vport->dl_port);
+		devl_rate_vport_destroy(vport->dl_port);
 	}
 
 	devl_port_unregister(vport->dl_port);
@@ -160,7 +160,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		return err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_vport_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
@@ -182,7 +182,7 @@ void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num
 
 	if (vport->dl_port->devlink_rate) {
 		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
-		devl_rate_leaf_destroy(vport->dl_port);
+		devl_rate_vport_destroy(vport->dl_port);
 	}
 
 	devl_port_unregister(vport->dl_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 694c54066955..9af0101ea7b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -783,8 +783,8 @@ static int esw_qos_devlink_rate_to_mbps(struct mlx5_core_dev *mdev, const char *
 
 /* Eswitch devlink rate API */
 
-int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
-					    u64 tx_share, struct netlink_ext_ack *extack)
+int mlx5_esw_devlink_rate_vport_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
+					     u64 tx_share, struct netlink_ext_ack *extack)
 {
 	struct mlx5_vport *vport = priv;
 	struct mlx5_eswitch *esw;
@@ -809,8 +809,8 @@ int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void
 	return err;
 }
 
-int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
-					  u64 tx_max, struct netlink_ext_ack *extack)
+int mlx5_esw_devlink_rate_vport_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
+					   u64 tx_max, struct netlink_ext_ack *extack)
 {
 	struct mlx5_vport *vport = priv;
 	struct mlx5_eswitch *esw;
@@ -936,11 +936,11 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 
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
index 0141e9d52037..61359455a962 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -10,10 +10,10 @@ int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evp
 				u32 max_rate, u32 min_rate);
 void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
-int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
-					    u64 tx_share, struct netlink_ext_ack *extack);
-int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
-					  u64 tx_max, struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_vport_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
+					     u64 tx_share, struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_vport_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
+					   u64 tx_max, struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, void *priv,
 					    u64 tx_share, struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void *priv,
@@ -24,7 +24,7 @@ int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 				   struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
 				     struct devlink_rate *parent,
-				     void *priv, void *parent_priv,
+				     void **priv, void *parent_priv,
 				     struct netlink_ext_ack *extack);
 #endif
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 794fc0cc73b8..17073abc4af5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1166,8 +1166,8 @@ static int nsim_rate_bytes_to_units(char *name, u64 *rate, struct netlink_ext_ac
 	return 0;
 }
 
-static int nsim_leaf_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
-				  u64 tx_share, struct netlink_ext_ack *extack)
+static int nsim_vport_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
+				   u64 tx_share, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev_port *nsim_dev_port = priv;
 	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
@@ -1182,8 +1182,8 @@ static int nsim_leaf_tx_share_set(struct devlink_rate *devlink_rate, void *priv,
 	return 0;
 }
 
-static int nsim_leaf_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
-				u64 tx_max, struct netlink_ext_ack *extack)
+static int nsim_vport_tx_max_set(struct devlink_rate *devlink_rate, void *priv,
+				 u64 tx_max, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev_port *nsim_dev_port = priv;
 	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
@@ -1273,10 +1273,10 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
 	return 0;
 }
 
-static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
-				     struct devlink_rate *parent,
-				     void *priv_child, void *priv_parent,
-				     struct netlink_ext_ack *extack)
+static int nsim_rate_vport_set(struct devlink_rate *child,
+			       struct devlink_rate *parent,
+			       void *priv_child, void *priv_parent,
+			       struct netlink_ext_ack *extack)
 {
 	struct nsim_dev_port *nsim_dev_port = priv_child;
 
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
@@ -1332,13 +1332,13 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
-	.rate_leaf_tx_share_set = nsim_leaf_tx_share_set,
-	.rate_leaf_tx_max_set = nsim_leaf_tx_max_set,
+	.rate_vport_tx_share_set = nsim_vport_tx_share_set,
+	.rate_vport_tx_max_set = nsim_vport_tx_max_set,
 	.rate_node_tx_share_set = nsim_node_tx_share_set,
 	.rate_node_tx_max_set = nsim_node_tx_max_set,
 	.rate_node_new = nsim_rate_node_new,
 	.rate_node_del = nsim_rate_node_del,
-	.rate_leaf_parent_set = nsim_rate_leaf_parent_set,
+	.rate_vport_parent_set = nsim_rate_node_parent_set,
 	.rate_node_parent_set = nsim_rate_node_parent_set,
 	.trap_drop_counter_get = nsim_dev_devlink_trap_drop_counter_get,
 };
@@ -1391,8 +1391,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	}
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
-		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
-					    nsim_dev_port);
+		err = devl_rate_vport_create(&nsim_dev_port->devlink_port,
+					     nsim_dev_port, NULL);
 		if (err)
 			goto err_nsim_destroy;
 	}
@@ -1419,7 +1419,7 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
-		devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
+		devl_rate_vport_destroy(&nsim_dev_port->devlink_port);
 	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 264aa98e6da6..885e1999eb87 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -98,22 +98,22 @@ struct devlink_port_attrs {
 	};
 };
 
+#define DEVLINK_RATE_NAME_MAX_LEN 30
+
 struct devlink_rate {
 	struct list_head list;
-	enum devlink_rate_type type;
 	struct devlink *devlink;
 	void *priv;
 	u64 tx_share;
 	u64 tx_max;
-
 	struct devlink_rate *parent;
-	union {
-		struct devlink_port *devlink_port;
-		struct {
-			char *name;
-			refcount_t refcnt;
-		};
-	};
+	struct devlink_port *devlink_port;
+	char *name;
+	refcount_t refcnt;
+	enum devlink_rate_type type;
+	u16 queue_id;
+	u16 tx_priority;
+	u16 tx_weight;
 };
 
 struct devlink_port {
@@ -1487,26 +1487,46 @@ struct devlink_ops {
 	/**
 	 * Rate control callbacks.
 	 */
-	int (*rate_leaf_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
+	int (*rate_vport_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
-	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+	int (*rate_vport_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_vport_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_vport_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_weight, struct netlink_ext_ack *extack);
+	int (*rate_queue_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_queue_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_share, struct netlink_ext_ack *extack);
+	int (*rate_queue_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_queue_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				    u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
 			     struct netlink_ext_ack *extack);
-	int (*rate_leaf_parent_set)(struct devlink_rate *child,
+	int (*rate_vport_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
 	int (*rate_node_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
+	int (*rate_queue_parent_set)(struct devlink_rate *child,
+				     struct devlink_rate *parent,
+				     void **priv_child, void *priv_parent,
+				     struct netlink_ext_ack *extack);
 	/**
 	 * selftests_check() - queries if selftest is supported
 	 * @devlink: devlink instance
@@ -1584,9 +1604,13 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
-void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
+int devl_rate_node_create(struct devlink *devlink, void *priv,  char *node_name,
+			  char *parent_name);
+int devl_rate_vport_create(struct devlink_port *port, void *priv, char *parent_name);
+int devl_rate_queue_create(struct devlink *devlink, char *parent_name, u16 queue_id, void *priv);
+void devl_rate_vport_destroy(struct devlink_port *devlink_port);
 void devl_rate_nodes_destroy(struct devlink *devlink);
+void devl_rate_objects_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
 struct devlink_linecard *
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..2eb5b8dbfe59 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -220,8 +220,10 @@ enum devlink_port_flavour {
 };
 
 enum devlink_rate_type {
-	DEVLINK_RATE_TYPE_LEAF,
+	DEVLINK_RATE_TYPE_LEAF, /* deprecated, leaving this for backward compatibility */
 	DEVLINK_RATE_TYPE_NODE,
+	DEVLINK_RATE_TYPE_QUEUE,
+	DEVLINK_RATE_TYPE_VPORT,
 };
 
 enum devlink_param_cmode {
@@ -607,6 +609,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_QUEUE,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7776dc82f88d..930a3b6b4fcd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -411,9 +411,10 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 }
 
 static inline bool
-devlink_rate_is_leaf(struct devlink_rate *devlink_rate)
+devlink_rate_is_vport(struct devlink_rate *devlink_rate)
 {
-	return devlink_rate->type == DEVLINK_RATE_TYPE_LEAF;
+	return devlink_rate->type == DEVLINK_RATE_TYPE_VPORT ||
+	       devlink_rate->type == DEVLINK_RATE_TYPE_LEAF;
 }
 
 static inline bool
@@ -422,8 +423,14 @@ devlink_rate_is_node(struct devlink_rate *devlink_rate)
 	return devlink_rate->type == DEVLINK_RATE_TYPE_NODE;
 }
 
+static inline bool
+devlink_rate_is_queue(struct devlink_rate *devlink_rate)
+{
+	return devlink_rate->type == DEVLINK_RATE_TYPE_QUEUE;
+}
+
 static struct devlink_rate *
-devlink_rate_leaf_get_from_info(struct devlink *devlink, struct genl_info *info)
+devlink_rate_vport_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
 	struct devlink_rate *devlink_rate;
 	struct devlink_port *devlink_port;
@@ -441,8 +448,22 @@ devlink_rate_node_get_by_name(struct devlink *devlink, const char *node_name)
 	static struct devlink_rate *devlink_rate;
 
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
-		if (devlink_rate_is_node(devlink_rate) &&
-		    !strcmp(node_name, devlink_rate->name))
+		if ((devlink_rate_is_node(devlink_rate) ||
+		     devlink_rate_is_vport(devlink_rate)) &&
+		     !strcmp(node_name, devlink_rate->name))
+			return devlink_rate;
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static struct devlink_rate *
+devlink_rate_queue_get_by_id(struct devlink *devlink, u16 queue_id)
+{
+	static struct devlink_rate *devlink_rate;
+
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+		if (devlink_rate_is_queue(devlink_rate) &&
+		    devlink_rate->queue_id == queue_id)
 			return devlink_rate;
 	}
 	return ERR_PTR(-ENODEV);
@@ -465,6 +486,30 @@ devlink_rate_node_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
 	return devlink_rate_node_get_by_name(devlink, rate_node_name);
 }
 
+static struct devlink_rate *
+devlink_rate_queue_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
+{
+	struct devlink_rate *devlink_rate;
+	u16 queue_id;
+
+	if (!attrs[DEVLINK_ATTR_RATE_QUEUE])
+		return ERR_PTR(-EINVAL);
+
+	queue_id = nla_get_u16(attrs[DEVLINK_ATTR_RATE_QUEUE]);
+
+	devlink_rate = devlink_rate_queue_get_by_id(devlink, queue_id);
+	if (!devlink_rate)
+		return ERR_PTR(-ENODEV);
+
+	return devlink_rate;
+}
+
+static struct devlink_rate *
+devlink_rate_queue_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	return devlink_rate_queue_get_from_attrs(devlink, info->attrs);
+}
+
 static struct devlink_rate *
 devlink_rate_node_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
@@ -477,9 +522,11 @@ devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 
 	if (attrs[DEVLINK_ATTR_PORT_INDEX])
-		return devlink_rate_leaf_get_from_info(devlink, info);
+		return devlink_rate_vport_get_from_info(devlink, info);
 	else if (attrs[DEVLINK_ATTR_RATE_NODE_NAME])
 		return devlink_rate_node_get_from_info(devlink, info);
+	else if (attrs[DEVLINK_ATTR_RATE_QUEUE])
+		return devlink_rate_queue_get_from_info(devlink, info);
 	else
 		return ERR_PTR(-EINVAL);
 }
@@ -1159,7 +1206,7 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TYPE, devlink_rate->type))
 		goto nla_put_failure;
 
-	if (devlink_rate_is_leaf(devlink_rate)) {
+	if (devlink_rate_is_vport(devlink_rate)) {
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
 				devlink_rate->devlink_port->index))
 			goto nla_put_failure;
@@ -1167,6 +1214,10 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_NODE_NAME,
 				   devlink_rate->name))
 			goto nla_put_failure;
+	} else if (devlink_rate_is_queue(devlink_rate)) {
+		if (nla_put_u16(msg, DEVLINK_ATTR_RATE_QUEUE,
+				devlink_rate->queue_id))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RATE_TX_SHARE,
@@ -1177,10 +1228,19 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
-	if (devlink_rate->parent)
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
+			devlink_rate->tx_priority))
+		goto nla_put_failure;
+
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_WEIGHT,
+			devlink_rate->tx_weight))
+		goto nla_put_failure;
+
+	if (devlink_rate->parent && devlink_rate->parent->name) {
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
 			goto nla_put_failure;
+	}
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -1860,25 +1920,27 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 	int err = -EOPNOTSUPP;
 
 	parent = devlink_rate->parent;
-	if (parent && len) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
-		return -EBUSY;
-	} else if (parent && !len) {
-		if (devlink_rate_is_leaf(devlink_rate))
-			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
-							info->extack);
+	if (parent && !len) {
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_parent_set(devlink_rate, NULL,
+							 &devlink_rate->priv, NULL,
+							 info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
+							&devlink_rate->priv, NULL,
 							info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_parent_set(devlink_rate, NULL,
+							 &devlink_rate->priv, NULL,
+							 info->extack);
 		if (err)
 			return err;
 
 		refcount_dec(&parent->refcnt);
 		devlink_rate->parent = NULL;
-	} else if (!parent && len) {
+	} else if (len) {
 		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+
 		if (IS_ERR(parent))
 			return -ENODEV;
 
@@ -1893,17 +1955,25 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 			return -EEXIST;
 		}
 
-		if (devlink_rate_is_leaf(devlink_rate))
-			err = ops->rate_leaf_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
-							info->extack);
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_parent_set(devlink_rate, parent,
+							 &devlink_rate->priv, parent->priv,
+							 info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
+							&devlink_rate->priv, parent->priv,
 							info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_parent_set(devlink_rate, parent,
+							 &devlink_rate->priv, parent->priv,
+							 info->extack);
 		if (err)
 			return err;
 
+		if (devlink_rate->parent)
+			/* we're reassigning to other parent in this case */
+			refcount_dec(&devlink_rate->parent->refcnt);
+
 		refcount_inc(&parent->refcnt);
 		devlink_rate->parent = parent;
 	}
@@ -1917,16 +1987,21 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
+	u16 priority;
+	u16 weight;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
 		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_SHARE]);
-		if (devlink_rate_is_leaf(devlink_rate))
-			err = ops->rate_leaf_tx_share_set(devlink_rate, devlink_rate->priv,
-							  rate, info->extack);
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_tx_share_set(devlink_rate, devlink_rate->priv,
+							   rate, info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_tx_share_set(devlink_rate, devlink_rate->priv,
 							  rate, info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_tx_share_set(devlink_rate, devlink_rate->priv,
+							   rate, info->extack);
 		if (err)
 			return err;
 		devlink_rate->tx_share = rate;
@@ -1934,17 +2009,52 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_MAX]) {
 		rate = nla_get_u64(attrs[DEVLINK_ATTR_RATE_TX_MAX]);
-		if (devlink_rate_is_leaf(devlink_rate))
-			err = ops->rate_leaf_tx_max_set(devlink_rate, devlink_rate->priv,
-							rate, info->extack);
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_tx_max_set(devlink_rate, devlink_rate->priv,
+							 rate, info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_tx_max_set(devlink_rate, devlink_rate->priv,
 							rate, info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_tx_max_set(devlink_rate, devlink_rate->priv,
+							rate, info->extack);
 		if (err)
 			return err;
 		devlink_rate->tx_max = rate;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
+		priority = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+		if (err)
+			return err;
+		devlink_rate->tx_priority = rate;
+	}
+
+	if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]) {
+		weight = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]);
+		if (devlink_rate_is_vport(devlink_rate))
+			err = ops->rate_vport_tx_weight_set(devlink_rate, devlink_rate->priv,
+							 weight, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_weight_set(devlink_rate, devlink_rate->priv,
+							weight, info->extack);
+		else if (devlink_rate_is_queue(devlink_rate))
+			err = ops->rate_queue_tx_weight_set(devlink_rate, devlink_rate->priv,
+							weight, info->extack);
+		if (err)
+			return err;
+		devlink_rate->tx_weight = weight;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -1962,32 +2072,85 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 {
 	struct nlattr **attrs = info->attrs;
 
-	if (type == DEVLINK_RATE_TYPE_LEAF) {
-		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_leaf_tx_share_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the leafs");
+	if (type == DEVLINK_RATE_TYPE_VPORT || type == DEVLINK_RATE_TYPE_LEAF) {
+		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_vport_tx_share_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX share set isn't supported for the vports");
 			return false;
 		}
-		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_leaf_tx_max_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the leafs");
+		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_vport_tx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the vports");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_vport_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the vports");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_vport_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the vports");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
-		    !ops->rate_leaf_parent_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
+		    !ops->rate_vport_parent_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Parent set isn't supported for the vports");
 			return false;
 		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX share set isn't supported for the nodes");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_node_tx_max_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "TX max set isn't supported for the nodes");
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the nodes");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_node_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the nodes");
 			return false;
 		}
 		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
 		    !ops->rate_node_parent_set) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Parent set isn't supported for the nodes");
+			return false;
+		}
+	} else if (type == DEVLINK_RATE_TYPE_QUEUE) {
+		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX share set isn't supported for the queues");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_MAX] && !ops->rate_node_tx_max_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX max set isn't supported for the queues");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the queues");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_node_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the queues");
+			return false;
+		}
+		if (attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] &&
+		    !ops->rate_queue_parent_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Parent set isn't supported for the queues");
 			return false;
 		}
 	} else {
@@ -9165,6 +9328,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_QUEUE] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -10165,16 +10331,105 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
 /**
- * devl_rate_leaf_create - create devlink rate leaf
+ * devl_rate_queue_create - create devlink rate queue
+ * @devlink: devlink instance
+ * @parent_name: name of the parent of the resultion node
+ * @queue_id: identifier of the new queue
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type node
+ */
+int devl_rate_queue_create(struct devlink *devlink, char *parent_name, u16 queue_id, void *priv)
+{
+	struct devlink_rate *devlink_rate;
+
+	devl_assert_locked(devlink);
+
+	devlink_rate = devlink_rate_queue_get_by_id(devlink, queue_id);
+	if (!IS_ERR(devlink_rate))
+		return -EEXIST;
+
+	devlink_rate = kzalloc(sizeof(*devlink_rate), GFP_KERNEL);
+	if (!devlink_rate)
+		return -ENOMEM;
+
+	devlink_rate->parent = devlink_rate_node_get_by_name(devlink, parent_name);
+	if (IS_ERR(devlink_rate->parent))
+		devlink_rate->parent = NULL;
+
+	if (devlink_rate->parent)
+		refcount_inc(&devlink_rate->parent->refcnt);
+
+	devlink_rate->type = DEVLINK_RATE_TYPE_QUEUE;
+	devlink_rate->devlink = devlink;
+	devlink_rate->queue_id = queue_id;
+	devlink_rate->priv = priv;
+	list_add_tail(&devlink_rate->list, &devlink->rate_list);
+	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_rate_queue_create);
+
+/**
+ * devl_rate_node_create - create devlink rate vport
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
+	rate_node->devlink = devlink;
+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
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
+/**
+ * devl_rate_vport_create - create devlink rate vport
  * @devlink_port: devlink port object to create rate object on
  * @priv: driver private data
  *
- * Create devlink rate object of type leaf on provided @devlink_port.
+ * Create devlink rate object of type vport on provided @devlink_port.
  */
-int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int devl_rate_vport_create(struct devlink_port *devlink_port, void *priv, char *parent_name)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
+	struct devlink_rate *parent;
 
 	devl_assert_locked(devlink_port->devlink);
 
@@ -10185,26 +10440,42 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
+	if (parent_name) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent))
+			return -ENODEV;
+		devlink_rate->parent = parent;
+		refcount_inc(&devlink_rate->parent->refcnt);
+	}
+
+	devlink_rate->name = kzalloc(DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
+	if (!devlink_rate->name)
+		return -ENOMEM;
+
+	snprintf(devlink_rate->name, DEVLINK_RATE_NAME_MAX_LEN, "vport_%u",
+		 devlink_port->index);
+
+	devlink_rate->type = DEVLINK_RATE_TYPE_VPORT;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
 	devlink_rate->priv = priv;
+	refcount_set(&devlink_rate->refcnt, 1);
 	list_add_tail(&devlink_rate->list, &devlink->rate_list);
 	devlink_port->devlink_rate = devlink_rate;
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
+EXPORT_SYMBOL_GPL(devl_rate_vport_create);
 
 /**
- * devl_rate_leaf_destroy - destroy devlink rate leaf
+ * devl_rate_vport_destroy - destroy devlink rate vport
  *
  * @devlink_port: devlink port linked to the rate object
  *
- * Destroy the devlink rate object of type leaf on provided @devlink_port.
+ * Destroy the devlink rate object of type vport on provided @devlink_port.
  */
-void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
+void devl_rate_vport_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
 
@@ -10217,9 +10488,32 @@ void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 		refcount_dec(&devlink_rate->parent->refcnt);
 	list_del(&devlink_rate->list);
 	devlink_port->devlink_rate = NULL;
+	kfree(devlink_rate->name);
 	kfree(devlink_rate);
 }
-EXPORT_SYMBOL_GPL(devl_rate_leaf_destroy);
+EXPORT_SYMBOL_GPL(devl_rate_vport_destroy);
+
+void devl_rate_objects_destroy(struct devlink *devlink)
+{
+	static struct devlink_rate *devlink_rate, *tmp;
+
+	devl_assert_locked(devlink);
+
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+		if (devlink_rate->parent)
+			refcount_dec(&devlink_rate->parent->refcnt);
+	}
+	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
+		kfree(devlink_rate->name);
+		if (devlink_rate->devlink_port) {
+			if (devlink_rate->devlink_port->devlink_rate)
+				devlink_rate->devlink_port->devlink_rate = NULL;
+		}
+		list_del(&devlink_rate->list);
+		kfree(devlink_rate);
+	}
+}
+EXPORT_SYMBOL_GPL(devl_rate_objects_destroy);
 
 /**
  * devl_rate_nodes_destroy - destroy all devlink rate nodes on device
@@ -10240,12 +10534,18 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 			continue;
 
 		refcount_dec(&devlink_rate->parent->refcnt);
-		if (devlink_rate_is_leaf(devlink_rate))
-			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
-						  NULL, NULL);
+		if (devlink_rate_is_vport(devlink_rate))
+			ops->rate_vport_parent_set(devlink_rate, NULL,
+						   &devlink_rate->priv,
+						   NULL, NULL);
 		else if (devlink_rate_is_node(devlink_rate))
-			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
+			ops->rate_node_parent_set(devlink_rate, NULL,
+						  &devlink_rate->priv,
 						  NULL, NULL);
+		else if (devlink_rate_is_queue(devlink_rate))
+			ops->rate_queue_parent_set(devlink_rate, NULL,
+						   &devlink_rate->priv,
+						   NULL, NULL);
 	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
 		if (devlink_rate_is_node(devlink_rate)) {
@@ -10253,6 +10553,9 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 			list_del(&devlink_rate->list);
 			kfree(devlink_rate->name);
 			kfree(devlink_rate);
+		} else if (devlink_rate_is_queue(devlink_rate)) {
+			list_del(&devlink_rate->list);
+			kfree(devlink_rate);
 		}
 	}
 }
-- 
2.37.2

