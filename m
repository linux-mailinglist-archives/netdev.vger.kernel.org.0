Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC22188822
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCQOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:53:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40974 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQOxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=js1cMqI0tMMqv7zt1fkS4bAuhVX1aBsQDpCsKhLODcs=; b=I64gqa+T+FWzNSWB9YDahsPcgm
        e9dxhL+call5eDZcdxQaAZNHarwMBSmzRrSI5cdj92vQYPtiFKXbwNar6PG8NcZXEZhoMdX6YxxzJ
        d67pwDnEQesT/3Y9Hhlq2/Iwfy0mCeYJJZDtEIWLmhGFGBnuUX8hvheJbKfobF+gOf43yK5ChkV2i
        LoUPLpqHx9XIF4nX2V0KAIKILrER/agDNiQdmyZ+MrCuT53B/s60awCtUbPEvlUEVU+k7tgumfVYS
        o5EJEzFwSXKrL76UIaef4CPPQaACMwXsruwbfKhaJ8OdNbhlSa3fyR9REpH0XOLxSj4QkU3s9BWn1
        3MjGbn2A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44366 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaa-0007in-JE; Tue, 17 Mar 2020 14:53:04 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jEDaX-0008JW-Sl; Tue, 17 Mar 2020 14:53:01 +0000
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [RFC net-next 4/5] dpaa2-mac: add 1000BASE-X/SGMII PCS support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jEDaX-0008JW-Sl@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Mar 2020 14:53:01 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*NOT FOR MERGING*

Add support for the PCS block, so we can dynamically configure it for
1000base-X or SGMII depending on the SFP module inserted. This gives
us more flexibility than using the MC firmware with a "fixed" link
type, which can only be setup to support a single interface mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 206 +++++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   1 +
 2 files changed, 204 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c5fc37..e7b2dc366338 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -7,6 +7,117 @@
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
 
