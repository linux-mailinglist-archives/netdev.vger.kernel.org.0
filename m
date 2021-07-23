Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70063D38E7
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhGWKB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhGWKBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:01:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A51C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 03:42:28 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6sdJ-0002P6-68; Fri, 23 Jul 2021 12:42:21 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6sdH-0006bw-Dy; Fri, 23 Jul 2021 12:42:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support for the DP83TD510 Ethernet PHY
Date:   Fri, 23 Jul 2021 12:42:18 +0200
Message-Id: <20210723104218.25361-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
that supports 10M single pair cable.

This driver provides basic support for this chip:
- link status
- autoneg can be turned off
- master/slave can be configured to be able to work without autoneg

This driver and PHY was tested with ASIX AX88772B USB Ethernet controller.

Co-developed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/Kconfig     |   6 +
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/dp83td510.c | 303 ++++++++++++++++++++++++++++++++++++
 3 files changed, 310 insertions(+)
 create mode 100644 drivers/net/phy/dp83td510.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index c56f703ae998..9bdc88deb5e1 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -326,6 +326,12 @@ config DP83869_PHY
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
index 172bb193ae6a..e4927c59bfdb 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
 obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
 obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
 obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
+obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
new file mode 100644
index 000000000000..860e2b516dda
--- /dev/null
+++ b/drivers/net/phy/dp83td510.c
@@ -0,0 +1,303 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for the Texas Instruments DP83TD510 PHY
+ * Copyright (C) 2020 Texas Instruments Incorporated - https://www.ti.com/
+ * Copyright (c) 2021 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define DP83TD510E_PHY_ID			0x20000181
+
+#define DP83TD510_PHY_STS			0x10
+#define DP83TD510_PHY_STS_LINK_STATUS		BIT(0)
+
+#define DP83TD510_AN_CONTROL			0x200
+#define DP83TD510_AN_ENABLE			BIT(12)
+
+#define DP83TD510_AN_STAT_1			0x60c
+/* Master/Slave resolution failed */
+#define DP83TD510_AN_STAT_1_MS_FAIL		BIT(15)
+
+#define DP83TD510_PMA_PMD_CTRL			0x1834
+#define DP83TD510_PMD_CTRL_MASTER_MODE		BIT(14)
+
+#define DP83TD510_SOR_0				0x420
+#define DP83TD510_SOR_0_GPIO2			BIT(6)
+
+#define DP83TD510_SOR_1				0x467
+#define DP83TD510_SOR_1_GPIO1			BIT(9)
+#define DP83TD510_SOR_1_LED_0			BIT(8)
+#define DP83TD510_SOR_1_LED_2			BIT(7)
+#define DP83TD510_SOR_1_RX_ER			BIT(6)
+#define DP83TD510_SOR_1_RX_CTRL			BIT(5)
+#define DP83TD510_SOR_1_CLK_OUT			BIT(4)
+#define DP83TD510_SOR_1_RX_D0			BIT(3)
+#define DP83TD510_SOR_1_RX_D1			BIT(2)
+#define DP83TD510_SOR_1_RX_D2			BIT(1)
+#define DP83TD510_SOR_1_RX_D3			BIT(0)
+
+enum dp83td510_xmii_mode {
+	DP83TD510_MII = 0,
+	DP83TD510_RMII_MASTER,
+	DP83TD510_RGMII,
+	DP83TD510_RMII_SLAVE,
+};
+
+static const char *dp83td510_get_xmii_mode_str(enum dp83td510_xmii_mode mode)
+{
+	switch (mode) {
+	case DP83TD510_MII:
+		return "MII";
+	case DP83TD510_RMII_MASTER:
+		return "RMII master";
+	case DP83TD510_RGMII:
+		return "RGMII";
+	case DP83TD510_RMII_SLAVE:
+		return "RMII slave";
+	}
+
+	return "<unknown>";
+}
+
+static int dp83td510_get_mmd(struct phy_device *phydev, u16 *reg)
+{
+	switch (*reg) {
+	case 0x1000 ... 0x18f8:
+		/* According to the datasheet:
+		 * Prefixed 0x1 in [15:12] of address to differentiate. Please
+		 * remove 0x1 from [15:12] while using the address.
+		 */
+		*reg &= 0xfff;
+		return 0x1;
+	case 0x3000 ... 0x38e7:
+		/* According to the datasheet:
+		 * Prefixed 0x3 in [15:12] of address to differentiate. Please
+		 * remove 0x3 from [15:12] while using the address.
+		 */
+		*reg &= 0xfff;
+		return 0x3;
+	case 0x0200 ... 0x020f:
+		return 0x7;
+	case 0x0000 ... 0x0130:
+	case 0x0300 ... 0x0e01:
+		return 0x1f;
+	default:
+		phydev_err(phydev, "Unknown register 0x%04x\n", *reg);
+		return -EOPNOTSUPP;
+	}
+}
+
+static int dp83td510_read(struct phy_device *phydev, u16 reg)
+{
+	int mmd;
+
+	mmd = dp83td510_get_mmd(phydev, &reg);
+	if (mmd < 0)
+		return mmd;
+
+	return phy_read_mmd(phydev, mmd, reg);
+}
+
+static int dp83td510_write(struct phy_device *phydev, u16 reg, u16 val)
+{
+	int mmd;
+
+	mmd = dp83td510_get_mmd(phydev, &reg);
+	if (mmd < 0)
+		return mmd;
+
+	return phy_write_mmd(phydev, mmd, reg, val);
+}
+
+static int dp83td510_modify(struct phy_device *phydev, u16 reg, u16 mask,
+			    u16 set)
+{
+	int mmd;
+
+	mmd = dp83td510_get_mmd(phydev, &reg);
+	if (mmd < 0)
+		return mmd;
+
+	return phy_modify_mmd(phydev, mmd, reg, mask, set);
+}
+
+static int dp83td510_modify_changed(struct phy_device *phydev, u16 reg,
+				    u16 mask, u16 set)
+{
+	int mmd;
+
+	mmd = dp83td510_get_mmd(phydev, &reg);
+	if (mmd < 0)
+		return mmd;
+
+	return phy_modify_mmd_changed(phydev, mmd, reg, mask, set);
+}
+
+static int dp83td510_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	ret = dp83td510_read(phydev, DP83TD510_PHY_STS);
+	if (ret < 0)
+		return ret;
+
+	phydev->link = ret & DP83TD510_PHY_STS_LINK_STATUS;
+	if (phydev->link) {
+		phydev->duplex = DUPLEX_FULL;
+		phydev->speed = SPEED_10;
+	} else {
+		phydev->speed = SPEED_UNKNOWN;
+		phydev->duplex = DUPLEX_UNKNOWN;
+	}
+
+	ret = dp83td510_read(phydev, DP83TD510_AN_STAT_1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & DP83TD510_AN_STAT_1_MS_FAIL)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_ERR;
+
+	ret = dp83td510_read(phydev, DP83TD510_PMA_PMD_CTRL);
+	if (ret < 0)
+		return ret;
+
+	if (!phydev->autoneg) {
+		if (ret & DP83TD510_PMD_CTRL_MASTER_MODE)
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+		else
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+	}
+
+	return 0;
+}
+
+static int dp83td510_config_aneg(struct phy_device *phydev)
+{
+	u16 ctrl = 0, pmd_ctrl = 0;
+	int ret;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		if (phydev->autoneg) {
+			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
+			phydev_warn(phydev, "Can't force master mode if autoneg is enabled\n");
+			goto do_aneg;
+		}
+		pmd_ctrl |= DP83TD510_PMD_CTRL_MASTER_MODE;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		if (phydev->autoneg) {
+			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
+			phydev_warn(phydev, "Can't force slave mode if autoneg is enabled\n");
+			goto do_aneg;
+		}
+		break;
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
+		phydev_warn(phydev, "Preferred master/slave modes are not supported\n");
+		goto do_aneg;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		goto do_aneg;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	ret = dp83td510_modify(phydev, DP83TD510_PMA_PMD_CTRL,
+			       DP83TD510_PMD_CTRL_MASTER_MODE, pmd_ctrl);
+	if (ret)
+		return ret;
+
+do_aneg:
+	if (phydev->autoneg)
+		ctrl |= DP83TD510_AN_ENABLE;
+
+	ret = dp83td510_modify_changed(phydev, DP83TD510_AN_CONTROL,
+				       DP83TD510_AN_ENABLE, ctrl);
+	if (ret < 0)
+		return ret;
+
+	/* Reset link if settings are changed */
+	if (ret)
+		ret = dp83td510_write(phydev, MII_BMCR, BMCR_RESET);
+
+	return ret;
+}
+
+static int dp83td510_strap(struct phy_device *phydev)
+{
+	int tx_vpp, pin18, rx_trap, pin30, rx_ctrl;
+	enum dp83td510_xmii_mode xmii_mode;
+	int sor0, sor1;
+	u8 addr;
+
+	sor0 = dp83td510_read(phydev, DP83TD510_SOR_0);
+	if (sor0 < 0)
+		return sor0;
+
+	rx_trap = FIELD_GET(DP83TD510_SOR_0_GPIO2, sor0);
+
+	sor1 = dp83td510_read(phydev, DP83TD510_SOR_1);
+	if (sor1 < 0)
+		return sor0;
+
+	addr = FIELD_GET(DP83TD510_SOR_1_RX_D3, sor1) << 3 |
+		FIELD_GET(DP83TD510_SOR_1_RX_D0, sor1) << 2 |
+		FIELD_GET(DP83TD510_SOR_1_RX_ER, sor1) << 1 |
+		FIELD_GET(DP83TD510_SOR_1_GPIO1, sor1) << 0;
+
+	tx_vpp = FIELD_GET(DP83TD510_SOR_1_LED_2, sor1);
+	xmii_mode = FIELD_GET(DP83TD510_SOR_1_LED_0, sor1) << 1 |
+		FIELD_GET(DP83TD510_SOR_1_RX_D1, sor1) << 0;
+	pin18 = FIELD_GET(DP83TD510_SOR_1_RX_D2, sor1);
+	pin30 = FIELD_GET(DP83TD510_SOR_1_CLK_OUT, sor1);
+	rx_ctrl = FIELD_GET(DP83TD510_SOR_1_RX_CTRL, sor1);
+
+	phydev_info(phydev,
+		    "bootstrap cfg: Pin 18: %s, Pin 30: %s, TX Vpp: %s, RX trap: %s, xMII mode: %s, PHY addr: 0x%x\n",
+		    pin18 ? "RX_DV" : "CRS_DV",
+		    pin30 ? "LED_1" : "CLKOUT",
+		    tx_vpp ? "1.0V p2p" : "2.4V & 1.0V p2p",
+		    rx_trap ? "< 40Ω" : "50Ω",
+		    dp83td510_get_xmii_mode_str(xmii_mode),
+		    addr);
+
+	return 0;
+}
+
+static int dp83td510_probe(struct phy_device *phydev)
+{
+	return dp83td510_strap(phydev);
+}
+
+static struct phy_driver dp83td510_driver[] = {
+{
+	PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
+	.name		= "TI DP83TD510E",
+	.probe          = dp83td510_probe,
+
+	.config_aneg	= dp83td510_config_aneg,
+	.read_status	= dp83td510_read_status,
+
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
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
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com");
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

