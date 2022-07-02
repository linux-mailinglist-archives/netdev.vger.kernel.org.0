Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7F564250
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiGBTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiGBTEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DBDDEA3
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4FE3B8013C
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9880BC34114;
        Sat,  2 Jul 2022 19:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788665;
        bh=Hq8WlysE753Il7iEmgvm93whpveW26AVgjLZnb0Plmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxjSAlUboxnFc30sJchhKtoEPengFGJ0hbYgDTB6Y7iWh0suDQeFyVHY8KK3Y2aef
         OgKYQFuDDpa3SWLMqgA+LM6dBwQ6BujiMP70wvZMHska4Ayh1wGcCSe5W0IE5G9gvC
         reeTJ/q5z52sCvrabZKxQx+cBDxf1/j1mij8/3BpnbgC9wdBubVlku24FxZQnaTZjG
         KonjR5oYBXrOqzSZtv8EJHep8dN7rXzvB6LD/YuW6aZBa/9E0eoFKa/p8h7d7wDSRC
         7+ML3OTXF+zDVy3QLpteB3q+6BeEDTCgW1noNFcO1BpCvIMWLOEGHn5sAnNf94xFfF
         1vuVVHetDoDjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Chris Mi <cmi@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next v2 05/15] net/mlx5: E-switch, Remove dependency between sriov and eswitch mode
Date:   Sat,  2 Jul 2022 12:02:03 -0700
Message-Id: <20220702190213.80858-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently, there are three eswitch modes, none, legacy and switchdev.
None is the default mode. Remove redundant none mode as eswitch mode
should always be either legacy mode or switchdev mode.

With this patch, there are two behavior changes:

1. Legacy becomes the default mode. When querying eswitch mode using
   devlink, a valid mode is always returned.
2. When disabling sriov, the eswitch mode will not change, only vfs
   are unloaded.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 87 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  9 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 52 ++++-------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 10 +--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  3 +-
 include/linux/mlx5/eswitch.h                  |  8 +-
 8 files changed, 89 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b9a3473f5672..82b62ab1d1d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1152,8 +1152,6 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
 {
 	const u32 *out;
 
-	WARN_ON_ONCE(esw->mode != MLX5_ESWITCH_NONE);
-
 	if (num_vfs < 0)
 		return;
 
@@ -1287,7 +1285,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	return 0;
 
 abort:
-	esw->mode = MLX5_ESWITCH_NONE;
+	esw->mode = MLX5_ESWITCH_LEGACY;
 
 	if (mode == MLX5_ESWITCH_OFFLOADS)
 		mlx5_rescan_drivers(esw->dev);
@@ -1312,13 +1310,13 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	toggle_lag = esw->mode == MLX5_ESWITCH_NONE;
+	toggle_lag = !mlx5_esw_is_fdb_created(esw);
 
 	if (toggle_lag)
 		mlx5_lag_disable_change(esw->dev);
 
 	down_write(&esw->mode_lock);
-	if (esw->mode == MLX5_ESWITCH_NONE) {
+	if (!mlx5_esw_is_fdb_created(esw)) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
 	} else {
 		enum mlx5_eswitch_vport_event vport_events;
@@ -1337,56 +1335,79 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	return ret;
 }
 
-void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
+/* When disabling sriov, free driver level resources. */
+void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 {
-	struct devlink *devlink = priv_to_devlink(esw->dev);
-	int old_mode;
-
-	lockdep_assert_held_write(&esw->mode_lock);
-
-	if (esw->mode == MLX5_ESWITCH_NONE)
+	if (!mlx5_esw_allowed(esw))
 		return;
 
-	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), active vports(%d)\n",
+	down_write(&esw->mode_lock);
+	/* If driver is unloaded, this function is called twice by remove_one()
+	 * and mlx5_unload(). Prevent the second call.
+	 */
+	if (!esw->esw_funcs.num_vfs && !clear_vf)
+		goto unlock;
+
+	esw_info(esw->dev, "Unload vfs: mode(%s), nvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
+	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
+	if (clear_vf)
+		mlx5_eswitch_clear_vf_vports_info(esw);
+	/* If disabling sriov in switchdev mode, free meta rules here
+	 * because it depends on num_vfs.
+	 */
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS) {
+		struct devlink *devlink = priv_to_devlink(esw->dev);
+
+		esw_offloads_del_send_to_vport_meta_rules(esw);
+		devlink_rate_nodes_destroy(devlink);
+	}
+
+	esw->esw_funcs.num_vfs = 0;
+
+unlock:
+	up_write(&esw->mode_lock);
+}
+
+/* Free resources for corresponding eswitch mode. It is called by devlink
+ * when changing eswitch mode or modprobe when unloading driver.
+ */
+void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
+{
+	struct devlink *devlink = priv_to_devlink(esw->dev);
+
 	/* Notify eswitch users that it is exiting from current mode.
 	 * So that it can do necessary cleanup before the eswitch is disabled.
 	 */
-	mlx5_esw_mode_change_notify(esw, MLX5_ESWITCH_NONE);
+	mlx5_esw_mode_change_notify(esw, MLX5_ESWITCH_LEGACY);
 
 	mlx5_eswitch_event_handlers_unregister(esw);
 
+	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), active vports(%d)\n",
+		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
+		 esw->esw_funcs.num_vfs, esw->enabled_vports);
+
 	esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
