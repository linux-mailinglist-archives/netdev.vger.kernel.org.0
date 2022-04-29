Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC687514F5D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378387AbiD2Pak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378406AbiD2Pab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:30:31 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194F5D4C8F;
        Fri, 29 Apr 2022 08:27:12 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDqaTW014899;
        Fri, 29 Apr 2022 11:26:53 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3fprsdk7vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:53 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 23TFQpA5024102
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 Apr 2022 11:26:51 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 29 Apr
 2022 11:26:50 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:26:50 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 23TFQEci028122;
        Fri, 29 Apr 2022 11:26:43 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v7 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Date:   Fri, 29 Apr 2022 18:34:34 +0300
Message-ID: <20220429153437.80087-5-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220429153437.80087-1-alexandru.tachici@analog.com>
References: <20220429153437.80087-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: egN8AMhGIK5lTtO84tihMLxeuCFXjFge
X-Proofpoint-ORIG-GUID: egN8AMhGIK5lTtO84tihMLxeuCFXjFge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290083
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

This patch is needed because the BASE-T1 uses different registers
for status, control and advertisement to those already
employed in the existing phy-c45 functions.

Where required, genphy_c45 functions will now check whether
the device supports BASE-T1 and use the specific registers
instead: 45.2.7.19 BASE-T1 AN control register,
45.2.7.20 BASE-T1 AN status, 45.2.7.21 BASE-T1 AN
advertisement register, 45.2.7.22 BASE-T1 AN LP Base
Page ability register, 45.2.1.185 BASE-T1 PMA/PMD control
register.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/phy-c45.c    | 257 ++++++++++++++++++++++++++++++++++-
 drivers/net/phy/phy_device.c |   1 +
 include/linux/mdio.h         |  70 ++++++++++
 include/linux/phy.h          |   3 +
 include/uapi/linux/mdio.h    |  10 ++
 5 files changed, 336 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index db709d30bf84..eefdd67d5556 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,6 +8,25 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+/**
+ * genphy_c45_baset1_able - checks if the PMA has BASE-T1 extended abilities
+ * @phydev: target phy_device struct
+ */
+static bool genphy_c45_baset1_able(struct phy_device *phydev)
+{
+	int val;
+
+	if (phydev->pma_extable == -ENODATA) {
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+		if (val < 0)
+			return false;
+
+		phydev->pma_extable = val;
+	}
+
+	return !!(phydev->pma_extable & MDIO_PMA_EXTABLE_BT1);
+}
+
 /**
  * genphy_c45_pma_can_sleep - checks if the PMA have sleep support
  * @phydev: target phy_device struct
@@ -80,7 +99,10 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 
 	switch (phydev->speed) {
 	case SPEED_10:
-		ctrl2 |= MDIO_PMA_CTRL2_10BT;
+		if (genphy_c45_baset1_able(phydev))
+			ctrl2 |= MDIO_PMA_CTRL2_BASET1;
+		else
+			ctrl2 |= MDIO_PMA_CTRL2_10BT;
 		break;
 	case SPEED_100:
 		ctrl1 |= MDIO_PMA_CTRL1_SPEED100;
@@ -118,10 +140,95 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	if (genphy_c45_baset1_able(phydev)) {
+		int ctl = 0;
+
+		switch (phydev->master_slave_set) {
+		case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		case MASTER_SLAVE_CFG_MASTER_FORCE:
+			ctl = MDIO_PMA_PMD_BT1_CTRL_CFG_MST;
+			break;
+		case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		case MASTER_SLAVE_CFG_UNKNOWN:
+		case MASTER_SLAVE_CFG_UNSUPPORTED:
+			break;
+		default:
+			phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+			return -EOPNOTSUPP;
+		}
+
+		ret = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL,
+				     MDIO_PMA_PMD_BT1_CTRL_CFG_MST, ctl);
+		if (ret < 0)
+			return ret;
+	}
+
 	return genphy_c45_an_disable_aneg(phydev);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);
 
+/* Sets master/slave preference and supported technologies.
+ * The preference is set in the BIT(4) of BASE-T1 AN
+ * advertisement register 7.515 and whether the status
+ * is forced or not, it is set in the BIT(12) of BASE-T1
+ * AN advertisement register 7.514.
+ * Sets 10BASE-T1L Ability BIT(14) in BASE-T1 autonegotiation
+ * advertisement register [31:16] if supported.
+ */
+static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
+{
+	int changed = 0;
+	u16 adv_l = 0;
+	u16 adv_m = 0;
+	int ret;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		adv_l |= MDIO_AN_T1_ADV_L_FORCE_MS;
+		break;
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		break;
+	default:
+		break;
+	}
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		adv_m |= MDIO_AN_T1_ADV_M_MST;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		break;
+	default:
+		break;
+	}
+
+	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
+
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
+				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
+				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = 1;
+
+	adv_m |= linkmode_adv_to_mii_t1_adv_m_t(phydev->advertising);
+
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M,
+				     MDIO_AN_T1_ADV_M_MST | MDIO_AN_T1_ADV_M_B10L, adv_m);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed = 1;
+
+	return changed;
+}
+
 /**
  * genphy_c45_an_config_aneg - configure advertisement registers
  * @phydev: target phy_device struct
@@ -141,6 +248,9 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev)
 
 	changed = genphy_config_eee_advert(phydev);
 
+	if (genphy_c45_baset1_able(phydev))
+		return genphy_c45_baset1_an_config_aneg(phydev);
+
 	adv = linkmode_adv_to_mii_adv_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_ADVERTISE,
@@ -178,8 +288,12 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
  */
 int genphy_c45_an_disable_aneg(struct phy_device *phydev)
 {
+	u16 reg = MDIO_CTRL1;
 
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	if (genphy_c45_baset1_able(phydev))
+		reg = MDIO_AN_T1_CTRL;
+
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, reg,
 				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
@@ -194,7 +308,12 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
  */
 int genphy_c45_restart_aneg(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	u16 reg = MDIO_CTRL1;
+
+	if (genphy_c45_baset1_able(phydev))
+		reg = MDIO_AN_T1_CTRL;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, reg,
 				MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
@@ -210,11 +329,15 @@ EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
  */
 int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 {
+	u16 reg = MDIO_CTRL1;
 	int ret;
 
+	if (genphy_c45_baset1_able(phydev))
+		reg = MDIO_AN_T1_CTRL;
+
 	if (!restart) {
 		/* Configure and restart aneg if it wasn't set before */
-		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		ret = phy_read_mmd(phydev, MDIO_MMD_AN, reg);
 		if (ret < 0)
 			return ret;
 
@@ -242,7 +365,13 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
  */
 int genphy_c45_aneg_done(struct phy_device *phydev)
 {
-	int val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	int reg = MDIO_STAT1;
+	int val;
+
+	if (genphy_c45_baset1_able(phydev))
+		reg = MDIO_AN_T1_STAT;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, reg);
 
 	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
 }
@@ -307,6 +436,49 @@ int genphy_c45_read_link(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_link);
 
+/* Read the Clause 45 defined BASE-T1 AN (7.513) status register to check
+ * if autoneg is complete. If so read the BASE-T1 Autonegotiation
+ * Advertisement registers filling in the link partner advertisement,
+ * pause and asym_pause members in phydev.
+ */
+static int genphy_c45_baset1_read_lpa(struct phy_device *phydev)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_STAT);
+	if (val < 0)
+		return val;
+
+	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising);
+		mii_t1_adv_l_mod_linkmode_t(phydev->lp_advertising, 0);
+		mii_t1_adv_m_mod_linkmode_t(phydev->lp_advertising, 0);
+
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
+
+		return 0;
+	}
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->lp_advertising, 1);
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_L);
+	if (val < 0)
+		return val;
+
+	mii_t1_adv_l_mod_linkmode_t(phydev->lp_advertising, val);
+	phydev->pause = val & MDIO_AN_T1_ADV_L_PAUSE_CAP ? 1 : 0;
+	phydev->asym_pause = val & MDIO_AN_T1_ADV_L_PAUSE_ASYM ? 1 : 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_M);
+	if (val < 0)
+		return val;
+
+	mii_t1_adv_m_mod_linkmode_t(phydev->lp_advertising, val);
+
+	return 0;
+}
+
 /**
  * genphy_c45_read_lpa - read the link partner advertisement and pause
  * @phydev: target phy_device struct
@@ -321,6 +493,9 @@ int genphy_c45_read_lpa(struct phy_device *phydev)
 {
 	int val;
 
+	if (genphy_c45_baset1_able(phydev))
+		return genphy_c45_baset1_read_lpa(phydev);
+
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
 	if (val < 0)
 		return val;
@@ -399,6 +574,17 @@ int genphy_c45_read_pma(struct phy_device *phydev)
 
 	phydev->duplex = DUPLEX_FULL;
 
+	if (genphy_c45_baset1_able(phydev)) {
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
+		if (val < 0)
+			return val;
+
+		if (MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
+			phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+		else
+			phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_pma);
@@ -530,12 +716,67 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
 					 phydev->supported,
 					 val & MDIO_PMA_NG_EXTABLE_5GBT);
 		}
+
+		if (val & MDIO_PMA_EXTABLE_BT1) {
+			val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1);
+			if (val < 0)
+				return val;
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+					 phydev->supported,
+					 val & MDIO_PMA_PMD_BT1_B10L_ABLE);
+
+			val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_STAT);
+			if (val < 0)
+				return val;
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					 phydev->supported,
+					 val & MDIO_AN_STAT1_ABLE);
+		}
 	}
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_read_abilities);
 
+/* Read master/slave preference from registers.
+ * The preference is read from the BIT(4) of BASE-T1 AN
+ * advertisement register 7.515 and whether the preference
+ * is forced or not, it is read from BASE-T1 AN advertisement
+ * register 7.514.
+ */
+static int genphy_c45_baset1_read_status(struct phy_device *phydev)
+{
+	int ret;
+	int cfg;
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L);
+	if (ret < 0)
+		return ret;
+
+	cfg = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M);
+	if (cfg < 0)
+		return cfg;
+
+	if (ret & MDIO_AN_T1_ADV_L_FORCE_MS) {
+		if (cfg & MDIO_AN_T1_ADV_M_MST)
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+		else
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+	} else {
+		if (cfg & MDIO_AN_T1_ADV_M_MST)
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+		else
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+	}
+
+	return 0;
+}
+
 /**
  * genphy_c45_read_status - read PHY status
  * @phydev: target phy_device struct
@@ -560,6 +801,12 @@ int genphy_c45_read_status(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
+		if (genphy_c45_baset1_able(phydev)) {
+			ret = genphy_c45_baset1_read_status(phydev);
+			if (ret < 0)
+				return ret;
+		}
+
 		phy_resolve_aneg_linkmode(phydev);
 	} else {
 		ret = genphy_c45_read_pma(phydev);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1369daeded14..431a8719c635 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -600,6 +600,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 
 	dev->autoneg = AUTONEG_ENABLE;
 
+	dev->pma_extable = -ENODATA;
 	dev->is_c45 = is_c45;
 	dev->phy_id = phy_id;
 	if (c45_ids)
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ecac96d52e01..00177567cfef 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -340,6 +340,76 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
 			 advertising, lpa & MDIO_AN_10GBT_STAT_LP10G);
 }
 
+/**
+ * mii_t1_adv_l_mod_linkmode_t
+ * @advertising: target the linkmode advertisement settings
+ * @lpa: value of the BASE-T1 Autonegotiation Advertisement [15:0] Register
+ *
+ * A small helper function that translates BASE-T1 Autonegotiation
+ * Advertisement [15:0] Register bits to linkmode advertisement settings.
+ * Other bits in advertising aren't changed.
+ */
+static inline void mii_t1_adv_l_mod_linkmode_t(unsigned long *advertising, u32 lpa)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertising,
+			 lpa & MDIO_AN_T1_ADV_L_PAUSE_CAP);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertising,
+			 lpa & MDIO_AN_T1_ADV_L_PAUSE_ASYM);
+}
+
+/**
+ * mii_t1_adv_m_mod_linkmode_t
+ * @advertising: target the linkmode advertisement settings
+ * @lpa: value of the BASE-T1 Autonegotiation Advertisement [31:16] Register
+ *
+ * A small helper function that translates BASE-T1 Autonegotiation
+ * Advertisement [31:16] Register bits to linkmode advertisement settings.
+ * Other bits in advertising aren't changed.
+ */
+static inline void mii_t1_adv_m_mod_linkmode_t(unsigned long *advertising, u32 lpa)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+			 advertising, lpa & MDIO_AN_T1_ADV_M_B10L);
+}
+
+/**
+ * linkmode_adv_to_mii_t1_adv_l_t
+ * @advertising: the linkmode advertisement settings
+ *
+ * A small helper function that translates linkmode advertisement
+ * settings to phy autonegotiation advertisements for the
+ * BASE-T1 Autonegotiation Advertisement [15:0] Register.
+ */
+static inline u32 linkmode_adv_to_mii_t1_adv_l_t(unsigned long *advertising)
+{
+	u32 result = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertising))
+		result |= MDIO_AN_T1_ADV_L_PAUSE_CAP;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertising))
+		result |= MDIO_AN_T1_ADV_L_PAUSE_ASYM;
+
+	return result;
+}
+
+/**
+ * linkmode_adv_to_mii_t1_adv_m_t
+ * @advertising: the linkmode advertisement settings
+ *
+ * A small helper function that translates linkmode advertisement
+ * settings to phy autonegotiation advertisements for the
+ * BASE-T1 Autonegotiation Advertisement [31:16] Register.
+ */
+static inline u32 linkmode_adv_to_mii_t1_adv_m_t(unsigned long *advertising)
+{
+	u32 result = 0;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, advertising))
+		result |= MDIO_AN_T1_ADV_M_B10L;
+
+	return result;
+}
+
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index b12af9e2f389..2d12054932ba 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -570,6 +570,7 @@ struct macsec_ops;
  * @autoneg_complete: Flag auto negotiation of the link has completed
  * @mdix: Current crossover
  * @mdix_ctrl: User setting of crossover
