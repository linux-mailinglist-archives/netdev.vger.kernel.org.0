Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60571BC495
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgD1QKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:10:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43722 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbgD1QKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:10:06 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03SG9wD8043162;
        Tue, 28 Apr 2020 11:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588090198;
        bh=R7o3BT4CYy5NdMPvEu2aN/eBzQEoN5q8cyhJ4J/6Clg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=q56zGSKbkc6FwGAUaMiJsAWduBCuQBx1MBfl5CNDLDIjq/2390g5SwFboRuTCvFUW
         1o8Z4Tv3JStm6UpQ4jJOBARMTTyI+DTl4EsFLgBKnFQG8O72U9JwUiovtn9f8ashqG
         C0LEoD3rrFSGAK0EPy9B9PqXc8NwULwODCJsC/Xo=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03SG9wum000440
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Apr 2020 11:09:58 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Apr 2020 11:09:58 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Apr 2020 11:09:58 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03SG9vEx127113;
        Tue, 28 Apr 2020 11:09:58 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v3 1/2] net: phy: DP83822: Fix WoL in config init to be disabled
Date:   Tue, 28 Apr 2020 11:03:53 -0500
Message-ID: <20200428160354.2879-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428160354.2879-1-dmurphy@ti.com>
References: <20200428160354.2879-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WoL feature should be disabled when config_init is called and the
feature should turned on or off  when set_wol is called.

In addition updated the calls to modify the registers to use the set_bit
and clear_bit function calls.

Fixes: 3b427751a9d0 ("net: phy: DP83822 initial driver submission")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83822.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index fe9aa3ad52a7..1dd19d0cb269 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -137,19 +137,18 @@ static int dp83822_set_wol(struct phy_device *phydev,
 			value &= ~DP83822_WOL_SECURE_ON;
 		}
 
-		value |= (DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
-			  DP83822_WOL_CLR_INDICATION);
-		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
-			      value);
+		/* Clear any pending WoL interrupt */
+		phy_read(phydev, MII_DP83822_MISR2);
+
+		value |= DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
+			 DP83822_WOL_CLR_INDICATION;
+
+		return phy_write_mmd(phydev, DP83822_DEVADDR,
+				     MII_DP83822_WOL_CFG, value);
 	} else {
-		value = phy_read_mmd(phydev, DP83822_DEVADDR,
-				     MII_DP83822_WOL_CFG);
-		value &= ~DP83822_WOL_EN;
-		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
-			      value);
+		return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
+					  MII_DP83822_WOL_CFG, DP83822_WOL_EN);
 	}
-
-	return 0;
 }
 
 static void dp83822_get_wol(struct phy_device *phydev,
@@ -258,12 +257,11 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 static int dp83822_config_init(struct phy_device *phydev)
 {
-	int value;
-
-	value = DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON | DP83822_WOL_EN;
+	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
+		    DP83822_WOL_SECURE_ON;
 
-	return phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
-	      value);
+	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
+				  MII_DP83822_WOL_CFG, value);
 }
 
 static int dp83822_phy_reset(struct phy_device *phydev)
-- 
2.25.1