-	if (esw->mode == MLX5_ESWITCH_LEGACY)
-		esw_legacy_disable(esw);
-	else if (esw->mode == MLX5_ESWITCH_OFFLOADS)
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		esw_offloads_disable(esw);
-
-	old_mode = esw->mode;
-	esw->mode = MLX5_ESWITCH_NONE;
-
-	if (old_mode == MLX5_ESWITCH_OFFLOADS)
-		mlx5_rescan_drivers(esw->dev);
-
-	devlink_rate_nodes_destroy(devlink);
-
+	else if (esw->mode == MLX5_ESWITCH_LEGACY)
+		esw_legacy_disable(esw);
 	mlx5_esw_acls_ns_cleanup(esw);
 
-	if (clear_vf)
-		mlx5_eswitch_clear_vf_vports_info(esw);
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
+		devlink_rate_nodes_destroy(devlink);
 }
 
-void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
+void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 {
 	if (!mlx5_esw_allowed(esw))
 		return;
 
 	mlx5_lag_disable_change(esw->dev);
 	down_write(&esw->mode_lock);
-	mlx5_eswitch_disable_locked(esw, clear_vf);
-	esw->esw_funcs.num_vfs = 0;
+	mlx5_eswitch_disable_locked(esw);
 	up_write(&esw->mode_lock);
 	mlx5_lag_enable_change(esw->dev);
 }
@@ -1581,7 +1602,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	refcount_set(&esw->qos.refcnt, 0);
 
 	esw->enabled_vports = 0;
-	esw->mode = MLX5_ESWITCH_NONE;
+	esw->mode = MLX5_ESWITCH_LEGACY;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
 	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
 	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
@@ -1883,7 +1904,7 @@ u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
-	return mlx5_esw_allowed(esw) ? esw->mode : MLX5_ESWITCH_NONE;
+	return mlx5_esw_allowed(esw) ? esw->mode : MLX5_ESWITCH_LEGACY;
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a9ba0e324834..5452437e531f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -342,6 +342,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw);
 int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
+void esw_offloads_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw);
 
 bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw);
 int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
@@ -357,8 +358,9 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
 #define MLX5_ESWITCH_IGNORE_NUM_VFS (-1)
 int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs);
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs);
-void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf);
-void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf);
+void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf);
+void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw);
+void mlx5_eswitch_disable(struct mlx5_eswitch *esw);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 			       u16 vport, const u8 *mac);
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
@@ -729,7 +731,8 @@ int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
 static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { return 0; }
-static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
+static inline void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf) {}
+static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
 static inline
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2ce3728576d1..7c51011aed2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1040,6 +1040,15 @@ static void mlx5_eswitch_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 		mlx5_del_flow_rules(flows[i]);
 
 	kvfree(flows);
+	/* If changing eswitch mode from switchdev to legacy, but num_vfs is not 0,
+	 * meta rules could be freed again. So set it to NULL.
+	 */
+	esw->fdb_table.offloads.send_to_vport_meta_rules = NULL;
+}
+
+void esw_offloads_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
+{
+	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
 }
 
 static int
@@ -2034,7 +2043,7 @@ static int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, u8 *mode)
 	if (!MLX5_CAP_GEN(dev, vport_group_manager))
 		return -EOPNOTSUPP;
 
-	if (esw->mode == MLX5_ESWITCH_NONE)
+	if (!mlx5_esw_is_fdb_created(esw))
 		return -EOPNOTSUPP;
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
@@ -2170,7 +2179,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	mlx5_eswitch_disable_locked(esw, false);
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
 					 esw->dev->priv.sriov.num_vfs);
 	if (err) {
@@ -2894,7 +2902,7 @@ int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable)
 	int err = 0;
 
 	down_write(&esw->mode_lock);
