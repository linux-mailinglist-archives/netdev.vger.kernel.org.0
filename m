Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED1B3B31B0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhFXOrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:47:47 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61654 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhFXOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:47:46 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OEfUDB027215;
        Thu, 24 Jun 2021 10:45:11 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39c2y8eax4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:45:11 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 15OEjABv041084
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Jun 2021 10:45:10 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:09 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:09 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Thu, 24 Jun 2021 10:45:09 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 15OEj0IM003029;
        Thu, 24 Jun 2021 10:45:06 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH 3/4] net: phy: adin1100: Add ethtool master-slave support
Date:   Thu, 24 Jun 2021 17:53:52 +0300
Message-ID: <20210624145353.6910-4-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624145353.6910-1-alexandru.tachici@analog.com>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: ivvpe0s_dzTuuzWAlBH0VdZfIT3SfAZh
X-Proofpoint-GUID: ivvpe0s_dzTuuzWAlBH0VdZfIT3SfAZh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106240081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Allow user to select the advertised master-slave
configuration through ethtool.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 78 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index f0674a0e8e8a..a8ddf5a9879a 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -36,7 +36,11 @@ static const int phy_10_features_array[] = {
 
 #define ADIN_AN_STATUS				0x0201
 #define ADIN_AN_ADV_ABILITY_L			0x0202
+#define   ADIN_AN_ADV_FORCE_MS			BIT(12)
+
 #define ADIN_AN_ADV_ABILITY_M			0x0203
+#define   ADIN_AN_ADV_MST			BIT(4)
+
 #define ADIN_AN_ADV_ABILITY_H			0x0204U
 #define   ADIN_AN_ADV_B10L_TX_LVL_HI_ABL	BIT(13)
 #define   ADIN_AN_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
@@ -68,6 +72,10 @@ static const int phy_10_features_array[] = {
 #define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
 #define   ADIN_CRSM_SYS_RDY			BIT(0)
 
+#define AN_PHY_INST_STATUS			0x8030
+#define   ADIN_IS_CFG_SLV			BIT(2)
+#define   ADIN_IS_CFG_MST			BIT(3)
+
 #define ADIN_MAC_IF_LOOPBACK			0x803d
 #define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
 #define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
@@ -203,6 +211,7 @@ static int adin_read_lpa(struct phy_device *phydev)
 static int adin_read_status(struct phy_device *phydev)
 {
 	int ret;
+	int cfg;
 
 	ret = genphy_c45_read_link(phydev);
 	if (ret)
@@ -212,6 +221,8 @@ static int adin_read_status(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
 
 	if (phydev->autoneg == AUTONEG_ENABLE) {
 		ret = adin_read_lpa(phydev);
@@ -226,7 +237,37 @@ static int adin_read_status(struct phy_device *phydev)
 		phydev->duplex = DUPLEX_FULL;
 	}
 
-	return ret;
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_L);
+	if (ret < 0)
+		return ret;
+
+	cfg = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_M);
+	if (cfg < 0)
+		return cfg;
+
+	if (ret & ADIN_AN_ADV_FORCE_MS) {
+		if (cfg & ADIN_AN_ADV_MST)
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+		else
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+	} else {
+		if (cfg & ADIN_AN_ADV_MST)
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+		else
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+	}
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, AN_PHY_INST_STATUS);
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
@@ -240,6 +281,41 @@ static int adin_config_aneg(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_DISABLE)
 		return 0;
 
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_L,
+				       ADIN_AN_ADV_FORCE_MS);
+		if (ret < 0)
+			return ret;
+		break;
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_L,
+					 ADIN_AN_ADV_FORCE_MS);
+		break;
+	default:
+		break;
+	}
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_M, ADIN_AN_ADV_MST);
+		if (ret < 0)
+			return ret;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_M,
+					 ADIN_AN_ADV_MST);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
+	}
+
 	if (priv->tx_level_24v)
 		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN,
 				       ADIN_AN_ADV_ABILITY_H,
-- 
2.25.1

