Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D7852B2BC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiERGuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiERGuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F76423141
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC4860BD3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4BBC385A5;
        Wed, 18 May 2022 06:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856595;
        bh=PLRkoRaPdf/vevAhYcwXyQ/XV2mpmU4a2ViMotL1LG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAm4VMYnHs+koPX9iCsvbIyLfRaWNzRxcQp+G+L48kW0vmEJ/avgcXuBqZgaGCu2+
         xO3Mmc2ja4w7ykIsbBk8SleF6yoN+nCiUNKcFJPEuOHLPWi9Wtna2lx0lt3KcSNeIo
         va4c8J3qSKCgTR/dGL001xZseg0duFi/A+Q2YpOn7jdpXjqwcRgejkM1+hk/Ee1ZSz
         Xfxrk3+5a5UcJZx+6GF1uoUgp0frUMi45gdD4G/iPHNdfPidRgJ4oMkmnDJOe/RpVC
         oEucWwPHHa09dw82US3n1t1urNind+OmivBzSZA2uw3JvoKi9zSX0N+ETzWxVCjNac
         85KOrqhhl/4UA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5: Lag, refactor lag state machine
Date:   Tue, 17 May 2022 23:49:36 -0700
Message-Id: <20220518064938.128220-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

LAG state machine is implemented using bit flags. However, all these bit
flags, except for MLX5_LAG_FLAG_HASH_BASED, are really mutual exclusive.

In addition, MLX5_LAG_FLAG_READY is used by bonding to mark if we have
our netdevices successfully added to lag and does not really belong in
the same flags variable as the other flags.

Rename MLX5_LAG_FLAG_READY to MLX5_LAG_FLAG_NDEVS_READY to better
reflect its purpose and put it in a new flags variable.

For the rest of the flags, we introduce a mode enum to hold the state
of the LAG.

Remove the shared fdb boolean flag from struct mlx5_lag and store this
configuration as a mode flag.

