Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF052B0C58
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgKLSKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:10:36 -0500
Received: from inva021.nxp.com ([92.121.34.21]:60412 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgKLSKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 13:10:30 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CF24F20151C;
        Thu, 12 Nov 2020 19:10:28 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C212B2001D1;
        Thu, 12 Nov 2020 19:10:28 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 765E62032C;
        Thu, 12 Nov 2020 19:10:28 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next 4/7] dpaa_eth: add XDP_TX support
Date:   Thu, 12 Nov 2020 20:10:09 +0200
Message-Id: <ba14ff6342f74c6cdc086d31c2ca77248f371003.1605181416.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605181416.git.camelia.groza@nxp.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an xdp_frame structure for managing the frame. Store a backpointer to
the structure at the start of the buffer before enqueueing. Use the XDP
API for freeing the buffer when it returns to the driver on the TX
confirmation path.

This approach will be reused for XDP REDIRECT.

Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 129 ++++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
 2 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index b9b0db2..343d693 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq *dpaa_fq, bool td_enable)
 
 	dpaa_fq->fqid = qman_fq_fqid(fq);
 
+	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
+	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD) {
+		err = xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_dev,
+				       dpaa_fq->fqid);
+		if (err) {
+			dev_err(dev, "xdp_rxq_info_reg failed\n");
+			return err;
+		}
+
+		err = xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
+						 MEM_TYPE_PAGE_ORDER0, NULL);
+		if (err) {
+			dev_err(dev, "xdp_rxq_info_reg_mem_model failed\n");
+			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
+			return err;
+		}
+	}
+
 	return 0;
 }
 
@@ -1159,6 +1177,10 @@ static int dpaa_fq_free_entry(struct device *dev, struct qman_fq *fq)
 		}
 	}
 
+	if (dpaa_fq->fq_type == FQ_TYPE_RX_DEFAULT ||
+	    dpaa_fq->fq_type == FQ_TYPE_RX_PCD)
+		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
+
 	qman_destroy_fq(fq);
 	list_del(&dpaa_fq->list);
 
@@ -1625,6 +1647,9 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
  *
  * Return the skb backpointer, since for S/G frames the buffer containing it
  * gets freed here.
+ *
+ * No skb backpointer is set when transmitting XDP frames. Cleanup the buffer
+ * and return NULL in this case.
  */
 static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 					  const struct qm_fd *fd, bool ts)
@@ -1636,6 +1661,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	void *vaddr = phys_to_virt(addr);
 	const struct qm_sg_entry *sgt;
 	struct dpaa_eth_swbp *swbp;
+	struct xdp_frame *xdpf;
 	struct sk_buff *skb;
 	u64 ns;
 	int i;
@@ -1664,13 +1690,22 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 		}
 	} else {
 		dma_unmap_single(priv->tx_dma_dev, addr,
-				 priv->tx_headroom + qm_fd_get_length(fd),
+				 qm_fd_get_offset(fd) + qm_fd_get_length(fd),
 				 dma_dir);
 	}
 
 	swbp = (struct dpaa_eth_swbp *)vaddr;
 	skb = swbp->skb;
 
+	/* No skb backpointer is set when running XDP. An xdp_frame
+	 * backpointer is saved instead.
+	 */
+	if (!skb) {
+		xdpf = swbp->xdpf;
+		xdp_return_frame(xdpf);
+		return NULL;
+	}
+
 	/* DMA unmapping is required before accessing the HW provided info */
 	if (ts && priv->tx_tstamp &&
 	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
@@ -2350,11 +2385,76 @@ static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
 	return qman_cb_dqrr_consume;
 }
 
