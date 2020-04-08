Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4480F1A2B76
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgDHVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:51:37 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:44878 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDHVvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 17:51:37 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2020 17:51:36 EDT
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id D4D19C72B3E;
        Wed,  8 Apr 2020 23:45:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1586382328;
        bh=/Xfxr6bQ0YUHTVcrSQ5u+QRzIamIw5VqJzOKJ0VgNNU=;
        h=From:To:Cc:Subject:Date:From;
        b=k/0qDYpotiovTl+xpRajQ9esKeqgReP0BjkNmbwAasfOY0GzIsXwv2wMkoEvZcZIa
         fZYXBZIE8zZ3x/IXsPy8WBeXz/dCz4QwPnP25vbnvde5ETHg3UbR0YdlVXhdSZP8qJ
         nqkHJu02YexlKmteRSlFpgB0nnWW8YFhuMcQ0q5I=
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        stable@vger.kernel.org
Subject: [PATCH] net: phy: marvell: Fix pause frame negotiation
Date:   Wed,  8 Apr 2020 23:43:26 +0200
Message-Id: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The negotiation of flow control / pause frame modes was broken since
commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
genphy_read_lpa()") moved the setting of phydev->duplex below the
phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
function, phydev->pause was no longer set.

Fix it by moving the parsing of the status variable before the blocks
dealing with the pause frames.

Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
---
 drivers/net/phy/marvell.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4714ca0e0d4b..02cde4c0668c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1263,6 +1263,28 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 	int lpa;
 	int err;
 
+	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
+		return 0;
+
+	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
+		phydev->duplex = DUPLEX_FULL;
+	else
+		phydev->duplex = DUPLEX_HALF;
+
+	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
+	case MII_M1011_PHY_STATUS_1000:
+		phydev->speed = SPEED_1000;
+		break;
+
+	case MII_M1011_PHY_STATUS_100:
+		phydev->speed = SPEED_100;
+		break;
+
+	default:
+		phydev->speed = SPEED_10;
+		break;
+	}
+
 	if (!fiber) {
 		err = genphy_read_lpa(phydev);
 		if (err < 0)
@@ -1291,28 +1313,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		}
 	}
 
-	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
-		return 0;
-
-	if (status & MII_M1011_PHY_STATUS_FULLDUPLEX)
-		phydev->duplex = DUPLEX_FULL;
-	else
-		phydev->duplex = DUPLEX_HALF;
-
-	switch (status & MII_M1011_PHY_STATUS_SPD_MASK) {
-	case MII_M1011_PHY_STATUS_1000:
-		phydev->speed = SPEED_1000;
-		break;
-
-	case MII_M1011_PHY_STATUS_100:
-		phydev->speed = SPEED_100;
-		break;
-
-	default:
-		phydev->speed = SPEED_10;
-		break;
-	}
-
 	return 0;
 }
 
-- 
2.26.0

