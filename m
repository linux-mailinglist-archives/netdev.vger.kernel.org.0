Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F923CC01F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390211AbfJDQGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:06:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33716 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390098AbfJDQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v5lENi7MleKavcxCBuAHyF9Lt4Cu7Xz/mPVZlU1pxu0=; b=F4Ob/U0PYIm3qosVpSiVeGSGdx
        rcGFPDF0v7xYKr7FEzW8ktQ6dwZorFjMK+/aZ/s/I0o+MrDrwUfGtBy3bg9GhzEpXS60YfCwg+Gxh
        hRKWNp9ofhNe/tuPcF03xwGyN2VHWVCOBuF/JtF3iRfEHGhfGfmp+5S4Aoa7B8cS9vk+lh1aO4QX7
        SFnwCHGSSmi5dIBQcXppSyNme4++7F1HkawiIyLSONXbjPN3d6K/Oa3ox+uKhAGvlOEt0CHZDx/DZ
        QPueNisQrfswUn/kgxogF9JSbFDZL0R/IBVWVE3vy80DyvEbOH2EoEamDGhD1nxY1D/wUb/eOCWJn
        1JQuag4g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39854 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5f-0005Kx-Ll; Fri, 04 Oct 2019 17:05:59 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5e-0001QZ-Tr; Fri, 04 Oct 2019 17:05:59 +0100
In-Reply-To: <20191004160525.GZ25745@shell.armlinux.org.uk>
References: <20191004160525.GZ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 1/4] net: phy: fix write to mii-ctrl1000 register
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iGQ5e-0001QZ-Tr@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Oct 2019 17:05:58 +0100
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 5 +++++
 include/linux/mii.h   | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7c92afd36bbe..119e6f466056 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -457,6 +457,11 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
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

