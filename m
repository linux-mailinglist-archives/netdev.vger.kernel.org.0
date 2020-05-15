Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC91D56BA
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgEOQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:53:21 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42736 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgEOQxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 12:53:21 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 82D6D20077A;
        Fri, 15 May 2020 18:53:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7724920076B;
        Fri, 15 May 2020 18:53:19 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2095920328;
        Fri, 15 May 2020 18:53:19 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 6/7] dpaa2-eth: Add congestion group taildrop
Date:   Fri, 15 May 2020 19:52:59 +0300
Message-Id: <20200515165300.16125-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200515165300.16125-1-ioana.ciornei@nxp.com>
References: <20200515165300.16125-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

The increase in number of ingress frame queues means we now risk
depleting the buffer pool before the FQ taildrop kicks in.

Congestion group taildrop allows us to control the number of frames
that can accumulate on a group of Rx frame queues belonging to the
same traffic class.

This setting coexists with the frame queue based taildrop: whichever
limit gets hit first triggers the frame drop.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 16 ++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 3cdfc564a45c..624f0e4bdc6c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1309,6 +1309,22 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 		}
 	}
 
+	/* Congestion group taildrop: threshold is in frames, per group
+	 * of FQs belonging to the same traffic class
+	 */
+	td.threshold = DPAA2_ETH_CG_TAILDROP_THRESH(priv);
+	td.units = DPNI_CONGESTION_UNIT_FRAMES;
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		err = dpni_set_taildrop(priv->mc_io, 0, priv->mc_token,
+					DPNI_CP_GROUP, DPNI_QUEUE_RX,
+					i, 0, &td);
+		if (err) {
+			netdev_err(priv->net_dev,
+				   "dpni_set_taildrop(CG) failed\n");
+			return;
+		}
+	}
+
 	priv->rx_td_enabled = td.enable;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 1b9f6689e9ec..184d5d83e497 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -57,6 +57,15 @@
 #define DPAA2_ETH_REFILL_THRESH \
 	(DPAA2_ETH_NUM_BUFS - DPAA2_ETH_BUFS_PER_CMD)
 
+/* Congestion group taildrop threshold: number of frames allowed to accumulate
+ * at any moment in a group of Rx queues belonging to the same traffic class.
+ * Choose value such that we don't risk depleting the buffer pool before the
+ * taildrop kicks in
+ */
+#define DPAA2_ETH_CG_TAILDROP_THRESH(priv)				\
+	(DPAA2_ETH_MAX_FRAMES_PER_QUEUE * dpaa2_eth_queue_count(priv) /	\
+	 dpaa2_eth_tc_count(priv))
+
 /* Maximum number of buffers that can be acquired/released through a single
  * QBMan command
  */
-- 
2.17.1

