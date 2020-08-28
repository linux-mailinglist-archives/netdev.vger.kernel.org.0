Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83291255671
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgH1I1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:27:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:23551 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgH1I1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:32 -0400
IronPort-SDR: vNgBJ1jyocbEx6igenEQRb9vyHWWo0SjyOrml6LXtvGXc61GSoBFMWZdTeWPgYIEqfTy7mOU+u
 1oo9F13Wk7sA==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156634026"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156634026"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:27:18 -0700
IronPort-SDR: n8Og1iFhqtb5IrTVPS3vX/W5mpx88D+UVyV6aLFCh6wtN6KtSpxvutRJyd29ARdNhLc8PJrhDe
 /y7rX3MELQLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762828"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:27:15 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 10/15] xsk: i40e: ice: ixgbe: mlx5: test for dma_need_sync earlier for better performance
Date:   Fri, 28 Aug 2020 10:26:24 +0200
Message-Id: <1598603189-32145-11-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test for dma_need_sync earlier to increase
performance. xsk_buff_dma_sync_for_cpu() takes an xdp_buff as
parameter and from that the xsk_buff_pool reference is dug out. Perf
shows that this dereference causes a lot of cache misses. But as the
buffer pool is now sent down to the driver at zero-copy initialization
time, we might as well use this pointer directly, instead of going via
the xsk_buff and we can do so already in xsk_buff_dma_sync_for_cpu()
instead of in xp_dma_sync_for_cpu. This gets rid of these cache
misses.

Throughput increases with 3% for the xdpsock l2fwd sample application
on my machine.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c          | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c            | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 4 ++--
 include/net/xdp_sock_drv.h                          | 7 +++++--
 include/net/xsk_buff_pool.h                         | 3 ---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 95b9a7e..2a1153d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -314,7 +314,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)

 		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 		(*bi)->data_end = (*bi)->data + size;
-		xsk_buff_dma_sync_for_cpu(*bi);
+		xsk_buff_dma_sync_for_cpu(*bi, rx_ring->xsk_pool);

 		xdp_res = i40e_run_xdp_zc(rx_ring, *bi);
 		if (xdp_res) {
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index dffef37..7978865 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -595,7 +595,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)

 		rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
 		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
-		xsk_buff_dma_sync_for_cpu(rx_buf->xdp);
+		xsk_buff_dma_sync_for_cpu(rx_buf->xdp, rx_ring->xsk_pool);

 		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
 		if (xdp_res) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6af34da..3771857 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -287,7 +287,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		}

 		bi->xdp->data_end = bi->xdp->data + size;
-		xsk_buff_dma_sync_for_cpu(bi->xdp);
+		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
 		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);

 		if (xdp_res) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index a33a1f7..902ce77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -48,7 +48,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,

 	xdp->data_end = xdp->data + cqe_bcnt32;
 	xdp_set_data_meta_invalid(xdp);
-	xsk_buff_dma_sync_for_cpu(xdp);
+	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	prefetch(xdp->data);

 	rcu_read_lock();
@@ -99,7 +99,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,

 	xdp->data_end = xdp->data + cqe_bcnt;
 	xdp_set_data_meta_invalid(xdp);
-	xsk_buff_dma_sync_for_cpu(xdp);
+	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	prefetch(xdp->data);

 	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index a7c7d2e..5b1ee8a 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -99,10 +99,13 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 	return xp_raw_get_data(pool, addr);
 }

-static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
+static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_buff_pool *pool)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);

+	if (!pool->dma_need_sync)
+		return;
+
 	xp_dma_sync_for_cpu(xskb);
 }

@@ -222,7 +225,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 	return NULL;
 }

-static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
+static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_buff_pool *pool)
 {
 }

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 38d03a6..907537d 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -114,9 +114,6 @@ static inline dma_addr_t xp_get_frame_dma(struct xdp_buff_xsk *xskb)
 void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
 static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
 {
-	if (!xskb->pool->dma_need_sync)
-		return;
-
 	xp_dma_sync_for_cpu_slow(xskb);
 }

--
2.7.4
