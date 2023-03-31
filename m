Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA876D147A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCaA4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCaAzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A35D322
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cfp1FqY7Y8E92284N8DFBdTLetOjaw0pAoiT5v+E6D8=; b=Z+Z8vF87nB19u46tqStAFy4Ome
        ETzpMW6tX4MPVtpBG+TjQnGW/O8bg2B5O3EA3t00WEfcHulfgj0KpVpN7ZCOrkNkd7wOYgeNz2ZCR
        Q30jKeZgrgOusKhFXvtv4QJIrEYUvQYbcUS7dVT5c+yEYgX1C1ws5i0dPk2mlk3XK0L8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33M-008xLd-8G; Fri, 31 Mar 2023 02:55:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 24/24] net: phy: Disable EEE advertisement by default
Date:   Fri, 31 Mar 2023 02:55:18 +0200
Message-Id: <20230331005518.2134652-25-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
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
index 30f07623637b..0a5936a81ee6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3153,24 +3153,11 @@ static int phy_probe(struct device *dev)
 	of_set_phy_supported(phydev);
 	phy_advertise_supported(phydev);
 
-	/* Get PHY default EEE advertising modes and handle them as potentially
-	 * safe initial configuration.
+	/* Clear EEE advertising until the MAC indicates it also
+	 * supports EEE.
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
2.40.0

