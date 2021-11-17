Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F89453F94
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhKQEhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233119AbhKQEhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7A361BE2;
        Wed, 17 Nov 2021 04:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123653;
        bh=KPhPKHQqfcLkcucc8sonHd1WUicEs6SaTpGxKTs8CM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ1FunyUvtOIvCD4cR7iAoxbq5spWsxvm6aQfkKY+3lI19N0ILkHjm8Ml9SyQWpgo
         Xafq8zTOJv61L5sJ7oGySlQ4JbKieO+gZtwAh6dzgv05nzQlaXSnadLQZLBbk1Yin0
         rgl5pBWlAD0wnrG9BqWZNp4v4YM0qA+itU+Z0I3jx4Q0Yo5GTxvRAhKBfsj1QQDl3+
         CP0c4pDFQpqODPi4H5ZSeiA+ZgTBosbG4DCbtR4dXfzjIsxWqoZLtqrCqvdjLJfIwT
         ibjNg4sT4iY0SR5D6NZLXBGkuUmE/5TTO1ZA6vUHVJZ1GTlkBzksznVOnRr7kAUOdm
         Dts8g/G1yxhfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 15/15] net/mlx5: E-switch, Create QoS on demand
Date:   Tue, 16 Nov 2021 20:33:57 -0800
Message-Id: <20211117043357.345072-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Don't create eswitch QoS (root TSAR) on switch mode change. Create it on
first child TSAR object creation - vport or rate group. Keep track
root TSAR references and release root TSAR with last object deletion.
No need to check for QoS is enabled when installing tc matchall filter.
Remove related helper function due to no users of it.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 -
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 152 ++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |   2 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   9 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 5 files changed, 111 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 686bb2e08e9e..55e384abd364 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4948,14 +4948,8 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
 				struct tc_cls_matchall_offload *ma)
 {
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = ma->common.extack;
 
-	if (!mlx5_esw_qos_enabled(esw)) {
-		NL_SET_ERR_MSG_MOD(extack, "QoS is not supported on this device");
-		return -EOPNOTSUPP;
-	}
-
 	if (ma->common.prio != 1) {
 		NL_SET_ERR_MSG_MOD(extack, "only priority 1 is supported");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 304abc293086..ff0a07a91992 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -428,16 +428,13 @@ static int esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 }
 
 static struct mlx5_esw_rate_group *
-esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
+__esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_esw_rate_group *group;
 	u32 divider;
 	int err;
 
-	if (!MLX5_CAP_QOS(esw->dev, log_esw_max_sched_depth))
-		return ERR_PTR(-EOPNOTSUPP);
-
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
@@ -478,9 +475,32 @@ esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 	return ERR_PTR(err);
 }
 
-static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
-				      struct mlx5_esw_rate_group *group,
-				      struct netlink_ext_ack *extack)
+static int esw_qos_get(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack);
+static void esw_qos_put(struct mlx5_eswitch *esw);
+
+static struct mlx5_esw_rate_group *
+esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
+{
+	struct mlx5_esw_rate_group *group;
+	int err;
+
+	if (!MLX5_CAP_QOS(esw->dev, log_esw_max_sched_depth))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	err = esw_qos_get(esw, extack);
+	if (err)
+		return ERR_PTR(err);
+
+	group = __esw_qos_create_rate_group(esw, extack);
+	if (IS_ERR(group))
+		esw_qos_put(esw);
+
+	return group;
+}
+
+static int __esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
+					struct mlx5_esw_rate_group *group,
+					struct netlink_ext_ack *extack)
 {
 	u32 divider;
 	int err;
@@ -499,7 +519,21 @@ static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch destroy TSAR_ID failed");
 
 	trace_mlx5_esw_group_qos_destroy(esw->dev, group, group->tsar_ix);
+
 	kfree(group);
+
+	return err;
+}
+
+static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
+				      struct mlx5_esw_rate_group *group,
+				      struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = __esw_qos_destroy_rate_group(esw, group, extack);
+	esw_qos_put(esw);
+
 	return err;
 }
 
@@ -522,7 +556,7 @@ static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
 	return false;
 }
 
-void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
+static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -530,14 +564,10 @@ void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
 	int err;
 
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
-		return;
+		return -EOPNOTSUPP;
 
 	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
