Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655C2DF0CD
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgLSRz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbgLSRz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 12:55:56 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v4 bpf-next 1/2] net: xdp: introduce xdp_init_buff utility routine
Date:   Sat, 19 Dec 2020 18:55:00 +0100
Message-Id: <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608399672.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1608399672.git.lorenzo@kernel.org>
References: <cover.1608399672.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_init_buff utility routine to initialize xdp_buff fields
const over NAPI iterations (e.g. frame_sz or rxq pointer). Rely on
xdp_init_buff in all XDP capable drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c        | 3 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 4 ++--
 drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 4 ++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c      | 4 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 8 ++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 6 +++---
 drivers/net/ethernet/intel/ice/ice_txrx.c           | 6 +++---
 drivers/net/ethernet/intel/igb/igb_main.c           | 6 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 7 +++----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 7 +++----
 drivers/net/ethernet/marvell/mvneta.c               | 3 +--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 8 +++++---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 3 +--
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c          | 3 +--
 drivers/net/ethernet/sfc/rx.c                       | 3 +--
 drivers/net/ethernet/socionext/netsec.c             | 3 +--
 drivers/net/ethernet/ti/cpsw.c                      | 4 ++--
 drivers/net/ethernet/ti/cpsw_new.c                  | 4 ++--
 drivers/net/hyperv/netvsc_bpf.c                     | 3 +--
 drivers/net/tun.c                                   | 7 +++----
 drivers/net/veth.c                                  | 8 ++++----
 drivers/net/virtio_net.c                            | 6 ++----
 drivers/net/xen-netfront.c                          | 4 ++--
 include/net/xdp.h                                   | 7 +++++++
 net/bpf/test_run.c                                  | 4 ++--
 net/core/dev.c                                      | 8 ++++----
 28 files changed, 68 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 06596fa1f9fe..43331f6967c9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1634,8 +1634,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 		  "%s qid %d\n", __func__, rx_ring->qid);
 	res_budget = budget;
