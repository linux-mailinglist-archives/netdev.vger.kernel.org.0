Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560E2692F23
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 08:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBKHlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 02:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBKHlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 02:41:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D26D8FC
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 23:41:32 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVc-0003zW-Rr; Sat, 11 Feb 2023 08:41:20 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVX-004ALa-2A; Sat, 11 Feb 2023 08:41:16 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQkVX-00BfsU-1d; Sat, 11 Feb 2023 08:41:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v8 2/9] net: phy: add genphy_c45_read_eee_abilities() function
Date:   Sat, 11 Feb 2023 08:41:06 +0100
Message-Id: <20230211074113.2782508-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230211074113.2782508-1-o.rempel@pengutronix.de>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic function for EEE abilities defined by IEEE 802.3
specification. For now following registers are supported:
- IEEE 802.3-2018 45.2.3.10 EEE control and capability 1 (Register 3.20)
- IEEE 802.3cg-2019 45.2.1.186b 10BASE-T1L PMA status register
  (Register 1.2295)

Since I was not able to find any flag signaling support of these
registers, we should detect link mode abilities first and then based on
these abilities doing EEE link modes detection.

Results of EEE ability detection will be stored into new variable
phydev->supported_eee.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy-c45.c    | 70 ++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 16 +++++++++
 include/linux/mdio.h         | 26 ++++++++++++++
 include/linux/phy.h          |  6 ++++
 4 files changed, 118 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 9f9565a4819d..2d10d22e7684 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -661,6 +661,76 @@ int genphy_c45_read_mdix(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
 
+/**
+ * genphy_c45_read_eee_cap1 - read supported EEE link modes from register 3.20
+ * @phydev: target phy_device struct
+ */
+static int genphy_c45_read_eee_cap1(struct phy_device *phydev)
+{
+	int val;
+
+	/* IEEE 802.3-2018 45.2.3.10 EEE control and capability 1
+	 * (Register 3.20)
+	 */
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
+	if (val < 0)
+		return val;
+
+	/* The 802.3 2018 standard says the top 2 bits are reserved and should
+	 * read as 0. Also, it seems unlikely anybody will build a PHY which
+	 * supports 100GBASE-R deep sleep all the way down to 100BASE-TX EEE.
+	 * If MDIO_PCS_EEE_ABLE is 0xffff assume EEE is not supported.
+	 */
+	if (val == 0xffff)
+		return 0;
+
+	mii_eee_cap1_mod_linkmode_t(phydev->supported_eee, val);
+
+	/* Some buggy devices indicate EEE link modes in MDIO_PCS_EEE_ABLE
+	 * which they don't support as indicated by BMSR, ESTATUS etc.
+	 */
+	linkmode_and(phydev->supported_eee, phydev->supported_eee,
+		     phydev->supported);
+
+	return 0;
+}
+
+/**
+ * genphy_c45_read_eee_abilities - read supported EEE link modes
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_read_eee_abilities(struct phy_device *phydev)
+{
+	int val;
+
+	/* There is not indicator whether optional register
+	 * "EEE control and capability 1" (3.20) is supported. Read it only
+	 * on devices with appropriate linkmodes.
+	 */
+	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+		val = genphy_c45_read_eee_cap1(phydev);
+		if (val)
+			return val;
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			      phydev->supported)) {
+		/* IEEE 802.3cg-2019 45.2.1.186b 10BASE-T1L PMA status register
+		 * (Register 1.2295)
+		 */
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10T1L_STAT);
+		if (val < 0)
+			return val;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+				 phydev->supported_eee,
+				 val & MDIO_PMA_10T1L_STAT_EEE);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
+
 /**
  * genphy_c45_pma_read_abilities - read supported link modes from PMA
  * @phydev: target phy_device struct
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a3917c7acbd3..66a4e62009bb 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -132,6 +132,18 @@ static const int phy_10gbit_full_features_array[] = {
 	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
 };
 
+static const int phy_eee_cap1_features_array[] = {
+	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+};
+
+__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_eee_cap1_features) __ro_after_init;
+EXPORT_SYMBOL_GPL(phy_eee_cap1_features);
+
 static void features_init(void)
 {
 	/* 10/100 half/full*/
