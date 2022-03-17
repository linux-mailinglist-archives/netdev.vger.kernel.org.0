Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7854DCE36
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiCQSzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbiCQSzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719BADFDF7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C655617AE
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844ABC340F3;
        Thu, 17 Mar 2022 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543270;
        bh=Z8FbhyBI0CiPU3RnMtg8G1ugPBvbK/yQf31cf4TbQOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsvanfAiDKgm/26LCAywhHp1ncbpF7JGvmgv1pBHPAoScl8A3sTLVCleHeZaiACKH
         mLzfov+IEBF4OUjKmtjUHoVZz9XkO18ZGPOhDDDy/7oVOD35DJb8EHY8LBQVD+VciY
         +zXxy/CE2uEsIHPRKN07KxCMwxOa3dZefflDOVNB2uaN7AXNt6ruPjqz9fbGSwneSq
         JpXOujpJvwKOWTDRO2bl5hj2fGybUTej2a1KfyKCMuabEPnBD1TlFc3lGco7ZSz8Wb
         0Xzb+qvZPKDbOc+kms6hTW0yKMeSdx4HySnURXeMZjWhz+bcm6PIzBqVnzMoUuQtO4
         vAYqQEHGruJGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Drop the len output parameter from mlx5e_xdp_handle
Date:   Thu, 17 Mar 2022 11:54:14 -0700
Message-Id: <20220317185424.287982-6-saeed@kernel.org>
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

The len parameter of mlx5e_xdp_handle is used to output the new packet
length after XDP has processed the packet and returned XDP_PASS.
However, this value can be calculated on the caller site, as the caller
knows if it was an XDP_PASS.

This commit drops the len parameter and moves the calculation to the
caller, reducing the number of parameters passed to the function and
preparing for XDP support in non-linear legacy RQ.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h    |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 11 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  6 ++++--
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index fcb84971b138..6aa77f0e094e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -120,8 +120,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      struct bpf_prog *prog,
-		      u32 *len, struct xdp_buff *xdp)
+		      struct bpf_prog *prog, struct xdp_buff *xdp)
 {
 	u32 act;
 	int err;
@@ -129,7 +128,6 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		*len = xdp->data_end - xdp->data;
 		return false;
 	case XDP_TX:
 		if (unlikely(!mlx5e_xmit_xdp_buff(rq->xdpsq, rq, di, xdp)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 850540e94bb4..20d8af66c072 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -48,8 +48,7 @@
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
-		      struct bpf_prog *prog,
-		      u32 *len, struct xdp_buff *xdp);
+		      struct bpf_prog *prog, struct xdp_buff *xdp);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 162513594862..021da085e603 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -31,7 +31,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 page_idx)
 {
 	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
-	u32 cqe_bcnt32 = cqe_bcnt;
 	struct bpf_prog *prog;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
@@ -47,7 +46,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(head_offset);
 
-	xdp->data_end = xdp->data + cqe_bcnt32;
+	xdp->data_end = xdp->data + cqe_bcnt;
 	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
@@ -68,7 +67,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 */
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, &cqe_bcnt32, xdp))) {
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -77,7 +76,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
 	 * frame. On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp->data, cqe_bcnt32);
+	return mlx5e_xsk_construct_skb(rq, xdp->data, xdp->data_end - xdp->data);
 }
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
@@ -106,12 +105,12 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	}
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, &cqe_bcnt, xdp)))
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
 	 * will be handled by mlx5e_put_rx_frag.
 	 * On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp->data, cqe_bcnt);
+	return mlx5e_xsk_construct_skb(rq, xdp->data, xdp->data_end - xdp->data);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 60c640fc430c..7c490c0ca370 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1544,11 +1544,12 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, di, prog, &cqe_bcnt, &xdp))
+		if (mlx5e_xdp_handle(rq, di, prog, &xdp))
 			return NULL; /* page/packet was consumed by XDP */
 
 		rx_headroom = xdp.data - xdp.data_hard_start;
 		metasize = xdp.data - xdp.data_meta;
+		cqe_bcnt = xdp.data_end - xdp.data;
 	}
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
@@ -1874,7 +1875,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
-		if (mlx5e_xdp_handle(rq, di, prog, &cqe_bcnt32, &xdp)) {
+		if (mlx5e_xdp_handle(rq, di, prog, &xdp)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
@@ -1882,6 +1883,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 		rx_headroom = xdp.data - xdp.data_hard_start;
 		metasize = xdp.data - xdp.data_meta;
+		cqe_bcnt32 = xdp.data_end - xdp.data;
 	}
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32, metasize);
-- 
2.35.1

