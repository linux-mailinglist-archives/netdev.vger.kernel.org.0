Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDB3C5CD8
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbhGLNBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:01:22 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:60296 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234393AbhGLNBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:01:12 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CCoOtt014799;
        Mon, 12 Jul 2021 08:58:17 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39rj8dgs3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:58:17 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 16CCwGdE024690
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Jul 2021 08:58:16 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:15 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:15 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Mon, 12 Jul 2021 08:58:15 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 16CCvx0F018858;
        Mon, 12 Jul 2021 08:58:12 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Alexandru Tachici" <alexandru.tachici@analog.com>
Subject: [PATCH v2 6/7] net: phy: adin1100: Add SQI support
Date:   Mon, 12 Jul 2021 16:06:30 +0300
Message-ID: <20210712130631.38153-7-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210712130631.38153-1-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: Vtju8RR3uOetRmTPcZhvyhT9I0JiNs-f
X-Proofpoint-ORIG-GUID: Vtju8RR3uOetRmTPcZhvyhT9I0JiNs-f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_07:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120101
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
index ae216a80608b..46598ec4fb2c 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -63,6 +63,8 @@ static const int phy_10_features_array[] = {
 
 #define ADIN_FC_EN				0x8001
 
+#define ADIN_MSE_VAL				0x830B
+
 #define ADIN_CRSM_SFT_RST			0x8810
 #define   ADIN_CRSM_SFT_RST_EN			BIT(0)
 
@@ -81,6 +83,8 @@ static const int phy_10_features_array[] = {
 #define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
 #define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
 
+#define ADIN_SQI_MAX	7
+
 struct adin_hw_stat {
 	const char *string;
 	u16 reg1;
@@ -100,6 +104,22 @@ static const struct adin_hw_stat adin_hw_stats[] = {
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
@@ -436,6 +456,36 @@ static void adin_get_stats(struct phy_device *phydev, struct ethtool_stats *stat
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
@@ -466,6 +516,8 @@ static struct phy_driver adin_driver[] = {
 		.get_sset_count		= adin_get_sset_count,
 		.get_strings		= adin_get_strings,
 		.get_stats		= adin_get_stats,
+		.get_sqi		= adin_get_sqi,
+		.get_sqi_max		= adin_get_sqi_max,
 	},
 };
 
-- 
2.25.1

