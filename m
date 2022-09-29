Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D75EEEDE
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiI2HX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiI2HW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71023115BF5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F195B82365
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DABC433D6;
        Thu, 29 Sep 2022 07:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436170;
        bh=Bvp/Gu9peSgGwbXU7xNsRZVN+8UyrX+GClF2vyQrN8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty9v4h8DbT/SNhKVOYDNTYTWr2mPmM4U9YAjpI3e0EhtOso0shZ4FiL0mZ5uK2U9c
         pQ0PfaxFmjoKjHhSbnxzsBHgGjxbRVXsl/n45i9+3ui7sY88JnMQ5eJZ1NxpHbKm2T
         FaLHbxzQ+S+hSWPVxp88FwJ0J7eTiYOXcEX5OQSkI+9Ii9TYetlGbO3B6Ve9uy3cJF
         aO3p/xPqJW1/ilEYbYBQAjS8JFyK/Mvnz5pcsZm4TY8fl11KBha3n5Ky821C4tx9h9
         EEvIoWmSrItKJvsyYtU9FAQsThqlaF0cbHoYhPYOXZPsiJq9WQzz7FPI0ANRNDxHR5
         FzxR+ZfpM3HuA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 12/16] net/mlx5e: Convert struct mlx5e_alloc_unit to a union
Date:   Thu, 29 Sep 2022 00:21:52 -0700
Message-Id: <20220929072156.93299-13-saeed@kernel.org>
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

struct mlx5e_alloc_unit consists of a single union. Convert it to a
union itself to simplify casting it to struct xdp_buff *, which will be
used to implement XSK batching on striding RQ.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 14 ++++----
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 36 +++++++++----------
 4 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 944bf4c92582..95a232fb2127 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -474,11 +474,9 @@ struct mlx5e_txqsq {
 	cqe_ts_to_ns               ptp_cyc2time;
 } ____cacheline_aligned_in_smp;
 
