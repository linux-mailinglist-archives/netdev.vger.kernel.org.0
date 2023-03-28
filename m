Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA796CCBB5
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjC1U5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjC1U5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9230C3588
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECD2D61961
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45450C433D2;
        Tue, 28 Mar 2023 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037021;
        bh=/EUtVdMMaXckOWEWqpdGxnPdw7U9KnrDhOeAwpvs4uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbGLkf85QX//L3DP3u2tTvasJAoXKSrsbLD4ldDLIcDixzMHdGuI2FMEQqwuOLmaB
         WlBRwwTznMhW009YHrA7BL90Q9iFUgphYFLnPgXRMdHCjdw5513ps7Ra2YpzWeknAh
         7xVA84DxjSjY04yhwYWjUss2/rN4USLuYqrBRiHj6hruV2y+iJLdW0tFRQC10ySrun
         dAqadLGgaBMeyIw+ap7I0zDtnSPMiSRiHiLzznvTF09c2rbctdQfu+orqyra9umqer
         KXIVpRgmaB2ab6hpKb7ZPBvI3utjRQZlHBRiAp1cWKvhEQBE5TIpDZxdXTCUw7VBG/
         rVj2eAQbmrrjw==
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
Subject: [net-next 15/15] net/mlx5e: RX, Remove unnecessary recycle parameter and page_cache stats
Date:   Tue, 28 Mar 2023 13:56:23 -0700
Message-Id: <20230328205623.142075-16-saeed@kernel.org>
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

The recycle parameter used during page release is no longer
necessary: the page pool can detect when the page cannot be
recycled to the cache or ring without any outside hint.

The page pool will also take care of cleaning up after itself
once all the inflight pages have been released. So no need to
explicitly release pages to the system.

Remove the internal page_cache stats as the mlx5e_page_cache
struct no longer exists.

Delete the documentation entries along with the stats.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/counters.rst       | 26 ----------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  7 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 47 +++++++++----------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 20 --------
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 10 ----
 5 files changed, 25 insertions(+), 85 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
index 4cd8e869762b..6b2d1fe74ecf 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
@@ -346,32 +346,6 @@ the software port.
      - The number of receive packets with CQE compression on ring i [#accel]_.
      - Acceleration
 
-   * - `rx[i]_cache_reuse`
-     - The number of events of successful reuse of a page from a driver's
-       internal page cache.
-     - Acceleration
-
-   * - `rx[i]_cache_full`
-     - The number of events of full internal page cache where driver can't put a
-       page back to the cache for recycling (page will be freed).
-     - Acceleration
-
-   * - `rx[i]_cache_empty`
-     - The number of events where cache was empty - no page to give. Driver
-       shall allocate new page.
-     - Acceleration
-
-   * - `rx[i]_cache_busy`
-     - The number of events where cache head was busy and cannot be recycled.
-       Driver allocated new page.
-     - Acceleration
-
-   * - `rx[i]_cache_waive`
-     - The number of cache evacuation. This can occur due to page move to
-       another NUMA node or page was pfmemalloc-ed and should be freed as soon
-       as possible.
-     - Acceleration
-
    * - `rx[i]_arfs_err`
      - Number of flow rules that failed to be added to the flow table.
      - Error
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index ca6ac9772d22..15d15d0e5ef9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -505,7 +505,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  struct mlx5e_xdp_wqe_info *wi,
 				  u32 *xsk_frames,
-				  bool recycle,
 				  struct xdp_frame_bulk *bq)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
@@ -524,7 +523,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
 			page_pool_put_defragged_page(xdpi.page.rq->page_pool,
-						     xdpi.page.page, -1, recycle);
+						     xdpi.page.page, -1, true);
 			break;
 		case MLX5E_XDP_XMIT_MODE_XSK:
 			/* AF_XDP send */
@@ -578,7 +577,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 			sqcc += wi->num_wqebbs;
 
-			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true, &bq);
+			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, &bq);
 		} while (!last_wqe);
 
 		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
@@ -625,7 +624,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 
 		sq->cc += wi->num_wqebbs;
 
