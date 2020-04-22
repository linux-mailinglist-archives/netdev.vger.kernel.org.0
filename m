Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFC1B43F1
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgDVMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:05:38 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56404 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgDVMFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:05:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 198982010A6;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0CCE5200EDC;
        Wed, 22 Apr 2020 14:05:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C54072030B;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 2/5] dpaa2-eth: return num_enqueued frames from enqueue callback
Date:   Wed, 22 Apr 2020 15:05:10 +0300
Message-Id: <20200422120513.6583-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422120513.6583-1-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enqueue dpaa2-eth callback now returns the number of successfully
enqueued frames. This is a preliminary patch necessary for adding
support for bulk ring mode enqueue.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 34 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  5 +--
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b6c46639aa4c..7b41ece8f160 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2019 NXP
+ * Copyright 2016-2020 NXP
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -268,7 +268,7 @@ static int xdp_enqueue(struct dpaa2_eth_priv *priv, struct dpaa2_fd *fd,
 
 	fq = &priv->fq[queue_id];
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, fd, 0);
+		err = priv->enqueue(priv, fq, fd, 0, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -847,7 +847,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	 * the Tx confirmation callback for this frame
 	 */
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, prio);
+		err = priv->enqueue(priv, fq, &fd, prio, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -1937,7 +1937,7 @@ static int dpaa2_eth_xdp_xmit_frame(struct net_device *net_dev,
 
 	fq = &priv->fq[smp_processor_id() % dpaa2_eth_queue_count(priv)];
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, 0);
+		err = priv->enqueue(priv, fq, &fd, 0, NULL);
 		if (err != -EBUSY)
 			break;
 	}
@@ -2523,19 +2523,31 @@ static int set_buffer_layout(struct dpaa2_eth_priv *priv)
 
 static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,
 				       struct dpaa2_eth_fq *fq,
-				       struct dpaa2_fd *fd, u8 prio)
+				       struct dpaa2_fd *fd, u8 prio,
+				       int *frames_enqueued)
 {
-	return dpaa2_io_service_enqueue_qd(fq->channel->dpio,
-					   priv->tx_qdid, prio,
-					   fq->tx_qdbin, fd);
+	int err;
+
+	err = dpaa2_io_service_enqueue_qd(fq->channel->dpio,
+					  priv->tx_qdid, prio,
+					  fq->tx_qdbin, fd);
+	if (!err && frames_enqueued)
+		*frames_enqueued = 1;
+	return err;
 }
 
 static inline int dpaa2_eth_enqueue_fq(struct dpaa2_eth_priv *priv,
 				       struct dpaa2_eth_fq *fq,
-				       struct dpaa2_fd *fd, u8 prio)
+				       struct dpaa2_fd *fd, u8 prio,
+				       int *frames_enqueued)
 {
-	return dpaa2_io_service_enqueue_fq(fq->channel->dpio,
-					   fq->tx_fqid[prio], fd);
+	int err;
+
+	err = dpaa2_io_service_enqueue_fq(fq->channel->dpio,
+					  fq->tx_fqid[prio], fd);
+	if (!err && frames_enqueued)
+		*frames_enqueued = 1;
+	return err;
 }
 
 static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7635db3ef903..085ff750e4b5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016 NXP
+ * Copyright 2016-2020 NXP
  */
 
 #ifndef __DPAA2_ETH_H
@@ -371,7 +371,8 @@ struct dpaa2_eth_priv {
 	struct dpaa2_eth_fq fq[DPAA2_ETH_MAX_QUEUES];
 	int (*enqueue)(struct dpaa2_eth_priv *priv,
 		       struct dpaa2_eth_fq *fq,
-		       struct dpaa2_fd *fd, u8 prio);
+		       struct dpaa2_fd *fd, u8 prio,
+		       int *frames_enqueued);
 
 	u8 num_channels;
 	struct dpaa2_eth_channel *channel[DPAA2_ETH_MAX_DPCONS];
-- 
2.17.1

