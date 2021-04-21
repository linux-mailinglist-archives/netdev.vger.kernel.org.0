Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758D23671C1
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbhDURs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244922AbhDURsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46BC361455;
        Wed, 21 Apr 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027261;
        bh=m3ZN1fpMHwCP+UEAw/uCN4eS/ECaYS0RBytP4dTpVgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxNYfxAKiBZ+ahvYaUjtjuiGq46530FR9pjzA0srnztjnBrgt+IRvhy0tYAHFDM7l
         WR4MM70YHTnnFEAoenFTX/ENyGlTTGtnOH0LTxF2ROiaHQhxS/1esD5QOxTjWPINYH
         phUmUrsRTztvfYHF9EKBn4EvWYNTKV9oskRax+65kpgXGH4QauC/2j0W1H5KBP6hJb
         HQ+7Vx0Dnk6PzQWTsfPvJIQVgzHmxkpzDiCSZ3NjjrUeiYFbuJX5hQSKLcAlbzEhpn
         TNfbArvEvzsrK2bjQPb4um6HU5MG1Nn14+HAw61zBQkrKkb1cSbHrKdIk+yv39TfX0
         tJ/o4Xpj2k++A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/11] net/mlx5: SF, Store and use start function id
Date:   Wed, 21 Apr 2021 10:47:19 -0700
Message-Id: <20210421174723.159428-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

SF ids in the device are in two different contiguous ranges. One for
the local controller and second for the external host controller.

Prepare code to handle multiple start function id by storing it in the
table.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 9140c81aa03a..c3126031c2bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -19,18 +19,23 @@ struct mlx5_sf_hw_table {
 	struct mlx5_core_dev *dev;
 	struct mlx5_sf_hw *sfs;
 	int max_local_functions;
+	u16 start_fn_id;
 	struct mutex table_lock; /* Serializes sf deletion and vhca state change handler. */
 	struct notifier_block vhca_nb;
 };
 
 u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
 {
-	return sw_id + mlx5_sf_start_function_id(dev);
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	return table->start_fn_id + sw_id;
 }
 
 static u16 mlx5_sf_hw_to_sw_id(const struct mlx5_core_dev *dev, u16 hw_id)
 {
-	return hw_id - mlx5_sf_start_function_id(dev);
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+
+	return hw_id - table->start_fn_id;
 }
 
 int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
@@ -164,6 +169,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	table->dev = dev;
 	table->sfs = sfs;
 	table->max_local_functions = max_functions;
+	table->start_fn_id = mlx5_sf_start_function_id(dev);
 	dev->priv.sf_hw_table = table;
 	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_functions);
 	return 0;
-- 
2.30.2