-		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, false, &bq);
+		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, &bq);
 	}
 
 	xdp_flush_frame_bulk(&bq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index df5dbef9e5ec..1049805571c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -293,14 +293,13 @@ static int mlx5e_page_alloc_fragmented(struct mlx5e_rq *rq,
 }
 
 static void mlx5e_page_release_fragmented(struct mlx5e_rq *rq,
-					  struct mlx5e_frag_page *frag_page,
-					  bool recycle)
+					  struct mlx5e_frag_page *frag_page)
 {
 	u16 drain_count = MLX5E_PAGECNT_BIAS_MAX - frag_page->frags;
 	struct page *page = frag_page->page;
 
 	if (page_pool_defrag_page(page, drain_count) == 0)
-		page_pool_put_defragged_page(rq->page_pool, page, -1, recycle);
+		page_pool_put_defragged_page(rq->page_pool, page, -1, true);
 }
 
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
@@ -330,11 +329,10 @@ static bool mlx5e_frag_can_release(struct mlx5e_wqe_frag_info *frag)
 }
 
 static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
-				     struct mlx5e_wqe_frag_info *frag,
-				     bool recycle)
+				     struct mlx5e_wqe_frag_info *frag)
 {
 	if (mlx5e_frag_can_release(frag))
-		mlx5e_page_release_fragmented(rq, frag->frag_page, recycle);
+		mlx5e_page_release_fragmented(rq, frag->frag_page);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -368,19 +366,18 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 
 free_frags:
 	while (--i >= 0)
-		mlx5e_put_rx_frag(rq, --frag, true);
+		mlx5e_put_rx_frag(rq, --frag);
 
 	return err;
 }
 
 static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
-				     struct mlx5e_wqe_frag_info *wi,
-				     bool recycle)
+				     struct mlx5e_wqe_frag_info *wi)
 {
 	int i;
 
 	for (i = 0; i < rq->wqe.info.num_frags; i++, wi++)
-		mlx5e_put_rx_frag(rq, wi, recycle);
+		mlx5e_put_rx_frag(rq, wi);
 }
 
 static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
@@ -396,7 +393,7 @@ static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 	if (rq->xsk_pool)
 		mlx5e_xsk_free_rx_wqe(wi);
 	else
-		mlx5e_free_rx_wqe(rq, wi, false);
+		mlx5e_free_rx_wqe(rq, wi);
 }
 
 static void mlx5e_xsk_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
@@ -427,7 +424,7 @@ static void mlx5e_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 		struct mlx5e_wqe_frag_info *wi;
 
 		wi = get_frag(rq, j);
-		mlx5e_free_rx_wqe(rq, wi, true);
+		mlx5e_free_rx_wqe(rq, wi);
 	}
 }
 
@@ -502,7 +499,7 @@ mlx5e_copy_skb_header(struct mlx5e_rq *rq, struct sk_buff *skb,
 }
 
 static void
-mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle)
+mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi)
 {
 	bool no_xdp_xmit;
 	int i;
@@ -516,9 +513,9 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 	if (rq->xsk_pool) {
 		struct xdp_buff **xsk_buffs = wi->alloc_units.xsk_buffs;
 
-		/* The `recycle` parameter is ignored, and the page is always
-		 * put into the Reuse Ring, because there is no way to return
-		 * the page to the userspace when the interface goes down.
+		/* The page is always put into the Reuse Ring, because there
+		 * is no way to return the page to userspace when the interface
+		 * goes down.
 		 */
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap))
@@ -529,7 +526,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 				struct mlx5e_frag_page *frag_page;
 
 				frag_page = &wi->alloc_units.frag_pages[i];
-				mlx5e_page_release_fragmented(rq, frag_page, recycle);
+				mlx5e_page_release_fragmented(rq, frag_page);
 			}
 		}
 	}
@@ -663,7 +660,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
-			mlx5e_page_release_fragmented(rq, dma_info->frag_page, true);
+			mlx5e_page_release_fragmented(rq, dma_info->frag_page);
 		}
 	}
 	rq->stats->buff_alloc_err++;
@@ -781,7 +778,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 err_unmap:
 	while (--i >= 0) {
 		frag_page--;
-		mlx5e_page_release_fragmented(rq, frag_page, true);
+		mlx5e_page_release_fragmented(rq, frag_page);
 	}
 
 err:
@@ -815,7 +812,7 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
 		if (hd_info->frag_page && hd_info->frag_page != deleted_page) {
 			deleted_page = hd_info->frag_page;
-			mlx5e_page_release_fragmented(rq, hd_info->frag_page, false);
+			mlx5e_page_release_fragmented(rq, hd_info->frag_page);
 		}
 
 		hd_info->frag_page = NULL;
@@ -833,8 +830,8 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
-	/* Don't recycle, this function is called on rq/netdev close */
-	mlx5e_free_rx_mpwqe(rq, wi, false);
+	/* This function is called on rq/netdev close. */
+	mlx5e_free_rx_mpwqe(rq, wi);
 }
 
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
@@ -1058,7 +1055,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 		struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, head);
 
 		/* Deferred free for better page pool cache usage. */
-		mlx5e_free_rx_mpwqe(rq, wi, true);
+		mlx5e_free_rx_mpwqe(rq, wi);
 
 		alloc_err = rq->xsk_pool ? mlx5e_xsk_alloc_rx_mpwqe(rq, head) :
 					   mlx5e_alloc_rx_mpwqe(rq, head);
@@ -1739,7 +1736,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 			int i;
 
 			for (i = wi - head_wi; i < rq->wqe.info.num_frags; i++)
-				mlx5e_put_rx_frag(rq, &head_wi[i], true);
+				mlx5e_put_rx_frag(rq, &head_wi[i]);
 		}
 		return NULL; /* page/packet was consumed by XDP */
 	}
@@ -2158,7 +2155,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 		struct mlx5e_dma_info *dma_info = &shampo->info[header_index];
 
 		dma_info->addr = ALIGN_DOWN(addr, PAGE_SIZE);
-		mlx5e_page_release_fragmented(rq, dma_info->frag_page, true);
+		mlx5e_page_release_fragmented(rq, dma_info->frag_page);
 	}
 	bitmap_clear(shampo->bitmap, header_index, 1);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 4478223c1720..f1d9596905c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -179,11 +179,6 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_buff_alloc_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_blks) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_pkts) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_reuse) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_full) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_empty) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_busy) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_waive) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
@@ -358,11 +353,6 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_buff_alloc_err          += rq_stats->buff_alloc_err;
 	s->rx_cqe_compress_blks       += rq_stats->cqe_compress_blks;
 	s->rx_cqe_compress_pkts       += rq_stats->cqe_compress_pkts;
-	s->rx_cache_reuse             += rq_stats->cache_reuse;
-	s->rx_cache_full              += rq_stats->cache_full;
-	s->rx_cache_empty             += rq_stats->cache_empty;
-	s->rx_cache_busy              += rq_stats->cache_busy;
-	s->rx_cache_waive             += rq_stats->cache_waive;
 	s->rx_congst_umr              += rq_stats->congst_umr;
 	s->rx_arfs_err                += rq_stats->arfs_err;
 	s->rx_recover                 += rq_stats->recover;
@@ -1978,11 +1968,6 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_blks) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_reuse) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_full) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_empty) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_busy) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_waive) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
@@ -2163,11 +2148,6 @@ static const struct counter_desc ptp_rq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cqe_compress_blks) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) },
-	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_reuse) },
-	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_full) },
-	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_empty) },
-	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_busy) },
-	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, cache_waive) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_PTP_RQ_STAT(struct mlx5e_rq_stats, recover) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index b77100b60b50..1ff8a06027dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -193,11 +193,6 @@ struct mlx5e_sw_stats {
 	u64 rx_buff_alloc_err;
 	u64 rx_cqe_compress_blks;
 	u64 rx_cqe_compress_pkts;
-	u64 rx_cache_reuse;
-	u64 rx_cache_full;
-	u64 rx_cache_empty;
-	u64 rx_cache_busy;
-	u64 rx_cache_waive;
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
@@ -362,11 +357,6 @@ struct mlx5e_rq_stats {
 	u64 buff_alloc_err;
 	u64 cqe_compress_blks;
 	u64 cqe_compress_pkts;
-	u64 cache_reuse;
-	u64 cache_full;
-	u64 cache_empty;
-	u64 cache_busy;
-	u64 cache_waive;
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
-- 
2.39.2

