Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C9A1D9950
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgESOSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:18:24 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58230 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbgESOSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:18:22 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JEIIZE072941;
        Tue, 19 May 2020 09:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589897898;
        bh=3+JLyobE6CLV4WmdNv4VMaXp4knXgWi6fteWMgKn13U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ADoH+zyr5MIRS2MXLxf2ZMml+U1sLZaPUz1WZVYa6qpXSaxpca9eZM28NUgXkBVo1
         bVl2nRJpXjY9ibRgL0hRiocT+khDedK4qBW7AMpbqRC9S2QRpY44x5N6b+YISr9moq
         j3SkgbWc2+VsXgwbbJVjpkVnENv7drfp3AZo/c40=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JEIIm4026411;
        Tue, 19 May 2020 09:18:18 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 09:18:18 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 09:18:18 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JEIHQr058715;
        Tue, 19 May 2020 09:18:17 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next 2/4] net: phy: dp83869: Set opmode from straps
Date:   Tue, 19 May 2020 09:18:11 -0500
Message-ID: <20200519141813.28167-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519141813.28167-1-dmurphy@ti.com>
References: <20200519141813.28167-1-dmurphy@ti.com>
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

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 073a0f7754a5..64fa2d911074 100644
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
+	u16 val;
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

