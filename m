Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDA34AACC1
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 22:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245263AbiBEVuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 16:50:01 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:41858 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiBEVuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 16:50:00 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 3339E8001D4C;
        Sun,  6 Feb 2022 00:49:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 3339E8001D4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644097798;
        bh=CjuqZZNusyyBrdQUX0NyOK0jjIqNInUwEk3UWH6pwes=;
        h=From:To:CC:Subject:Date:From;
        b=jBiPyX8xNcjihqTEJEPTl+Hem6IwT8aXywyq32MwCG1iKLhZieq5LByVIVowMgMBw
         zyjBgYysuPsDa84IkcQwFkVESR9sJ88nnhANGZ54dgXKiImgvx5WykHMSFjcf5NYWy
         F4JtQUthTlRUh7H1iqy82+PoojNu8+8w5Ad/Na8o=
Received: from localhost (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Sun, 6 Feb 2022 00:49:41 +0300
From:   Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ron Madrid <ron_madrid@sbcglobal.net>
CC:     Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        <stable@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs
Date:   Sun, 6 Feb 2022 00:49:51 +0300
Message-ID: <20220205214951.60371-1-Pavel.Parkhomenko@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up autonegotiation for 88E1118R and compatible PHYs,
a software reset of PHY is issued before setting up polarity.
This is incorrect as changes of MDI Crossover Mode bits are
disruptive to the normal operation and must be followed by a
software reset to take effect. Let's patch m88e1118_config_aneg()
to fix the issue mentioned before by invoking software reset
of the PHY just after setting up MDI-x polarity.

Fixes: 605f196efbf8 ("phy: Add support for Marvell 88E1118 PHY")
Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
---
 drivers/net/phy/marvell.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index fa71fb7a66b5..ab063961ac00 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1213,16 +1213,15 @@ static int m88e1118_config_aneg(struct phy_device *phydev)
 {
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1118_config_init(struct phy_device *phydev)
-- 
2.32.0

