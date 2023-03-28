Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6A96CCBB2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjC1U5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjC1U5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE86830FC
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B65CB81E78
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EEBC433D2;
        Tue, 28 Mar 2023 20:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037018;
        bh=ACuZM5mn/z7yxWUzKVu6rqlVqqaQnPuK1nHIQV8xI8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DL6unPXM7SauToeCJSxBOF2KK9Ym7CVngxNMYs0OdeS15La7LiCSK3jpS0ttpe6pP
         r6G+Cs4shkU5gSWeTEsr2MhiExBs2SYSooyKdEP4UPosU6FcN9vnibTjl8kCMSv4De
         YeSC8U+qkXH3rbCid2lT80/PqWC04odJn4ubVEac1c9HsZtGYEoWcaTYAbuyKckLK3
         9JNMacBujXNEwu+OBdm1kTlL9p6WOUKJ8paR+qSH/bH9ShLZ1H+UomKjJOr9Z5uz0W
         sRnwvCv0pzSjihr6dGiJw9J/nDGI36jNml/f2sRFE1sDnqmxmyMACUzxEKdAJCUmr5
         KMnJaZZS78F9A==
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
Subject: [net-next 12/15] net/mlx5e: RX, Split off release path for xsk buffers for legacy rq
Date:   Tue, 28 Mar 2023 13:56:20 -0700
Message-Id: <20230328205623.142075-13-saeed@kernel.org>
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

Don't mix xsk buffer releases with page releases anymore. This is
needed for handling of deferred page release.

Add a new bulk free function for xsk buffers from wqe frags.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 50 +++++++++++++------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0675ffa5f8df..9c5270eb9dc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -379,24 +379,42 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 {
 	int i;
 
-	if (rq->xsk_pool && !(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))) {
-		/* The `recycle` parameter is ignored, and the page is always
-		 * put into the Reuse Ring, because there is no way to return
-		 * the page to the userspace when the interface goes down.
-		 */
-		xsk_buff_free(*wi->xskp);
-		return;
-	}
-
 	for (i = 0; i < rq->wqe.info.num_frags; i++, wi++)
 		mlx5e_put_rx_frag(rq, wi, recycle);
 }
 
+static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
+{
+	if (!(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE)))
+		xsk_buff_free(*wi->xskp);
+}
+
 static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_wqe_frag_info *wi = get_frag(rq, ix);
 
-	mlx5e_free_rx_wqe(rq, wi, false);
+	if (rq->xsk_pool)
+		mlx5e_xsk_free_rx_wqe(wi);
+	else
+		mlx5e_free_rx_wqe(rq, wi, false);
+}
+
+static void mlx5e_xsk_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
+{
+	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	int i;
+
+	for (i = 0; i < wqe_bulk; i++) {
+		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
+		struct mlx5e_wqe_frag_info *wi;
+
+		wi = get_frag(rq, j);
+		/* The page is always put into the Reuse Ring, because there
+		 * is no way to return the page to the userspace when the
+		 * interface goes down.
+		 */
+		mlx5e_xsk_free_rx_wqe(wi);
+	}
 }
 
 static void mlx5e_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
@@ -818,19 +836,21 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	 */
 	wqe_bulk -= (head + wqe_bulk) & rq->wqe.info.wqe_index_mask;
 
-	mlx5e_free_rx_wqes(rq, head, wqe_bulk);
-
-	if (!rq->xsk_pool)
+	if (!rq->xsk_pool) {
+		mlx5e_free_rx_wqes(rq, head, wqe_bulk);
 		count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
-	else if (likely(!rq->xsk_pool->dma_need_sync))
+	} else if (likely(!rq->xsk_pool->dma_need_sync)) {
+		mlx5e_xsk_free_rx_wqes(rq, head, wqe_bulk);
 		count = mlx5e_xsk_alloc_rx_wqes_batched(rq, head, wqe_bulk);
-	else
+	} else {
+		mlx5e_xsk_free_rx_wqes(rq, head, wqe_bulk);
 		/* If dma_need_sync is true, it's more efficient to call
 		 * xsk_buff_alloc in a loop, rather than xsk_buff_alloc_batch,
 		 * because the latter does the same check and returns only one
 		 * frame.
 		 */
 		count = mlx5e_xsk_alloc_rx_wqes(rq, head, wqe_bulk);
+	}
 
 	mlx5_wq_cyc_push_n(wq, count);
 	if (unlikely(count != wqe_bulk)) {
-- 
2.39.2

