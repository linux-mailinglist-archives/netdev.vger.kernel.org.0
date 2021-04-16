Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7E1362819
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbhDPSzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236440AbhDPSzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD6AC613B7;
        Fri, 16 Apr 2021 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599285;
        bh=eNSJ7PVcsCHsSPgsBDYJmgUwSLcDPrV4rqchZrCwffU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bM7ePVJ/bF5sCgpsxLpEKRQk7MC82ce6kSz4JvYD+No6rW26Gu0xqslZbNnQaO7tG
         JIzV00k5J6bEEXY8jNXxJHfKP7aKctd7M5m8/4bfgWbF5CO6LYbOFmVO+KlxydKR0J
         FGzm4AkoI04jpk1d/b4lap1+8gUHXkd5+Llw1CjD9YQsLrx7vBdklAd42a1gQGuZhs
         eJp7iXJsHXHbQOT4DBQZFKdAeLiJgUdaOXNikSnsNKIXPKEk8PBeSZ63LlRbNTNOB3
         ujgVTVE+JBECkVZVmkDpanc/v/qy8QPPtPIw0y8Cv6ill4W7OSrwMX55cUQTOvcSNX
         FwnShg9Mf3Z4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/14] net/mlx5: Allocate FC bulk structs with kvzalloc() instead of kzalloc()
Date:   Fri, 16 Apr 2021 11:54:26 -0700
Message-Id: <20210416185430.62584-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The bulk size is larger than 16K so use kvzalloc().
The bulk bitmask upper size limit is 16K so use kvcalloc().

Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index f43caefd07a1..18e5aec14641 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -497,13 +497,13 @@ static struct mlx5_fc_bulk *mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
 	alloc_bitmask = MLX5_CAP_GEN(dev, flow_counter_bulk_alloc);
 	bulk_len = alloc_bitmask > 0 ? MLX5_FC_BULK_NUM_FCS(alloc_bitmask) : 1;
 
-	bulk = kzalloc(sizeof(*bulk) + bulk_len * sizeof(struct mlx5_fc),
-		       GFP_KERNEL);
+	bulk = kvzalloc(sizeof(*bulk) + bulk_len * sizeof(struct mlx5_fc),
+			GFP_KERNEL);
 	if (!bulk)
 		goto err_alloc_bulk;
 
-	bulk->bitmask = kcalloc(BITS_TO_LONGS(bulk_len), sizeof(unsigned long),
-				GFP_KERNEL);
+	bulk->bitmask = kvcalloc(BITS_TO_LONGS(bulk_len), sizeof(unsigned long),
+				 GFP_KERNEL);
 	if (!bulk->bitmask)
 		goto err_alloc_bitmask;
 
@@ -521,9 +521,9 @@ static struct mlx5_fc_bulk *mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
 	return bulk;
 
 err_mlx5_cmd_bulk_alloc:
-	kfree(bulk->bitmask);
+	kvfree(bulk->bitmask);
 err_alloc_bitmask:
-	kfree(bulk);
+	kvfree(bulk);
 err_alloc_bulk:
 	return ERR_PTR(err);
 }
@@ -537,8 +537,8 @@ mlx5_fc_bulk_destroy(struct mlx5_core_dev *dev, struct mlx5_fc_bulk *bulk)
 	}
 
 	mlx5_cmd_fc_free(dev, bulk->base_id);
-	kfree(bulk->bitmask);
-	kfree(bulk);
+	kvfree(bulk->bitmask);
+	kvfree(bulk);
 
 	return 0;
 }
-- 
2.30.2

