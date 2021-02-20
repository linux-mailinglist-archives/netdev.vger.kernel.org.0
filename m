Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4D3204D1
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 10:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhBTJrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 04:47:37 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:52714 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhBTJrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 04:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to;
        bh=ZEoo7OSsszRykRhI5XODKGHO2hyN0cXKj7h3maeZvVA=;
        b=ePa1mLwDY2fRlRzv8yd0rO1lhMpb5stxiz4jJ4X4iUFO8u+0queRPFwmqir+1Fs1b7FwUcW1RCEPo
         Q9glYETkyH7HBoFludXR0JboXwsK4NGMUpYhzCNmXA14m0aGtC2iG0Gdm5Uwo9uM7zN43R4EE6wJ4x
         /HYKn5Ua+8mZWYuoGGC7PbQ1m4woD+rIIY0hhLSxH4eefL1KuPMduBVdpgev0HhsVeIiwlXIBJ2YOf
         wOav41to8+LPrUL5iiZ+1SYC3PaVEyVFluRH8Io+hW7oUX9+pVGjHZBaIADqy5i9ITvJqvPCWKbeM7
         iJJjt0X2zyqHc5wRF7+Kki7AtIzcYLQ==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Sat, 20 Feb 2021 12:46:32 +0300
Date:   Sat, 20 Feb 2021 12:46:23 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     i.bornyakov@metrotek.ru, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210220094621.tl6fawj7c5hjrp6s@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
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
1000Base-X/10GBase-R on the line-side, for now. The SGMII is also
supported over 1000Base-X. Interrupts are not supported.

