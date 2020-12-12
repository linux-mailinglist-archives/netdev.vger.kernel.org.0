Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA92D88BE
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439373AbgLLRnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgLLRnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 12:43:07 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff utility routine
Date:   Sat, 12 Dec 2020 18:41:49 +0100
Message-Id: <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1607794551.git.lorenzo@kernel.org>
References: <cover.1607794551.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_prepare_buff utility routine to initialize per-descriptor
xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff() in
all XDP capable drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c      |  5 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     |  4 +---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c  |  7 ++++---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c    |  6 ++----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 13 +++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 11 ++++++-----
 drivers/net/ethernet/intel/igb/igb_main.c         | 12 ++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 12 ++++++------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 12 ++++++------
 drivers/net/ethernet/marvell/mvneta.c             |  6 ++----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 +++----
 drivers/net/ethernet/mellanox/mlx4/en_rx.c        |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  4 +---
 .../net/ethernet/netronome/nfp/nfp_net_common.c   |  8 ++++----
 drivers/net/ethernet/qlogic/qede/qede_fp.c        |  4 +---
 drivers/net/ethernet/sfc/rx.c                     |  6 ++----
 drivers/net/ethernet/socionext/netsec.c           |  5 ++---
 drivers/net/ethernet/ti/cpsw.c                    | 15 +++++----------
 drivers/net/ethernet/ti/cpsw_new.c                | 15 +++++----------
 drivers/net/hyperv/netvsc_bpf.c                   |  4 +---
 drivers/net/tun.c                                 |  4 +---
 drivers/net/veth.c                                |  6 +-----
 drivers/net/virtio_net.c                          | 12 ++++--------
 drivers/net/xen-netfront.c                        |  4 +---
 include/net/xdp.h                                 | 12 ++++++++++++
 net/bpf/test_run.c                                |  5 +----
 net/core/dev.c                                    | 10 ++++------
 28 files changed, 96 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 338dce73927e..1cfd0c98677e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1519,10 +1519,9 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	int ret;
 
 	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-	xdp->data = page_address(rx_info->page) + rx_info->page_offset;
+	xdp_prepare_buff(xdp, page_address(rx_info->page),
+			 rx_info->page_offset, rx_ring->ena_bufs[0].len);
 	xdp_set_data_meta_invalid(xdp);
