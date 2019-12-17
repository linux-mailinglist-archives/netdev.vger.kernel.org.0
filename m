Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B25122D1F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfLQNkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:40:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56824 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLQNkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=etQeDQ9OrLLxyMchQ/o8ppJAOYpHgRhGeECGkopaBqA=; b=yNmdloBmd/xCsrPd/eOQmSbFkr
        PO0b7GNTZC55+gMClWdjJOyaQA1d+FMmDATqYPGhY+NmsTXJuyhZ672DY37nMxdaotL54IIgLmaP2
        JfkSm+Pj52k49AbK6BC7A0mA2hUzJm4vZYU9UKJZ94iZ1EfhYYDTTo7nOlbYWdjQ7fwpoeWRngI5K
        W75iAMwKA1+L3ir737GULwXO/JL6G2tt1wnEQqOyAvMRsDoqu/5HBrPuR7x541cSFTKv0Dw3lUaik
        4npnK2kqRaT5iGwGH1zHpVN45+1r+lmXzMWCBFJsjjF3ypEz5nWtMOw9Ayo5hl1JvrrAp+MRC7wu8
        JpZWd00Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:51640 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4n-0006Fr-42; Tue, 17 Dec 2019 13:39:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4l-0001zP-48; Tue, 17 Dec 2019 13:39:47 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 10/11] net: phy: marvell: use phy_modify_changed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4l-0001zP-48@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:47 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use phy_modify_changed() to change the fiber advertisement register
rather than open coding this functionality.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2d30653ddf4b..c40d49523719 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -524,7 +524,7 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 {
 	int changed = 0;
 	int err;
-	int adv, oldadv;
+	u16 adv;
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
 		return genphy_setup_forced(phydev);
@@ -533,23 +533,17 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	linkmode_and(phydev->advertising, phydev->advertising,
 		     phydev->supported);
 
-	/* Setup fiber advertisement */
-	adv = phy_read(phydev, MII_ADVERTISE);
-	if (adv < 0)
-		return adv;
-
-	oldadv = adv;
-	adv &= ~(ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
-		 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM);
-	adv |= linkmode_adv_to_fiber_adv_t(phydev->advertising);
-
-	if (adv != oldadv) {
-		err = phy_write(phydev, MII_ADVERTISE, adv);
-		if (err < 0)
-			return err;
+	adv = linkmode_adv_to_fiber_adv_t(phydev->advertising);
 
+	/* Setup fiber advertisement */
+	err = phy_modify_changed(phydev, MII_ADVERTISE,
+				 ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
+				 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM,
+				 adv);
+	if (err < 0)
+		return err;
+	if (err > 0)
 		changed = 1;
-	}
 
 	if (changed == 0) {
 		/* Advertisement hasn't changed, but maybe aneg was never on to
-- 
2.20.1

