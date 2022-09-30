Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA305F1002
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiI3Qac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiI3QaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFD312740
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46132622AA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9478DC433C1;
        Fri, 30 Sep 2022 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555379;
        bh=HN81YAxkG6mQs8jr5/Dvh3YZuYgf+sClirYIzDZv68Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYnVarI0Fo0FpwTQ+2kI6EpHPOc5d58jpqWtbyf5692jQSyvnXg4/ufIFmqZRcDd5
         41xd3/wQubNNg3kn0qtdwmFNQposCuOYG4KwHt0/D4vyUllK3zzHAUN6haKjyjrqYO
         ByGUXEyapQ/qh0cPYsbAeVHwBQrLteeHVOVGjCSpkja51xZyMjrP5FprS03aNsrAfc
         TUflYSelaDKFjFiz8Q5qdSPe+rfrkjYYFzwoOPVrY87eaVL0Vnnutt2K2p3Oxr0eP4
         /TyXEgnYJwBvNMtlAMa1nRstx3UJyZ45beGgBk5tDIrAdUlwJkG7gtT8DKV/SHPWDu
         JWjgCpc7VT2DA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 13/16] net/mlx5e: Optimize RQ page deallocation
Date:   Fri, 30 Sep 2022 09:29:00 -0700
Message-Id: <20220930162903.62262-14-saeed@kernel.org>
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

mlx5e_free_rx_mpwqe loops over all pages of a MPWQE, calling
mlx5e_page_release for ones that are not scheduled for XDP_TX or
XDP_REDIRECT; and mlx5e_page_release checks whether it's an XSK RQ or a
regular one for each page/XSK frame. This check can be moved outside the
loop to reduce the number of branches.

mlx5e_free_rx_wqe loops over all fragments, calling mlx5e_page_release
for the ones that are last in a page; and mlx5e_page_release checks
whether it's an XSK RQ or a regular one for each fragment. Using the
fact that XSK doesn't support multiple fragments, it can be optimized
for both XSK and regular usages:

1. Make an early check for XSK and call its deallocator directly, saving
3 branches (loop condition, frag->last_in_page and selection of
deallocator).

2. Call the regular deallocator directly in the non-XSK case, saving a
branch per fragment, except the first one.

After the changes, mlx5e_page_release is removed, as there are no
callers left.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 41 +++++++++++--------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 7bd49f0b1271..661d2d5748f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -253,7 +253,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
-	 * will be handled by mlx5e_put_rx_frag.
+	 * will be handled by mlx5e_free_rx_wqe.
 	 * On SKB allocation failure, NULL is returned.
 	 */
 	return mlx5e_xsk_construct_skb(rq, xdp->data, xdp->data_end - xdp->data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d0db6a66cb46..36eda4c958a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -317,20 +317,6 @@ void mlx5e_page_release_dynamic(struct mlx5e_rq *rq, struct page *page, bool rec
 	}
 }
 
-static inline void mlx5e_page_release(struct mlx5e_rq *rq,
-				      union mlx5e_alloc_unit *au,
-				      bool recycle)
-{
-	if (rq->xsk_pool)
-		/* The `recycle` parameter is ignored, and the page is always
-		 * put into the Reuse Ring, because there is no way to return
-		 * the page to the userspace when the interface goes down.
-		 */
-		xsk_buff_free(au->xsk);
-	else
-		mlx5e_page_release_dynamic(rq, au->page, recycle);
-}
-
 static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 				    struct mlx5e_wqe_frag_info *frag)
 {
@@ -352,7 +338,7 @@ static inline void mlx5e_put_rx_frag(struct mlx5e_rq *rq,
 				     bool recycle)
 {
 	if (frag->last_in_page)
-		mlx5e_page_release(rq, frag->au, recycle);
+		mlx5e_page_release_dynamic(rq, frag->au->page, recycle);
 }
 
 static inline struct mlx5e_wqe_frag_info *get_frag(struct mlx5e_rq *rq, u16 ix)
@@ -395,6 +381,15 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 {
 	int i;
 
+	if (rq->xsk_pool) {
+		/* The `recycle` parameter is ignored, and the page is always
+		 * put into the Reuse Ring, because there is no way to return
+		 * the page to the userspace when the interface goes down.
+		 */
+		xsk_buff_free(wi->au->xsk);
+		return;
+	}
+
 	for (i = 0; i < rq->wqe.info.num_frags; i++, wi++)
 		mlx5e_put_rx_frag(rq, wi, recycle);
 }
@@ -463,9 +458,19 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 
 	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
 
-	for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
-		if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-			mlx5e_page_release(rq, &alloc_units[i], recycle);
+	if (rq->xsk_pool) {
+		/* The `recycle` parameter is ignored, and the page is always
+		 * put into the Reuse Ring, because there is no way to return
+		 * the page to the userspace when the interface goes down.
+		 */
+		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
+			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
+				xsk_buff_free(alloc_units[i].xsk);
+	} else {
+		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
+			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
+				mlx5e_page_release_dynamic(rq, alloc_units[i].page, recycle);
+	}
 }
 
 static void mlx5e_post_rx_mpwqe(struct mlx5e_rq *rq, u8 n)
-- 
2.37.3

