Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882F74DCE2C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiCQSzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiCQSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF111637F1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF69617B0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DA8C340EC;
        Thu, 17 Mar 2022 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543270;
        bh=JKu6yx0xHGA7JVcpXXEOtPXJ1mGO3lSpJ4k850iiCRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCgyJjO3AwalOMPPVoj80nSPXncD79mP3k2pSFnVAcYdB+BX9Tu9LqmbcIqjz5L1F
         EN1/4+FUibEAWIJC9NZcKswtXp6jlVCyndDtQM4UWpyRKinEjCJz2T/qWuJCUzm50e
         iN8wPLiGLjWgSAaQj8YeGgCBVC9Gdhpd3gYfvqQdVLLJoIQMLTO/oCTFs6Bix0mvvt
         a3CqvthnyA/E2H8h9ymzvMwsh4c4P+2WN4lFd1V4em511HzPBt01hFq9IMvieg/cGq
         VifsDRyuNr2DjN5i8MCu9wM2q9BerdWmzNm1WlvjbnqoYuGH7IODmnfaq7fF4vSqkm
         pTNR1S1+kCaew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: RX, Test the XDP program existence out of the handler
Date:   Thu, 17 Mar 2022 11:54:13 -0700
Message-Id: <20220317185424.287982-5-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Instead of early return inside mlx5e_xdp_handle(), let the caller check
if an XDP program is loaded.  This allows saving a few unnecessary
function calls and calculations in case !prog.

Performance test: single core, drop packets in iptables
Before: 3,872,504 pps
After:  3,975,628 pps (+2.66%)

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  9 +++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 49 ++++++++++++-------
 4 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index a7f020399370..fcb84971b138 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -120,15 +120,12 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
+		      struct bpf_prog *prog,
 		      u32 *len, struct xdp_buff *xdp)
 {
-	struct bpf_prog *prog = rcu_dereference(rq->xdp_prog);
 	u32 act;
 	int err;
 
-	if (!prog)
-		return false;
-
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index c62f11d7ef6a..850540e94bb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -48,6 +48,7 @@
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
+		      struct bpf_prog *prog,
 		      u32 *len, struct xdp_buff *xdp);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8e7b877d8a12..162513594862 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -4,6 +4,7 @@
 #include "rx.h"
 #include "en/xdp.h"
 #include <net/xdp_sock_drv.h>
+#include <linux/filter.h>
 
 /* RX data path */
 
@@ -31,6 +32,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 {
 	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
 	u32 cqe_bcnt32 = cqe_bcnt;
+	struct bpf_prog *prog;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -65,7 +67,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	 * allocated first from the Reuse Ring, so it has enough space.
 	 */
 
-	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp))) {
+	prog = rcu_dereference(rq->xdp_prog);
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, &cqe_bcnt32, xdp))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -83,6 +86,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      u32 cqe_bcnt)
 {
 	struct xdp_buff *xdp = wi->di->xsk;
+	struct bpf_prog *prog;
 
 	/* wi->offset is not used in this function, because xdp->data and the
 	 * DMA address point directly to the necessary place. Furthermore, the
@@ -101,7 +105,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 		return NULL;
 	}
 
-	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp)))
+	prog = rcu_dereference(rq->xdp_prog);
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, &cqe_bcnt, xdp)))
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b06aac087b2a..60c640fc430c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -34,6 +34,7 @@
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
 #include <linux/bitmap.h>
+#include <linux/filter.h>
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
 #include <net/inet_ecn.h>
@@ -1523,11 +1524,11 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 {
 	struct mlx5e_dma_info *di = wi->di;
 	u16 rx_headroom = rq->buff.headroom;
-	struct xdp_buff xdp;
+	struct bpf_prog *prog;
 	struct sk_buff *skb;
+	u32 metasize = 0;
 	void *va, *data;
 	u32 frag_size;
-	u32 metasize;
 
 	va             = page_address(di->page) + wi->offset;
 	data           = va + rx_headroom;
@@ -1535,16 +1536,21 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
 				      frag_size, DMA_FROM_DEVICE);
-	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(data);
 
-	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp))
-		return NULL; /* page/packet was consumed by XDP */
+	prog = rcu_dereference(rq->xdp_prog);
+	if (prog) {
+		struct xdp_buff xdp;
 
-	rx_headroom = xdp.data - xdp.data_hard_start;
+		net_prefetchw(va); /* xdp_frame data area */
+		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
+		if (mlx5e_xdp_handle(rq, di, prog, &cqe_bcnt, &xdp))
+			return NULL; /* page/packet was consumed by XDP */
+
+		rx_headroom = xdp.data - xdp.data_hard_start;
+		metasize = xdp.data - xdp.data_meta;
+	}
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
-	metasize = xdp.data - xdp.data_meta;
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
 	if (unlikely(!skb))
 		return NULL;
@@ -1842,11 +1848,11 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
 	u16 rx_headroom = rq->buff.headroom;
 	u32 cqe_bcnt32 = cqe_bcnt;
-	struct xdp_buff xdp;
+	struct bpf_prog *prog;
 	struct sk_buff *skb;
+	u32 metasize = 0;
 	void *va, *data;
 	u32 frag_size;
-	u32 metasize;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -1860,19 +1866,24 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, head_offset,
 				      frag_size, DMA_FROM_DEVICE);
-	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(data);
 
-	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
-	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp)) {
-		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
-			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
-		return NULL; /* page/packet was consumed by XDP */
-	}
+	prog = rcu_dereference(rq->xdp_prog);
+	if (prog) {
+		struct xdp_buff xdp;
 
-	rx_headroom = xdp.data - xdp.data_hard_start;
+		net_prefetchw(va); /* xdp_frame data area */
+		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
+		if (mlx5e_xdp_handle(rq, di, prog, &cqe_bcnt32, &xdp)) {
+			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
+				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
+			return NULL; /* page/packet was consumed by XDP */
+		}
+
+		rx_headroom = xdp.data - xdp.data_hard_start;
+		metasize = xdp.data - xdp.data_meta;
+	}
 	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
-	metasize = xdp.data - xdp.data_meta;
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32, metasize);
 	if (unlikely(!skb))
 		return NULL;
-- 
2.35.1

