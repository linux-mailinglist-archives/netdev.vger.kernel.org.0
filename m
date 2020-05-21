Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B75A1DD4CC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgEURrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:53 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57650 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgEURrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:51 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHlk5U052208;
        Thu, 21 May 2020 12:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083266;
        bh=PZ4r5XGl2mSqS4YYQmPElJ3WJ0EBOzNWqHYk+VWDcQA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=TGVpFD9kttTMixvuPA012ci3rfW1R6NKI7ZeeiOIrL/98GGW30DY+vApYEk1YFJBo
         e0qbaiqMrd5Cro7YCBKsZSFfapZLTc/7RaHeDYRB5jb40opVMoOqOMYvV4I/lmNjrP
         Uz2KAwJvdmtRkHJbnrasg8HNmPmQfVyqjRSb90JY=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04LHljne128037
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 12:47:45 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:47:45 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:47:45 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHljFv081147;
        Thu, 21 May 2020 12:47:45 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 2/2] net: phy: dp83869: Set opmode from straps
Date:   Thu, 21 May 2020 12:47:38 -0500
Message-ID: <20200521174738.3151-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174738.3151-1-dmurphy@ti.com>
References: <20200521174738.3151-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the op-mode for the device is not set in the device tree then set
the strapped op-mode and store it for later configuration.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 073a0f7754a5..cfb22a21a2e6 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -65,6 +65,7 @@
 #define DP83869_RGMII_RX_CLK_DELAY_EN		BIT(0)
 
 /* STRAP_STS1 bits */
+#define DP83869_STRAP_OP_MODE_MASK		GENMASK(2, 0)
 #define DP83869_STRAP_STS1_RESERVED		BIT(11)
 #define DP83869_STRAP_MIRROR_ENABLED           BIT(12)
 
@@ -161,6 +162,20 @@ static int dp83869_config_port_mirroring(struct phy_device *phydev)
 					  DP83869_CFG3_PORT_MIRROR_EN);
 }
 
+static int dp83869_set_strapped_mode(struct phy_device *phydev)
+{
+	struct dp83869_private *dp83869 = phydev->priv;
+	int val;
+
+	val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_STRAP_STS1);
+	if (val < 0)
+		return val;
+
+	dp83869->mode = val & DP83869_STRAP_OP_MODE_MASK;
+
+	return 0;
+}
+
 #ifdef CONFIG_OF_MDIO
 static int dp83869_of_init(struct phy_device *phydev)
 {
@@ -185,6 +200,10 @@ static int dp83869_of_init(struct phy_device *phydev)
 		if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
 		    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
 			return -EINVAL;
+	} else {
+		ret = dp83869_set_strapped_mode(phydev);
+		if (ret)
+			return ret;
 	}
 
 	if (of_property_read_bool(of_node, "ti,max-output-impedance"))
@@ -218,7 +237,7 @@ static int dp83869_of_init(struct phy_device *phydev)
 #else
 static int dp83869_of_init(struct phy_device *phydev)
 {
-	return 0;
+	return dp83869_set_strapped_mode(phydev);
 }
 #endif /* CONFIG_OF_MDIO */
 
-- 
2.26.2