-	xdp->data_hard_start = page_address(rx_info->page);
-	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
 	/* If for some reason we received a bigger packet than
 	 * we expect, then we simply drop it
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index b7942c3440c0..e1664b86a7b8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -134,10 +134,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 	txr = rxr->bnapi->tx_ring;
 	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
-	xdp.data_hard_start = *data_ptr - offset;
-	xdp.data = *data_ptr;
+	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len);
 	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = *data_ptr + *len;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 9fc672f075f2..9bdac04359c6 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -530,6 +530,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 				struct cqe_rx_t *cqe_rx, struct snd_queue *sq,
 				struct rcv_queue *rq, struct sk_buff **skb)
 {
+	unsigned char *hard_start, *data;
 	struct xdp_buff xdp;
 	struct page *page;
 	u32 action;
@@ -549,10 +550,10 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 
 	xdp_init_buff(&xdp, RCV_FRAG_LEN + XDP_PACKET_HEADROOM,
 		      &rq->xdp_rxq);
-	xdp.data_hard_start = page_address(page);
-	xdp.data = (void *)cpu_addr;
+	hard_start = page_address(page);
+	data = (unsigned char *)cpu_addr;
+	xdp_prepare_buff(&xdp, hard_start, data - hard_start, len);
 	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + len;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 93030000e0aa..86ee07c90154 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2538,10 +2538,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 
 	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
 		      &dpaa_fq->xdp_rxq);
-	xdp.data = vaddr + fd_off;
-	xdp.data_meta = xdp.data;
-	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
-	xdp.data_end = xdp.data + qm_fd_get_length(fd);
+	xdp_prepare_buff(&xdp, vaddr + fd_off - XDP_PACKET_HEADROOM,
+			 XDP_PACKET_HEADROOM, qm_fd_get_length(fd));
 
 	/* We reserve a fixed headroom of 256 bytes under the erratum and we
 	 * offer it all to XDP programs to use. If no room is left for the
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a4ade0b5adb0..12358f5d59d6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -350,7 +350,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
 	u32 xdp_act = XDP_PASS;
-	int err;
+	int err, offset;
 
 	rcu_read_lock();
 
@@ -358,13 +358,10 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	if (!xdp_prog)
 		goto out;
 
-	xdp_init_buff(&xdp,
-		      DPAA2_ETH_RX_BUF_RAW_SIZE -
-		      (dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM),
-		      &ch->xdp_rxq);
-	xdp.data = vaddr + dpaa2_fd_get_offset(fd);
-	xdp.data_end = xdp.data + dpaa2_fd_get_len(fd);
-	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
+	offset = dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM;
+	xdp_init_buff(&xdp, DPAA2_ETH_RX_BUF_RAW_SIZE - offset, &ch->xdp_rxq);
+	xdp_prepare_buff(&xdp, vaddr + offset, XDP_PACKET_HEADROOM,
+			 dpaa2_fd_get_len(fd));
 	xdp_set_data_meta_invalid(&xdp);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 4dbbbd49c389..fcd1ca3343fb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2393,12 +2393,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			xdp.data = page_address(rx_buffer->page) +
-				   rx_buffer->page_offset;
-			xdp.data_meta = xdp.data;
-			xdp.data_hard_start = xdp.data -
-					      i40e_rx_offset(rx_ring);
-			xdp.data_end = xdp.data + size;
+			unsigned int offset = i40e_rx_offset(rx_ring);
+			unsigned char *hard_start;
+
+			hard_start = page_address(rx_buffer->page) +
+				     rx_buffer->page_offset - offset;
+			xdp_prepare_buff(&xdp, hard_start, offset, size);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index d52d98d56367..a7a00060f520 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1094,8 +1094,9 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
+		unsigned int size, offset;
+		unsigned char *hard_start;
 		struct sk_buff *skb;
-		unsigned int size;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
@@ -1138,10 +1139,10 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			goto construct_skb;
 		}
 
-		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
-		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
-		xdp.data_meta = xdp.data;
-		xdp.data_end = xdp.data + size;
+		offset = ice_rx_offset(rx_ring);
+		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
+			     offset;
+		xdp_prepare_buff(&xdp, hard_start, offset, size);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 365dfc0e3b65..070b2bb4e9ca 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8700,12 +8700,12 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			xdp.data = page_address(rx_buffer->page) +
-				   rx_buffer->page_offset;
-			xdp.data_meta = xdp.data;
-			xdp.data_hard_start = xdp.data -
-					      igb_rx_offset(rx_ring);
-			xdp.data_end = xdp.data + size;
+			unsigned int offset = igb_rx_offset(rx_ring);
+			unsigned char *hard_start;
+
+			hard_start = page_address(rx_buffer->page) +
+				     rx_buffer->page_offset - offset;
+			xdp_prepare_buff(&xdp, hard_start, offset, size);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index dcd49cfa36f7..e34054433c7a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2325,12 +2325,12 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			xdp.data = page_address(rx_buffer->page) +
-				   rx_buffer->page_offset;
-			xdp.data_meta = xdp.data;
-			xdp.data_hard_start = xdp.data -
-					      ixgbe_rx_offset(rx_ring);
-			xdp.data_end = xdp.data + size;
+			unsigned int offset = ixgbe_rx_offset(rx_ring);
+			unsigned char *hard_start;
+
+			hard_start = page_address(rx_buffer->page) +
+				     rx_buffer->page_offset - offset;
+			xdp_prepare_buff(&xdp, hard_start, offset, size);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 624efcd71569..51df79005ccb 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1160,12 +1160,12 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			xdp.data = page_address(rx_buffer->page) +
-				   rx_buffer->page_offset;
-			xdp.data_meta = xdp.data;
-			xdp.data_hard_start = xdp.data -
-					      ixgbevf_rx_offset(rx_ring);
-			xdp.data_end = xdp.data + size;
+			unsigned int offset = ixgbevf_rx_offset(rx_ring);
+			unsigned char *hard_start;
+
+			hard_start = page_address(rx_buffer->page) +
+				     rx_buffer->page_offset - offset;
+			xdp_prepare_buff(&xdp, hard_start, offset, size);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index acbb9cb85ada..af6c9cf59809 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2263,10 +2263,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
-
-	xdp->data_hard_start = data;
-	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
-	xdp->data_end = xdp->data + data_len;
+	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
+			 data_len);
 	xdp_set_data_meta_invalid(xdp);
 
 	sinfo = xdp_get_shared_info_from_buff(xdp);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ca05dfc05058..8c2197b96515 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3564,16 +3564,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		if (xdp_prog) {
 			struct xdp_rxq_info *xdp_rxq;
 
-			xdp.data_hard_start = data;
-			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
-			xdp.data_end = xdp.data + rx_bytes;
-
 			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
 				xdp_rxq = &rxq->xdp_rxq_short;
 			else
 				xdp_rxq = &rxq->xdp_rxq_long;
 
 			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
+			xdp_prepare_buff(&xdp, data,
+					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
+					 rx_bytes);
 			xdp_set_data_meta_invalid(&xdp);
 
 			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 815381b484ca..86c63dedc689 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -776,10 +776,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 						priv->frag_info[0].frag_size,
 						DMA_FROM_DEVICE);
 
-			xdp.data_hard_start = va - frags[0].page_offset;
-			xdp.data = va;
+			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
+					 frags[0].page_offset, length);
 			xdp_set_data_meta_invalid(&xdp);
-			xdp.data_end = xdp.data + length;
 			orig_data = xdp.data;
 
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index c68628b1f30b..a2f4f0ce427f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1128,10 +1128,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
-	xdp->data_hard_start = va;
-	xdp->data = va + headroom;
+	xdp_prepare_buff(xdp, va, headroom, len);
 	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 68e03e8257f2..5d0046c24b8c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1914,10 +1914,10 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			unsigned int dma_off;
 			int act;
 
-			xdp.data_hard_start = rxbuf->frag + NFP_NET_RX_BUF_HEADROOM;
-			xdp.data = orig_data;
-			xdp.data_meta = orig_data;
-			xdp.data_end = orig_data + pkt_len;
+			xdp_prepare_buff(&xdp,
+					 rxbuf->frag + NFP_NET_RX_BUF_HEADROOM,
+					 pkt_off - NFP_NET_RX_BUF_HEADROOM,
+					 pkt_len);
 
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index d40220043883..9c50df499046 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1091,10 +1091,8 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	enum xdp_action act;
 
 	xdp_init_buff(&xdp, rxq->rx_buf_seg_size, &rxq->xdp_rxq);
-	xdp.data_hard_start = page_address(bd->data);
-	xdp.data = xdp.data_hard_start + *data_offset;
+	xdp_prepare_buff(&xdp, page_address(bd->data), *data_offset, *len);
 	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + *len;
 
 	/* Queues always have a full reset currently, so for the time
 	 * being until there's atomic program replace just mark read
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index eaa6650955d1..9015a1639234 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -294,12 +294,10 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	       efx->rx_prefix_size);
 
 	xdp_init_buff(&xdp, efx->rx_page_buf_step, &rx_queue->xdp_rxq_info);
-	xdp.data = *ehp;
-	xdp.data_hard_start = xdp.data - EFX_XDP_HEADROOM;
-
+	xdp_prepare_buff(&xdp, *ehp - EFX_XDP_HEADROOM, EFX_XDP_HEADROOM,
+			 rx_buf->len);
 	/* No support yet for XDP metadata */
 	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + rx_buf->len;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	rcu_read_unlock();
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 945ca9517bf9..80bb1a6612b1 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1015,10 +1015,9 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 					dma_dir);
 		prefetch(desc->addr);
 
