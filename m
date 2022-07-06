Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE05695C8
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiGFXYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiGFXYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A062BB37
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A061BB81EFB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F972C3411C;
        Wed,  6 Jul 2022 23:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149868;
        bh=kB3a+lgQZaExOGuprV+qJttZlO7TtQuEhSjvgosdyvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ohew4vMOJX9NSXndDrPdHHpUbG+xvfLvybQoQdioqmYziXDZbwdJQ46A36b+2E9lu
         +fdxPxYdiH+6vYD4zpqJwubTCCQ4FWOi0WLdJ+bWrYO2USA1x52/BuRO6r7mnJ0cUT
         sYCHjVNA+6oF/pX5SyzsUKPFG0TJjsVr9IMhEIQjNsxQ+lwcVHVV/RrHMtn8iUQ4aP
         AX1OhMnMKmhB+k/4WRY9KD/A5fCowIFCQq6a6T5fnII7UkTRLA0nyiWqBTWGzHiZVn
         0obCHfsqS7GzucR8/gxvM4zWdj7lsSFdNhEju52MA7pvFDgxP5QrKNqbsQL0f7njA0
         4LY9gqGoJB7JA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register
Date:   Wed,  6 Jul 2022 16:24:10 -0700
Message-Id: <20220706232421.41269-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

The function mlx5_esw_offloads_devlink_port_register() calls
devlink_port_register() and devlink_rate_leaf_create(). Use devl_ API to
call devl_port_register() and devl_rate_leaf_create() accordingly and
add devlink instance lock in driver paths to this function.

Similarly, use devl_ API to call devl_port_unregister() and
devl_rate_leaf_destroy() in mlx5_esw_offloads_devlink_port_unregister()
and ensure locking devlink instance lock on the paths to this function
too.

This will be used by the downstream patch to invoke
mlx5_devlink_eswitch_mode_set() with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c      |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 ++++++++++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 7f9b96d9537e..a8f7618831f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -87,11 +87,11 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
-	err = devlink_port_register(devlink, dl_port, dl_port_index);
+	err = devl_port_register(devlink, dl_port, dl_port_index);
 	if (err)
 		goto reg_err;
 
-	err = devlink_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport);
 	if (err)
 		goto rate_err;
 
@@ -99,7 +99,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	return 0;
 
 rate_err:
-	devlink_port_unregister(dl_port);
+	devl_port_unregister(dl_port);
 reg_err:
 	mlx5_esw_dl_port_free(dl_port);
 	return err;
@@ -118,10 +118,10 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 
 	if (vport->dl_port->devlink_rate) {
 		mlx5_esw_qos_vport_update_group(esw, vport, NULL, NULL);
-		devlink_rate_leaf_destroy(vport->dl_port);
+		devl_rate_leaf_destroy(vport->dl_port);
 	}
 
-	devlink_port_unregister(vport->dl_port);
+	devl_port_unregister(vport->dl_port);
 	mlx5_esw_dl_port_free(vport->dl_port);
 	vport->dl_port = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 571114e4878f..b95f75431882 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1296,6 +1296,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
  */
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
+	struct devlink *devlink;
 	bool toggle_lag;
 	int ret;
 
@@ -1307,6 +1308,8 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	if (toggle_lag)
 		mlx5_lag_disable_change(esw->dev);
 
+	devlink = priv_to_devlink(esw->dev);
+	devl_lock(devlink);
 	down_write(&esw->mode_lock);
 	if (!mlx5_esw_is_fdb_created(esw)) {
 		ret = mlx5_eswitch_enable_locked(esw, num_vfs);
@@ -1320,6 +1323,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
 	up_write(&esw->mode_lock);
+	devl_unlock(devlink);
 
 	if (toggle_lag)
 		mlx5_lag_enable_change(esw->dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f1640e4cb719..1bfbc88f513f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2177,8 +2177,10 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err, err1;
 
+	devl_lock(devlink);
 	esw->mode = MLX5_ESWITCH_OFFLOADS;
 	err = mlx5_eswitch_enable_locked(esw, esw->dev->priv.sriov.num_vfs);
 	if (err) {
@@ -2200,6 +2202,7 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 					   "Inline mode is different between vports");
 		}
 	}
+	devl_unlock(devlink);
 	return err;
 }
 
@@ -3064,6 +3067,7 @@ static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 static void
 esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 {
+	struct devlink *devlink;
 	bool host_pf_disabled;
 	u16 new_num_vfs;
 
@@ -3075,6 +3079,8 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 	if (new_num_vfs == esw->esw_funcs.num_vfs || host_pf_disabled)
 		return;
 
+	devlink = priv_to_devlink(esw->dev);
+	devl_lock(devlink);
 	/* Number of VFs can only change from "0 to x" or "x to 0". */
 	if (esw->esw_funcs.num_vfs > 0) {
 		mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
@@ -3087,6 +3093,7 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 			return;
 	}
 	esw->esw_funcs.num_vfs = new_num_vfs;
+	devl_unlock(devlink);
 }
 
 static void esw_functions_changed_event_handler(struct work_struct *work)
@@ -3236,8 +3243,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 static int esw_offloads_stop(struct mlx5_eswitch *esw,
 			     struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err, err1;
 
+	devl_lock(devlink);
 	esw->mode = MLX5_ESWITCH_LEGACY;
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
@@ -3249,6 +3258,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 					   "Failed setting eswitch back to offloads");
 		}
 	}
+	devl_unlock(devlink);
 
 	return err;
 }
-- 
2.36.1

