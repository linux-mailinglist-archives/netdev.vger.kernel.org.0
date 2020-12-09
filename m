Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4362D42A9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbgLINFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:23 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58183 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732006AbgLINFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:14 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 9 Dec 2020 15:04:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B9D4KeJ022609;
        Wed, 9 Dec 2020 15:04:21 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 1/2] net/mlx4_en: Avoid scheduling restart task if it is already running
Date:   Wed,  9 Dec 2020 15:03:38 +0200
Message-Id: <20201209130339.21795-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201209130339.21795-1-tariqt@nvidia.com>
References: <20201209130339.21795-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Add restarting state flag to avoid scheduling another restart task while
such task is already running. Change task name from watchdog_task to
restart_task to better fit the task role.

Fixes: 1e338db56e5a ("mlx4_en: Fix a race at restart task")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 20 ++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  7 ++++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 106513f772c3..1a2b0bd64aa9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1378,8 +1378,10 @@ static void mlx4_en_tx_timeout(struct net_device *dev, unsigned int txqueue)
 		tx_ring->cons, tx_ring->prod);
 
 	priv->port_stats.tx_timeout++;
-	en_dbg(DRV, priv, "Scheduling watchdog\n");
-	queue_work(mdev->workqueue, &priv->watchdog_task);
+	if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state)) {
+		en_dbg(DRV, priv, "Scheduling port restart\n");
+		queue_work(mdev->workqueue, &priv->restart_task);
+	}
 }
 
 
@@ -1829,6 +1831,7 @@ int mlx4_en_start_port(struct net_device *dev)
 		local_bh_enable();
 	}
 
+	clear_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state);
 	netif_tx_start_all_queues(dev);
 	netif_device_attach(dev);
 
@@ -1999,7 +2002,7 @@ void mlx4_en_stop_port(struct net_device *dev, int detach)
 static void mlx4_en_restart(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
-						 watchdog_task);
+						 restart_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct net_device *dev = priv->dev;
 
@@ -2377,7 +2380,7 @@ static int mlx4_en_change_mtu(struct net_device *dev, int new_mtu)
 	if (netif_running(dev)) {
 		mutex_lock(&mdev->state_lock);
 		if (!mdev->device_up) {
-			/* NIC is probably restarting - let watchdog task reset
+			/* NIC is probably restarting - let restart task reset
 			 * the port */
 			en_dbg(DRV, priv, "Change MTU called with card down!?\n");
 		} else {
@@ -2386,7 +2389,9 @@ static int mlx4_en_change_mtu(struct net_device *dev, int new_mtu)
 			if (err) {
 				en_err(priv, "Failed restarting port:%d\n",
 					 priv->port);
-				queue_work(mdev->workqueue, &priv->watchdog_task);
+				if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING,
+						      &priv->state))
+					queue_work(mdev->workqueue, &priv->restart_task);
 			}
 		}
 		mutex_unlock(&mdev->state_lock);
@@ -2792,7 +2797,8 @@ static int mlx4_xdp_set(struct net_device *dev, struct bpf_prog *prog)
 		if (err) {
 			en_err(priv, "Failed starting port %d for XDP change\n",
 			       priv->port);
-			queue_work(mdev->workqueue, &priv->watchdog_task);
+			if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state))
+				queue_work(mdev->workqueue, &priv->restart_task);
 		}
 	}
 
@@ -3165,7 +3171,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	priv->counter_index = MLX4_SINK_COUNTER_INDEX(mdev->dev);
 	spin_lock_init(&priv->stats_lock);
 	INIT_WORK(&priv->rx_mode_task, mlx4_en_do_set_rx_mode);
-	INIT_WORK(&priv->watchdog_task, mlx4_en_restart);
+	INIT_WORK(&priv->restart_task, mlx4_en_restart);
 	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index a46efe37cfa9..fd9535bde1b8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -530,6 +530,10 @@ struct mlx4_en_stats_bitmap {
 	struct mutex mutex; /* for mutual access to stats bitmap */
 };
 
+enum {
+	MLX4_EN_STATE_FLAG_RESTARTING,
+};
+
 struct mlx4_en_priv {
 	struct mlx4_en_dev *mdev;
 	struct mlx4_en_port_profile *prof;
@@ -595,7 +599,7 @@ struct mlx4_en_priv {
 	struct mlx4_en_cq *rx_cq[MAX_RX_RINGS];
 	struct mlx4_qp drop_qp;
 	struct work_struct rx_mode_task;
-	struct work_struct watchdog_task;
+	struct work_struct restart_task;
 	struct work_struct linkstate_task;
 	struct delayed_work stats_task;
 	struct delayed_work service_task;
@@ -641,6 +645,7 @@ struct mlx4_en_priv {
 	u32 pflags;
 	u8 rss_key[MLX4_EN_RSS_KEY_SIZE];
 	u8 rss_hash_fn;
+	unsigned long state;
 };
 
 enum mlx4_en_wol {
-- 
2.21.0

