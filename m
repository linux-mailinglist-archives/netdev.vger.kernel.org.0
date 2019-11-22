Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11AF107240
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKVMhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 07:37:19 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45034 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVMhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 07:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r5TXXhid21G7+9/7i/KygQOqG5Gr7KaIdp+n95tHJ+U=; b=I3MEMSf0A4e+w1FMVR0pFn45Cu
        mDOxacNM1NJ1A+4Gzd/D6GX1a9qUcZSNXwFH9SmoS2vSvndrvMZLHaitHR+nX4aByuEMUSWoUdFIR
        FZ+pNtdua955z8Q/qi5XsASt6LuCU69hD2nmOvIXL+5pHZ35Ng+aO78nviYprbBBYw7rWb4X8WUGv
        Jj7+LsdjuBT9yY8wbsdHZVIeNlwzrLeeLJnaWvbYBwhHeQBgOupHY1G9IjJHI3NCRSSUSQhIYznva
        iGq+2ix41oDlX/2K2HGJbQ0WM4grAXIcYo7bLNuEwseRIL5M+HbFZ258SsEd0NL/TfpDLxzq7SyBB
        H89Ic7eQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:57320 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iY8BR-00059V-PX; Fri, 22 Nov 2019 12:37:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iY8BQ-00066m-TG; Fri, 22 Nov 2019 12:37:08 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] net: phy: remove phy_ethtool_sset()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
Date:   Fri, 22 Nov 2019 12:37:08 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no users of phy_ethtool_sset() in the kernel anymore, and
as of 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
supported from u32 to link mode"), the implementation is slightly
buggy - it doesn't correctly check the masked advertising mask as it
used to.

Remove it, and update the phy documentation to refer to its replacement
function.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/phy.rst |  3 +-
 drivers/net/phy/phy.c            | 60 --------------------------------
 include/linux/phy.h              |  1 -
 3 files changed, 2 insertions(+), 62 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index a689966bc4be..cda1c0a0492a 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -352,7 +352,8 @@ Fills the phydev structure with up-to-date information about the current
 settings in the PHY.
 ::
 
- int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd);
+ int phy_ethtool_ksettings_set(struct phy_device *phydev,
+                               const struct ethtool_link_ksettings *cmd);
 
 Ethtool convenience functions.
 ::
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef6096dc7182..9e431b9f9d87 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -253,66 +253,6 @@ static void phy_sanitize_settings(struct phy_device *phydev)
 	}
 }
 
-/**
- * phy_ethtool_sset - generic ethtool sset function, handles all the details
- * @phydev: target phy_device struct
- * @cmd: ethtool_cmd
- *
- * A few notes about parameter checking:
- *
- * - We don't set port or transceiver, so we don't care what they
- *   were set to.
- * - phy_start_aneg() will make sure forced settings are sane, and
- *   choose the next best ones from the ones selected, so we don't
- *   care if ethtool tries to give us bad values.
- */
-int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
-	u32 speed = ethtool_cmd_speed(cmd);
-
-	if (cmd->phy_address != phydev->mdio.addr)
-		return -EINVAL;
-
-	/* We make sure that we don't pass unsupported values in to the PHY */
-	ethtool_convert_legacy_u32_to_link_mode(advertising, cmd->advertising);
-	linkmode_and(advertising, advertising, phydev->supported);
-
-	/* Verify the settings we care about. */
-	if (cmd->autoneg != AUTONEG_ENABLE && cmd->autoneg != AUTONEG_DISABLE)
-		return -EINVAL;
-
-	if (cmd->autoneg == AUTONEG_ENABLE && cmd->advertising == 0)
-		return -EINVAL;
-
-	if (cmd->autoneg == AUTONEG_DISABLE &&
-	    ((speed != SPEED_1000 &&
-	      speed != SPEED_100 &&
-	      speed != SPEED_10) ||
-	     (cmd->duplex != DUPLEX_HALF &&
-	      cmd->duplex != DUPLEX_FULL)))
-		return -EINVAL;
-
-	phydev->autoneg = cmd->autoneg;
-
-	phydev->speed = speed;
-
-	linkmode_copy(phydev->advertising, advertising);
-
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-			 phydev->advertising, AUTONEG_ENABLE == cmd->autoneg);
-
-	phydev->duplex = cmd->duplex;
-
-	phydev->mdix_ctrl = cmd->eth_tp_mdix_ctrl;
-
-	/* Restart the PHY */
-	phy_start_aneg(phydev);
-
-	return 0;
-}
-EXPORT_SYMBOL(phy_ethtool_sset);
-
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 70173861e1a2..f172ff22c177 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1158,7 +1158,6 @@ void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
 void phy_mac_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
-int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd);
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd);
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
-- 
2.20.1

