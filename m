Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E61B5BDD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgDWM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:56:08 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57489 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728529AbgDWM4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:56:07 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Apr 2020 15:55:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03NCtw24003234;
        Thu, 23 Apr 2020 15:55:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V5 mlx5-next 14/16] net/mlx5: Add support to get lag physical port
Date:   Thu, 23 Apr 2020 15:55:53 +0300
Message-Id: <20200423125555.21759-15-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200423125555.21759-1-maorg@mellanox.com>
References: <20200423125555.21759-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function to get the device physical port of the lag slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 24 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 496a3408d771..5461fbe47c0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -710,6 +710,30 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_get_roce_netdev);
 
+u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
+			   struct net_device *slave)
+{
+	struct mlx5_lag *ldev;
+	u8 port = 0;
+
+	spin_lock(&lag_lock);
+	ldev = mlx5_lag_dev_get(dev);
+	if (!(ldev && __mlx5_lag_is_roce(ldev)))
+		goto unlock;
+
+	if (ldev->pf[MLX5_LAG_P1].netdev == slave)
+		port = MLX5_LAG_P1;
+	else
+		port = MLX5_LAG_P2;
+
+	port = ldev->v2p_map[port];
+
+unlock:
+	spin_unlock(&lag_lock);
+	return port;
+}
+EXPORT_SYMBOL(mlx5_lag_get_slave_port);
+
 bool mlx5_lag_intf_add(struct mlx5_interface *intf, struct mlx5_priv *priv)
 {
 	struct mlx5_core_dev *dev = container_of(priv, struct mlx5_core_dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6f8f79ef829b..7b81b512d116 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1062,6 +1062,8 @@ bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
+u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
+			   struct net_device *slave);
 int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 u64 *values,
 				 int num_counters,
-- 
2.17.2