-	xdp.rxq = &rx_ring->xdp_rxq;
-	xdp.frame_sz = ENA_PAGE_SIZE;
+	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
 
 	do {
 		xdp_verdict = XDP_PASS;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index fcc262064766..ab805d6750e5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -133,12 +133,12 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
 
 	txr = rxr->bnapi->tx_ring;
+	/* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
+	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
 	xdp.data_hard_start = *data_ptr - offset;
 	xdp.data = *data_ptr;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = *data_ptr + *len;
-	xdp.rxq = &rxr->xdp_rxq;
-	xdp.frame_sz = PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index f3b7b443f964..9fc672f075f2 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -547,12 +547,12 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	cpu_addr = (u64)phys_to_virt(cpu_addr);
 	page = virt_to_page((void *)cpu_addr);
 
+	xdp_init_buff(&xdp, RCV_FRAG_LEN + XDP_PACKET_HEADROOM,
+		      &rq->xdp_rxq);
 	xdp.data_hard_start = page_address(page);
 	xdp.data = (void *)cpu_addr;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + len;
-	xdp.rxq = &rq->xdp_rxq;
-	xdp.frame_sz = RCV_FRAG_LEN + XDP_PACKET_HEADROOM;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4360ce4d3fb6..26e20b96fd96 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2532,12 +2532,12 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		return XDP_PASS;
 	}
 
+	xdp_init_buff(&xdp, DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE,
+		      &dpaa_fq->xdp_rxq);
 	xdp.data = vaddr + fd_off;
 	xdp.data_meta = xdp.data;
 	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
 	xdp.data_end = xdp.data + qm_fd_get_length(fd);
-	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
-	xdp.rxq = &dpaa_fq->xdp_rxq;
 
 	/* We reserve a fixed headroom of 256 bytes under the erratum and we
 	 * offer it all to XDP programs to use. If no room is left for the
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 91cff93dbdae..a4ade0b5adb0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -358,14 +358,14 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	if (!xdp_prog)
 		goto out;
 
+	xdp_init_buff(&xdp,
+		      DPAA2_ETH_RX_BUF_RAW_SIZE -
+		      (dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM),
+		      &ch->xdp_rxq);
 	xdp.data = vaddr + dpaa2_fd_get_offset(fd);
 	xdp.data_end = xdp.data + dpaa2_fd_get_len(fd);
 	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
 	xdp_set_data_meta_invalid(&xdp);
-	xdp.rxq = &ch->xdp_rxq;
-
-	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE -
-		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 4aca637d4a23..a87fb8264d0c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2344,7 +2344,7 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
  **/
 static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int xdp_xmit = 0;
@@ -2352,9 +2352,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	struct xdp_buff xdp;
 
 #if (PAGE_SIZE < 8192)
-	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
+	frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
 #endif
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index a2d0aad8cfdd..500e93bf6238 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1089,18 +1089,18 @@ ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  */
 int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
+	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
 	bool failure;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-	xdp.frame_sz = ice_rx_frame_truesize(rx_ring, 0);
+	frame_sz = ice_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..cf9e8b7d2c70 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8681,13 +8681,13 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	u16 cleaned_count = igb_desc_unused(rx_ring);
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
-
-	xdp.rxq = &rx_ring->xdp_rxq;
+	u32 frame_sz = 0;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-	xdp.frame_sz = igb_rx_frame_truesize(rx_ring, 0);
+	frame_sz = igb_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	while (likely(total_packets < budget)) {
 		union e1000_adv_rx_desc *rx_desc;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 393d1c2cd853..7ec196589a07 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2291,7 +2291,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			       struct ixgbe_ring *rx_ring,
 			       const int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	struct ixgbe_adapter *adapter = q_vector->adapter;
 #ifdef IXGBE_FCOE
 	int ddp_bytes;
@@ -2301,12 +2301,11 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
-
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
+	frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 4061cd7db5dd..624efcd71569 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1121,19 +1121,18 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
 				struct ixgbevf_ring *rx_ring,
 				int budget)
 {
-	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	struct ixgbevf_adapter *adapter = q_vector->adapter;
 	u16 cleaned_count = ixgbevf_desc_unused(rx_ring);
 	struct sk_buff *skb = rx_ring->skb;
 	bool xdp_xmit = false;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
-
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
-	xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, 0);
+	frame_sz = ixgbevf_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	while (likely(total_rx_packets < budget)) {
 		struct ixgbevf_rx_buffer *rx_buffer;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac3060f..acbb9cb85ada 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2363,9 +2363,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	u32 desc_status, frame_sz;
 	struct xdp_buff xdp_buf;
 
+	xdp_init_buff(&xdp_buf, PAGE_SIZE, &rxq->xdp_rxq);
 	xdp_buf.data_hard_start = NULL;
-	xdp_buf.frame_sz = PAGE_SIZE;
-	xdp_buf.rxq = &rxq->xdp_rxq;
 
 	sinfo.nr_frags = 0;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index afdd22827223..ca05dfc05058 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3562,16 +3562,18 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			frag_size = bm_pool->frag_size;
 
 		if (xdp_prog) {
+			struct xdp_rxq_info *xdp_rxq;
+
 			xdp.data_hard_start = data;
 			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
 			xdp.data_end = xdp.data + rx_bytes;
-			xdp.frame_sz = PAGE_SIZE;
 
 			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
-				xdp.rxq = &rxq->xdp_rxq_short;
+				xdp_rxq = &rxq->xdp_rxq_short;
 			else
-				xdp.rxq = &rxq->xdp_rxq_long;
+				xdp_rxq = &rxq->xdp_rxq_long;
 
+			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
 			xdp_set_data_meta_invalid(&xdp);
 
 			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 7954c1daf2b6..815381b484ca 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -682,8 +682,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	/* Protect accesses to: ring->xdp_prog, priv->mac_hash list */
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(ring->xdp_prog);
-	xdp.rxq = &ring->xdp_rxq;
-	xdp.frame_sz = priv->frag_info[0].frag_stride;
+	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
 	doorbell_pending = false;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7f5851c61218..bc7c81f2b036 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1126,12 +1126,11 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
+	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
 	xdp->data_hard_start = va;
 	xdp->data = va + headroom;
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
-	xdp->rxq = &rq->xdp_rxq;
-	xdp->frame_sz = rq->buff.frame0_sz;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f21fb573ea3e..f66be67e8b40 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1822,8 +1822,8 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(dp->xdp_prog);
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
-	xdp.frame_sz = PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM;
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp_init_buff(&xdp, PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM,
+		      &rx_ring->xdp_rxq);
 	tx_ring = r_vec->xdp_ring;
 
 	while (pkts_polled < budget) {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf85007..d40220043883 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1090,12 +1090,11 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	struct xdp_buff xdp;
 	enum xdp_action act;
 
+	xdp_init_buff(&xdp, rxq->rx_buf_seg_size, &rxq->xdp_rxq);
 	xdp.data_hard_start = page_address(bd->data);
 	xdp.data = xdp.data_hard_start + *data_offset;
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + *len;
-	xdp.rxq = &rxq->xdp_rxq;
-	xdp.frame_sz = rxq->rx_buf_seg_size; /* PAGE_SIZE when XDP enabled */
 
 	/* Queues always have a full reset currently, so for the time
 	 * being until there's atomic program replace just mark read
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index aaa112877561..eaa6650955d1 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -293,14 +293,13 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	memcpy(rx_prefix, *ehp - efx->rx_prefix_size,
 	       efx->rx_prefix_size);
 
+	xdp_init_buff(&xdp, efx->rx_page_buf_step, &rx_queue->xdp_rxq_info);
 	xdp.data = *ehp;
 	xdp.data_hard_start = xdp.data - EFX_XDP_HEADROOM;
 
 	/* No support yet for XDP metadata */
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + rx_buf->len;
-	xdp.rxq = &rx_queue->xdp_rxq_info;
-	xdp.frame_sz = efx->rx_page_buf_step;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	rcu_read_unlock();
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 19d20a6d0d44..945ca9517bf9 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -956,8 +956,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	u32 xdp_act = 0;
 	int done = 0;
 
-	xdp.rxq = &dring->xdp_rxq;
-	xdp.frame_sz = PAGE_SIZE;
+	xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b0f00b4edd94..78a923391828 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -392,6 +392,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
+		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
+
 		if (status & CPDMA_RX_VLAN_ENCAP) {
 			xdp.data = pa + CPSW_HEADROOM +
 				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
@@ -405,8 +407,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp_set_data_meta_invalid(&xdp);
 
 		xdp.data_hard_start = pa;
-		xdp.rxq = &priv->xdp_rxq[ch];
-		xdp.frame_sz = PAGE_SIZE;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 2f5e0ad23ad7..1b3385ec9645 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -335,6 +335,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 	if (priv->xdp_prog) {
+		xdp_init_buff(&xdp, PAGE_SIZE, &priv->xdp_rxq[ch]);
+
 		if (status & CPDMA_RX_VLAN_ENCAP) {
 			xdp.data = pa + CPSW_HEADROOM +
 				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
@@ -348,8 +350,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp_set_data_meta_invalid(&xdp);
 
 		xdp.data_hard_start = pa;
-		xdp.rxq = &priv->xdp_rxq[ch];
-		xdp.frame_sz = PAGE_SIZE;
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 440486d9c999..14a7ee4c6899 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -44,12 +44,11 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 		goto out;
 	}
 
+	xdp_init_buff(xdp, PAGE_SIZE, &nvchan->xdp_rxq);
 	xdp->data_hard_start = page_address(page);
 	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
-	xdp->rxq = &nvchan->xdp_rxq;
-	xdp->frame_sz = PAGE_SIZE;
 
 	memcpy(xdp->data, data, len);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbed05ae7b0f..a82f7823d428 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1599,12 +1599,11 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		struct xdp_buff xdp;
 		u32 act;
 
+		xdp_init_buff(&xdp, buflen, &tfile->xdp_rxq);
 		xdp.data_hard_start = buf;
 		xdp.data = buf + pad;
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
-		xdp.rxq = &tfile->xdp_rxq;
-		xdp.frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2344,9 +2343,9 @@ static int tun_xdp_one(struct tun_struct *tun,
 			skb_xdp = true;
 			goto build;
 		}
+
+		xdp_init_buff(xdp, buflen, &tfile->xdp_rxq);
 		xdp_set_data_meta_invalid(xdp);
-		xdp->rxq = &tfile->xdp_rxq;
-		xdp->frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index dbacf90df2b5..6a0afce0253c 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -642,7 +642,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 					struct veth_xdp_tx_bq *bq,
 					struct veth_stats *stats)
 {
-	u32 pktlen, headroom, act, metalen;
+	u32 pktlen, headroom, act, metalen, frame_sz;
 	void *orig_data, *orig_data_end;
 	struct bpf_prog *xdp_prog;
 	int mac_len, delta, off;
@@ -702,11 +702,11 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	xdp.data = skb_mac_header(skb);
 	xdp.data_end = xdp.data + pktlen;
 	xdp.data_meta = xdp.data;
-	xdp.rxq = &rq->xdp_rxq;
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
-	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
-	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
+	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 052975ea0af4..a22ce87bcd9c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -689,12 +689,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			page = xdp_page;
 		}
 
+		xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
 		xdp.data_end = xdp.data + len;
 		xdp.data_meta = xdp.data;
-		xdp.rxq = &rq->xdp_rxq;
-		xdp.frame_sz = buflen;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -859,12 +858,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		 * the descriptor on if we get an XDP_TX return code.
 		 */
 		data = page_address(xdp_page) + offset;
+		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
 		xdp.data_meta = xdp.data;
-		xdp.rxq = &rq->xdp_rxq;
-		xdp.frame_sz = frame_sz - vi->hdr_len;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848ef4649..329397c60d84 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -864,12 +864,12 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 	u32 act;
 	int err;
 
+	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
+		      &queue->xdp_rxq);
 	xdp->data_hard_start = page_address(pdata);
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
-	xdp->rxq = &queue->xdp_rxq;
-	xdp->frame_sz = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 11ec93f827c0..323340caef88 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -76,6 +76,13 @@ struct xdp_buff {
 	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
 };
 
+static __always_inline void
+xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
+{
+	xdp->frame_sz = frame_sz;
+	xdp->rxq = rxq;
+}
+
 /* Reserve memory area at end-of data area.
  *
  * This macro reserves tailroom in the XDP buffer by limiting the
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c1c30a9f76f3..a8fa5a9e4137 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -640,10 +640,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	xdp.data = data + headroom;
 	xdp.data_meta = xdp.data;
 	xdp.data_end = xdp.data + size;
-	xdp.frame_sz = headroom + max_data_sz + tailroom;
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
-	xdp.rxq = &rxqueue->xdp_rxq;
+	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
+		      &rxqueue->xdp_rxq);
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
diff --git a/net/core/dev.c b/net/core/dev.c
index a46334906c94..b1a765900c01 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4588,11 +4588,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
+	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
 	bool orig_bcast;
 	int hlen, off;
-	u32 mac_len;
 
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
@@ -4631,8 +4631,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	xdp->data_hard_start = skb->data - skb_headroom(skb);
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
-	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
-	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	frame_sz = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
+	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
@@ -4641,7 +4641,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	orig_eth_type = eth->h_proto;
 
 	rxqueue = netif_get_rxqueue(skb);
-	xdp->rxq = &rxqueue->xdp_rxq;
+	xdp_init_buff(xdp, frame_sz, &rxqueue->xdp_rxq);
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
-- 
2.29.2

