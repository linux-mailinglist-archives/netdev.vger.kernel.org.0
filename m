Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8701E93D1
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgE3VIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:08:38 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55106 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbgE3VIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:08:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C29A81A1DF0;
        Sat, 30 May 2020 23:08:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B625D1A1DEB;
        Sat, 30 May 2020 23:08:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 77E33203C0;
        Sat, 30 May 2020 23:08:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 3/7] dpaa2-eth: Add helper functions
Date:   Sun, 31 May 2020 00:08:10 +0300
Message-Id: <20200530210814.348-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200530210814.348-1-ioana.ciornei@nxp.com>
References: <20200530210814.348-1-ioana.ciornei@nxp.com>
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
Changes in v4:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |  3 +--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     | 11 +++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |  5 ++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 3bf5df92ecfa..c16c8ea3a174 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1333,8 +1333,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
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
index 8bf169783bea..e88269fe3de7 100644
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

