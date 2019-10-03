Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26071CAE68
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbfJCSoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:44:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42574 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfJCSoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:44:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so1912308pls.9;
        Thu, 03 Oct 2019 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2zykc3aIa4pRoxK9eihG+83EwwxjGFm5ctchyIo+HaI=;
        b=mE65RoOFj4VFuDMRx6anpOikl7WDLVt0K8+HiD6p4wyBWqIKVM8IgwFXh7ikK+DFmW
         JcdeIggzyxjHoWJW4GkS6mx1g3mhkj0ErOa2F56BDKis1tLg2kJFwl9+DyrntuhmGGaY
         3oTxDOy8rENeWJF8gLWnYAaer2dTBw3ygpnWXiGuYDSjWThqdiqN6q7AMzh5DtL3g2UZ
         qQQEXYRXq652+vz6RFR2WRGcVEets1az6PSDi4f9N+cTwjOBHoF++mW2FdlERQKpBlOY
         6unfXXqdKPEUyGK9YvLMn2OnHJyZ1nuwMkhAH8KK2oxGVOXWiSLOY1sZoaTKZygh7RFu
         Da4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2zykc3aIa4pRoxK9eihG+83EwwxjGFm5ctchyIo+HaI=;
        b=LEsVMLzNQCprpVr3cTO+b81SGOc9IN+HG3mxNTnMQFRXcdvRZb9zVtBTa0XyWVmVeV
         ZC3n3hXembfR782HHmUslRxcYq3m8ZNhh5doRsmk8fHATmNsZShP2dZv9B5pdD8oDsoo
         TdTQ8GMpqf8C9TScdqkrD7StsYCZBvyi8tYjR+X9RWx72g3EQbrw7tkQdbHri4Nv/j3B
         mdt9U7oxIker3nO1kMRXQ5t5VjR5g6J8J/R7Q4J3m3JlF0gp0Ns28Vqy84e6Az6Px4Ih
         l9+YIRUZte+/9XJ4Yo1G3YKJXonoVB4uAQqhiFKaL5Dt3SLVXSe+eZT8bx+DBNaFdhdb
         /qCA==
X-Gm-Message-State: APjAAAXt+LEIeYd+lTrz+oH4E+VUE7XQ3SD8OsqqRpZe9aew1fLf6uya
        vViwRFlhFy+Wv/EBH1eda2ts574h
X-Google-Smtp-Source: APXvYqwtIG33yCwYu8qdw8jZIOqf2kJEkqHo8XNTly/DI92Ej7oI7T7PhejIx/EKr0oMHOZscDRI5w==
X-Received: by 2002:a17:902:7c0c:: with SMTP id x12mr11189557pll.238.1570128242589;
        Thu, 03 Oct 2019 11:44:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm3568268pje.27.2019.10.03.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 11:44:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        olteanv@gmail.com, rafal@milecki.pl
Subject: [PATCH 2/2] net: phy: broadcom: Use bcm54xx_config_clock_delay() for BCM54612E
Date:   Thu,  3 Oct 2019 11:43:52 -0700
Message-Id: <20191003184352.24356-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003184352.24356-1-f.fainelli@gmail.com>
References: <20191003184352.24356-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm54612e_config_init() duplicates what bcm54xx_config_clock_delay()
does with respect to configuring RGMII TX/RX delays appropriately.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 5e956089bf52..4313c74b4fd8 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -47,26 +47,7 @@ static int bcm54612e_config_init(struct phy_device *phydev)
 {
 	int reg;
 
-	/* Clear TX internal delay unless requested. */
-	if ((phydev->interface != PHY_INTERFACE_MODE_RGMII_ID) &&
-	    (phydev->interface != PHY_INTERFACE_MODE_RGMII_TXID)) {
-		/* Disable TXD to GTXCLK clock delay (default set) */
-		/* Bit 9 is the only field in shadow register 00011 */
-		bcm_phy_write_shadow(phydev, 0x03, 0);
-	}
-
-	/* Clear RX internal delay unless requested. */
-	if ((phydev->interface != PHY_INTERFACE_MODE_RGMII_ID) &&
-	    (phydev->interface != PHY_INTERFACE_MODE_RGMII_RXID)) {
-		reg = bcm54xx_auxctl_read(phydev,
-					  MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
-		/* Disable RXD to RXC delay (default set) */
-		reg &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN;
-		/* Clear shadow selector field */
-		reg &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MASK;
-		bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
-				     MII_BCM54XX_AUXCTL_MISC_WREN | reg);
-	}
+	bcm54xx_config_clock_delay(phydev);
 
 	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
 	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
-- 
2.17.1

