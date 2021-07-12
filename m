Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9233C5CD1
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhGLNBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:01:14 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58350 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234226AbhGLNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:01:10 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CCoN1S014634;
        Mon, 12 Jul 2021 08:58:14 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39rj8dgs3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:58:13 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 16CCwCv9024684
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Jul 2021 08:58:12 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:11 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Mon, 12 Jul 2021 08:58:11 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Mon, 12 Jul 2021 08:58:11 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 16CCvx0D018858;
        Mon, 12 Jul 2021 08:58:08 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Alexandru Tachici" <alexandru.tachici@analog.com>
Subject: [PATCH v2 4/7] net: phy: adin1100: Add ethtool get_stats support
Date:   Mon, 12 Jul 2021 16:06:28 +0300
Message-ID: <20210712130631.38153-5-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210712130631.38153-1-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: Km-8XqO-TPxL7461fmJdAai9msAL6ZP3
X-Proofpoint-ORIG-GUID: Km-8XqO-TPxL7461fmJdAai9msAL6ZP3
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

The PHY has multiple error counters and one frame counter.
This change enables the frame checker and allows ethtool
to retrieve the counters values.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 79 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index 682fc617c51b..94deaf52bbcd 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -57,6 +57,8 @@ static const int phy_10_features_array[] = {
 #define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
 #define   ADIN_AN_LP_ADV_B10S_HD		BIT(11)
 
+#define ADIN_FC_EN				0x8001
+
 #define ADIN_CRSM_SFT_RST			0x8810
 #define   ADIN_CRSM_SFT_RST_EN			BIT(0)
 
@@ -71,11 +73,32 @@ static const int phy_10_features_array[] = {
 #define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
 #define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
 
+struct adin_hw_stat {
+	const char *string;
+	u16 reg1;
+	u16 reg2;
+};
+
+static const struct adin_hw_stat adin_hw_stats[] = {
+	{ "total_frames_error_count",		0x8008 },
+	{ "total_frames_count",			0x8009, 0x800A }, /* hi, lo */
+	{ "length_error_frames_count",		0x800B },
+	{ "alignment_error_frames_count",	0x800C },
+	{ "symbol_error_count",			0x800D },
+	{ "oversized_frames_count",		0x800E },
+	{ "undersized_frames_count",		0x800F },
+	{ "odd_nibble_frames_count",		0x8010 },
+	{ "odd_preamble_packet_count",		0x8011 },
+	{ "false_carrier_events_count",		0x8013 },
+};
+
 /**
  * struct adin_priv - ADIN PHY driver private data
  * tx_level_24v			set if the PHY supports 2.4V TX levels (10BASE-T1L)
+ * stats:			statistic counters for the PHY
  */
 struct adin_priv {
+	u64			stats[ARRAY_SIZE(adin_hw_stats)];
 	unsigned int		tx_level_24v:1;
 };
 
@@ -249,6 +272,11 @@ static int adin_soft_reset(struct phy_device *phydev)
 					 10000, 30000, true);
 }
 
+static int adin_config_init(struct phy_device *phydev)
+{
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, ADIN_FC_EN, 1);
+}
+
 static int adin_get_features(struct phy_device *phydev)
 {
 	struct adin_priv *priv = phydev->priv;
@@ -285,6 +313,53 @@ static int adin_get_features(struct phy_device *phydev)
 	return 0;
 }
 
+static int adin_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(adin_hw_stats);
+}
+
+static void adin_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++)
+		strscpy(&data[i * ETH_GSTRING_LEN], adin_hw_stats[i].string, ETH_GSTRING_LEN);
+}
+
+static u64 adin_get_stat(struct phy_device *phydev, int i)
+{
+	const struct adin_hw_stat *stat = &adin_hw_stats[i];
+	struct adin_priv *priv = phydev->priv;
+	u64 val;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, stat->reg1);
+	if (ret < 0)
+		return U64_MAX;
+
+	val = (0xffff & ret);
+
+	if (stat->reg2 != 0) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, stat->reg2);
+		if (ret < 0)
+			return U64_MAX;
+
+		val = (val << 16) + (0xffff & ret);
+	}
+
+	priv->stats[i] += val;
+
+	return priv->stats[i];
+}
+
+static void adin_get_stats(struct phy_device *phydev, struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++)
+		data[i] = adin_get_stat(phydev, i);
+}
+
 static int adin_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -306,11 +381,15 @@ static struct phy_driver adin_driver[] = {
 		.get_features		= adin_get_features,
 		.soft_reset		= adin_soft_reset,
 		.probe			= adin_probe,
+		.config_init		= adin_config_init,
 		.config_aneg		= adin_config_aneg,
 		.read_status		= adin_read_status,
 		.set_loopback		= adin_set_loopback,
 		.suspend		= adin_suspend,
 		.resume			= adin_resume,
+		.get_sset_count		= adin_get_sset_count,
+		.get_strings		= adin_get_strings,
+		.get_stats		= adin_get_stats,
 	},
 };
 
-- 
2.25.1

