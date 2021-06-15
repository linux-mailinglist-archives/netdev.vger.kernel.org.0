Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39E83A7582
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhFOEDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhFOEDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8504461417;
        Tue, 15 Jun 2021 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729689;
        bh=a95i3ThGabJ9REwwCJQX1YLHCjeqExl0qDh644MXJBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEs96y3/AvKI02h1ZcBrfdAXmMB5++7odLnyBq60uur34oxM+a1vqEaEuKMRwCzTm
         7log/8TH6vfxGhIH9HQ4VNzoVb+Z8n67w81+iGLwEqdBelKZaZFOEjED0O50YCzREA
         v/pq3WKPRdpBJ4MXa1JoY/VF3KDO/Xu+agKaxfWX4JLWo8mSKS1f6DFfcMrTLq7C5Y
         XT8fQP/sB23i+oCnjU0yOPHE3xUhxKkbbKF2rW3J9nPNklMXY0N/N4/Cu4NhXv6EBg
         WcmLfMtHOH0UMImmdTpcSs5cVDUqbI0Y6AQ7rO2AOm9y7F8OuV4WKqWsgQ3i343CYT
         Io27YyNQ/S/Mw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Change ownership model for lag
Date:   Mon, 14 Jun 2021 21:01:11 -0700
Message-Id: <20210615040123.287101-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Lag is used to combine two PCI functions of the same HCA into a single
logical unit. This is a core functionality and as such should be managed by
the core driver. Currently this isn't the case. While we store the lag
software structure inside the lower device, its lifetime (creation /
destruction) is dictated by the mlx5e part. Change the ownership model so
lag is tied to the lifetime of the lower level driver instead to the
mlx5e part.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 221 +++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 +-
 7 files changed, 154 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 59ee28156603..930b225dfe77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5114,7 +5114,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	mlx5e_set_dev_port_mtu(priv);
 
-	mlx5_lag_add(mdev, netdev);
+	mlx5_lag_add_netdev(mdev, netdev);
 
 	mlx5e_enable_async_events(priv);
 	mlx5e_enable_blocking_events(priv);
@@ -5162,7 +5162,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 		priv->en_trap = NULL;
 	}
 	mlx5e_disable_async_events(priv);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8290e0086178..2d2cc5f3b03f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -976,7 +976,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	if (MLX5_CAP_GEN(mdev, uplink_follow))
 		mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
 					      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
-	mlx5_lag_add(mdev, netdev);
+	mlx5_lag_add_netdev(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
 	mlx5e_dcbnl_initialize(priv);
@@ -1009,7 +1009,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	mlx5e_dcbnl_delete_app(priv);
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	mlx5e_rep_tc_disable(priv);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove_netdev(mdev, priv->netdev);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 4a4e9b228ba0..5c043c5cc403 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -93,6 +93,64 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_cmd_destroy_vport_lag);
 
+static int mlx5_lag_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr);
+static void mlx5_do_bond_work(struct work_struct *work);
+
+static void mlx5_ldev_free(struct kref *ref)
+{
+	struct mlx5_lag *ldev = container_of(ref, struct mlx5_lag, ref);
+
+	if (ldev->nb.notifier_call)
+		unregister_netdevice_notifier_net(&init_net, &ldev->nb);
+	mlx5_lag_mp_cleanup(ldev);
+	cancel_delayed_work_sync(&ldev->bond_work);
+	destroy_workqueue(ldev->wq);
+	kfree(ldev);
+}
+
+static void mlx5_ldev_put(struct mlx5_lag *ldev)
+{
+	kref_put(&ldev->ref, mlx5_ldev_free);
+}
+
+static void mlx5_ldev_get(struct mlx5_lag *ldev)
+{
+	kref_get(&ldev->ref);
+}
+
+static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+	int err;
+
+	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
+	if (!ldev)
+		return NULL;
+
+	ldev->wq = create_singlethread_workqueue("mlx5_lag");
+	if (!ldev->wq) {
+		kfree(ldev);
+		return NULL;
+	}
+
+	kref_init(&ldev->ref);
+	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
+
+	ldev->nb.notifier_call = mlx5_lag_netdev_event;
+	if (register_netdevice_notifier_net(&init_net, &ldev->nb)) {
+		ldev->nb.notifier_call = NULL;
+		mlx5_core_err(dev, "Failed to register LAG netdev notifier\n");
+	}
+
+	err = mlx5_lag_mp_init(ldev);
+	if (err)
+		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
+			      err);
+
+	return ldev;
+}
+
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev)
 {
@@ -511,55 +569,52 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct mlx5_lag *mlx5_lag_dev_alloc(void)
+static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
+				 struct mlx5_core_dev *dev,
+				 struct net_device *netdev)
 {
-	struct mlx5_lag *ldev;
-
-	ldev = kzalloc(sizeof(*ldev), GFP_KERNEL);
-	if (!ldev)
-		return NULL;
-
-	ldev->wq = create_singlethread_workqueue("mlx5_lag");
-	if (!ldev->wq) {
-		kfree(ldev);
-		return NULL;
-	}
+	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
 
-	INIT_DELAYED_WORK(&ldev->bond_work, mlx5_do_bond_work);
+	if (fn >= MLX5_MAX_PORTS)
+		return;
 
-	return ldev;
+	spin_lock(&lag_lock);
+	ldev->pf[fn].netdev = netdev;
+	ldev->tracker.netdev_state[fn].link_up = 0;
+	ldev->tracker.netdev_state[fn].tx_enabled = 0;
+	spin_unlock(&lag_lock);
 }
 
