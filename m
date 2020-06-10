Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B61F5BDB
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgFJTOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJTOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:14:09 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF84C03E96B;
        Wed, 10 Jun 2020 12:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UUKUZQ3OqdSq/ZN18EEaBgdv/S6MKo4aunaCE6J6UZY=; b=mdCxsAe53/sVgnjl7m/e2lf6Uj
        0S8PedA162KgRw6jq7BcYdS6GLrXsd2TZIDlWmn+vFvVXEImqjPQ8MhjlRGjA8ZwlxcqPHTNglOMw
        v5GyZzQhw5wXZQ2t7FF4e+zHsK1t3Rzv1G7wtmIKIYJiLTadxGPt37udIbJ6URLS681t2DmLzqrx3
        owMsg+LlSxFuJnNff/z4bE7rd1iXX5AufpfJNZhAyr6NeyIywNMEudjqTOPRIQnKP77L/gl2QKbRb
        Xqikq50eZHBY9ix6NPLzlfK1XKDDJESJrYZOVmmeseeMUxKJ+Zb6D97OarSJFM76/GuzZNGx2CZZH
        IgFYNrlQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jj6Al-0005oA-Mj; Wed, 10 Jun 2020 20:14:03 +0100
Date:   Wed, 10 Jun 2020 20:14:03 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
Message-ID: <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the driver to use the new PHYLINK callbacks, removing the
legacy adjust_link callback.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/dsa/qca8k.c | 309 +++++++++++++++++++++++++++-------------
 1 file changed, 212 insertions(+), 97 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d2b5ab403e06..dcd9e8fa99b6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -14,6 +14,7 @@
 #include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 #include <linux/mdio.h>
+#include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
 #include <linux/etherdevice.h>
 
@@ -418,55 +419,6 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
-static int
-qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
-{
-	u32 reg, val;
-
-	switch (port) {
-	case 0:
-		reg = QCA8K_REG_PORT0_PAD_CTRL;
-		break;
-	case 6:
-		reg = QCA8K_REG_PORT6_PAD_CTRL;
-		break;
-	default:
-		pr_err("Can't set PAD_CTRL on port %d\n", port);
-		return -EINVAL;
-	}
-
-	/* Configure a port to be directly connected to an external
-	 * PHY or MAC.
-	 */
-	switch (mode) {
-	case PHY_INTERFACE_MODE_RGMII:
-		/* RGMII mode means no delay so don't enable the delay */
-		val = QCA8K_PORT_PAD_RGMII_EN;
-		qca8k_write(priv, reg, val);
-		break;
-	case PHY_INTERFACE_MODE_RGMII_ID:
-		/* RGMII_ID needs internal delay. This is enabled through
-		 * PORT5_PAD_CTRL for all ports, rather than individual port
-		 * registers
-		 */
-		qca8k_write(priv, reg,
-			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
-		break;
-	case PHY_INTERFACE_MODE_SGMII:
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
-		break;
-	default:
-		pr_err("xMII mode %d not supported\n", mode);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static void
 qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 {
@@ -639,9 +591,7 @@ static int
 qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
 	int ret, i;
-	u32 mask;
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -661,24 +611,9 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Initialize CPU port pad mode (xMII type, delays...) */
-	ret = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn, &phy_mode);
-	if (ret) {
-		pr_err("Can't find phy-mode for master device\n");
-		return ret;
-	}
-	ret = qca8k_set_pad_ctrl(priv, QCA8K_CPU_PORT, phy_mode);
-	if (ret < 0)
-		return ret;
-
-	/* Enable CPU Port, force it to maximum bandwidth and full-duplex */
-	mask = QCA8K_PORT_STATUS_SPEED_1000 | QCA8K_PORT_STATUS_TXFLOW |
-	       QCA8K_PORT_STATUS_RXFLOW | QCA8K_PORT_STATUS_DUPLEX;
-	qca8k_write(priv, QCA8K_REG_PORT_STATUS(QCA8K_CPU_PORT), mask);
+	/* Enable CPU Port */
 	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
-	qca8k_port_set_status(priv, QCA8K_CPU_PORT, 1);
-	priv->port_sts[QCA8K_CPU_PORT].enabled = 1;
 
 	/* Enable MIB counters */
 	qca8k_mib_init(priv);
@@ -693,10 +628,9 @@ qca8k_setup(struct dsa_switch *ds)
 		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 			  QCA8K_PORT_LOOKUP_MEMBER, 0);
 
-	/* Disable MAC by default on all user ports */
+	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
-		if (dsa_is_user_port(ds, i))
-			qca8k_port_set_status(priv, i, 0);
+		qca8k_port_set_status(priv, i, 0);
 
 	/* Forward all unknown frames to CPU port for Linux processing */
 	qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
@@ -713,7 +647,7 @@ qca8k_setup(struct dsa_switch *ds)
 				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 		}
 
-		/* Invividual user ports get connected to CPU port only */
+		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
 			int shift = 16 * (i % 2);
 
@@ -743,44 +677,223 @@ qca8k_setup(struct dsa_switch *ds)
 }
 
 static void
-qca8k_adjust_link(struct dsa_switch *ds, int port, struct phy_device *phy)
+qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
+			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg;
 
