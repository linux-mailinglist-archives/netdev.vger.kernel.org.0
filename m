Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716423DF855
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhHCXUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233205AbhHCXUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447D660FA0;
        Tue,  3 Aug 2021 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032818;
        bh=Qktmr9TWKmVNw8s/sQBxRP1Jh/I+VL/hnnYwlQ34WnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pf4EHnVdsacIMfE4ibILfczso4Eeu4L79LLCnmFVVoQpwWOOUU8hzvIaOg5XTkhC/
         O6Xxr0u+LgeMCOZR1JwL0QMGC7BcnQl34w92BtrPLnJ1TmTeKrctiNN7CtLvAEd5kM
         WlCuCr8RT9RW9smhpkjWgbdMzzDmYtgXECcovKxbtvtZP3s9NtdxPbGRlZd8X/Ks0e
         0vhZVJd7P9uV9mpNJUN/KzSZnQ9bhBADjRtULQWie+WjEMCLaAKXwRD8qt9dCjo3xM
         VF+t0GP7LhH8+LThTw/R6dTMA+IJFLuZRYjve9MODmzED1ohlUueBnXps4yEs/sUtG
         0pwycsco1B6Jw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 02/14] net/mlx5: Lag, add initial logic for shared FDB
Date:   Tue,  3 Aug 2021 16:19:47 -0700
Message-Id: <20210803231959.26513-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

As shared FDB requires changes in two subsystems first expose the needed
core functions so the RDMA side can be changed.

mlx5_lag_is_master(): return true if a given mlx5 device is the lag master.
mlx5_lag_is_shared_fdb(): Returns true if the lag mode is shared FDB.
mlx5_lag_get_peer_mdev(): Return the peer mdev in lag.

The mentioned functions will be used by downstream patches in order
to add support for shared FDB for the RDMA side.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 49 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |  1 +
 include/linux/mlx5/driver.h                   |  3 ++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 5c043c5cc403..3049de648256 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -746,6 +746,21 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_is_active);
 
+bool mlx5_lag_is_master(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+	bool res;
+
+	spin_lock(&lag_lock);
+	ldev = mlx5_lag_dev(dev);
+	res = ldev && __mlx5_lag_is_active(ldev) &&
+		dev == ldev->pf[MLX5_LAG_P1].dev;
+	spin_unlock(&lag_lock);
+
+	return res;
+}
+EXPORT_SYMBOL(mlx5_lag_is_master);
+
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
@@ -760,6 +775,20 @@ bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_is_sriov);
 
+bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev;
+	bool res;
+
+	spin_lock(&lag_lock);
+	ldev = mlx5_lag_dev(dev);
+	res = ldev && __mlx5_lag_is_sriov(ldev) && ldev->shared_fdb;
+	spin_unlock(&lag_lock);
+
+	return res;
+}
+EXPORT_SYMBOL(mlx5_lag_is_shared_fdb);
+
 void mlx5_lag_update(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
@@ -827,6 +856,26 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_lag_get_slave_port);
 
+struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_dev *peer_dev = NULL;
+	struct mlx5_lag *ldev;
+
+	spin_lock(&lag_lock);
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		goto unlock;
+
+	peer_dev = ldev->pf[MLX5_LAG_P1].dev == dev ?
+			   ldev->pf[MLX5_LAG_P2].dev :
+			   ldev->pf[MLX5_LAG_P1].dev;
+
+unlock:
+	spin_unlock(&lag_lock);
+	return peer_dev;
+}
+EXPORT_SYMBOL(mlx5_lag_get_peer_mdev);
+
 int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 u64 *values,
 				 int num_counters,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index 191392c37558..70b244b1a09e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -39,6 +39,7 @@ struct lag_tracker {
  */
 struct mlx5_lag {
 	u8                        flags;
+	bool			  shared_fdb;
 	u8                        v2p_map[MLX5_MAX_PORTS];
 	struct kref               ref;
 	struct lag_func           pf[MLX5_MAX_PORTS];
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1efe37466969..af4dd6e9f97f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1138,6 +1138,8 @@ bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
 u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 			   struct net_device *slave);
@@ -1145,6 +1147,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 u64 *values,
 				 int num_counters,
 				 size_t *offsets);
+struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev);
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-- 
2.31.1

