Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEAD1BB07D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgD0V13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:27:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45342 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0V13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:27:29 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRGp0084931;
        Mon, 27 Apr 2020 16:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588022836;
        bh=R7o3BT4CYy5NdMPvEu2aN/eBzQEoN5q8cyhJ4J/6Clg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UQrKXL1bUUTmXhgiMbnYeEHxVzRMdFMFe9L234OPp2vYdtdkPQApux2SYO+KSKzkB
         lRoH7Grm93UE7DnIafQ/rBkRlAVNLhb2txFqLUMaGuXzGScNecfHCl9KaL+guJKjpN
         8lI50GZuvP6z1KkYy3J8d2uKaF4hFutOEZP2p6IM=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03RLRG9R054884
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Apr 2020 16:27:16 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 27
 Apr 2020 16:27:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 27 Apr 2020 16:27:16 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRG8L048696;
        Mon, 27 Apr 2020 16:27:16 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v2 1/2] net: phy: DP83822: Fix WoL in config init to be disabled
Date:   Mon, 27 Apr 2020 16:21:11 -0500
Message-ID: <20200427212112.25368-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200427212112.25368-1-dmurphy@ti.com>
References: <20200427212112.25368-1-dmurphy@ti.com>
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

