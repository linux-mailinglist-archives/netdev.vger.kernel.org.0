Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B6640114
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiLBHgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiLBHgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:36:20 -0500
Received: from out28-172.mail.aliyun.com (out28-172.mail.aliyun.com [115.124.28.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B33FA8FFC;
        Thu,  1 Dec 2022 23:36:18 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0110163-0.262401-0.726583;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.QM0A.oG_1669966558;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QM0A.oG_1669966558)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 15:36:05 +0800
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
Subject: [PATCH net-next v2] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
Date:   Fri,  2 Dec 2022 15:36:48 +0800
Message-Id: <20221202073648.3182-1-Frank.Sae@motor-comm.com>
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
Hi Russell, Andrew
 Thanks and based on your comments we added lock accordingly in the v2 patch.
 
v2:
- Fixed yt8531_set_wol's lock issue.
- Added ASSERT_MDIO(phydev) to check mdio lock.

Thanks and BR,
Frank

 drivers/net/phy/Kconfig     |   2 +-
 drivers/net/phy/motorcomm.c | 194 +++++++++++++++++++++++++++++++++++-
 2 files changed, 190 insertions(+), 6 deletions(-)

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
index 685190db72de..5334e734a147 100644
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
@@ -245,6 +249,15 @@ struct yt8521_priv {
 	u8 reg_page;
 };
 
+static bool mdio_is_locked(struct phy_device *phydev)
+{
+	return mutex_is_locked(&phydev->mdio.bus->mdio_lock);
+}
+
+#define ASSERT_MDIO(phydev) \
+	WARN_ONCE(!mdio_is_locked(phydev), \
+		  "MDIO: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
+
 /**
  * ytphy_read_ext() - read a PHY's extended register
  * @phydev: a pointer to a &struct phy_device
@@ -258,6 +271,8 @@ static int ytphy_read_ext(struct phy_device *phydev, u16 regnum)
 {
 	int ret;
 
+	ASSERT_MDIO(phydev);
+
 	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
 	if (ret < 0)
 		return ret;
@@ -297,6 +312,8 @@ static int ytphy_write_ext(struct phy_device *phydev, u16 regnum, u16 val)
 {
 	int ret;
 
+	ASSERT_MDIO(phydev);
+
 	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
 	if (ret < 0)
 		return ret;
@@ -342,6 +359,8 @@ static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
 {
 	int ret;
 
+	ASSERT_MDIO(phydev);
+
 	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
 	if (ret < 0)
 		return ret;
@@ -479,6 +498,76 @@ static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 	return phy_restore_page(phydev, old_page, ret);
 }
 
+/**
+ * yt8531_set_wol() - turn wake-on-lan on or off
+ * @phydev: a pointer to a &struct phy_device
+ * @wol: a pointer to a &struct ethtool_wolinfo
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
@@ -651,6 +740,19 @@ static int yt8521_probe(struct phy_device *phydev)
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
@@ -683,6 +785,8 @@ static int ytphy_utp_read_lpa(struct phy_device *phydev)
 {
 	int lpa, lpagb;
 
+	ASSERT_MDIO(phydev);
+
 	if (phydev->autoneg == AUTONEG_ENABLE) {
 		if (!phydev->autoneg_complete) {
 			mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising,
@@ -744,6 +848,8 @@ static int yt8521_adjust_status(struct phy_device *phydev, int status,
 	int err;
 	int lpa;
 
+	ASSERT_MDIO(phydev);
+
 	if (is_utp)
 		duplex = (status & YTPHY_SSR_DUPLEX) >> YTPHY_SSR_DUPLEX_OFFSET;
 	else
@@ -1192,6 +1298,59 @@ static int yt8521_config_init(struct phy_device *phydev)
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
@@ -1220,6 +1379,8 @@ static int yt8521_fiber_setup_forced(struct phy_device *phydev)
 	u16 val;
 	int ret;
 
+	ASSERT_MDIO(phydev);
+
 	if (phydev->speed == SPEED_1000)
 		val = YTPHY_MCR_FIBER_1000BX;
 	else if (phydev->speed == SPEED_100)
@@ -1259,6 +1420,8 @@ static int ytphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 {
 	int ret;
 
+	ASSERT_MDIO(phydev);
+
 	if (!restart) {
 		/* Advertisement hasn't changed, but maybe aneg was never on to
 		 * begin with?  Or maybe phy was isolated?
@@ -1295,6 +1458,8 @@ static int yt8521_fiber_config_aneg(struct phy_device *phydev)
 	int bmcr;
 	u16 adv;
 
+	ASSERT_MDIO(phydev);
+
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return yt8521_fiber_setup_forced(phydev);
 
@@ -1352,6 +1517,8 @@ static int ytphy_setup_master_slave(struct phy_device *phydev)
 {
 	u16 ctl = 0;
 
+	ASSERT_MDIO(phydev);
+
 	if (!phydev->is_gigabit_capable)
 		return 0;
 
@@ -1397,6 +1564,8 @@ static int ytphy_utp_config_advert(struct phy_device *phydev)
 	int err, bmsr, changed = 0;
 	u32 adv;
 
+	ASSERT_MDIO(phydev);
+
 	/* Only allow advertising what this PHY supports */
 	linkmode_and(phydev->advertising, phydev->advertising,
 		     phydev->supported);
@@ -1454,6 +1623,8 @@ static int ytphy_utp_config_aneg(struct phy_device *phydev, bool changed)
 	int err;
 	u16 ctl;
 
+	ASSERT_MDIO(phydev);
+
 	err = ytphy_setup_master_slave(phydev);
 	if (err < 0)
 		return err;
@@ -1655,6 +1826,8 @@ static int ytphy_utp_read_abilities(struct phy_device *phydev)
 {
 	int val;
 
+	ASSERT_MDIO(phydev);
+
 	linkmode_set_bit_array(phy_basic_ports_array,
 			       ARRAY_SIZE(phy_basic_ports_array),
 			       phydev->supported);
@@ -1774,6 +1947,16 @@ static struct phy_driver motorcomm_phy_drvs[] = {
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
@@ -1795,7 +1978,7 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm 8511/8521/8531S PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521/8531/8531S PHY driver");
 MODULE_AUTHOR("Peter Geis");
 MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
@@ -1803,8 +1986,9 @@ MODULE_LICENSE("GPL");
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

