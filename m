Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3C5F0FFA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiI3Q3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiI3Q3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4753F5F80
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D78CD622AA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346FBC433D6;
        Fri, 30 Sep 2022 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555373;
        bh=VBLYSQiEU5GR8zWNTIE+1X7e84OcbdW2H0E/dJrdTig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok3OMHkwAzGMA22GIC1bbal1w/eRpAxtkcQ1LMz1T9g2LqVOizUiKBJYf1CiaEUqs
         NKfaBaXoLI6gPgh5Anelu2LJhhvLRhc8QPhni4+DPWLNJAmLM4anjtilm/8H81BYic
         3TAmNHRgQLna5F0WIfdcBX45QVIBoQYkfQ8Gl3tfSpkyxylmo4JTIvFFz5W3AU9M6b
         Ga3LUtdl6KmXaeXJ4DUKmi+V1ELoB0tHh5xFCAl4xkzsWbw1Vb8uC1z2zaVllike5Z
         Gth161oF+v2I4ePadr1omowFL2cIVc6dvs3VaQShsSc7ju7oNHxkQ/4WZpr41pCT+X
         S53b/kuwKCVfw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 07/16] net/mlx5e: Remove the outer loop when allocating legacy RQ WQEs
Date:   Fri, 30 Sep 2022 09:28:54 -0700
Message-Id: <20220930162903.62262-8-saeed@kernel.org>
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

Legacy RQ WQEs are allocated in a loop in small batches (8 WQEs). As
partial batches are allowed, there is no point to have a loop in a loop,
so the outer loop is removed, and the batch size is increased up to the
total number of WQEs to allocate, still not smaller than 8.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 37 ++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |  2 +-
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 80f2b5960782..d620c1ed9b80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -424,7 +424,7 @@ static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 	mlx5e_free_rx_wqe(rq, wi, false);
 }
 
-static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
+static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	int i;
@@ -805,38 +805,33 @@ static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	int wqe_bulk, count;
 	bool busy = false;
-	u8 wqe_bulk;
+	u16 head;
 
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return false;
 
-	wqe_bulk = rq->wqe.info.wqe_bulk;
-
-	if (mlx5_wq_cyc_missing(wq) < wqe_bulk)
+	if (mlx5_wq_cyc_missing(wq) < rq->wqe.info.wqe_bulk)
 		return false;
 
 	if (rq->page_pool)
 		page_pool_nid_changed(rq->page_pool, numa_mem_id());
 
-	do {
-		u16 head = mlx5_wq_cyc_get_head(wq);
-		int count;
-		u8 bulk;
+	wqe_bulk = mlx5_wq_cyc_missing(wq);
+	head = mlx5_wq_cyc_get_head(wq);
 
-		/* Don't allow any newly allocated WQEs to share the same page
-		 * with old WQEs that aren't completed yet. Stop earlier.
-		 */
-		bulk = wqe_bulk - ((head + wqe_bulk) & rq->wqe.info.wqe_index_mask);
+	/* Don't allow any newly allocated WQEs to share the same page with old
+	 * WQEs that aren't completed yet. Stop earlier.
+	 */
+	wqe_bulk -= (head + wqe_bulk) & rq->wqe.info.wqe_index_mask;
 
-		count = mlx5e_alloc_rx_wqes(rq, head, bulk);
-		mlx5_wq_cyc_push_n(wq, count);
-		if (unlikely(count != bulk)) {
-			rq->stats->buff_alloc_err++;
-			busy = true;
-			break;
-		}
-	} while (mlx5_wq_cyc_missing(wq) >= wqe_bulk);
+	count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
+	mlx5_wq_cyc_push_n(wq, count);
+	if (unlikely(count != wqe_bulk)) {
+		rq->stats->buff_alloc_err++;
+		busy = true;
+	}
 
 	/* ensure wqes are visible to device before updating doorbell record */
 	dma_wmb();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index e5c4dcd1425e..4d629e5ddbc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -123,7 +123,7 @@ static inline void mlx5_wq_cyc_push(struct mlx5_wq_cyc *wq)
 	wq->cur_sz++;
 }
 
-static inline void mlx5_wq_cyc_push_n(struct mlx5_wq_cyc *wq, u8 n)
+static inline void mlx5_wq_cyc_push_n(struct mlx5_wq_cyc *wq, u16 n)
 {
 	wq->wqe_ctr += n;
 	wq->cur_sz += n;
-- 
2.37.3

