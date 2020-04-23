Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650041B613B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgDWQqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:46:09 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:46692 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbgDWQqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:46:08 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NGjuEx113868;
        Thu, 23 Apr 2020 11:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587660356;
        bh=tKDw8OQZcIMisiTxBsvq0HEhQVuhSJ2oL6rRmaHita8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=l+QdGwrB0y4GleuBqdWCjgG1tj8QsW+HOWJHHSOadCt+SpoMek1G42USrUoiSf0NV
         iTrIb47oFnBM0pFEFyiOggQ3ts0eLCK+QzrfoohfmlhIR3QDN2uLZsEQzAjUBsKwkB
         eFkGAyXm0Muj8xZhp9jgcuDUxeD+jEcQlXHOUL4E=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NGjuDL123655
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 11:45:56 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 11:45:55 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 11:45:55 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NGjtIm012635;
        Thu, 23 Apr 2020 11:45:55 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net 2/2] net: phy: DP83TC811: Fix WoL in config init to be disabled
Date:   Thu, 23 Apr 2020 11:39:47 -0500
Message-ID: <20200423163947.18313-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423163947.18313-1-dmurphy@ti.com>
References: <20200423163947.18313-1-dmurphy@ti.com>
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
 drivers/net/phy/dp83tc811.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 06f08832ebcd..48dcd2649272 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -139,10 +139,11 @@ static int dp83811_set_wol(struct phy_device *phydev,
 			value &= ~DP83811_WOL_SECURE_ON;
 		}
 
-		value |= (DP83811_WOL_EN | DP83811_WOL_INDICATION_SEL |
-			  DP83811_WOL_CLR_INDICATION);
-		phy_write_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
-			      value);
+		value |= DP83811_WOL_EN | DP83811_WOL_INDICATION_SEL |
+			 DP83811_WOL_CLR_INDICATION;
+
+		phy_set_bits_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
+				 value);
 	} else {
 		phy_clear_bits_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
 				   DP83811_WOL_EN);
@@ -292,8 +293,8 @@ static int dp83811_config_init(struct phy_device *phydev)
 
 	value = DP83811_WOL_MAGIC_EN | DP83811_WOL_SECURE_ON | DP83811_WOL_EN;
 
-	return phy_write_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
-	      value);
+	return phy_clear_bits_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG,
+				  value);
 }
 
 static int dp83811_phy_reset(struct phy_device *phydev)
-- 
2.25.1