-static void mlx5_lag_dev_free(struct mlx5_lag *ldev)
+static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
+				    struct net_device *netdev)
 {
-	destroy_workqueue(ldev->wq);
-	kfree(ldev);
+	int i;
+
+	spin_lock(&lag_lock);
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		if (ldev->pf[i].netdev == netdev) {
+			ldev->pf[i].netdev = NULL;
+			break;
+		}
+	}
+	spin_unlock(&lag_lock);
 }
 
-static int mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
-			       struct mlx5_core_dev *dev,
-			       struct net_device *netdev)
+static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
+			       struct mlx5_core_dev *dev)
 {
 	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
 
 	if (fn >= MLX5_MAX_PORTS)
-		return -EPERM;
-
-	spin_lock(&lag_lock);
-	ldev->pf[fn].dev    = dev;
-	ldev->pf[fn].netdev = netdev;
-	ldev->tracker.netdev_state[fn].link_up = 0;
-	ldev->tracker.netdev_state[fn].tx_enabled = 0;
+		return;
 
+	ldev->pf[fn].dev = dev;
 	dev->priv.lag = ldev;
-
-	spin_unlock(&lag_lock);
-
-	return fn;
 }
 
-static void mlx5_lag_dev_remove_pf(struct mlx5_lag *ldev,
-				   struct mlx5_core_dev *dev)
+/* Must be called with intf_mutex held */
+static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
+				  struct mlx5_core_dev *dev)
 {
 	int i;
 
@@ -570,19 +625,15 @@ static void mlx5_lag_dev_remove_pf(struct mlx5_lag *ldev,
 	if (i == MLX5_MAX_PORTS)
 		return;
 
-	spin_lock(&lag_lock);
-	memset(&ldev->pf[i], 0, sizeof(*ldev->pf));
-
+	ldev->pf[i].dev = NULL;
 	dev->priv.lag = NULL;
-	spin_unlock(&lag_lock);
 }
 
 /* Must be called with intf_mutex held */
-void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
+static void __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
-	int i, err;
 
 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(dev, lag_master) ||
@@ -594,67 +645,77 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 		ldev = tmp_dev->priv.lag;
 
 	if (!ldev) {
-		ldev = mlx5_lag_dev_alloc();
+		ldev = mlx5_lag_dev_alloc(dev);
 		if (!ldev) {
 			mlx5_core_err(dev, "Failed to alloc lag dev\n");
 			return;
 		}
+	} else {
+		mlx5_ldev_get(ldev);
 	}
 
-	if (mlx5_lag_dev_add_pf(ldev, dev, netdev) < 0)
-		return;
+	mlx5_ldev_add_mdev(ldev, dev);
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
-		if (!ldev->pf[i].dev)
-			break;
+	return;
+}
 
-	if (i >= MLX5_MAX_PORTS)
-		ldev->flags |= MLX5_LAG_FLAG_READY;
+void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
 
-	if (!ldev->nb.notifier_call) {
-		ldev->nb.notifier_call = mlx5_lag_netdev_event;
-		if (register_netdevice_notifier_net(&init_net, &ldev->nb)) {
-			ldev->nb.notifier_call = NULL;
-			mlx5_core_err(dev, "Failed to register LAG netdev notifier\n");
-		}
-	}
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
 
-	err = mlx5_lag_mp_init(ldev);
-	if (err)
-		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
-			      err);
+	mlx5_dev_list_lock();
+	mlx5_ldev_remove_mdev(ldev, dev);
+	mlx5_dev_list_unlock();
+	mlx5_ldev_put(ldev);
+}
+
+void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
+{
+	mlx5_dev_list_lock();
+	__mlx5_lag_dev_add_mdev(dev);
+	mlx5_dev_list_unlock();
 }
 
 /* Must be called with intf_mutex held */
