Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FC3435213
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJTR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhJTR6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D87A6138B;
        Wed, 20 Oct 2021 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752589;
        bh=zT3oqJxVGM1YbvKPqhk7lAF+GvjNzAog0PQgqnLVX9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr8WyDmd0tlcgUAPsKCPvcDfDZirIUM2k9suofmrytigUnNy90pjqex7tqEEnYrZi
         igO6EJL4DIUAGXuJxEmO8oLbl5MXHGBHFwx4vwcFKKTSgdrcI3guB7hvbtg8+IAeUf
         dcJbokcMkUPQszMC59ukcqs5B2FKjhg+va0bEDs+zkD3xFCEumm7AJHqdFpk6DVc9f
         cEk1oOf00BAD2Cl4PSbK9zZYIcLOFuRaDPF7Hbonw5HhzQ+E3wQ9NHzstemxVe4c37
         wt37sRXEViqT6OAfKhDJOjiDnnyrbjbKiEDp7Gy/kcBEllVHgI2r7KCG6HQVEmWjOO
         mxIClAxyXee4g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/5] net/mlx5: Lag, change multipath and bonding to be mutually exclusive
Date:   Wed, 20 Oct 2021 10:56:23 -0700
Message-Id: <20211020175627.269138-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020175627.269138-1-saeed@kernel.org>
References: <20211020175627.269138-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Both multipath and bonding events are changing the HW LAG state
independently.
Handling one of the features events while the other is already
enabled can cause unwanted behavior, for example handling
bonding event while multipath enabled will disable the lag and
cause multipath to stop working.

Fix it by ignoring bonding event while in multipath and ignoring FIB
events while in bonding mode.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affinity based on FIB events")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag.c       |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c    | 13 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h    |  2 ++
 include/linux/mlx5/driver.h                         |  1 -
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index b4e986818794..4a13ef561587 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -10,6 +10,8 @@
 #include "en_tc.h"
 #include "rep/tc.h"
 #include "rep/neigh.h"
+#include "lag.h"
+#include "lag_mp.h"
 
 struct mlx5e_tc_tun_route_attr {
 	struct net_device *out_dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ba8164792016..129ff7e0d65c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -67,6 +67,8 @@
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
 #include <asm/div64.h>
+#include "lag.h"
+#include "lag_mp.h"
 
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index ca5690b0a7ab..d2105c1635c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -442,6 +442,10 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	if (!mlx5_lag_is_ready(ldev)) {
 		do_bond = false;
 	} else {
+		/* VF LAG is in multipath mode, ignore bond change requests */
+		if (mlx5_lag_is_multipath(dev0))
+			return;
+
 		tracker = ldev->tracker;
 
 		do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index f239b352a58a..21fdaf708f1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -9,20 +9,23 @@
 #include "eswitch.h"
 #include "lib/mlx5.h"
 
+static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
+{
+	return !!(ldev->flags & MLX5_LAG_FLAG_MULTIPATH);
+}
+
 static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 {
 	if (!mlx5_lag_is_ready(ldev))
 		return false;
 
+	if (__mlx5_lag_is_active(ldev) && !__mlx5_lag_is_multipath(ldev))
+		return false;
+
 	return mlx5_esw_multipath_prereq(ldev->pf[MLX5_LAG_P1].dev,
 					 ldev->pf[MLX5_LAG_P2].dev);
 }
 
-static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
-{
-	return !!(ldev->flags & MLX5_LAG_FLAG_MULTIPATH);
-}
-
 bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
index 729c839397a8..dea199e79bed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h
@@ -24,12 +24,14 @@ struct lag_mp {
 void mlx5_lag_mp_reset(struct mlx5_lag *ldev);
 int mlx5_lag_mp_init(struct mlx5_lag *ldev);
 void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev);
+bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 
 static inline void mlx5_lag_mp_reset(struct mlx5_lag *ldev) {};
 static inline int mlx5_lag_mp_init(struct mlx5_lag *ldev) { return 0; }
 static inline void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev) {}
+bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev) { return false; }
 
 #endif /* CONFIG_MLX5_ESWITCH */
 #endif /* __MLX5_LAG_MP_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index e23417424373..f17d2101af7a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1138,7 +1138,6 @@ int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev);
 int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
-bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
-- 
2.31.1

