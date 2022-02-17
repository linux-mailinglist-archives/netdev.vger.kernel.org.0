Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC14B9A48
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiBQH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:56:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiBQH4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7958165C7
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1660E61B44
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363D2C340F3;
        Thu, 17 Feb 2022 07:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084595;
        bh=BZ5UROxJ3wX2zrZkPNVINOs2B12P3eU1/5eP+tUJhPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9uRF7okYtqJPzHiRl3tMW9KaiNKI5nI3IPkeLzaRhLCS6LwIIlqF5h+w2V0xMzJj
         w4lASmN1lm9gmMLp8P7oPpwaD4WSn4g7zmGOAqMw02UVbKSHgwfCAxHWYfvk1hw/6/
         6Fdsh+rMfKAmiYj+LD6iqTN+WhFzWA29h3niQmmt6fw5uMr5VZhqnGnaOw64A10Gjn
         964scABhFo4d/w2V9vQDoiFGUt2XyVHCbErLqPVVLLy/+1KxUuoJQslvTm7ZAOK/WH
         4P/iWKY8AbYC2iPO3FKYMRflIrTP6umul8GuA+XxySifTDTguTCw+isEHs0Dx64A5D
         Jfn3TCKhl/q1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alex Liu <liualex@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Add support for using xdp->data_meta
Date:   Wed, 16 Feb 2022 23:56:19 -0800
Message-Id: <20220217075632.831542-3-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Liu <liualex@fb.com>

Add support for using xdp->data_meta for cross-program communication

Pass "true" to the last argument of xdp_prepare_buff().

After SKB is built, call skb_metadata_set() if metadata was pushed.

Signed-off-by: Alex Liu <liualex@fb.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 91fdf957cd7c..3fe4f06f3e71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1489,7 +1489,7 @@ static inline void mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
 static inline
 struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 				       u32 frag_size, u16 headroom,
-				       u32 cqe_bcnt)
+				       u32 cqe_bcnt, u32 metasize)
 {
 	struct sk_buff *skb = build_skb(va, frag_size);
 
@@ -1501,6 +1501,9 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 	skb_reserve(skb, headroom);
 	skb_put(skb, cqe_bcnt);
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 	return skb;
 }
 
@@ -1508,7 +1511,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
-	xdp_prepare_buff(xdp, va, headroom, len, false);
+	xdp_prepare_buff(xdp, va, headroom, len, true);
 }
 
 static struct sk_buff *
@@ -1521,6 +1524,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
+	u32 metasize;
 
 	va             = page_address(di->page) + wi->offset;
 	data           = va + rx_headroom;
@@ -1537,7 +1541,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	rx_headroom = xdp.data - xdp.data_hard_start;
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
-	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
+	metasize = xdp.data - xdp.data_meta;
+	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -1836,6 +1841,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
+	u32 metasize;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -1861,7 +1867,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	rx_headroom = xdp.data - xdp.data_hard_start;
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
-	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
+	metasize = xdp.data - xdp.data_meta;
+	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32, metasize);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -1892,7 +1899,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		dma_sync_single_range_for_cpu(rq->pdev, head->addr, 0, frag_size, DMA_FROM_DEVICE);
 		prefetchw(hdr);
 		prefetch(data);
-		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size);
+		skb = mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_size, 0);
 
 		if (unlikely(!skb))
 			return NULL;
-- 
2.34.1

