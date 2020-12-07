Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450032D160F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgLGQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLGQdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:33:44 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 02/14] xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
Date:   Mon,  7 Dec 2020 17:32:31 +0100
Message-Id: <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c        | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 1 +
 drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 1 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c           | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 1 +
 drivers/net/ethernet/marvell/mvneta.c               | 1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 1 +
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c          | 1 +
 drivers/net/ethernet/sfc/rx.c                       | 1 +
 drivers/net/ethernet/socionext/netsec.c             | 1 +
 drivers/net/ethernet/ti/cpsw.c                      | 1 +
 drivers/net/ethernet/ti/cpsw_new.c                  | 1 +
 drivers/net/hyperv/netvsc_bpf.c                     | 1 +
 drivers/net/tun.c                                   | 2 ++
 drivers/net/veth.c                                  | 1 +
 drivers/net/virtio_net.c                            | 2 ++
 drivers/net/xen-netfront.c                          | 1 +
 net/core/dev.c                                      | 1 +
 24 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0e98f45c2b22..abe826395e2f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1569,6 +1569,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	res_budget = budget;
 	xdp.rxq = &rx_ring->xdp_rxq;
 	xdp.frame_sz = ENA_PAGE_SIZE;
+	xdp.mb = 0;
 
 	do {
 		xdp_verdict = XDP_PASS;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index fcc262064766..344644b6dd4d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -139,6 +139,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	xdp.data_end = *data_ptr + *len;
 	xdp.rxq = &rxr->xdp_rxq;
 	xdp.frame_sz = PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
+	xdp.mb = 0;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index f3b7b443f964..4e790a50d14c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -553,6 +553,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	xdp.data_end = xdp.data + len;
 	xdp.rxq = &rq->xdp_rxq;
 	xdp.frame_sz = RCV_FRAG_LEN + XDP_PACKET_HEADROOM;
+	xdp.mb = 0;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 91cff93dbdae..fe70be3ca399 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -366,6 +366,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 
 	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE -
 		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
+	xdp.mb = 0;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 9f73cd7aee09..1c8acebfde3d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2343,6 +2343,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
 #endif
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 77d5eae6b4c2..0f8a996e298b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1089,6 +1089,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = ice_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp.mb = 0;
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 50e6b8b6ba7b..2e028b306677 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2298,6 +2298,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp.mb = 0;
 
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 4061cd7db5dd..037bfb2aadac 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1129,6 +1129,7 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
 	struct xdp_buff xdp;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac3060f..1e5b5c69685a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2366,6 +2366,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	xdp_buf.data_hard_start = NULL;
 	xdp_buf.frame_sz = PAGE_SIZE;
 	xdp_buf.rxq = &rxq->xdp_rxq;
+	xdp_buf.mb = 0;
 
 	sinfo.nr_frags = 0;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index afdd22827223..32b48de36841 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3566,6 +3566,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
 			xdp.data_end = xdp.data + rx_bytes;
 			xdp.frame_sz = PAGE_SIZE;
+			xdp.mb = 0;
 
 			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
 				xdp.rxq = &rxq->xdp_rxq_short;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 7954c1daf2b6..547ff84bb71a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,6 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
 	xdp.frame_sz = priv->frag_info[0].frag_stride;
+	xdp.mb = 0;
 	doorbell_pending = false;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6628a0197b4e..50fd12ba3a0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1133,6 +1133,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &rq->xdp_rxq;
 	xdp->frame_sz = rq->buff.frame0_sz;
+	xdp->mb = 0;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b4acf2f41e84..4e762bbf283c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1824,6 +1824,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
 	xdp.frame_sz = PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM;
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 	tx_ring = r_vec->xdp_ring;
 
 	while (pkts_polled < budget) {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf85007..14a54094ca08 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1096,6 +1096,7 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	xdp.data_end = xdp.data + *len;
 	xdp.rxq = &rxq->xdp_rxq;
 	xdp.frame_sz = rxq->rx_buf_seg_size; /* PAGE_SIZE when XDP enabled */
+	xdp.mb = 0;
 
 	/* Queues always have a full reset currently, so for the time
 	 * being until there's atomic program replace just mark read
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index aaa112877561..286feb510c21 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -301,6 +301,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	xdp.data_end = xdp.data + rx_buf->len;
 	xdp.rxq = &rx_queue->xdp_rxq_info;
 	xdp.frame_sz = efx->rx_page_buf_step;
+	xdp.mb = 0;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	rcu_read_unlock();
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 19d20a6d0d44..8853db2575f0 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -958,6 +958,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp.rxq = &dring->xdp_rxq;
 	xdp.frame_sz = PAGE_SIZE;
+	xdp.mb = 0;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b0f00b4edd94..6e3fa1994bd5 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -407,6 +407,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
 		xdp.frame_sz = PAGE_SIZE;
+		xdp.mb = 0;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 2f5e0ad23ad7..a13535fefbeb 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -350,6 +350,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
 		xdp.frame_sz = PAGE_SIZE;
+		xdp.mb = 0;
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 440486d9c999..a4bafc64997f 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -50,6 +50,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &nvchan->xdp_rxq;
 	xdp->frame_sz = PAGE_SIZE;
+	xdp->mb = 0;
 
 	memcpy(xdp->data, data, len);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbed05ae7b0f..8c100f4b2001 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1605,6 +1605,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2347,6 +2348,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
 		xdp->frame_sz = buflen;
+		xdp->mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 02bfcdf50a7a..52e050228a42 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -719,6 +719,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
 	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp.mb = 0;
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 052975ea0af4..4c15e30d7ef1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -695,6 +695,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -865,6 +866,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = frame_sz - vi->hdr_len;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848ef4649..34a254eab58b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -870,6 +870,7 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &queue->xdp_rxq;
 	xdp->frame_sz = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
+	xdp->mb = 0;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
diff --git a/net/core/dev.c b/net/core/dev.c
index ce8fea2e2788..7f0b2b25860a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4633,6 +4633,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
 	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp->mb = 0;
 
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
-- 
2.28.0

