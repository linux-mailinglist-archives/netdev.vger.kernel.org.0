Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4C26CAB69
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbjC0REA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjC0RDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:03:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A887A40FB
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qV5A0SpBL70ac4TSWLNy5rx10yTs2pKbS0vAF3V5vlg=; b=NPEsmeOQxo6jcwn7AozTBPZ00f
        9bdezLnbARrVzScT8Y3BG33JzRjQSTdHD4RJRCAQJTD1qyTmX7n8GSDkmoJqJ9/lxkvwSEt1ZLgRr
        nCFzvB/3fYQ3TKYSYjaNI3p6R50U8NZ14jkbVBcRY96XYQXCHZdIs8nkeUhwBIyNpRpE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEW-008Xtg-2k; Mon, 27 Mar 2023 19:02:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 23/23] net: phy: Disable EEE advertisement by default
Date:   Mon, 27 Mar 2023 19:02:01 +0200
Message-Id: <20230327170201.2036708-24-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE should only be advertised if the MAC supports it. Clear
advertising_eee by default. If the MAC indicates it supports EEE by
calling phy_support_eee() advertising_eee will be set to
supported_eee. When the PHY is started, EEE registers will then be
configured.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 30f07623637b..d571738be3d8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3153,24 +3153,11 @@ static int phy_probe(struct device *dev)
 	of_set_phy_supported(phydev);
 	phy_advertise_supported(phydev);
 
-	/* Get PHY default EEE advertising modes and handle them as potentially
-	 * safe initial configuration.
+	/* Clear EEE advertising until the MAC indicates it also
+	   supports EEE.
 	 */
-	err = genphy_c45_read_eee_adv(phydev, phydev->advertising_eee);
-	if (err)
-		goto out;
-
-	/* There is no "enabled" flag. If PHY is advertising, assume it is
-	 * kind of enabled.
-	 */
-	phydev->eee_enabled = !linkmode_empty(phydev->advertising_eee);
-
-	/* Some PHYs may advertise, by default, not support EEE modes. So,
-	 * we need to clean them.
-	 */
-	if (phydev->eee_enabled)
-		linkmode_and(phydev->advertising_eee, phydev->supported_eee,
-			     phydev->advertising_eee);
+	linkmode_zero(phydev->advertising_eee);
+	phydev->eee_enabled = false;
 
 	/* Get the EEE modes we want to prohibit. We will ask
 	 * the PHY stop advertising these mode later on
-- 
2.39.2