-	if (esw->mode != MLX5_ESWITCH_NONE) {
+	if (mlx5_esw_is_fdb_created(esw)) {
 		err = -EBUSY;
 		goto done;
 	}
@@ -3229,7 +3237,6 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	mlx5_eswitch_disable_locked(esw, false);
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY,
 					 MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
@@ -3334,15 +3341,6 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-static int eswitch_devlink_esw_mode_check(const struct mlx5_eswitch *esw)
-{
-	/* devlink commands in NONE eswitch mode are currently supported only
-	 * on ECPF.
-	 */
-	return (esw->mode == MLX5_ESWITCH_NONE &&
-		!mlx5_core_is_ecpf_esw_manager(esw->dev)) ? -EOPNOTSUPP : 0;
-}
-
 /* FIXME: devl_unlock() followed by devl_lock() inside driver callback
  * is never correct and prone to races. It's a transitional workaround,
  * never repeat this pattern.
@@ -3399,6 +3397,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
+	mlx5_eswitch_disable_locked(esw);
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -3409,6 +3408,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = esw_offloads_start(esw, extack);
 	} else if (mode == DEVLINK_ESWITCH_MODE_LEGACY) {
 		err = esw_offloads_stop(esw, extack);
+		mlx5_rescan_drivers(esw->dev);
 	} else {
 		err = -EINVAL;
 	}
@@ -3431,12 +3431,7 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 		return PTR_ERR(esw);
 
 	mlx5_eswtich_mode_callback_enter(devlink, esw);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto unlock;
-
 	err = esw_mode_to_devlink(esw->mode, mode);
-unlock:
 	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
@@ -3485,9 +3480,6 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 		return PTR_ERR(esw);
 
 	mlx5_eswtich_mode_callback_enter(devlink, esw);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto out;
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
@@ -3539,12 +3531,7 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 		return PTR_ERR(esw);
 
 	mlx5_eswtich_mode_callback_enter(devlink, esw);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto unlock;
-
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
-unlock:
 	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
@@ -3555,16 +3542,13 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	struct mlx5_eswitch *esw;
-	int err;
+	int err = 0;
 
 	esw = mlx5_devlink_eswitch_get(devlink);
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
 	mlx5_eswtich_mode_callback_enter(devlink, esw);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto unlock;
 
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
@@ -3615,21 +3599,15 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode *encap)
 {
 	struct mlx5_eswitch *esw;
-	int err;
 
 	esw = mlx5_devlink_eswitch_get(devlink);
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
 	mlx5_eswtich_mode_callback_enter(devlink, esw);
-	err = eswitch_devlink_esw_mode_check(esw);
-	if (err)
-		goto unlock;
-
 	*encap = esw->offloads.encap;
-unlock:
 	mlx5_eswtich_mode_callback_exit(devlink, esw);
-	return err;
+	return 0;
 }
 
 static bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 2a8fc547eb37..641505d2c0c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -632,6 +632,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
 #ifdef CONFIG_MLX5_ESWITCH
+	struct mlx5_core_dev *dev;
 	u8 mode;
 #endif
 	int i;
@@ -641,11 +642,11 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 			return false;
 
 #ifdef CONFIG_MLX5_ESWITCH
-	mode = mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev);
-
-	if (mode != MLX5_ESWITCH_NONE && mode != MLX5_ESWITCH_OFFLOADS)
+	dev = ldev->pf[MLX5_LAG_P1].dev;
+	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev))
 		return false;
 
+	mode = mlx5_eswitch_mode(dev);
 	for (i = 0; i < ldev->ports; i++)
 		if (mlx5_eswitch_mode(ldev->pf[i].dev) != mode)
 			return false;
@@ -760,8 +761,7 @@ static bool mlx5_lag_is_roce_lag(struct mlx5_lag *ldev)
 
 #ifdef CONFIG_MLX5_ESWITCH
 	for (i = 0; i < ldev->ports; i++)
-		roce_lag = roce_lag &&
-			ldev->pf[i].dev->priv.eswitch->mode == MLX5_ESWITCH_NONE;
+		roce_lag = roce_lag && is_mdev_legacy_mode(ldev->pf[i].dev);
 #endif
 
 	return roce_lag;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2078d9f03a5f..a9e51c1b7738 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1250,6 +1250,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 {
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sf_hw_table_destroy(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 3be659cd91f1..7d955a4d9f14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -501,7 +501,7 @@ static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long event, voi
 	case MLX5_ESWITCH_OFFLOADS:
 		mlx5_sf_table_enable(table);
 		break;
-	case MLX5_ESWITCH_NONE:
+	case MLX5_ESWITCH_LEGACY:
 		mlx5_sf_table_disable(table);
 		break;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 2935614f6fa9..5757cd6e1819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -145,8 +145,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 		sriov->vfs_ctx[vf].enabled = 0;
 	}
 
-	if (MLX5_ESWITCH_MANAGER(dev))
-		mlx5_eswitch_disable(dev->priv.eswitch, clear_vf);
+	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
 	if (mlx5_wait_for_pages(dev, &dev->priv.vfs_pages))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 8b18fe9771f9..e2701ed0200e 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -12,7 +12,6 @@
 #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev, eswitch_manager)
 
 enum {
-	MLX5_ESWITCH_NONE,
 	MLX5_ESWITCH_LEGACY,
 	MLX5_ESWITCH_OFFLOADS
 };
@@ -153,7 +152,7 @@ struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw);
 
 static inline u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
-	return MLX5_ESWITCH_NONE;
+	return MLX5_ESWITCH_LEGACY;
 }
 
 static inline enum devlink_eswitch_encap_mode
@@ -198,6 +197,11 @@ static inline struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitc
 
 #endif /* CONFIG_MLX5_ESWITCH */
 
+static inline bool is_mdev_legacy_mode(struct mlx5_core_dev *dev)
+{
+	return mlx5_eswitch_mode(dev) == MLX5_ESWITCH_LEGACY;
+}
+
 static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
 {
 	return mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS;
-- 
2.36.1

