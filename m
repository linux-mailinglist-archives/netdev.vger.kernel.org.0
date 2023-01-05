Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1F65E61D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjAEHao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjAEHaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:30:12 -0500
Received: from out29-126.mail.aliyun.com (out29-126.mail.aliyun.com [115.124.29.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455D14BD59;
        Wed,  4 Jan 2023 23:30:10 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07440397|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00960953-0.221312-0.769078;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.QktmAx9_1672903805;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QktmAx9_1672903805)
          by smtp.aliyun-inc.com;
          Thu, 05 Jan 2023 15:30:06 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v1 3/3] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
Date:   Thu,  5 Jan 2023 15:30:24 +0800
Message-Id: <20230105073024.8390-4-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
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

Add driver for Motorcomm yt8531 gigabit ethernet phy. This patch has
been tested on AM335x platform which has one YT8531 interface
card and passed all test cases.

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/Kconfig     |   2 +-
 drivers/net/phy/motorcomm.c | 127 +++++++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 1327290decab..e25c061e619a 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -257,7 +257,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511, YT8521, YT8531S Gigabit Ethernet PHYs.
+	  Currently supports the YT8511, YT8521, YT8531, YT8531S Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 7ebcca374a67..23d7e48587cf 100644
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
 #define PHY_ID_YT8521		0x0000011a
+#define PHY_ID_YT8531		0x4f51e91b
 #define PHY_ID_YT8531S		0x4f51e91a
 
 /* YT8521/YT8531S Register Overview
@@ -542,6 +543,69 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
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
@@ -1032,6 +1096,11 @@ static int yt8521_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int yt8531_probe(struct phy_device *phydev)
+{
+	return ytphy_probe_helper(phydev);
+}
+
 /**
  * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
  * @phydev: a pointer to a &struct phy_device
@@ -1543,6 +1612,48 @@ static int yt8521_config_init(struct phy_device *phydev)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+static int yt8531_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_config_init_helper(phydev);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+
+static void yt8531_link_change_notify(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u16 val = 0;
+
+	if (!(priv->tx_clk_adj_enabled))
+		return;
+
+	if (phydev->speed < 0)
+		return;
+
+	switch (phydev->speed) {
+	case SPEED_1000:
+		if (priv->tx_clk_1000_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	case SPEED_100:
+		if (priv->tx_clk_100_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	case SPEED_10:
+		if (priv->tx_clk_10_inverted)
+			val = YT8521_RC1R_TX_CLK_SEL_INVERTED;
+		break;
+	default:
+		return;
+	}
+	ytphy_modify_ext_with_lock(phydev, YT8521_RGMII_CONFIG1_REG,
+				   YT8521_RC1R_TX_CLK_SEL_MASK, val);
+}
+
 /**
  * yt8521_prepare_fiber_features() -  A small helper function that setup
  * fiber's features.
@@ -2125,6 +2236,17 @@ static struct phy_driver motorcomm_phy_drvs[] = {
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
@@ -2146,7 +2268,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm 8511/8521/8531S PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521/8531/8531S PHY driver");
 MODULE_AUTHOR("Peter Geis");
 MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
@@ -2154,6 +2276,7 @@ MODULE_LICENSE("GPL");
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531) },
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
 	{ /* sentinel */ }
 };
-- 
2.34.1

