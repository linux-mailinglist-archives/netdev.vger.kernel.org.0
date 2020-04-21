Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACC71B2B16
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 17:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDUPWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 11:22:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52586 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgDUPWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 11:22:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 589C31A0DB8;
        Tue, 21 Apr 2020 17:22:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C3551A0DB5;
        Tue, 21 Apr 2020 17:22:36 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 16C2D205A2;
        Tue, 21 Apr 2020 17:22:36 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/4] dpaa2-eth: split the .ndo_xdp_xmit callback into two stages
Date:   Tue, 21 Apr 2020 18:21:53 +0300
Message-Id: <20200421152154.10965-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421152154.10965-1-ioana.ciornei@nxp.com>
References: <20200421152154.10965-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having a function that both creates a frame descriptor from
an xdp_frame and enqueues it, split this into two stages.
Add the dpaa2_eth_xdp_create_fd that just transforms an xdp_frame into a
FD while the actual enqueue callback is called directly from the ndo for
each frame.
This is particulary useful in conjunction with bulk enqueue.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 76 ++++++++++---------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 26c2868435d5..9a0432cd893c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1880,20 +1880,16 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	return 0;
 }
 
-static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
-				    struct xdp_frame *xdpf)
+static int dpaa2_eth_xdp_create_fd(struct net_device *net_dev,
+				   struct xdp_frame *xdpf,
+				   struct dpaa2_fd *fd)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
-	struct rtnl_link_stats64 *percpu_stats;
-	struct dpaa2_eth_drv_stats *percpu_extras;
 	unsigned int needed_headroom;
 	struct dpaa2_eth_swa *swa;
-	struct dpaa2_eth_fq *fq;
-	struct dpaa2_fd fd;
 	void *buffer_start, *aligned_start;
 	dma_addr_t addr;
-	int err, i;
 
 	/* We require a minimum headroom to be able to transmit the frame.
 	 * Otherwise return an error and let the original net_device handle it
@@ -1902,11 +1898,8 @@ static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
 	if (xdpf->headroom < needed_headroom)
 		return -EINVAL;
 
-	percpu_stats = this_cpu_ptr(priv->percpu_stats);
-	percpu_extras = this_cpu_ptr(priv->percpu_extras);
-
 	/* Setup the FD fields */
-	memset(&fd, 0, sizeof(fd));
+	memset(fd, 0, sizeof(*fd));
 
 	/* Align FD address, if possible */
 	buffer_start = xdpf->data - needed_headroom;
@@ -1924,32 +1917,14 @@ static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
 	addr = dma_map_single(dev, buffer_start,
 			      swa->xdp.dma_size,
 			      DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(dev, addr))) {
-		percpu_stats->tx_dropped++;
+	if (unlikely(dma_mapping_error(dev, addr)))
 		return -ENOMEM;
-	}
-
-	dpaa2_fd_set_addr(&fd, addr);
-	dpaa2_fd_set_offset(&fd, xdpf->data - buffer_start);
-	dpaa2_fd_set_len(&fd, xdpf->len);
-	dpaa2_fd_set_format(&fd, dpaa2_fd_single);
-	dpaa2_fd_set_ctrl(&fd, FD_CTRL_PTA);
-
-	fq = &priv->fq[smp_processor_id() % dpaa2_eth_queue_count(priv)];
-	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, 0, 1, NULL);
-		if (err != -EBUSY)
-			break;
-	}
-	percpu_extras->tx_portal_busy += i;
-	if (unlikely(err < 0)) {
-		percpu_stats->tx_errors++;
-		/* let the Rx device handle the cleanup */
-		return err;
-	}
 
-	percpu_stats->tx_packets++;
-	percpu_stats->tx_bytes += dpaa2_fd_get_len(&fd);
+	dpaa2_fd_set_addr(fd, addr);
+	dpaa2_fd_set_offset(fd, xdpf->data - buffer_start);
+	dpaa2_fd_set_len(fd, xdpf->len);
+	dpaa2_fd_set_format(fd, dpaa2_fd_single);
+	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
 
 	return 0;
 }
@@ -1957,6 +1932,11 @@ static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
 static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 			      struct xdp_frame **frames, u32 flags)
 {
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct rtnl_link_stats64 *percpu_stats;
+	struct dpaa2_eth_fq *fq;
+	struct dpaa2_fd fd;
 	int drops = 0;
 	int i, err;
 
@@ -1966,14 +1946,38 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 	if (!netif_running(net_dev))
 		return -ENETDOWN;
 
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+	percpu_extras = this_cpu_ptr(priv->percpu_extras);
+
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 
-		err = dpaa2_eth_xdp_xmit_frame(net_dev, xdpf);
+		/* create the FD from the xdp_frame */
+		err = dpaa2_eth_xdp_create_fd(net_dev, xdpf, &fd);
 		if (err) {
+			percpu_stats->tx_dropped++;
 			xdp_return_frame_rx_napi(xdpf);
 			drops++;
+			continue;
+		}
+
+		/* enqueue the newly created FD */
+		fq = &priv->fq[smp_processor_id() % dpaa2_eth_queue_count(priv)];
+		for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
+			err = priv->enqueue(priv, fq, &fd, 0, 1);
+			if (err != -EBUSY)
+				break;
 		}
+
+		percpu_extras->tx_portal_busy += i;
+		if (unlikely(err < 0)) {
+			percpu_stats->tx_errors++;
+			xdp_return_frame_rx_napi(xdpf);
+			continue;
+		}
+
+		percpu_stats->tx_packets++;
+		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fd);
 	}
 
 	return n - drops;
-- 
2.17.1