-	/* Force fixed-link setting for CPU port, skip others. */
-	if (!phy_is_pseudo_fixed_link(phy))
+	switch (port) {
+	case 0: /* 1st CPU port */
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII)
+			return;
+
+		reg = QCA8K_REG_PORT0_PAD_CTRL;
+		break;
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+	case 5:
+		/* Internal PHY, nothing to do */
+		return;
+	case 6: /* 2nd CPU port / external PHY */
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII &&
+		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
+			return;
+
+		reg = QCA8K_REG_PORT6_PAD_CTRL;
+		break;
+	default:
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+		return;
+	}
+
+	if (port != 6 && phylink_autoneg_inband(mode)) {
+		dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
+			__func__);
+		return;
+	}
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		/* RGMII mode means no delay so don't enable the delay */
+		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		/* RGMII_ID needs internal delay. This is enabled through
+		 * PORT5_PAD_CTRL for all ports, rather than individual port
+		 * registers
+		 */
+		qca8k_write(priv, reg,
+			    QCA8K_PORT_PAD_RGMII_EN |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		/* Enable SGMII on the port */
+		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
+		break;
+	default:
+		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
+			phy_modes(state->interface), port);
 		return;
+	}
+}
 
-	/* Set port speed */
-	switch (phy->speed) {
-	case 10:
-		reg = QCA8K_PORT_STATUS_SPEED_10;
+static void
+qca8k_phylink_validate(struct dsa_switch *ds, int port,
+		       unsigned long *supported,
+		       struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (port) {
+	case 0: /* 1st CPU port */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII)
+			goto unsupported;
 		break;
-	case 100:
-		reg = QCA8K_PORT_STATUS_SPEED_100;
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+	case 5:
+		/* Internal PHY */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_GMII)
+			goto unsupported;
 		break;
-	case 1000:
-		reg = QCA8K_PORT_STATUS_SPEED_1000;
+	case 6: /* 2nd CPU port / external PHY */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII &&
+		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
+			goto unsupported;
 		break;
 	default:
-		dev_dbg(priv->dev, "port%d link speed %dMbps not supported.\n",
-			port, phy->speed);
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+unsupported:
+		linkmode_zero(supported);
 		return;
 	}
 
-	/* Set duplex mode */
-	if (phy->duplex == DUPLEX_FULL)
-		reg |= QCA8K_PORT_STATUS_DUPLEX;
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Autoneg);
+
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+
+	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+		phylink_set(mask, 1000baseX_Full);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
+}
+
+static int
+qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
+			     struct phylink_link_state *state)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
 
-	/* Force flow control */
-	if (dsa_is_cpu_port(ds, port))
-		reg |= QCA8K_PORT_STATUS_RXFLOW | QCA8K_PORT_STATUS_TXFLOW;
+	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+
+	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
+	state->an_complete = state->link;
+	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
+	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
+							   DUPLEX_HALF;
+
+	switch (reg & QCA8K_PORT_STATUS_SPEED) {
+	case QCA8K_PORT_STATUS_SPEED_10:
+		state->speed = SPEED_10;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_100:
+		state->speed = SPEED_100;
+		break;
+	case QCA8K_PORT_STATUS_SPEED_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	state->pause = MLO_PAUSE_NONE;
+	if (reg & QCA8K_PORT_STATUS_RXFLOW)
+		state->pause |= MLO_PAUSE_RX;
+	if (reg & QCA8K_PORT_STATUS_TXFLOW)
+		state->pause |= MLO_PAUSE_TX;
+
+	return 1;
+}
+
+static void
+qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct qca8k_priv *priv = ds->priv;
 
-	/* Force link down before changing MAC options */
 	qca8k_port_set_status(priv, port, 0);
+}
+
+static void
+qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+			  phy_interface_t interface, struct phy_device *phydev,
+			  int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg;
+
+	if (phylink_autoneg_inband(mode)) {
+		reg = QCA8K_PORT_STATUS_LINK_AUTO;
+	} else {
+		switch (speed) {
+		case SPEED_10:
+			reg = QCA8K_PORT_STATUS_SPEED_10;
+			break;
+		case SPEED_100:
+			reg = QCA8K_PORT_STATUS_SPEED_100;
+			break;
+		case SPEED_1000:
+			reg = QCA8K_PORT_STATUS_SPEED_1000;
+			break;
+		default:
+			reg = QCA8K_PORT_STATUS_LINK_AUTO;
+			break;
+		}
+
+		if (duplex == DUPLEX_FULL)
+			reg |= QCA8K_PORT_STATUS_DUPLEX;
+
+		if (rx_pause | dsa_is_cpu_port(ds, port))
+			reg |= QCA8K_PORT_STATUS_RXFLOW;
+
+		if (tx_pause | dsa_is_cpu_port(ds, port))
+			reg |= QCA8K_PORT_STATUS_TXFLOW;
+	}
+
+	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
+
 	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
-	qca8k_port_set_status(priv, port, 1);
 }
 
 static void
@@ -937,13 +1050,11 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	qca8k_port_set_status(priv, port, 1);
 	priv->port_sts[port].enabled = 1;
 
-	phy_support_asym_pause(phy);
+	if (dsa_is_user_port(ds, port))
+		phy_support_asym_pause(phy);
 
 	return 0;
 }
@@ -1026,7 +1137,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
-	.adjust_link            = qca8k_adjust_link,
 	.get_strings		= qca8k_get_strings,
 	.get_ethtool_stats	= qca8k_get_ethtool_stats,
 	.get_sset_count		= qca8k_get_sset_count,
@@ -1040,6 +1150,11 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
+	.phylink_validate	= qca8k_phylink_validate,
+	.phylink_mac_link_state	= qca8k_phylink_mac_link_state,
+	.phylink_mac_config	= qca8k_phylink_mac_config,
+	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
+	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 };
 
 static int
-- 
2.20.1

