Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFD6CCBAA
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjC1U5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjC1U4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDCC268C
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71631B81E6F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB7C433D2;
        Tue, 28 Mar 2023 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037009;
        bh=Gj0wdNiZzBU8cCyvc8xfdkZidQy3c6XwjJ+cVoKkAVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FT8mcKleAWv5r1Hdvv0pk8UONw5ZfSYF/x5sj/36PoMt1uR8DsDTLtd0RlEn/h4Na
         fiT2J7QdBpVCFaHSz8E0Fz5IqhOMCyzIF69UdzD8uzoEsfQ7d4aPgc6yIyUyE+iy0O
         TfY4hYEnn8pOlRQfNDTNegaF8Va3U7dQBPI9CXSHnfpsscPbTTysfjikydFW26W36l
         yLnyE12kdo7zMqPmVyJ6K+YA6ObGOkyHz49aQq9iF2waWU66IchogGVS9hlZut819X
         VC85C8xUFC34s1pz10XMNnNVPlwpGMQE56sgGHC1qPvqG87Djy24vtxoPyTmepz8ry
         y9TxlW87lpW4Q==
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
Subject: [net-next 04/15] net/mlx5e: RX, Store SHAMPO header pages in array
Date:   Tue, 28 Mar 2023 13:56:12 -0700
Message-Id: <20230328205623.142075-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

Save allocated SHAMPO header pages to an array to which the
mlx5e_dma_info page will point to.

This change is a preparation for introducing mlx5e_frag_page structure
in a downstream patch. There's no new functionality introduced.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 +++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 ++++++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 42 +++++++++++--------
 3 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ad4ad14853bf..b38fbacbb4d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -670,13 +670,17 @@ struct mlx5e_rq_frags_info {
 
 struct mlx5e_dma_info {
 	dma_addr_t addr;
-	struct page *page;
+	union {
+		struct page **pagep;
+		struct page *page;
+	};
 };
 
 struct mlx5e_shampo_hd {
 	u32 mkey;
 	struct mlx5e_dma_info *info;
-	struct page *last_page;
+	struct page **pages;
+	u16 curr_page_index;
 	u16 hd_per_wq;
 	u16 hd_per_wqe;
 	unsigned long *bitmap;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0ed3f67f7dfc..77f81d74ff30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -262,23 +262,30 @@ static int mlx5e_rq_shampo_hd_info_alloc(struct mlx5e_rq *rq, int node)
 
 	shampo->bitmap = bitmap_zalloc_node(shampo->hd_per_wq, GFP_KERNEL,
 					    node);
-	if (!shampo->bitmap)
-		return -ENOMEM;
-
 	shampo->info = kvzalloc_node(array_size(shampo->hd_per_wq,
 						sizeof(*shampo->info)),
 				     GFP_KERNEL, node);
-	if (!shampo->info) {
-		kvfree(shampo->bitmap);
-		return -ENOMEM;
-	}
+	shampo->pages = kvzalloc_node(array_size(shampo->hd_per_wq,
+						 sizeof(*shampo->pages)),
+				     GFP_KERNEL, node);
+	if (!shampo->bitmap || !shampo->info || !shampo->pages)
+		goto err_nomem;
+
 	return 0;
+
+err_nomem:
+	kvfree(shampo->info);
+	kvfree(shampo->bitmap);
+	kvfree(shampo->pages);
+
+	return -ENOMEM;
 }
 
 static void mlx5e_rq_shampo_hd_info_free(struct mlx5e_rq *rq)
 {
 	kvfree(rq->mpwqe.shampo->bitmap);
 	kvfree(rq->mpwqe.shampo->info);
+	kvfree(rq->mpwqe.shampo->pages);
 }
 
 static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq, int node)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d02f2f2af4ec..7057db954f6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -586,10 +586,11 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 	u16 entries, pi, header_offset, err, wqe_bbs, new_entries;
 	u32 lkey = rq->mdev->mlx5e_res.hw_objs.mkey;
-	struct page *page = shampo->last_page;
+	u16 page_index = shampo->curr_page_index;
 	u64 addr = shampo->last_addr;
 	struct mlx5e_dma_info *dma_info;
 	struct mlx5e_umr_wqe *umr_wqe;
+	struct page **pagep;
 	int headroom, i;
 
 	headroom = rq->buff.headroom;
@@ -600,6 +601,8 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	umr_wqe = mlx5_wq_cyc_get_wqe(&sq->wq, pi);
 	build_klm_umr(sq, umr_wqe, shampo->key, index, entries, wqe_bbs);
 
