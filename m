Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DEB680604
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 07:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbjA3GgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 01:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbjA3GgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 01:36:09 -0500
Received: from out29-153.mail.aliyun.com (out29-153.mail.aliyun.com [115.124.29.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FB826846;
        Sun, 29 Jan 2023 22:36:03 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436331|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00946298-0.254234-0.736303;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.R4fCYQh_1675060557;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R4fCYQh_1675060557)
          by smtp.aliyun-inc.com;
          Mon, 30 Jan 2023 14:35:58 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v3 5/5] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
Date:   Mon, 30 Jan 2023 14:35:39 +0800
Message-Id: <20230130063539.3700-6-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add a driver for the motorcomm yt8531 gigabit ethernet phy. We have
 verified the driver on AM335x platform with yt8531 board. On the
 board, yt8531 gigabit ethernet phy works in utp mode, RGMII
 interface, supports 1000M/100M/10M speeds, and wol(magic package).

Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/Kconfig     |   2 +-
 drivers/net/phy/motorcomm.c | 208 +++++++++++++++++++++++++++++++++++-
 2 files changed, 207 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f5df2edc94a5..54874555c921 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -257,7 +257,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
+	  Currently supports YT85xx Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index ee9cd72758d6..81a251815fb0 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Motorcomm 8511/8521/8531S PHY driver.
+ * Motorcomm 8511/8521/8531/8531S PHY driver.
  *
  * Author: Peter Geis <pgwipeout@gmail.com>
  * Author: Frank <Frank.Sae@motor-comm.com>
@@ -14,6 +14,7 @@
 
 #define PHY_ID_YT8511		0x0000010a
 #define PHY_ID_YT8521		0x0000011A
+#define PHY_ID_YT8531		0x4f51e91b
 #define PHY_ID_YT8531S		0x4F51E91A
 
 /* YT8521/YT8531S Register Overview
@@ -517,6 +518,61 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+static int yt8531_set_wol(struct phy_device *phydev,
+			  struct ethtool_wolinfo *wol)
+{
+	const u16 mac_addr_reg[] = {
+		YTPHY_WOL_MACADDR2_REG,
+		YTPHY_WOL_MACADDR1_REG,
+		YTPHY_WOL_MACADDR0_REG,
+	};
+	const u8 *mac_addr;
+	u16 mask, val;
+	int ret;
+	u8 i;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		mac_addr = phydev->attached_dev->dev_addr;
+
+		/* Store the device address for the magic packet */
+		for (i = 0; i < 3; i++) {
+			ret = ytphy_write_ext_with_lock(phydev, mac_addr_reg[i],
+							((mac_addr[i * 2] << 8)) |
+							(mac_addr[i * 2 + 1]));
+			if (ret < 0)
+				return ret;
+		}
+
+		/* Enable WOL feature */
+		mask = YTPHY_WCR_PULSE_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
+		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PULSE_WIDTH_672MS;
+		ret = ytphy_modify_ext_with_lock(phydev, YTPHY_WOL_CONFIG_REG,
+						 mask, val);
+		if (ret < 0)
+			return ret;
+
+		/* Enable WOL interrupt */
+		ret = phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0,
+				 YTPHY_IER_WOL);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* Disable WOL feature */
+		mask = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		ret = ytphy_modify_ext_with_lock(phydev, YTPHY_WOL_CONFIG_REG,
+						 mask, 0);
+
+		/* Disable WOL interrupt */
+		ret = phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG,
+				 YTPHY_IER_WOL, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int yt8511_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, YT8511_PAGE_SELECT);
@@ -767,6 +823,17 @@ static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
 	return ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG, mask, val);
 }
 
