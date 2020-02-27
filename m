Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F03171449
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgB0Jo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:44:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34754 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbgB0Jo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bqOOl8F8L/m0So+j1pmD+kH6YnmeJyMLlLj+LaMp5Zo=; b=JHf7tPUhmxxUY5pGpsN2qAnQu2
        iiv54JVROypNL7zfsW8vDDbnZVYX6ugyWiOjq9ZCB85OabAtQRLke9W78WxVp4+FfXOs6ij9piBlM
        A3Jf7Yvc7zLyALtdtpozat1AjH/p18b+KJnn3Vr/0kFE/SY0K/Bqohm0pKAKc/KgmAOAOKmPziQYB
        XzwwRBMhYwQLFMrPtydyfaMqu2VHMGYAcRcSfZWLgonUnllZEriRbjUosG1ijtEQXYzTwuBgyY3eL
        D28ksQzgvzML5pnJu0MrGU0e9RocbrbX2078p/I1RqHJ2S7TL3prrbNrEfY5g1RjDXACKIkoQjKyk
        l6TIs1Yw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45354 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7Fit-0004hX-7V; Thu, 27 Feb 2020 09:44:51 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7Fir-0003jk-HI; Thu, 27 Feb 2020 09:44:49 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phy: marvell: don't interpret PHY status unless
 resolved
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7Fir-0003jk-HI@rmk-PC.armlinux.org.uk>
Date:   Thu, 27 Feb 2020 09:44:49 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't attempt to interpret the PHY specific status register unless
the PHY is indicating that the resolution is valid.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

