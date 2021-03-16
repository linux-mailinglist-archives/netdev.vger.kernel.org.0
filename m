Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C13433E26B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCPXvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCPXvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A9D64F8F;
        Tue, 16 Mar 2021 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938682;
        bh=a5VuRy5xmwalN5dmJBM2lGAvC9fJyEBmBPsDN6ppvQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjf5L5WcW43CDbLIUAbq42/Ge1YfhyeAnoVYesxSq/byAniFQ9HwKy8NxjpWtmEOE
         qtT7Rcix0r4IS1dR5xRUeBK7dYYHkvIxKMeuD41+NWclVYqOT63EyU53KcZi1CfMlJ
         Lj99u71aS+DbyUuhw7LapHsr3OWI6JXAt8HLcLlo+mdi2cJ1xdybg+OhkL0Aeeq5U8
         GRECEvF8rBskAtfpXuq6qwkbeAo4k4W1qBTl2LITxJYY1rnvrVXAwVPwKTJviIMcg8
         UOiWaQnVajTvRiFqEj2IodI0cTmuDAy6Kydk9NlY5zHe11K6SOgk1nMSg4yUZCoI7H
         5D4cq6J8dvP5g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: E-Switch, Protect changing mode while adding rules
Date:   Tue, 16 Mar 2021 16:51:12 -0700
Message-Id: <20210316235112.72626-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We re-use the native NIC port net device instance for the Uplink
representor, a driver currently cannot unbind TC setup callback
actively, hence protect changing E-Switch mode while adding rules.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  9 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 93 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  9 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 14 ++-
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b3bf7bb7b97e..730f33ada90a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4323,6 +4323,11 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int err = 0;
 
+	if (!mlx5_esw_hold(priv->mdev))
+		return -EAGAIN;
+
+	mlx5_esw_get(priv->mdev);
+
 	rcu_read_lock();
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	if (flow) {
@@ -4360,11 +4365,14 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
+	mlx5_esw_release(priv->mdev);
 	return 0;
 
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
+	mlx5_esw_put(priv->mdev);
+	mlx5_esw_release(priv->mdev);
 	return err;
 }
 
@@ -4404,6 +4412,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
 
+	mlx5_esw_put(priv->mdev);
 	return 0;
 
 errout:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ddee2aefe8b9..6b260dacf853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -435,6 +435,7 @@ static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw)
 	esw->fdb_table.legacy.addr_grp = NULL;
 	esw->fdb_table.legacy.allmulti_grp = NULL;
 	esw->fdb_table.legacy.promisc_grp = NULL;
+	atomic64_set(&esw->user_count, 0);
 }
 
 static int esw_create_legacy_table(struct mlx5_eswitch *esw)
@@ -442,6 +443,7 @@ static int esw_create_legacy_table(struct mlx5_eswitch *esw)
 	int err;
 
 	memset(&esw->fdb_table.legacy, 0, sizeof(struct legacy_fdb));
+	atomic64_set(&esw->user_count, 0);
 
 	err = esw_create_legacy_vepa_table(esw);
 	if (err)
@@ -2581,3 +2583,94 @@ void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct notifie
 {
 	blocking_notifier_chain_unregister(&esw->n_head, nb);
 }
+
+/**
+ * mlx5_esw_hold() - Try to take a read lock on esw mode lock.
+ * @mdev: mlx5 core device.
+ *
+ * Should be called by esw resources callers.
+ *
+ * Return: true on success or false.
+ */
+bool mlx5_esw_hold(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+
+	/* e.g. VF doesn't have eswitch so nothing to do */
+	if (!ESW_ALLOWED(esw))
+		return true;
+
+	if (down_read_trylock(&esw->mode_lock) != 0)
+		return true;
+
+	return false;
+}
+
+/**
+ * mlx5_esw_release() - Release a read lock on esw mode lock.
+ * @mdev: mlx5 core device.
+ */
+void mlx5_esw_release(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+
+	if (ESW_ALLOWED(esw))
+		up_read(&esw->mode_lock);
+}
+
+/**
+ * mlx5_esw_get() - Increase esw user count.
+ * @mdev: mlx5 core device.
+ */
+void mlx5_esw_get(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+
+	if (ESW_ALLOWED(esw))
+		atomic64_inc(&esw->user_count);
+}
+
+/**
+ * mlx5_esw_put() - Decrease esw user count.
+ * @mdev: mlx5 core device.
+ */
+void mlx5_esw_put(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+
+	if (ESW_ALLOWED(esw))
+		atomic64_dec_if_positive(&esw->user_count);
+}
+
+/**
+ * mlx5_esw_try_lock() - Take a write lock on esw mode lock.
+ * @esw: eswitch device.
+ *
+ * Should be called by esw mode change routine.
+ *
+ * Return:
+ * * 0       - esw mode if successfully locked and refcount is 0.
+ * * -EBUSY  - refcount is not 0.
+ * * -EINVAL - In the middle of switching mode or lock is already held.
+ */
+int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
+{
+	if (down_write_trylock(&esw->mode_lock) == 0)
+		return -EINVAL;
+
+	if (atomic64_read(&esw->user_count) > 0) {
+		up_write(&esw->mode_lock);
+		return -EBUSY;
+	}
+
+	return esw->mode;
+}
+
+/**
+ * mlx5_esw_unlock() - Release write lock on esw mode lock
+ * @esw: eswitch device.
+ */
+void mlx5_esw_unlock(struct mlx5_eswitch *esw)
+{
+	up_write(&esw->mode_lock);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b149d1d2c150..56d85cedb9bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -272,6 +272,7 @@ struct mlx5_eswitch {
 	 * user commands, i.e. sriov state change, devlink commands.
 	 */
 	struct rw_semaphore mode_lock;
+	atomic64_t user_count;
 
 	struct {
 		bool            enabled;
@@ -761,6 +762,14 @@ struct mlx5_esw_event_info {
 
 int mlx5_esw_event_notifier_register(struct mlx5_eswitch *esw, struct notifier_block *n);
 void mlx5_esw_event_notifier_unregister(struct mlx5_eswitch *esw, struct notifier_block *n);
+
+bool mlx5_esw_hold(struct mlx5_core_dev *dev);
+void mlx5_esw_release(struct mlx5_core_dev *dev);
+void mlx5_esw_get(struct mlx5_core_dev *dev);
+void mlx5_esw_put(struct mlx5_core_dev *dev);
+int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
+void mlx5_esw_unlock(struct mlx5_eswitch *esw);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5e2712521fec..8e7a702e23a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1854,6 +1854,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
 				     MLX5_FLOW_STEERING_MODE_DMFS);
+	atomic64_set(&esw->user_count, 0);
 }
 
 static int esw_create_offloads_table(struct mlx5_eswitch *esw)
@@ -2584,6 +2585,7 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.vports.lock);
 	hash_init(esw->fdb_table.offloads.vports.table);
+	atomic64_set(&esw->user_count, 0);
 
 	indir = mlx5_esw_indir_table_init();
 	if (IS_ERR(indir)) {
@@ -2925,8 +2927,14 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
-	down_write(&esw->mode_lock);
-	cur_mlx5_mode = esw->mode;
+	err = mlx5_esw_try_lock(esw);
+	if (err < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't change mode, E-Switch is busy");
+		return err;
+	}
+	cur_mlx5_mode = err;
+	err = 0;
+
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
@@ -2938,7 +2946,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = -EINVAL;
 
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return err;
 }
 
-- 
2.30.2

