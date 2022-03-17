Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A74DCE2E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiCQSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiCQSzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C131163E38
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E034A617AF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D68AC340EE;
        Thu, 17 Mar 2022 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543271;
        bh=x+j2LBCcjtTAhBTHk4BTfWYPGLA24eLr+PXgaIxEYjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBvjquxC0qzRIREl+XDjs8/SWjB6+ncjdRjNpMsYsJDL/1QWbRy5ct61n77FQ/OY1
         VaUqPg+aii/+Vmo0F0vungwMgQcepvfmENPbl8rrTLK+sB/yQ7MeK116TOVkdp0nbR
         x54LIEOtr2HsqgephVAPKgCukVlKSq5sJllurLNftxBz62dIEp10TXmsUwBBHolq9U
         p0ptXjRnP7fgw4Al4bRAHwQImsIaw0BdIfnuj5t6gVGD8bkhDsCBayYt803y5rCWl/
         3i7fwnw0rDe6/luMVmJIxFGtF6ZkwAW6glZv0Tt2aNOiQapdEVgPrWbX9aFMye15AN
         0JDyKoZBpjWFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Drop cqe_bcnt32 from mlx5e_skb_from_cqe_mpwrq_linear
Date:   Thu, 17 Mar 2022 11:54:15 -0700
Message-Id: <20220317185424.287982-7-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The packet size in mlx5e_skb_from_cqe_mpwrq_linear can't overflow u16,
since the maximum packet size in linear striding RQ is 2^13 bytes. Drop
the unneeded u32 variable.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7c490c0ca370..4b8699f39200 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1848,7 +1848,6 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 {
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
-	u32 cqe_bcnt32 = cqe_bcnt;
 	struct bpf_prog *prog;
 	struct sk_buff *skb;
 	u32 metasize = 0;
@@ -1863,7 +1862,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	va             = page_address(di->page) + head_offset;
 	data           = va + rx_headroom;
-	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
+	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, head_offset,
 				      frag_size, DMA_FROM_DEVICE);
@@ -1874,7 +1873,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		struct xdp_buff xdp;
 
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
+		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
 		if (mlx5e_xdp_handle(rq, di, prog, &xdp)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
@@ -1883,10 +1882,10 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		rx_headroom = xdp.data - xdp.data_hard_start;
 		metasize = xdp.data - xdp.data_meta;
-		cqe_bcnt32 = xdp.data_end - xdp.data;
+		cqe_bcnt = xdp.data_end - xdp.data;
 	}
-	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
-	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32, metasize);
+	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
+	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.35.1

