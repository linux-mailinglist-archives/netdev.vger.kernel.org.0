Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008DA51B803
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbiEEGhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244544AbiEEGhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD22FE53
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047R-E3; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-000SRv-Hx; Thu, 05 May 2022 08:33:20 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F6j-UG; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 7/7] net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY
Date:   Thu,  5 May 2022 08:33:18 +0200
Message-Id: <20220505063318.296280-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505063318.296280-1-o.rempel@pengutronix.de>
References: <20220505063318.296280-1-o.rempel@pengutronix.de>
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
 drivers/net/phy/Kconfig     |   6 ++
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/dp83td510.c | 210 ++++++++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+)
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
index 000000000000..5c3251602e4a
--- /dev/null
+++ b/drivers/net/phy/dp83td510.c
@@ -0,0 +1,210 @@
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
+#define DP83TD510E_LINK_STATUS			BIT(0)
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
+#define DP83TD510E_AN_STAT_1			0x60c
+#define DP83TD510E_MASTER_SLAVE_RESOL_FAIL	BIT(15)
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
+static int dp83td510_read_status(struct phy_device *phydev)
+{
+	u16 phy_sts;
+	int ret, cfg;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+	linkmode_zero(phydev->lp_advertising);
+
+	phy_sts = phy_read(phydev, DP83TD510E_PHY_STS);
+
+	phydev->link = !!(phy_sts & DP83TD510E_LINK_STATUS);
+	if (phydev->link) {
+		/* This PHY supports only one link mode: 10BaseT1L_Full */
+		phydev->duplex = DUPLEX_FULL;
+		phydev->speed = SPEED_10;
+
+		if (phydev->autoneg == AUTONEG_ENABLE) {
+			ret = genphy_c45_read_lpa(phydev);
+			if (ret)
+				return ret;
+
+			phy_resolve_aneg_linkmode(phydev);
+		}
+	}
+
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		ret = genphy_c45_baset1_read_status(phydev);
+		if (ret < 0)
+			return ret;
+
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
+				   DP83TD510E_AN_STAT_1);
+		if (ret < 0)
+			return ret;
+
+		if (ret & DP83TD510E_MASTER_SLAVE_RESOL_FAIL)
+			phydev->master_slave_state = MASTER_SLAVE_STATE_ERR;
+	} else {
+		return genphy_c45_pma_baset1_read_master_slave(phydev);
+	}
+
+	return 0;
+}
+
+static int dp83td510_config_aneg(struct phy_device *phydev)
+{
+	bool changed = false;
+	int ctl = 0;
+	int ret;
+
+	ret = genphy_c45_pma_base1_setup_master_slave(phydev);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return genphy_c45_an_disable_aneg(phydev);
+
+	ret = genphy_c45_an_config_aneg(phydev);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = true;
+
+	return genphy_c45_check_and_restart_aneg(phydev, changed);
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
+	.config_aneg	= dp83td510_config_aneg,
+	.read_status	= dp83td510_read_status,
+	.get_features	= dp83td510_get_features,
+	.config_intr	= dp83td510_config_intr,
+	.handle_interrupt = dp83td510_handle_interrupt,
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
+MODULE_AUTHOR("Oleksij Rempel <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