@@ -213,6 +225,10 @@ static void features_init(void)
 	linkmode_set_bit_array(phy_10gbit_fec_features_array,
 			       ARRAY_SIZE(phy_10gbit_fec_features_array),
 			       phy_10gbit_fec_features);
+	linkmode_set_bit_array(phy_eee_cap1_features_array,
+			       ARRAY_SIZE(phy_eee_cap1_features_array),
+			       phy_eee_cap1_features);
+
 }
 
 void phy_device_free(struct phy_device *phydev)
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index c0da30d63b1d..e75583f5d967 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -402,6 +402,32 @@ static inline u32 linkmode_adv_to_mii_t1_adv_m_t(unsigned long *advertising)
 	return result;
 }
 
+/**
+ * mii_eee_cap1_mod_linkmode_t()
+ * @adv: target the linkmode advertisement settings
+ * @val: register value
+ *
+ * A function that translates value of following registers to the linkmode:
+ * IEEE 802.3-2018 45.2.3.10 "EEE control and capability 1" register (3.20)
+ * IEEE 802.3-2018 45.2.7.13 "EEE advertisement 1" register (7.60)
+ * IEEE 802.3-2018 45.2.7.14 "EEE "link partner ability 1 register (7.61)
+ */
+static inline void mii_eee_cap1_mod_linkmode_t(unsigned long *adv, u32 val)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 adv, val & MDIO_EEE_100TX);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			 adv, val & MDIO_EEE_1000T);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+			 adv, val & MDIO_EEE_10GT);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			 adv, val & MDIO_EEE_1000KX);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			 adv, val & MDIO_EEE_10GKX4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			 adv, val & MDIO_EEE_10GKR);
+}
+
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fbeba4fee8d4..c183a8a27986 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -52,6 +52,7 @@ extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_gbit_all_ports_features) __ro_after_
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_features) __ro_after_init;
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_fec_features) __ro_after_init;
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_full_features) __ro_after_init;
+extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_eee_cap1_features) __ro_after_init;
 
 #define PHY_BASIC_FEATURES ((unsigned long *)&phy_basic_features)
 #define PHY_BASIC_T1_FEATURES ((unsigned long *)&phy_basic_t1_features)
@@ -62,6 +63,7 @@ extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_full_features) __ro_after_ini
 #define PHY_10GBIT_FEATURES ((unsigned long *)&phy_10gbit_features)
 #define PHY_10GBIT_FEC_FEATURES ((unsigned long *)&phy_10gbit_fec_features)
 #define PHY_10GBIT_FULL_FEATURES ((unsigned long *)&phy_10gbit_full_features)
+#define PHY_EEE_CAP1_FEATURES ((unsigned long *)&phy_eee_cap1_features)
 
 extern const int phy_basic_ports_array[3];
 extern const int phy_fibre_port_array[1];
@@ -572,6 +574,7 @@ struct macsec_ops;
  * @supported: Combined MAC/PHY supported linkmodes
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
+ * @supported_eee: supported PHY EEE linkmodes
  * @lp_advertising: Current link partner advertised linkmodes
  * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
@@ -676,6 +679,8 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	/* used with phy_speed_down */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
+	/* used for eee validation */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);
 
 	/* Host supported PHY interface types. Should be ignored if empty. */
 	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
@@ -1737,6 +1742,7 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev);
 int genphy_c45_an_disable_aneg(struct phy_device *phydev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
+int genphy_c45_read_eee_abilities(struct phy_device *phydev);
 int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_baset1_read_status(struct phy_device *phydev);
-- 
2.30.2

