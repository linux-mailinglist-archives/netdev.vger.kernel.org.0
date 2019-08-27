Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65B79EAA7
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfH0OPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:15:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33018 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfH0OPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 10:15:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3CFFA1A030A;
        Tue, 27 Aug 2019 16:15:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 30D391A02D2;
        Tue, 27 Aug 2019 16:15:52 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E37D62061A;
        Tue, 27 Aug 2019 16:15:51 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 2/3] dpaa2-eth: Use stored link settings
Date:   Tue, 27 Aug 2019 17:15:50 +0300
Message-Id: <1566915351-32075-2-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever a link state change occurs, we get notified and save
the new link settings in the device's private data. In ethtool
get_link_ksettings, use the stored state instead of interrogating
the firmware each time.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
v2: split from main pause frames patch

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |  6 ++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 15 +++------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0acb115..2c6f9b1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1222,9 +1222,8 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 
 	/* Chech link state; speed / duplex changes are not treated yet */
 	if (priv->link_state.up == state.up)
-		return 0;
+		goto out;
 
-	priv->link_state = state;
 	if (state.up) {
 		netif_carrier_on(priv->net_dev);
 		netif_tx_start_all_queues(priv->net_dev);
@@ -1236,6 +1235,9 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	netdev_info(priv->net_dev, "Link Event: state %s\n",
 		    state.up ? "up" : "down");
 
+out:
+	priv->link_state = state;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 5c9816b..fb17042 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -78,23 +78,14 @@ static int
 dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 			     struct ethtool_link_ksettings *link_settings)
 {
-	struct dpni_link_state state = {0};
-	int err = 0;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
-	if (err) {
-		netdev_err(net_dev, "ERROR %d getting link state\n", err);
-		goto out;
-	}
-
 	link_settings->base.autoneg = AUTONEG_DISABLE;
-	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
+	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
 		link_settings->base.duplex = DUPLEX_FULL;
-	link_settings->base.speed = state.rate;
+	link_settings->base.speed = priv->link_state.rate;
 
-out:
-	return err;
+	return 0;
 }
 
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
-- 
2.7.4

