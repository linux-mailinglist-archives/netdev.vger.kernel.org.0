Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3819A5F0FF8
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiI3Q3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiI3Q3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286964FA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2FDDCE2619
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2070FC433D7;
        Fri, 30 Sep 2022 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555371;
        bh=Z9SNyGO5U6234c/I+YUEmNVkVGJqjzBX0ObkkAsluPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGfYF708FANmFwlH7iwSkMfHcm/F3uRhm92pK6kW26iQLOvCdkMrDgNfbDChNKFEt
         jLmstcF6cWNriITC66NOI+9SUOoYzlBIlX/kziz2c2i/s/JfmiwN2JDHANWEI6g05q
         WDaWEkzq/YfNy7RTzecxtwJimLHQfjwm8+qiwdNdKNIoH7TdkeIK0rdibNroXbxNRQ
         qEQF4w2bgZPbD7Qp5ebPZkmz0xxxGHC+bOsmD+C2fqH/9U2BIkEUMpEQIEWXfSIP8/
         0QqyEHUyZngfAfmRbfF0mQlXygJmD2gvzUq5etbWXtSVLrAtf6PHbEoYOUuVxpP17A
         WXfrKaDK8qvKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 05/16] net/mlx5e: Use partial batches in legacy RQ
Date:   Fri, 30 Sep 2022 09:28:52 -0700
Message-Id: <20220930162903.62262-6-saeed@kernel.org>
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

Legacy RQ allocates WQEs in batches. If the batch allocation fails, the
pages of the allocated part are released. This commit changes this
behavior to allow to use the pages that have been already allocated.

After this change, we need to be careful about indexing rq->wqe.frags[].
The WQ size is a power of two that divides by wqe_bulk (8), and the old
code used whole bulks, which allowed to use indices [8*K; 8*K+7] without
overflowing. Now that the bulks may be partial, the range can start at
any location (not only at 8*K), so we need to wrap them around to avoid
out-of-bounds array access.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 39 ++++++++++---------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 72d74de3ee99..ffca217b7d7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -427,7 +427,6 @@ static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
-	int err;
 	int i;
 
 	if (rq->xsk_pool) {
@@ -442,20 +441,16 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	}
 
 	for (i = 0; i < wqe_bulk; i++) {
-		struct mlx5e_rx_wqe_cyc *wqe = mlx5_wq_cyc_get_wqe(wq, ix + i);
+		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
+		struct mlx5e_rx_wqe_cyc *wqe;
 
-		err = mlx5e_alloc_rx_wqe(rq, wqe, ix + i);
-		if (unlikely(err))
-			goto free_wqes;
-	}
+		wqe = mlx5_wq_cyc_get_wqe(wq, j);
 
-	return 0;
-
-free_wqes:
-	while (--i >= 0)
-		mlx5e_dealloc_rx_wqe(rq, ix + i);
+		if (unlikely(mlx5e_alloc_rx_wqe(rq, wqe, j)))
+			break;
+	}
 
-	return err;
+	return i;
 }
 
 static inline void
@@ -821,8 +816,8 @@ static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	bool busy = false;
 	u8 wqe_bulk;
-	int err;
 
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return false;
@@ -837,14 +832,22 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 
 	do {
 		u16 head = mlx5_wq_cyc_get_head(wq);
+		int count;
+		u8 bulk;
 
-		err = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
-		if (unlikely(err)) {
+		/* Don't allow any newly allocated WQEs to share the same page
+		 * with old WQEs that aren't completed yet. Stop earlier.
+		 */
+		bulk = wqe_bulk - ((head + wqe_bulk) & rq->wqe.info.wqe_index_mask);
+
+		count = mlx5e_alloc_rx_wqes(rq, head, bulk);
+		if (likely(count > 0))
+			mlx5_wq_cyc_push_n(wq, count);
+		if (unlikely(count != bulk)) {
 			rq->stats->buff_alloc_err++;
+			busy = true;
 			break;
 		}
-
-		mlx5_wq_cyc_push_n(wq, wqe_bulk);
 	} while (mlx5_wq_cyc_missing(wq) >= wqe_bulk);
 
 	/* ensure wqes are visible to device before updating doorbell record */
@@ -852,7 +855,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 
 	mlx5_wq_cyc_update_db_record(wq);
 
-	return !!err;
+	return busy;
 }
 
 void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
-- 
2.37.3

