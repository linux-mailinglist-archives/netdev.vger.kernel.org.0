Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC59C5695D6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiGFXYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiGFXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7892C10A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADA761EBC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E35CC341C6;
        Wed,  6 Jul 2022 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149873;
        bh=dDXevZqMpRdcmE6HP493RikgC90mbqOZfdFiYvqe7/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdU1fRxbS2QIOJNVsGehzc3XletpOLk9QDFY83ntQA4fUvHN1K3KS2M5+7hSeX/Gi
         Aiex1y6YOO0UbNuG/YfPkovUDWr40kU8j/deVkc11oRyp7pWSIVimZkTfEW24++35/
         qoswD6/9e5dUK7PcQSpIr9LhigF/aCVBXEFRyOGjf5H57EEy/k/fIFUDNacq7XHgGd
         7qgHbvXtkjabdefmkcIxHdFIqX/a4oWiS8Egxu7RdcDnnxCyVgYmQV9ErbbwsD27qI
         LD3Rgx3XsNCAVvezElwyEA0iKkrj0XduNr+emtZ8ig2WA3vsA6eOcdMVlXj07YT1sD
         RaJGKqXJIkktA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Remove devl_unlock from mlx5_devlink_eswitch_mode_set
Date:   Wed,  6 Jul 2022 16:24:14 -0700
Message-Id: <20220706232421.41269-9-saeed@kernel.org>
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

The callback mlx5_devlink_eswitch_mode_set() had unlocked devlink as a
temporary workaround once devlink instance lock was added to devlink
eswitch callbacks. Now that all flows triggered by this function
that took devlink lock are using devl_ API and all parallel paths are
locked we can remove this workaround.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ccda3a0a2594..d3da52e3fc67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2177,10 +2177,8 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
-	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err, err1;
 
-	devl_lock(devlink);
 	esw->mode = MLX5_ESWITCH_OFFLOADS;
 	err = mlx5_eswitch_enable_locked(esw, esw->dev->priv.sriov.num_vfs);
 	if (err) {
@@ -2202,7 +2200,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 					   "Inline mode is different between vports");
 		}
 	}
-	devl_unlock(devlink);
 	return err;
 }
 
@@ -3243,10 +3240,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 static int esw_offloads_stop(struct mlx5_eswitch *esw,
 			     struct netlink_ext_ack *extack)
 {
-	struct devlink *devlink = priv_to_devlink(esw->dev);
 	int err, err1;
 
-	devl_lock(devlink);
 	esw->mode = MLX5_ESWITCH_LEGACY;
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err) {
@@ -3258,7 +3253,6 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 					   "Failed setting eswitch back to offloads");
 		}
 	}
-	devl_unlock(devlink);
 
 	return err;
 }
@@ -3366,15 +3360,6 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
-	/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
-	 * is never correct and prone to races. It's a transitional workaround,
-	 * never repeat this pattern.
-	 *
-	 * This code MUST be fixed before removing devlink_mutex as it is safe
-	 * to do only because of that mutex.
-	 */
-	devl_unlock(devlink);
-
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
@@ -3387,9 +3372,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
 
-	devl_lock(devlink);
 	mlx5_eswitch_disable_locked(esw);
-	devl_unlock(devlink);
 	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		if (mlx5_devlink_trap_get_num_active(esw->dev)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -3400,9 +3383,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = esw_offloads_start(esw, extack);
 	} else if (mode == DEVLINK_ESWITCH_MODE_LEGACY) {
 		err = esw_offloads_stop(esw, extack);
-		devl_lock(devlink);
 		mlx5_rescan_drivers(esw->dev);
-		devl_unlock(devlink);
 	} else {
 		err = -EINVAL;
 	}
@@ -3411,7 +3392,6 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	mlx5_esw_unlock(esw);
 enable_lag:
 	mlx5_lag_enable_change(esw->dev);
-	devl_lock(devlink);
 	return err;
 }
 
-- 
2.36.1

