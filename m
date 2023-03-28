Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116C36CCBA6
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjC1U4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1U4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CB91FEC
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39E16195E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD5DC4339C;
        Tue, 28 Mar 2023 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037005;
        bh=XlAZ2VdXkOnMYH4d2OM/KnDzqO8i1CYImN34MFua0Ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPvPAgX/uyeuqyMD5TZIwlD6Jgn6s4M0EWjSyHYXnt1A6XTmX8WMVKgOtFi/KgBte
         eGEb2h2+6v+hHGp7bpHo/Os9rPpkMhyjcDKfQP/ERLnJOF1CyYXqHl1s0w+g/ha6Nq
         b1jujup9pgp9bU/AveNyVemaCzbvPb8pxNAtW9XXvNUHWOf3m0wD0eCQ6tcjKBCqct
         rUCRFCk9CCsyFA4GWQJLNJtNoms84Z7NiGJo6++MWaYww8+t19SyzjjHzXV1HWVGob
         OgUEYjBBBHfTvlDlGNq13LhRU5Nh+aXIKNPCXHDuBHkMj8BtWBiMsb2rKlKFT98kuv
         EewMqzokb3bjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: RX, Remove mlx5e_alloc_unit argument in page allocation
Date:   Tue, 28 Mar 2023 13:56:09 -0700
Message-Id: <20230328205623.142075-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Change internal page cache and page pool api to use a struct page **
instead of a mlx5e_alloc_unit *.

This is the first change in a series which is meant to remove the
mlx5e_alloc_unit altogether.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 35 ++++++++++---------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3f7b63d6616b..36300118b6e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -292,7 +292,7 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
 	return true;
 }
 
-static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
+static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct page **pagep)
 {
 	struct mlx5e_page_cache *cache = &rq->page_cache;
 	struct mlx5e_rq_stats *stats = rq->stats;
@@ -308,35 +308,35 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, union mlx5e_alloc_uni
 		return false;
 	}
 
-	au->page = cache->page_cache[cache->head];
+	*pagep = cache->page_cache[cache->head];
 	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
 	stats->cache_reuse++;
 
-	addr = page_pool_get_dma_addr(au->page);
+	addr = page_pool_get_dma_addr(*pagep);
 	/* Non-XSK always uses PAGE_SIZE. */
 	dma_sync_single_for_device(rq->pdev, addr, PAGE_SIZE, rq->buff.map_dir);
 	return true;
 }
 
-static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
+static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct page **pagep)
 {
 	dma_addr_t addr;
 
-	if (mlx5e_rx_cache_get(rq, au))
+	if (mlx5e_rx_cache_get(rq, pagep))
 		return 0;
 
-	au->page = page_pool_dev_alloc_pages(rq->page_pool);
-	if (unlikely(!au->page))
+	*pagep = page_pool_dev_alloc_pages(rq->page_pool);
+	if (unlikely(!*pagep))
 		return -ENOMEM;
 
 	/* Non-XSK always uses PAGE_SIZE. */
-	addr = dma_map_page(rq->pdev, au->page, 0, PAGE_SIZE, rq->buff.map_dir);
+	addr = dma_map_page(rq->pdev, *pagep, 0, PAGE_SIZE, rq->buff.map_dir);
 	if (unlikely(dma_mapping_error(rq->pdev, addr))) {
-		page_pool_recycle_direct(rq->page_pool, au->page);
-		au->page = NULL;
+		page_pool_recycle_direct(rq->page_pool, *pagep);
+		*pagep = NULL;
 		return -ENOMEM;
 	}
-	page_pool_set_dma_addr(au->page, addr);
+	page_pool_set_dma_addr(*pagep, addr);
 
 	return 0;
 }
@@ -376,7 +376,7 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 		 * offset) should just use the new one without replenishing again
 		 * by themselves.
 		 */
-		err = mlx5e_page_alloc_pool(rq, frag->au);
+		err = mlx5e_page_alloc_pool(rq, &frag->au->page);
 
 	return err;
 }
@@ -605,13 +605,14 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		header_offset = (index & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) <<
 			MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
 		if (!(header_offset & (PAGE_SIZE - 1))) {
-			union mlx5e_alloc_unit au;
 
-			err = mlx5e_page_alloc_pool(rq, &au);
+			err = mlx5e_page_alloc_pool(rq, &page);
 			if (unlikely(err))
 				goto err_unmap;
-			page = dma_info->page = au.page;
-			addr = dma_info->addr = page_pool_get_dma_addr(au.page);
+
+			addr = page_pool_get_dma_addr(page);
+			dma_info->addr = addr;
+			dma_info->page = page;
 		} else {
 			dma_info->addr = addr + header_offset;
 			dma_info->page = page;
@@ -715,7 +716,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++, au++) {
 		dma_addr_t addr;
 
-		err = mlx5e_page_alloc_pool(rq, au);
+		err = mlx5e_page_alloc_pool(rq, &au->page);
 		if (unlikely(err))
 			goto err_unmap;
 		addr = page_pool_get_dma_addr(au->page);
-- 
2.39.2

