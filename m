Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9AA0440
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfH1OIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:08:18 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47124 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfH1OIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:08:18 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D495820018D;
        Wed, 28 Aug 2019 16:08:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C74C12000E0;
        Wed, 28 Aug 2019 16:08:15 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8585B205CD;
        Wed, 28 Aug 2019 16:08:15 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, ioana.ciornei@nxp.com
Subject: [PATCH net-next v3 1/3] dpaa2-eth: Remove support for changing link settings
Date:   Wed, 28 Aug 2019 17:08:13 +0300
Message-Id: <1567001295-31801-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only support fixed-link for now, so there is no point in
offering users the option to change link settings via ethtool.

Functionally there is no change, since firmware prevents us from
changing link parameters anyway.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2: new patch
v3: no changes

 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 51 +---------------------
 1 file changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 7b182f4..5c9816b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -88,13 +88,7 @@ dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 		goto out;
 	}
 
-	/* At the moment, we have no way of interrogating the DPMAC
-	 * from the DPNI side - and for that matter there may exist
-	 * no DPMAC at all. So for now we just don't report anything
-	 * beyond the DPNI attributes.
-	 */
-	if (state.options & DPNI_LINK_OPT_AUTONEG)
-		link_settings->base.autoneg = AUTONEG_ENABLE;
+	link_settings->base.autoneg = AUTONEG_DISABLE;
 	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
 		link_settings->base.duplex = DUPLEX_FULL;
 	link_settings->base.speed = state.rate;
@@ -103,48 +97,6 @@ dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 	return err;
 }
 
-#define DPNI_DYNAMIC_LINK_SET_VER_MAJOR		7
-#define DPNI_DYNAMIC_LINK_SET_VER_MINOR		1
-static int
-dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
-			     const struct ethtool_link_ksettings *link_settings)
-{
-	struct dpni_link_cfg cfg = {0};
-	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	int err = 0;
-
-	/* If using an older MC version, the DPNI must be down
-	 * in order to be able to change link settings. Taking steps to let
-	 * the user know that.
-	 */
-	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_DYNAMIC_LINK_SET_VER_MAJOR,
-				   DPNI_DYNAMIC_LINK_SET_VER_MINOR) < 0) {
-		if (netif_running(net_dev)) {
-			netdev_info(net_dev, "Interface must be brought down first.\n");
-			return -EACCES;
-		}
-	}
-
-	cfg.rate = link_settings->base.speed;
-	if (link_settings->base.autoneg == AUTONEG_ENABLE)
-		cfg.options |= DPNI_LINK_OPT_AUTONEG;
-	else
-		cfg.options &= ~DPNI_LINK_OPT_AUTONEG;
-	if (link_settings->base.duplex  == DUPLEX_HALF)
-		cfg.options |= DPNI_LINK_OPT_HALF_DUPLEX;
-	else
-		cfg.options &= ~DPNI_LINK_OPT_HALF_DUPLEX;
-
-	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &cfg);
-	if (err)
-		/* ethtool will be loud enough if we return an error; no point
-		 * in putting our own error message on the console by default
-		 */
-		netdev_dbg(net_dev, "ERROR %d setting link cfg\n", err);
-
-	return err;
-}
-
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
@@ -721,7 +673,6 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_link_ksettings = dpaa2_eth_get_link_ksettings,
-	.set_link_ksettings = dpaa2_eth_set_link_ksettings,
 	.get_sset_count = dpaa2_eth_get_sset_count,
 	.get_ethtool_stats = dpaa2_eth_get_ethtool_stats,
 	.get_strings = dpaa2_eth_get_strings,
-- 
2.7.4