-		xdp.data_hard_start = desc->addr;
-		xdp.data = desc->addr + NETSEC_RXBUF_HEADROOM;
+		xdp_prepare_buff(&xdp, desc->addr, NETSEC_RXBUF_HEADROOM,
+				 pkt_len);
 		xdp_set_data_meta_invalid(&xdp);
-		xdp.data_end = xdp.data + pkt_len;
 
 		if (xdp_prog) {
 			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 78a923391828..c08fd6a6be9b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -392,22 +392,17 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
+		int headroom = CPSW_HEADROOM, size = len;
 
+		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
-			xdp.data = pa + CPSW_HEADROOM +
-				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
-			xdp.data_end = xdp.data + len -
-				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
-		} else {
-			xdp.data = pa + CPSW_HEADROOM;
-			xdp.data_end = xdp.data + len;
+			headroom += CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+			size -= CPSW_RX_VLAN_ENCAP_HDR_SIZE;
 		}
 
+		xdp_prepare_buff(&xdp, pa, headroom, size);
 		xdp_set_data_meta_invalid(&xdp);
 
-		xdp.data_hard_start = pa;
-
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
 		if (ret != CPSW_XDP_PASS)
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1b3385ec9645..c74c997d1cf2 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -335,22 +335,17 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
-		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
+		int headroom = CPSW_HEADROOM, size = len;
 
