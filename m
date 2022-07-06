Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE6A5695A8
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiGFXN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiGFXNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D541CF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291C2B81F20
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC032C341C6;
        Wed,  6 Jul 2022 23:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149199;
        bh=PqmM6znB0TPagV3ZRM3oi+6ut5OxWzj2+UJ6ED39g90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B34j/E4jtONEr1/tTDcg+vyr3WAb5yaed976jb9vdrtt5sV2JGlvUTJ6/ZxrV9mMw
         tUOgi7Mz8SLUy+IqkSCFgGpADaoDaNKQvBI6WUX4wzTZ8vKGGMgoboNeNO8bvqvze7
         2qatRXX8vGj6xT4RA1mp5fPPb8SyQmvc+Xtl3VB69EyR4OM0MGdUfk3+GPdGAPXSLv
         j1cDWZ/PhQBY9i39uTBhjfRpUJkzFuGWfYaMJXr4WZw9yl19oGpz1Gvd1P+KUbqGhb
         0MoQfjutcYm5SfY4aXid60I67CFbT5BAXG3e7Gi32xAAsC6sZ7au5AWzRiMsP6Lcfr
         pmh08MuFuW/IQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net 2/9] net/mlx5: Lag, decouple FDB selection and shared FDB
Date:   Wed,  6 Jul 2022 16:13:02 -0700
Message-Id: <20220706231309.38579-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Multiport eswitch is required to use native FDB selection instead of
affinity, This was achieved by passing the shared_fdb flag down
the HW lag creation path. While it did accomplish the goal of setting
FDB selection mode to native, it had the side effect of also
creating a shared FDB configuration.

This created a few issues:
- TC rules are inserted into a non active FDB, which means traffic isn't
  offloaded as all traffic will reach only a single FDB.
- All wire traffic is treated as if a single physical port received it; while
  this is true for a bond configuration, this shouldn't be the case for
  multiport eswitch.

Create a new flag MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE
to indicate what FDB selection mode should be used.

Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c    | 12 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c    | 12 +++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c  |  5 ++---
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index 15e41dc84d53..f1ad233ec990 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -72,6 +72,7 @@ static int state_show(struct seq_file *file, void *priv)
 static int flags_show(struct seq_file *file, void *priv)
 {
 	struct mlx5_core_dev *dev = file->private;
+	bool fdb_sel_mode_native;
 	struct mlx5_lag *ldev;
 	bool shared_fdb;
 	bool lag_active;
@@ -79,14 +80,21 @@ static int flags_show(struct seq_file *file, void *priv)
 	ldev = dev->priv.lag;
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
-	if (lag_active)
-		shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
+	if (!lag_active)
+		goto unlock;
+
+	shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &ldev->mode_flags);
+	fdb_sel_mode_native = test_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE,
+				       &ldev->mode_flags);
 
+unlock:
 	mutex_unlock(&ldev->lock);
 	if (!lag_active)
 		return -EINVAL;
 
 	seq_printf(file, "%s:%s\n", "shared_fdb", shared_fdb ? "on" : "off");
+	seq_printf(file, "%s:%s\n", "fdb_selection_mode",
+		   fdb_sel_mode_native ? "native" : "affinity");
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 2a8fc547eb37..a9b65dc47a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -68,14 +68,15 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, int mode,
 			       unsigned long flags)
 {
-	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
+	bool fdb_sel_mode = test_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE,
+				     &flags);
 	int port_sel_mode = get_port_sel_mode(mode, flags);
 	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
 	void *lag_ctx;
 
 	lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
 	MLX5_SET(create_lag_in, in, opcode, MLX5_CMD_OP_CREATE_LAG);
-	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, shared_fdb);
+	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, fdb_sel_mode);
 	if (port_sel_mode == MLX5_LAG_PORT_SELECT_MODE_QUEUE_AFFINITY) {
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
 		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
@@ -471,8 +472,13 @@ static int mlx5_lag_set_flags(struct mlx5_lag *ldev, enum mlx5_lag_mode mode,
 	bool roce_lag = mode == MLX5_LAG_MODE_ROCE;
 
 	*flags = 0;
-	if (shared_fdb)
+	if (shared_fdb) {
 		set_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, flags);
+		set_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE, flags);
+	}
+
+	if (mode == MLX5_LAG_MODE_MPESW)
+		set_bit(MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE, flags);
 
 	if (roce_lag)
 		return mlx5_lag_set_port_sel_mode_roce(ldev, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index c81b173156d2..71d2bb969544 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -24,6 +24,7 @@ enum {
 enum {
 	MLX5_LAG_MODE_FLAG_HASH_BASED,
 	MLX5_LAG_MODE_FLAG_SHARED_FDB,
+	MLX5_LAG_MODE_FLAG_FDB_SEL_MODE_NATIVE,
 };
 
 enum mlx5_lag_mode {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index ee4b25a50315..f643202b29c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -41,7 +41,6 @@ void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev)
 int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev = dev->priv.lag;
-	bool shared_fdb;
 	int err = 0;
 
 	if (!ldev)
@@ -55,8 +54,8 @@ int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
 		err = -EINVAL;
 		goto out;
 	}
-	shared_fdb = mlx5_shared_fdb_supported(ldev);
-	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, shared_fdb);
+
+	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
 	if (err)
 		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
 
-- 
2.36.1

