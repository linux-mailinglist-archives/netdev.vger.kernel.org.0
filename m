Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020543FB45A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhH3LIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:08:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43221 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236411AbhH3LIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 07:08:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630321675; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=mLBGoT0kwpZ18GWDEam89tIw+l9583+L6W4JSOu0PzQ=; b=SJGsBgSrlFfxJTM10hjY57EdCxToi17TGcCIRpLIdanG/Ko2cNIRNqGpNJWpz7SevyEP3r9Q
 af4B7vN7+z4RfLvj0pugRHjxHAAHqKOpW4J5m1LkWy46h4+3g+GJLLjXyYq/XbMzLvEYkPyu
 V+3Bjhm9GFA/FwC76KgzLaf/VIU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 612cbc09825e13c54ad25b19 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 30 Aug 2021 11:07:53
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 350A5C43616; Mon, 30 Aug 2021 11:07:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2585C4360C;
        Mon, 30 Aug 2021 11:07:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E2585C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v1 2/3] net: phy: add qca8081 ethernet phy driver
Date:   Mon, 30 Aug 2021 19:07:32 +0800
Message-Id: <20210830110733.8964-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830110733.8964-1-luoj@codeaurora.org>
References: <20210830110733.8964-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8081 is a single port ethernet phy chip that supports
10/100/1000/2500 Mbps mode.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 389 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 338 insertions(+), 51 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index ecae26f11aa4..2b3563ae152f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -33,10 +33,10 @@
 #define AT803X_SFC_DISABLE_JABBER		BIT(0)
 
 #define AT803X_SPECIFIC_STATUS			0x11
-#define AT803X_SS_SPEED_MASK			(3 << 14)
-#define AT803X_SS_SPEED_1000			(2 << 14)
-#define AT803X_SS_SPEED_100			(1 << 14)
-#define AT803X_SS_SPEED_10			(0 << 14)
+#define AT803X_SS_SPEED_MASK			GENMASK(15, 14)
+#define AT803X_SS_SPEED_1000			2
+#define AT803X_SS_SPEED_100			1
+#define AT803X_SS_SPEED_10			0
 #define AT803X_SS_DUPLEX			BIT(13)
 #define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
 #define AT803X_SS_MDIX				BIT(6)
@@ -158,6 +158,8 @@
 #define QCA8337_PHY_ID				0x004dd036
 #define QCA8K_PHY_ID_MASK			0xffffffff
 
+#define QCA8081_PHY_ID				0x004dd101
+
 #define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
 
 #define AT803X_PAGE_FIBER			0
@@ -167,7 +169,73 @@
 #define AT803X_KEEP_PLL_ENABLED			BIT(0)
 #define AT803X_DISABLE_SMARTEEE			BIT(1)
 
-MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
+/* MII special status */
+#define QCA808X_SS_SPEED_MASK			GENMASK(9, 7)
+#define QCA808X_SS_SPEED_2500			4
+
+/* Conifg seed */
+#define QCA808X_PHY_DEBUG_LOCAL_SEED		9
+#define QCA808X_MASTER_SLAVE_SEED_ENABLE	BIT(1)
+#define QCA808X_MASTER_SLAVE_SEED_CFG		GENMASK(12, 2)
+#define QCA808X_MASTER_SLAVE_SEED_RANGE		0x32
+
+/* ADC threshold */
+#define QCA808X_PHY_DEBUG_ADC_THRESHOLD		0x2c80
+#define QCA808X_ADC_THRESHOLD_MASK		GENMASK(7, 0)
+#define QCA808X_ADC_THRESHOLD_80MV		0
+#define QCA808X_ADC_THRESHOLD_100MV		0xf0
+#define QCA808X_ADC_THRESHOLD_200MV		0x0f
+#define QCA808X_ADC_THRESHOLD_300MV		0xff
+
+/* CLD control */
+#define QCA808X_PHY_MMD3_ADDR_CLD_CTRL7		0x8007
+#define QCA808X_8023AZ_AFE_CTRL_MASK		GENMASK(8, 4)
+#define QCA808X_8023AZ_AFE_EN			0x90
+
+/* AZ control */
+#define QCA808X_PHY_MMD3_AZ_TRAINING_CTRL	0x8008
+#define QCA808X_MMD3_AZ_TRAINING_VAL		0x1c32
+
+/* AN 2.5G */
+#define QCA808X_FAST_RETRAIN_2500BT		BIT(5)
+#define QCA808X_ADV_LOOP_TIMING			BIT(0)
+
+/* Fast retrain related registers */
+#define QCA808X_PHY_MMD1_FAST_RETRAIN_CTL	0x93
+#define QCA808X_FAST_RETRAIN_CTRL_VALUE		0x1
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_20DB	0x8014
+#define QCA808X_MSE_THRESHOLD_20DB_VALUE	0x529
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_17DB	0x800E
+#define QCA808X_MSE_THRESHOLD_17DB_VALUE	0x341
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_27DB	0x801E
+#define QCA808X_MSE_THRESHOLD_27DB_VALUE	0x419
+
+#define QCA808X_PHY_MMD1_MSE_THRESHOLD_28DB	0x8020
+#define QCA808X_MSE_THRESHOLD_28DB_VALUE	0x341
+
+#define QCA808X_PHY_MMD7_TOP_OPTION1		0x901c
+#define QCA808X_TOP_OPTION1_DATA		0x0
+
+#define QCA808X_PHY_MMD7_EEE_LP_ADVERTISEMENT	0x40
+#define QCA808X_EEE_ADV_THP			0x8
+
+#define QCA808X_PHY_MMD3_DEBUG_1		0xa100
+#define QCA808X_MMD3_DEBUG_1_VALUE		0x9203
+#define QCA808X_PHY_MMD3_DEBUG_2		0xa101
+#define QCA808X_MMD3_DEBUG_2_VALUE		0x48ad
+#define QCA808X_PHY_MMD3_DEBUG_3		0xa103
+#define QCA808X_MMD3_DEBUG_3_VALUE		0x1698
+#define QCA808X_PHY_MMD3_DEBUG_4		0xa105
+#define QCA808X_MMD3_DEBUG_4_VALUE		0x8001
+#define QCA808X_PHY_MMD3_DEBUG_5		0xa106
+#define QCA808X_MMD3_DEBUG_5_VALUE		0x1111
+#define QCA808X_PHY_MMD3_DEBUG_6		0xa011
+#define QCA808X_MMD3_DEBUG_6_VALUE		0x5f85
+
+MODULE_DESCRIPTION("Qualcomm Atheros AR803x and QCA808X PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
@@ -711,11 +779,18 @@ static void at803x_remove(struct phy_device *phydev)
 
 static int at803x_get_features(struct phy_device *phydev)
 {
-	int err;
+	int val;
 
-	err = genphy_read_abilities(phydev);
-	if (err)
-		return err;
+	val = genphy_read_abilities(phydev);
+	if (val)
+		return val;
+
+	if (at803x_match_phy_id(phydev, QCA8081_PHY_ID)) {
+		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
+				val & MDIO_PMA_NG_EXTABLE_2_5GBT);
+	}
 
 	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
 		return 0;
@@ -935,44 +1010,44 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 	}
 }
 
