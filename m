Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724DF690436
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjBIJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjBIJvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:51:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB6A241D8
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:51:27 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pQ3aH-0005eX-RR; Thu, 09 Feb 2023 10:51:17 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQ3aF-003i89-Ud; Thu, 09 Feb 2023 10:51:17 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pQ3aF-001WrD-35; Thu, 09 Feb 2023 10:51:15 +0100
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
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v7 5/9] net: phy: add genphy_c45_ethtool_get/set_eee() support
Date:   Thu,  9 Feb 2023 10:51:09 +0100
Message-Id: <20230209095113.364524-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209095113.364524-1-o.rempel@pengutronix.de>
References: <20230209095113.364524-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add replacement for phy_ethtool_get/set_eee() functions.

Current phy_ethtool_get/set_eee() implementation is great and it is
possible to make it even better:
- this functionality is for devices implementing parts of IEEE 802.3
  specification beyond Clause 22. The better place for this code is
  phy-c45.c
- currently it is able to do read/write operations on PHYs with
  different abilities to not existing registers. It is better to
  use stored supported_eee abilities to avoid false read/write
  operations.
- the eee_active detection will provide wrong results on not supported
  link modes. It is better to validate speed/duplex properties against
  supported EEE link modes.
- it is able to support only limited amount of link modes. We have more
  EEE link modes...

