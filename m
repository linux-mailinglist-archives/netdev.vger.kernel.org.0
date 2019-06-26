Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4BB56C28
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfFZOg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59931 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728075AbfFZOgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:25 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY8027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 10/16] net/mlx5e: Refactor struct mlx5e_xdp_info
Date:   Wed, 26 Jun 2019 17:35:32 +0300
Message-Id: <1561559738-4213-11-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Currently, struct mlx5e_xdp_info has some issues that have to be cleaned
up before the upcoming AF_XDP support makes things too complicated and
messy. This structure is used both when sending the packet and on
completion. Moreover, the cleanup procedure on completion depends on the
origin of the packet (XDP_REDIRECT, XDP_TX). Adding AF_XDP support will
add new flows that use this structure even differently. To avoid
overcomplicating the code, this commit refactors the usage of this
structure in the following ways:

1. struct mlx5e_xdp_info is split into two different structures. One is
struct mlx5e_xdp_xmit_data, a transient structure that doesn't need to
be stored and is only used while sending the packet. The other is still
struct mlx5e_xdp_info that is stored in a FIFO and contains the fields
needed on completion.

2. The fields of struct mlx5e_xdp_info that are used in different flows
are put into a union. A special enum indicates the cleanup mode and
helps choose the right union member. This approach is clear and
explicit. Although it could be possible to "guess" the mode by looking
at the values of the fields and at the XDP SQ type, it wouldn't be that
clear and extendable and would require looking through the whole chain
to understand what's going on.

For the reference, there are the fields of struct mlx5e_xdp_info that
are used in different flows (including AF_XDP ones):

Packet origin          | Fields used on completion | Cleanup steps
-----------------------+---------------------------+------------------
XDP_REDIRECT,          | xdpf, dma_addr            | DMA unmap and
XDP_TX from XSK RQ     |                           | xdp_return_frame.
-----------------------+---------------------------+------------------
XDP_TX from regular RQ | di                        | Recycle page.
-----------------------+---------------------------+------------------
AF_XDP TX              | (none)                    | Increment the
                       |                           | producer index in
                       |                           | Completion Ring.

On send, the same set of mlx5e_xdp_xmit_data fields is used in all
flows: DMA and virtual addresses and length.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 46 ++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 81 +++++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h | 11 ++--
 3 files changed, 97 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c7676635bc8e..b3c2d7ef1287 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -403,10 +403,44 @@ struct mlx5e_dma_info {
 	dma_addr_t      addr;
 };
 
+/* XDP packets can be transmitted in different ways. On completion, we need to
+ * distinguish between them to clean up things in a proper way.
+ */
+enum mlx5e_xdp_xmit_mode {
+	/* An xdp_frame was transmitted due to either XDP_REDIRECT from another
+	 * device or XDP_TX from an XSK RQ. The frame has to be unmapped and
+	 * returned.
+	 */
+	MLX5E_XDP_XMIT_MODE_FRAME,
+
+	/* The xdp_frame was created in place as a result of XDP_TX from a
+	 * regular RQ. No DMA remapping happened, and the page belongs to us.
+	 */
+	MLX5E_XDP_XMIT_MODE_PAGE,
+
+	/* No xdp_frame was created at all, the transmit happened from a UMEM
+	 * page. The UMEM Completion Ring producer pointer has to be increased.
+	 */
+	MLX5E_XDP_XMIT_MODE_XSK,
+};
+
 struct mlx5e_xdp_info {
-	struct xdp_frame      *xdpf;
-	dma_addr_t            dma_addr;
-	struct mlx5e_dma_info di;
+	enum mlx5e_xdp_xmit_mode mode;
+	union {
+		struct {
+			struct xdp_frame *xdpf;
+			dma_addr_t dma_addr;
+		} frame;
+		struct {
+			struct mlx5e_dma_info di;
+		} page;
+	};
+};
+
+struct mlx5e_xdp_xmit_data {
+	dma_addr_t  dma_addr;
+	void       *data;
+	u32         len;
 };
 
 struct mlx5e_xdp_info_fifo {
@@ -432,8 +466,10 @@ struct mlx5e_xdp_mpwqe {
 };
 
 struct mlx5e_xdpsq;
-typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq*,
-					struct mlx5e_xdp_info*);
+typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
+					struct mlx5e_xdp_xmit_data *,
+					struct mlx5e_xdp_info *);
+
 struct mlx5e_xdpsq {
 	/* data path */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 5a900b70b203..89f6eb1109cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -57,17 +57,27 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_dma_info *di,
 		    struct xdp_buff *xdp)
 {
+	struct mlx5e_xdp_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
+	struct xdp_frame *xdpf;
+	dma_addr_t dma_addr;
 
-	xdpi.xdpf = convert_to_xdp_frame(xdp);
-	if (unlikely(!xdpi.xdpf))
+	xdpf = convert_to_xdp_frame(xdp);
+	if (unlikely(!xdpf))
 		return false;
-	xdpi.dma_addr = di->addr + (xdpi.xdpf->data - (void *)xdpi.xdpf);
-	dma_sync_single_for_device(sq->pdev, xdpi.dma_addr,
-				   xdpi.xdpf->len, DMA_TO_DEVICE);
-	xdpi.di = *di;
 
-	return sq->xmit_xdp_frame(sq, &xdpi);
+	xdptxd.data = xdpf->data;
+	xdptxd.len  = xdpf->len;
+
+	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
+
+	dma_addr = di->addr + (xdpf->data - (void *)xdpf);
+	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
+
+	xdptxd.dma_addr = dma_addr;
+	xdpi.page.di = *di;
+
+	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi);
 }
 
 /* returns true if packet was consumed by xdp */
