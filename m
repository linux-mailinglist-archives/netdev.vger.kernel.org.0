Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D3269891B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBPAJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBPAJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0358C3866F
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B9761E19
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA49C433AE;
        Thu, 16 Feb 2023 00:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506163;
        bh=I0XfYKyeH9KGQLPDJ3Soyg8AbyTJD9la8tX9nQiS/Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTHGqzJGF1oBJZ6uG0xTN059KP9cZugyHKkBWAz5T6Vny+DGgjclENjSgEshaIPW9
         7iuitC0YadPM5dE08qP14UZTh3UzkAUd1fX8VqZSmTA/xOCVXKOXi0BTjDmNQhJg1m
         hljbfQIFoQyTlnTmF5HgSGjMipOgpLgdXoIxQVUhP6vcpvol3gI7zEOsCNUESwCfaB
         nkj0ezJ9yrz0VVfmlqKxSYVpDZQ6hEBMRQzzvGAJbppyuIOLue9UaxdzqkLAotYrVR
         0R8mJ05vxXcEinOEwsjhHAb3nv7KVio7R1xTEFVkTrd/rbuRea1kf4W1Ff3lqHfEbW
         /ORZpuNrsSP3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 3/9] net/mlx5e: Remove redundant page argument in mlx5e_xdp_handle()
Date:   Wed, 15 Feb 2023 16:09:12 -0800
Message-Id: <20230216000918.235103-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Remove the page parameter, it can be derived from the xdp_buff member
of mlx5e_xdp_buff.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 10 ++++------
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 4b9cd8ef8d28..bcd6370de440 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -186,7 +186,7 @@ const struct xdp_metadata_ops mlx5e_xdp_metadata_ops = {
 };
 
 /* returns true if packet was consumed by xdp */
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
 		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
 {
 	struct xdp_buff *xdp = &mxbuf->xdp;
@@ -210,7 +210,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags);
 		__set_bit(MLX5E_RQ_FLAG_XDP_REDIRECT, rq->flags);
 		if (xdp->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
-			mlx5e_page_dma_unmap(rq, page);
+			mlx5e_page_dma_unmap(rq, virt_to_page(xdp->data));
 		rq->stats->xdp_redirect++;
 		return true;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 69f338bc0633..10bcfa6f88c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -52,7 +52,7 @@ struct mlx5e_xdp_buff {
 
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
-bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
+bool mlx5e_xdp_handle(struct mlx5e_rq *rq,
 		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mlctx);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index b7c84ebe8418..fab787600459 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -289,7 +289,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 */
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf))) {
+	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -323,7 +323,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	net_prefetch(mxbuf->xdp.data);
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf)))
+	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf)))
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9ac2c7778b5b..ac570945d5d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1610,7 +1610,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
+		if (mlx5e_xdp_handle(rq, prog, &mxbuf))
 			return NULL; /* page/packet was consumed by XDP */
 
 		rx_headroom = mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
@@ -1698,10 +1698,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 		wi++;
 	}
 
-	au = head_wi->au;
-
 	prog = rcu_dereference(rq->xdp_prog);
-	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
+	if (prog && mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 			int i;
 
@@ -1718,7 +1716,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	if (unlikely(!skb))
 		return NULL;
 
-	page_ref_inc(au->page);
+	page_ref_inc(head_wi->au->page);
 
 	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
 		int i;
@@ -2013,7 +2011,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
+		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
-- 
2.39.1

