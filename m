Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381A856D77D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiGKIOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGKIOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9CB7FD
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3690260F58
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF4C341C0;
        Mon, 11 Jul 2022 08:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527254;
        bh=6i1SyttgMc5FbATXnrGso04gRH6QEJ/H+4lYfPA3TUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNpjEkBW8S+kgOCXGPNbxsLX0W6GPy1jhjKJaLV9p7WkQikg5f70Nzy89hU97hycp
         Dw57gEunVtoGdfjCBAnOhhUaPbuf3s41MKDem5/7yVX8MCrlNxXvWj83zhCRnriGgk
         MDHyGlM+cJ5kfhYVPkWWE+lDHLl9A6iHQsBMKyIJOiSHlC0zoe11cgNuxu4qs5HtdD
         Xe8Einkf3XqKN+/4ogUvXXyIZH7zU8HB2A4CAaA/nCuA0qbNycJEG8k+HKGzlw75rl
         zv5ETyCK0l/3PQi2zWmhbucH8p7OpxOpuTCReN8oFdzzXMHQzx6WOvHsK2uH/fHdzS
         6SxNc07PqsJFw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 1/9] net/mlx5: Remove devl_unlock from mlx5_eswtich_mode_callback_enter
Date:   Mon, 11 Jul 2022 01:14:00 -0700
Message-Id: <20220711081408.69452-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
References: <20220711081408.69452-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

