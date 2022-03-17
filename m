Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8340B4DCE35
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiCQS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbiCQSzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DAA1637DD
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B82B81F9D
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75185C340EE;
        Thu, 17 Mar 2022 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543275;
        bh=8SOp2VTWmwoba19bl5NOw95YcRTwQ6O4ahodxgZQMj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKpMFzu0eCBoXzpcrkVPY/DxwbZrOYhWGtbSN3NLbM7inDJL5FyPZY8C4sgRCAII6
         4wDTYhLcq2g9hdgvopF7pfBY4CBmJ5pfrtYJjfvCcgcNo1nD0OCe/Tu8irNeCyu213
         zZmJMeiLx15e6I3J83oDcMbP668aNWaIhmVzQo0yTCZJmangBMhtwRxqHpttgImrvn
         hziRMBZvtvN9JzfDphc92tA7eJ1tYJsSyyy94LZ9cq20OZY6UeaCLR8KpyihBjct1G
         OsmPftB7M5hu6MMQWeiHvswi1Ei1Hc6ylPiZ+/K2C9+lVYvWG1e3SIDyI54WLTs/h3
         vh2OopZvuE3kQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Remove unused exported contiguous coherent buffer allocation API
Date:   Thu, 17 Mar 2022 11:54:23 -0700
Message-Id: <20220317185424.287982-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

All WQ types moved to using the fragmented allocation API
for coherent memory. Contiguous API is not used anymore.
Remove it, reduce the number of exported functions.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 47 -------------------
 include/linux/mlx5/driver.h                   |  3 --
 2 files changed, 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index d5408f6ce5a7..1762c5c36042 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -71,53 +71,6 @@ static void *mlx5_dma_zalloc_coherent_node(struct mlx5_core_dev *dev,
 	return cpu_handle;
 }
 
-static int mlx5_buf_alloc_node(struct mlx5_core_dev *dev, int size,
-			       struct mlx5_frag_buf *buf, int node)
-{
-	dma_addr_t t;
-
-	buf->size = size;
-	buf->npages       = 1;
-	buf->page_shift   = (u8)get_order(size) + PAGE_SHIFT;
-
-	buf->frags = kzalloc(sizeof(*buf->frags), GFP_KERNEL);
-	if (!buf->frags)
-		return -ENOMEM;
-
-	buf->frags->buf   = mlx5_dma_zalloc_coherent_node(dev, size,
-							  &t, node);
-	if (!buf->frags->buf)
-		goto err_out;
-
-	buf->frags->map = t;
-
-	while (t & ((1 << buf->page_shift) - 1)) {
-		--buf->page_shift;
-		buf->npages *= 2;
-	}
-
-	return 0;
-err_out:
-	kfree(buf->frags);
-	return -ENOMEM;
-}
-
-int mlx5_buf_alloc(struct mlx5_core_dev *dev,
-		   int size, struct mlx5_frag_buf *buf)
-{
-	return mlx5_buf_alloc_node(dev, size, buf, dev->priv.numa_node);
-}
-EXPORT_SYMBOL(mlx5_buf_alloc);
-
-void mlx5_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
-{
-	dma_free_coherent(mlx5_core_dma_dev(dev), buf->size, buf->frags->buf,
-			  buf->frags->map);
-
-	kfree(buf->frags);
-}
-EXPORT_SYMBOL_GPL(mlx5_buf_free);
-
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 			     struct mlx5_frag_buf *buf, int node)
 {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 00a914b0716e..a386aec1eb65 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1009,9 +1009,6 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev);
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health);
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
-int mlx5_buf_alloc(struct mlx5_core_dev *dev,
-		   int size, struct mlx5_frag_buf *buf);
-void mlx5_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 			     struct mlx5_frag_buf *buf, int node);
 void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
-- 
2.35.1

