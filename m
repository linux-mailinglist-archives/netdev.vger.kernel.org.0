Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA01BB07A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD0V1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:27:31 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59384 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0V1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:27:30 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRLrJ028314;
        Mon, 27 Apr 2020 16:27:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588022841;
        bh=M3ka0zwBQEFyARBdnBuOoAp46mGrBdLsTITwD7gl5S4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=OwesEUCxOd9k6fwwtOye+2H7/d5X3xh6zOV4RJFZxGOzWIdeoyrSVn3MgwusArbtl
         RiMJft3YO0wNKflvYGAvAX3h3ha9vRDhgmSHLn/fX3nb8sEB4CHjROdtx4gKFrNwn+
         43Ohszk2+EVsGXTFR+9F0uDklRZWTBKsf+UGZ4Gc=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03RLRLIT123724
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 27 Apr 2020 16:27:21 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 27
 Apr 2020 16:27:21 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 27 Apr 2020 16:27:21 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03RLRL9R048731;
        Mon, 27 Apr 2020 16:27:21 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net v2 2/2] net: phy: DP83TC811: Fix WoL in config init to be disabled
Date:   Mon, 27 Apr 2020 16:21:12 -0500
Message-ID: <20200427212112.25368-3-dmurphy@ti.com>
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

Fixes: 6d749428788b ("net: phy: DP83TC811: Introduce support for the
DP83TC811 phy")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83tc811.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 06f08832ebcd..ff325fb748b9 100644
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
+		return phy_write_mmd(phydev, DP83822_DEVADDR,
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

