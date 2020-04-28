Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B281BC4A2
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgD1QKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:10:13 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43742 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbgD1QKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:10:11 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03SGA45c043200;
        Tue, 28 Apr 2020 11:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588090204;
        bh=t2wy9FWProHqy/MyEp4hiCaYn524xY2xYIvfK5vZASk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=leaRBxJw9Kr8Pd0v90Tn0rElaACir9qhkpx1q61vm/xCga59zhDEbEc5VLACqoMls
         6yVkSU9pQhLIuLxl36bhLt2MzTM8n6Pd2EIPUiJmwUNRbyoGY0eb1cxRhJCleV66M8
         cALIK6nUZCtbeJJKePEsnNgjjDx8UPevw55ikuZk=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03SGA4uW060731
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Apr 2020 11:10:04 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Apr 2020 11:10:03 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Apr 2020 11:10:03 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03SGA36v127668;
        Tue, 28 Apr 2020 11:10:03 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v3 2/2] net: phy: DP83TC811: Fix WoL in config init to be disabled
Date:   Tue, 28 Apr 2020 11:03:54 -0500
Message-ID: <20200428160354.2879-3-dmurphy@ti.com>
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

Fixes: 6d749428788b ("net: phy: DP83TC811: Introduce support for the
DP83TC811 phy")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83tc811.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 06f08832ebcd..d73725312c7c 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -139,16 +139,19 @@ static int dp83811_set_wol(struct phy_device *phydev,
 			value &= ~DP83811_WOL_SECURE_ON;
 		}
 
-		value |= (DP83811_WOL_EN | DP83811_WOL_INDICATION_SEL |
-			  DP83811_WOL_CLR_INDICATION);
-		phy_write_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
-			      value);
+		/* Clear any pending WoL interrupt */
+		phy_read(phydev, MII_DP83811_INT_STAT1);
+
+		value |= DP83811_WOL_EN | DP83811_WOL_INDICATION_SEL |
+			 DP83811_WOL_CLR_INDICATION;
+
+		return phy_write_mmd(phydev, DP83811_DEVADDR,
+				     MII_DP83811_WOL_CFG, value);
 	} else {
-		phy_clear_bits_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
-				   DP83811_WOL_EN);
+		return phy_clear_bits_mmd(phydev, DP83811_DEVADDR,
+					  MII_DP83811_WOL_CFG, DP83811_WOL_EN);
 	}
 
-	return 0;
 }
 
 static void dp83811_get_wol(struct phy_device *phydev,
@@ -292,8 +295,8 @@ static int dp83811_config_init(struct phy_device *phydev)
 
 	value = DP83811_WOL_MAGIC_EN | DP83811_WOL_SECURE_ON | DP83811_WOL_EN;
 
-	return phy_write_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
-	      value);
+	return phy_clear_bits_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
+				  value);
 }
 
 static int dp83811_phy_reset(struct phy_device *phydev)
-- 
2.25.1

