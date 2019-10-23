Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2FDE1E9F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405143AbfJWOul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:50:41 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48402 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404873AbfJWOuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:50:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9NEoaUM090494;
        Wed, 23 Oct 2019 09:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571842236;
        bh=x1qHQIzWckKmDT0+Z5edtZm7FwPcWh80iTf5ybJzuKU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=shZTD08YebKJPfXNfpuvavUiME3smvs0S+d/Y7xuey0NPDFOA6Uios7wLGe1/XqZz
         6+LGXJwXiAyHDzFN2LSDUa4JZpFqma+U68+klMkeEa3MEIpSeVxdWQksdkmFIic6Q/
         LQIG9GJc3A9j74KseS02Y8GBpcIehcKWStohckfQ=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9NEoZjo129477
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Oct 2019 09:50:36 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 23
 Oct 2019 09:50:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 23 Oct 2019 09:50:25 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9NEoYLt130427;
        Wed, 23 Oct 2019 09:50:35 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 1/2] net: phy: dp83867: enable robust auto-mdix
Date:   Wed, 23 Oct 2019 17:48:45 +0300
Message-ID: <20191023144846.1381-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191023144846.1381-1-grygorii.strashko@ti.com>
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link detection timeouts can be observed (or link might not be detected
at all) when dp83867 PHY is configured in manual mode (speed/duplexity).

CFG3[9] Robust Auto-MDIX option allows significantly improve link detection
in case dp83867 is configured in manual mode and reduce link detection
time.
As per DM: "If link partners are configured to operational modes that are
not supported by normal Auto MDI/MDIX mode (like Auto-Neg versus Force
100Base-TX or Force 100Base-TX versus Force 100Base-TX), this Robust Auto
MDI/MDIX mode allows MDI/MDIX resolution and prevents deadlock."

Hence, enable this option by default as there are no known reasons
not to do so.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/dp83867.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 37fceaf9fa10..cf4455bbf888 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -95,6 +95,10 @@
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
 
+/* CFG3 bits */
+#define DP83867_CFG3_INT_OE			BIT(7)
+#define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
+
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
@@ -410,12 +414,13 @@ static int dp83867_config_init(struct phy_device *phydev)
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
 	}
 
+	val = phy_read(phydev, DP83867_CFG3);
 	/* Enable Interrupt output INT_OE in CFG3 register */
-	if (phy_interrupt_is_valid(phydev)) {
-		val = phy_read(phydev, DP83867_CFG3);
-		val |= BIT(7);
-		phy_write(phydev, DP83867_CFG3, val);
-	}
+	if (phy_interrupt_is_valid(phydev))
+		val |= DP83867_CFG3_INT_OE;
+
+	val |= DP83867_CFG3_ROBUST_AUTO_MDIX;
+	phy_write(phydev, DP83867_CFG3, val);
 
 	if (dp83867->port_mirroring != DP83867_PORT_MIRROING_KEEP)
 		dp83867_config_port_mirroring(phydev);
-- 
2.17.1