Change all flag related operations to use standard Linux APIs.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lag/debugfs.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 112 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  33 +++---
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  |   4 +-
 4 files changed, 93 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index 443daf6e3d4b..6e7001c0cfd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -5,11 +5,11 @@
 
 static char *get_str_mode_type(struct mlx5_lag *ldev)
 {
-	if (ldev->flags & MLX5_LAG_FLAG_ROCE)
+	if (ldev->mode == MLX5_LAG_MODE_ROCE)
 		return "roce";
-	if (ldev->flags & MLX5_LAG_FLAG_SRIOV)
+	if (ldev->mode == MLX5_LAG_MODE_SRIOV)
 		return "switchdev";
-	if (ldev->flags & MLX5_LAG_FLAG_MULTIPATH)
+	if (ldev->mode == MLX5_LAG_MODE_MULTIPATH)
 		return "multipath";
 
 	return NULL;
@@ -43,7 +43,7 @@ static int port_sel_mode_show(struct seq_file *file, void *priv)
 	ldev = dev->priv.lag;
 	mutex_lock(&ldev->lock);
 	if (__mlx5_lag_is_active(ldev))
-		mode = get_str_port_sel_mode(ldev->flags);
+		mode = get_str_port_sel_mode(ldev->mode_flags);
 	else
 		ret = -EINVAL;
 	mutex_unlock(&ldev->lock);
@@ -79,7 +79,7 @@ static int flags_show(struct seq_file *file, void *priv)
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
 	if (lag_active)
-		shared_fdb = ldev->shared_fdb;
+		shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
 
 	mutex_unlock(&ldev->lock);
 	if (!lag_active)
@@ -103,7 +103,7 @@ static int mapping_show(struct seq_file *file, void *priv)
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
 	if (lag_active) {
-		if (ldev->flags & MLX5_LAG_FLAG_HASH_BASED) {
+		if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags)) {
 			mlx5_infer_tx_enabled(&ldev->tracker, ldev->ports, ports,
 					      &num_ports);
 			hash = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index b6dd9043061f..3eb195cba205 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -53,21 +53,30 @@ enum {
  */
 static DEFINE_SPINLOCK(lag_lock);
 
-static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, bool shared_fdb, u8 flags)
+static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 {
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
+		return MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT;
+
+	return MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY;
+}
+
+static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
+			       unsigned long flags)
+{
+	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
+	int port_sel_mode = get_port_sel_mode(mode, flags);
 	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
-	void *lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
+	void *lag_ctx;
 
+	lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
-
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, shared_fdb);
-	if (!(flags & MLX5_LAG_FLAG_HASH_BASED)) {
+	if (port_sel_mode == MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY) {
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
-	} else {
-		MLX5_SET(lagc, lag_ctx, port_select_mode,
-			 MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT);
 	}
+	MLX5_SET(lagc, lag_ctx, port_select_mode, port_sel_mode);
 
 	return mlx5_cmd_exec_in(dev, create_lag, in);
 }
@@ -139,7 +148,7 @@ void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
 static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
 				   struct mlx5_lag *ldev,
 				   struct lag_tracker *tracker,
-				   u8 flags)
+				   unsigned long flags)
 {
 	char buf[MLX5_MAX_PORTS * 10 + 1] = {};
 	u8 enabled_ports[MLX5_MAX_PORTS] = {};
@@ -150,7 +159,7 @@ static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
 	int i;
 	int j;
 
-	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
 		mlx5_infer_tx_enabled(tracker, ldev->ports, enabled_ports,
 				      &num_enabled);
 		for (i = 0; i < num_enabled; i++) {
@@ -227,6 +236,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 		ldev->nb.notifier_call = NULL;
 		mlx5_core_err(dev, "Failed to register LAG netdev notifier\n");
 	}
+	ldev->mode = MLX5_LAG_MODE_NONE;
 
 	err = mlx5_lag_mp_init(ldev);
 	if (err)
@@ -252,12 +262,12 @@ int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 
 static bool __mlx5_lag_is_roce(struct mlx5_lag *ldev)
 {
-	return !!(ldev->flags & MLX5_LAG_FLAG_ROCE);
+	return ldev->mode == MLX5_LAG_MODE_ROCE;
 }
 
 static bool __mlx5_lag_is_sriov(struct mlx5_lag *ldev)
 {
-	return !!(ldev->flags & MLX5_LAG_FLAG_SRIOV);
+	return ldev->mode == MLX5_LAG_MODE_SRIOV;
 }
 
 /* Create a mapping between steering slots and active ports.
@@ -372,7 +382,7 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 
-	if (ldev->flags & MLX5_LAG_FLAG_HASH_BASED)
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &ldev->mode_flags))
 		return mlx5_lag_port_sel_modify(ldev, ports);
 	return mlx5_cmd_modify_lag(dev0, ldev->ports, ports);
 }
@@ -404,19 +414,19 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 			memcpy(ldev->v2p_map, ports, sizeof(ports));
 
 			mlx5_lag_print_mapping(dev0, ldev, tracker,
-					       ldev->flags);
+					       ldev->mode_flags);
 			break;
 		}
 	}
 
 	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
-	    !(ldev->flags & MLX5_LAG_FLAG_ROCE))
+	    !(ldev->mode == MLX5_LAG_MODE_ROCE))
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 }
 
 #define MLX5_LAG_ROCE_HASH_PORTS_SUPPORTED 4
 static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
-					   struct lag_tracker *tracker, u8 *flags)
+					   unsigned long *flags)
 {
 	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
 
@@ -424,7 +434,7 @@ static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 		/* Four ports are support only in hash mode */
 		if (!MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table))
 			return -EINVAL;
-		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+		set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
 		if (ldev->ports > 2)
 			ldev->buckets = MLX5_LAG_MAX_HASH_BUCKETS;
 	}
@@ -433,38 +443,46 @@ static int mlx5_lag_set_port_sel_mode_roce(struct mlx5_lag *ldev,
 }
 
 static int mlx5_lag_set_port_sel_mode_offloads(struct mlx5_lag *ldev,
-					       struct lag_tracker *tracker, u8 *flags)
+					       struct lag_tracker *tracker, unsigned long *flags)
 {
 	struct lag_func *dev0 = &ldev->pf[MLX5_LAG_P1];
 
 	if (MLX5_CAP_PORT_SELECTION(dev0->dev, port_select_flow_table) &&
 	    tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH)
-		*flags |= MLX5_LAG_FLAG_HASH_BASED;
+		set_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, flags);
 
 	return 0;
 }
 
-static int mlx5_lag_set_port_sel_mode(struct mlx5_lag *ldev,
-				      struct lag_tracker *tracker, u8 *flags)
+static int mlx5_lag_set_flags(struct mlx5_lag *ldev, enum mlx5_lag_mode mode,
+			      struct lag_tracker *tracker, bool shared_fdb,
+			      unsigned long *flags)
 {
-	bool roce_lag = !!(*flags & MLX5_LAG_FLAG_ROCE);
+	bool roce_lag = mode == MLX5_LAG_MODE_ROCE;
+
+	*flags = 0;
+	if (shared_fdb)
+		set_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, flags);
 
 	if (roce_lag)
