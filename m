Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B932E0FB9
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgLVVK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:10:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgLVVK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:10:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D32F22AB9;
        Tue, 22 Dec 2020 21:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608671386;
        bh=8WBTn+Omllr9Fi01pNBqrd8rGVRyBF0L62DXwHHK68A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=id7XZY7a7Qay4va25SG9bRd8ErQEO2vkfLXdmbL07aIabAoEGIqYtMdmIq72USWQ7
         o6uonIzEM5f9N/2GYBRXotEBNbl9HnUVUe/zAu8RKdTrMzUb1FulfTiyUwNkGKcdWJ
         Xom+aureKROPtOoaPgLh9l7JvnUAyaDKm4Vv6aPnrsLwPLy24h9Pm9Jlg0Wv4GKi5h
         Q1H4EEgeShrlc4NDRNGmdDtmghvUVvJhKGC2hxgl1diIG90O8mmioaTN2R9+19iE4n
         QXPzYc2UP6Ma5Lg2LR7fIYtovOf98OI+AnmVT6zRtFweAE2zHqdke4qzvuEfl4sSmr
         jfAdGXqvd8lsw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff utility routine
Date:   Tue, 22 Dec 2020 22:09:29 +0100
Message-Id: <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1608670965.git.lorenzo@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  7 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  5 +----
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  8 ++++----
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  6 ++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 +++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 +++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  9 +++++----
 drivers/net/ethernet/intel/igb/igb_main.c     | 12 +++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 +++++------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 12 +++++------
 drivers/net/ethernet/marvell/mvneta.c         |  7 ++-----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +++-----
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  6 ++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 +----
 .../ethernet/netronome/nfp/nfp_net_common.c   |  8 ++++----
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  6 ++----
 drivers/net/ethernet/sfc/rx.c                 |  7 ++-----
 drivers/net/ethernet/socionext/netsec.c       |  6 ++----
 drivers/net/ethernet/ti/cpsw.c                | 16 +++++----------
 drivers/net/ethernet/ti/cpsw_new.c            | 16 +++++----------
 drivers/net/hyperv/netvsc_bpf.c               |  5 +----
 drivers/net/tun.c                             |  5 +----
 drivers/net/veth.c                            |  8 ++------
 drivers/net/virtio_net.c                      | 12 ++++-------
 drivers/net/xen-netfront.c                    |  6 ++----
 include/net/xdp.h                             | 12 +++++++++++
 net/bpf/test_run.c                            |  7 ++-----
 net/core/dev.c                                | 20 +++++++++----------
 28 files changed, 105 insertions(+), 152 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 43331f6967c9..1db6cfd2b55c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1585,10 +1585,9 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	int ret;
 
 	rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-	xdp->data = page_address(rx_info->page) + rx_info->page_offset;
-	xdp_set_data_meta_invalid(xdp);
-	xdp->data_hard_start = page_address(rx_info->page);
-	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
+	xdp_prepare_buff(xdp, page_address(rx_info->page),
+			 rx_info->page_offset,
+			 rx_ring->ena_bufs[0].len, false);
 	/* If for some reason we received a bigger packet than
 	 * we expect, then we simply drop it
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index ab805d6750e5..641303894341 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -135,10 +135,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	txr = rxr->bnapi->tx_ring;
 	/* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
 	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
-	xdp.data_hard_start = *data_ptr - offset;
-	xdp.data = *data_ptr;
-	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = *data_ptr + *len;
+	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len, false);
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 9fc672f075f2..c33b4e837515 100644
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
@@ -549,10 +550,9 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 
 	xdp_init_buff(&xdp, RCV_FRAG_LEN + XDP_PACKET_HEADROOM,
 		      &rq->xdp_rxq);
-	xdp.data_hard_start = page_address(page);
-	xdp.data = (void *)cpu_addr;
-	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + len;
+	hard_start = page_address(page);
+	data = (unsigned char *)cpu_addr;
+	xdp_prepare_buff(&xdp, hard_start, data - hard_start, len, false);
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 26e20b96fd96..d8e568f6caf3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2534,10 +2534,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 
 	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
 		      &dpaa_fq->xdp_rxq);
-	xdp.data = vaddr + fd_off;
-	xdp.data_meta = xdp.data;
-	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
-	xdp.data_end = xdp.data + qm_fd_get_length(fd);
+	xdp_prepare_buff(&xdp, vaddr + fd_off - XDP_PACKET_HEADROOM,
+			 XDP_PACKET_HEADROOM, qm_fd_get_length(fd), true);
 
 	/* We reserve a fixed headroom of 256 bytes under the erratum and we
 	 * offer it all to XDP programs to use. If no room is left for the
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a4ade0b5adb0..ca5b9be1c345 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -350,7 +350,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
 	u32 xdp_act = XDP_PASS;
-	int err;
+	int err, offset;
 
 	rcu_read_lock();
 
@@ -358,14 +358,10 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	if (!xdp_prog)
 		goto out;
 
-	xdp_init_buff(&xdp,
-		      DPAA2_ETH_RX_BUF_RAW_SIZE -
-		      (dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM),
-		      &ch->xdp_rxq);
-	xdp.data = vaddr + dpaa2_fd_get_offset(fd);
-	xdp.data_end = xdp.data + dpaa2_fd_get_len(fd);
-	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
-	xdp_set_data_meta_invalid(&xdp);
+	offset = dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM;
+	xdp_init_buff(&xdp, DPAA2_ETH_RX_BUF_RAW_SIZE - offset, &ch->xdp_rxq);
+	xdp_prepare_buff(&xdp, vaddr + offset, XDP_PACKET_HEADROOM,
+			 dpaa2_fd_get_len(fd), false);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a87fb8264d0c..2574e78f7597 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2406,12 +2406,12 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
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
+			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 500e93bf6238..422f53997c02 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1104,8 +1104,10 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
+		unsigned int offset = ice_rx_offset(rx_ring);
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
+		unsigned char *hard_start;
 		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
@@ -1151,10 +1153,9 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			goto construct_skb;
 		}
 
-		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
-		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
-		xdp.data_meta = xdp.data;
-		xdp.data_end = xdp.data + size;
+		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
+			     offset;
+		xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index cf9e8b7d2c70..6b5adbd9660b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8715,12 +8715,12 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 
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
+			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7ec196589a07..e714db51701a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2335,12 +2335,12 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 
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
+			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 624efcd71569..a534a3fb392e 100644
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
+			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index acbb9cb85ada..d6da44b9c7ea 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2263,11 +2263,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 
 	/* Prefetch header */
 	prefetch(data);
