Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57895F0FFF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiI3QaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiI3QaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5F812AE2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A182623DB
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B82EC433B5;
        Fri, 30 Sep 2022 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555380;
        bh=C5cwXTM95dP4hYzPMBboVzRq46tvrTsVSznlMlZX7x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHkbUPohrDi5mac9I6IF/zbhD0S6pjxQBU+1pbD1i6sxMXpGJC+KHI7cKeaZvllen
         W8BV/ETsomuxiVXuDqab8HC+zJgtSjkaTAg8V3Y0t5GfRdL/NQnYOQYJweObmOnIQi
         jwkZ2ucjfaQ5pkq518sMK6vYbtw36ISSPyWQ/EMcQkTgh+IlgNi8lUmfe5ntfnFDeN
         NiasvGU+s+eLLT21335gPX/+DtawtdkcWVl3N4D4h6aFdgADfNJHF0hWGlMpKtzRhU
         rKm0IScjWcUg3MWT0L/kYHlcDXFRRAWzhRCvbqe4/bvST/sP5WkTxiF8HOlVD+uzcM
         Y6BQrEl604vrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 14/16] net/mlx5e: xsk: Support XDP metadata on XSK RQs
Date:   Fri, 30 Sep 2022 09:29:01 -0700
Message-Id: <20220930162903.62262-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
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

Add support for XDP metadata on XSK RQs for cross-program
communication. The driver no longer calls xdp_set_data_meta_invalid and
copies the metadata to a newly allocated SKB on XDP_PASS.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 661d2d5748f4..aebc1d5a9004 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -158,18 +158,24 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 	return wqe_bulk;
 }
 
-static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
-					       u32 cqe_bcnt)
+static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, struct xdp_buff *xdp)
 {
+	u32 totallen = xdp->data_end - xdp->data_meta;
+	u32 metalen = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
 
-	skb = napi_alloc_skb(rq->cq.napi, cqe_bcnt);
+	skb = napi_alloc_skb(rq->cq.napi, totallen);
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
 	}
 
-	skb_put_data(skb, data, cqe_bcnt);
+	skb_put_data(skb, xdp->data_meta, totallen);
+
+	if (metalen) {
+		skb_metadata_set(skb, metalen);
+		__skb_pull(skb, metalen);
+	}
 
 	return skb;
 }
@@ -197,7 +203,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	WARN_ON_ONCE(head_offset);
 
 	xsk_buff_set_size(xdp, cqe_bcnt);
-	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
 
@@ -226,7 +231,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
 	 * frame. On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp->data, xdp->data_end - xdp->data);
+	return mlx5e_xsk_construct_skb(rq, xdp);
 }
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
@@ -244,7 +249,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	WARN_ON_ONCE(wi->offset);
 
 	xsk_buff_set_size(xdp, cqe_bcnt);
-	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
 
@@ -256,5 +260,5 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	 * will be handled by mlx5e_free_rx_wqe.
 	 * On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp->data, xdp->data_end - xdp->data);
+	return mlx5e_xsk_construct_skb(rq, xdp);
 }
-- 
2.37.3