-		return mlx5_lag_set_port_sel_mode_roce(ldev, tracker, flags);
+		return mlx5_lag_set_port_sel_mode_roce(ldev, flags);
+
 	return mlx5_lag_set_port_sel_mode_offloads(ldev, tracker, flags);
 }
 
-char *get_str_port_sel_mode(u8 flags)
+char *get_str_port_sel_mode(unsigned long flags)
 {
-	if (flags &  MLX5_LAG_FLAG_HASH_BASED)
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
 		return "hash";
 	return "queue_affinity";
 }
 
 static int mlx5_create_lag(struct mlx5_lag *ldev,
 			   struct lag_tracker *tracker,
-			   bool shared_fdb, u8 flags)
+			   enum mlx5_lag_mode mode,
+			   unsigned long flags)
 {
+	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
@@ -474,7 +492,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, get_str_port_sel_mode(flags));
 
-	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map, shared_fdb, flags);
+	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map, mode, flags);
 	if (err) {
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
@@ -503,20 +521,20 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 
 int mlx5_activate_lag(struct mlx5_lag *ldev,
 		      struct lag_tracker *tracker,
-		      u8 flags,
+		      enum mlx5_lag_mode mode,
 		      bool shared_fdb)
 {
-	bool roce_lag = !!(flags & MLX5_LAG_FLAG_ROCE);
+	bool roce_lag = mode == MLX5_LAG_MODE_ROCE;
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	unsigned long flags;
 	int err;
 
-	err = mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
+	err = mlx5_lag_set_flags(ldev, mode, tracker, shared_fdb, &flags);
 	if (err)
 		return err;
 
 	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->buckets, ldev->v2p_map);
-
-	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
 		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
 					       ldev->v2p_map);
 		if (err) {
@@ -527,9 +545,9 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		}
 	}
 
-	err = mlx5_create_lag(ldev, tracker, shared_fdb, flags);
+	err = mlx5_create_lag(ldev, tracker, mode, flags);
 	if (err) {
-		if (flags & MLX5_LAG_FLAG_HASH_BASED)
+		if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
 			mlx5_lag_port_sel_destroy(ldev);
 		if (roce_lag)
 			mlx5_core_err(dev0,
@@ -545,8 +563,8 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	    !roce_lag)
 		mlx5_lag_drop_rule_setup(ldev, tracker);
 
-	ldev->flags |= flags;
-	ldev->shared_fdb = shared_fdb;
+	ldev->mode = mode;
+	ldev->mode_flags = flags;
 	return 0;
 }
 
@@ -556,16 +574,17 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
-	u8 flags = ldev->flags;
+	unsigned long flags = ldev->mode_flags;
 	int err;
 
-	ldev->flags &= ~MLX5_LAG_MODE_FLAGS;
+	ldev->mode = MLX5_LAG_MODE_NONE;
+	ldev->mode_flags = 0;
 	mlx5_lag_mp_reset(ldev);
 
-	if (ldev->shared_fdb) {
+	if (test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags)) {
 		mlx5_eswitch_offloads_destroy_single_fdb(dev0->priv.eswitch,
 							 dev1->priv.eswitch);
-		ldev->shared_fdb = false;
+		clear_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
 	}
 
 	MLX5_SET(destroy_lag_in, in, opcode, MLX5_CMD_OP_DESTROY_LAG);
@@ -582,7 +601,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 		return err;
 	}
 
