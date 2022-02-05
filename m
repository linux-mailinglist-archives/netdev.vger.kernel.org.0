Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E534AAC86
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 21:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381309AbiBEUjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 15:39:40 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:41692 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242000AbiBEUjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 15:39:40 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 468108001D4C;
        Sat,  5 Feb 2022 23:39:38 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 468108001D4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644093578;
        bh=sDoTov5OIKx67Gh9Jh4s/4QXTa6AuW6mlrErVMoII/c=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=p1dTl/rgXa1VCd6PQrjyq/HRHFMdvzgtDz6OVPK0zx9ut+CsHzJzl2EjMvPkcbEZb
         xhEW/IyE4RcMvW4T5dczJ1/8/CNuh86o6CabZK5ox7oPKdU8v/r7D5/kNKmj4LtauA
         XO4BrCFQNUv8FwLXm7ZgrnMmdqYKa2mkl1LniAGo=
Received: from localhost (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Sat, 5 Feb 2022 23:39:23 +0300
From:   Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
Date:   Sat, 5 Feb 2022 23:39:32 +0300
Message-ID: <20220205203932.26899-1-Pavel.Parkhomenko@baikalelectronics.ru>
In-Reply-To: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is mandatory for a software to issue a reset upon modifying RGMII
Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
Specific Control register 2 (page 2, register 21) otherwise the changes
won't be perceived by the PHY (the same is applicable for a lot of other
registers). Not setting the RGMII delays on the platforms that imply it'
being done on the PHY side will consequently cause the traffic loss. We
discovered that the denoted soft-reset is missing in the
m88e1121_config_aneg() method for the case if the RGMII delays are
modified but the MDIx polarity isn't changed or the auto-negotiation is
left enabled, thus causing the traffic loss on our platform with Marvell
Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
method.

Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Cc: stable@vger.kernel.org

---

Link: https://lore.kernel.org/netdev/96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru/
Changelog v2:
- Add "net" suffix into the PATCH-clause of the subject.
- Cc the patch to the stable tree list.
- Rebase onto the latset netdev/net branch with the top commit 59085208e4a2
("net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over
IP")
---
 drivers/net/phy/marvell.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa71fb7a66b5..e2fd1252be48 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -553,9 +553,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct phy_device *phydev)
 	else
 		mscr = 0;
 
-	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
-				MII_88E1121_PHY_MSCR_REG,
-				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
+	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
+					MII_88E1121_PHY_MSCR_REG,
+					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
 }
 
 static int m88e1121_config_aneg(struct phy_device *phydev)
@@ -569,11 +569,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 			return err;
 	}
 
+	changed = err;
+
 	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	changed = err;
+	changed |= err;
 
 	err = genphy_config_aneg(phydev);
 	if (err < 0)
-- 
2.32.0

