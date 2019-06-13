Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1791145059
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfFMX4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:38 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34656 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfFMX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C9F99200516;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BCD06200503;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4EBF0205DC;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com,
        Valentin Catalin Neacsu <valentin-catalin.neacsu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 5/6] dpaa2-eth: add autoneg support
Date:   Fri, 14 Jun 2019 02:55:52 +0300
Message-Id: <1560470153-26155-6-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

For MC versions that support it, use the new DPNI link APIs, which
allow setting/getting of advertised and supported link modes.

A mapping between DPNI link modes and ethtool ones is created to
help converting from one to the other.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Valentin Catalin Neacsu <valentin-catalin.neacsu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 83 ++++++++++++++++++----
 1 file changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 7b182f4b263c..38999908a388 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -74,6 +74,44 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 		sizeof(drvinfo->bus_info));
 }
 
+#define DPNI_LINK_AUTONEG_VER_MAJOR		7
+#define DPNI_LINK_AUTONEG_VER_MINOR		8
+
+struct dpaa2_eth_link_mode_map {
+	u64 dpni_lm;
+	u64 ethtool_lm;
+};
+
+static const struct dpaa2_eth_link_mode_map dpaa2_eth_lm_map[] = {
+	{DPNI_ADVERTISED_10BASET_FULL, ETHTOOL_LINK_MODE_10baseT_Full_BIT},
+	{DPNI_ADVERTISED_100BASET_FULL, ETHTOOL_LINK_MODE_100baseT_Full_BIT},
+	{DPNI_ADVERTISED_1000BASET_FULL, ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
+	{DPNI_ADVERTISED_10000BASET_FULL, ETHTOOL_LINK_MODE_10000baseT_Full_BIT},
+	{DPNI_ADVERTISED_AUTONEG, ETHTOOL_LINK_MODE_Autoneg_BIT},
+};
+
+static void link_mode_dpni2ethtool(u64 dpni_lm, unsigned long *ethtool_lm)
+{
+	int i;
+
+	bitmap_zero(ethtool_lm, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	for (i = 0; i < ARRAY_SIZE(dpaa2_eth_lm_map); i++) {
+		if (dpni_lm & dpaa2_eth_lm_map[i].dpni_lm)
+			__set_bit(dpaa2_eth_lm_map[i].ethtool_lm, ethtool_lm);
+	}
+}
+
+static void link_mode_ethtool2dpni(const unsigned long *ethtool_lm,
+				   u64 *dpni_lm)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dpaa2_eth_lm_map); i++) {
+		if (test_bit(dpaa2_eth_lm_map[i].ethtool_lm, ethtool_lm))
+			*dpni_lm |= dpaa2_eth_lm_map[i].dpni_lm;
+	}
+}
+
 static int
 dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 			     struct ethtool_link_ksettings *link_settings)
@@ -82,19 +120,32 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 	int err = 0;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
-	if (err) {
-		netdev_err(net_dev, "ERROR %d getting link state\n", err);
-		goto out;
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_LINK_AUTONEG_VER_MAJOR,
+				   DPNI_LINK_AUTONEG_VER_MINOR) < 0) {
+		err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token,
+					  &state);
+		if (err) {
+			netdev_err(net_dev, "dpni_get_link_state failed\n");
+			goto out;
+		}
+	} else {
+		err = dpni_get_link_state_v2(priv->mc_io, 0, priv->mc_token,
+					     &state);
+		if (err) {
+			netdev_err(net_dev, "dpni_get_link_state_v2 failed\n");
+			goto out;
+		}
+		link_mode_dpni2ethtool(state.supported,
+				       link_settings->link_modes.supported);
+		link_mode_dpni2ethtool(state.advertising,
+				       link_settings->link_modes.advertising);
 	}
 
-	/* At the moment, we have no way of interrogating the DPMAC
-	 * from the DPNI side - and for that matter there may exist
-	 * no DPMAC at all. So for now we just don't report anything
-	 * beyond the DPNI attributes.
-	 */
 	if (state.options & DPNI_LINK_OPT_AUTONEG)
 		link_settings->base.autoneg = AUTONEG_ENABLE;
+	else
+		link_settings->base.autoneg = AUTONEG_DISABLE;
+
 	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
 		link_settings->base.duplex = DUPLEX_FULL;
 	link_settings->base.speed = state.rate;
@@ -135,12 +186,16 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 	else
 		cfg.options &= ~DPNI_LINK_OPT_HALF_DUPLEX;
 
-	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &cfg);
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_LINK_AUTONEG_VER_MAJOR,
+				   DPNI_LINK_AUTONEG_VER_MINOR) < 0) {
+		err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &cfg);
+	} else {
+		link_mode_ethtool2dpni(link_settings->link_modes.advertising,
+				       &cfg.advertising);
+		dpni_set_link_cfg_v2(priv->mc_io, 0, priv->mc_token, &cfg);
+	}
 	if (err)
-		/* ethtool will be loud enough if we return an error; no point
-		 * in putting our own error message on the console by default
-		 */
-		netdev_dbg(net_dev, "ERROR %d setting link cfg\n", err);
+		netdev_err(net_dev, "dpni_set_link_cfg failed");
 
 	return err;
 }
-- 
1.9.1