@@ -184,14 +194,13 @@ static void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
 }
 
 static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
+				       struct mlx5e_xdp_xmit_data *xdptxd,
 				       struct mlx5e_xdp_info *xdpi)
 {
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	struct xdp_frame *xdpf = xdpi->xdpf;
-
-	if (unlikely(sq->hw_mtu < xdpf->len)) {
+	if (unlikely(xdptxd->len > sq->hw_mtu)) {
 		stats->err++;
 		return false;
 	}
@@ -208,7 +217,7 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 		mlx5e_xdp_mpwqe_session_start(sq);
 	}
 
-	mlx5e_xdp_mpwqe_add_dseg(sq, xdpi, stats);
+	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
 
 	if (unlikely(session->complete ||
 		     session->ds_count == session->max_ds_count))
@@ -219,7 +228,9 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 	return true;
 }
 
-static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_info *xdpi)
+static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
+				 struct mlx5e_xdp_xmit_data *xdptxd,
+				 struct mlx5e_xdp_info *xdpi)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
 	u16                       pi   = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -229,9 +240,8 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_info *
 	struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
 	struct mlx5_wqe_data_seg *dseg = wqe->data;
 
-	struct xdp_frame *xdpf = xdpi->xdpf;
-	dma_addr_t dma_addr  = xdpi->dma_addr;
-	unsigned int dma_len = xdpf->len;
+	dma_addr_t dma_addr = xdptxd->dma_addr;
+	u32 dma_len = xdptxd->len;
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
@@ -253,7 +263,7 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_info *
 
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
-		memcpy(eseg->inline_hdr.start, xdpf->data, MLX5E_XDP_MIN_INLINE);
+		memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
 		eseg->inline_hdr.sz = cpu_to_be16(MLX5E_XDP_MIN_INLINE);
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
 		dma_addr += MLX5E_XDP_MIN_INLINE;
@@ -286,14 +296,19 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 	for (i = 0; i < wi->num_pkts; i++) {
 		struct mlx5e_xdp_info xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 
-		if (rq) {
-			/* XDP_TX */
-			mlx5e_page_release(rq, &xdpi.di, recycle);
-		} else {
+		switch (xdpi.mode) {
+		case MLX5E_XDP_XMIT_MODE_FRAME:
 			/* XDP_REDIRECT */
-			dma_unmap_single(sq->pdev, xdpi.dma_addr,
-					 xdpi.xdpf->len, DMA_TO_DEVICE);
-			xdp_return_frame(xdpi.xdpf);
+			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
+					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
+			xdp_return_frame(xdpi.frame.xdpf);
+			break;
+		case MLX5E_XDP_XMIT_MODE_PAGE:
+			/* XDP_TX */
+			mlx5e_page_release(rq, &xdpi.page.di, recycle);
+			break;
+		default:
+			WARN_ON_ONCE(true);
 		}
 	}
 }
@@ -398,21 +413,27 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
+		struct mlx5e_xdp_xmit_data xdptxd;
 		struct mlx5e_xdp_info xdpi;
 
-		xdpi.dma_addr = dma_map_single(sq->pdev, xdpf->data, xdpf->len,
-					       DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(sq->pdev, xdpi.dma_addr))) {
+		xdptxd.data = xdpf->data;
+		xdptxd.len = xdpf->len;
+		xdptxd.dma_addr = dma_map_single(sq->pdev, xdptxd.data,
+						 xdptxd.len, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr))) {
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
 			continue;
 		}
 
-		xdpi.xdpf = xdpf;
+		xdpi.mode           = MLX5E_XDP_XMIT_MODE_FRAME;
+		xdpi.frame.xdpf     = xdpf;
+		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdpi))) {
-			dma_unmap_single(sq->pdev, xdpi.dma_addr,
-					 xdpf->len, DMA_TO_DEVICE);
+		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi))) {
+			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
+					 xdptxd.len, DMA_TO_DEVICE);
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 8b537a4b0840..2a5158993349 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -97,15 +97,14 @@ static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
 }
 
 static inline void
-mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_info *xdpi,
+mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
+			 struct mlx5e_xdp_xmit_data *xdptxd,
 			 struct mlx5e_xdpsq_stats *stats)
 {
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
-	dma_addr_t dma_addr    = xdpi->dma_addr;
-	struct xdp_frame *xdpf = xdpi->xdpf;
 	struct mlx5_wqe_data_seg *dseg =
 		(struct mlx5_wqe_data_seg *)session->wqe + session->ds_count;
-	u16 dma_len = xdpf->len;
+	u32 dma_len = xdptxd->len;
 
 	session->pkt_count++;
 
@@ -124,7 +123,7 @@ static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
 		}
 
 		inline_dseg->byte_count = cpu_to_be32(dma_len | MLX5_INLINE_SEG);
-		memcpy(inline_dseg->data, xdpf->data, dma_len);
+		memcpy(inline_dseg->data, xdptxd->data, dma_len);
 
 		session->ds_count += ds_cnt;
 		stats->inlnw++;
@@ -132,7 +131,7 @@ static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
 	}
 
 no_inline:
-	dseg->addr       = cpu_to_be64(dma_addr);
+	dseg->addr       = cpu_to_be64(xdptxd->dma_addr);
 	dseg->byte_count = cpu_to_be32(dma_len);
 	dseg->lkey       = sq->mkey_be;
 	session->ds_count++;
-- 
1.8.3.1

