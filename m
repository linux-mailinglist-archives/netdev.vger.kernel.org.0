Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654293B31B6
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhFXOr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:47:56 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61676 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231487AbhFXOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:47:46 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OEfHr1023672;
        Thu, 24 Jun 2021 10:45:10 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 39bk4vj7ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:45:10 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 15OEj9KC038684
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Jun 2021 10:45:09 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:08 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:08 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.858.5 via Frontend
 Transport; Thu, 24 Jun 2021 10:45:08 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 15OEj0IL003029;
        Thu, 24 Jun 2021 10:45:05 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH 2/4] net: phy: adin1100: Add ethtool get_stats support
Date:   Thu, 24 Jun 2021 17:53:51 +0300
Message-ID: <20210624145353.6910-3-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624145353.6910-1-alexandru.tachici@analog.com>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: 56TAv9HCVkpEkHgOrCHKyybYnRcy5xxJ
X-Proofpoint-ORIG-GUID: 56TAv9HCVkpEkHgOrCHKyybYnRcy5xxJ
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

The PHY has multiple error counters and one frame counter.
This change enables the frame checker and allows ethtool
to retrieve the counters values.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 77 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index 8d85a4d00d80..f0674a0e8e8a 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -56,6 +56,8 @@ static const int phy_10_features_array[] = {
 #define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
 #define   ADIN_AN_LP_ADV_B10S_HD		BIT(11)
 
+#define ADIN_FC_EN				0x8001
+
 #define ADIN_CRSM_SFT_RST			0x8810
 #define   ADIN_CRSM_SFT_RST_EN			BIT(0)
 
@@ -70,11 +72,32 @@ static const int phy_10_features_array[] = {
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
 
@@ -354,6 +377,10 @@ static int adin_config_init(struct phy_device *phydev)
 		priv->tx_level_24v = 0;
 	}
 
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, ADIN_FC_EN, 1);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -393,6 +420,53 @@ static int adin_get_features(struct phy_device *phydev)
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
+		strlcpy(&data[i * ETH_GSTRING_LEN], adin_hw_stats[i].string, ETH_GSTRING_LEN);
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
+		return (u64)(~0);
+
+	val = (0xffff & ret);
+
+	if (stat->reg2 != 0) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, stat->reg2);
+		if (ret < 0)
+			return (u64)(~0);
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
@@ -422,6 +496,9 @@ static struct phy_driver adin_driver[] = {
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

