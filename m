Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926901A52F6
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDKQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 12:53:01 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:47606 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgDKQxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 12:53:01 -0400
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id B8ADDC72B3E;
        Sat, 11 Apr 2020 18:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1586623980;
        bh=jZBDMo4ZDtBc5dBRTHb4bv9HXY1GC/SNmnqUr4mAXIE=;
        h=From:To:Cc:Subject:Date:From;
        b=v7Jv0UJVhAabBoB7iLeJ2ThRVyNePCE9Ob18zso+SaVFnpG+YoFBadPWnvK9fEIgN
         lCC6HBAyIuM7ufrkHdAr12bVwGupE/Cf6SmFzfysxcWe7Zb38qECd+e2O24oIRMmGS
         79xT877W8bhlt5EUROM25AbxHjmNszb7YetBXcQQ=
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>
Subject: [PATCH v2] net: phy: marvell: Fix pause frame negotiation
Date:   Sat, 11 Apr 2020 18:51:25 +0200
Message-Id: <20200411165125.1091-1-clemens.gruber@pqgruber.com>
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

As the Marvell 88E1510 datasheet does not specify the timing between the
link status and the "Speed and Duplex Resolved" bit, we have to force
the link down as long as the resolved bit is not set, to avoid reporting
link up before we even have valid Speed/Duplex.

Tested with a Marvell 88E1510 (RGMII to Copper/1000Base-T)

Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
---
Changes since v1:
- Force link to 0 if resolved bit is not set as suggested by Russell King

 drivers/net/phy/marvell.c | 46 ++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 9a8badafea8a..561df5e33f65 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1278,6 +1278,30 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 	int lpa;
 	int err;
 
+	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
+		phydev->link = 0;
+		return 0;
+	}
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
@@ -1306,28 +1330,6 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
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

