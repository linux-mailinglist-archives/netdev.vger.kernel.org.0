Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311426EA143
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjDUBvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbjDUBvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C4E6E8F
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3564664C08
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2523BC433EF;
        Fri, 21 Apr 2023 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041898;
        bh=U+OtraWVtFjdO48dYGQc7Ln69uaRSvwBJv1iKwyxs5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMuO1joy3UkBeTUzcX1Hs2xwpii6kmcDOVJ/uhEjLh4dl86+rNYYJoevGXCoUzpjz
         DfnLTAeTWMPy6rvBjl32MsmeQ2CzvB5EFEuFcpcQ57V5gJw/qt0HNZIusoL+WmzhrD
         1Eo5Joho/AdU3a/GuBq6kje9s1oq9r4L7PffeQpJUdeecr/vUB3VvFw/dTusDFeykB
         xp6qJ/R4FBLFo1zQ/GDx0p1dNv5UVqUhkx/odG01KAsind/g2k2KL7Pmv/tQS/flmT
         +oXe0LYUKEAbP0rX27FWkywAcPC8RthvCxUMyuxiMIiYsEBFlaMkC79HWdTvru235e
         2EwaUsrTijt2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>
Subject: [net V2 08/10] net/mlx5: Use recovery timeout on sync reset flow
Date:   Thu, 20 Apr 2023 18:50:55 -0700
Message-Id: <20230421015057.355468-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421015057.355468-1-saeed@kernel.org>
References: <20230421015057.355468-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Use the same timeout for sync reset flow and health recovery flow, since
the former involves driver's recovery from firmware reset, which is
similar to health recovery. Otherwise, in some cases, such as a firmware
upgrade on the DPU, the firmware pre-init bit may not be ready within
current timeout and the driver will abort loading back after reset.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Fixes: 37ca95e62ee2 ("net/mlx5: Increase FW pre-init timeout for health recovery")
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c5d2fdcabd56..e5f03d071a37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -202,7 +202,7 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-		ret = mlx5_load_one_devl_locked(dev, false);
+		ret = mlx5_load_one_devl_locked(dev, true);
 		break;
 	default:
 		/* Unsupported action should not get to this function */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 289e915def98..50022e7565f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -167,7 +167,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
-			mlx5_load_one(dev, false);
+			mlx5_load_one(dev, true);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
@@ -499,7 +499,7 @@ int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 	err = fw_reset->ret;
 	if (test_and_clear_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags)) {
 		mlx5_unload_one_devl_locked(dev, false);
-		mlx5_load_one_devl_locked(dev, false);
+		mlx5_load_one_devl_locked(dev, true);
 	}
 out:
 	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
-- 
2.39.2