+ * @pma_extable: Cached value of PMA/PMD Extended Abilities Register
  * @interrupts: Flag interrupts have been enabled
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
@@ -698,6 +699,8 @@ struct phy_device {
 	u8 mdix;
 	u8 mdix_ctrl;
 
+	int pma_extable;
+
 	void (*phy_link_change)(struct phy_device *phydev, bool up);
 	void (*adjust_link)(struct net_device *dev);
 
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index fa3515257f54..75b7257a51e1 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -70,6 +70,7 @@
 #define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
 #define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
 #define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
+#define MDIO_PMA_PMD_BT1	18	/* BASE-T1 PMA/PMD extended ability */
 #define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
 #define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
 #define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
@@ -78,6 +79,7 @@
 #define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP Base Page ability register [15:0] */
 #define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP Base Page ability register [31:16] */
 #define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP Base Page ability register [47:32] */
+#define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -170,6 +172,7 @@
 #define MDIO_PMA_CTRL2_10BT		0x000f	/* 10BASE-T type */
 #define MDIO_PMA_CTRL2_2_5GBT		0x0030  /* 2.5GBaseT type */
 #define MDIO_PMA_CTRL2_5GBT		0x0031  /* 5GBaseT type */
+#define MDIO_PMA_CTRL2_BASET1		0x003D  /* BASE-T1 type */
 #define MDIO_PCS_CTRL2_TYPE		0x0003	/* PCS type selection */
 #define MDIO_PCS_CTRL2_10GBR		0x0000	/* 10GBASE-R type */
 #define MDIO_PCS_CTRL2_10GBX		0x0001	/* 10GBASE-X type */
@@ -223,6 +226,7 @@
 #define MDIO_PMA_EXTABLE_1000BKX	0x0040	/* 1000BASE-KX ability */
 #define MDIO_PMA_EXTABLE_100BTX		0x0080	/* 100BASE-TX ability */
 #define MDIO_PMA_EXTABLE_10BT		0x0100	/* 10BASE-T ability */
+#define MDIO_PMA_EXTABLE_BT1		0x0800	/* BASE-T1 ability */
 #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
 
 /* PHY XGXS lane state register. */
@@ -301,6 +305,9 @@
 #define MDIO_PCS_10T1L_CTRL_LB		0x4000	/* Enable PCS level loopback mode */
 #define MDIO_PCS_10T1L_CTRL_RESET	0x8000	/* PCS reset */
 
+/* BASE-T1 PMA/PMD extended ability register. */
+#define MDIO_PMA_PMD_BT1_B10L_ABLE	0x0004	/* 10BASE-T1L Ability */
+
 /* BASE-T1 auto-negotiation advertisement register [15:0] */
 #define MDIO_AN_T1_ADV_L_PAUSE_CAP	ADVERTISE_PAUSE_CAP
 #define MDIO_AN_T1_ADV_L_PAUSE_ASYM	ADVERTISE_PAUSE_ASYM
@@ -333,6 +340,9 @@
 #define MDIO_AN_T1_LP_H_10L_TX_HI_REQ	0x1000	/* 10BASE-T1L High Level LP Transmit Request */
 #define MDIO_AN_T1_LP_H_10L_TX_HI	0x2000	/* 10BASE-T1L High Level LP Transmit Ability */
 
+/* BASE-T1 PMA/PMD control register */
+#define MDIO_PMA_PMD_BT1_CTRL_CFG_MST	0x4000 /* MASTER-SLAVE config value */
+
 /* EEE Supported/Advertisement/LP Advertisement registers.
  *
  * EEE capability Register (3.20), Advertisement (7.60) and
-- 
2.25.1