+		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
 		if (status & CPDMA_RX_VLAN_ENCAP) {
-			xdp.data = pa + CPSW_HEADROOM +
-				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
-			xdp.data_end = xdp.data + len -
-				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
-		} else {
-			xdp.data = pa + CPSW_HEADROOM;
-			xdp.data_end = xdp.data + len;
+			headroom += CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+			size -= CPSW_RX_VLAN_ENCAP_HDR_SIZE;
 		}
 
+		xdp_prepare_buff(&xdp, pa, headroom, size);
 		xdp_set_data_meta_invalid(&xdp);
 
-		xdp.data_hard_start = pa;
-
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)
 			goto requeue;
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 14a7ee4c6899..93c202d6aff5 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -45,10 +45,8 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	}
 
 	xdp_init_buff(xdp, PAGE_SIZE, &nvchan->xdp_rxq);
-	xdp->data_hard_start = page_address(page);
-	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
+	xdp_prepare_buff(xdp, page_address(page), NETVSC_XDP_HDRM, len);
 	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
 
 	memcpy(xdp->data, data, len);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a82f7823d428..c7cbd058b345 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1600,10 +1600,8 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		u32 act;
 
 		xdp_init_buff(&xdp, buflen, &tfile->xdp_rxq);
-		xdp.data_hard_start = buf;
-		xdp.data = buf + pad;
+		xdp_prepare_buff(&xdp, buf, pad, len);
 		xdp_set_data_meta_invalid(&xdp);
-		xdp.data_end = xdp.data + len;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 25f3601fb6dd..30a7f2ad39c3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -710,11 +710,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		skb = nskb;
 	}
 
-	xdp.data_hard_start = skb->head;
-	xdp.data = skb_mac_header(skb);
-	xdp.data_end = xdp.data + pktlen;
-	xdp.data_meta = xdp.data;
-
+	xdp_prepare_buff(&xdp, skb->head, skb->mac_header, pktlen);
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
 	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a22ce87bcd9c..e57b2d452cbc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -690,10 +690,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		}
 
 		xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
-		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
-		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp.data_end = xdp.data + len;
-		xdp.data_meta = xdp.data;
+		xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
+				 xdp_headroom, len);
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -859,10 +857,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		 */
 		data = page_address(xdp_page) + offset;
 		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
-		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
-		xdp.data = data + vi->hdr_len;
-		xdp.data_end = xdp.data + (len - vi->hdr_len);
-		xdp.data_meta = xdp.data;
+		xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
+				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len);
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 329397c60d84..61d3f5f8b7f3 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 
 	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
 		      &queue->xdp_rxq);
-	xdp->data_hard_start = page_address(pdata);
-	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
+	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM, len);
 	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3fb3a9aa1b71..66d8a4b317a3 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 	xdp->rxq = rxq;
 }
 
+static inline void
+xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
+		 int headroom, int data_len)
+{
+	unsigned char *data = hard_start + headroom;
+
+	xdp->data_hard_start = hard_start;
+	xdp->data = data;
+	xdp->data_end = data + data_len;
+	xdp->data_meta = data;
+}
+
 /* Reserve memory area at end-of data area.
  *
  * This macro reserves tailroom in the XDP buffer by limiting the
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index a8fa5a9e4137..fe5a80d396e3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -636,10 +636,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	xdp.data_hard_start = data;
-	xdp.data = data + headroom;
-	xdp.data_meta = xdp.data;
-	xdp.data_end = xdp.data + size;
+	xdp_prepare_buff(&xdp, data, headroom, size);
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
diff --git a/net/core/dev.c b/net/core/dev.c
index bac56afcf6bc..2997177876cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4592,7 +4592,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
 	bool orig_bcast;
-	int hlen, off;
+	int off;
 
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
@@ -4624,11 +4624,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
-	hlen = skb_headlen(skb) + mac_len;
-	xdp->data = skb->data - mac_len;
-	xdp->data_meta = xdp->data;
-	xdp->data_end = xdp->data + hlen;
-	xdp->data_hard_start = skb->data - skb_headroom(skb);
+	xdp_prepare_buff(xdp, skb->data - skb_headroom(skb),
+			 skb_headroom(skb) - mac_len,
+			 skb_headlen(skb) + mac_len);
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	frame_sz = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
-- 
2.29.2

