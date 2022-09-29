Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BCD5EEEDC
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiI2HXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiI2HW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E61E1181FF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4580EB82344
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C45C433D6;
        Thu, 29 Sep 2022 07:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436167;
        bh=JJNkTrSOp2ur6TiDvp+CDKzoBNnfNhdOGgCXBNK0efE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1jqHWespM2XpeKzxzgMQyp6tMruJ9UaVrZEj+X4M6nhW0YXztOJErYeTIsPwTUyR
         LX30G3uB7uVy0Gdo5Of7UcVyvAXaBRdy2n7uBL3QyXd12q2rTWWTXPrAeCwqLlHeim
         jIVLDjjORMDLAbHAkeIo/BJfw7EoB8HAQwZjYGQ6HLJuoL6vpvRIM0ZMTtM5oW6z1D
         6nFUUJ6KPrG4g2mGuW1QMn6bAomCqjMJsL44FNCG2JSONYayS79arEhwg+npzGUAp0
         aTbjWa1O7Iy3tfXtQQZnur3dDoiHrSCMWyBeruzigi6cjALZlAt45ge+YGgVkBI+Xd
         joI1mxRWQqbag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 09/16] net/mlx5e: Optimize the page cache reducing its size 2x
Date:   Thu, 29 Sep 2022 00:21:49 -0700
Message-Id: <20220929072156.93299-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

RX page cache stores dma_info structs, that consist of a pointer to
struct page and a DMA address. In fact, the DMA address is extracted
from struct page using page_pool_get_dma_addr when a page is pushed to
the cache. By moving this call to the point when a page is popped from
the cache, we can avoid storing the DMA address in the cache,
effectively reducing its size by two times without losing any
functionality.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 8 ++++----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 449c016262f4..6b91fa7f2221 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -630,7 +630,7 @@ struct mlx5e_mpw_info {
 struct mlx5e_page_cache {
 	u32 head;
 	u32 tail;
-	struct mlx5e_dma_info page_cache[MLX5E_CACHE_SIZE];
+	struct page *page_cache[MLX5E_CACHE_SIZE];
 };
 
 struct mlx5e_rq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fbbc2e792c27..b1d8fd08887b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -830,13 +830,11 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 
 	for (i = rq->page_cache.head; i != rq->page_cache.tail;
 	     i = (i + 1) & (MLX5E_CACHE_SIZE - 1)) {
-		struct mlx5e_dma_info *dma_info = &rq->page_cache.page_cache[i];
-
 		/* With AF_XDP, page_cache is not used, so this loop is not
 		 * entered, and it's safe to call mlx5e_page_release_dynamic
 		 * directly.
 		 */
-		mlx5e_page_release_dynamic(rq, dma_info->page, false);
+		mlx5e_page_release_dynamic(rq, rq->page_cache.page_cache[i], false);
 	}
 
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index de929fde8cc6..b8aa6f843675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -245,8 +245,7 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
 		return false;
 	}
 
-	cache->page_cache[cache->tail].page = page;
-	cache->page_cache[cache->tail].addr = page_pool_get_dma_addr(page);
+	cache->page_cache[cache->tail] = page;
 	cache->tail = tail_next;
 	return true;
 }
@@ -262,12 +261,13 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq,
 		return false;
 	}
 
-	if (page_ref_count(cache->page_cache[cache->head].page) != 1) {
+	if (page_ref_count(cache->page_cache[cache->head]) != 1) {
 		stats->cache_busy++;
 		return false;
 	}
 
-	*dma_info = cache->page_cache[cache->head];
+	dma_info->page = cache->page_cache[cache->head];
+	dma_info->addr = page_pool_get_dma_addr(dma_info->page);
 	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
 	stats->cache_reuse++;
 
-- 
2.37.3