Internal registers access compliant with the Clause 45 specification.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
---
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/marvell-88x2222.c | 510 ++++++++++++++++++++++++++++++
 include/linux/marvell_phy.h       |   1 +
 4 files changed, 518 insertions(+)
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
index 000000000000..5f1b6185e272
--- /dev/null
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -0,0 +1,510 @@
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
+#define	MV_PCS_LINE_SGMII_AN	(0x7F << 8)
+
+/* Port Reset and Power Down */
+#define	MV_PORT_RST	0xF003
+#define	MV_LINE_RST_SW	BIT(15)
+#define	MV_HOST_RST_SW	BIT(7)
+#define	MV_PORT_RST_SW	(MV_LINE_RST_SW | MV_HOST_RST_SW)
+
+/* 10GBASE-R PCS Real Time Status Register */
+#define	MV_10GBR_STAT_RT	0x8002
+
+/* 1000Base-X/SGMII Control Register */
+#define	MV_1GBX_CTRL		(0x2000 + MII_BMCR)
+
+/* 1000BASE-X/SGMII Status Register */
+#define	MV_1GBX_STAT		(0x2000 + MII_BMSR)
+
+/* 1000Base-X Auto-Negotiation Advertisement Register */
+#define	MV_1GBX_ADVERTISE	(0x2000 + MII_ADVERTISE)
+
+/* 1000Base-X PHY Specific Status Register */
+#define	MV_1GBX_PHY_STAT		0xA003
+#define	MV_1GBX_PHY_STAT_AN_RESOLVED	BIT(11)
+#define	MV_1GBX_PHY_STAT_DUPLEX		BIT(13)
+#define	MV_1GBX_PHY_STAT_SPEED100	BIT(14)
+#define	MV_1GBX_PHY_STAT_SPEED1000	BIT(15)
+
+struct mv2222_data {
+	phy_interface_t line_interface;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+};
+
+/* SFI PMA transmit enable */
+static int mv2222_tx_enable(struct phy_device *phydev)
+{
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_TXDIS,
+				  MDIO_PMD_TXDIS_GLOBAL);
+}
+
+/* SFI PMA transmit disable */
+static int mv2222_tx_disable(struct phy_device *phydev)
+{
+	return phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_TXDIS,
+				MDIO_PMD_TXDIS_GLOBAL);
+}
+
+static int mv2222_soft_reset(struct phy_device *phydev)
+{
+	int val, ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PORT_RST,
+			    MV_PORT_RST_SW);
+	if (ret < 0)
+		return ret;
+
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND2, MV_PORT_RST,
+					 val, !(val & MV_PORT_RST_SW),
+					 5000, 1000000, true);
+}
+
+static int sfp_module_insert(void *_priv, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = _priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct mv2222_data *priv = phydev->priv;
+	phy_interface_t sfp_interface;
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_supported) = { 0, };
+
+	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
+	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
+
+	dev_info(dev, "%s SFP module inserted", phy_modes(sfp_interface));
+
+	switch (sfp_interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		phydev->speed = SPEED_10000;
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		phydev->speed = SPEED_1000;
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		phydev->speed = SPEED_1000;
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_SGMII_AN);
+		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED1000);
+		break;
+	default:
+		dev_err(dev, "Incompatible SFP module inserted\n");
+
+		return -EINVAL;
+	}
+
+	linkmode_and(phydev->supported, priv->supported, sfp_supported);
+	priv->line_interface = sfp_interface;
+
+	return mv2222_soft_reset(phydev);
+}
+
+static void sfp_module_remove(void *_priv)
+{
+	struct phy_device *phydev = _priv;
+	struct mv2222_data *priv = phydev->priv;
+
+	priv->line_interface = PHY_INTERFACE_MODE_NA;
+	linkmode_copy(phydev->supported, priv->supported);
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
+	if (phydev->interface != PHY_INTERFACE_MODE_XAUI)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* switch line-side interface between 10GBase-R and 1GBase-X
+ * according to speed */
+static void mv2222_update_interface(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+
+	if (phydev->speed == SPEED_10000 &&
+	    priv->line_interface == PHY_INTERFACE_MODE_1000BASEX) {
+		priv->line_interface = PHY_INTERFACE_MODE_10GBASER;
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
+		mv2222_soft_reset(phydev);
+	}
+
+	if (phydev->speed == SPEED_1000 &&
+	    priv->line_interface == PHY_INTERFACE_MODE_10GBASER) {
+		priv->line_interface = PHY_INTERFACE_MODE_1000BASEX;
+
+		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
+			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
+		mv2222_soft_reset(phydev);
+	}
+}
+
+/* Returns negative on error, 0 if link is down, 1 if link is up */
+static int mv2222_read_status_10g(struct phy_device *phydev)
+{
+	int val, link = 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
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
+	if (!(val & BMSR_LSTATUS) ||
+	    (phydev->autoneg == AUTONEG_ENABLE &&
+	     !(val & BMSR_ANEGCOMPLETE)))
+		return 0;
+
+	link = 1;
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
+	struct mv2222_data *priv = phydev->priv;
+	int link;
+
+	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
+		link = mv2222_read_status_10g(phydev);
+	else
+		link = mv2222_read_status_1g(phydev);
+
+	if (link < 0)
+		return link;
+
+	phydev->link = link;
+
+	return 0;
+}
+
+static int mv2222_disable_aneg(struct phy_device *phydev)
+{
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+				  BMCR_ANENABLE | BMCR_ANRESTART);
+}
+
+static int mv2222_enable_aneg(struct phy_device *phydev)
+{
+	return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+				BMCR_ANENABLE | BMCR_RESET);
+}
+
+static int mv2222_set_sgmii_speed(struct phy_device *phydev)
+{
+	switch (phydev->speed) {
+	case SPEED_1000:
+		if (!(linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+					phydev->supported) ||
+		      linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+					phydev->supported)))
+			return -EINVAL;
+
+		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED1000);
+		break;
+	case SPEED_100:
+		if (!(linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+					phydev->supported) ||
+		      linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+					phydev->supported)))
+			return -EINVAL;
+
+		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED100);
+		break;
+	case SPEED_10:
+		if (!(linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+					phydev->supported) ||
+		      linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+					phydev->supported)))
+			return -EINVAL;
+
+		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
+			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED10);
+		break;
+	default:
+		break;
+	}
+
+	return mv2222_soft_reset(phydev);
+}
+
+static bool mv2222_is_10g_capable(struct phy_device *phydev)
+{
+	return (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
+				  phydev->supported) ||
+		linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+				  phydev->supported));
+}
+
+static int mv2222_config_aneg(struct phy_device *phydev)
+{
+	struct mv2222_data *priv = phydev->priv;
+	int ret, adv;
+
+	/* SFP is not present, do nothing */
+	if (priv->line_interface == PHY_INTERFACE_MODE_NA)
+		return 0;
+
+	if (phydev->autoneg == AUTONEG_DISABLE ||
+	    phydev->speed == SPEED_10000) {
+		if (phydev->speed == SPEED_10000 &&
+		    !mv2222_is_10g_capable(phydev))
+			return -EINVAL;
+
+		if (priv->line_interface == PHY_INTERFACE_MODE_SGMII) {
+			ret = mv2222_set_sgmii_speed(phydev);
+			if (ret < 0)
+				return ret;
+		} else {
+			mv2222_update_interface(phydev);
+		}
+
+		return mv2222_disable_aneg(phydev);
+	}
+
+	/* Try 10G first */
+	if (mv2222_is_10g_capable(phydev)) {
+		phydev->speed = SPEED_10000;
+		mv2222_update_interface(phydev);
+
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT_RT);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MDIO_STAT1_LSTATUS) {
+			phydev->autoneg = AUTONEG_DISABLE;
+
+			return mv2222_disable_aneg(phydev);
+		}
+
+		/* 10G link was not established, switch back to 1G
+		 * and proceed with true autonegotiation */
+		phydev->speed = SPEED_1000;
+		mv2222_update_interface(phydev);
+	}
+
+	adv = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			      phydev->supported))
+		adv |= ADVERTISE_1000XFULL;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			      phydev->supported))
+		adv |= ADVERTISE_1000XPAUSE;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      phydev->supported))
+		adv |= ADVERTISE_1000XPSE_ASYM;
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
+	if (mv2222_is_10g_capable(phydev)) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_STAT1);
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
+	return (ret & BMSR_ANEGCOMPLETE);
+}
+
+static int mv2222_resume(struct phy_device *phydev)
+{
+	return mv2222_tx_enable(phydev);
+}
+
+static int mv2222_suspend(struct phy_device *phydev)
+{
+	return mv2222_tx_disable(phydev);
+}
+
+static int mv2222_get_features(struct phy_device *phydev)
+{
+	/* All supported linkmodes are set at probe
+	 * and adjusted at SFP module insert */
+
+	return 0;
+}
+
+static int mv2222_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct mv2222_data *priv = NULL;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseCR_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseER_Full_BIT, supported);
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	linkmode_copy(phydev->supported, supported);
+	linkmode_copy(priv->supported, supported);
+	priv->line_interface = PHY_INTERFACE_MODE_NA;
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
+		.get_features = mv2222_get_features,
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


