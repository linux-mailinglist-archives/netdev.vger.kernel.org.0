Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F4C438BB6
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 21:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhJXTuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 15:50:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhJXTuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 15:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IkG1yF57PDHxNEr3gmvwUC/OZD/PTPvHu6NqRi5iEJY=; b=1dkOmEQXThnlavcUR/V8BkWvd4
        auy2dfVq2KjeiEo3CTJV7BXttC6/jI8xDQnehT9cUbH8FbDS/KDImmShlzNLopF+gfMxBRY0thIBJ
        Z2nHwSL/B8P8mQPkpS0iZeEyaGt37JJsJxNyxqb6+sJObj0AAWX3sF5ctzkNrnKpozUE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mejTf-00Bacc-83; Sun, 24 Oct 2021 21:48:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Walter.Stoll@duagon.com,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 2/4] phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
Date:   Sun, 24 Oct 2021 21:48:03 +0200
Message-Id: <20211024194805.2762333-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211024194805.2762333-1-andrew@lunn.ch>
References: <20211024194805.2762333-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows it to make use of a helper which assume the PHY is already
locked.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 106 +++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8457b829667e..ee584fa8b76d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -243,59 +243,6 @@ static void phy_sanitize_settings(struct phy_device *phydev)
 	}
 }
 
-int phy_ethtool_ksettings_set(struct phy_device *phydev,
-			      const struct ethtool_link_ksettings *cmd)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
-	u8 autoneg = cmd->base.autoneg;
-	u8 duplex = cmd->base.duplex;
-	u32 speed = cmd->base.speed;
-
-	if (cmd->base.phy_address != phydev->mdio.addr)
-		return -EINVAL;
-
-	linkmode_copy(advertising, cmd->link_modes.advertising);
-
-	/* We make sure that we don't pass unsupported values in to the PHY */
-	linkmode_and(advertising, advertising, phydev->supported);
-
-	/* Verify the settings we care about. */
-	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
-		return -EINVAL;
-
-	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
-		return -EINVAL;
-
-	if (autoneg == AUTONEG_DISABLE &&
-	    ((speed != SPEED_1000 &&
-	      speed != SPEED_100 &&
-	      speed != SPEED_10) ||
-	     (duplex != DUPLEX_HALF &&
-	      duplex != DUPLEX_FULL)))
-		return -EINVAL;
-
-	phydev->autoneg = autoneg;
-
-	if (autoneg == AUTONEG_DISABLE) {
-		phydev->speed = speed;
-		phydev->duplex = duplex;
-	}
-
-	linkmode_copy(phydev->advertising, advertising);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-			 phydev->advertising, autoneg == AUTONEG_ENABLE);
-
-	phydev->master_slave_set = cmd->base.master_slave_cfg;
-	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
-
-	/* Restart the PHY */
-	phy_start_aneg(phydev);
-
-	return 0;
-}
-EXPORT_SYMBOL(phy_ethtool_ksettings_set);
-
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
@@ -802,6 +749,59 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
+int phy_ethtool_ksettings_set(struct phy_device *phydev,
+			      const struct ethtool_link_ksettings *cmd)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
+	u8 autoneg = cmd->base.autoneg;
+	u8 duplex = cmd->base.duplex;
+	u32 speed = cmd->base.speed;
+
+	if (cmd->base.phy_address != phydev->mdio.addr)
+		return -EINVAL;
+
+	linkmode_copy(advertising, cmd->link_modes.advertising);
+
+	/* We make sure that we don't pass unsupported values in to the PHY */
+	linkmode_and(advertising, advertising, phydev->supported);
+
+	/* Verify the settings we care about. */
+	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
+		return -EINVAL;
+
+	if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
+		return -EINVAL;
+
+	if (autoneg == AUTONEG_DISABLE &&
+	    ((speed != SPEED_1000 &&
+	      speed != SPEED_100 &&
+	      speed != SPEED_10) ||
+	     (duplex != DUPLEX_HALF &&
+	      duplex != DUPLEX_FULL)))
+		return -EINVAL;
+
+	phydev->autoneg = autoneg;
+
+	if (autoneg == AUTONEG_DISABLE) {
+		phydev->speed = speed;
+		phydev->duplex = duplex;
+	}
+
+	linkmode_copy(phydev->advertising, advertising);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->advertising, autoneg == AUTONEG_ENABLE);
+
+	phydev->master_slave_set = cmd->base.master_slave_cfg;
+	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
+
+	/* Restart the PHY */
+	phy_start_aneg(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_ethtool_ksettings_set);
+
 /**
  * phy_speed_down - set speed to lowest speed supported by both link partners
  * @phydev: the phy_device struct
-- 
2.33.0

