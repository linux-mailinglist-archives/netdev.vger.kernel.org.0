Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1CF25C4A9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgICPNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:13:22 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59546 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgICLnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:43:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083Bh11e078905;
        Thu, 3 Sep 2020 06:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599133381;
        bh=klBh5N7iRzXaFIEDB5cpeWg+Qq8oIkn1VHAHtfCNShs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mCy3d/1MZeF942TxAYqBSdKfI8U3S8BlqrCE80m1XeD73TCn6PhaHtpZbH0VWxfn3
         hT89goxvauhSoZxUH0LbPO9ETTVkgzCxL0M/R2Gci1J93qnLdMuBB0lhatzAnrNZh+
         /lhJyB2A51elaiObt2S6oEufIJKK0qgozAWLgEcs=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083Bh15Z047264
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 06:43:01 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 06:43:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 06:43:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083Bh0XS113281;
        Thu, 3 Sep 2020 06:43:00 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 1/3] net: dp83869: Add ability to advertise Fiber connection
Date:   Thu, 3 Sep 2020 06:42:57 -0500
Message-ID: <20200903114259.14013-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903114259.14013-1-dmurphy@ti.com>
References: <20200903114259.14013-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to advertise the Fiber connection if the strap or the
op-mode is configured for 100Base-FX.

Auto negotiation is not supported on this PHY when in fiber mode.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 58103152c601..48a68474f89c 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -52,6 +52,11 @@
 					 BMCR_FULLDPLX | \
 					 BMCR_SPEED1000)
 
+#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
+					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
+					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
+					ADVERTISED_100baseT_Full)
+
 /* This is the same bit mask as the BMCR so re-use the BMCR default */
 #define DP83869_FX_CTRL_DEFAULT	MII_DP83869_BMCR_DEFAULT
 
@@ -300,6 +305,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 {
 	int phy_ctrl_val;
 	int ret;
+	int bmcr;
 
 	if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
 	    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
@@ -383,7 +389,37 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 
 		break;
 	case DP83869_RGMII_1000_BASE:
+		break;
 	case DP83869_RGMII_100_BASE:
+		/* Only allow advertising what this PHY supports */
+		linkmode_and(phydev->advertising, phydev->advertising,
+			     phydev->supported);
+
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->supported);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+				 phydev->advertising);
+
+		/* Auto neg is not supported in fiber mode */
+		bmcr = phy_read(phydev, MII_BMCR);
+		if (bmcr < 0)
+			return bmcr;
+
+		phydev->autoneg = AUTONEG_DISABLE;
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				   phydev->supported);
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				   phydev->advertising);
+
+		if (bmcr & BMCR_ANENABLE) {
+			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+			if (ret < 0)
+				return ret;
+		}
+
+		phy_modify_changed(phydev, MII_ADVERTISE,
+				   MII_DP83869_FIBER_ADVERTISE,
+				   MII_DP83869_FIBER_ADVERTISE);
 		break;
 	default:
 		return -EINVAL;
-- 
2.28.0

