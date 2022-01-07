Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A1486F42
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiAGA6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGA6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA4A61E7A
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB8C36AEF;
        Fri,  7 Jan 2022 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517123;
        bh=eevKWNgmJN1kU0Pp8sRF6camFyyzpJhv/4BqiOLoesM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUU1kWGuyiXwPFMTBGp/8vBwYGH78gHjB+7zV/X3teyc9n4fHIZ5AKMUnV6g/gULf
         U1S6XtL1aXP01Rpb4sfVz4TwmNCAVs9jhnvCcg6dDu6bMXcdKmsJt2LZNvhM35M60n
         rTuBMRLah/PTFiyftTrnbr0wXf/EnDX3LPZdy7LqPoF1fzewjv0dcJM/ApnEAeblEA
         HzfuxvZG7XsjMnAk5n5raOQI+FyErqvqYYzBPhQcRdziH7gn9J5Ve+iN3RsXBLnwnW
         0BP0L7UtDBPPdUuifRtmXojIEmoJklvS8JC0+1HFS0LBwPWdSqgXxOnrKkSZhJuB77
         a5cpd+ShhvYag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/11] net/mlx5e: Fix page DMA map/unmap attributes
Date:   Thu,  6 Jan 2022 16:58:21 -0800
Message-Id: <20220107005831.78909-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Driver initiates DMA sync, hence it may skip CPU sync. Add
DMA_ATTR_SKIP_CPU_SYNC as input attribute both to dma_map_page and
dma_unmap_page to avoid redundant sync with the CPU.
When forcing the device to work with SWIOTLB, the extra sync might cause
data corruption. The driver unmaps the whole page while the hardware
used just a part of the bounce buffer. So syncing overrides the entire
page with bounce buffer that only partially contains real data.

Fixes: bc77b240b3c5 ("net/mlx5e: Add fragmented memory support for RX multi packet WQE")
Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c       | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 7b562d2c8a19..279cd8f4e79f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -11,13 +11,13 @@ static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
 {
 	struct device *dev = mlx5_core_dma_dev(priv->mdev);
 
-	return xsk_pool_dma_map(pool, dev, 0);
+	return xsk_pool_dma_map(pool, dev, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
 				 struct xsk_buff_pool *pool)
 {
-	return xsk_pool_dma_unmap(pool, 0);
+	return xsk_pool_dma_unmap(pool, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 793511d5ee4c..dfc6604b9538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -278,8 +278,8 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 	if (unlikely(!dma_info->page))
 		return -ENOMEM;
 
-	dma_info->addr = dma_map_page(rq->pdev, dma_info->page, 0,
-				      PAGE_SIZE, rq->buff.map_dir);
+	dma_info->addr = dma_map_page_attrs(rq->pdev, dma_info->page, 0, PAGE_SIZE,
+					    rq->buff.map_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(rq->pdev, dma_info->addr))) {
 		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 		dma_info->page = NULL;
@@ -300,7 +300,8 @@ static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info)
 {
-	dma_unmap_page(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir);
+	dma_unmap_page_attrs(rq->pdev, dma_info->addr, PAGE_SIZE, rq->buff.map_dir,
+			     DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-- 
2.33.1

