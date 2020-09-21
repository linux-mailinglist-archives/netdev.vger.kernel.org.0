Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8686272C39
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgIUQ2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58624 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgIUQ2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:53 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 12:28:51 EDT
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D01161A0CF2;
        Mon, 21 Sep 2020 18:20:42 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C061D1A0CF4;
        Mon, 21 Sep 2020 18:20:42 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F48F202B6;
        Mon, 21 Sep 2020 18:20:42 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-mac: add PCS support through the Lynx module
Date:   Mon, 21 Sep 2020 19:20:31 +0300
Message-Id: <20200921162031.12921-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921162031.12921-1-ioana.ciornei@nxp.com>
References: <20200921162031.12921-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include PCS support in the dpaa2-eth driver by integrating it with the
new Lynx PCS module. There is not much to talk about in terms of changes
needed in the dpaa2-eth driver since the only steps necessary are to
find the MDIO device representing the PCS, register it to the Lynx PCS
module and then let phylink know if its existence also.
After this, the PCS callbacks will be treated directly by Lynx, without
interraction from dpaa2-eth's part.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 88 ++++++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 +
 3 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index feea797cde02..cfd369cf4c8c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -3,6 +3,7 @@ config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
+	select PCS_LYNX
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..8956ae5ea924 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -15,6 +15,18 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	case DPMAC_ETH_IF_RGMII:
 		*if_mode = PHY_INTERFACE_MODE_RGMII;
 		break;
+	case DPMAC_ETH_IF_USXGMII:
+		*if_mode = PHY_INTERFACE_MODE_USXGMII;
+		break;
+	case DPMAC_ETH_IF_QSGMII:
+		*if_mode = PHY_INTERFACE_MODE_QSGMII;
+		break;
+	case DPMAC_ETH_IF_SGMII:
+		*if_mode = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case DPMAC_ETH_IF_XFI:
+		*if_mode = PHY_INTERFACE_MODE_10GBASER;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -67,6 +79,10 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
 					phy_interface_t interface)
 {
 	switch (interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
@@ -95,6 +111,17 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_USXGMII:
+		phylink_set(mask, 10000baseT_Full);
+		if (state->interface == PHY_INTERFACE_MODE_10GBASER)
+			break;
+		phylink_set(mask, 5000baseT_Full);
+		phylink_set(mask, 2500baseT_Full);
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
@@ -227,6 +254,51 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 	return fixed;
 }
 
+static int dpaa2_pcs_create(struct dpaa2_mac *mac,
+			    struct device_node *dpmac_node, int id)
+{
+	struct mdio_device *mdiodev;
+	struct device_node *node;
+
+	node = of_parse_phandle(dpmac_node, "pcs-handle", 0);
+	if (!node) {
+		/* do not error out on old DTS files */
+		netdev_warn(mac->net_dev, "pcs-handle node not found\n");
+		return 0;
+	}
+
+	if (!of_device_is_available(node) ||
+	    !of_device_is_available(node->parent)) {
+		netdev_err(mac->net_dev, "pcs-handle node not available\n");
+		return -ENODEV;
+	}
+
+	mdiodev = of_mdio_find_device(node);
+	of_node_put(node);
+	if (!mdiodev)
+		return -EPROBE_DEFER;
+
+	mac->pcs = lynx_pcs_create(mdiodev);
+	if (!mac->pcs) {
+		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
+		put_device(&mdiodev->dev);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
+{
+	struct lynx_pcs *pcs = mac->pcs;
+
+	if (pcs) {
+		put_device(&pcs->mdio->dev);
+		lynx_pcs_destroy(pcs);
+		mac->pcs = NULL;
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
@@ -278,6 +350,13 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_put_node;
 	}
 
+	if (attr.link_type == DPMAC_LINK_TYPE_PHY &&
+	    attr.eth_if != DPMAC_ETH_IF_RGMII) {
+		err = dpaa2_pcs_create(mac, dpmac_node, attr.id);
+		if (err)
+			goto err_put_node;
+	}
+
 	mac->phylink_config.dev = &net_dev->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
 
@@ -286,10 +365,13 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
-		goto err_put_node;
+		goto err_pcs_destroy;
 	}
 	mac->phylink = phylink;
 
+	if (mac->pcs)
+		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
+
 	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
 		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
@@ -302,6 +384,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
+err_pcs_destroy:
+	dpaa2_pcs_destroy(mac);
 err_put_node:
 	of_node_put(dpmac_node);
 err_close_dpmac:
@@ -316,6 +400,8 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
+	dpaa2_pcs_destroy(mac);
+
 	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 2130d9c7d40e..955a52856210 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -7,6 +7,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/phylink.h>
+#include <linux/pcs-lynx.h>
 
 #include "dpmac.h"
 #include "dpmac-cmd.h"
@@ -21,6 +22,7 @@ struct dpaa2_mac {
 	struct phylink *phylink;
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
+	struct lynx_pcs *pcs;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-- 
2.25.1

