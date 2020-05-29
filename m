Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1C1E8583
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgE2Ro7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:44:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44480 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgE2Roy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:44:54 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F17722000E1;
        Fri, 29 May 2020 19:44:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E4E0E2000DE;
        Fri, 29 May 2020 19:44:52 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A7A602039E;
        Fri, 29 May 2020 19:44:52 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 4/7] dpaa2-eth: Add congestion group taildrop
Date:   Fri, 29 May 2020 20:43:42 +0300
Message-Id: <20200529174345.27537-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529174345.27537-1-ioana.ciornei@nxp.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

The increase in number of ingress frame queues means we now risk
depleting the buffer pool before the FQ taildrop kicks in.

Congestion group taildrop allows us to control the number of frames that
can accumulate on a group of Rx frame queues belonging to the same
traffic class.  This setting coexists with the frame queue based
taildrop: whichever limit gets hit first triggers the frame drop.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 35 ++++++++++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 13 +++++--
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c521f4afba8e..8cbbebefdcfd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1287,17 +1287,20 @@ static void disable_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
-static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
+static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
+				      bool tx_pause)
 {
 	struct dpni_taildrop td = {0};
 	struct dpaa2_eth_fq *fq;
 	int i, err;
 
-	if (priv->rx_td_enabled == enable)
+	td.enable = !tx_pause;
+	if (priv->rx_td_enabled == td.enable)
 		return;
 
-	td.enable = enable;
-	td.threshold = DPAA2_ETH_TAILDROP_THRESH;
+	/* FQ taildrop: threshold is in bytes, per frame queue */
+	td.threshold = DPAA2_ETH_FQ_TAILDROP_THRESH;
+	td.units = DPNI_CONGESTION_UNIT_BYTES;
 
 	for (i = 0; i < priv->num_fqs; i++) {
 		fq = &priv->fq[i];
@@ -1308,12 +1311,28 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 					fq->tc, fq->flowid, &td);
 		if (err) {
 			netdev_err(priv->net_dev,
-				   "dpni_set_taildrop() failed\n");
-			break;
+				   "dpni_set_taildrop(FQ) failed\n");
+			return;
+		}
+	}
+
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
 		}
 	}
 
-	priv->rx_td_enabled = enable;
+	priv->rx_td_enabled = td.enable;
 }
 
 static int link_state_update(struct dpaa2_eth_priv *priv)
@@ -1334,7 +1353,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	 * only when pause frame generation is disabled.
 	 */
 	tx_pause = dpaa2_eth_tx_pause_enabled(state.options);
-	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);
+	dpaa2_eth_set_rx_taildrop(priv, tx_pause);
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 6384f6a23349..184d5d83e497 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -40,7 +40,7 @@
  * frames in the Rx queues (length of the current frame is not
  * taken into account when making the taildrop decision)
  */
-#define DPAA2_ETH_TAILDROP_THRESH	(64 * 1024)
+#define DPAA2_ETH_FQ_TAILDROP_THRESH	(64 * 1024)
 
 /* Maximum number of Tx confirmation frames to be processed
  * in a single NAPI call
@@ -52,11 +52,20 @@
  * how many 64B frames fit inside the taildrop threshold and add a margin
  * to accommodate the buffer refill delay.
  */
-#define DPAA2_ETH_MAX_FRAMES_PER_QUEUE	(DPAA2_ETH_TAILDROP_THRESH / 64)
+#define DPAA2_ETH_MAX_FRAMES_PER_QUEUE	(DPAA2_ETH_FQ_TAILDROP_THRESH / 64)
 #define DPAA2_ETH_NUM_BUFS		(DPAA2_ETH_MAX_FRAMES_PER_QUEUE + 256)
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

