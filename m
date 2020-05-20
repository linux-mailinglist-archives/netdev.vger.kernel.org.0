Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B971DB2FC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgETMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:18:58 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:43944 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgETMS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:18:57 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KCIqdj060823;
        Wed, 20 May 2020 07:18:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589977132;
        bh=LS36fzbKZ/Gxra5Y004Yo3U0C0ZMBz2aBiM5mswkmoQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=PzyjGIP9FfS0dJZzdll/ToTngU5dCXga59VTyPF3T801TAVQHjShJYvkNvMle/far
         RAisSpP+YZ+rHumWKruJQQS3ztk/7aM7gRv7bD3ePJfNJe3/mDxBSd8mxA8aLA+K6A
         ROAZvOqXzDg+V9jFrNUWn0DpPsyVjEoVu3PtZsWU=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KCIq2r064069
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 07:18:52 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 07:18:51 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 07:18:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KCIpG8046771;
        Wed, 20 May 2020 07:18:51 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 2/4] net: phy: dp83869: Set opmode from straps
Date:   Wed, 20 May 2020 07:18:33 -0500
Message-ID: <20200520121835.31190-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520121835.31190-1-dmurphy@ti.com>
References: <20200520121835.31190-1-dmurphy@ti.com>
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

v2 - Fixed val declaration from u16 to int

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

