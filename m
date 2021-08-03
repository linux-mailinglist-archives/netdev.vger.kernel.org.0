Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04123DF869
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhHCXUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232935AbhHCXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B18060F58;
        Tue,  3 Aug 2021 23:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032823;
        bh=vHYayD8Yt76H93pQteGSxFseJTY2VJBTKWkVabcLxc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNRDZfPj6fZHXJ+QMJNHpJnGne0OoOEdgfeL9hEJ73oxhR4UV0IkaFBUjKRf/pldN
         WDwFD44Iy8Gzh0nN33mU/r7351s9P7kkyxKlKWT+Hb98fjbuhyldJm7Z+mU7TscR9Z
         kK2NpoBEjMJbz6g7Mbyt/dORhFd/SX+a1XpV3b/jsyrFaeBpmxo6yuF2YSGb99IMIY
         spCSU08MdvmJDljFYikCy8DM+qIGdoN9RqFUDsKej+rExToTb72xeufQbVTkZcvOpy
         7FU7lCnj5OjowF7moAfiza8mXI644G8Bnq6mT0eUAtda3+I0fKXrjiwJPJSCUGADMN
         g4DZwmRnTkzNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 11/14] net/mlx5: Lag, properly lock eswitch if needed
Date:   Tue,  3 Aug 2021 16:19:56 -0700
Message-Id: <20210803231959.26513-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Currently when doing hardware lag we check the eswitch mode
but as this isn't done under a lock the check isn't valid.

As the code needs to sync between two different devices an extra
care is needed.

- When going to change eswitch mode, if hardware lag is active destroy it.
- While changing eswitch modes block any hardware bond creation.
- Delay handling bonding events until there are no mode changes in
  progress.
- When attaching a new mdev to lag, block until there is no mode change
  in progress. In order for the mode change to finish the interface lock
  will have to be taken. Release the lock and sleep for 100ms to
  allow forward progress. As this is a very rare condition (can happen if
  the user unbinds and binds a PCI function while also changing eswitch
  mode of the other PCI function) it has no real world impact.

As taking multiple eswitch mode locks is now required lockdep will
complain about a possible deadlock. Register a key per eswitch to make
lockdep happy.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  5 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 83 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +
 7 files changed, 107 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b65a472067d2..f3a7f9d3334f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1458,8 +1458,6 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 
 	esw->mode = mode;
 
-	mlx5_lag_update(esw->dev);
-
 	if (mode == MLX5_ESWITCH_LEGACY) {
 		err = esw_legacy_enable(esw);
 	} else {
@@ -1506,6 +1504,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
+	mlx5_lag_disable_change(esw->dev);
 	down_write(&esw->mode_lock);
 	if (esw->mode == MLX5_ESWITCH_NONE) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
@@ -1519,6 +1518,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
 	up_write(&esw->mode_lock);
+	mlx5_lag_enable_change(esw->dev);
 	return ret;
 }
 
@@ -1550,8 +1550,6 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	old_mode = esw->mode;
 	esw->mode = MLX5_ESWITCH_NONE;
 
-	mlx5_lag_update(esw->dev);
-
 	if (old_mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
 
@@ -1567,10 +1565,12 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 	if (!mlx5_esw_allowed(esw))
 		return;
 
+	mlx5_lag_disable_change(esw->dev);
 	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw, clear_vf);
 	esw->esw_funcs.num_vfs = 0;
 	up_write(&esw->mode_lock);
+	mlx5_lag_enable_change(esw->dev);
 }
 
 static int mlx5_query_hca_cap_host_pf(struct mlx5_core_dev *dev, void *out)
@@ -1759,7 +1759,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	ida_init(&esw->offloads.vport_metadata_ida);
 	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
 	mutex_init(&esw->state_lock);
+	lockdep_register_key(&esw->mode_lock_key);
 	init_rwsem(&esw->mode_lock);
+	lockdep_set_class(&esw->mode_lock, &esw->mode_lock_key);
 
 	esw->enabled_vports = 0;
 	esw->mode = MLX5_ESWITCH_NONE;
@@ -1793,6 +1795,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
+	lockdep_unregister_key(&esw->mode_lock_key);
 	mutex_destroy(&esw->state_lock);
 	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
 	xa_destroy(&esw->offloads.vhca_map);