-
-	xdp->data_hard_start = data;
-	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
-	xdp->data_end = xdp->data + data_len;
-	xdp_set_data_meta_invalid(xdp);
+	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
+			 data_len, false);
 
 	sinfo = xdp_get_shared_info_from_buff(xdp);
 	sinfo->nr_frags = 0;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ca05dfc05058..a76b0adb01c6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3564,17 +3564,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
-			xdp_set_data_meta_invalid(&xdp);
+			xdp_prepare_buff(&xdp, data,
+					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
+					 rx_bytes, false);
 
 			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 815381b484ca..63ff85ae0371 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -776,10 +776,8 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 						priv->frag_info[0].frag_size,
 						DMA_FROM_DEVICE);
 
-			xdp.data_hard_start = va - frags[0].page_offset;
-			xdp.data = va;
-			xdp_set_data_meta_invalid(&xdp);
-			xdp.data_end = xdp.data + length;
+			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
+					 frags[0].page_offset, length, false);
 			orig_data = xdp.data;
 
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index bc7c81f2b036..a63ce7c8b98f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1127,10 +1127,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
-	xdp->data_hard_start = va;
-	xdp->data = va + headroom;
-	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
+	xdp_prepare_buff(xdp, va, headroom, len, false);
 }
 
 static struct sk_buff *
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f66be67e8b40..c56889601049 100644
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
+					 pkt_len, true);
 
 			act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index d40220043883..76ef9879db17 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1091,10 +1091,8 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	enum xdp_action act;
 
 	xdp_init_buff(&xdp, rxq->rx_buf_seg_size, &rxq->xdp_rxq);
-	xdp.data_hard_start = page_address(bd->data);
-	xdp.data = xdp.data_hard_start + *data_offset;
-	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + *len;
+	xdp_prepare_buff(&xdp, page_address(bd->data), *data_offset,
+			 *len, false);
 
 	/* Queues always have a full reset currently, so for the time
 	 * being until there's atomic program replace just mark read
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index eaa6650955d1..89c5c75f479f 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -294,12 +294,9 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	       efx->rx_prefix_size);
 
 	xdp_init_buff(&xdp, efx->rx_page_buf_step, &rx_queue->xdp_rxq_info);
-	xdp.data = *ehp;
-	xdp.data_hard_start = xdp.data - EFX_XDP_HEADROOM;
-
 	/* No support yet for XDP metadata */
-	xdp_set_data_meta_invalid(&xdp);
-	xdp.data_end = xdp.data + rx_buf->len;
+	xdp_prepare_buff(&xdp, *ehp - EFX_XDP_HEADROOM, EFX_XDP_HEADROOM,
+			 rx_buf->len, false);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	rcu_read_unlock();
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 945ca9517bf9..3c53051bdacf 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1015,10 +1015,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 					dma_dir);
 		prefetch(desc->addr);
 
