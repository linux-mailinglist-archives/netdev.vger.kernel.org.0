Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD38A1C7881
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEFRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:47:28 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47546 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgEFRr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:47:28 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5C2731A0CF8;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4FB751A0CF3;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1ABFA205C6;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     hawk@kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] dpaa2-eth: create a function to flush the XDP fds
Date:   Wed,  6 May 2020 20:47:17 +0300
Message-Id: <20200506174718.20916-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506174718.20916-1-ioana.ciornei@nxp.com>
References: <20200506174718.20916-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create an independent function that takes a particular frame queue and
an array of frame descriptors and tries to enqueue them until it hits
the maximum number fo retries. The same function will be used in the
next patch also on the XDP_TX path.

Also, create the dpaa2_eth_xdp_fds structure to incorporate the array of
FDs as well as the number of FDs already populated.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 61 ++++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  7 ++-
 2 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 11accab81ea1..0f3e842a4fd6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -244,6 +244,35 @@ static void xdp_release_buf(struct dpaa2_eth_priv *priv,
 	ch->xdp.drop_cnt = 0;
 }
 
+static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
+			       struct dpaa2_eth_fq *fq,
+			       struct dpaa2_eth_xdp_fds *xdp_fds)
+{
+	int total_enqueued = 0, retries = 0, enqueued;
+	struct dpaa2_eth_drv_stats *percpu_extras;
+	int num_fds, err, max_retries;
+	struct dpaa2_fd *fds;
+
+	percpu_extras = this_cpu_ptr(priv->percpu_extras);
+
+	/* try to enqueue all the FDs until the max number of retries is hit */
+	fds = xdp_fds->fds;
+	num_fds = xdp_fds->num;
+	max_retries = num_fds * DPAA2_ETH_ENQUEUE_RETRIES;
+	while (total_enqueued < num_fds && retries < max_retries) {
+		err = priv->enqueue(priv, fq, &fds[total_enqueued],
+				    0, num_fds - total_enqueued, &enqueued);
+		if (err == -EBUSY) {
+			percpu_extras->tx_portal_busy += ++retries;
+			continue;
+		}
+		total_enqueued += enqueued;
+	}
+	xdp_fds->num = 0;
+
+	return total_enqueued;
+}
+
 static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
 		       void *buf_start, u16 queue_id)
 {
@@ -1934,12 +1963,11 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 			      struct xdp_frame **frames, u32 flags)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	int total_enqueued = 0, retries = 0, enqueued;
-	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct dpaa2_eth_xdp_fds *xdp_redirect_fds;
 	struct rtnl_link_stats64 *percpu_stats;
-	int num_fds, i, err, max_retries;
 	struct dpaa2_eth_fq *fq;
 	struct dpaa2_fd *fds;
+	int enqueued, i, err;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -1948,10 +1976,10 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 		return -ENETDOWN;
 
 	fq = &priv->fq[smp_processor_id()];
-	fds = fq->xdp_fds;
+	xdp_redirect_fds = &fq->xdp_redirect_fds;
+	fds = xdp_redirect_fds->fds;
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
-	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
 	/* create a FD for each xdp_frame in the list received */
 	for (i = 0; i < n; i++) {
@@ -1959,28 +1987,19 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 		if (err)
 			break;
 	}
-	num_fds = i;
+	xdp_redirect_fds->num = i;
 
-	/* try to enqueue all the FDs until the max number of retries is hit */
-	max_retries = num_fds * DPAA2_ETH_ENQUEUE_RETRIES;
-	while (total_enqueued < num_fds && retries < max_retries) {
-		err = priv->enqueue(priv, fq, &fds[total_enqueued],
-				    0, num_fds - total_enqueued, &enqueued);
-		if (err == -EBUSY) {
-			percpu_extras->tx_portal_busy += ++retries;
-			continue;
-		}
-		total_enqueued += enqueued;
-	}
+	/* enqueue all the frame descriptors */
+	enqueued = dpaa2_eth_xdp_flush(priv, fq, xdp_redirect_fds);
 
 	/* update statistics */
-	percpu_stats->tx_packets += total_enqueued;
-	for (i = 0; i < total_enqueued; i++)
+	percpu_stats->tx_packets += enqueued;
+	for (i = 0; i < enqueued; i++)
 		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
-	for (i = total_enqueued; i < n; i++)
+	for (i = enqueued; i < n; i++)
 		xdp_return_frame_rx_napi(frames[i]);
 
-	return total_enqueued;
+	return enqueued;
 }
 
 static int update_xps(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 43cd8409f2e9..b5f7dbbc2a02 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -310,6 +310,11 @@ enum dpaa2_eth_fq_type {
 
 struct dpaa2_eth_priv;
 
+struct dpaa2_eth_xdp_fds {
+	struct dpaa2_fd fds[DEV_MAP_BULK_SIZE];
+	ssize_t num;
+};
+
 struct dpaa2_eth_fq {
 	u32 fqid;
 	u32 tx_qdbin;
@@ -328,7 +333,7 @@ struct dpaa2_eth_fq {
 			struct dpaa2_eth_fq *fq);
 	struct dpaa2_eth_fq_stats stats;
 
-	struct dpaa2_fd xdp_fds[DEV_MAP_BULK_SIZE];
+	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
 };
 
 struct dpaa2_eth_ch_xdp {
-- 
2.17.1

