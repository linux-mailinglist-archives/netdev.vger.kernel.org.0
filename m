Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E401BA1ED
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfIVLA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:00:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35626 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbfIVLA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XGg9nrbzvC/Dngeq9AftUDnCmvEnRmhjCkLXijVHeko=; b=LGVSK9GC7qWTwYiI7mqwUr378E
        yOHWerE7cvn+bBUk4PUDhymg6Z8hD1SzP5ERqpGEHPEN1OFtqNobpLQGH4b0WVlWE0S5mTfGB98k7
        YRHf3aK/iSF9MEL8Ht/uy+daeTcL8WjC1WFx6/w8tO/K4KHwV8UQEm4L8QSj3kikFaD2o20UjziBF
        BQzZ+8qYLvwsS0571mw1IFDWbUQ54Z9vnG+rvF+s5+VeWXB7+iQbaRJPn7bSoaKqb30fYz0U2824U
        It/cUejm3Q+J6pZ62Wcbjb5K6WEL4MPbboUAQwNM+m0Pnuss1pDPIlpSjsZ/bc5mb7oNR2+HtmPJ6
        aabUnQzw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:43956 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbK-0006az-0W; Sun, 22 Sep 2019 12:00:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbI-000072-R4; Sun, 22 Sep 2019 12:00:20 +0100
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 3/4] net: phy: extract pause mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iBzbI-000072-R4@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Sep 2019 12:00:20 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract the update of phylib's software pause mode state from
genphy_read_status(), so that we can re-use this functionality with
PHYs that have alternative ways to read the negotiation results.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy-core.c | 20 +++++++++++++-------
 include/linux/phy.h        |  1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 16667fbac8bf..91b856b31fd6 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -278,6 +278,18 @@ void of_set_phy_eee_broken(struct phy_device *phydev)
 	phydev->eee_broken_modes = broken;
 }
 
+void phy_resolve_aneg_pause(struct phy_device *phydev)
+{
+	if (phydev->duplex == DUPLEX_FULL) {
+		phydev->pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+						  phydev->lp_advertising);
+		phydev->asym_pause = linkmode_test_bit(
+			ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			phydev->lp_advertising);
+	}
+}
+EXPORT_SYMBOL_GPL(phy_resolve_aneg_pause);
+
 /**
  * phy_resolve_aneg_linkmode - resolve the advertisements into phy settings
  * @phydev: The phy_device struct
@@ -300,13 +312,7 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
 			break;
 		}
 
-	if (phydev->duplex == DUPLEX_FULL) {
-		phydev->pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-						  phydev->lp_advertising);
-		phydev->asym_pause = linkmode_test_bit(
-			ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-			phydev->lp_advertising);
-	}
+	phy_resolve_aneg_pause(phydev);
 }
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index bef7f30af22d..224e81740963 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -686,6 +686,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
 	return phydev->state >= PHY_UP;
 }
 
+void phy_resolve_aneg_pause(struct phy_device *phydev);
 void phy_resolve_aneg_linkmode(struct phy_device *phydev);
 
 /**
-- 
2.7.4