-		return;
-
-	mutex_lock(&esw->state_lock);
-	if (esw->qos.enabled)
-		goto unlock;
+		return -EOPNOTSUPP;
 
 	MLX5_SET(scheduling_context, tsar_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
@@ -551,75 +581,93 @@ void mlx5_esw_qos_create(struct mlx5_eswitch *esw)
 						 &esw->qos.root_tsar_ix);
 	if (err) {
 		esw_warn(dev, "E-Switch create root TSAR failed (%d)\n", err);
-		goto unlock;
+		return err;
 	}
 
 	INIT_LIST_HEAD(&esw->qos.groups);
 	if (MLX5_CAP_QOS(dev, log_esw_max_sched_depth)) {
-		esw->qos.group0 = esw_qos_create_rate_group(esw, NULL);
+		esw->qos.group0 = __esw_qos_create_rate_group(esw, extack);
 		if (IS_ERR(esw->qos.group0)) {
 			esw_warn(dev, "E-Switch create rate group 0 failed (%ld)\n",
 				 PTR_ERR(esw->qos.group0));
 			goto err_group0;
 		}
 	}
-	esw->qos.enabled = true;
-unlock:
-	mutex_unlock(&esw->state_lock);
-	return;
+	refcount_set(&esw->qos.refcnt, 1);
+
+	return 0;
 
 err_group0:
-	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  esw->qos.root_tsar_ix);
-	if (err)
-		esw_warn(esw->dev, "E-Switch destroy root TSAR failed (%d)\n", err);
-	mutex_unlock(&esw->state_lock);
+	if (mlx5_destroy_scheduling_element_cmd(esw->dev, SCHEDULING_HIERARCHY_E_SWITCH,
+						esw->qos.root_tsar_ix))
+		esw_warn(esw->dev, "E-Switch destroy root TSAR failed.\n");
+
+	return err;
 }
 
-void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw)
+static void esw_qos_destroy(struct mlx5_eswitch *esw)
 {
-	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err;
 
-	devlink_rate_nodes_destroy(devlink);
-	mutex_lock(&esw->state_lock);
-	if (!esw->qos.enabled)
-		goto unlock;
-
 	if (esw->qos.group0)
-		esw_qos_destroy_rate_group(esw, esw->qos.group0, NULL);
+		__esw_qos_destroy_rate_group(esw, esw->qos.group0, NULL);
 
 	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
 						  SCHEDULING_HIERARCHY_E_SWITCH,
 						  esw->qos.root_tsar_ix);
 	if (err)
 		esw_warn(esw->dev, "E-Switch destroy root TSAR failed (%d)\n", err);
+}
 
-	esw->qos.enabled = false;
-unlock:
-	mutex_unlock(&esw->state_lock);
+static int esw_qos_get(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	lockdep_assert_held(&esw->state_lock);
+
+	if (!refcount_inc_not_zero(&esw->qos.refcnt)) {
+		/* esw_qos_create() set refcount to 1 only on success.
+		 * No need to decrement on failure.
+		 */
+		err = esw_qos_create(esw, extack);
+	}
+
+	return err;
+}
+
+static void esw_qos_put(struct mlx5_eswitch *esw)
+{
+	lockdep_assert_held(&esw->state_lock);
+	if (refcount_dec_and_test(&esw->qos.refcnt))
+		esw_qos_destroy(esw);
 }
 
 static int esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
-				u32 max_rate, u32 bw_share)
+				u32 max_rate, u32 bw_share, struct netlink_ext_ack *extack)
 {
 	int err;
 
 	lockdep_assert_held(&esw->state_lock);
-	if (!esw->qos.enabled)
-		return 0;
-
 	if (vport->qos.enabled)
 		return 0;
 
+	err = esw_qos_get(esw, extack);
+	if (err)
+		return err;
+
 	vport->qos.group = esw->qos.group0;
 
 	err = esw_qos_vport_create_sched_element(esw, vport, max_rate, bw_share);
-	if (!err) {
-		vport->qos.enabled = true;
-		trace_mlx5_esw_vport_qos_create(vport, bw_share, max_rate);
-	}
+	if (err)
+		goto err_out;
+
+	vport->qos.enabled = true;
+	trace_mlx5_esw_vport_qos_create(vport, bw_share, max_rate);
+
+	return 0;
+
+err_out:
+	esw_qos_put(esw);
 
 	return err;
 }
@@ -629,7 +677,7 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 	int err;
 
 	lockdep_assert_held(&esw->state_lock);
-	if (!esw->qos.enabled || !vport->qos.enabled)
+	if (!vport->qos.enabled)
 		return;
 	WARN(vport->qos.group && vport->qos.group != esw->qos.group0,
 	     "Disabling QoS on port before detaching it from group");
