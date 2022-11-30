Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0B63D26A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiK3JtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiK3JtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:49:06 -0500
Received: from out28-146.mail.aliyun.com (out28-146.mail.aliyun.com [115.124.28.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE3924BEB;
        Wed, 30 Nov 2022 01:49:01 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436713|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00962744-0.224256-0.766116;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.QKTZsXY_1669801718;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QKTZsXY_1669801718)
          by smtp.aliyun-inc.com;
          Wed, 30 Nov 2022 17:48:58 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     yinghong.zhang@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: [PATCH net-next] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
Date:   Wed, 30 Nov 2022 17:49:28 +0800
Message-Id: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a driver for the motorcomm yt8531 gigabit ethernet phy. We have verified
the patch on AM335x platform which has one YT8531 interface
card and passed all test cases.
The tested cases indluding: YT8531 UTP function with support of 10M/100M/1000M
and wol(based on magic packet).

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/Kconfig     |   2 +-
 drivers/net/phy/motorcomm.c | 162 ++++++++++++++++++++++++++++++++++--
 2 files changed, 158 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index af00cf44cd97..4291fdfbb600 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -260,7 +260,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
+	  Currently supports the YT8511, YT8521, YT8531, YT8531S Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 685190db72de..e38d7a0b7beb 100644
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
@@ -12,8 +12,9 @@
 #include <linux/phy.h>
 
 #define PHY_ID_YT8511		0x0000010a
-#define PHY_ID_YT8521		0x0000011A
-#define PHY_ID_YT8531S		0x4F51E91A
+#define PHY_ID_YT8521		0x0000011a
+#define PHY_ID_YT8531		0x4f51e91b
+#define PHY_ID_YT8531S		0x4f51e91a
 
 /* YT8521/YT8531S Register Overview
  *	UTP Register space	|	FIBER Register space
@@ -225,6 +226,9 @@
 #define YT8531S_SYNCE_CFG_REG			0xA012
 #define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
 
+#define YT8531_SYNCE_CFG_REG			0xA012
+#define YT8531_SCR_SYNCE_ENABLE			BIT(6)
+
 /* Extended Register  end */
 
 struct yt8521_priv {
@@ -479,6 +483,77 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+/**
+ * yt8531_set_wol() - turn wake-on-lan on or off
+ * @phydev: a pointer to a &struct phy_device
+ * @wol: a pointer to a &struct ethtool_wolinfo
+ *
+ * NOTE: YTPHY_WOL_CONFIG_REG, YTPHY_WOL_MACADDR2_REG, YTPHY_WOL_MACADDR1_REG
+ * and YTPHY_WOL_MACADDR0_REG are common ext reg.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8531_set_wol(struct phy_device *phydev,
+			  struct ethtool_wolinfo *wol)
+{
+	struct net_device *p_attached_dev;
+	const u16 mac_addr_reg[] = {
+		YTPHY_WOL_MACADDR2_REG,
+		YTPHY_WOL_MACADDR1_REG,
+		YTPHY_WOL_MACADDR0_REG,
+	};
+	const u8 *mac_addr;
+	u16 mask;
+	u16 val;
+	int ret;
+	u8 i;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		p_attached_dev = phydev->attached_dev;
+		if (!p_attached_dev)
+			return -ENODEV;
+
+		mac_addr = (const u8 *)p_attached_dev->dev_addr;
+		if (!is_valid_ether_addr(mac_addr))
+			return -EINVAL;
+
+		/* Store the device address for the magic packet */
+		for (i = 0; i < 3; i++) {
+			ret = ytphy_write_ext(phydev, mac_addr_reg[i],
+					      ((mac_addr[i * 2] << 8)) |
+						      (mac_addr[i * 2 + 1]));
+			if (ret < 0)
+				return ret;
+		}
+
+		/* Enable WOL feature */
+		mask = YTPHY_WCR_PULSE_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
+		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PULSE_WIDTH_672MS;
+		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, val);
+		if (ret < 0)
+			return ret;
+
+		/* Enable WOL interrupt */
+		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0,
+				   YTPHY_IER_WOL);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* Disable WOL feature */
+		mask = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, 0);
+
+		/* Disable WOL interrupt */
+		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG,
+				   YTPHY_IER_WOL, 0);
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
@@ -651,6 +726,19 @@ static int yt8521_probe(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * yt8531_probe() - Now only disable SyncE clock output
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8531_probe(struct phy_device *phydev)
+{
+	/* Disable SyncE clock output by default */
+	return ytphy_modify_ext_with_lock(phydev, YT8531_SYNCE_CFG_REG,
+					 YT8531_SCR_SYNCE_ENABLE, 0);
+}
+
 /**
  * yt8531s_probe() - read chip config then set suitable polling_mode
  * @phydev: a pointer to a &struct phy_device
@@ -1192,6 +1280,59 @@ static int yt8521_config_init(struct phy_device *phydev)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+/**
+ * yt8531_config_init() - called to initialize the PHY
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8531_config_init(struct phy_device *phydev)
+{
+	int ret;
+	u16 val;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
+		val |= YT8521_RC1R_RX_DELAY_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_FE_TX_DELAY_DIS;
+		val |= YT8521_RC1R_RX_DELAY_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
+		val |= YT8521_RC1R_RX_DELAY_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_FE_TX_DELAY_EN;
+		val |= YT8521_RC1R_RX_DELAY_EN;
+		break;
+	default: /* do not support other modes */
+		return -EOPNOTSUPP;
+	}
+
+	/* set rgmii delay mode */
+	ret = ytphy_modify_ext_with_lock(phydev, YT8521_RGMII_CONFIG1_REG,
+					 (YT8521_RC1R_RX_DELAY_MASK |
+					 YT8521_RC1R_FE_TX_DELAY_MASK |
+					 YT8521_RC1R_GE_TX_DELAY_MASK),
+					 val);
+	if (ret < 0)
+		return ret;
+
+	/* disable auto sleep */
+	ret = ytphy_modify_ext_with_lock(phydev,
+					 YT8521_EXTREG_SLEEP_CONTROL1_REG,
+					 YT8521_ESC1R_SLEEP_SW, 0);
+	if (ret < 0)
+		return ret;
+
+	/* enable RXC clock when no wire plug */
+	return ytphy_modify_ext_with_lock(phydev, YT8521_CLOCK_GATING_REG,
+					  YT8521_CGR_RX_CLK_EN, 0);
+}
+
 /**
  * yt8521_prepare_fiber_features() -  A small helper function that setup
  * fiber's features.
@@ -1774,6 +1915,16 @@ static struct phy_driver motorcomm_phy_drvs[] = {
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
+	},
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
 		.name		= "YT8531S Gigabit Ethernet",
@@ -1795,7 +1946,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm 8511/8521/8531S PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521/8531/8531S PHY driver");
 MODULE_AUTHOR("Peter Geis");
 MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
@@ -1803,8 +1954,9 @@ MODULE_LICENSE("GPL");
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
-	{ /* sentinal */ }
+	{ /* sentinel */ }
 };
 
 MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
-- 
2.34.1

