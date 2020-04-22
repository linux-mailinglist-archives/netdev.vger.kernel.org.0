Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAE1B43F2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgDVMFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:05:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41654 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgDVMFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:05:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 72E161A11D1;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 642AE1A11C4;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1FB292030B;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 3/5] dpaa2-eth: use the bulk ring mode enqueue interface
Date:   Wed, 22 Apr 2020 15:05:11 +0300
Message-Id: <20200422120513.6583-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422120513.6583-1-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the dpaa2-eth driver to use the bulk enqueue function introduced
with the change to QBMAN ring mode. At the moment, no functional changes
are made but rather the driver just transitions to the new interface
while still enqueuing just one frame at a time.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 35 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 +
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7b41ece8f160..26c2868435d5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -268,7 +268,7 @@ static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
 
 	fq = &priv->fq[queue_id];
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, fd, 0, NULL);
+		err = priv->enqueue(priv, fq, fd, 0, 1, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -847,7 +847,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	 * the Tx confirmation callback for this frame
 	 */
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, prio, NULL);
+		err = priv->enqueue(priv, fq, &fd, prio, 1, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -1937,7 +1937,7 @@ static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
 
 	fq = &priv->fq[smp_processor_id() % dpaa2_eth_queue_count(priv)];
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, 0, NULL);
+		err = priv->enqueue(priv, fq, &fd, 0, 1, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -2524,6 +2524,7 @@ static int set_buffer_layout(struct dpaa2_eth_priv *priv)
 static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,
 				       struct dpaa2_eth_fq *fq,
 				       struct dpaa2_fd *fd, u8 prio,
+				       u32 num_frames __always_unused,
 				       int *frames_enqueued)
 {
 	int err;
@@ -2536,18 +2537,24 @@ static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,
 	return err;
 }
 
-static inline int dpaa2_eth_enqueue_fq(struct dpaa2_eth_priv *priv,
-				       struct dpaa2_eth_fq *fq,
-				       struct dpaa2_fd *fd, u8 prio,
-				       int *frames_enqueued)
+static inline int dpaa2_eth_enqueue_fq_multiple(struct dpaa2_eth_priv *priv,
+						struct dpaa2_eth_fq *fq,
+						struct dpaa2_fd *fd,
+						u8 prio, u32 num_frames,
+						int *frames_enqueued)
 {
 	int err;
 
-	err = dpaa2_io_service_enqueue_fq(fq->channel->dpio,
-					  fq->tx_fqid[prio], fd);
-	if (!err && frames_enqueued)
-		*frames_enqueued = 1;
-	return err;
+	err = dpaa2_io_service_enqueue_multiple_fq(fq->channel->dpio,
+						   fq->tx_fqid[prio],
+						   fd, num_frames);
+
+	if (err == 0)
+		return -EBUSY;
+
+	if (frames_enqueued)
+		*frames_enqueued = err;
+	return 0;
 }
 
 static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
@@ -2556,7 +2563,7 @@ static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
 				   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)
 		priv->enqueue = dpaa2_eth_enqueue_qd;
 	else
-		priv->enqueue = dpaa2_eth_enqueue_fq;
+		priv->enqueue = dpaa2_eth_enqueue_fq_multiple;
 }
 
 static int set_pause(struct dpaa2_eth_priv *priv)
@@ -2617,7 +2624,7 @@ static void update_tx_fqids(struct dpaa2_eth_priv *priv)
 		}
 	}
 
-	priv->enqueue = dpaa2_eth_enqueue_fq;
+	priv->enqueue = dpaa2_eth_enqueue_fq_multiple;
 
 	return;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 085ff750e4b5..2440ba6b21ef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -372,6 +372,7 @@ struct dpaa2_eth_priv {
 	int (*enqueue)(struct dpaa2_eth_priv *priv,
 		       struct dpaa2_eth_fq *fq,
 		       struct dpaa2_fd *fd, u8 prio,
+		       u32 num_frames,
 		       int *frames_enqueued);
 
 	u8 num_channels;
-- 
2.17.1