+static int ytphy_rgmii_clk_delay_config_with_lock(struct phy_device *phydev)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_rgmii_clk_delay_config(phydev);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+
 /**
  * yt8521_probe() - read chip config then set suitable polling_mode
  * @phydev: a pointer to a &struct phy_device
@@ -891,6 +958,43 @@ static int yt8521_probe(struct phy_device *phydev)
 					  val);
 }
 
+static int yt8531_probe(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	u16 mask, val;
+	u32 freq;
+
+	if (of_property_read_u32(node, "motorcomm,clk-out-frequency-hz", &freq))
+		freq = YTPHY_DTS_OUTPUT_CLK_DIS;
+
+	switch (freq) {
+	case YTPHY_DTS_OUTPUT_CLK_DIS:
+		mask = YT8531_SCR_SYNCE_ENABLE;
+		val = 0;
+		break;
+	case YTPHY_DTS_OUTPUT_CLK_25M:
+		mask = YT8531_SCR_SYNCE_ENABLE | YT8531_SCR_CLK_SRC_MASK |
+		       YT8531_SCR_CLK_FRE_SEL_125M;
+		val = YT8531_SCR_SYNCE_ENABLE |
+		      FIELD_PREP(YT8531_SCR_CLK_SRC_MASK,
+				 YT8531_SCR_CLK_SRC_REF_25M);
+		break;
+	case YTPHY_DTS_OUTPUT_CLK_125M:
+		mask = YT8531_SCR_SYNCE_ENABLE | YT8531_SCR_CLK_SRC_MASK |
+		       YT8531_SCR_CLK_FRE_SEL_125M;
+		val = YT8531_SCR_SYNCE_ENABLE | YT8531_SCR_CLK_FRE_SEL_125M |
+		      FIELD_PREP(YT8531_SCR_CLK_SRC_MASK,
+				 YT8531_SCR_CLK_SRC_PLL_125M);
+		break;
+	default:
+		phydev_warn(phydev, "Freq err:%u\n", freq);
+		return -EINVAL;
+	}
+
+	return ytphy_modify_ext_with_lock(phydev, YTPHY_SYNCE_CFG_REG, mask,
+					  val);
+}
+
 /**
  * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
  * @phydev: a pointer to a &struct phy_device
@@ -1387,6 +1491,94 @@ static int yt8521_config_init(struct phy_device *phydev)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+static int yt8531_config_init(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int ret;
+
+	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
+	if (ret < 0)
+		return ret;
+
+	if (of_property_read_bool(node, "motorcomm,auto-sleep-disabled")) {
+		/* disable auto sleep */
+		ret = ytphy_modify_ext_with_lock(phydev,
+						 YT8521_EXTREG_SLEEP_CONTROL1_REG,
+						 YT8521_ESC1R_SLEEP_SW, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled")) {
+		/* enable RXC clock when no wire plug */
+		ret = ytphy_modify_ext_with_lock(phydev,
+						 YT8521_CLOCK_GATING_REG,
+						 YT8521_CGR_RX_CLK_EN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * yt8531_link_change_notify() - Adjust the tx clock direction according to
+ * the current speed and dts config.
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * NOTE: This function is only used to adapt to VF2 with JH7110 SoC. Please
+ * keep "motorcomm,tx-clk-adj-enabled" not exist in dts when the soc is not
+ * JH7110.
+ */
+static void yt8531_link_change_notify(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	bool tx_clk_adj_enabled = false;
+	bool tx_clk_1000_inverted;
+	bool tx_clk_100_inverted;
+	bool tx_clk_10_inverted;
+	u16 val = 0;
+	int ret;
+
+	if (of_property_read_bool(node, "motorcomm,tx-clk-adj-enabled"))
+		tx_clk_adj_enabled = true;
+
+	if (!tx_clk_adj_enabled)
+		return;
+
+	if (of_property_read_bool(node, "motorcomm,tx-clk-10-inverted"))
+		tx_clk_10_inverted = true;
+	if (of_property_read_bool(node, "motorcomm,tx-clk-100-inverted"))
+		tx_clk_100_inverted = true;
+	if (of_property_read_bool(node, "motorcomm,tx-clk-1000-inverted"))
+		tx_clk_1000_inverted = true;
+
+	if (phydev->speed < 0)
+		return;
+
+	switch (phydev->speed) {
+	case SPEED_1000:
+		if (tx_clk_1000_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	case SPEED_100:
+		if (tx_clk_100_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	case SPEED_10:
+		if (tx_clk_10_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	default:
+		return;
+	}
+
+	ret = ytphy_modify_ext_with_lock(phydev, YT8521_RGMII_CONFIG1_REG,
+					 YT8521_RC1R_TX_CLK_SEL_INVERTED, val);
+	if (ret < 0)
+		phydev_warn(phydev, "Modify TX_CLK_SEL err:%d\n", ret);
+}
+
 /**
  * yt8521_prepare_fiber_features() -  A small helper function that setup
  * fiber's features.
@@ -1969,6 +2161,17 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		.suspend	= yt8521_suspend,
 		.resume		= yt8521_resume,
 	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8531),
+		.name		= "YT8531 Gigabit Ethernet",
+		.probe		= yt8531_probe,
+		.config_init	= yt8531_config_init,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.get_wol	= ytphy_get_wol,
+		.set_wol	= yt8531_set_wol,
+		.link_change_notify = yt8531_link_change_notify,
+	},
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
 		.name		= "YT8531S Gigabit Ethernet",
@@ -1990,7 +2193,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm 8511/8521/8531S PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521/8531/8531S PHY driver");
 MODULE_AUTHOR("Peter Geis");
 MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
@@ -1998,6 +2201,7 @@ MODULE_LICENSE("GPL");
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
 	{ /* sentinal */ }
 };
-- 
2.34.1

