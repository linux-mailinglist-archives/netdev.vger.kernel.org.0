Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0552D1D596E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgEOSsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:48:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51744 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgEOSsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:48:01 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 82BD51A074F;
        Fri, 15 May 2020 20:47:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 768C01A073C;
        Fri, 15 May 2020 20:47:59 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1A95320328;
        Fri, 15 May 2020 20:47:59 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 4/7] dpaa2-eth: Add helper functions
Date:   Fri, 15 May 2020 21:47:50 +0300
Message-Id: <20200515184753.15080-5-ioana.ciornei@nxp.com>
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

Add convenient helper functions that determines whether Rx/Tx pause
frames are enabled based on link state flags received from firmware.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |  3 +--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     | 11 +++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |  5 ++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f4f085b7829a..d426fc1f20ef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1326,8 +1326,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	 * Rx FQ taildrop configuration as well. We configure taildrop
 	 * only when pause frame generation is disabled.
 	 */
-	tx_pause = !!(state.options & DPNI_LINK_OPT_PAUSE) ^
-		   !!(state.options & DPNI_LINK_OPT_ASYM_PAUSE);
+	tx_pause = dpaa2_eth_tx_pause_enabled(state.options);
 	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);
 
 	/* When we manage the MAC/PHY using phylink there is no need
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7856f69bcf36..6384f6a23349 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -510,6 +510,17 @@ enum dpaa2_eth_rx_dist {
 	(dpaa2_eth_cmp_dpni_ver((priv), DPNI_PAUSE_VER_MAJOR,	\
 				DPNI_PAUSE_VER_MINOR) >= 0)
 
+static inline bool dpaa2_eth_tx_pause_enabled(u64 link_options)
+{
+	return !!(link_options & DPNI_LINK_OPT_PAUSE) ^
+	       !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);
+}
+
+static inline bool dpaa2_eth_rx_pause_enabled(u64 link_options)
+{
+	return !!(link_options & DPNI_LINK_OPT_PAUSE);
+}
+
 static inline
 unsigned int dpaa2_eth_needed_headroom(struct dpaa2_eth_priv *priv,
 				       struct sk_buff *skb)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 1d0402011ac5..326c638c7a56 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -130,9 +130,8 @@ static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
 		return;
 	}
 
-	pause->rx_pause = !!(link_options & DPNI_LINK_OPT_PAUSE);
-	pause->tx_pause = pause->rx_pause ^
-			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);
+	pause->rx_pause = dpaa2_eth_rx_pause_enabled(link_options);
+	pause->tx_pause = dpaa2_eth_tx_pause_enabled(link_options);
 	pause->autoneg = AUTONEG_DISABLE;
 }
 
-- 
2.17.1

