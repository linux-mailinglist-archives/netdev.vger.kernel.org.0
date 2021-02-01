Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E2B30B0E9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhBATzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:55:46 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:50666 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhBATzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 14:55:12 -0500
X-Greylist: delayed 1869 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2021 14:55:10 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type;
        bh=myK6cQQzMxgYoV2hhs7cdtiAdqh9UIoSjDmPzAgRz00=;
        b=RC4n4a+WdolHbC72rjD7eDe/xvDpIgBA0gaMrqZIiywHPVzOXut/6IH8pCXkVlWADYnj22AxvDv0v
         jWm9EptnDZNN66uF5+pGyTj2dP7nTWKonQW1SXP5NkZBIjHThDnAnfRuxZETUnfyxoIJncj3WfGafM
         xz6syyL06WF02wb7BT6hGBq0e2b2qJlu9WOIudXoia86LZQC1us1HAOuu5cTTnl6q9nxMN2uoQfob1
         59OAmjeXC0qIiEA0Tu+HLjvAq4nkQ6ByZChhuuYh5zn5c4nA9wPn/dGqhUbT7s/0YzUybpi11RAomw
         BYskFG7T31iTm49PQIefONz++6gXbKQ==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW, TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Mon, 1 Feb 2021 22:23:01 +0300
Date:   Mon, 1 Feb 2021 22:22:51 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     i.bornyakov@metrotek.ru, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for the Marvell 88X2222 multi-speed ethernet
transceiver.

This PHY provides data transmission over fiber-optic as well as Twinax
copper links. The 88X2222 supports 2 ports of 10GBase-R and 1000Base-X
on the line-side interface. The host-side interface supports 4 ports of
10GBase-R, RXAUI, 1000Base-X and 2 ports of XAUI.

This driver, however, supports only XAUI on the host-side and
1000Base-X/10GBase-R on the line-side, for now. Interrupts are not
supported also.

Internal registers access compliant with the Clause 45 specification.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/marvell-88x2222.c | 480 ++++++++++++++++++++++++++++++
 include/linux/marvell_phy.h       |   1 +
 4 files changed, 488 insertions(+)
 create mode 100644 drivers/net/phy/marvell-88x2222.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 698bea312adc..a615b3660b05 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -201,6 +201,12 @@ config MARVELL_10G_PHY
 	help
 	  Support for the Marvell Alaska MV88X3310 and compatible PHYs.
 
+config MARVELL_88X2222_PHY
+	tristate "Marvell 88X2222 PHY"
+	help
+	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
+	  Transceiver.
+
 config MICREL_PHY
 	tristate "Micrel PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..de683e3abe63 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
 obj-$(CONFIG_LXT_PHY)		+= lxt.o
 obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
 obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
+obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
 obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
 obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
