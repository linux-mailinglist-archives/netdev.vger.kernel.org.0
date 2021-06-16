Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8173AA6BA
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhFPWmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234022AbhFPWmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0617613F8;
        Wed, 16 Jun 2021 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883230;
        bh=6PlaYnPx3Kaq07vhfEPukdxlzlS1mhN3U7Xev077HKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr1r+yB+5GuoRpirGLC0JuemeznBjAJF9vVdm+JkS/wK8i9mabwJuj4XvmT1YcntJ
         VPbelZX28wWO9teIbrXv8JTXZK3ZdcM1IcLEjlDn2RSTI63IYlNHbWz6oE4m97VMxq
         PgE+gDtCpEMKmwdTB4ZPUCUBRNnLuR8IBngOm/rI6/frshfGP42Hsqpe10fwq0E7R+
         q+h4a+xuJlsmn1HEmZgNeELz/HOMEpTzc5IZN040xvP5ME4Jkdswf1iqraHk6mD/2r
         rZ0ew2DSzfp63ez5TZkeljnD5jcfl8jRJPerfvR1KiKa9rb6YDv+3LHxGOf1cyN3pV
         01MY55+Brc7Cw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/8] net/mlx5e: Don't create devices during unload flow
Date:   Wed, 16 Jun 2021 15:40:14 -0700
Message-Id: <20210616224015.14393-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Running devlink reload command for port in switchdev mode cause
resources to corrupt: driver can't release allocated EQ and reclaim
memory pages, because "rdma" auxiliary device had add CQs which blocks
EQ from deletion.
Erroneous sequence happens during reload-down phase, and is following:

1. detach device - suspends auxiliary devices which support it, destroys
   others. During this step "eth-rep" and "rdma-rep" are destroyed,
   "eth" - suspended.
2. disable SRIOV - moves device to legacy mode; as part of disablement -
   rescans drivers. This step adds "rdma" auxiliary device.
3. destroy EQ table - <failure>.

Driver shouldn't create any device during unload flows. To handle that
implement MLX5_PRIV_FLAGS_DETACH flag, set it on device detach and unset
on device attach. If flag is set do no-op on drivers rescan.

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 4 ++++
 include/linux/mlx5/driver.h                   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 8de118adfb54..ceebfc20f65e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -303,6 +303,7 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 	int ret = 0, i;
 
 	mutex_lock(&mlx5_intf_mutex);
+	priv->flags &= ~MLX5_PRIV_FLAGS_DETACH;
 	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
 		if (!priv->adev[i]) {
 			bool is_supported = false;
@@ -375,6 +376,7 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
+	priv->flags |= MLX5_PRIV_FLAGS_DETACH;
 	mutex_unlock(&mlx5_intf_mutex);
 }
 
@@ -463,6 +465,8 @@ int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 	struct mlx5_priv *priv = &dev->priv;
 
 	lockdep_assert_held(&mlx5_intf_mutex);
+	if (priv->flags & MLX5_PRIV_FLAGS_DETACH)
+		return 0;
 
 	delete_drivers(dev);
 	if (priv->flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 020a8f7fdbdd..f8902bcd91e2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -542,6 +542,10 @@ struct mlx5_core_roce {
 enum {
 	MLX5_PRIV_FLAGS_DISABLE_IB_ADEV = 1 << 0,
 	MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV = 1 << 1,
+	/* Set during device detach to block any further devices
+	 * creation/deletion on drivers rescan. Unset during device attach.
+	 */
+	MLX5_PRIV_FLAGS_DETACH = 1 << 2,
 };
 
 struct mlx5_adev {
-- 
2.31.1

