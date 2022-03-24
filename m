Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD624E624B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349784AbiCXLTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349738AbiCXLTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:19:11 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B0A66E6;
        Thu, 24 Mar 2022 04:17:40 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22OAcLV4015854;
        Thu, 24 Mar 2022 07:17:18 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3f0denc07j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 07:17:18 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 22OBHHwo032735
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Mar 2022 07:17:17 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 24 Mar
 2022 07:17:16 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 24 Mar 2022 07:17:16 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 22OBGjPf000657;
        Thu, 24 Mar 2022 07:17:09 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v5 6/7] net: phy: adin1100: Add SQI support
Date:   Thu, 24 Mar 2022 13:26:19 +0200
Message-ID: <20220324112620.46963-7-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220324112620.46963-1-alexandru.tachici@analog.com>
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: JjnSNZ5Q58_1sbugbUd09_-pcfLRAP_e
X-Proofpoint-ORIG-GUID: JjnSNZ5Q58_1sbugbUd09_-pcfLRAP_e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_03,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203240067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Determine the SQI from MSE using a predefined table
for the 10BASE-T1L.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 52 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index 23d1ae61e0ef..9cbe8b92dc6f 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -33,6 +33,26 @@
 #define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
 #define   ADIN_CRSM_SYS_RDY			BIT(0)
 
+#define ADIN_MSE_VAL				0x830B
+
+#define ADIN_SQI_MAX	7
+
+struct adin_mse_sqi_range {
+	u16 start;
+	u16 end;
+};
+
+static const struct adin_mse_sqi_range adin_mse_sqi_map[] = {
+	{ 0x0A74, 0xFFFF },
+	{ 0x084E, 0x0A74 },
+	{ 0x0698, 0x084E },
+	{ 0x053D, 0x0698 },
+	{ 0x0429, 0x053D },
+	{ 0x034E, 0x0429 },
+	{ 0x02A0, 0x034E },
+	{ 0x0000, 0x02A0 },
+};
+
 /**
  * struct adin_priv - ADIN PHY driver private data
  * @tx_level_2v4_able:		set if the PHY supports 2.4V TX levels (10BASE-T1L)
@@ -206,6 +226,36 @@ static int adin_get_features(struct phy_device *phydev)
 	return genphy_c45_pma_read_abilities(phydev);
 }
 
+static int adin_get_sqi(struct phy_device *phydev)
+{
+	u16 mse_val;
+	int sqi;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+	else if (!(ret & MDIO_STAT1_LSTATUS))
+		return 0;
+
+	ret = phy_read_mmd(phydev, MDIO_STAT1, ADIN_MSE_VAL);
+	if (ret < 0)
+		return ret;
+
+	mse_val = 0xFFFF & ret;
+	for (sqi = 0; sqi < ARRAY_SIZE(adin_mse_sqi_map); sqi++) {
+		if (mse_val >= adin_mse_sqi_map[sqi].start && mse_val <= adin_mse_sqi_map[sqi].end)
+			return sqi;
+	}
+
+	return -EINVAL;
+}
+
+static int adin_get_sqi_max(struct phy_device *phydev)
+{
+	return ADIN_SQI_MAX;
+}
+
 static int adin_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -232,6 +282,8 @@ static struct phy_driver adin_driver[] = {
 		.set_loopback		= adin_set_loopback,
 		.suspend		= adin_suspend,
 		.resume			= adin_resume,
+		.get_sqi		= adin_get_sqi,
+		.get_sqi_max		= adin_get_sqi_max,
 	},
 };
 
-- 
2.25.1

