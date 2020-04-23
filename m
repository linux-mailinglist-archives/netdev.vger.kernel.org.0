Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055811B6138
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgDWQqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:46:09 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50914 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729750AbgDWQqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:46:08 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NGjofs117956;
        Thu, 23 Apr 2020 11:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587660350;
        bh=UuM6vG3QFMWDodCJ7O1B5Kk4df71JSKexxTXYlfg/0E=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=k0y2cQhsRXosEoOCt7eif1mUgIyvv+I8zjex83Vit2BPSdKOduN44xFxgv5kYs7ai
         sQc1KpJVJ/cE+0FEFT+KhImXmE9JqUNhmW1fWM54LkINtiDR9lZIf/UkynMdy3pHiJ
         QabzqDYn3t3jqEFnYrgI+nzbUJFBCoVQV6nciF5M=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NGjovq122085
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 11:45:50 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 11:45:50 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 11:45:50 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NGjoQc012573;
        Thu, 23 Apr 2020 11:45:50 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net 1/2] net: phy: DP83822: Fix WoL in config init to be disabled
Date:   Thu, 23 Apr 2020 11:39:46 -0500
Message-ID: <20200423163947.18313-2-dmurphy@ti.com>
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

Fixes: 3b427751a9d0 ("net: phy: DP83822 initial driver submission")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83822.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index fe9aa3ad52a7..40fdfd043947 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -137,16 +137,19 @@ static int dp83822_set_wol(struct phy_device *phydev,
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
+			DP83822_WOL_CLR_INDICATION;
+
+		return phy_set_bits_mmd(phydev, DP83822_DEVADDR,
+					MII_DP83822_WOL_CFG, value);
 	} else {
-		value = phy_read_mmd(phydev, DP83822_DEVADDR,
-				     MII_DP83822_WOL_CFG);
-		value &= ~DP83822_WOL_EN;
-		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
-			      value);
+		value = DP83822_WOL_EN | DP83822_WOL_CLR_INDICATION;
+
+		return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
+					  MII_DP83822_WOL_CFG, value);
 	}
 
 	return 0;
@@ -258,12 +261,11 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
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

