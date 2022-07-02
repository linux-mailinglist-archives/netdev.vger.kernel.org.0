Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC218564258
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiGBTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiGBTEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF6FE006
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF3B0B808C5
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E60C341CF;
        Sat,  2 Jul 2022 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788666;
        bh=Iblp5uu0qeSv502cn/yZkpeExuwf7KWiWiDnKUkctW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaYAmbhR/qzz6UI79GudhoD9BBwEht9/lrQF2j1QVLzYTKwqn7oxkuTqcV+LGuePD
         bv1r0LHGLGiUIi9ehlLwxVptda7il0R5Eq0MIZbxPriYXs/egkxlGpIf/LvcSw2dav
         QwHZkH9wy9iJqd/oq87kOQ98OIGfvk5cvqDBhpB8NYQe3031NuQ5gaNcksiA7VCMxu
         5bKsbo+uSsEOU6xi1yXaYiSJXyW39yqUm2qGosURB+k3T11OcKhJZPMCXb6nf/ex8M
         MpCCEqrEmdwFeNNi5zkQgUnpwgGsIvsNxBGvBgmSlbmNQBWDDbWiWnQ2OyXew8VboE
         dsjFxfYpFLKtA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Chris Mi <cmi@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next v2 06/15] net/mlx5: E-switch: Change eswitch mode only via devlink command
Date:   Sat,  2 Jul 2022 12:02:04 -0700
Message-Id: <20220702190213.80858-7-saeed@kernel.org>
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

Enable or disable switchdev according to the eswitch mode set by
devlink command. So it is not changed by other functions anymore.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c  | 18 +++++-------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c      | 17 +++++++++--------
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 82b62ab1d1d9..b938632f89ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1227,7 +1227,6 @@ static void mlx5_esw_acls_ns_cleanup(struct mlx5_eswitch *esw)
 /**
  * mlx5_eswitch_enable_locked - Enable eswitch
  * @esw:	Pointer to eswitch
- * @mode:	Eswitch mode to enable
  * @num_vfs:	Enable eswitch for given number of VFs. This is optional.
  *		Valid value are 0, > 0 and MLX5_ESWITCH_IGNORE_NUM_VFS.
  *		Caller should pass num_vfs > 0 when enabling eswitch for
@@ -1241,7 +1240,7 @@ static void mlx5_esw_acls_ns_cleanup(struct mlx5_eswitch *esw)
  * mode. If num_vfs >=0 is provided, it setup VF related eswitch vports.
  * It returns 0 on success or error code on failure.
  */
-int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
+int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
 {
 	int err;
 
@@ -1260,9 +1259,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 
 	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
 
-	esw->mode = mode;
-
-	if (mode == MLX5_ESWITCH_LEGACY) {
+	if (esw->mode == MLX5_ESWITCH_LEGACY) {
 		err = esw_legacy_enable(esw);
 	} else {
 		mlx5_rescan_drivers(esw->dev);
@@ -1277,19 +1274,14 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 	mlx5_eswitch_event_handlers_register(esw);
 
 	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), active vports(%d)\n",
-		 mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
+		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
-	mlx5_esw_mode_change_notify(esw, mode);
+	mlx5_esw_mode_change_notify(esw, esw->mode);
 
 	return 0;
 
 abort:
-	esw->mode = MLX5_ESWITCH_LEGACY;
-
-	if (mode == MLX5_ESWITCH_OFFLOADS)
-		mlx5_rescan_drivers(esw->dev);
-
 	mlx5_esw_acls_ns_cleanup(esw);
 	return err;
 }
@@ -1317,7 +1309,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 
 	down_write(&esw->mode_lock);
 	if (!mlx5_esw_is_fdb_created(esw)) {
-		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
+		ret = mlx5_eswitch_enable_locked(esw, num_vfs);
 	} else {
 		enum mlx5_eswitch_vport_event vport_events;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 5452437e531f..c19604b06a2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -356,7 +356,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
 
 #define MLX5_ESWITCH_IGNORE_NUM_VFS (-1)
-int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs);
+int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs);
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs);
 void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf);
 void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7c51011aed2b..e224ec7005a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2179,17 +2179,18 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
-					 esw->dev->priv.sriov.num_vfs);
+	esw->mode = MLX5_ESWITCH_OFFLOADS;
+	err = mlx5_eswitch_enable_locked(esw, esw->dev->priv.sriov.num_vfs);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed setting eswitch to offloads");
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY,
-						  MLX5_ESWITCH_IGNORE_NUM_VFS);
+		esw->mode = MLX5_ESWITCH_LEGACY;
+		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to legacy");
 		}
+		mlx5_rescan_drivers(esw->dev);
 	}
 	if (esw->offloads.inline_mode == MLX5_INLINE_MODE_NONE) {
 		if (mlx5_eswitch_inline_mode_get(esw,
@@ -3237,12 +3238,12 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 {
 	int err, err1;
 
-	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY,
-					 MLX5_ESWITCH_IGNORE_NUM_VFS);
+	esw->mode = MLX5_ESWITCH_LEGACY;
+	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_OFFLOADS,
-						  MLX5_ESWITCH_IGNORE_NUM_VFS);
+		esw->mode = MLX5_ESWITCH_OFFLOADS;
+		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 		if (err1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Failed setting eswitch back to offloads");
-- 
2.36.1

