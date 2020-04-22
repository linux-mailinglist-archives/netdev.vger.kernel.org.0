Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7FE1B43F3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgDVMFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:05:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56464 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgDVMFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:05:39 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 442842010B3;
        Wed, 22 Apr 2020 14:05:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 382CA2010B1;
        Wed, 22 Apr 2020 14:05:36 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E13A92030B;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 5/5] dpaa2-eth: use bulk enqueue in .ndo_xdp_xmit
Date:   Wed, 22 Apr 2020 15:05:13 +0300
Message-Id: <20200422120513.6583-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422120513.6583-1-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take advantage of the bulk enqueue feature in .ndo_xdp_xmit.
We cannot use the XDP_XMIT_FLUSH since the architecture is not capable
to store all the frames dequeued in a NAPI cycle so we instead are
enqueueing all the frames received in a ndo_xdp_xmit call right away.

After setting up all FDs for the xdp_frames received, enqueue multiple
frames at a time until all are sent or the maximum number of retries is
hit.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - use a statically allocated array of dpaa2_fd for each fq
 - use DEV_MAP_BULK_SIZE as the max number of xdp_frames received

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 57 +++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  2 +
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 9a0432cd893c..9d4061bba0b8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1933,12 +1933,12 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 			      struct xdp_frame **frames, u32 flags)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int total_enqueued = 0, retries = 0, enqueued;
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct rtnl_link_stats64 *percpu_stats;
+	int num_fds, i, err, max_retries;
 	struct dpaa2_eth_fq *fq;
-	struct dpaa2_fd fd;
-	int drops = 0;
-	int i, err;
+	struct dpaa2_fd *fds;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -1946,41 +1946,40 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 	if (!netif_running(net_dev))
 		return -ENETDOWN;
 
+	fq = &priv->fq[smp_processor_id()];
+	fds = fq->xdp_fds;
+
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
+	/* create a FD for each xdp_frame in the list received */
 	for (i = 0; i < n; i++) {
-		struct xdp_frame *xdpf = frames[i];
-
-		/* create the FD from the xdp_frame */
-		err = dpaa2_eth_xdp_create_fd(net_dev, xdpf, &fd);
-		if (err) {
-			percpu_stats->tx_dropped++;
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-			continue;
-		}
-
-		/* enqueue the newly created FD */
-		fq = &priv->fq[smp_processor_id() % dpaa2_eth_queue_count(priv)];
-		for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-			err = priv->enqueue(priv, fq, &fd, 0, 1);
-			if (err != -EBUSY)
-				break;
-		}
+		err = dpaa2_eth_xdp_create_fd(net_dev, frames[i], &fds[i]);
+		if (err)
+			break;
+	}
+	num_fds = i;
 
-		percpu_extras->tx_portal_busy += i;
-		if (unlikely(err < 0)) {
-			percpu_stats->tx_errors++;
-			xdp_return_frame_rx_napi(xdpf);
+	/* try to enqueue all the FDs until the max number of retries is hit */
+	max_retries = num_fds * DPAA2_ETH_ENQUEUE_RETRIES;
+	while (total_enqueued < num_fds && retries < max_retries) {
+		err = priv->enqueue(priv, fq, &fds[total_enqueued],
+				    0, num_fds - total_enqueued, &enqueued);
+		if (err == -EBUSY) {
+			percpu_extras->tx_portal_busy += ++retries;
 			continue;
 		}
-
-		percpu_stats->tx_packets++;
-		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fd);
+		total_enqueued += enqueued;
 	}
 
-	return n - drops;
+	/* update statistics */
+	percpu_stats->tx_packets += total_enqueued;
+	for (i = 0; i < total_enqueued; i++)
+		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
+	for (i = total_enqueued; i < n; i++)
+		xdp_return_frame_rx_napi(frames[i]);
+
+	return total_enqueued;
 }
 
 static int update_xps(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 2440ba6b21ef..289053099974 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -325,6 +325,8 @@ struct dpaa2_eth_fq {
 			const struct dpaa2_fd *fd,
 			struct dpaa2_eth_fq *fq);
 	struct dpaa2_eth_fq_stats stats;
+
+	struct dpaa2_fd xdp_fds[DEV_MAP_BULK_SIZE];
 };
 
 struct dpaa2_eth_ch_xdp {
-- 
2.17.1

