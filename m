Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF53F2622
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbhHTE4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234460AbhHTE4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D50F961051;
        Fri, 20 Aug 2021 04:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435330;
        bh=1DoACpW/Ml8AWUFp4wpO78XwX2hnSJYfnCcs4XFfjv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkwcZKaYH8buznjfBS5eE6+HAKcf+LYD6UjR8HHOeAY6ASnezqm0LMI+g5JPUTVNt
         fjLTgbuOm0psFK2lFBD3IeMi9oI5m6XLH4uSyi4sTGsuqHXFEIIOiJJ64KGmMY1K3C
         zkGMe3LyjwMWl9lsYl4t258CtzWLAoK2gl9ewVML4HRgEvQFPS6cWUEM+DBlNqu2G8
         gJNAb9CM1vSnODKBq437fGhO1erw1lIF//hLECJMJfbKC/ntBgGdBRGxtykmsFoMvK
         IO+FP+CjHKe2d1dp2TgAyN9sxh/YGhDIOCdNjXqdnLmkbaPIuVhe3xsD1eQEwqkhDZ
         OHbkEZ/sXRm8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: E-switch, Introduce rate limiting groups API
Date:   Thu, 19 Aug 2021 21:55:12 -0700
Message-Id: <20210820045515.265297-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Extend eswitch API with rate limiting groups:

- Define new struct mlx5_esw_rate_group that is used to hold all
  internal group data.

- Implement functions that allow creation, destruction and cleanup of
  groups.

- Assign all vports to internal unlimited zero group by default.

This commit lays the groundwork for group rate limiting by implementing
devlink_ops->rate_node_{new|del}() callbacks to support creating and
deleting groups through devlink rate node objects. APIs that allows
setting rates and adding/removing members are implemented in following
patches.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 141 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +-
 5 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f4cd2573d4ea..ef87d0bf983b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -295,6 +295,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
 	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
 	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
+	.rate_node_new = mlx5_esw_devlink_rate_node_new,
+	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index fcdcddf4a710..c9081d39fa8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -11,6 +11,13 @@
 #define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
 	min_t(u32, max_t(u32, DIV_ROUND_UP(rate, divider), MLX5_MIN_BW_SHARE), limit)
 
+struct mlx5_esw_rate_group {
+	u32 tsar_ix;
+	u32 max_rate;
+	u32 min_rate;
+	u32 bw_share;
+};
+
 static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 				struct mlx5_vport *vport,
 				u32 max_rate, u32 bw_share,
@@ -159,6 +166,54 @@ int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
 	return err;
 }
 
