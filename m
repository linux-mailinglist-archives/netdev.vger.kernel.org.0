Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47B1294DE4
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441984AbgJUNsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 09:48:13 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:1572 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439418AbgJUNsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 09:48:12 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09LDiUTg007895;
        Wed, 21 Oct 2020 09:48:01 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 347tf6e4w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 09:48:01 -0400
Received: from ASHBMBX9.ad.analog.com (ashbmbx9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 09LDm0F2017714
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 21 Oct 2020 09:48:00 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 21 Oct 2020 09:47:59 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 21 Oct 2020 09:47:59 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Wed, 21 Oct 2020 09:47:59 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 09LDls8H007237;
        Wed, 21 Oct 2020 09:47:54 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alexaundru.ardelean@analog.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <ardeleanalex@gmail.com>, <kuba@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/2] net: phy: adin: clear the diag clock and set LINKING_EN during autoneg
Date:   Wed, 21 Oct 2020 16:51:39 +0300
Message-ID: <20201021135140.51300-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_06:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LINKING_EN bit is always cleared during reset. Initially it was set
during the downshift setup, because it's in the same register as the
downshift retry count (PHY_CTRL1).

This change moves the handling of LINKING_EN from the downshift handler to
the autonegotiation handler. Also, during autonegotiation setup, the
diagnostics clock is cleared.

This is being done as a prequel to the cable-diagnostics patch. When the
cable diagnostics finishes, the PHY state machine goes back into the PHY_UP
state and the autonegotiation is restarted (or better said, the
autonegotiation handler is called).
During this call, the diagnostics clock should be disabled, and the
LINKING_EN bit set in the PHY_CTRL1 register.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
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