By refactoring this code I address most of this point except of the last
one. Adding additional EEE link modes will need more work.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 238 ++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h      |  58 ++++++++++
 include/linux/phy.h       |   7 ++
 include/uapi/linux/mdio.h |   8 ++
 4 files changed, 311 insertions(+)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 2d10d22e7684..b4910c4c21d7 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -661,6 +661,129 @@ int genphy_c45_read_mdix(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
 
+/**
+ * genphy_c45_write_eee_adv - write advertised EEE link modes
+ * @phydev: target phy_device struct
+ * @adv: the linkmode advertisement settings
+ */
+int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
+{
+	int val, changed;
+
+	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+		val = linkmode_to_mii_eee_cap1_t(adv);
+
+		/* In eee_broken_modes are stored MDIO_AN_EEE_ADV specific raw
+		 * register values.
+		 */
+		val &= ~phydev->eee_broken_modes;
+
+		/* IEEE 802.3-2018 45.2.7.13 EEE advertisement 1
+		 * (Register 7.60)
+		 */
+		val = phy_modify_mmd_changed(phydev, MDIO_MMD_AN,
+					     MDIO_AN_EEE_ADV,
+					     MDIO_EEE_100TX | MDIO_EEE_1000T |
+					     MDIO_EEE_10GT | MDIO_EEE_1000KX |
+					     MDIO_EEE_10GKX4 | MDIO_EEE_10GKR,
+					     val);
+		if (val < 0)
+			return val;
+		if (val > 0)
+			changed = 1;
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			      phydev->supported_eee)) {
+		val = linkmode_adv_to_mii_10base_t1_t(adv);
+		/* IEEE 802.3cg-2019 45.2.7.25 10BASE-T1 AN control register
+		 * (Register 7.526)
+		 */
+		val = phy_modify_mmd_changed(phydev, MDIO_MMD_AN,
+					     MDIO_AN_10BT1_AN_CTRL,
+					     MDIO_AN_10BT1_AN_CTRL_ADV_EEE_T1L,
+					     val);
+		if (val < 0)
+			return val;
+		if (val > 0)
+			changed = 1;
+	}
+
+	return changed;
+}
+
+/**
+ * genphy_c45_read_eee_adv - read advertised EEE link modes
+ * @phydev: target phy_device struct
+ * @adv: the linkmode advertisement status
+ */
+static int genphy_c45_read_eee_adv(struct phy_device *phydev,
+				   unsigned long *adv)
+{
+	int val;
+
+	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+		/* IEEE 802.3-2018 45.2.7.13 EEE advertisement 1
+		 * (Register 7.60)
+		 */
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
+		if (val < 0)
+			return val;
+
+		mii_eee_cap1_mod_linkmode_t(adv, val);
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			      phydev->supported_eee)) {
+		/* IEEE 802.3cg-2019 45.2.7.25 10BASE-T1 AN control register
+		 * (Register 7.526)
+		 */
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10BT1_AN_CTRL);
+		if (val < 0)
+			return val;
+
+		mii_10base_t1_adv_mod_linkmode_t(adv, val);
+	}
+
+	return 0;
+}
+
+/**
+ * genphy_c45_read_eee_lpa - read advertised LP EEE link modes
+ * @phydev: target phy_device struct
+ * @lpa: the linkmode LP advertisement status
+ */
+static int genphy_c45_read_eee_lpa(struct phy_device *phydev,
+				   unsigned long *lpa)
+{
+	int val;
+
+	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+		/* IEEE 802.3-2018 45.2.7.14 EEE link partner ability 1
+		 * (Register 7.61)
+		 */
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
+		if (val < 0)
+			return val;
+
+		mii_eee_cap1_mod_linkmode_t(lpa, val);
+	}
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			      phydev->supported_eee)) {
+		/* IEEE 802.3cg-2019 45.2.7.26 10BASE-T1 AN status register
+		 * (Register 7.527)
+		 */
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10BT1_AN_STAT);
+		if (val < 0)
+			return val;
+
+		mii_10base_t1_adv_mod_linkmode_t(lpa, val);
+	}
+
+	return 0;
+}
+
 /**
  * genphy_c45_read_eee_cap1 - read supported EEE link modes from register 3.20
  * @phydev: target phy_device struct
@@ -1194,6 +1317,121 @@ int genphy_c45_plca_get_status(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
 
+/**
+ * genphy_c45_eee_is_active - get EEE status
+ * @phydev: target phy_device struct
+ * @adv: variable to store advertised linkmodes
+ * @lp: variable to store LP advertised linkmodes
+ * @is_enabled: variable to store EEE enabled/disabled configuration value
+ *
+ * Description: this function will read local and link partner PHY
+ * advertisements. Compare them return current EEE state.
+ */
+int genphy_c45_eee_is_active(struct phy_device *phydev, unsigned long *adv,
+			     unsigned long *lp, bool *is_enabled)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(tmp_adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(tmp_lp) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
+	bool eee_enabled, eee_active;
+	int ret;
+
+	ret = genphy_c45_read_eee_adv(phydev, tmp_adv);
+	if (ret)
+		return ret;
+
+	ret = genphy_c45_read_eee_lpa(phydev, tmp_lp);
+	if (ret)
+		return ret;
+
+	eee_enabled = !linkmode_empty(tmp_adv);
+	linkmode_and(common, tmp_adv, tmp_lp);
+	if (eee_enabled && !linkmode_empty(common))
+		eee_active = phy_check_valid(phydev->speed, phydev->duplex,
+					     common);
+	else
+		eee_active = false;
+
+	if (adv)
+		linkmode_copy(adv, tmp_adv);
+	if (lp)
+		linkmode_copy(lp, tmp_lp);
+	if (is_enabled)
+		*is_enabled = eee_enabled;
+
+	return eee_active;
+}
+EXPORT_SYMBOL(genphy_c45_eee_is_active);
+
+/**
+ * genphy_c45_ethtool_get_eee - get EEE supported and status
+ * @phydev: target phy_device struct
+ * @data: ethtool_eee data
+ *
+ * Description: it reports the Supported/Advertisement/LP Advertisement
+ * capabilities.
+ */
+int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
+			       struct ethtool_eee *data)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp) = {};
+	bool overflow = false, is_enabled;
+	int ret;
+
+	ret = genphy_c45_eee_is_active(phydev, adv, lp, &is_enabled);
+	if (ret < 0)
+		return ret;
+
+	data->eee_enabled = is_enabled;
+	data->eee_active = ret;
+
+	if (!ethtool_convert_link_mode_to_legacy_u32(&data->supported,
+						     phydev->supported_eee))
+		overflow = true;
+	if (!ethtool_convert_link_mode_to_legacy_u32(&data->advertised, adv))
+		overflow = true;
+	if (!ethtool_convert_link_mode_to_legacy_u32(&data->lp_advertised, lp))
+		overflow = true;
+
+	if (overflow)
+		phydev_warn(phydev, "Not all supported or advertised EEE link modes were passed to the user space\n");
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
+
+/**
+ * genphy_c45_ethtool_set_eee - get EEE supported and status
+ * @phydev: target phy_device struct
+ * @data: ethtool_eee data
+ *
+ * Description: it reportes the Supported/Advertisement/LP Advertisement
+ * capabilities.
+ */
+int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
+			       struct ethtool_eee *data)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+	int ret;
+
+	if (data->eee_enabled) {
+		if (data->advertised)
+			adv[0] = data->advertised;
+		else
+			linkmode_copy(adv, phydev->supported_eee);
+	}
+
+	ret = genphy_c45_write_eee_adv(phydev, adv);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		return phy_restart_aneg(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c45_ethtool_set_eee);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index e75583f5d967..e3568e44efd0 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -428,6 +428,64 @@ static inline void mii_eee_cap1_mod_linkmode_t(unsigned long *adv, u32 val)
 			 adv, val & MDIO_EEE_10GKR);
 }
 
