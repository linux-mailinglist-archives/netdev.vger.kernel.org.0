Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C9281575
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388171AbgJBOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOmc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:32 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5178C20719;
        Fri,  2 Oct 2020 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649750;
        bh=LxNPYsGGK2VbzekPFKAjqYOFrt5K/1kDpfiN9h5n05I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDOdnIvFlldyEYf1C2uiHfd7/4zY3EBJSr7D4M2p+jBKwjK6cl+FJ0NWiDiuCeHLq
         9Jj8hjwCSMc+LB3fLf4vLiejaxl9oCNBJ68Upmm197CkNIbwCZfjCMKRRuz8PRXTqF
         bLN0uhcQ0QwN5eeYCc0TDLDqx65E8gAzQ8+pzR0M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 02/13] xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
Date:   Fri,  2 Oct 2020 16:42:00 +0200
Message-Id: <31f641800f63ad8c221785c54295112f01935106.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
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
 23 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e8131dadc22c..339319b97853 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1595,6 +1595,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
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
index 0a94c396173b..7fdabaabab1b 100644
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
index fe4caf7aad7c..8410e713162e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -366,6 +366,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 
 	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE -
 		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
+	xdp.mb = 0;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d43ce13a93c9..5df07bc98283 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2332,6 +2332,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
 #endif
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae75260fe20..d641f513b8d9 100644
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
index a190d5c616fc..39f9d2032b9d 100644
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
index 82fce27f682b..1fbc740c266e 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1129,6 +1129,7 @@ static int ixgbevf_clean_rx_irq(struct ixgbevf_q_vector *q_vector,
 	struct xdp_buff xdp;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f6616c8933ca..01661ade9009 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3558,6 +3558,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
 			xdp.data_end = xdp.data + rx_bytes;
 			xdp.frame_sz = PAGE_SIZE;
+			xdp.mb = 0;
 
 			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
 				xdp.rxq = &rxq->xdp_rxq_short;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 99d7737e8ad6..de1ae36b068e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,6 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
 	xdp.frame_sz = priv->frag_info[0].frag_stride;
+	xdp.mb = 0;
 	doorbell_pending = 0;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 599f5b5ebc97..82c3e755dadd 100644
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
index b150da43adb2..69fab1010752 100644
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
index 806eb651cea3..0f0567083a6c 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -947,6 +947,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp.rxq = &dring->xdp_rxq;
 	xdp.frame_sz = PAGE_SIZE;
+	xdp.mb = 0;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9fd1f77190ad..558e0abb03c1 100644
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
index f779d2e1b5c5..7baab97e302a 100644
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
index be69d272052f..d8380feb7626 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1641,6 +1641,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2388,6 +2389,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
 		xdp->frame_sz = buflen;
+		xdp->mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 091e5b4ba042..e25af95a532d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -711,6 +711,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp.frame_sz = (void *)skb_end_pointer(skb) - xdp.data_hard_start;
 	xdp.frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp.mb = 0;
 
 	orig_data = xdp.data;
 	orig_data_end = xdp.data_end;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7145c83c6c8c..3d39d7622840 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -690,6 +690,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = buflen;
+		xdp.mb = 0;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -860,6 +861,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		xdp.frame_sz = frame_sz - vi->hdr_len;
+		xdp.mb = 0;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3e9895bec15f..00440ad34ca8 100644
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
index 9d55bf5d1a65..1e78b028518d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4640,6 +4640,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
 	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	xdp->mb = 0;
 
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
-- 
2.26.2