+	pagep = &shampo->pages[page_index];
+
 	for (i = 0; i < entries; i++, index++) {
 		dma_info = &shampo->info[index];
 		if (i >= klm_entries || (index < shampo->pi && shampo->pi - index <
@@ -608,17 +611,20 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		header_offset = (index & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) <<
 			MLX5E_SHAMPO_LOG_MAX_HEADER_ENTRY_SIZE;
 		if (!(header_offset & (PAGE_SIZE - 1))) {
+			page_index = (page_index + 1) & (shampo->hd_per_wq - 1);
+			pagep = &shampo->pages[page_index];
 
-			err = mlx5e_page_alloc_pool(rq, &page);
+			err = mlx5e_page_alloc_pool(rq, pagep);
 			if (unlikely(err))
 				goto err_unmap;
 
-			addr = page_pool_get_dma_addr(page);
+			addr = page_pool_get_dma_addr(*pagep);
+
 			dma_info->addr = addr;
-			dma_info->page = page;
+			dma_info->pagep = pagep;
 		} else {
 			dma_info->addr = addr + header_offset;
-			dma_info->page = page;
+			dma_info->pagep = pagep;
 		}
 
 update_klm:
@@ -636,7 +642,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 	};
 
 	shampo->pi = (shampo->pi + new_entries) & (shampo->hd_per_wq - 1);
-	shampo->last_page = page;
+	shampo->curr_page_index = page_index;
 	shampo->last_addr = addr;
 	sq->pc += wqe_bbs;
 	sq->doorbell_cseg = &umr_wqe->ctrl;
@@ -648,7 +654,7 @@ static int mlx5e_build_shampo_hd_umr(struct mlx5e_rq *rq,
 		dma_info = &shampo->info[--index];
 		if (!(i & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1))) {
 			dma_info->addr = ALIGN_DOWN(dma_info->addr, PAGE_SIZE);
-			mlx5e_page_release_dynamic(rq, dma_info->page, true);
+			mlx5e_page_release_dynamic(rq, *dma_info->pagep, true);
 		}
 	}
 	rq->stats->buff_alloc_err++;
@@ -783,7 +789,7 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 {
 	struct mlx5e_shampo_hd *shampo = rq->mpwqe.shampo;
 	int hd_per_wq = shampo->hd_per_wq;
-	struct page *deleted_page = NULL;
+	struct page **deleted_page = NULL;
 	struct mlx5e_dma_info *hd_info;
 	int i, index = start;
 
@@ -796,9 +802,9 @@ void mlx5e_shampo_dealloc_hd(struct mlx5e_rq *rq, u16 len, u16 start, bool close
 
 		hd_info = &shampo->info[index];
 		hd_info->addr = ALIGN_DOWN(hd_info->addr, PAGE_SIZE);
-		if (hd_info->page != deleted_page) {
-			deleted_page = hd_info->page;
-			mlx5e_page_release_dynamic(rq, hd_info->page, false);
+		if (hd_info->pagep != deleted_page) {
+			deleted_page = hd_info->pagep;
+			mlx5e_page_release_dynamic(rq, *hd_info->pagep, false);
 		}
 	}
 
@@ -1137,7 +1143,7 @@ static void *mlx5e_shampo_get_packet_hd(struct mlx5e_rq *rq, u16 header_index)
 	struct mlx5e_dma_info *last_head = &rq->mpwqe.shampo->info[header_index];
 	u16 head_offset = (last_head->addr & (PAGE_SIZE - 1)) + rq->buff.headroom;
 
-	return page_address(last_head->page) + head_offset;
+	return page_address(*last_head->pagep) + head_offset;
 }
 
 static void mlx5e_shampo_update_ipv4_udp_hdr(struct mlx5e_rq *rq, struct iphdr *ipv4)
@@ -2048,7 +2054,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	void *hdr, *data;
 	u32 frag_size;
 
-	hdr		= page_address(head->page) + head_offset;
+	hdr		= page_address(*head->pagep) + head_offset;
 	data		= hdr + rx_headroom;
 	frag_size	= MLX5_SKB_FRAG_SZ(rx_headroom + head_size);
 
@@ -2063,7 +2069,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			return NULL;
 
 		/* queue up for recycling/reuse */
-		page_ref_inc(head->page);
+		page_ref_inc(*head->pagep);
 
 	} else {
 		/* allocate SKB and copy header for large header */
@@ -2076,7 +2082,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		}
 
 		prefetchw(skb->data);
-		mlx5e_copy_skb_header(rq, skb, head->page, head->addr,
+		mlx5e_copy_skb_header(rq, skb, *head->pagep, head->addr,
 				      head_offset + rx_headroom,
 				      rx_headroom, head_size);
 		/* skb linear part was allocated with headlen and aligned to long */
@@ -2127,8 +2133,10 @@ mlx5e_free_rx_shampo_hd_entry(struct mlx5e_rq *rq, u16 header_index)
 	u64 addr = shampo->info[header_index].addr;
 
 	if (((header_index + 1) & (MLX5E_SHAMPO_WQ_HEADER_PER_PAGE - 1)) == 0) {
-		shampo->info[header_index].addr = ALIGN_DOWN(addr, PAGE_SIZE);
-		mlx5e_page_release_dynamic(rq, shampo->info[header_index].page, true);
+		struct mlx5e_dma_info *dma_info = &shampo->info[header_index];
+
+		dma_info->addr = ALIGN_DOWN(addr, PAGE_SIZE);
+		mlx5e_page_release_dynamic(rq, *dma_info->pagep, true);
 	}
 	bitmap_clear(shampo->bitmap, header_index, 1);
 }
-- 
2.39.2

