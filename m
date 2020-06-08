Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E741F1F1F
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgFHSkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFHSkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:40:05 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9CFC08C5C2;
        Mon,  8 Jun 2020 11:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bJTlH/hOKVgJhuAh3/c2AMzeHLc6tJ7LPTIL+3j18jI=; b=soepZDSrZGxKBS7ax7SkT42dM/
        OdTNdJ4qn/mxPDevNx7BWqyiQt5mlsVn9WYkHLeiLyVa2mdzy6IVBc8EQqzDYdLQDmtmuri9ZGr3m
        2o4pEIrF0N4WJX9KIi586WqNH/Oknipyesr3cX6LO2Q/9LKeTXCIY13pMYICHUk2OjJrR8XhBWNUG
        oBCIelukCYIjqo3/WEmjwAStjNWD9STAC5HJE1l/ZDKJPUaDBQrZDgXkpryTKJ4dQj7StbE59su8i
        UAZ5bzz+Oun3JA3BkAcuOdyEha43rmT07+Gxm5xzODRTEhdkNrr1Fr8qo0xL4MG6YwXJXWfI75hYR
        6sUpX7vA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jiMgb-0004OM-RA; Mon, 08 Jun 2020 19:39:53 +0100
Date:   Mon, 8 Jun 2020 19:39:53 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <20200608183953.GR311@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606105909.GN311@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 11:59:09AM +0100, Jonathan McDowell wrote:
> I'll go away and roll a v2 moving qca8k over to phylink and then using
> that to auto select the appropriate SGMII mode. Thanks for the feedback.

Ok, take 2. I've switched the driver over to phylink which has let me
drop the need for any device tree configuration; if we're a CPU port
then we're in SGMII-PHY mode, otherwise we choose between SGMII-MAC +
Base-X on what phylink tells us.

----

This patch improves the handling of the SGMII interface on the QCA8K
devices. Previously the driver did no configuration of the port, even if
it was selected. We now configure it up in the appropriate
PHY/MAC/Base-X mode depending on what phylink tells us we are connected
to and ensure it is enabled.

Tested with a device where the CPU connection is RGMII (i.e. the common
current use case) + one where the CPU connection is SGMII. I don't have
any devices where the SGMII interface is brought out to something other
than the CPU.

v2:
- Switch to phylink
- Avoid need for device tree configuration options

Signed-off-by: Jonathan McDowell <noodles@earth.li>

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d2b5ab403e06..62f609ea0e49 100644
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
 
@@ -743,44 +677,252 @@ qca8k_setup(struct dsa_switch *ds)
 }
 
 static void
-qca8k_adjust_link(struct dsa_switch *ds, int port, struct phy_device *phy)
+qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
+			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg;
+	u32 reg, val;
 
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
 		return;
+	case 6: /* 2nd CPU port / external PHY */
+		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII &&
+		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
+			return;
 
-	/* Set port speed */
-	switch (phy->speed) {
-	case 10:
-		reg = QCA8K_PORT_STATUS_SPEED_10;
+		reg = QCA8K_REG_PORT6_PAD_CTRL;
 		break;
-	case 100:
-		reg = QCA8K_PORT_STATUS_SPEED_100;
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
+		val = QCA8K_PORT_PAD_RGMII_EN;
+		qca8k_write(priv, reg, val);
 		break;
-	case 1000:
-		reg = QCA8K_PORT_STATUS_SPEED_1000;
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
+
+		/* Enable/disable SerDes auto-negotiation as necessary */
+		val = qca8k_read(priv, QCA8K_REG_PWS);
+		if (phylink_autoneg_inband(mode))
+			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
+		else
+			val |= QCA8K_PWS_SERDES_AEN_DIS;
+		qca8k_write(priv, QCA8K_REG_PWS, val);
+
+		/* Configure the SGMII parameters */
+		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
+
+		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+
+		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+		if (dsa_is_cpu_port(ds, port)) {
+			/* CPU port, we're talking to the CPU MAC, be a PHY */
+			val |= QCA8K_SGMII_MODE_CTRL_PHY;
+		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			val |= QCA8K_SGMII_MODE_CTRL_MAC;
+		} else {
+			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
+		}
+
+		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
 		break;
 	default:
-		dev_dbg(priv->dev, "port%d link speed %dMbps not supported.\n",
-			port, phy->speed);
+		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
+			phy_modes(state->interface), port);
 		return;
 	}