+static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
+			       struct xdp_frame *xdpf)
+{
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct rtnl_link_stats64 *percpu_stats;
+	struct dpaa_percpu_priv *percpu_priv;
+	struct dpaa_eth_swbp *swbp;
+	struct netdev_queue *txq;
+	void *buff_start;
+	struct qm_fd fd;
+	dma_addr_t addr;
+	int err;
+
+	percpu_priv = this_cpu_ptr(priv->percpu_priv);
+	percpu_stats = &percpu_priv->stats;
+
+	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
+		err = -EINVAL;
+		goto out_error;
+	}
+
+	buff_start = xdpf->data - xdpf->headroom;
+
+	/* Leave empty the skb backpointer at the start of the buffer.
+	 * Save the XDP frame for easy cleanup on confirmation.
+	 */
+	swbp = (struct dpaa_eth_swbp *)buff_start;
+	swbp->skb = NULL;
+	swbp->xdpf = xdpf;
+
+	qm_fd_clear_fd(&fd);
+	fd.bpid = FSL_DPAA_BPID_INV;
+	fd.cmd |= cpu_to_be32(FM_FD_CMD_FCO);
+	qm_fd_set_contig(&fd, xdpf->headroom, xdpf->len);
+
+	addr = dma_map_single(priv->tx_dma_dev, buff_start,
+			      xdpf->headroom + xdpf->len,
+			      DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		err = -EINVAL;
+		goto out_error;
+	}
+
+	qm_fd_addr_set64(&fd, addr);
+
+	/* Bump the trans_start */
+	txq = netdev_get_tx_queue(net_dev, smp_processor_id());
+	txq->trans_start = jiffies;
+
+	err = dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);
+	if (err) {
+		dma_unmap_single(priv->tx_dma_dev, addr,
+				 qm_fd_get_offset(&fd) + qm_fd_get_length(&fd),
+				 DMA_TO_DEVICE);
+		goto out_error;
+	}
+
+	return 0;
+
+out_error:
+	percpu_stats->tx_errors++;
+	return err;
+}
+
 static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
-			unsigned int *xdp_meta_len)
+			struct dpaa_fq *dpaa_fq, unsigned int *xdp_meta_len)
 {
 	ssize_t fd_off = qm_fd_get_offset(fd);
 	struct bpf_prog *xdp_prog;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 xdp_act;
 
@@ -2370,7 +2470,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	xdp.data_meta = xdp.data;
 	xdp.data_hard_start = xdp.data - XDP_PACKET_HEADROOM;
 	xdp.data_end = xdp.data + qm_fd_get_length(fd);
-	xdp.frame_sz = DPAA_BP_RAW_SIZE;
+	xdp.frame_sz = DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
+	xdp.rxq = &dpaa_fq->xdp_rxq;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
@@ -2381,6 +2482,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 	case XDP_PASS:
 		*xdp_meta_len = xdp.data - xdp.data_meta;
 		break;
+	case XDP_TX:
+		/* We can access the full headroom when sending the frame
+		 * back out
+		 */
+		xdp.data_hard_start = vaddr;
+		xdp.frame_sz = DPAA_BP_RAW_SIZE;
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (unlikely(!xdpf)) {
+			free_pages((unsigned long)vaddr, 0);
+			break;
+		}
+
+		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
+			xdp_return_frame_rx_napi(xdpf);
+
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(xdp_act);
 		fallthrough;
@@ -2414,6 +2531,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	struct net_device *net_dev;
 	u32 fd_status, hash_offset;
 	struct dpaa_bp *dpaa_bp;
+	struct dpaa_fq *dpaa_fq;
 	struct dpaa_priv *priv;
 	struct sk_buff *skb;
 	int *count_ptr;
@@ -2422,9 +2540,10 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 hash;
 	u64 ns;
 
+	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
 	fd_status = be32_to_cpu(fd->status);
 	fd_format = qm_fd_get_format(fd);
-	net_dev = ((struct dpaa_fq *)fq)->net_dev;
+	net_dev = dpaa_fq->net_dev;
 	priv = netdev_priv(net_dev);
 	dpaa_bp = dpaa_bpid2pool(dq->fd.bpid);
 	if (!dpaa_bp)
@@ -2493,7 +2612,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 
 	if (likely(fd_format == qm_fd_contig)) {
 		xdp_act = dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
-				       &xdp_meta_len);
+				       dpaa_fq, &xdp_meta_len);
 		if (xdp_act != XDP_PASS) {
 			percpu_stats->rx_packets++;
 			percpu_stats->rx_bytes += qm_fd_get_length(fd);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index 94e8613..5c8d52a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -68,6 +68,7 @@ struct dpaa_fq {
 	u16 channel;
 	u8 wq;
 	enum dpaa_fq_type fq_type;
+	struct xdp_rxq_info xdp_rxq;
 };
 
 struct dpaa_fq_cbs {
@@ -150,6 +151,7 @@ struct dpaa_buffer_layout {
  */
 struct dpaa_eth_swbp {
 	struct sk_buff *skb;
+	struct xdp_frame *xdpf;
 };
 
 struct dpaa_priv {
-- 
1.9.1

