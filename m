Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D33671BF
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244951AbhDURsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244913AbhDURsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E44761427;
        Wed, 21 Apr 2021 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027260;
        bh=Q80QWz9WuMuq647rBwI9VdSnMLeouMcuMpMAiZBhdaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI6a/ziHlZxCSC7695pvzpQZEc9SvHkg4yf3pzEhDtP7FLXXs621vZnKPlTtDsk6x
         0IILuqjSTziQg3qwJT989ZURFpNoBp5aGFhR+pc8lYBEu7BChVWgUwnxtbTp4LtPMX
         QrXW7CGIT3l6kXHNsL3dZUWI90sGgwqkD0D4lsGWr8zuppEKzy5TAOrmgwwfmrGQ4x
         uKX4/O/GOzlMQ8BUi6Sw8ZKKBU9kEJ1NbA/3I9VtqK/fIaMp7/ThnsGTbRA5yScOgq
         R6+G+avWGPXXckRpCOxYmeoqnF6HWqqngLPUaeytbW6YUc3EST+1jnMX4/cT0KsuKf
         0pIc2J3g4SvjQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/11] net/mlx5: SF, Rely on hw table for SF devlink port allocation
Date:   Wed, 21 Apr 2021 10:47:17 -0700
Message-Id: <20210421174723.159428-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Supporting SF allocation is currently checked at two places:
(a) SF devlink port allocator and
(b) SF HW table handler.

Both layers are using HCA CAP to identify it using helper routine
mlx5_sf_supported() and mlx5_sf_max_functions().

Instead, rely on the HW table handler to check if SF is supported
or not.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c  | 9 ++-------
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h     | 1 +
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 52226d9b9a6d..5fa261334cd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -437,9 +437,6 @@ static int mlx5_sf_vhca_event(struct notifier_block *nb, unsigned long opcode, v
 
 static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
 {
-	if (!mlx5_sf_max_functions(table->dev))
-		return;
-
 	init_completion(&table->disable_complete);
 	refcount_set(&table->refcount, 1);
 }
@@ -462,9 +459,6 @@ static void mlx5_sf_deactivate_all(struct mlx5_sf_table *table)
 
 static void mlx5_sf_table_disable(struct mlx5_sf_table *table)
 {
-	if (!mlx5_sf_max_functions(table->dev))
-		return;
-
 	if (!refcount_read(&table->refcount))
 		return;
 
@@ -498,7 +492,8 @@ static int mlx5_sf_esw_event(struct notifier_block *nb, unsigned long event, voi
 
 static bool mlx5_sf_table_supported(const struct mlx5_core_dev *dev)
 {
-	return dev->priv.eswitch && MLX5_ESWITCH_MANAGER(dev) && mlx5_sf_supported(dev);
+	return dev->priv.eswitch && MLX5_ESWITCH_MANAGER(dev) &&
+	       mlx5_sf_hw_table_supported(dev);
 }
 
 int mlx5_sf_table_init(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index ec53c11c8344..9140c81aa03a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -41,7 +41,7 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	int err;
 	int i;
 
-	if (!table->max_local_functions)
+	if (!table || !table->max_local_functions)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&table->table_lock);
@@ -230,3 +230,8 @@ void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
 	/* Dealloc SFs whose firmware event has been missed. */
 	mlx5_sf_hw_dealloc_all(table);
 }
+
+bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev)
+{
+	return !!dev->priv.sf_hw_table;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
index cb02a51d0986..b36be5ecb496 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -17,5 +17,6 @@ u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id);
 int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum);
 void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id);
 void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id);
+bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev);
 
 #endif
-- 
2.30.2