+}
+
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
+		break;
+	case 1:
+	case 2:
+	case 3:
+	case 4:
+	case 5:
+		/* Internal PHY */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_GMII)
+			goto unsupported;
+		break;
+	case 6: /* 2nd CPU port / external PHY */
+		if (state->interface != PHY_INTERFACE_MODE_NA &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_SGMII &&
+		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
+			goto unsupported;
+		break;
+	default:
+		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
+unsupported:
+		linkmode_zero(supported);
+		return;
+	}
+
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
+
+	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
+
+	state->link = (reg & QCA8K_PORT_STATUS_LINK_UP);
+	state->an_complete = state->link;
+	state->an_enabled = (reg & QCA8K_PORT_STATUS_LINK_AUTO);
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
 
-	/* Set duplex mode */
-	if (phy->duplex == DUPLEX_FULL)
-		reg |= QCA8K_PORT_STATUS_DUPLEX;
+	state->pause = MLO_PAUSE_NONE;
+	if (reg & QCA8K_PORT_STATUS_RXFLOW)
+		state->pause |= MLO_PAUSE_RX;
+	if (reg & QCA8K_PORT_STATUS_TXFLOW)
+		state->pause |= MLO_PAUSE_TX;
+	if (reg & QCA8K_PORT_STATUS_FLOW_AUTO)
+		state->pause |= MLO_PAUSE_AN;
 
-	/* Force flow control */
-	if (dsa_is_cpu_port(ds, port))
-		reg |= QCA8K_PORT_STATUS_RXFLOW | QCA8K_PORT_STATUS_TXFLOW;
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
@@ -937,13 +1079,11 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
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
@@ -1026,7 +1166,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
-	.adjust_link            = qca8k_adjust_link,
 	.get_strings		= qca8k_get_strings,
 	.get_ethtool_stats	= qca8k_get_ethtool_stats,
 	.get_sset_count		= qca8k_get_sset_count,
@@ -1040,6 +1179,11 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
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
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 42d6ea24eb14..10ef2bca2cde 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -36,6 +36,8 @@
 #define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
+#define QCA8K_REG_PWS					0x010
+#define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
 #define QCA8K_REG_MIB					0x034
@@ -69,6 +71,7 @@
 #define   QCA8K_PORT_STATUS_LINK_UP			BIT(8)
 #define   QCA8K_PORT_STATUS_LINK_AUTO			BIT(9)
 #define   QCA8K_PORT_STATUS_LINK_PAUSE			BIT(10)
+#define   QCA8K_PORT_STATUS_FLOW_AUTO			BIT(12)
 #define QCA8K_REG_PORT_HDR_CTRL(_i)			(0x9c + (_i * 4))
 #define   QCA8K_PORT_HDR_CTRL_RX_MASK			GENMASK(3, 2)
 #define   QCA8K_PORT_HDR_CTRL_RX_S			2
@@ -77,6 +80,16 @@
 #define   QCA8K_PORT_HDR_CTRL_ALL			2
 #define   QCA8K_PORT_HDR_CTRL_MGMT			1
 #define   QCA8K_PORT_HDR_CTRL_NONE			0
+#define QCA8K_REG_SGMII_CTRL				0x0e0
+#define   QCA8K_SGMII_EN_PLL				BIT(1)
+#define   QCA8K_SGMII_EN_RX				BIT(2)
+#define   QCA8K_SGMII_EN_TX				BIT(3)
+#define   QCA8K_SGMII_EN_SD				BIT(4)
+#define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
+#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
+#define   QCA8K_SGMII_MODE_CTRL_BASEX			(0 << 22)
+#define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
+#define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
 
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