-struct mlx5e_alloc_unit {
-	union {
-		struct page *page;
-		struct xdp_buff *xsk;
-	};
+union mlx5e_alloc_unit {
+	struct page *page;
+	struct xdp_buff *xsk;
 };
 
 /* XDP packets can be transmitted in different ways. On completion, we need to
@@ -607,7 +605,7 @@ struct mlx5e_icosq {
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_wqe_frag_info {
-	struct mlx5e_alloc_unit *au;
+	union mlx5e_alloc_unit *au;
 	u32 offset;
 	bool last_in_page;
 };
@@ -615,7 +613,7 @@ struct mlx5e_wqe_frag_info {
 struct mlx5e_mpw_info {
 	u16 consumed_strides;
 	DECLARE_BITMAP(xdp_xmit_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
-	struct mlx5e_alloc_unit alloc_units[];
+	union mlx5e_alloc_unit alloc_units[];
 };
 
 #define MLX5E_MAX_RX_FRAGS 4
@@ -694,7 +692,7 @@ struct mlx5e_rq {
 		struct {
 			struct mlx5_wq_cyc          wq;
 			struct mlx5e_wqe_frag_info *frags;
-			struct mlx5e_alloc_unit    *alloc_units;
+			union mlx5e_alloc_unit     *alloc_units;
 			struct mlx5e_rq_frags_info  info;
 			mlx5e_fp_skb_from_cqe       skb_from_cqe;
 		} wqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index d6dddad890e9..53a833c9b09e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -19,7 +19,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      u32 cqe_bcnt);
 
 static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
-					    struct mlx5e_alloc_unit *au)
+					    union mlx5e_alloc_unit *au)
 {
 	au->xsk = xsk_buff_alloc(rq->xsk_pool);
 	if (!au->xsk)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47d60a53727f..b9591f902760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -460,7 +460,7 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 		prev->last_in_page = true;
 }
 
-static int mlx5e_init_di_list(struct mlx5e_rq *rq, int wq_sz, int node)
+static int mlx5e_init_au_list(struct mlx5e_rq *rq, int wq_sz, int node)
 {
 	int len = wq_sz << rq->wqe.info.log_num_frags;
 
@@ -474,7 +474,7 @@ static int mlx5e_init_di_list(struct mlx5e_rq *rq, int wq_sz, int node)
 	return 0;
 }
 
-static void mlx5e_free_di_list(struct mlx5e_rq *rq)
+static void mlx5e_free_au_list(struct mlx5e_rq *rq)
 {
 	kvfree(rq->wqe.alloc_units);
 }
@@ -693,7 +693,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			goto err_rq_wq_destroy;
 		}
 
-		err = mlx5e_init_di_list(rq, wq_sz, node);
+		err = mlx5e_init_au_list(rq, wq_sz, node);
 		if (err)
 			goto err_rq_frags;
 	}
@@ -792,7 +792,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		mlx5e_free_di_list(rq);
+		mlx5e_free_au_list(rq);
 err_rq_frags:
 		kvfree(rq->wqe.frags);
 	}
@@ -826,7 +826,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		kvfree(rq->wqe.frags);
-		mlx5e_free_di_list(rq);
+		mlx5e_free_au_list(rq);
 	}
 
 	for (i = rq->page_cache.head; i != rq->page_cache.tail;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a3891a88863e..0d0064d66c09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -250,7 +250,7 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
 	return true;
 }
 
-static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct mlx5e_alloc_unit *au)
+static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
 {
 	struct mlx5e_page_cache *cache = &rq->page_cache;
 	struct mlx5e_rq_stats *stats = rq->stats;
@@ -276,7 +276,7 @@ static inline bool mlx5e_rx_cache_get(struct mlx5e_rq *rq, struct mlx5e_alloc_un
 	return true;
 }
 
-static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct mlx5e_alloc_unit *au)
+static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
 {
 	dma_addr_t addr;
 
@@ -300,7 +300,7 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq, struct mlx5e_alloc_
 	return 0;
 }
 
-static inline int mlx5e_page_alloc(struct mlx5e_rq *rq, struct mlx5e_alloc_unit *au)
+static inline int mlx5e_page_alloc(struct mlx5e_rq *rq, union mlx5e_alloc_unit *au)
 {
 	if (rq->xsk_pool)
 		return mlx5e_xsk_page_alloc_pool(rq, au);
@@ -333,7 +333,7 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool rec
 }
 
 static inline void mlx5e_page_release(struct mlx5e_rq *rq,
-				      struct mlx5e_alloc_unit *au,
+				      union mlx5e_alloc_unit *au,
 				      bool recycle)
 {
 	if (rq->xsk_pool)
@@ -458,7 +458,7 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 
 static inline void
 mlx5e_add_skb_frag(struct mlx5e_rq *rq, struct sk_buff *skb,
-		   struct mlx5e_alloc_unit *au, u32 frag_offset, u32 len,
+		   union mlx5e_alloc_unit *au, u32 frag_offset, u32 len,
 		   unsigned int truesize)
 {
 	dma_addr_t addr = page_pool_get_dma_addr(au->page);
@@ -485,7 +485,7 @@ mlx5e_copy_skb_header(struct device *pdev, struct sk_buff *skb,
 static void
 mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle)
 {
-	struct mlx5e_alloc_unit *alloc_units = wi->alloc_units;
+	union mlx5e_alloc_unit *alloc_units = wi->alloc_units;
 	bool no_xdp_xmit;
 	int i;
 
@@ -582,7 +582,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		header_offset = (index & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) <<
 			MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
 		if (!(header_offset & (PAGE_SIZE - 1))) {
-			struct mlx5e_alloc_unit au;
+			union mlx5e_alloc_unit au;
 
 			err = mlx5e_page_alloc(rq, &au);
 			if (unlikely(err))
@@ -620,7 +620,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	while (--i >= 0) {
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
-			struct mlx5e_alloc_unit au = {
+			union mlx5e_alloc_unit au = {
 				.page = dma_info->page,
 			};
 
@@ -674,7 +674,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = mlx5e_get_mpw_info(rq, ix);
-	struct mlx5e_alloc_unit *au = &wi->alloc_units[0];
+	union mlx5e_alloc_unit *au = &wi->alloc_units[0];
 	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
@@ -791,7 +791,7 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 		hd_info = &shampo->info[index];
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
 		if (hd_info->page != deleted_page) {
-			struct mlx5e_alloc_unit au = {
+			union mlx5e_alloc_unit au = {
 				.page = hd_info->page,
 			};
 
@@ -1571,7 +1571,7 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 			  u32 cqe_bcnt)
 {
-	struct mlx5e_alloc_unit *au = wi->au;
+	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
@@ -1619,7 +1619,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	struct mlx5e_alloc_unit *au = wi->au;
+	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
 	struct skb_shared_info *sinfo;
 	u32 frag_consumed_bytes;
@@ -1899,7 +1899,7 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
 static void
 mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
-		    struct mlx5e_alloc_unit *au, u32 data_bcnt, u32 data_offset)
+		    union mlx5e_alloc_unit *au, u32 data_bcnt, u32 data_offset)
 {
 	net_prefetchw(skb->data);
 
@@ -1926,11 +1926,11 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
-	struct mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
+	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
 	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
-	struct mlx5e_alloc_unit *head_au = au;
+	union mlx5e_alloc_unit *head_au = au;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 
@@ -1965,7 +1965,7 @@ static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
-	struct mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
+	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
@@ -2107,7 +2107,7 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 	u64 addr = shampo->info[header_index].addr;
 
 	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
-		struct mlx5e_alloc_unit au = {
+		union mlx5e_alloc_unit au = {
 			.page = shampo->info[header_index].page,
 		};
 
@@ -2133,7 +2133,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	bool match		= cqe->shampo.match;
 	struct mlx5e_rq_stats *stats = rq->stats;
 	struct mlx5e_rx_wqe_ll *wqe;
-	struct mlx5e_alloc_unit *au;
+	union mlx5e_alloc_unit *au;
 	struct mlx5e_mpw_info *wi;
 	struct mlx5_wq_ll *wq;
 
-- 
2.37.3

