Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E553A515F97
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243825AbiD3Rec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiD3Rea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:34:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F7C3701D
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BioyjDVinakaLEAY/8tf/sHKY9WXKFdP50pgysMiSpU=; b=S44bQUUEQ1g261UCrgWrn/qliT
        zsZPtQWHT8XLc9iZz4FzkehorfP2iC0cB23ulY04iX2EobsBvMkRCaMdyVwtk8jMRuM4E1Z4L2f4r
        zIAqUi6c+jwoU29+2Ciwgk6td3kEXIDaKm8S5/gDLysbdOx6mJpbFu6c44jbKvb2ydqs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkqvl-000eoH-5u; Sat, 30 Apr 2022 19:30:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 1/5] net: phylink: Convert to mdiobus_c45_{read|write}
Date:   Sat, 30 Apr 2022 19:30:33 +0200
Message-Id: <20220430173037.156823-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220430173037.156823-1-andrew@lunn.ch>
References: <20220430173037.156823-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop using the helpers to construct a special phy address which
indicates C45. Instead use the C45 accessors, which will call the
busses C45 specific read/write API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phylink.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 33c285252584..83499481e793 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2301,8 +2301,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 	if (mdio_phy_id_is_c45(phy_id)) {
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
-		devad = mdiobus_c45_addr(devad, reg);
-	} else if (phydev->is_c45) {
+		return mdiobus_c45_read(pl->phydev->mdio.bus, prtad, devad,
+					reg);
+	}
+
+	if (phydev->is_c45) {
 		switch (reg) {
 		case MII_BMCR:
 		case MII_BMSR:
@@ -2324,12 +2327,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
 			return -EINVAL;
 		}
 		prtad = phy_id;
-		devad = mdiobus_c45_addr(devad, reg);
-	} else {
-		prtad = phy_id;
-		devad = reg;
+		return mdiobus_c45_read(pl->phydev->mdio.bus, prtad, devad,
+					reg);
 	}
-	return mdiobus_read(pl->phydev->mdio.bus, prtad, devad);
+
+	return mdiobus_read(pl->phydev->mdio.bus, phy_id, reg);
 }
 
 static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
@@ -2341,8 +2343,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 	if (mdio_phy_id_is_c45(phy_id)) {
 		prtad = mdio_phy_id_prtad(phy_id);
 		devad = mdio_phy_id_devad(phy_id);
-		devad = mdiobus_c45_addr(devad, reg);
-	} else if (phydev->is_c45) {
+		return mdiobus_c45_write(pl->phydev->mdio.bus, prtad, devad,
+					 reg, val);
+	}
+
+	if (phydev->is_c45) {
 		switch (reg) {
 		case MII_BMCR:
 		case MII_BMSR:
@@ -2363,14 +2368,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
 		default:
 			return -EINVAL;
 		}
-		prtad = phy_id;
-		devad = mdiobus_c45_addr(devad, reg);
-	} else {
-		prtad = phy_id;
-		devad = reg;
+		return mdiobus_c45_write(pl->phydev->mdio.bus, phy_id, devad,
+					 reg, val);
 	}
 
-	return mdiobus_write(phydev->mdio.bus, prtad, devad, val);
+	return mdiobus_write(phydev->mdio.bus, phy_id, reg, val);
 }
 
 static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
-- 
2.35.2

