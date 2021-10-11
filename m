Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47386429126
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbhJKOP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:15:56 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:36268 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244055AbhJKONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:35 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BDhHCs015355;
        Mon, 11 Oct 2021 10:11:18 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm7b1c0kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:18 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 19BEBHP0034964
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:17 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Mon, 11 Oct 2021
 10:11:16 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Mon, 11 Oct 2021 10:11:16 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxnA020418;
        Mon, 11 Oct 2021 10:11:12 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: [PATCH v3 6/8] net: phy: adin1100: Add SQI support
Date:   Mon, 11 Oct 2021 17:22:13 +0300
Message-ID: <20211011142215.9013-7-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211011142215.9013-1-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: QgzO0TyI8upj_0e6OkMM5UGXjLntQzHE
X-Proofpoint-ORIG-GUID: QgzO0TyI8upj_0e6OkMM5UGXjLntQzHE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=979 impostorscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
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
index 86e2a6bdcebf..504c12b51362 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -34,6 +34,26 @@ static const int phy_10_features_array[] = {
 #define   ADIN_IS_CFG_SLV			BIT(2)
 #define   ADIN_IS_CFG_MST			BIT(3)
 
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
  * tx_level_2v4_able		set if the PHY supports 2.4V TX levels (10BASE-T1L)
@@ -310,6 +330,36 @@ static int adin_get_features(struct phy_device *phydev)
 	return 0;
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
@@ -336,6 +386,8 @@ static struct phy_driver adin_driver[] = {
 		.set_loopback		= adin_set_loopback,
 		.suspend		= adin_suspend,
 		.resume			= adin_resume,
+		.get_sqi		= adin_get_sqi,
+		.get_sqi_max		= adin_get_sqi_max,
 	},
 };
 
-- 
2.25.1