+static struct mlx5_esw_rate_group *
+esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
+{
+	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
+	struct mlx5_esw_rate_group *group;
+	int err;
+
+	if (!MLX5_CAP_QOS(esw->dev, log_esw_max_sched_depth))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(scheduling_context, tsar_ctx, parent_element_id,
+		 esw->qos.root_tsar_ix);
+	err = mlx5_create_scheduling_element_cmd(esw->dev,
+						 SCHEDULING_HIERARCHY_E_SWITCH,
+						 tsar_ctx,
+						 &group->tsar_ix);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch create TSAR for group failed");
+		goto err_sched_elem;
+	}
+
+	return group;
+
+err_sched_elem:
+	kfree(group);
+	return ERR_PTR(err);
+}
+
+static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
+				      struct mlx5_esw_rate_group *group,
+				      struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  group->tsar_ix);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch destroy TSAR_ID failed");
+
+	kfree(group);
+	return err;
+}
+
 static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
 {
 	switch (type) {
@@ -191,8 +246,9 @@ void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
 	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
 		return;
 
+	mutex_lock(&esw->state_lock);
 	if (esw->qos.enabled)
-		return;
+		goto unlock;
 
 	MLX5_SET(scheduling_context, tsar_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
@@ -205,27 +261,54 @@ void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
 						 tsar_ctx,
 						 &esw->qos.root_tsar_ix);
 	if (err) {
-		esw_warn(dev, "E-Switch create TSAR failed (%d)\n", err);
-		return;
+		esw_warn(dev, "E-Switch create root TSAR failed (%d)\n", err);
+		goto unlock;
 	}
 
+	if (MLX5_CAP_QOS(dev, log_esw_max_sched_depth)) {
+		esw->qos.group0 = esw_qos_create_rate_group(esw, NULL);
+		if (IS_ERR(esw->qos.group0)) {
+			esw_warn(dev, "E-Switch create rate group 0 failed (%ld)\n",
+				 PTR_ERR(esw->qos.group0));
+			goto err_group0;
+		}
+	}
 	esw->qos.enabled = true;
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return;
+
+err_group0:
+	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  esw->qos.root_tsar_ix);
+	if (err)
+		esw_warn(esw->dev, "E-Switch destroy root TSAR failed (%d)\n", err);
+	mutex_unlock(&esw->state_lock);
 }
 
 void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw)
 {
+	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err;
 
+	devlink_rate_nodes_destroy(devlink);
+	mutex_lock(&esw->state_lock);
 	if (!esw->qos.enabled)
-		return;
+		goto unlock;
+
+	if (esw->qos.group0)
+		esw_qos_destroy_rate_group(esw, esw->qos.group0, NULL);
 
 	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
 						  SCHEDULING_HIERARCHY_E_SWITCH,
 						  esw->qos.root_tsar_ix);
 	if (err)
-		esw_warn(esw->dev, "E-Switch destroy TSAR failed (%d)\n", err);
+		esw_warn(esw->dev, "E-Switch destroy root TSAR failed (%d)\n", err);
 
 	esw->qos.enabled = false;
+unlock:
+	mutex_unlock(&esw->state_lock);
 }
 
 int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
@@ -386,3 +469,51 @@ int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
+
+int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_rate_group *group;
+	struct mlx5_eswitch *esw;
+	int err = 0;
+
+	esw = mlx5_devlink_eswitch_get(rate_node->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	mutex_lock(&esw->state_lock);
+	if (esw->mode != MLX5_ESWITCH_OFFLOADS) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Rate node creation supported only in switchdev mode");
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	group = esw_qos_create_rate_group(esw, extack);
+	if (IS_ERR(group)) {
+		err = PTR_ERR(group);
+		goto unlock;
+	}
+
+	*priv = group;
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_rate_group *group = priv;
+	struct mlx5_eswitch *esw;
+	int err;
+
+	esw = mlx5_devlink_eswitch_get(rate_node->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	mutex_lock(&esw->state_lock);
+	err = esw_qos_destroy_rate_group(esw, group, extack);
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 507c7e017834..ab9fd8621cca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -24,6 +24,10 @@ int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void
 					    u64 tx_share, struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
 					  u64 tx_max, struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
+				   struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
+				   struct netlink_ext_ack *extack);
 #endif
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ebeccee38a57..3580901ae548 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -306,6 +306,7 @@ struct mlx5_eswitch {
 	struct {
 		bool            enabled;
 		u32             root_tsar_ix;
+		struct mlx5_esw_rate_group *group0;
 	} qos;
 
 	struct mlx5_esw_bridge_offloads *br_offloads;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fce3cbae0b99..f3638d09ba77 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -865,7 +865,8 @@ struct mlx5_ifc_qos_cap_bits {
 	u8         nic_bw_share[0x1];
 	u8         nic_rate_limit[0x1];
 	u8         packet_pacing_uid[0x1];
-	u8         reserved_at_c[0x14];
+	u8         log_esw_max_sched_depth[0x4];
+	u8         reserved_at_10[0x10];
 
 	u8         reserved_at_20[0xb];
 	u8         log_max_qos_nic_queue_group[0x5];
-- 
2.31.1

