Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FD21616BF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgBQPyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:33 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38432 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBQPyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hARU9gqb11OAizO1qTl7juy0uEll5rK2iDNCVHfevhE=; b=MLsdcDiL/vpYWlpEm2R8/kbn84
        QTZsszIhm7ty/FqQ5qPnaAcRJ1ACv9+JO1u0NukSGs99y3tBnxdEeIEoOQyFSTnwow/aCFZgMC+3X
        tX734emeUgc+cwZOWgBBl/ruQ6Tvy1Q4LawMU69sfmc2uz2YXlvW4UDn3Pts4GL9UjzcWEgNt2EtH
        nNwX7vf5Zm17eTd1PmAL3pmPKJn5Cpn3E9w/vbZzREIe6/3HbRvbhS5kDEJbxvvZvlEeuxqPQxDt8
        LDDWMkEvbd08qkSm83c8IEzY9SNo7KjGejDow7VK3uxZ1EtHkibjtlQ1v2wF/tscV+QkyQoTSFo8R
        XRYE9fLA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:36432 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ij4-0001hv-9w; Mon, 17 Feb 2020 15:54:26 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ij3-0006ET-E3; Mon, 17 Feb 2020 15:54:25 +0000
In-Reply-To: <20200217155346.GW25745@shell.armlinux.org.uk>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: phy: marvell: don't interpret PHY status
 unless resolved
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3ij3-0006ET-E3@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 15:54:25 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't attempt to interpret the PHY specific status register unless
the PHY is indicating that the resolution is valid.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 28e33ece4ce1..9a8badafea8a 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1306,6 +1306,9 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		}
 	}
 
+	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
+		return 0;
+
 	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
 		phydev->duplex = DUPLEX_FULL;
 	else
@@ -1365,6 +1368,8 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
 	linkmode_zero(phydev->lp_advertising);
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
 
 	if (phydev->autoneg == AUTONEG_ENABLE)
 		err = marvell_read_status_page_an(phydev, fiber, status);
-- 
2.20.1