@@ -2366,9 +2369,22 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
+	if (!mlx5_esw_allowed(esw))
+		return;
 	up_write(&esw->mode_lock);
 }
 
+/**
+ * mlx5_esw_lock() - Take write lock on esw mode lock
+ * @esw: eswitch device.
+ */
+void mlx5_esw_lock(struct mlx5_eswitch *esw)
+{
+	if (!mlx5_esw_allowed(esw))
+		return;
+	down_write(&esw->mode_lock);
+}
+
 /**
  * mlx5_eswitch_get_total_vports - Get total vports of the eswitch
  *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c3a47349f447..5a27445fa892 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -323,6 +323,7 @@ struct mlx5_eswitch {
 		u32             large_group_num;
 	}  params;
 	struct blocking_notifier_head n_head;
+	struct lock_class_key mode_lock_key;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -707,6 +708,7 @@ void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
+void mlx5_esw_lock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
 
@@ -727,6 +729,9 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline void mlx5_esw_unlock(struct mlx5_eswitch *esw) { return; }
+static inline void mlx5_esw_lock(struct mlx5_eswitch *esw) { return; }
+
 static inline struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e02a8bd2bd96..109cbbb99933 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3051,10 +3051,11 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't change mode, E-Switch is busy");
-		return err;
+		goto enable_lag;
 	}
 	cur_mlx5_mode = err;
 	err = 0;
@@ -3071,6 +3072,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 
 unlock:
 	mlx5_esw_unlock(esw);
+enable_lag:
+	mlx5_lag_enable_change(esw->dev);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 3049de648256..459e3e5ef13f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -418,21 +418,48 @@ static void mlx5_queue_bond_work(struct mlx5_lag *ldev, unsigned long delay)
 	queue_delayed_work(ldev->wq, &ldev->bond_work, delay);
 }
 
+static void mlx5_lag_lock_eswitches(struct mlx5_core_dev *dev0,
+				    struct mlx5_core_dev *dev1)
+{
+	if (dev0)
+		mlx5_esw_lock(dev0->priv.eswitch);
+	if (dev1)
+		mlx5_esw_lock(dev1->priv.eswitch);
+}
+
+static void mlx5_lag_unlock_eswitches(struct mlx5_core_dev *dev0,
+				      struct mlx5_core_dev *dev1)
+{
+	if (dev1)
+		mlx5_esw_unlock(dev1->priv.eswitch);
+	if (dev0)
+		mlx5_esw_unlock(dev0->priv.eswitch);
+}
+
 static void mlx5_do_bond_work(struct work_struct *work)
 {
 	struct delayed_work *delayed_work = to_delayed_work(work);
 	struct mlx5_lag *ldev = container_of(delayed_work, struct mlx5_lag,
 					     bond_work);
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	int status;
 
 	status = mlx5_dev_list_trylock();
 	if (!status) {
-		/* 1 sec delay. */
 		mlx5_queue_bond_work(ldev, HZ);
 		return;
 	}
 
+	if (ldev->mode_changes_in_progress) {
+		mlx5_dev_list_unlock();
+		mlx5_queue_bond_work(ldev, HZ);
+		return;
+	}
+
+	mlx5_lag_lock_eswitches(dev0, dev1);
 	mlx5_do_bond(ldev);
+	mlx5_lag_unlock_eswitches(dev0, dev1);
 	mlx5_dev_list_unlock();
 }
 
@@ -630,7 +657,7 @@ static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 }
 
 /* Must be called with intf_mutex held */
-static void __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
+static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
@@ -638,7 +665,7 @@ static void __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(dev, lag_master) ||
 	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
-		return;
+		return 0;
 
 	tmp_dev = mlx5_get_next_phys_dev(dev);
 	if (tmp_dev)
@@ -648,15 +675,17 @@ static void __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 		ldev = mlx5_lag_dev_alloc(dev);
 		if (!ldev) {
 			mlx5_core_err(dev, "Failed to alloc lag dev\n");
-			return;
+			return 0;
 		}
 	} else {
+		if (ldev->mode_changes_in_progress)
+			return -EAGAIN;
 		mlx5_ldev_get(ldev);
 	}
 
 	mlx5_ldev_add_mdev(ldev, dev);
 
