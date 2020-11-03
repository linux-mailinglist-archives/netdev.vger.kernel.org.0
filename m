Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC56E2A3DDC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgKCHlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:41:37 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:23950 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbgKCHlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:41:36 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A37egbb010265;
        Tue, 3 Nov 2020 02:41:23 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 34h1s51chm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 02:41:23 -0500
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 0A37fMm0039465
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 3 Nov 2020 02:41:22 -0500
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Tue, 3 Nov 2020
 02:41:21 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Tue, 3 Nov 2020 02:41:21 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 0A37fExR015488;
        Tue, 3 Nov 2020 02:41:14 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alexaundru.ardelean@analog.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <ardeleanalex@gmail.com>, <kuba@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH net-next v2 1/2][RESEND] net: phy: adin: disable diag clock & disable standby mode in config_aneg
Date:   Tue, 3 Nov 2020 09:44:35 +0200
Message-ID: <20201103074436.93790-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_05:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the PHY powers up, the diagnostics clock isn't enabled (bit 2 in
register PHY_CTRL_1 (0x0012)).
Also, the PHY is not in standby mode, so bit 13 in PHY_CTRL_3 (0x0017) is
always set at power up.

The standby mode and the diagnostics clock are both meant to be for the
cable diagnostics feature of the PHY (in phylib this would be equivalent to
the cable-test support), and for the frame-generator feature of the PHY.

In standby mode, the PHY doesn't negotiate links or manage links.

To use the cable diagnostics/test (or frame-generator), the PHY must be
first set in standby mode, so that the link operation doesn't interfere.
Then, the diagnostics clock must be enabled.

For the cable-test feature, when the operation finishes, the PHY goes into
PHY_UP state, and the config_aneg hook is called.

For the ADIN PHY, we need to make sure that during autonegotiation
configuration/setup the PHY is removed from standby mode and the
diagnostics clock is disabled, so that normal operation is resumed.

This change does that by moving the set of the ADIN1300_LINKING_EN bit (2)
in the config_aneg (to disable standby mode).
Previously, this was set in the downshift setup, because the downshift
retry value and the ADIN1300_LINKING_EN are in the same register.

And the ADIN1300_DIAG_CLK_EN bit (13) is cleared, to disable the
diagnostics clock.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

This is a re-send of:
 https://lore.kernel.org/netdev/20201022074551.11520-1-alexandru.ardelean@analog.com/

Added 'Reviewed-by: Andrew Lunn <andrew@lunn.ch>' to both patches.

 drivers/net/phy/adin.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5bc3926c52f0..619d36685b5d 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -23,6 +23,7 @@
 #define ADIN1300_PHY_CTRL1			0x0012
 #define   ADIN1300_AUTO_MDI_EN			BIT(10)
 #define   ADIN1300_MAN_MDIX_EN			BIT(9)
+#define   ADIN1300_DIAG_CLK_EN			BIT(2)
 
 #define ADIN1300_RX_ERR_CNT			0x0014
 
@@ -326,10 +327,9 @@ static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
 		return -E2BIG;
 
 	val = FIELD_PREP(ADIN1300_DOWNSPEED_RETRIES_MSK, cnt);
-	val |= ADIN1300_LINKING_EN;
 
 	rc = phy_modify(phydev, ADIN1300_PHY_CTRL3,
-			ADIN1300_LINKING_EN | ADIN1300_DOWNSPEED_RETRIES_MSK,
+			ADIN1300_DOWNSPEED_RETRIES_MSK,
 			val);
 	if (rc < 0)
 		return rc;
@@ -560,6 +560,14 @@ static int adin_config_aneg(struct phy_device *phydev)
 {
 	int ret;
 
+	ret = phy_clear_bits(phydev, ADIN1300_PHY_CTRL1, ADIN1300_DIAG_CLK_EN);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_set_bits(phydev, ADIN1300_PHY_CTRL3, ADIN1300_LINKING_EN);
+	if (ret < 0)
+		return ret;
+
 	ret = adin_config_mdix(phydev);
 	if (ret)
 		return ret;
-- 
2.17.1

