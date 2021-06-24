Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0FC3B31B1
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhFXOrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:47:48 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61662 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231475AbhFXOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:47:46 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OEfIqN023842;
        Thu, 24 Jun 2021 10:45:12 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 39bk4vj7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:45:11 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 15OEjA4n038692
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Jun 2021 10:45:10 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Thu, 24 Jun 2021
 10:45:09 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Thu, 24 Jun 2021 10:45:09 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 15OEj0IN003029;
        Thu, 24 Jun 2021 10:45:08 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH 4/4] net: phy: adin1100: Add SQI support
Date:   Thu, 24 Jun 2021 17:53:53 +0300
Message-ID: <20210624145353.6910-5-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624145353.6910-1-alexandru.tachici@analog.com>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: sxHrXKMrQy4VY78RD3OK2F0ghNYLdxIr
X-Proofpoint-ORIG-GUID: sxHrXKMrQy4VY78RD3OK2F0ghNYLdxIr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Determine the SQI from MSE using a predefined table
for the 10BASE-T1L.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 52 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index a8ddf5a9879a..661ccb4a2045 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -62,6 +62,8 @@ static const int phy_10_features_array[] = {
 
 #define ADIN_FC_EN				0x8001
 
+#define ADIN_MSE_VAL				0x830B
+
 #define ADIN_CRSM_SFT_RST			0x8810
 #define   ADIN_CRSM_SFT_RST_EN			BIT(0)
 
@@ -80,6 +82,8 @@ static const int phy_10_features_array[] = {
 #define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
 #define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
 
+#define ADIN_SQI_MAX	7
+
 struct adin_hw_stat {
 	const char *string;
 	u16 reg1;
@@ -99,6 +103,22 @@ static const struct adin_hw_stat adin_hw_stats[] = {
 	{ "false_carrier_events_count",		0x8013 },
 };
 
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
  * tx_level_24v			set if the PHY supports 2.4V TX levels (10BASE-T1L)
@@ -543,6 +563,36 @@ static void adin_get_stats(struct phy_device *phydev, struct ethtool_stats *stat
 		data[i] = adin_get_stat(phydev, i);
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
@@ -575,6 +625,8 @@ static struct phy_driver adin_driver[] = {
 		.get_sset_count		= adin_get_sset_count,
 		.get_strings		= adin_get_strings,
 		.get_stats		= adin_get_stats,
+		.get_sqi		= adin_get_sqi,
+		.get_sqi_max		= adin_get_sqi_max,
 	},
 };
 
-- 
2.25.1