@@ -643,6 +691,8 @@ void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 
 	memset(&vport->qos, 0, sizeof(vport->qos));
 	trace_mlx5_esw_vport_qos_destroy(vport);
+
+	esw_qos_put(esw);
 }
 
 int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
@@ -651,7 +701,7 @@ int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *vpo
 	int err;
 
 	lockdep_assert_held(&esw->state_lock);
-	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	err = esw_qos_vport_enable(esw, vport, 0, 0, NULL);
 	if (err)
 		return err;
 
@@ -676,7 +726,7 @@ int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32
 	mutex_lock(&esw->state_lock);
 	if (!vport->qos.enabled) {
 		/* Eswitch QoS wasn't enabled yet. Enable it and vport QoS. */
-		err = esw_qos_vport_enable(esw, vport, rate_mbps, vport->qos.bw_share);
+		err = esw_qos_vport_enable(esw, vport, rate_mbps, vport->qos.bw_share, NULL);
 	} else {
 		MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
 
@@ -748,7 +798,7 @@ int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void
 		return err;
 
 	mutex_lock(&esw->state_lock);
-	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	err = esw_qos_vport_enable(esw, vport, 0, 0, extack);
 	if (err)
 		goto unlock;
 
@@ -774,7 +824,7 @@ int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *
 		return err;
 
 	mutex_lock(&esw->state_lock);
-	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	err = esw_qos_vport_enable(esw, vport, 0, 0, extack);
 	if (err)
 		goto unlock;
 
@@ -876,7 +926,7 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 	int err;
 
 	mutex_lock(&esw->state_lock);
-	err = esw_qos_vport_enable(esw, vport, 0, 0);
+	err = esw_qos_vport_enable(esw, vport, 0, 0, extack);
 	if (!err)
 		err = esw_qos_vport_update_group(esw, vport, group, extack);
 	mutex_unlock(&esw->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 91b66c1b9881..0141e9d52037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -8,8 +8,6 @@
 
 int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
 				u32 max_rate, u32 min_rate);
-void mlx5_esw_qos_create(struct mlx5_eswitch *esw);
-void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw);
 void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
 int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2d188f462028..46532dd42b43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1257,8 +1257,6 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 
 	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
 
-	mlx5_esw_qos_create(esw);
-
 	esw->mode = mode;
 
 	if (mode == MLX5_ESWITCH_LEGACY) {
@@ -1287,7 +1285,6 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	if (mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
 
-	mlx5_esw_qos_destroy(esw);
 	mlx5_esw_acls_ns_cleanup(esw);
 	return err;
 }
@@ -1327,6 +1324,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 
 void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 {
+	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int old_mode;
 
 	lockdep_assert_held_write(&esw->mode_lock);
@@ -1356,7 +1354,8 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	if (old_mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
 
-	mlx5_esw_qos_destroy(esw);
+	devlink_rate_nodes_destroy(devlink);
+
 	mlx5_esw_acls_ns_cleanup(esw);
 
 	if (clear_vf)
@@ -1565,6 +1564,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	lockdep_register_key(&esw->mode_lock_key);
 	init_rwsem(&esw->mode_lock);
 	lockdep_set_class(&esw->mode_lock, &esw->mode_lock_key);
+	refcount_set(&esw->qos.refcnt, 0);
 
 	esw->enabled_vports = 0;
 	esw->mode = MLX5_ESWITCH_NONE;
@@ -1598,6 +1598,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
+	WARN_ON(refcount_read(&esw->qos.refcnt));
 	lockdep_unregister_key(&esw->mode_lock_key);
 	mutex_destroy(&esw->state_lock);
 	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 42f8ee2e5d9f..513f741d16c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -308,10 +308,14 @@ struct mlx5_eswitch {
 	atomic64_t user_count;
 
 	struct {
-		bool            enabled;
 		u32             root_tsar_ix;
 		struct mlx5_esw_rate_group *group0;
 		struct list_head groups; /* Protected by esw->state_lock */
+
+		/* Protected by esw->state_lock.
+		 * Initially 0, meaning no QoS users and QoS is disabled.
+		 */
+		refcount_t refcnt;
 	} qos;
 
 	struct mlx5_esw_bridge_offloads *br_offloads;
@@ -516,11 +520,6 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
 
-static inline bool mlx5_esw_qos_enabled(struct mlx5_eswitch *esw)
-{
-	return esw->qos.enabled;
-}
-
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
 						       u8 vlan_depth)
 {
-- 
2.31.1

