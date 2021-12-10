Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA546FF1C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbhLJK4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:56:37 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:7154 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239265AbhLJK4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:56:34 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA6cmCm026361;
        Fri, 10 Dec 2021 05:52:39 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3cv1tbrw1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 05:52:39 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 1BAAqckq021154
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Dec 2021 05:52:38 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 10 Dec
 2021 05:52:37 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 10 Dec 2021 05:52:37 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1BAAqLrG008399;
        Fri, 10 Dec 2021 05:52:34 -0500
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v4 6/7] net: phy: adin1100: Add SQI support
Date:   Fri, 10 Dec 2021 13:05:08 +0200
Message-ID: <20211210110509.20970-7-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211210110509.20970-1-alexandru.tachici@analog.com>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: ZjyTG4A1y8uuNhLcA8rXAD32aKjvP1uo
X-Proofpoint-ORIG-GUID: ZjyTG4A1y8uuNhLcA8rXAD32aKjvP1uo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100059
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

