Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA55BA1EB
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfIVLAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:00:17 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35604 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbfIVLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uQlVSfKonRbi6Kz3XxpjbzkNVOMpKT5h3JgvNRyW5Q0=; b=tWKnONuwejzaWmFpV7IJwlcVMg
        FMUt6qXNGJtO/KcqIaL5mrPOt9tZjcKG2yb7AK346jpg0wQ70sey8ZBE3jqGyBAqT+szWOAmTmDcD
        d1NPVvO2Wmga26QwqE8AE8lI/8vgsxa4nIOevvIflZZ471GDuBFQP8EZi8MbNFsQxxE+ncyy6rDg1
        0XW860gwPXQRZliNtOoInduqElg9+vLObjnvQskxSfPvnimC4NDBgptsXXZCAJh1QPa1D/wO9+OV5
        CYZsozYDH4/1w/6Ow7nRXzPbyzAH79vLlDXxKMYIfCNA/4gCtcVa9J+uLBRSg9hfm62isKJcF9C38
        HLiXhmGQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34008 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzb8-0006ah-Uj; Sun, 22 Sep 2019 12:00:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzb8-00006n-4B; Sun, 22 Sep 2019 12:00:10 +0100
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/4] net: phy: fix write to mii-ctrl1000 register
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iBzb8-00006n-4B@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Sep 2019 12:00:10 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When userspace writes to the MII_ADVERTISE register, we update phylib's
advertising mask and trigger a renegotiation.  However, writing to the
MII_CTRL1000 register, which contains the gigabit advertisement, does
neither.  This can lead to phylib's copy of the advertisement becoming
de-synced with the values in the PHY register set, which can result in
incorrect negotiation resolution.

Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 5 +++++
 include/linux/mii.h   | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7af390d8bbdb..068a08a50064 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -458,6 +458,11 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 							   val);
 				change_autoneg = true;
 				break;
+			case MII_CTRL1000:
+				mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
+							        val);
+				change_autoneg = true;
+				break;
 			default:
 				/* do nothing */
 				break;
diff --git a/include/linux/mii.h b/include/linux/mii.h
index 5cd824c1c0ca..4ce8901a1af6 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -455,6 +455,15 @@ static inline void mii_lpa_mod_linkmode_lpa_t(unsigned long *lp_advertising,
 			 lp_advertising, lpa & LPA_LPACK);
 }
 
+static inline void mii_ctrl1000_mod_linkmode_adv_t(unsigned long *advertising,
+						   u32 ctrl1000)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, advertising,
+			 ctrl1000 & ADVERTISE_1000HALF);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, advertising,
+			 ctrl1000 & ADVERTISE_1000FULL);
+}
+
 /**
  * linkmode_adv_to_lcl_adv_t
  * @advertising:pointer to linkmode advertising
-- 
2.7.4