-	return;
+	return 0;
 }
 
 void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
@@ -667,7 +696,13 @@ void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return;
 
+recheck:
 	mlx5_dev_list_lock();
+	if (ldev->mode_changes_in_progress) {
+		mlx5_dev_list_unlock();
+		msleep(100);
+		goto recheck;
+	}
 	mlx5_ldev_remove_mdev(ldev, dev);
 	mlx5_dev_list_unlock();
 	mlx5_ldev_put(ldev);
@@ -675,8 +710,16 @@ void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev)
 
 void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
+	int err;
+
+recheck:
 	mlx5_dev_list_lock();
-	__mlx5_lag_dev_add_mdev(dev);
+	err = __mlx5_lag_dev_add_mdev(dev);
+	if (err) {
+		mlx5_dev_list_unlock();
+		msleep(100);
+		goto recheck;
+	}
 	mlx5_dev_list_unlock();
 }
 
@@ -716,6 +759,7 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 
 	if (i >= MLX5_MAX_PORTS)
 		ldev->flags |= MLX5_LAG_FLAG_READY;
+	mlx5_queue_bond_work(ldev, 0);
 }
 
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
@@ -789,19 +833,36 @@ bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_is_shared_fdb);
 
-void mlx5_lag_update(struct mlx5_core_dev *dev)
+void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 {
+	struct mlx5_core_dev *dev0;
+	struct mlx5_core_dev *dev1;
 	struct mlx5_lag *ldev;
 
 	mlx5_dev_list_lock();
+
 	ldev = mlx5_lag_dev(dev);
-	if (!ldev)
-		goto unlock;
+	dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	dev1 = ldev->pf[MLX5_LAG_P2].dev;
 
-	mlx5_do_bond(ldev);
+	ldev->mode_changes_in_progress++;
+	if (__mlx5_lag_is_active(ldev)) {
+		mlx5_lag_lock_eswitches(dev0, dev1);
+		mlx5_disable_lag(ldev);
+		mlx5_lag_unlock_eswitches(dev0, dev1);
+	}
+	mlx5_dev_list_unlock();
+}
 
-unlock:
+void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+
+	mlx5_dev_list_lock();
+	ldev = mlx5_lag_dev(dev);
+	ldev->mode_changes_in_progress--;
 	mlx5_dev_list_unlock();
+	mlx5_queue_bond_work(ldev, 0);
 }
 
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index 70b244b1a09e..e1d7a6671cf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -39,6 +39,7 @@ struct lag_tracker {
  */
 struct mlx5_lag {
 	u8                        flags;
+	int			  mode_changes_in_progress;
 	bool			  shared_fdb;
 	u8                        v2p_map[MLX5_MAX_PORTS];
 	struct kref               ref;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index eb1b316560a8..1357a6ec8c3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1179,6 +1179,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_ec;
 	}
 
+	mlx5_lag_add_mdev(dev);
 	err = mlx5_sriov_attach(dev);
 	if (err) {
 		mlx5_core_err(dev, "sriov init failed %d\n", err);
@@ -1186,11 +1187,11 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	}
 
 	mlx5_sf_dev_table_create(dev);
-	mlx5_lag_add_mdev(dev);
 
 	return 0;
 
 err_sriov:
+	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 err_ec:
 	mlx5_sf_hw_table_destroy(dev);
@@ -1222,9 +1223,9 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
-	mlx5_lag_remove_mdev(dev);
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
+	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sf_hw_table_destroy(dev);
 	mlx5_vhca_event_stop(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 343807ac2036..14ffd74eeabe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -168,6 +168,8 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev, struct net_device *netdev);
 void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev, struct net_device *netdev);
 void mlx5_lag_add_mdev(struct mlx5_core_dev *dev);
 void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev);
+void mlx5_lag_disable_change(struct mlx5_core_dev *dev);
+void mlx5_lag_enable_change(struct mlx5_core_dev *dev);
 
 int mlx5_events_init(struct mlx5_core_dev *dev);
 void mlx5_events_cleanup(struct mlx5_core_dev *dev);
-- 
2.31.1

