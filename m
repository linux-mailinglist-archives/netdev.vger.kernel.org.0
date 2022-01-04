Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22AB48460C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiADQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiADQiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:38:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648E2C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A53dYCQZb7vGLxkG0KXWMDv1NPVIwE+AZjGM+Fk/5b4=; b=0XKiSKXi997A8XPMjM81yS27H0
        FF/92ie/ySFNd9pulo6Jj20GQ3ME4bftObnEr5oGb6ZlbSjI12FU/wTj05zRYmH2BGAKnPx9WyNma
        Ua+nvqYTU74jC9IxOTw1CksgSTvyEF7nphqKuhzWwTK4Re2RGUoSzXs3wz3uIwUuGjfwTHrf0EIst
        /259Erzldf2TvZSFJjPLRXWdf9JdVtnfuqop9qc1yNZAy/LORDboafY/+NEr/cyn9IgNPzQdQXY0l
        iE9M1Q5Os76gp+Rw2jDO3qja0snb3gvbj/l0aR4swDDNa4oB+EPUnKmmLHJOigMt8RGfT6t7/4t+F
        XmHq+Igw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49480 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1n4mpC-0007Gj-D6; Tue, 04 Jan 2022 16:38:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1n4mpB-002PKE-UM; Tue, 04 Jan 2022 16:38:13 +0000
In-Reply-To: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: phy: marvell: use phy_write_paged() to set
 MSCR
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1n4mpB-002PKE-UM@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 04 Jan 2022 16:38:13 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use phy_write_paged() in m88e1118_config_init() to set the MSCR value.
We leave the other paged write for the LEDs in case the DT register
parsing is relying on this page.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..64e7874c95f4 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1225,28 +1225,22 @@ static int m88e1118_config_aneg(struct phy_device *phydev)
 
 static int m88e1118_config_init(struct phy_device *phydev)
 {
+	u16 leds;
 	int err;
 
-	/* Change address */
-	err = marvell_set_page(phydev, MII_MARVELL_MSCR_PAGE);
-	if (err < 0)
-		return err;
-
 	/* Enable 1000 Mbit */
-	err = phy_write(phydev, 0x15, 0x1070);
-	if (err < 0)
-		return err;
-
-	/* Change address */
-	err = marvell_set_page(phydev, MII_MARVELL_LED_PAGE);
+	err = phy_write_paged(phydev, MII_MARVELL_MSCR_PAGE,
+			      MII_88E1121_PHY_MSCR_REG, 0x1070);
 	if (err < 0)
 		return err;
 
 	/* Adjust LED Control */
 	if (phydev->dev_flags & MARVELL_PHY_M1118_DNS323_LEDS)
-		err = phy_write(phydev, 0x10, 0x1100);
+		leds = 0x1100;
 	else
-		err = phy_write(phydev, 0x10, 0x021e);
+		leds = 0x021e;
+
+	err = phy_write_paged(phydev, MII_MARVELL_LED_PAGE, 0x10, leds);
 	if (err < 0)
 		return err;
 
@@ -1254,7 +1248,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	/* Reset address */
+	/* Reset page register */
 	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
 	if (err < 0)
 		return err;
-- 
2.30.2

