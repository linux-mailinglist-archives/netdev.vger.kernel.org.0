Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8404BDA1C1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404396AbfJPWvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:51:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404089AbfJPWvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:51:06 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMoqUX009323
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:51:05 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnmy2e4nk-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:51:05 -0700
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 15:50:29 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id BB9314A2BD54; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Date:   Wed, 16 Oct 2019 15:50:19 -0700
Message-ID: <20191016225028.2100206-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=2 malwarescore=0 mlxlogscore=777 bulkscore=0
 clxscore=1034 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Obsolete the RX page-cache layer, pages are now recycled
in page_pool.

This patch introduce a temporary degradation as recycling
does not keep the pages DMA-mapped. That is fixed in a
downstream patch.

Issue: 1487631
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 13 ----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 16 -----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 67 ++-----------------
 3 files changed, 4 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8d76452cacdc..0595cdcff594 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -583,18 +583,6 @@ struct mlx5e_mpw_info {
 
 #define MLX5E_MAX_RX_FRAGS 4
 
-/* a single cache unit is capable to serve one napi call (for non-striding rq)
- * or a MPWQE (for striding rq).
- */
-#define MLX5E_CACHE_UNIT	(MLX5_MPWRQ_PAGES_PER_WQE > NAPI_POLL_WEIGHT ? \
-				 MLX5_MPWRQ_PAGES_PER_WQE : NAPI_POLL_WEIGHT)
-#define MLX5E_CACHE_SIZE	(4 * roundup_pow_of_two(MLX5E_CACHE_UNIT))
-struct mlx5e_page_cache {
-	u32 head;
-	u32 tail;
-	struct mlx5e_dma_info page_cache[MLX5E_CACHE_SIZE];
-};
-
 struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
 typedef struct sk_buff *
@@ -658,7 +646,6 @@ struct mlx5e_rq {
 	struct mlx5e_rq_stats *stats;
 	struct mlx5e_cq        cq;
 	struct mlx5e_cq_decomp cqd;
-	struct mlx5e_page_cache page_cache;
 	struct hwtstamp_config *tstamp;
 	struct mlx5_clock      *clock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7569287f8f3c..168be1f800a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -612,9 +612,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	}
 
-	rq->page_cache.head = 0;
-	rq->page_cache.tail = 0;
-
 	return 0;
 
 err_free:
@@ -640,8 +637,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 static void mlx5e_free_rq(struct mlx5e_rq *rq)
 {
-	int i;
-
 	if (rq->xdp_prog)
 		bpf_prog_put(rq->xdp_prog);
 
@@ -655,17 +650,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		mlx5e_free_di_list(rq);
 	}
 
-	for (i = rq->page_cache.head; i != rq->page_cache.tail;
-	     i = (i + 1) & (MLX5E_CACHE_SIZE - 1)) {
-		struct mlx5e_dma_info *dma_info = &rq->page_cache.page_cache[i];
-
-		/* With AF_XDP, page_cache is not used, so this loop is not
-		 * entered, and it's safe to call mlx5e_page_release_dynamic
-		 * directly.
-		 */
-		mlx5e_page_release_dynamic(rq, dma_info, false);
-	}
-
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
 	page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d6a547238de0..a3773f8a4931 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -184,65 +184,9 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
 }
 
-static inline bool mlx5e_page_is_reserved(struct page *page)
-{
-	return page_is_pfmemalloc(page) || page_to_nid(page) != numa_mem_id();
-}
-
-static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq,
-				      struct mlx5e_dma_info *dma_info)
-{
-	struct mlx5e_page_cache *cache = &rq->page_cache;
-	u32 tail_next = (cache->tail + 1) & (MLX5E_CACHE_SIZE - 1);
-	struct mlx5e_rq_stats *stats = rq->stats;
-
-	if (tail_next == cache->head) {
-		stats->cache_full++;
-		return false;
-	}
-
-	if (unlikely(mlx5e_page_is_reserved(dma_info->page))) {
-		stats->cache_waive++;
-		return false;
-	}
-
-	cache->page_cache[cache->tail] = *dma_info;
-	cache->tail = tail_next;
-	return true;
-}
-
-static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq,
-				      struct mlx5e_dma_info *dma_info)
-{
-	struct mlx5e_page_cache *cache = &rq->page_cache;
-	struct mlx5e_rq_stats *stats = rq->stats;
-
-	if (unlikely(cache->head == cache->tail)) {
-		stats->cache_empty++;
-		return false;
-	}
-
-	if (page_ref_count(cache->page_cache[cache->head].page) != 1) {
-		stats->cache_busy++;
-		return false;
-	}
-
-	*dma_info = cache->page_cache[cache->head];
-	cache->head = (cache->head + 1) & (MLX5E_CACHE_SIZE - 1);
-	stats->cache_reuse++;
-
-	dma_sync_single_for_device(rq->pdev, dma_info->addr,
-				   PAGE_SIZE,
-				   DMA_FROM_DEVICE);
-	return true;
-}
-
 static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 					struct mlx5e_dma_info *dma_info)
 {
-	if (mlx5e_rx_cache_get(rq, dma_info))
-		return 0;
-
 	dma_info->page = page_pool_dev_alloc_pages(rq->page_pool);
 	if (unlikely(!dma_info->page))
 		return -ENOMEM;
@@ -276,14 +220,11 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info,
 				bool recycle)
 {
-	if (likely(recycle)) {
-		if (mlx5e_rx_cache_put(rq, dma_info))
-			return;
+	mlx5e_page_dma_unmap(rq, dma_info);
 
-		mlx5e_page_dma_unmap(rq, dma_info);
+	if (likely(recycle)) {
 		page_pool_recycle_direct(rq->page_pool, dma_info->page);
 	} else {
-		mlx5e_page_dma_unmap(rq, dma_info);
 		page_pool_release_page(rq->page_pool, dma_info->page);
 		put_page(dma_info->page);
 	}
@@ -1167,7 +1108,7 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			/* do not return page to cache,
+			/* do not return page to pool,
 			 * it will be returned on XDP_TX completion.
 			 */
 			goto wq_cyc_pop;
@@ -1210,7 +1151,7 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			/* do not return page to cache,
+			/* do not return page to pool,
 			 * it will be returned on XDP_TX completion.
 			 */
 			goto wq_cyc_pop;
-- 
2.17.1

