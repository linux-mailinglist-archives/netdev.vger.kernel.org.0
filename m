Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154C12F918F
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 10:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhAQJ1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 04:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbhAQJ1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 04:27:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 200C8225AB;
        Sun, 17 Jan 2021 09:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610875597;
        bh=AtBxoI86DOB/UKR0rgAMcvsjuL2mPJ205h5Yjr7Yzq8=;
        h=From:To:Cc:Subject:Date:From;
        b=FTi5sH6x6AlZHw0CSHueVrRQcrGnjgyOUb68cvMFKhHxWe3X/iGzVs3MhaVFex4Dk
         KZTsirWgZ3CJvh5yK2mS/iSJ7teMIBegXAERygIYYFKkDEzUohfoFnyioW5Bhxv/3z
         khWWg+NA5f6PaiABP4em8MC/KEkb4cRUmYVpN2CYe12mMoCvjuozgAc+GAjr8siClC
         /t+5X59mF1CA/wR8v6ErceLjjoE3AY4T8+xSqP2mFdPLEHO9Wlg7X1vIQQ77Fuly5F
         jo8BjQ5uKHWpo95Pn9DgIDzfHfFo97o/1UCx01nLgOF8uDaH2/tRByXQ0a+uhGVxUw
         wyEL7WjDrTk4w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-rc] Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"
Date:   Sun, 17 Jan 2021 11:26:33 +0200
Message-Id: <20210117092633.10690-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

This reverts commit fbdd0049d98d44914fc57d4b91f867f4996c787b.

Due to commit in fixes tag, netdevice events were received only
in one net namespace of mlx5_core_dev. Due to this when netdevice
events arrive in net namespace other than net namespace of mlx5_core_dev,
they are missed.

This results in empty GID table due to RDMA device being detached from
its net device.

Hence, revert back to receive netdevice events in all net namespaces to
restore back RDMA functionality in non init_net net namespace.

Fixes: fbdd0049d98d ("RDMA/mlx5: Fix devlink deadlock on net namespace deletion")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c              |  6 ++----
 .../net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 +++++
 include/linux/mlx5/driver.h                    | 18 ------------------
 3 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ed13c1bb031e..36f8ae4fe619 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3335,8 +3335,7 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 	int err;

 	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
-					      &dev->port[port_num].roce.nb);
+	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
 	if (err) {
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 		return err;
@@ -3348,8 +3347,7 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
-						  &dev->port[port_num].roce.nb);
+		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 3a9fa629503f..d046db7bb047 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -90,4 +90,9 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);

+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4901b4fadabb..c4939b28ceed 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1210,22 +1210,4 @@ static inline bool mlx5_is_roce_enabled(struct mlx5_core_dev *dev)
 	return val.vbool;
 }

-/**
- * mlx5_core_net - Provide net namespace of the mlx5_core_dev
- * @dev: mlx5 core device
- *
- * mlx5_core_net() returns the net namespace of mlx5 core device.
- * This can be called only in below described limited context.
- * (a) When a devlink instance for mlx5_core is registered and
- *     when devlink reload operation is disabled.
- *     or
- * (b) during devlink reload reload_down() and reload_up callbacks
- *     where it is ensured that devlink instance's net namespace is
- *     stable.
- */
-static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-{
-	return devlink_net(priv_to_devlink(dev));
-}
-
 #endif /* MLX5_DRIVER_H */
--
2.29.2

