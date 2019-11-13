Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9DBFB574
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfKMQnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:43:46 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59854 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfKMQnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:43:46 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xADGhcbD082565;
        Wed, 13 Nov 2019 10:43:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573663418;
        bh=paVykNsFG89EAYUXH9lqwwyyCdE1neML6AzAKD/PJC0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=n4oPiDNZtheKeZtH+8+4wSjk0rsUxZjORymZQ+m3qoUa3wm8sHEtz5mcm0nsKJA1T
         ZU73DSMBjMCiKiGAhou79vTtL3cOYTg4IIKw1qAVzW9c5gaWHlYTo7+gvCvujfwcFn
         TWK2e/zVZ65kxh4LLaYpFwDYjzja7OV1gbFJXvdo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xADGhcrt088352
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 Nov 2019 10:43:38 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 13
 Nov 2019 10:43:20 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 13 Nov 2019 10:43:20 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xADGhb4j067065;
        Wed, 13 Nov 2019 10:43:38 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v3 2/2] net: phy: dp83869: Add TI dp83869 phy
Date:   Wed, 13 Nov 2019 10:42:26 -0600
Message-ID: <20191113164226.3281-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.22.0.214.g8dca754b1e
In-Reply-To: <20191113164226.3281-1-dmurphy@ti.com>
References: <20191113164226.3281-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the TI DP83869 Gigabit ethernet phy
device.

The DP83869 is a robust, low power, fully featured
Physical Layer transceiver with integrated PMD
sublayers to support 10BASE-T, 100BASE-TX and
1000BASE-T Ethernet protocols.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig   |   6 +
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/dp83869.c | 431 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 438 insertions(+)
 create mode 100644 drivers/net/phy/dp83869.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index fe602648b99f..4f8db1bb72a8 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -364,6 +364,12 @@ config DP83867_PHY
 	---help---
 	  Currently supports the DP83867 PHY.
 
+config DP83869_PHY
+	tristate "Texas Instruments DP83869 Gigabit PHY"
+	---help---
+	  Currently supports the DP83869 PHY.  This PHY supports copper and
+	  fiber connections.
+
 config FIXED_PHY
 	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
 	depends on PHYLIB
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a03437e091f3..b433ec3bf9a6 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_DP83822_PHY)	+= dp83822.o
 obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
 obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
 obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
+obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
new file mode 100644
index 000000000000..fcd418716c10
--- /dev/null
+++ b/drivers/net/phy/dp83869.c
@@ -0,0 +1,431 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for the Texas Instruments DP83869 PHY
+ * Copyright (C) 2019 Texas Instruments Inc.
+ */
+
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/delay.h>
+
+#include <dt-bindings/net/ti-dp83869.h>
+
+#define DP83869_PHY_ID		0x2000a0f1
+#define DP83869_DEVADDR		0x1f
+
+#define MII_DP83869_PHYCTRL	0x10
+#define MII_DP83869_MICR	0x12
+#define MII_DP83869_ISR		0x13
+#define DP83869_CTRL		0x1f
+#define DP83869_CFG4		0x1e
+
+/* Extended Registers */
+#define DP83869_GEN_CFG3        0x0031
+#define DP83869_RGMIICTL	0x0032
+#define DP83869_STRAP_STS1	0x006e
+#define DP83869_RGMIIDCTL	0x0086
+#define DP83869_IO_MUX_CFG	0x0170
+#define DP83869_OP_MODE		0x01df
+#define DP83869_FX_CTRL		0x0c00
+
+#define DP83869_SW_RESET	BIT(15)
+#define DP83869_SW_RESTART	BIT(14)
+
+/* MICR Interrupt bits */
+#define MII_DP83869_MICR_AN_ERR_INT_EN		BIT(15)
+#define MII_DP83869_MICR_SPEED_CHNG_INT_EN	BIT(14)
+#define MII_DP83869_MICR_DUP_MODE_CHNG_INT_EN	BIT(13)
+#define MII_DP83869_MICR_PAGE_RXD_INT_EN	BIT(12)
+#define MII_DP83869_MICR_AUTONEG_COMP_INT_EN	BIT(11)
+#define MII_DP83869_MICR_LINK_STS_CHNG_INT_EN	BIT(10)
+#define MII_DP83869_MICR_FALSE_CARRIER_INT_EN	BIT(8)
+#define MII_DP83869_MICR_SLEEP_MODE_CHNG_INT_EN	BIT(4)
+#define MII_DP83869_MICR_WOL_INT_EN		BIT(3)
+#define MII_DP83869_MICR_XGMII_ERR_INT_EN	BIT(2)
+#define MII_DP83869_MICR_POL_CHNG_INT_EN	BIT(1)
+#define MII_DP83869_MICR_JABBER_INT_EN		BIT(0)
+
+#define MII_DP83869_BMCR_DEFAULT	(BMCR_ANENABLE | \
+					 BMCR_FULLDPLX | \
+					 BMCR_SPEED1000)
+
+/* This is the same bit mask as the BMCR so re-use the BMCR default */
+#define DP83869_FX_CTRL_DEFAULT	MII_DP83869_BMCR_DEFAULT
+
+/* CFG1 bits */
+#define DP83869_CFG1_DEFAULT	(ADVERTISE_1000HALF | \
+				 ADVERTISE_1000FULL | \
+				 CTL1000_AS_MASTER)
+
+/* RGMIICTL bits */
+#define DP83869_RGMII_TX_CLK_DELAY_EN		BIT(1)
+#define DP83869_RGMII_RX_CLK_DELAY_EN		BIT(0)
+
+/* STRAP_STS1 bits */
+#define DP83869_STRAP_STS1_RESERVED		BIT(11)
+
+/* PHYCTRL bits */
+#define DP83869_RX_FIFO_SHIFT	12
+#define DP83869_TX_FIFO_SHIFT	14
+
+/* PHY_CTRL lower bytes 0x48 are declared as reserved */
+#define DP83869_PHY_CTRL_DEFAULT	0x48
+#define DP83869_PHYCR_FIFO_DEPTH_MASK	GENMASK(15, 12)
+#define DP83869_PHYCR_RESERVED_MASK	BIT(11)
+
+/* RGMIIDCTL bits */
+#define DP83869_RGMII_TX_CLK_DELAY_SHIFT	4
+
+/* IO_MUX_CFG bits */
+#define DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL	0x1f
+
+#define DP83869_IO_MUX_CFG_IO_IMPEDANCE_MAX	0x0
+#define DP83869_IO_MUX_CFG_IO_IMPEDANCE_MIN	0x1f
+#define DP83869_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
+#define DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
+
+/* CFG3 bits */
+#define DP83869_CFG3_PORT_MIRROR_EN              BIT(0)
+
+/* CFG4 bits */
+#define DP83869_INT_OE	BIT(7)
+
+/* OP MODE */
+#define DP83869_OP_MODE_MII			BIT(5)
+#define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
+
+enum {
+	DP83869_PORT_MIRRORING_KEEP,
+	DP83869_PORT_MIRRORING_EN,
+	DP83869_PORT_MIRRORING_DIS,
+};
+
+struct dp83869_private {
+	int tx_fifo_depth;
+	int rx_fifo_depth;
+	int io_impedance;
+	int port_mirroring;
+	bool rxctrl_strap_quirk;
+	int clk_output_sel;
+	int mode;
+};
+
+static int dp83869_ack_interrupt(struct phy_device *phydev)
+{
+	int err = phy_read(phydev, MII_DP83869_ISR);
+
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int dp83869_config_intr(struct phy_device *phydev)
+{
+	int micr_status = 0;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		micr_status = phy_read(phydev, MII_DP83869_MICR);
+		if (micr_status < 0)
+			return micr_status;
+
+		micr_status |=
+			(MII_DP83869_MICR_AN_ERR_INT_EN |
+			MII_DP83869_MICR_SPEED_CHNG_INT_EN |
+			MII_DP83869_MICR_AUTONEG_COMP_INT_EN |
+			MII_DP83869_MICR_LINK_STS_CHNG_INT_EN |
+			MII_DP83869_MICR_DUP_MODE_CHNG_INT_EN |
+			MII_DP83869_MICR_SLEEP_MODE_CHNG_INT_EN);
+
+		return phy_write(phydev, MII_DP83869_MICR, micr_status);
+	}
+
+	return phy_write(phydev, MII_DP83869_MICR, micr_status);
+}
+
+static int dp83869_config_port_mirroring(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+
+	if (dp83869->port_mirroring == DP83869_PORT_MIRRORING_EN)
+		phy_set_bits_mmd(phydev, DP83869_DEVADDR, DP83869_GEN_CFG3,
+				 DP83869_CFG3_PORT_MIRROR_EN);
+	else
+		phy_clear_bits_mmd(phydev, DP83869_DEVADDR, DP83869_GEN_CFG3,
+				   DP83869_CFG3_PORT_MIRROR_EN);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF_MDIO
+static int dp83869_of_init(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	int ret;
+
+	if (!of_node)
+		return -ENODEV;
+
+	dp83869->io_impedance = -EINVAL;
+
+	/* Optional configuration */
+	ret = of_property_read_u32(of_node, "ti,clk-output-sel",
+				   &dp83869->clk_output_sel);
+	if (ret || dp83869->clk_output_sel > DP83869_CLK_O_SEL_REF_CLK)
+		dp83869->clk_output_sel = DP83869_CLK_O_SEL_REF_CLK;
+
+	ret = of_property_read_u32(of_node, "ti,op-mode", &dp83869->mode);
+	if (ret == 0) {
+		if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
+		    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
+			return -EINVAL;
+	}
+
+	if (of_property_read_bool(of_node, "ti,max-output-impedance"))
+		dp83869->io_impedance = DP83869_IO_MUX_CFG_IO_IMPEDANCE_MAX;
+	else if (of_property_read_bool(of_node, "ti,min-output-impedance"))
+		dp83869->io_impedance = DP83869_IO_MUX_CFG_IO_IMPEDANCE_MIN;
+
+	if (of_property_read_bool(of_node, "enet-phy-lane-swap"))
+		dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
+	else
+		dp83869->port_mirroring = DP83869_PORT_MIRRORING_DIS;
+
+	if (of_property_read_u32(of_node, "rx-fifo-depth",
+				 &dp83869->rx_fifo_depth))
+		dp83869->rx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
+
+	if (of_property_read_u32(of_node, "tx-fifo-depth",
+				 &dp83869->tx_fifo_depth))
+		dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
+
+	return 0;
+}
+#else
+static int dp83869_of_init(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif /* CONFIG_OF_MDIO */
+
+static int dp83869_configure_rgmii(struct phy_device *phydev,
+				   struct dp83869_private *dp83869)
+{
+	int ret, val;
+
+	if (phy_interface_is_rgmii(phydev)) {
+		val = phy_read(phydev, MII_DP83869_PHYCTRL);
+		if (val < 0)
+			return val;
+
+		val &= ~DP83869_PHYCR_FIFO_DEPTH_MASK;
+		val |= (dp83869->tx_fifo_depth << DP83869_TX_FIFO_SHIFT);
+		val |= (dp83869->rx_fifo_depth << DP83869_RX_FIFO_SHIFT);
+
+		ret = phy_write(phydev, MII_DP83869_PHYCTRL, val);
+		if (ret)
+			return ret;
+	}
+
+	if (dp83869->io_impedance >= 0)
+		phy_modify_mmd(phydev, DP83869_DEVADDR,
+			       DP83869_IO_MUX_CFG,
+			       DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL,
+			       dp83869->io_impedance &
+			       DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
+
+	return ret;
+}
+
+static int dp83869_configure_mode(struct phy_device *phydev,
+				  struct dp83869_private *dp83869)
+{
+	int phy_ctrl_val;
+	int ret;
+
+	if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
+	    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
+		return -EINVAL;
+
+	/* Below init sequence for each operational mode is defined in
+	 * section 9.4.8 of the datasheet.
+	 */
+	ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
+			    dp83869->mode);
+	if (ret)
+		return ret;
+
+	ret = phy_write(phydev, MII_BMCR, MII_DP83869_BMCR_DEFAULT);
+	if (ret)
+		return ret;
+
+	phy_ctrl_val = (dp83869->rx_fifo_depth << DP83869_RX_FIFO_SHIFT |
+			dp83869->tx_fifo_depth << DP83869_TX_FIFO_SHIFT |
+			DP83869_PHY_CTRL_DEFAULT);
+
+	switch (dp83869->mode) {
+	case DP83869_RGMII_COPPER_ETHERNET:
+		ret = phy_write(phydev, MII_DP83869_PHYCTRL,
+				phy_ctrl_val);
+		if (ret)
+			return ret;
+
+		ret = phy_write(phydev, MII_CTRL1000, DP83869_CFG1_DEFAULT);
+		if (ret)
+			return ret;
+
+		ret = dp83869_configure_rgmii(phydev, dp83869);
+		if (ret)
+			return ret;
+		break;
+	case DP83869_RGMII_SGMII_BRIDGE:
+		phy_modify_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
+			       DP83869_SGMII_RGMII_BRIDGE,
+			       DP83869_SGMII_RGMII_BRIDGE);
+
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR,
+				    DP83869_FX_CTRL, DP83869_FX_CTRL_DEFAULT);
+		if (ret)
+			return ret;
+
+		break;
+	case DP83869_1000M_MEDIA_CONVERT:
+		ret = phy_write(phydev, MII_DP83869_PHYCTRL,
+				phy_ctrl_val);
+		if (ret)
+			return ret;
+
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR,
+				    DP83869_FX_CTRL, DP83869_FX_CTRL_DEFAULT);
+		if (ret)
+			return ret;
+		break;
+	case DP83869_100M_MEDIA_CONVERT:
+		ret = phy_write(phydev, MII_DP83869_PHYCTRL,
+				phy_ctrl_val);
+		if (ret)
+			return ret;
+		break;
+	case DP83869_SGMII_COPPER_ETHERNET:
+		ret = phy_write(phydev, MII_DP83869_PHYCTRL,
+				phy_ctrl_val);
+		if (ret)
+			return ret;
+
+		ret = phy_write(phydev, MII_CTRL1000, DP83869_CFG1_DEFAULT);
+		if (ret)
+			return ret;
+
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR,
+				    DP83869_FX_CTRL, DP83869_FX_CTRL_DEFAULT);
+		if (ret)
+			return ret;
+
+		break;
+	case DP83869_RGMII_1000_BASE:
+	case DP83869_RGMII_100_BASE:
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int dp83869_config_init(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	int ret, val;
+
+	ret = dp83869_configure_mode(phydev, dp83869);
+	if (ret)
+		return ret;
+
+	/* Enable Interrupt output INT_OE in CFG4 register */
+	if (phy_interrupt_is_valid(phydev)) {
+		val = phy_read(phydev, DP83869_CFG4);
+		val |= DP83869_INT_OE;
+		phy_write(phydev, DP83869_CFG4, val);
+	}
+
+	if (dp83869->port_mirroring != DP83869_PORT_MIRRORING_KEEP)
+		dp83869_config_port_mirroring(phydev);
+
+	/* Clock output selection if muxing property is set */
+	if (dp83869->clk_output_sel != DP83869_CLK_O_SEL_REF_CLK)
+		phy_modify_mmd(phydev, DP83869_DEVADDR, DP83869_IO_MUX_CFG,
+			       DP83869_IO_MUX_CFG_CLK_O_SEL_MASK,
+			       dp83869->clk_output_sel <<
+			       DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
+
+	return 0;
+}
+
+static int dp83869_probe(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869;
+	int ret;
+
+	dp83869 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83869),
+			       GFP_KERNEL);
+	if (!dp83869)
+		return -ENOMEM;
+
+	phydev->priv = dp83869;
+
+	ret = dp83869_of_init(phydev);
+	if (ret)
+		return ret;
+
+	return dp83869_config_init(phydev);
+}
+
+static int dp83869_phy_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_write(phydev, DP83869_CTRL, DP83869_SW_RESET);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(10, 20);
+
+	/* Global sw reset sets all registers to default.
+	 * Need to set the registers in the PHY to the right config.
+	 */
+	return dp83869_config_init(phydev);
+}
+
+static struct phy_driver dp83869_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(DP83869_PHY_ID),
+		.name		= "TI DP83869",
+
+		.probe          = dp83869_probe,
+		.config_init	= dp83869_config_init,
+		.soft_reset	= dp83869_phy_reset,
+
+		/* IRQ related */
+		.ack_interrupt	= dp83869_ack_interrupt,
+		.config_intr	= dp83869_config_intr,
+
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+	},
+};
+module_phy_driver(dp83869_driver);
+
+static struct mdio_device_id __maybe_unused dp83869_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(DP83869_PHY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(mdio, dp83869_tbl);
+
+MODULE_DESCRIPTION("Texas Instruments DP83869 PHY driver");
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com");
+MODULE_LICENSE("GPL v2");
-- 
2.22.0.214.g8dca754b1e

