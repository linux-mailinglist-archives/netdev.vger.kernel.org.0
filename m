Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB21D5969
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgEOSsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:48:03 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46418 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgEOSsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:48:02 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0149F200784;
        Fri, 15 May 2020 20:48:00 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E90DF200103;
        Fri, 15 May 2020 20:47:59 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 90DEF20328;
        Fri, 15 May 2020 20:47:59 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 5/7] dpaa2-eth: Minor cleanup in dpaa2_eth_set_rx_taildrop()
Date:   Fri, 15 May 2020 21:47:51 +0300
Message-Id: <20200515184753.15080-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200515184753.15080-1-ioana.ciornei@nxp.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Make clear the setting refers to FQ-based taildrop and the threshold
value is given in bytes (the default option).

Reverse the logic of the second argument (pass tx_pause transparently).
This will be helpful further on.

Also don't set the device's Rx taildrop flag unless configuration
succeeds.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 19 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  4 ++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d426fc1f20ef..d8b1d6ab6656 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1280,17 +1280,20 @@ static void disable_ch_napi(struct dpaa2_eth_priv *priv)
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
@@ -1301,12 +1304,12 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
 					fq->tc, fq->flowid, &td);
 		if (err) {
 			netdev_err(priv->net_dev,
-				   "dpni_set_taildrop() failed\n");
-			break;
+				   "dpni_set_taildrop(FQ) failed\n");
+			return;
 		}
 	}
 
-	priv->rx_td_enabled = enable;
+	priv->rx_td_enabled = td.enable;
 }
 
 static int link_state_update(struct dpaa2_eth_priv *priv)
@@ -1327,7 +1330,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	 * only when pause frame generation is disabled.
 	 */
 	tx_pause = dpaa2_eth_tx_pause_enabled(state.options);
-	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);
+	dpaa2_eth_set_rx_taildrop(priv, tx_pause);
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 6384f6a23349..1b9f6689e9ec 100644
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
@@ -52,7 +52,7 @@
  * how many 64B frames fit inside the taildrop threshold and add a margin
  * to accommodate the buffer refill delay.
  */
-#define DPAA2_ETH_MAX_FRAMES_PER_QUEUE	(DPAA2_ETH_TAILDROP_THRESH / 64)
+#define DPAA2_ETH_MAX_FRAMES_PER_QUEUE	(DPAA2_ETH_FQ_TAILDROP_THRESH / 64)
 #define DPAA2_ETH_NUM_BUFS		(DPAA2_ETH_MAX_FRAMES_PER_QUEUE + 256)
 #define DPAA2_ETH_REFILL_THRESH \
 	(DPAA2_ETH_NUM_BUFS - DPAA2_ETH_BUFS_PER_CMD)
-- 
2.17.1