+/**
+ * mii_eee_cap1_mod_linkmode_t
+ * @adv: the linkmode advertisement settings
+ *
+ * A function that translates linkmode to value for IEEE 802.3-2018 45.2.7.13
+ * "EEE advertisement 1" register (7.60)
+ */
+static inline u32 linkmode_to_mii_eee_cap1_t(unsigned long *adv)
+{
+	u32 result = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, adv))
+		result |= MDIO_EEE_100TX;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, adv))
+		result |= MDIO_EEE_1000T;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT, adv))
+		result |= MDIO_EEE_10GT;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, adv))
+		result |= MDIO_EEE_1000KX;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT, adv))
+		result |= MDIO_EEE_10GKX4;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, adv))
+		result |= MDIO_EEE_10GKR;
+
+	return result;
+}
+
+/**
+ * mii_10base_t1_adv_mod_linkmode_t
+ * @adv: linkmode advertisement settings
+ * @val: register value
+ *
+ * A function that translates IEEE 802.3cg-2019 45.2.7.26 "10BASE-T1 AN status"
+ * register (7.527) value to the linkmode.
+ */
+static inline void mii_10base_t1_adv_mod_linkmode_t(unsigned long *adv, u16 val)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			 adv, val & MDIO_AN_10BT1_AN_CTRL_ADV_EEE_T1L);
+}
+
+/**
+ * linkmode_adv_to_mii_10base_t1_t
+ * @adv: linkmode advertisement settings
+ *
+ * A function that translates the linkmode to IEEE 802.3cg-2019 45.2.7.25
+ * "10BASE-T1 AN control" register (7.526) value.
+ */
+static inline u32 linkmode_adv_to_mii_10base_t1_t(unsigned long *adv)
+{
+	u32 result = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, adv))
+		result |= MDIO_AN_10BT1_AN_CTRL_ADV_EEE_T1L;
+
+	return result;
+}
+
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7a8e541de3f3..727bff531a14 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1758,6 +1758,13 @@ int genphy_c45_plca_set_cfg(struct phy_device *phydev,
 			    const struct phy_plca_cfg *plca_cfg);
 int genphy_c45_plca_get_status(struct phy_device *phydev,
 			       struct phy_plca_status *plca_st);
+int genphy_c45_eee_is_active(struct phy_device *phydev, unsigned long *adv,
+			     unsigned long *lp, bool *is_enabled);
+int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
+			       struct ethtool_eee *data);
+int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
+			       struct ethtool_eee *data);
+int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 75b7257a51e1..256b463e47a6 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -79,6 +79,8 @@
 #define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP Base Page ability register [15:0] */
 #define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP Base Page ability register [31:16] */
 #define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP Base Page ability register [47:32] */
+#define MDIO_AN_10BT1_AN_CTRL	526	/* 10BASE-T1 AN control register */
+#define MDIO_AN_10BT1_AN_STAT	527	/* 10BASE-T1 AN status register */
 #define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
@@ -340,6 +342,12 @@
 #define MDIO_AN_T1_LP_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level LP Transmit Request */
 #define MDIO_AN_T1_LP_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level LP Transmit Ability */
 
+/* 10BASE-T1 AN control register */
+#define MDIO_AN_10BT1_AN_CTRL_ADV_EEE_T1L	0x4000 /* 10BASE-T1L EEE ability advertisement */
+
+/* 10BASE-T1 AN status register */
+#define MDIO_AN_10BT1_AN_STAT_LPA_EEE_T1L	0x4000 /* 10BASE-T1L LP EEE ability advertisement */
+
 /* BASE-T1 PMA/PMD control register */
 #define MDIO_PMA_PMD_BT1_CTRL_CFG_MST	0x4000 /* MASTER-SLAVE config value */
 
-- 
2.30.2