-		xdp.data_hard_start = desc->addr;
-		xdp.data = desc->addr + NETSEC_RXBUF_HEADROOM;
-		xdp_set_data_meta_invalid(&xdp);
-		xdp.data_end = xdp.data + pkt_len;
+		xdp_prepare_buff(&xdp, desc->addr, NETSEC_RXBUF_HEADROOM,
+				 pkt_len, false);
 
 		if (xdp_prog) {
 			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 78a923391828..5239318e9686 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -392,21 +392,15 @@ static void cpsw_rx_handler(void *token, int len, int status)
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
 
-		xdp_set_data_meta_invalid(&xdp);
-
-		xdp.data_hard_start = pa;
+		xdp_prepare_buff(&xdp, pa, headroom, size, false);
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1b3385ec9645..94747f82c60b 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -335,21 +335,15 @@ static void cpsw_rx_handler(void *token, int len, int status)
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
 
-		xdp_set_data_meta_invalid(&xdp);
-
-		xdp.data_hard_start = pa;
+		xdp_prepare_buff(&xdp, pa, headroom, size, false);
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 14a7ee4c6899..d60dcf6c9829 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -45,10 +45,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	}
 
 	xdp_init_buff(xdp, PAGE_SIZE, &nvchan->xdp_rxq);
-	xdp->data_hard_start = page_address(page);
-	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
-	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
+	xdp_prepare_buff(xdp, page_address(page), NETVSC_XDP_HDRM, len, false);
 
 	memcpy(xdp->data, data, len);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a82f7823d428..1f57294cfd77 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1600,10 +1600,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		u32 act;
 
 		xdp_init_buff(&xdp, buflen, &tfile->xdp_rxq);
-		xdp.data_hard_start = buf;
-		xdp.data = buf + pad;
-		xdp_set_data_meta_invalid(&xdp);
-		xdp.data_end = xdp.data + len;
+		xdp_prepare_buff(&xdp, buf, pad, len, false);
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6a0afce0253c..6e03b619c93c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -698,15 +698,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		skb = nskb;
 	}
 
-	xdp.data_hard_start = skb->head;
-	xdp.data = skb_mac_header(skb);
-	xdp.data_end = xdp.data + pktlen;
-	xdp.data_meta = xdp.data;
-
 	/* SKB "head" area always have tailroom for skb_shared_info */
-	frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
+	frame_sz = skb_end_pointer(skb) - skb->head;
 	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, skb->head, skb->mac_header, pktlen, true);
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a22ce87bcd9c..f65eea603f7d 100644
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
+				 xdp_headroom, len, true);
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
+				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 329397c60d84..c20b78120bb4 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 
 	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
 		      &queue->xdp_rxq);
-	xdp->data_hard_start = page_address(pdata);
-	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
-	xdp_set_data_meta_invalid(xdp);
-	xdp->data_end = xdp->data + len;
+	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM,
+			 len, false);
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 323340caef88..c4bfdc9a8b79 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 	xdp->rxq = rxq;
 }
 
+static __always_inline void
+xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
+		 int headroom, int data_len, const bool meta_valid)
+{
+	unsigned char *data = hard_start + headroom;
+
+	xdp->data_hard_start = hard_start;
+	xdp->data = data;
+	xdp->data_end = data + data_len;
+	xdp->data_meta = meta_valid ? data : data + 1;
+}
+
 /* Reserve memory area at end-of data area.
  *
  * This macro reserves tailroom in the XDP buffer by limiting the
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index a8fa5a9e4137..23dfb2010ba6 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -636,14 +636,11 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	xdp.data_hard_start = data;
-	xdp.data = data + headroom;
-	xdp.data_meta = xdp.data;
-	xdp.data_end = xdp.data + size;
-
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
 		      &rxqueue->xdp_rxq);
+	xdp_prepare_buff(&xdp, data, headroom, size, true);
+
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
diff --git a/net/core/dev.c b/net/core/dev.c
index b1a765900c01..2c99c48ee180 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4585,14 +4585,14 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 				     struct xdp_buff *xdp,
 				     struct bpf_prog *xdp_prog)
 {
+	void *orig_data, *orig_data_end, *hard_start;
 	struct netdev_rx_queue *rxqueue;
-	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
 	bool orig_bcast;
-	int hlen, off;
+	int off;
 
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
@@ -4624,25 +4624,23 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
-	hlen = skb_headlen(skb) + mac_len;
-	xdp->data = skb->data - mac_len;
-	xdp->data_meta = xdp->data;
-	xdp->data_end = xdp->data + hlen;
-	xdp->data_hard_start = skb->data - skb_headroom(skb);
+	hard_start = skb->data - skb_headroom(skb);
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
-	frame_sz = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
+	frame_sz = (void *)skb_end_pointer(skb) - hard_start;
 	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
+	rxqueue = netif_get_rxqueue(skb);
+	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
+	xdp_prepare_buff(xdp, hard_start, skb_headroom(skb) - mac_len,
+			 skb_headlen(skb) + mac_len, true);
+
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
 	eth = (struct ethhdr *)xdp->data;
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
-	rxqueue = netif_get_rxqueue(skb);
-	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
-
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
-- 
2.29.2

