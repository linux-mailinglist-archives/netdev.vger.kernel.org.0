Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AC626B03E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgIOWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233102193E;
        Tue, 15 Sep 2020 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201558;
        bh=Qm3l8yQ0OD8GhTIoECQ0am40hEd2UFkbvRqIbWs+aew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJuBXH9bvcoFCIlUDgbkVqGdWAckAVmesbWYiJCDMAfROo9Nw8kSjHU4Odx3cTp7O
         cLgAQHS4115tTjMOtjcEa6YvQRzRjFuvWhtELYWJcgLABfl34oBOudLN7qIXDbWk9K
         TVQVYa0xjt9JBBjDF4hCpZtzv5bw+QbyQWCVDOew=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Raed Salem <raeds@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5e: Add LAG warning if bond slave is not lag master
Date:   Tue, 15 Sep 2020 13:25:26 -0700
Message-Id: <20200915202533.64389-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

LAG offload can't be enabled if the enslaved PF is not lag master,
which is indicated by HCA capabilities bit. It is cleared if more than
64 VFs are configured for this PF.

Previously, a data structure is created to store lag info, including
PFs to be enslaved, then a handler is registered for netdev notifier.
However, this initialization is skipped if PF is not lag master. So
PF can't handle CHANGEUPPER event from upper bond device. Even worse,
PF is enslaved silently, and LAG offload is not activated.

Fix this by registering netdev notifier for PFs which are not lag
masters. When CHANGEUPPER event is received, and both physical ports
(and only them) on the same NIC are about to be enslaved, a warning is
returned for user to know it.

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 43 ++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |  7 +++
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  2 +-
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 191d3d5be46d..33081b24f10a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -271,7 +271,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	bool do_bond, roce_lag;
 	int err;
 
-	if (!dev0 || !dev1)
+	if (!mlx5_lag_is_ready(ldev))
 		return;
 
 	spin_lock(&lag_lock);
@@ -394,6 +394,12 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	 */
 	is_in_lag = num_slaves == MLX5_MAX_PORTS && bond_status == 0x3;
 
+	if (!mlx5_lag_is_ready(ldev) && is_in_lag) {
+		NL_SET_ERR_MSG_MOD(info->info.extack,
+				   "Can't activate LAG offload, PF is configured with more than 64 VFs");
+		return 0;
+	}
+
 	/* Lag mode must be activebackup or hash. */
 	mode_supported = tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP ||
 			 tracker->tx_type == NETDEV_LAG_TX_TYPE_HASH;
@@ -450,6 +456,10 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 		return NOTIFY_DONE;
 
 	ldev    = container_of(this, struct mlx5_lag, nb);
+
+	if (!mlx5_lag_is_ready(ldev) && event == NETDEV_CHANGELOWERSTATE)
+		return NOTIFY_DONE;
+
 	tracker = ldev->tracker;
 
 	switch (event) {
@@ -498,14 +508,14 @@ static void mlx5_lag_dev_free(struct mlx5_lag *ldev)
 	kfree(ldev);
 }
 
-static void mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
-				struct mlx5_core_dev *dev,
-				struct net_device *netdev)
+static int mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
+			       struct mlx5_core_dev *dev,
+			       struct net_device *netdev)
 {
 	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
 
 	if (fn >= MLX5_MAX_PORTS)
-		return;
+		return -EPERM;
 
 	spin_lock(&lag_lock);
 	ldev->pf[fn].dev    = dev;
@@ -516,6 +526,8 @@ static void mlx5_lag_dev_add_pf(struct mlx5_lag *ldev,
 	dev->priv.lag = ldev;
 
 	spin_unlock(&lag_lock);
+
+	return fn;
 }
 
 static void mlx5_lag_dev_remove_pf(struct mlx5_lag *ldev,
@@ -542,11 +554,9 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 {
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
-	int err;
+	int i, err;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
-	    !MLX5_CAP_GEN(dev, lag_master) ||
-	    (MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS))
+	if (!MLX5_CAP_GEN(dev, vport_group_manager))
 		return;
 
 	tmp_dev = mlx5_get_next_phys_dev(dev);
@@ -561,7 +571,18 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 		}
 	}
 
-	mlx5_lag_dev_add_pf(ldev, dev, netdev);
+	if (mlx5_lag_dev_add_pf(ldev, dev, netdev) < 0)
+		return;
+
+	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		tmp_dev = ldev->pf[i].dev;
+		if (!tmp_dev || !MLX5_CAP_GEN(tmp_dev, lag_master) ||
+		    MLX5_CAP_GEN(tmp_dev, num_lag_ports) != MLX5_MAX_PORTS)
+			break;
+	}
+
+	if (i >= MLX5_MAX_PORTS)
+		ldev->flags |= MLX5_LAG_FLAG_READY;
 
 	if (!ldev->nb.notifier_call) {
 		ldev->nb.notifier_call = mlx5_lag_netdev_event;
@@ -592,6 +613,8 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
 
 	mlx5_lag_dev_remove_pf(ldev, dev);
 
+	ldev->flags &= ~MLX5_LAG_FLAG_READY;
+
 	for (i = 0; i < MLX5_MAX_PORTS; i++)
 		if (ldev->pf[i].dev)
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index f1068aac6406..8d8cf2d0bc6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -16,6 +16,7 @@ enum {
 	MLX5_LAG_FLAG_ROCE   = 1 << 0,
 	MLX5_LAG_FLAG_SRIOV  = 1 << 1,
 	MLX5_LAG_FLAG_MULTIPATH = 1 << 2,
+	MLX5_LAG_FLAG_READY = 1 << 3,
 };
 
 #define MLX5_LAG_MODE_FLAGS (MLX5_LAG_FLAG_ROCE | MLX5_LAG_FLAG_SRIOV |\
@@ -59,6 +60,12 @@ __mlx5_lag_is_active(struct mlx5_lag *ldev)
 	return !!(ldev->flags & MLX5_LAG_MODE_FLAGS);
 }
 
+static inline bool
+mlx5_lag_is_ready(struct mlx5_lag *ldev)
+{
+	return ldev->flags & MLX5_LAG_FLAG_READY;
+}
+
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker);
 int mlx5_activate_lag(struct mlx5_lag *ldev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index d192d25cff33..88e58ac902de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -11,7 +11,7 @@
 
 static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 {
-	if (!ldev->pf[MLX5_LAG_P1].dev || !ldev->pf[MLX5_LAG_P2].dev)
+	if (!mlx5_lag_is_ready(ldev))
 		return false;
 
 	return mlx5_esw_multipath_prereq(ldev->pf[MLX5_LAG_P1].dev,
-- 
2.26.2