new file mode 100644
index 000000000000..e2c55db4769f
--- /dev/null
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -0,0 +1,480 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Marvell 88x2222 dual-port multi-speed ethernet transceiver.
+ *
+ * Supports:
+ *	XAUI on the host side.
+ *	1000Base-X or 10GBase-R on the line side.
+ */
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include <linux/marvell_phy.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/sfp.h>
+#include <linux/netdevice.h>
+
+/* Port PCS Configuration */
+#define	MV_PCS_CONFIG		0xF002
+#define	MV_PCS_HOST_XAUI	0x73
+#define	MV_PCS_LINE_10GBR	(0x71 << 8)
+#define	MV_PCS_LINE_1GBX_AN	(0x7B << 8)
+
+/* Port Reset and Power Down */
+#define	MV_PORT_RST	0xF003
+#define	MV_LINE_RST_SW	BIT(15)
+#define	MV_HOST_RST_SW	BIT(7)
+#define	MV_PORT_RST_SW	(MV_LINE_RST_SW | MV_HOST_RST_SW)
+
+/* LED0 Control */
+#define	MV_LED0_CTRL		0xF020
+#define	MV_LED0_SOLID_MASK	(0xf << 4)
+#define	MV_LED0_SOLID_OFF	(0x0 << 4)
+#define	MV_LED0_SOLID_ON	(0x7 << 4)
+
+/* PMD Transmit Disable */
+#define	MV_TX_DISABLE		0x0009
+#define	MV_TX_DISABLE_GLOBAL	BIT(0)
+
+/* 10GBASE-R PCS Status 1 */
+#define	MV_10GBR_STAT		MDIO_STAT1
+
+/* 10GBASE-R PCS Real Time Status Register */
+#define	MV_10GBR_STAT_RT	0x8002
+
+/* 1000Base-X/SGMII Control Register */
+#define	MV_1GBX_CTRL		0x2000
+
+/* 1000BASE-X/SGMII Status Register */
+#define	MV_1GBX_STAT		0x2001
+
+/* 1000Base-X Auto-Negotiation Advertisement Register */
+#define	MV_1GBX_ADVERTISE	0x2004
+
+/* 1000Base-X PHY Specific Status Register */
+#define	MV_1GBX_PHY_STAT		0xA003
+#define	MV_1GBX_PHY_STAT_LSTATUS_RT	BIT(10)
+#define	MV_1GBX_PHY_STAT_AN_RESOLVED	BIT(11)
+#define	MV_1GBX_PHY_STAT_DUPLEX		BIT(13)
+#define	MV_1GBX_PHY_STAT_SPEED100	BIT(14)
+#define	MV_1GBX_PHY_STAT_SPEED1000	BIT(15)
+
+struct mv2222_data {
+	bool sfp_inserted;
+	bool net_up;
+};
+
+/* SFI PMA transmit enable */
+static void mv2222_tx_enable(struct phy_device *phydev)
+{
+	phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MV_TX_DISABLE,
+			   MV_TX_DISABLE_GLOBAL);
+}
+
+/* SFI PMA transmit disable */
+static void mv2222_tx_disable(struct phy_device *phydev)
+{
+	phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MV_TX_DISABLE,
+			 MV_TX_DISABLE_GLOBAL);
+}
+
+static void mv2222_link_led_on(struct phy_device *phydev)
+{
+	phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_LED0_CTRL, MV_LED0_SOLID_MASK,
+		       MV_LED0_SOLID_ON);
+}
+
+static void mv2222_link_led_off(struct phy_device *phydev)
+{
+	phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_LED0_CTRL, MV_LED0_SOLID_MASK,
+		       MV_LED0_SOLID_OFF);
+}
+
+static int mv2222_soft_reset(struct phy_device *phydev)
+{
+	int ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PORT_RST, MV_PORT_RST_SW);
+
+	msleep(2000);
+
+	return ret;
+}
+
+static int sfp_module_insert(void *_priv, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = _priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct mv2222_data *priv = phydev->priv;
+	phy_interface_t interface;
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
+
+	sfp_parse_support(phydev->sfp_bus, id, supported);
+	interface = sfp_select_interface(phydev->sfp_bus, supported);
+
+	dev_info(dev, "%s SFP module inserted", phy_modes(interface));
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		phydev->speed = SPEED_10000;
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+				 phydev->supported);
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
+		mv2222_soft_reset(phydev);
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	default:
+		phydev->speed = SPEED_1000;
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+				   phydev->supported);
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
+		mv2222_soft_reset(phydev);
+	}
+
+	priv->sfp_inserted = true;
+
+	if (priv->net_up)
+		mv2222_tx_enable(phydev);
+
+	return 0;
+}
+
+static void sfp_module_remove(void *_priv)
+{
+	struct phy_device *phydev = _priv;
+	struct mv2222_data *priv = phydev->priv;
+
+	priv->sfp_inserted = false;
+	mv2222_tx_disable(phydev);
+}
+
+static const struct sfp_upstream_ops sfp_phy_ops = {
+	.module_insert = sfp_module_insert,
+	.module_remove = sfp_module_remove,
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+};
+
+static int mv2222_config_init(struct phy_device *phydev)
+{
+	linkmode_zero(phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, phydev->supported);
+
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+	phydev->duplex = DUPLEX_FULL;
+	phydev->autoneg = AUTONEG_DISABLE;
+
+	return 0;
+}
+
+static void mv2222_update_interface(struct phy_device *phydev)
+{
+	if ((phydev->speed == SPEED_1000 ||
+	     phydev->speed == SPEED_100 ||
+	     phydev->speed == SPEED_10) &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX) {
+		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
+		mv2222_soft_reset(phydev);
+	} else if (phydev->speed == SPEED_10000 &&
+		   phydev->interface != PHY_INTERFACE_MODE_10GBASER) {
+		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
+		mv2222_soft_reset(phydev);
+	}
+}
+
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_10g(struct phy_device *phydev)
+{
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_STAT1_LSTATUS) {
+		link = 1;
+
+		/* 10GBASE-R do not support auto-negotiation */
+		phydev->autoneg = AUTONEG_DISABLE;
+		phydev->speed = SPEED_10000;
+		phydev->duplex = DUPLEX_FULL;
+	}
+
+	return link;
+}
+
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_1g(struct phy_device *phydev)
+{
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
+	if (val < 0)
+		return val;
+
+	if (!(val & MDIO_STAT1_LSTATUS) ||
+	    (phydev->autoneg == AUTONEG_ENABLE && !(val & MDIO_AN_STAT1_COMPLETE)))
+		return 0;
+
+	link = 1;
+
+	if (phydev->autoneg == AUTONEG_DISABLE) {
+		phydev->speed = SPEED_1000;
+		phydev->duplex = DUPLEX_FULL;
+
+		return link;
+	}
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_PHY_STAT);
+	if (val < 0)
+		return val;
+
+	if (val & MV_1GBX_PHY_STAT_AN_RESOLVED) {
+		if (val & MV_1GBX_PHY_STAT_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+
+		if (val & MV_1GBX_PHY_STAT_SPEED1000)
+			phydev->speed = SPEED_1000;
+		else if (val & MV_1GBX_PHY_STAT_SPEED100)
+			phydev->speed = SPEED_100;
+		else
+			phydev->speed = SPEED_10;
+	} else {
+		phydev->duplex = DUPLEX_UNKNOWN;
+		phydev->speed = SPEED_UNKNOWN;
+	}
+
+	return link;
+}
+
+static int mv2222_read_status(struct phy_device *phydev)
+{
+	int link;
+
+	linkmode_zero(phydev->lp_advertising);
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		link = mv2222_read_status_10g(phydev);
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	default:
+		link = mv2222_read_status_1g(phydev);
+		break;
+	}
+
+	if (link < 0)
+		return link;
+
+	phydev->link = link;
+
+	if (phydev->link)
+		mv2222_link_led_on(phydev);
+	else
+		mv2222_link_led_off(phydev);
+
+	return 0;
+}
+
+static int mv2222_disable_aneg(struct phy_device *phydev)
+{
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
+}
+
+static int mv2222_enable_aneg(struct phy_device *phydev)
+{
+	return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+				MDIO_AN_CTRL1_ENABLE | MDIO_CTRL1_RESET);
+}
+
+static int mv2222_config_aneg(struct phy_device *phydev)
+{
+	int ret, adv;
+
+	if (phydev->autoneg == AUTONEG_DISABLE ||
+	    phydev->speed == SPEED_10000) {
+		if (phydev->speed == SPEED_10000 &&
+		    !linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+				      phydev->supported))
+			return -EINVAL;
+
+		/* Link partner advertising modes */
+		linkmode_copy(phydev->advertising, phydev->supported);
+
+		mv2222_update_interface(phydev);
+
+		return mv2222_disable_aneg(phydev);
+	}
+
+	/* Try 10G first */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			      phydev->supported)) {
+		phydev->speed = SPEED_10000;
+		mv2222_update_interface(phydev);
+
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT_RT);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MDIO_STAT1_LSTATUS) {
+			phydev->autoneg = AUTONEG_DISABLE;
+			linkmode_copy(phydev->advertising, phydev->supported);
+
+			return mv2222_disable_aneg(phydev);
+		} else {
+			phydev->speed = SPEED_1000;
+			mv2222_update_interface(phydev);
+		}
+	}
+
+	adv = 0;
+	linkmode_zero(phydev->advertising);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			      phydev->supported)) {
+		adv |= ADVERTISE_1000XFULL;
+		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->advertising);
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			      phydev->supported)) {
+		adv |= ADVERTISE_1000XPAUSE;
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				 phydev->advertising);
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      phydev->supported)) {
+		adv |= ADVERTISE_1000XPSE_ASYM;
+		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 phydev->advertising);
+	}
+
+	ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_ADVERTISE,
+			     ADVERTISE_1000XFULL |
+			     ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM,
+			     adv);
+	if (ret < 0)
+		return ret;
+
+	return mv2222_enable_aneg(phydev);
+}
+
+static int mv2222_aneg_done(struct phy_device *phydev)
+{
+	int ret;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			      phydev->supported)) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MDIO_STAT1_LSTATUS)
+			return 1;
+	}
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
+	if (ret < 0)
+		return ret;
+
+	return (ret & MDIO_AN_STAT1_COMPLETE);
+}
+
+static int mv2222_resume(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+
+	priv->net_up = true;
+
+	if (priv->sfp_inserted)
+		mv2222_tx_enable(phydev);
+
+	return 0;
+}
+
+static int mv2222_suspend(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+
+	priv->net_up = false;
+	mv2222_tx_disable(phydev);
+	mv2222_link_led_off(phydev);
+
+	return 0;
+}
+
+static int mv2222_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct mv2222_data *priv = NULL;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return phy_sfp_probe(phydev, &sfp_phy_ops);
+}
+
+static void mv2222_remove(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct mv2222_data *priv = phydev->priv;
+
+	if (priv)
+		devm_kfree(dev, priv);
+}
+
+static struct phy_driver mv2222_drivers[] = {
+	{
+		.phy_id = MARVELL_PHY_ID_88X2222,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88X2222",
+		.soft_reset = mv2222_soft_reset,
+		.config_init = mv2222_config_init,
+		.config_aneg = mv2222_config_aneg,
+		.aneg_done = mv2222_aneg_done,
+		.probe = mv2222_probe,
+		.remove = mv2222_remove,
+		.suspend = mv2222_suspend,
+		.resume = mv2222_resume,
+		.read_status = mv2222_read_status,
+	},
+};
+module_phy_driver(mv2222_drivers);
+
+static struct mdio_device_id __maybe_unused mv2222_tbl[] = {
+	{ MARVELL_PHY_ID_88X2222, MARVELL_PHY_ID_MASK },
+	{ }
+};
+MODULE_DEVICE_TABLE(mdio, mv2222_tbl);
+
+MODULE_DESCRIPTION("Marvell 88x2222 ethernet transceiver driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 52b1610eae68..274abd5fbac3 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -24,6 +24,7 @@
 #define MARVELL_PHY_ID_88E3016		0x01410e60
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
+#define MARVELL_PHY_ID_88X2222		0x01410f10
 
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
-- 
2.20.1


