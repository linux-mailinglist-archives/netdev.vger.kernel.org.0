Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B220D1AFAC3
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgDSNkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 09:40:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37192 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbgDSNkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 09:40:09 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Apr 2020 16:40:04 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03JDe3Xr019088;
        Sun, 19 Apr 2020 16:40:03 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 6/9] net/mlx5: Change lag mutex lock to spin lock
Date:   Sun, 19 Apr 2020 16:39:30 +0300
Message-Id: <20200419133933.28258-7-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200419133933.28258-1-maorg@mellanox.com>
References: <20200419133933.28258-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lag lock could be a mutex, the critical section is short
and there is no need that the thread will sleep.
Change the lock that protects the LAG structure from mutex
to spin lock. It is required for next patch that need to
access this structure from context that we can't sleep.
In addition there is no need to hold this lock when query the
congestion counters.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 42 +++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 93052b07c76c..496a3408d771 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -42,7 +42,7 @@
  * Beware of lock dependencies (preferably, no locks should be acquired
  * under it).
  */
-static DEFINE_MUTEX(lag_mutex);
+static DEFINE_SPINLOCK(lag_lock);
 
 static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 			       u8 remap_port2)
@@ -297,9 +297,9 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	if (!dev0 || !dev1)
 		return;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	tracker = ldev->tracker;
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
 
@@ -481,9 +481,9 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 		break;
 	}
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev->tracker = tracker;
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	if (changed)
 		mlx5_queue_bond_work(ldev, 0);
@@ -525,7 +525,7 @@ static void mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
 	if (fn >= MLX5_MAX_PORTS)
 		return;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev->pf[fn].dev    = dev;
 	ldev->pf[fn].netdev = netdev;
 	ldev->tracker.netdev_state[fn].link_up = 0;
@@ -533,7 +533,7 @@ static void mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
 
 	dev->priv.lag = ldev;
 
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 }
 
 static void mlx5_lag_dev_remove_pf(struct mlx5_lag *ldev,
@@ -548,11 +548,11 @@ static void mlx5_lag_dev_remove_pf(struct mlx5_lag *ldev,
 	if (i == MLX5_MAX_PORTS)
 		return;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	memset(&ldev->pf[i], 0, sizeof(*ldev->pf));
 
 	dev->priv.lag = NULL;
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 }
 
 /* Must be called with intf_mutex held */
@@ -630,10 +630,10 @@ bool mlx5_lag_is_roce(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 	bool res;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
 	res  = ldev && __mlx5_lag_is_roce(ldev);
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	return res;
 }
@@ -644,10 +644,10 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 	bool res;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
 	res  = ldev && __mlx5_lag_is_active(ldev);
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	return res;
 }
@@ -658,10 +658,10 @@ bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev;
 	bool res;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
 	res  = ldev && __mlx5_lag_is_sriov(ldev);
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	return res;
 }
@@ -687,7 +687,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 	struct net_device *ndev = NULL;
 	struct mlx5_lag *ldev;
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
 
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
@@ -704,7 +704,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 		dev_hold(ndev);
 
 unlock:
-	mutex_unlock(&lag_mutex);
+	spin_unlock(&lag_lock);
 
 	return ndev;
 }
@@ -746,7 +746,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 
 	memset(values, 0, sizeof(*values) * num_counters);
 
-	mutex_lock(&lag_mutex);
+	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev_get(dev);
 	if (ldev && __mlx5_lag_is_roce(ldev)) {
 		num_ports = MLX5_MAX_PORTS;
@@ -756,18 +756,18 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 		num_ports = 1;
 		mdev[MLX5_LAG_P1] = dev;
 	}
+	spin_unlock(&lag_lock);
 
 	for (i = 0; i < num_ports; ++i) {
 		ret = mlx5_cmd_query_cong_counter(mdev[i], false, out, outlen);
 		if (ret)
-			goto unlock;
+			goto free;
 
 		for (j = 0; j < num_counters; ++j)
 			values[j] += be64_to_cpup((__be64 *)(out + offsets[j]));
 	}
 
-unlock:
-	mutex_unlock(&lag_mutex);
+free:
 	kvfree(out);
 	return ret;
 }
-- 
2.17.2

