Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712B5695C6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiGFXY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGFXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29872BB29
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4131B61EB4
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0AFC341C6;
        Wed,  6 Jul 2022 23:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149865;
        bh=6i1SyttgMc5FbATXnrGso04gRH6QEJ/H+4lYfPA3TUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3ksOT9hNzIM3CAt3Yai8ueLJeK4MNx1KPzCy9dXxpwUnJ1WMWa5clXIUTC6IH8yW
         kiORWKFPafnfZ7sNtxcSv+itREvxJRHrATAPD4J7JHNpRj0+Jrk9zmrq3kHnux+b2r
         A8aqNOaCOgzK2kd/VLUGfZTeqrKXILzUjbojedkRq69TEcR+H9u9gMcB/nvKQ+xjFS
         zlHniEQp0XMPB7866j7v0HO7Fb50N8VPV98Ya4huTfqGDgUwkxTF+slzh65PT1SV5c
         oQn7N9KdC1mgemODbTtmm/3nGDrkTMsT0aYW2w1F5Q0Ywt4qpQDs/Iox8ssrlk3mi/
         tYQOSGEk1OY1g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Remove devl_unlock from mlx5_eswtich_mode_callback_enter
Date:   Wed,  6 Jul 2022 16:24:07 -0700
Message-Id: <20220706232421.41269-2-saeed@kernel.org>
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

The function mlx5_eswtich_mode_callback_enter() was added as a temporary
workaround once devlink instance lock was added to devlink eswitch
callbacks. However, code review and testing show that all the callbacks
part to eswitch_mode_set don't take devlink instance lock in any flow
and so unlocking devlink instance lock while entering these functions is
not needed.

Remove devl_lock from mlx5_eswtich_mode_callback_enter() and devl_unlock
from mlx5_eswtich_mode_callback_exit(). Also remove the functions
mlx5_eswtich_mode_callback_enter()/exit() as they are not needed any
more. The callback eswitch_mode_set will be treated separately in the
following patches.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 43 +++++--------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e224ec7005a6..3bd843e6d66a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3342,27 +3342,6 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
- * is never correct and prone to races. It's a transitional workaround,
- * never repeat this pattern.
- *
- * This code MUST be fixed before removing devlink_mutex as it is safe
- * to do only because of that mutex.
- */
-static void mlx5_eswtich_mode_callback_enter(struct devlink *devlink,
-					     struct mlx5_eswitch *esw)
-{
-	devl_unlock(devlink);
-	down_write(&esw->mode_lock);
-}
-
-static void mlx5_eswtich_mode_callback_exit(struct devlink *devlink,
-					    struct mlx5_eswitch *esw)
-{
-	up_write(&esw->mode_lock);
-	devl_lock(devlink);
-}
-
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3431,9 +3410,9 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mlx5_eswtich_mode_callback_enter(devlink, esw);
+	down_write(&esw->mode_lock);
 	err = esw_mode_to_devlink(esw->mode, mode);
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3480,7 +3459,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mlx5_eswtich_mode_callback_enter(devlink, esw);
+	down_write(&esw->mode_lock);
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
@@ -3514,11 +3493,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 		goto out;
 
 	esw->offloads.inline_mode = mlx5_mode;
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return 0;
 
 out:
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3531,9 +3510,9 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mlx5_eswtich_mode_callback_enter(devlink, esw);
+	down_write(&esw->mode_lock);
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3549,7 +3528,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mlx5_eswtich_mode_callback_enter(devlink, esw);
+	down_write(&esw->mode_lock);
 
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
@@ -3592,7 +3571,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	}
 
 unlock:
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3605,9 +3584,9 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mlx5_eswtich_mode_callback_enter(devlink, esw);
+	down_write(&esw->mode_lock);
 	*encap = esw->offloads.encap;
-	mlx5_eswtich_mode_callback_exit(devlink, esw);
+	up_write(&esw->mode_lock);
 	return 0;
 }
 
-- 
2.36.1