+#define MII_IFMODE		0x14
+#define IF_MODE_SGMII_ENA	BIT(0)
+#define IF_MODE_USE_SGMII_AN	BIT(1)
+#define IF_MODE_SGMII_SPEED_10	(0 << 2)
+#define IF_MODE_SGMII_SPEED_100	(1 << 2)
+#define IF_MODE_SGMII_SPEED_1G	(2 << 2)
+#define IF_MODE_SGMII_SPEED_MSK	(3 << 2)
+#define IF_MODE_SGMII_DUPLEX	BIT(4)		// set = half duplex
+
+static void dpaa2_mac_pcs_get_state(struct phylink_config *config,
+				    struct phylink_link_state *state)
+{
+	struct mdio_device *pcs = phylink_to_dpaa2_mac(config)->pcs;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phylink_mii_c22_pcs_get_state(pcs, state);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static void dpaa2_mac_pcs_an_restart(struct phylink_config *config)
+{
+	struct mdio_device *pcs = phylink_to_dpaa2_mac(config)->pcs;
+
+	phylink_mii_c22_pcs_an_restart(pcs);
+}
+
+static int dpaa2_mac_pcs_config(struct phylink_config *config,
+				unsigned int mode,
+				const struct phylink_link_state *state)
+{
+	struct mdio_device *pcs = phylink_to_dpaa2_mac(config)->pcs;
+	u16 if_mode;
+	int bmcr, ret;
+
+	if (mode == MLO_AN_INBAND)
+		bmcr = BMCR_ANENABLE;
+	else
+		bmcr = 0;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if_mode = IF_MODE_SGMII_ENA;
+		if (mode == MLO_AN_INBAND)
+			if_mode |= IF_MODE_USE_SGMII_AN;
+		mdiobus_modify(pcs->bus, 0, MII_IFMODE,
+			       IF_MODE_SGMII_ENA | IF_MODE_USE_SGMII_AN,
+			       if_mode);
+		mdiobus_modify(pcs->bus, 0, MII_BMCR, BMCR_ANENABLE, bmcr);
+		ret = phylink_mii_c22_pcs_set_advertisement(pcs, state);
+		break;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+		mdiobus_write(pcs->bus, 0, MII_IFMODE, 0);
+		mdiobus_modify(pcs->bus, 0, MII_BMCR, BMCR_ANENABLE, bmcr);
+		ret = phylink_mii_c22_pcs_set_advertisement(pcs, state);
+		break;
+
+	default:
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static void dpaa2_mac_pcs_link_up(struct phylink_config *config,
+				  unsigned int mode, phy_interface_t interface,
+				  int speed, int duplex)
+{
+	struct mdio_device *pcs = phylink_to_dpaa2_mac(config)->pcs;
+	u16 if_mode;
+
+	/* The PCS PHY needs to be configured manually for the speed and
+	 * duplex when operating in SGMII mode without in-band negotiation.
+	 */
+	if (mode == MLO_AN_INBAND || interface != PHY_INTERFACE_MODE_SGMII)
+		return;
+
+	switch (speed) {
+	case SPEED_10:
+		if_mode = IF_MODE_SGMII_SPEED_10;
+		break;
+
+	case SPEED_100:
+		if_mode = IF_MODE_SGMII_SPEED_100;
+		break;
+
+	default:
+		if_mode = IF_MODE_SGMII_SPEED_1G;
+		break;
+	}
+	if (duplex == DUPLEX_HALF)
+		if_mode |= IF_MODE_SGMII_DUPLEX;
+
+	mdiobus_modify(pcs->bus, pcs->addr, MII_IFMODE,
+		       IF_MODE_SGMII_DUPLEX | IF_MODE_SGMII_SPEED_MSK, if_mode);
+}
+
+static const struct phylink_pcs_ops dpaa2_pcs_phylink_ops = {
+	.pcs_get_state = dpaa2_mac_pcs_get_state,
+	.pcs_config = dpaa2_mac_pcs_config,
+	.pcs_an_restart = dpaa2_mac_pcs_an_restart,
+	.pcs_link_up = dpaa2_mac_pcs_link_up,
+};
+
 static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 {
 	*if_mode = PHY_INTERFACE_MODE_NA;
@@ -15,6 +126,11 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	case DPMAC_ETH_IF_RGMII:
 		*if_mode = PHY_INTERFACE_MODE_RGMII;
 		break;
+
+	case DPMAC_ETH_IF_SGMII:
+		*if_mode = PHY_INTERFACE_MODE_SGMII;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -67,6 +183,10 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
 					phy_interface_t interface)
 {
 	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		return interface != mac->if_mode && !mac->pcs;
+
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
@@ -95,13 +215,19 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
 		phylink_set(mask, 1000baseT_Full);
+		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+			break;
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 10baseT_Full);
 		break;
 	default:
 		goto empty_set;
@@ -227,6 +353,65 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 	return fixed;
 }
 
+static int dpaa2_pcs_create(struct dpaa2_mac *mac,
+			    struct device_node *dpmac_node, int id)
+{
+	struct mdio_device *mdiodev;
+	struct device_node *node;
+	struct mii_bus *bus;
+	int err;
+
+	node = of_parse_phandle(dpmac_node, "pcs-mdio", 0);
+	if (!node) {
+		/* allow old DT files to work */
+		netdev_warn(mac->netdev, "pcs-mdio node not found\n");
+		return 0;
+	}
+
+	if (!of_device_is_available(node)) {
+		netdev_err(mac->net_dev, "pcs-mdio node not available\n");
+		return -ENODEV;
+	}
+
+	bus = of_mdio_find_bus(node);
+	of_node_put(node);
+	if (!bus)
+		return -EPROBE_DEFER;
+
+	mdiodev = mdio_device_create(bus, 0);
+	if (IS_ERR(mdiodev)) {
+		err = PTR_ERR(mdiodev);
+		netdev_err(mac->net_dev, "failed to create mdio device: %d\n",
+			   err);
+		goto err;
+	}
+
+	err = mdio_device_register(mdiodev);
+	if (err) {
+		netdev_err(mac->net_dev, "failed to register mdio device: %d\n",
+			   err);
+		goto dev_free;
+	}
+
+	mac->pcs = mdiodev;
+	mac->phylink_config.pcs_poll = true;
+
+	return 0;
+
+dev_free:
+	mdio_device_free(mdiodev);
+err:
+	return err;
+}
+
+static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
+{
+	if (mac->pcs) {
+		mdio_device_remove(mac->pcs);
+		mdio_device_free(mac->pcs);
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
@@ -236,6 +421,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	struct dpmac_attr attr;
 	int err;
 
+	memset(&mac->phylink_config, 0, sizeof(mac->phylink_config));
+
 	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
 			 &dpmac_dev->mc_handle);
 	if (err || !dpmac_dev->mc_handle) {
@@ -278,6 +465,13 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
 
@@ -286,10 +480,13 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 				 &dpaa2_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
-		goto err_put_node;
+		goto err_pcs_destroy;
 	}
 	mac->phylink = phylink;
 
+	if (mac->pcs)
+		phylink_add_pcs(mac->phylink, &dpaa2_pcs_phylink_ops);
+
 	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
 		netdev_err(net_dev, "phylink_of_phy_connect() = %d\n", err);
@@ -302,6 +499,8 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
+err_pcs_destroy:
+	dpaa2_pcs_destroy(mac);
 err_put_node:
 	of_node_put(dpmac_node);
 err_close_dpmac:
@@ -316,6 +515,7 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
+	dpaa2_pcs_destroy(mac);
 	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 2130d9c7d40e..5cfae5f8f55e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -19,6 +19,7 @@ struct dpaa2_mac {
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
+	struct mdio_device *pcs;
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
 };
-- 
2.20.1