-	if (flags & MLX5_LAG_FLAG_HASH_BASED)
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
 		mlx5_lag_port_sel_destroy(ldev);
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
@@ -658,9 +677,9 @@ static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 
 static void mlx5_disable_lag(struct mlx5_lag *ldev)
 {
+	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	bool shared_fdb = ldev->shared_fdb;
 	bool roce_lag;
 	int err;
 	int i;
@@ -759,8 +778,8 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 			mlx5_lag_remove_devices(ldev);
 
 		err = mlx5_activate_lag(ldev, &tracker,
-					roce_lag ? MLX5_LAG_FLAG_ROCE :
-						   MLX5_LAG_FLAG_SRIOV,
+					roce_lag ? MLX5_LAG_MODE_ROCE :
+						   MLX5_LAG_MODE_SRIOV,
 					shared_fdb);
 		if (err) {
 			if (shared_fdb || roce_lag)
@@ -1156,7 +1175,7 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev,
 
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_remove_netdev(ldev, netdev);
-	ldev->flags &= ~MLX5_LAG_FLAG_READY;
+	clear_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
 
 	lag_is_active = __mlx5_lag_is_active(ldev);
 	mutex_unlock(&ldev->lock);
@@ -1183,7 +1202,7 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 			break;
 
 	if (i >= ldev->ports)
-		ldev->flags |= MLX5_LAG_FLAG_READY;
+		set_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
 	mutex_unlock(&ldev->lock);
 	mlx5_queue_bond_work(ldev, 0);
 }
@@ -1252,7 +1271,8 @@ bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
 
 	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev(dev);
-	res = ldev && __mlx5_lag_is_sriov(ldev) && ldev->shared_fdb;
+	res = ldev && __mlx5_lag_is_sriov(ldev) &&
+	      test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
 	spin_unlock(&lag_lock);
 
 	return res;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 46683b84ff84..244b548e1420 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -17,16 +17,20 @@ enum {
 };
 
 enum {
-	MLX5_LAG_FLAG_ROCE   = 1 << 0,
-	MLX5_LAG_FLAG_SRIOV  = 1 << 1,
-	MLX5_LAG_FLAG_MULTIPATH = 1 << 2,
-	MLX5_LAG_FLAG_READY = 1 << 3,
-	MLX5_LAG_FLAG_HASH_BASED = 1 << 4,
+	MLX5_LAG_FLAG_NDEVS_READY,
 };
 
-#define MLX5_LAG_MODE_FLAGS (MLX5_LAG_FLAG_ROCE | MLX5_LAG_FLAG_SRIOV |\
-			     MLX5_LAG_FLAG_MULTIPATH | \
-			     MLX5_LAG_FLAG_HASH_BASED)
+enum {
+	MLX5_LAG_MODE_FLAG_HASH_BASED,
+	MLX5_LAG_MODE_FLAG_SHARED_FDB,
+};
+
+enum mlx5_lag_mode {
+	MLX5_LAG_MODE_NONE,
+	MLX5_LAG_MODE_ROCE,
+	MLX5_LAG_MODE_SRIOV,
+	MLX5_LAG_MODE_MULTIPATH,
+};
 
 struct lag_func {
 	struct mlx5_core_dev *dev;
@@ -47,11 +51,12 @@ struct lag_tracker {
  * It serves both its phys functions.
  */
 struct mlx5_lag {
-	u8                        flags;
+	enum mlx5_lag_mode        mode;
+	unsigned long		  mode_flags;
+	unsigned long		  state_flags;
 	u8			  ports;
 	u8			  buckets;
 	int			  mode_changes_in_progress;
-	bool			  shared_fdb;
 	u8			  v2p_map[MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS];
 	struct kref               ref;
 	struct lag_func           pf[MLX5_MAX_PORTS];
@@ -74,25 +79,25 @@ mlx5_lag_dev(struct mlx5_core_dev *dev)
 static inline bool
 __mlx5_lag_is_active(struct mlx5_lag *ldev)
 {
-	return !!(ldev->flags & MLX5_LAG_MODE_FLAGS);
+	return ldev->mode != MLX5_LAG_MODE_NONE;
 }
 
 static inline bool
 mlx5_lag_is_ready(struct mlx5_lag *ldev)
 {
-	return ldev->flags & MLX5_LAG_FLAG_READY;
+	return test_bit(MLX5_LAG_FLAG_NDEVS_READY, &ldev->state_flags);
 }
 
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker);
 int mlx5_activate_lag(struct mlx5_lag *ldev,
 		      struct lag_tracker *tracker,
-		      u8 flags,
+		      enum mlx5_lag_mode mode,
 		      bool shared_fdb);
 int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 				struct net_device *ndev);
 
-char *get_str_port_sel_mode(u8 flags);
+char *get_str_port_sel_mode(unsigned long flags);
 void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
 			   u8 *ports, int *num_enabled);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index d6c3e6dfd71f..0259a149a64c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -11,7 +11,7 @@
 
 static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
 {
-	return !!(ldev->flags & MLX5_LAG_FLAG_MULTIPATH);
+	return ldev->mode == MLX5_LAG_MODE_MULTIPATH;
 }
 
 static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
@@ -179,7 +179,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 		struct lag_tracker tracker;
 
 		tracker = ldev->tracker;
-		mlx5_activate_lag(ldev, &tracker, MLX5_LAG_FLAG_MULTIPATH, false);
+		mlx5_activate_lag(ldev, &tracker, MLX5_LAG_MODE_MULTIPATH, false);
 	}
 
 	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
-- 
2.36.1

