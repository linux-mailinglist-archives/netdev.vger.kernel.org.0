Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9F54A6B34
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiBBFGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05ADC061749
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FC6461731
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EDEC340EB;
        Wed,  2 Feb 2022 05:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778397;
        bh=Y4ly5RAaQaZlRpdm2r9UDeUXWPPuSDhaERFDfpl2bZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUT9g24Ja7OrUyicBV79ayFYM04v/ybAN9gO0wUC23no737Vuah/zS0NkRJmTLzze
         ol0wN1OHSqEy8JIWwkzPf7y9Ag+n4phuu8exvMULIuS17QwNR2NjjrnUzxjxk1HdQv
         6IWfrPe5gw8aO1JrVaWQ2g7xIN5CcjnyUCeJr0bodNgP7TCeCw17OH6ebxw0q3dJXI
         rr3Y38t4t+SOF9OtegA+lB2VFmhKQnOPgCYs5RpPAimPpjzEYCqZPntwscGsqI7fp5
         MoLVc0tzNP6cuQPvjv28Bgwe4B55qZ821VMXTCfLyD5MtoSSuekFcV8Wt+tQv0BB9f
         hkaSaAX9Z7mug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Khalid Manaa <khalidm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/18] net/mlx5e: Fix broken SKB allocation in HW-GRO
Date:   Tue,  1 Feb 2022 21:03:56 -0800
Message-Id: <20220202050404.100122-11-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

In case the HW doesn't perform header-data split, it will write the whole
packet into the data buffer in the WQ, in this case the SHAMPO CQE handler
couldn't use the header entry to build the SKB, instead it should allocate
a new memory to build the SKB using the function:
mlx5e_skb_from_cqe_mpwrq_nonlinear.

Fixes: f97d5c2a453e ("net/mlx5e: Add handle SHAMPO cqe support")
Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 26 ++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3a79ecd38003..ee0a8f5206e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1871,7 +1871,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	return skb;
 }
 
-static void
+static struct sk_buff *
 mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			  struct mlx5_cqe64 *cqe, u16 header_index)
 {
@@ -1895,7 +1895,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size);
 
 		if (unlikely(!skb))
-			return;
+			return NULL;
 
 		/* queue up for recycling/reuse */
 		page_ref_inc(head->page);
@@ -1907,7 +1907,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				     ALIGN(head_size, sizeof(long)));
 		if (unlikely(!skb)) {
 			rq->stats->buff_alloc_err++;
-			return;
+			return NULL;
 		}
 
 		prefetchw(skb->data);
@@ -1918,9 +1918,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		skb->tail += head_size;
 		skb->len  += head_size;
 	}
-	rq->hw_gro_data->skb = skb;
-	NAPI_GRO_CB(skb)->count = 1;
-	skb_shinfo(skb)->gso_size = mpwrq_get_cqe_byte_cnt(cqe) - head_size;
+	return skb;
 }
 
 static void
@@ -1980,6 +1978,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	u32 cqe_bcnt		= mpwrq_get_cqe_byte_cnt(cqe);
 	u16 wqe_id		= be16_to_cpu(cqe->wqe_id);
 	u32 page_idx		= wqe_offset >> PAGE_SHIFT;
+	u16 head_size		= cqe->shampo.header_size;
 	struct sk_buff **skb	= &rq->hw_gro_data->skb;
 	bool flush		= cqe->shampo.flush;
 	bool match		= cqe->shampo.match;
@@ -2011,9 +2010,16 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (!*skb) {
-		mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
+		if (likely(head_size))
+			*skb = mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
+		else
+			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe_bcnt, data_offset,
+								  page_idx);
 		if (unlikely(!*skb))
 			goto free_hd_entry;
+
+		NAPI_GRO_CB(*skb)->count = 1;
+		skb_shinfo(*skb)->gso_size = cqe_bcnt - head_size;
 	} else {
 		NAPI_GRO_CB(*skb)->count++;
 		if (NAPI_GRO_CB(*skb)->count == 2 &&
@@ -2027,8 +2033,10 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 		}
 	}
 
-	di = &wi->umr.dma_info[page_idx];
-	mlx5e_fill_skb_data(*skb, rq, di, data_bcnt, data_offset);
+	if (likely(head_size)) {
+		di = &wi->umr.dma_info[page_idx];
+		mlx5e_fill_skb_data(*skb, rq, di, data_bcnt, data_offset);
+	}
 
 	mlx5e_shampo_complete_rx_cqe(rq, cqe, cqe_bcnt, *skb);
 	if (flush)
-- 
2.34.1

