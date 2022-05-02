Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886C9516C9C
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383957AbiEBI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383950AbiEBI6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:58:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A81580CC
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:54:50 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nlRpJ-0002Gg-IE; Mon, 02 May 2022 10:54:41 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nlRpJ-006UvK-As; Mon, 02 May 2022 10:54:39 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nlRpG-000axD-E2; Mon, 02 May 2022 10:54:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY
Date:   Mon,  2 May 2022 10:54:37 +0200
Message-Id: <20220502085437.142000-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
that supports 10M single pair cable.

This driver was tested with NXP SJA1105, STMMAC and ASIX AX88772B USB Ethernet
controller.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/Kconfig     |   6 +
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/dp83td510.c | 299 ++++++++++++++++++++++++++++++++++++
 3 files changed, 306 insertions(+)
 create mode 100644 drivers/net/phy/dp83td510.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index bbbf6c07ea53..9fee639ee5c8 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -342,6 +342,12 @@ config DP83869_PHY
 	  Currently supports the DP83869 PHY.  This PHY supports copper and
 	  fiber connections.
 
+config DP83TD510_PHY
+	tristate "Texas Instruments DP83TD510 Ethernet 10Base-T1L PHY"
+	help
+	  Support for the DP83TD510 Ethernet 10Base-T1L PHY. This PHY supports
+	  a 10M single pair Ethernet connection for up to 1000 meter cable.
+
 config VITESSE_PHY
 	tristate "Vitesse PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b82651b57043..b12b1d86fc99 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
 obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
 obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
 obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
+obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
new file mode 100644
index 000000000000..90531d849545
--- /dev/null
+++ b/drivers/net/phy/dp83td510.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for the Texas Instruments DP83TD510 PHY
+ * Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define DP83TD510E_PHY_ID			0x20000181
+
+/* MDIO_MMD_VEND2 registers */
+#define DP83TD510E_PHY_STS			0x10
+#define DP83TD510E_STS_MII_INT			BIT(7)
+
+#define DP83TD510E_GEN_CFG			0x11
+#define DP83TD510E_GENCFG_INT_POLARITY		BIT(3)
+#define DP83TD510E_GENCFG_INT_EN		BIT(1)
+#define DP83TD510E_GENCFG_INT_OE		BIT(0)
+
+#define DP83TD510E_INTERRUPT_REG_1		0x12
+#define DP83TD510E_INT1_LINK			BIT(13)
+#define DP83TD510E_INT1_LINK_EN			BIT(5)
+
+static const u16 devad1[] = {
+	0x000, 0x007, 0x00B, 0x012, 0x834, 0x8F6, 0x8F7, 0x8F8
+};
+
+static const u16 devad3[] = {
+	0x3000, 0x38E6, 0x38E7
+};
+
+static const u16 devad7[] = {
+	0x200, 0x201, 0x202, 0x203, 0x204, 0x205, 0x206, 0x207, 0x208, 0x209,
+	0x20A, 0x20B, 0x20C, 0x20D, 0x20E, 0x20F };
+
+static const u16 devad1f[] = {
+	0x0, 0x2, 0x3, 0x10, 0x11, 0x12, 0x13, 0x15, 0x16, 0x17, 0x18, 0x19,
+	0x1E, 0x119, 0x11A, 0x11B, 0x11C, 0x11D, 0x11E, 0x11F, 0x120, 0x121,
+	0x122, 0x123, 0x124, 0x125, 0x126, 0x127, 0x128, 0x129, 0x12A, 0x12B,
+	0x12C, 0x12D, 0x12E, 0x12F, 0x130, 0x300, 0x301, 0x302, 0x303, 0x304,
+	0x305, 0x306, 0x307, 0x308, 0x309, 0x30A, 0x420, 0x460, 0x461, 0x462,
+	0x463, 0x467, 0x468, 0x469, 0x60C, 0x872, 0x88D, 0x88E, 0x88F, 0x890,
+	0x891, 0x892, 0x898, 0x899, 0x89A, 0x89B, 0x89C, 0x89D, 0x8E9, 0x8EA,
+	0x8EB, 0x8EC, 0x8ED, 0x8EE, 0xA9D, 0xA9F, 0xE01
+};
+
+/* This PHY has some differences compared to 802.3cg-2019 specification. To
+ * avoid misconfiguration it is better to validate register accesses.
+ */
+static int dp83td510_validate_mmd(struct phy_device *phydev, int devad,
+				  u16 regnum)
+{
+	const u16 *regs;
+	size_t size;
+	int i;
+
+	switch (devad) {
+	case MDIO_MMD_PMAPMD:
+		regs = &devad1[0];
+		size = ARRAY_SIZE(devad1);
+		break;
+	case MDIO_MMD_PCS:
+		regs = &devad3[0];
+		size = ARRAY_SIZE(devad3);
+		break;
+	case MDIO_MMD_AN:
+		regs = &devad7[0];
+		size = ARRAY_SIZE(devad7);
+		break;
+	case MDIO_MMD_VEND2:
+		regs = &devad1f[0];
+		size = ARRAY_SIZE(devad1f);
+		break;
+	default:
+		phydev_err(phydev, "Unknown device %i.%i\n", devad, regnum);
+		return -ENOTSUPP;
+	}
+
+	for (i = 0; i < size; i++)
+		if (regs[i] == regnum)
+			return 0;
+
+	phydev_err(phydev, "Unknown register %i.%i\n", devad, regnum);
+
+	WARN_ON_ONCE(1);
+
+	return -ENOTSUPP;
+}
+
+static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
+			     u16 regnum)
+{
+	/* Write the desired MMD Devad */
+	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
+
+	/* Write the desired MMD register address */
+	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
+
+	/* Select the Function : DATA with no post increment */
+	__mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
+			devad | MII_MMD_CTRL_NOINCR);
+}
+
+static int dp83td510_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	int val;
+
+	if (regnum > (u16)~0 || devad > 32)
+		return -EINVAL;
+
+	switch (devad) {
+	case MDIO_MMD_PMAPMD:
+		/* we do not have 1.1 register. Link status 1.1.2 can get on 7.513.2 */
+		if (regnum == MDIO_STAT1) {
+			devad = MDIO_MMD_AN;
+			regnum = MDIO_AN_T1_STAT;
+		}
+		/* 1.8 register is not present on this PHY, without it PHYlib
+		 * can't find T1 capabilities register.
+		 */
+		if (regnum == MDIO_STAT2)
+			return MDIO_PMA_STAT2_EXTABLE;
+
+		break;
+	case MDIO_MMD_AN:
+		/* Not supported on T1 or at least not on this PHY, use 7.512
+		 * instead. This regs look similar.
+		 */
+		if (regnum == MDIO_CTRL1)
+			regnum = MDIO_AN_T1_CTRL;
+		break;
+	case MDIO_MMD_PCS:
+		if (regnum == MDIO_PCS_EEE_ABLE)
+			return 0;
+		break;
+	}
+
+	val = dp83td510_validate_mmd(phydev, devad, regnum);
+	if (val < 0)
+		return 0;
+
+	/* This PHY supports only C22 MDIO opcodes. We can use only indirect
+	 * access.
+	 */
+	mmd_phy_indirect(bus, phy_addr, devad, regnum);
+
+	/* Read the content of the MMD's selected register */
+	val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
+
+	return val;
+}
+
+static int dp83td510_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
+			       u16 val)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	int ret;
+
+	if (regnum > (u16)~0 || devad > 32)
+		return -EINVAL;
+
+	if (devad == MDIO_MMD_PMAPMD) {
+		/* RO regs, nothing to write */
+		if (regnum == MDIO_CTRL1 || regnum == MDIO_CTRL2)
+			return 0;
+	}
+
+	ret = dp83td510_validate_mmd(phydev, devad, regnum);
+	if (ret < 0)
+		return 0;
+
+	/* This PHY supports only C22 MDIO opcodes. We can use only indirect
+	 * access.
+	 */
+	mmd_phy_indirect(bus, phy_addr, devad, regnum);
+
+	/* Write the data into MMD's selected register */
+	return __mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
+}
+
+static int dp83td510_config_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Clear any pending interrupts */
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
+				    0x0);
+		if (ret)
+			return ret;
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    DP83TD510E_INTERRUPT_REG_1,
+				    DP83TD510E_INT1_LINK_EN);
+		if (ret)
+			return ret;
+
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       DP83TD510E_GEN_CFG,
+				       DP83TD510E_GENCFG_INT_POLARITY |
+				       DP83TD510E_GENCFG_INT_EN |
+				       DP83TD510E_GENCFG_INT_OE);
+	} else {
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    DP83TD510E_INTERRUPT_REG_1, 0x0);
+		if (ret)
+			return ret;
+
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+					 DP83TD510E_GEN_CFG,
+					 DP83TD510E_GENCFG_INT_EN);
+		if (ret)
+			return ret;
+
+		/* Clear any pending interrupts */
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS,
+				    0x0);
+	}
+
+	return ret;
+}
+
+static irqreturn_t dp83td510_handle_interrupt(struct phy_device *phydev)
+{
+	int  ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_PHY_STS);
+	if (ret < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	} else if (!(ret & DP83TD510E_STS_MII_INT)) {
+		return IRQ_NONE;
+	}
+
+	/* Read the current enabled interrupts */
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, DP83TD510E_INTERRUPT_REG_1);
+	if (ret < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	} else if (!(ret & DP83TD510E_INT1_LINK_EN) ||
+		   !(ret & DP83TD510E_INT1_LINK)) {
+		return IRQ_NONE;
+	}
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static int dp83td510_get_features(struct phy_device *phydev)
+{
+	/* This PHY can't respond on MDIO bus if no RMII clock is enabled.
+	 * In case RMII mode is used (most meaningful mode for this PHY) and
+	 * the PHY do not have own XTAL, and CLK providing MAC is not probed,
+	 * we won't be able to read all needed ability registers.
+	 * So provide it manually.
+	 */
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			 phydev->supported);
+
+	return 0;
+}
+
+static struct phy_driver dp83td510_driver[] = {
+{
+	PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
+	.name		= "TI DP83TD510E",
+
+	.config_aneg	= genphy_c45_config_aneg,
+	.read_status	= genphy_c45_read_status,
+	.get_features	= dp83td510_get_features,
+	.config_intr	= dp83td510_config_intr,
+	.handle_interrupt = dp83td510_handle_interrupt,
+
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
+	.read_mmd	= dp83td510_read_mmd,
+	.write_mmd	= dp83td510_write_mmd,
+} };
+module_phy_driver(dp83td510_driver);
+
+static struct mdio_device_id __maybe_unused dp83td510_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(mdio, dp83td510_tbl);
+
+MODULE_DESCRIPTION("Texas Instruments DP83TD510E PHY driver");
+MODULE_AUTHOR("Oleksij Rempel <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

