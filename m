Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9EE42912A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbhJKOP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:15:59 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:36592 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244049AbhJKONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:35 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B75Pmw027354;
        Mon, 11 Oct 2021 10:11:17 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm8qfuv80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:17 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 19BEBG5H034961
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:16 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 10:11:15 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 11 Oct 2021 10:11:14 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 11 Oct 2021 10:11:14 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxn9020418;
        Mon, 11 Oct 2021 10:11:11 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v3 5/8] net: phy: adin1100: Add ethtool master-slave support
Date:   Mon, 11 Oct 2021 17:22:12 +0300
Message-ID: <20211011142215.9013-6-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211011142215.9013-1-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: 5Wez0DW3GdqGVWJu3r9P0kYD0nGCduCK
X-Proofpoint-GUID: 5Wez0DW3GdqGVWJu3r9P0kYD0nGCduCK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Allow user to select the advertised master-slave
configuration through ethtool.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 74 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index dc5c1987dc43..86e2a6bdcebf 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -30,6 +30,10 @@ static const int phy_10_features_array[] = {
 #define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
 #define   ADIN_CRSM_SYS_RDY			BIT(0)
 
+#define ADIN_AN_PHY_INST_STATUS			0x8030
+#define   ADIN_IS_CFG_SLV			BIT(2)
+#define   ADIN_IS_CFG_MST			BIT(3)
+
 /**
  * struct adin_priv - ADIN PHY driver private data
  * tx_level_2v4_able		set if the PHY supports 2.4V TX levels (10BASE-T1L)
@@ -88,6 +92,7 @@ static int adin_read_lpa(struct phy_device *phydev)
 static int adin_read_status(struct phy_device *phydev)
 {
 	int ret;
+	int cfg;
 
 	ret = genphy_c45_read_link(phydev);
 	if (ret)
@@ -97,6 +102,8 @@ static int adin_read_status(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
 
 	if (phydev->autoneg == AUTONEG_ENABLE) {
 		ret = adin_read_lpa(phydev);
@@ -111,7 +118,37 @@ static int adin_read_status(struct phy_device *phydev)
 		phydev->duplex = DUPLEX_FULL;
 	}
 
-	return ret;
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
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_PHY_INST_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & ADIN_IS_CFG_SLV)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+
+	if (ret & ADIN_IS_CFG_MST)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+
+	return 0;
 }
 
 static int adin_config_aneg(struct phy_device *phydev)
@@ -125,6 +162,41 @@ static int adin_config_aneg(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_DISABLE)
 		return 0;
 
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
+				       MDIO_AN_T1_ADV_L_FORCE_MS);
+		if (ret < 0)
+			return ret;
+		break;
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
+					 MDIO_AN_T1_ADV_L_FORCE_MS);
+		break;
+	default:
+		break;
+	}
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M, MDIO_AN_T1_ADV_M_MST);
+		if (ret < 0)
+			return ret;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M,
+					 MDIO_AN_T1_ADV_M_MST);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
+	}
+
 	/* Request increased transmit level from LP. */
 	if (priv->tx_level_prop_present && priv->tx_level_2v4) {
 		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
-- 
2.25.1

