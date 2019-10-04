Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B77CC027
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390354AbfJDQGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:06:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33750 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbfJDQGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0HGyShu8aTplIUTxeo4HMgmnhPzTlAOPhNkul91UCXM=; b=lgS/GQR0L5T8CZ4Dc5Dh5r/+ss
        XRCmUk4cUEM/QZxQ5AQzICajyL+CIT6o8AADe8o2lYdgNxt0ctP3bhxnMQc/ZlQiJ9LUlgIUcuxQG
        JaE7dtzgZ39E+7St0kjyLUouwDPR+hXV2myKPelfNJ1JGxQM2xq80fi8gRz8tHkt8SwmGHqYuDwYp
        ttG4bio5AshiUunwMFRsCGNUvVoEPEsm04FviC9sWdp+6xiwvWPHz4sWdBgrfjkOb7C0F/FQ809gU
        KO069Cvh1l+oobZztWSTIft8I2JKXJMaMIwdm7XbIEZl/rns2v0FTdBaTbFiGX/sBezUTGSRmBdPv
        Yelgj8VA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39862 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5r-0005LK-ND; Fri, 04 Oct 2019 17:06:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5p-0001Qo-AF; Fri, 04 Oct 2019 17:06:09 +0100
In-Reply-To: <20191004160525.GZ25745@shell.armlinux.org.uk>
References: <20191004160525.GZ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 3/4] net: phy: extract pause mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iGQ5p-0001Qo-AF@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Oct 2019 17:06:09 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract the update of phylib's software pause mode state from
genphy_read_status(), so that we can re-use this functionality with
PHYs that have alternative ways to read the negotiation results.

Tested-by: tinywrkb <tinywrkb@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy-core.c | 20 +++++++++++++-------
 include/linux/phy.h        |  1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 369903d9b6ec..9412669b579c 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -283,6 +283,18 @@ void of_set_phy_eee_broken(struct phy_device *phydev)
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
@@ -305,13 +317,7 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
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
index 7abee820d05c..9a0e981df502 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -678,6 +678,7 @@ static inline bool phy_is_started(struct phy_device *phydev)
 	return phydev->state >= PHY_UP;
 }
 
+void phy_resolve_aneg_pause(struct phy_device *phydev);
 void phy_resolve_aneg_linkmode(struct phy_device *phydev);
 
 /**
-- 
2.7.4

