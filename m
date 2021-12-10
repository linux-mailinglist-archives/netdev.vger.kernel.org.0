Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8DF46FF1E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbhLJK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:56:41 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:8728 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239280AbhLJK4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:56:36 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA3NRcr021479;
        Fri, 10 Dec 2021 05:52:35 -0500
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3cucqewvcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 05:52:35 -0500
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 1BAAqYKd051274
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Dec 2021 05:52:34 -0500
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 10 Dec 2021 05:52:33 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Fri, 10 Dec 2021 05:52:32 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 10 Dec 2021 05:52:32 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1BAAqLrE008399;
        Fri, 10 Dec 2021 05:52:30 -0500
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v4 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Date:   Fri, 10 Dec 2021 13:05:06 +0200
Message-ID: <20211210110509.20970-5-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211210110509.20970-1-alexandru.tachici@analog.com>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: EoGhq4GmYbW8NiQmOloXLivYVN8751Te
X-Proofpoint-GUID: EoGhq4GmYbW8NiQmOloXLivYVN8751Te
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=757 impostorscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100059
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

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/phy-c45.c | 283 +++++++++++++++++++++++++++++++++++++-
 include/linux/mdio.h      |  70 ++++++++++
 include/uapi/linux/mdio.h |  10 ++
 3 files changed, 357 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index db709d30bf84..9a96fa55f304 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -80,7 +80,14 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 
 	switch (phydev->speed) {
 	case SPEED_10:
-		ctrl2 |= MDIO_PMA_CTRL2_10BT;
+		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+		if (ret < 0)
+			return ret;
+
+		if (ret & MDIO_PMA_EXTABLE_BT1)
+			ctrl2 |= MDIO_PMA_CTRL2_BASET1;
+		else
+			ctrl2 |= MDIO_PMA_CTRL2_10BT;
 		break;
 	case SPEED_100:
 		ctrl1 |= MDIO_PMA_CTRL1_SPEED100;
@@ -118,10 +125,99 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_PMA_EXTABLE_BT1) {
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
@@ -133,7 +229,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);
  */
 int genphy_c45_an_config_aneg(struct phy_device *phydev)
 {
-	int changed, ret;
+	int changed, ret, val;
 	u32 adv;
 
 	linkmode_and(phydev->advertising, phydev->advertising,
@@ -141,6 +237,13 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev)
 
 	changed = genphy_config_eee_advert(phydev);
 
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PMA_EXTABLE_BT1)
+		return genphy_c45_baset1_an_config_aneg(phydev);
+
 	adv = linkmode_adv_to_mii_adv_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_ADVERTISE,
@@ -178,8 +281,17 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
  */
 int genphy_c45_an_disable_aneg(struct phy_device *phydev)
 {
+	u16 reg = MDIO_CTRL1;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_PMA_EXTABLE_BT1)
+		reg = MDIO_AN_T1_CTRL;
 
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, reg,
 				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
@@ -194,7 +306,17 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
  */
 int genphy_c45_restart_aneg(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
+	u16 reg = MDIO_CTRL1;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_PMA_EXTABLE_BT1)
+		reg = MDIO_AN_T1_CTRL;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, reg,
 				MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
 }
 EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
@@ -210,11 +332,19 @@ EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
  */
 int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 {
+	u16 reg = MDIO_CTRL1;
 	int ret;
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_PMA_EXTABLE_BT1)
+		reg = MDIO_AN_T1_CTRL;
+
 	if (!restart) {
 		/* Configure and restart aneg if it wasn't set before */
-		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		ret = phy_read_mmd(phydev, MDIO_MMD_AN, reg);
 		if (ret < 0)
 			return ret;
 
@@ -242,7 +372,17 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
  */
 int genphy_c45_aneg_done(struct phy_device *phydev)
 {
-	int val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	int reg = MDIO_STAT1;
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PMA_EXTABLE_BT1)
+		reg = MDIO_AN_T1_STAT;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, reg);
 
 	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
 }
@@ -307,6 +447,49 @@ int genphy_c45_read_link(struct phy_device *phydev)
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
@@ -321,6 +504,13 @@ int genphy_c45_read_lpa(struct phy_device *phydev)
 {
 	int val;
 
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PMA_EXTABLE_BT1)
+		return genphy_c45_baset1_read_lpa(phydev);
+
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
 	if (val < 0)
 		return val;
@@ -399,6 +589,21 @@ int genphy_c45_read_pma(struct phy_device *phydev)
 
 	phydev->duplex = DUPLEX_FULL;
 
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PMA_EXTABLE_BT1) {
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
@@ -530,12 +735,67 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
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
@@ -545,6 +805,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_read_abilities);
 int genphy_c45_read_status(struct phy_device *phydev)
 {
 	int ret;
+	int val;
 
 	ret = genphy_c45_read_link(phydev);
 	if (ret)
@@ -560,6 +821,16 @@ int genphy_c45_read_status(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+		if (val < 0)
+			return val;
+
+		if (val & MDIO_PMA_EXTABLE_BT1) {
+			ret = genphy_c45_baset1_read_status(phydev);
+			if (ret < 0)
+				return ret;
+		}
+
 		phy_resolve_aneg_linkmode(phydev);
 	} else {
 		ret = genphy_c45_read_pma(phydev);
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 9f3587a61e14..b621c4ea815b 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -338,6 +338,76 @@ static inline void mii_10gbt_stat_mod_linkmode_lpa_t(unsigned long *advertising,
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