-static int at803x_read_status(struct phy_device *phydev)
+static int at803x_read_specific_status(struct phy_device *phydev)
 {
-	int ss, err, old_link = phydev->link;
-
-	/* Update the link, but return if there was an error */
-	err = genphy_update_link(phydev);
-	if (err)
-		return err;
-
-	/* why bother the PHY if nothing can have changed */
-	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
-		return 0;
+	int val;
 
-	phydev->speed = SPEED_UNKNOWN;
-	phydev->duplex = DUPLEX_UNKNOWN;
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
+	val = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
+	if (val < 0)
+		return val;
 
-	err = genphy_read_lpa(phydev);
-	if (err < 0)
-		return err;
+	switch (FIELD_GET(AT803X_SFC_MDI_CROSSOVER_MODE_M, val)) {
+	case AT803X_SFC_MANUAL_MDI:
+		phydev->mdix_ctrl = ETH_TP_MDI;
+		break;
+	case AT803X_SFC_MANUAL_MDIX:
+		phydev->mdix_ctrl = ETH_TP_MDI_X;
+		break;
+	case AT803X_SFC_AUTOMATIC_CROSSOVER:
+		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+		break;
+	}
 
 	/* Read the AT8035 PHY-Specific Status register, which indicates the
 	 * speed and duplex that the PHY is actually using, irrespective of
 	 * whether we are in autoneg mode or not.
 	 */
-	ss = phy_read(phydev, AT803X_SPECIFIC_STATUS);
-	if (ss < 0)
-		return ss;
+	val = phy_read(phydev, AT803X_SPECIFIC_STATUS);
+	if (val < 0)
+		return val;
 
-	if (ss & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
-		int sfc;
+	if (val & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
+		int speed;
 
-		sfc = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
-		if (sfc < 0)
-			return sfc;
+		/* qca8081 phy takes the different bits for speed value from at803x phy */
+		if (at803x_match_phy_id(phydev, QCA8081_PHY_ID))
+			speed = FIELD_GET(QCA808X_SS_SPEED_MASK, val);
+		else
+			speed = FIELD_GET(AT803X_SS_SPEED_MASK, val);
 
-		switch (ss & AT803X_SS_SPEED_MASK) {
+		switch (speed) {
 		case AT803X_SS_SPEED_10:
 			phydev->speed = SPEED_10;
 			break;
@@ -982,30 +1057,51 @@ static int at803x_read_status(struct phy_device *phydev)
 		case AT803X_SS_SPEED_1000:
 			phydev->speed = SPEED_1000;
 			break;
+		case QCA808X_SS_SPEED_2500:
+			phydev->speed = SPEED_2500;
+			break;
 		}
-		if (ss & AT803X_SS_DUPLEX)
+
+		if (val & AT803X_SS_DUPLEX)
 			phydev->duplex = DUPLEX_FULL;
 		else
 			phydev->duplex = DUPLEX_HALF;
 
-		if (ss & AT803X_SS_MDIX)
+		if (val & AT803X_SS_MDIX)
 			phydev->mdix = ETH_TP_MDI_X;
 		else
 			phydev->mdix = ETH_TP_MDI;
-
-		switch (FIELD_GET(AT803X_SFC_MDI_CROSSOVER_MODE_M, sfc)) {
-		case AT803X_SFC_MANUAL_MDI:
-			phydev->mdix_ctrl = ETH_TP_MDI;
-			break;
-		case AT803X_SFC_MANUAL_MDIX:
-			phydev->mdix_ctrl = ETH_TP_MDI_X;
-			break;
-		case AT803X_SFC_AUTOMATIC_CROSSOVER:
-			phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
-			break;
-		}
 	}
 
+	return 0;
+}
+
+static int at803x_read_status(struct phy_device *phydev)
+{
+	int err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	err = at803x_read_specific_status(phydev);
+	if (err < 0)
+		return err;
+
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
 		phy_resolve_aneg_pause(phydev);
 
@@ -1053,7 +1149,24 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
-	return genphy_config_aneg(phydev);
+	ret = 0;
+	if (at803x_match_phy_id(phydev, QCA8081_PHY_ID)) {
+		int phy_ctrl = 0;
+
+		/* The reg MII_BMCR also needs to be configured for force mode. */
+		if (phydev->autoneg == AUTONEG_DISABLE)
+			genphy_c45_pma_setup_forced(phydev);
+
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->advertising))
+			phy_ctrl = MDIO_AN_10GBT_CTRL_ADV2_5G;
+
+		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
+				MDIO_AN_10GBT_CTRL_ADV2_5G, phy_ctrl);
+		if (ret < 0)
+			return ret;
+	}
+
+	return __genphy_config_aneg(phydev, ret);
 }
 
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
@@ -1325,6 +1438,161 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca808x_phy_fast_retrain_cfg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
+			MDIO_AN_10GBT_CTRL_ADV2_5G |
+			QCA808X_FAST_RETRAIN_2500BT |
+			QCA808X_ADV_LOOP_TIMING);
+	if (ret)
+		return ret;
+
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_FAST_RETRAIN_CTL,
+			QCA808X_FAST_RETRAIN_CTRL_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_20DB,
+			QCA808X_MSE_THRESHOLD_20DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_17DB,
+			QCA808X_MSE_THRESHOLD_17DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_27DB,
+			QCA808X_MSE_THRESHOLD_27DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_MSE_THRESHOLD_28DB,
+			QCA808X_MSE_THRESHOLD_28DB_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_AN, QCA808X_PHY_MMD7_EEE_LP_ADVERTISEMENT,
+			QCA808X_EEE_ADV_THP);
+	phy_write_mmd(phydev, MDIO_MMD_AN, QCA808X_PHY_MMD7_TOP_OPTION1,
+			QCA808X_TOP_OPTION1_DATA);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_1,
+			QCA808X_MMD3_DEBUG_1_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_4,
+			QCA808X_MMD3_DEBUG_4_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_5,
+			QCA808X_MMD3_DEBUG_5_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_3,
+			QCA808X_MMD3_DEBUG_3_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_6,
+			QCA808X_MMD3_DEBUG_6_VALUE);
+	phy_write_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_DEBUG_2,
+			QCA808X_MMD3_DEBUG_2_VALUE);
+
+	return 0;
+}
+
+static int qca808x_phy_ms_random_seed_set(struct phy_device *phydev)
+{
+	u16 seed_value = (prandom_u32() % QCA808X_MASTER_SLAVE_SEED_RANGE) << 2;
+
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
+			QCA808X_MASTER_SLAVE_SEED_CFG, seed_value);
+}
+
+static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
+{
+	u16 seed_enable = 0;
+
+	if (enable)
+		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
+
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
+			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
+}
+
+static int qca808x_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Active adc&vga on 802.3az for the link 1000M and 100M */
+	ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, QCA808X_PHY_MMD3_ADDR_CLD_CTRL7,
+			QCA808X_8023AZ_AFE_CTRL_MASK, QCA808X_8023AZ_AFE_EN);
+	if (ret)
+		return ret;
+
+	/* Adjust the threshold on 802.3az for the link 1000M */
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+			QCA808X_PHY_MMD3_AZ_TRAINING_CTRL, QCA808X_MMD3_AZ_TRAINING_VAL);
+	if (ret)
+		return ret;
+
+	/* Config the fast retrain for the link 2500M */
+	ret = qca808x_phy_fast_retrain_cfg(phydev);
+	if (ret)
+		return ret;
+
+	/* Configure ramdom seed to make phy linked as slave mode for link 2500M */
+	ret = qca808x_phy_ms_random_seed_set(phydev);
+	if (ret)
+		return ret;
+
+	/* Enable seed */
+	ret = qca808x_phy_ms_seed_enable(phydev, true);
+	if (ret)
+		return ret;
+
+	/* Configure adc threshold as 100mv for the link 10M */
+	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_ADC_THRESHOLD,
+			QCA808X_ADC_THRESHOLD_MASK, QCA808X_ADC_THRESHOLD_100MV);
+}
+
+static int qca808x_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_STAT);
+	if (ret < 0)
+		return ret;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->lp_advertising,
+			ret & MDIO_AN_10GBT_STAT_LP2_5G);
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	ret = at803x_read_specific_status(phydev);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->link && phydev->speed == SPEED_2500)
+		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+	else
+		phydev->interface = PHY_INTERFACE_MODE_SMII;
+
+	return 0;
+}
+
+static int qca808x_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_soft_reset(phydev);
+	if (ret < 0)
+		return ret;
+
+	return qca808x_phy_ms_seed_enable(phydev, true);
+}
+
+static void qca808x_link_change_notify(struct phy_device *phydev)
+{
+	int ret;
+
+	/* generate random seed as a lower value to make PHY linked as SLAVE easily,
+	 * excpet for master/slave configuration fault detected.
+	 */
+	if (phydev->state == PHY_NOLINK) {
+		ret = phy_read(phydev, MII_STAT1000);
+		if (ret < 0)
+			return;
+
+		if (ret & LPA_1000MSFAIL) {
+			qca808x_phy_ms_seed_enable(phydev, false);
+		} else {
+			qca808x_phy_ms_random_seed_set(phydev);
+			qca808x_phy_ms_seed_enable(phydev, true);
+		}
+	}
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1434,6 +1702,24 @@ static struct phy_driver at803x_driver[] = {
 	.get_sset_count = at803x_get_sset_count,
 	.get_strings = at803x_get_strings,
 	.get_stats = at803x_get_stats,
+}, {
+	/* Qualcomm QCA8081 */
+	PHY_ID_MATCH_EXACT(QCA8081_PHY_ID),
+	.name			= "QCA8081 PHY",
+	.get_features		= at803x_get_features,
+	.config_aneg		= at803x_config_aneg,
+	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
+	.get_tunable		= at803x_get_tunable,
+	.set_tunable		= at803x_set_tunable,
+	.set_wol		= at803x_set_wol,
+	.get_wol		= at803x_get_wol,
+	.config_init		= qca808x_config_init,
+	.read_status		= qca808x_read_status,
+	.soft_reset		= qca808x_soft_reset,
+	.link_change_notify	= qca808x_link_change_notify,
+	.suspend		= genphy_suspend,
+	.resume			= genphy_resume,
 }, };
 
 module_phy_driver(at803x_driver);
@@ -1444,6 +1730,7 @@ static struct mdio_device_id __maybe_unused atheros_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
+	{ PHY_ID_MATCH_EXACT(QCA8081_PHY_ID) },
 	{ }
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