-void mlx5_lag_remove(struct mlx5_core_dev *dev)
+void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
+			    struct net_device *netdev)
 {
 	struct mlx5_lag *ldev;
-	int i;
 
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		return;
 
 	if (__mlx5_lag_is_active(ldev))
 		mlx5_disable_lag(ldev);
 
-	mlx5_lag_dev_remove_pf(ldev, dev);
-
+	mlx5_ldev_remove_netdev(ldev, netdev);
 	ldev->flags &= ~MLX5_LAG_FLAG_READY;
+}
+
+/* Must be called with intf_mutex held */
+void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
+			 struct net_device *netdev)
+{
+	struct mlx5_lag *ldev;
+	int i;
+
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
+
+	mlx5_ldev_add_netdev(ldev, dev, netdev);
 
 	for (i = 0; i < MLX5_MAX_PORTS; i++)
-		if (ldev->pf[i].dev)
+		if (!ldev->pf[i].dev)
 			break;
 
-	if (i == MLX5_MAX_PORTS) {
-		if (ldev->nb.notifier_call) {
-			unregister_netdevice_notifier_net(&init_net, &ldev->nb);
-			ldev->nb.notifier_call = NULL;
-		}
-		mlx5_lag_mp_cleanup(ldev);
-		cancel_delayed_work_sync(&ldev->bond_work);
-		mlx5_lag_dev_free(ldev);
-	}
+	if (i >= MLX5_MAX_PORTS)
+		ldev->flags |= MLX5_LAG_FLAG_READY;
 }
 
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
@@ -663,7 +724,7 @@ bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
 	bool res;
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_roce(ldev);
 	spin_unlock(&lag_lock);
 
@@ -677,7 +738,7 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 	bool res;
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_active(ldev);
 	spin_unlock(&lag_lock);
 
@@ -691,7 +752,7 @@ bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 	bool res;
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_sriov(ldev);
 	spin_unlock(&lag_lock);
 
@@ -704,7 +765,7 @@ void mlx5_lag_update(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 
 	mlx5_dev_list_lock();
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		goto unlock;
 
@@ -720,7 +781,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
 		goto unlock;
@@ -749,7 +810,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 	u8 port = 0;
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
 		goto unlock;
 
@@ -785,7 +846,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	memset(values, 0, sizeof(*values) * num_counters);
 
 	spin_lock(&lag_lock);
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	if (ldev && __mlx5_lag_is_active(ldev)) {
 		num_ports = MLX5_MAX_PORTS;
 		mdev[MLX5_LAG_P1] = ldev->pf[MLX5_LAG_P1].dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index 8d8cf2d0bc6d..191392c37558 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -40,6 +40,7 @@ struct lag_tracker {
 struct mlx5_lag {
 	u8                        flags;
 	u8                        v2p_map[MLX5_MAX_PORTS];
+	struct kref               ref;
 	struct lag_func           pf[MLX5_MAX_PORTS];
 	struct lag_tracker        tracker;
 	struct workqueue_struct   *wq;
@@ -49,7 +50,7 @@ struct mlx5_lag {
 };
 
 static inline struct mlx5_lag *
-mlx5_lag_dev_get(struct mlx5_core_dev *dev)
+mlx5_lag_dev(struct mlx5_core_dev *dev)
 {
 	return dev->priv.lag;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index fd6196b5e163..c4bf8b679541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -28,7 +28,7 @@ bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 	bool res;
 
-	ldev = mlx5_lag_dev_get(dev);
+	ldev = mlx5_lag_dev(dev);
 	res  = ldev && __mlx5_lag_is_multipath(ldev);
 
 	return res;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a1d67bd7fb43..310518fabf77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1185,6 +1185,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	}
 
 	mlx5_sf_dev_table_create(dev);
+	mlx5_lag_add_mdev(dev);
 
 	return 0;
 
@@ -1219,6 +1220,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
+	mlx5_lag_remove_mdev(dev);
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_ec_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a22b706eebd3..dd95aa6eb2f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -164,8 +164,10 @@ int mlx5_query_mcam_reg(struct mlx5_core_dev *dev, u32 *mcap, u8 feature_group,
 int mlx5_query_qcam_reg(struct mlx5_core_dev *mdev, u32 *qcam,
 			u8 feature_group, u8 access_reg_group);
 
-void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev);
-void mlx5_lag_remove(struct mlx5_core_dev *dev);
+void mlx5_lag_add_netdev(struct mlx5_core_dev *dev, struct net_device *netdev);
+void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev, struct net_device *netdev);
+void mlx5_lag_add_mdev(struct mlx5_core_dev *dev);
+void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev);
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
-- 
2.31.1

