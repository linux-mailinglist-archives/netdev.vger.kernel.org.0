Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA00353674
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhDDEUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhDDEUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7156137E;
        Sun,  4 Apr 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510012;
        bh=eGjQhbgGBKdFBzicmjH5KykURKu62VWC0EKqSwumb0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrZJNSld7ud3g9zj6p/RXy6jSzRdqJSwr1X+iRMnbrB8DKLD+KPiN5HT8MqjIfYVo
         bI6UL2We4n6Ty/V34ZbZ3FQT8KlvIqWPlTcejlWkMQysW2/3zawT6mO8r6/ChFFZpR
         74WREC49nthRGLQVmARGjRRfKNxJY1nsSKv7pB48eImty85XPNa4664Y38k2xdFCwg
         AFYYAhO8V2DNdy+N867ZTZLlYuS3UCOig7KrPtvOQU2Jbr1Wc8MTmQEBnTunsCPNK7
         C4UHCSA1PXvqVmsH7a2URrsFluz7AtUzztYesbO7GfRdJ/NhGSyR5PZUx5FthohUxC
         xr2lydOLbXqdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: Use ida_alloc_range() instead of ida_simple_alloc()
Date:   Sat,  3 Apr 2021 21:19:51 -0700
Message-Id: <20210404041954.146958-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

ida_simple_alloc() and remove functions are deprecated.
Related change:
commit 3264ceec8f17 ("lib/idr.c: document that ida_simple_{get,remove}() are deprecated")

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c    | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 22bee4990232..d43a05e77f67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -707,7 +707,7 @@ static void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 	}
 
 	if (accel_xfrm->attrs.action == MLX5_ACCEL_ESP_ACTION_DECRYPT) {
-		err = ida_simple_get(&fipsec->halloc, 1, 0, GFP_KERNEL);
+		err = ida_alloc_min(&fipsec->halloc, 1, GFP_KERNEL);
 		if (err < 0) {
 			context = ERR_PTR(err);
 			goto exists;
@@ -758,7 +758,7 @@ static void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 unlock_hash:
 	mutex_unlock(&fipsec->sa_hash_lock);
 	if (accel_xfrm->attrs.action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
-		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
+		ida_free(&fipsec->halloc, sa_ctx->sa_handle);
 exists:
 	mutex_unlock(&fpga_xfrm->lock);
 	kfree(sa_ctx);
@@ -852,7 +852,7 @@ mlx5_fpga_ipsec_release_sa_ctx(struct mlx5_fpga_ipsec_sa_ctx *sa_ctx)
 
 	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action &
 	    MLX5_ACCEL_ESP_ACTION_DECRYPT)
-		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
+		ida_free(&fipsec->halloc, sa_ctx->sa_handle);
 
 	mutex_lock(&fipsec->sa_hash_lock);
 	WARN_ON(rhashtable_remove_fast(&fipsec->sa_hash, &sa_ctx->hash,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index dbd910656574..0216bd63a42d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -590,7 +590,7 @@ static void del_sw_fte(struct fs_node *node)
 				     &fte->hash,
 				     rhash_fte);
 	WARN_ON(err);
-	ida_simple_remove(&fg->fte_allocator, fte->index - fg->start_index);
+	ida_free(&fg->fte_allocator, fte->index - fg->start_index);
 	kmem_cache_free(steering->ftes_cache, fte);
 }
 
@@ -640,7 +640,7 @@ static int insert_fte(struct mlx5_flow_group *fg, struct fs_fte *fte)
 	int index;
 	int ret;
 
-	index = ida_simple_get(&fg->fte_allocator, 0, fg->max_ftes, GFP_KERNEL);
+	index = ida_alloc_max(&fg->fte_allocator, fg->max_ftes - 1, GFP_KERNEL);
 	if (index < 0)
 		return index;
 
@@ -656,7 +656,7 @@ static int insert_fte(struct mlx5_flow_group *fg, struct fs_fte *fte)
 	return 0;
 
 err_ida_remove:
-	ida_simple_remove(&fg->fte_allocator, index);
+	ida_free(&fg->fte_allocator, index);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
index 97324d9d4f2a..3f9869c7e326 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
@@ -88,12 +88,12 @@ void mlx5_core_unreserve_gids(struct mlx5_core_dev *dev, unsigned int count)
 int mlx5_core_reserved_gid_alloc(struct mlx5_core_dev *dev, int *gid_index)
 {
 	int end = dev->roce.reserved_gids.start +
-		  dev->roce.reserved_gids.count;
+		  dev->roce.reserved_gids.count - 1;
 	int index = 0;
 
-	index = ida_simple_get(&dev->roce.reserved_gids.ida,
-			       dev->roce.reserved_gids.start, end,
-			       GFP_KERNEL);
+	index = ida_alloc_range(&dev->roce.reserved_gids.ida,
+				dev->roce.reserved_gids.start, end,
+				GFP_KERNEL);
 	if (index < 0)
 		return index;
 
@@ -105,7 +105,7 @@ int mlx5_core_reserved_gid_alloc(struct mlx5_core_dev *dev, int *gid_index)
 void mlx5_core_reserved_gid_free(struct mlx5_core_dev *dev, int gid_index)
 {
 	mlx5_core_dbg(dev, "Freeing reserved GID %u\n", gid_index);
-	ida_simple_remove(&dev->roce.reserved_gids.ida, gid_index);
+	ida_free(&dev->roce.reserved_gids.ida, gid_index);
 }
 
 unsigned int mlx5_core_reserved_gids_count(struct mlx5_core_dev *dev)
-- 
2.30.2

