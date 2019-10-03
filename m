Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B184DCAE67
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbfJCSoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:44:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:47079 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfJCSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:44:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id a3so2247248pgm.13;
        Thu, 03 Oct 2019 11:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZJ8cu5edBCUcvp+R07u3Basm4+WGpKXDSlnnk4F2ItY=;
        b=P+3j0Llnml/5yIazX8wyYDYbZjE+8IowURBtuf0l88AffRW5/70PiynCSjmppAZvns
         HuczZCmaLax8PWP/vASA/FX1as37vIhW9xjWzJOQcBoZyNas2W8bYVgr2/XBE28Qt6yG
         kQSPcSVlra+HTtw8E6Z9Ije+T5d+VaKrVqtupLnCJ6g4ZgJdW9wTWE90EIRMipYIT1Ra
         rg0goxu2sY+Cd+2roSH1PH7+4esk8mHtmv5tBnxpKFJWrhEZRADYHTY6ApdHXSC22/Hn
         CJfpdwOlwuoiIGyfWe65eBm8dbbGuX4LtwuL10xjo1Qa7aD5qXUhHfmgrxDBOjJZeN8d
         bNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZJ8cu5edBCUcvp+R07u3Basm4+WGpKXDSlnnk4F2ItY=;
        b=b9Ni2ID6aIf0F8703Vz8hxV6S9uFSt711AnbzN/Raw1dyB44K2iJVucxVgJzIzvFyH
         6xjcxkh1vl+NxWvkOhvHvdggQd6brdk3FFJDpwKCehiWGAdFOeHjFdbgTfNnxuT2BB/F
         yquDMjGb8+h9lscExDS25L02/tKlKr0RAsxbN3FNVSwh4X8oEIAclgTzu/7zoyIiO7Ia
         qIefXaNkeO685jQQ/gBv+5A4olCz5xVeA2wQ0cBuA7i4GFg4unJGVADKA90wXwzq61Mj
         OINsnzAcreYjUst96AljQDCbbtZJZCXeoJlF79yIUu+o+kPg8OwXhhnHw/Up8m4+5hYv
         MKag==
X-Gm-Message-State: APjAAAXBFQmyipOT+12akxJq5QeTJKD8GDIIeJXUilW9vz8lykZ06CaS
        8jT0wDkWHL/axrA/8i8lJN/1lGTq
X-Google-Smtp-Source: APXvYqxmx5wHrjxtbL6/5qgcZRStHdYUQi08Z9aAvV7mdNd9jBXm9OI76MoewygccJPkjiqkN0U+8A==
X-Received: by 2002:a63:5342:: with SMTP id t2mr11117013pgl.417.1570128240184;
        Thu, 03 Oct 2019 11:44:00 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm3568268pje.27.2019.10.03.11.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 11:43:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        olteanv@gmail.com, rafal@milecki.pl
Subject: [PATCH 1/2] net: phy: broadcom: Fix RGMII delays configuration for BCM54210E
Date:   Thu,  3 Oct 2019 11:43:51 -0700
Message-Id: <20191003184352.24356-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003184352.24356-1-f.fainelli@gmail.com>
References: <20191003184352.24356-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0fc9ae107669 ("net: phy: broadcom: add support for
BCM54210E") added support for BCM54210E but also unconditionally cleared
the RXC to RXD skew and the TXD to TXC skew, thus only making
PHY_INTERFACE_MODE_RGMII a possible configuration. Use
bcm54xx_config_clock_delay() which correctly sets the registers
depending on the 4 possible PHY interface values that exist for RGMII.

Fixes: 0fc9ae107669 ("net: phy: broadcom: add support for BCM54210E")
Reported-by: Manasa Mudireddy <manasa.mudireddy@broadcom.com>
Reported-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 937d0059e8ac..5e956089bf52 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -26,18 +26,13 @@ MODULE_DESCRIPTION("Broadcom PHY driver");
 MODULE_AUTHOR("Maciej W. Rozycki");
 MODULE_LICENSE("GPL");
 
+static int bcm54xx_config_clock_delay(struct phy_device *phydev);
+
 static int bcm54210e_config_init(struct phy_device *phydev)
 {
 	int val;
 
-	val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
-	val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN;
-	val |= MII_BCM54XX_AUXCTL_MISC_WREN;
-	bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC, val);
-
-	val = bcm_phy_read_shadow(phydev, BCM54810_SHD_CLK_CTL);
-	val &= ~BCM54810_SHD_CLK_CTL_GTXCLK_EN;
-	bcm_phy_write_shadow(phydev, BCM54810_SHD_CLK_CTL, val);
+	bcm54xx_config_clock_delay(phydev);
 
 	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
 		val = phy_read(phydev, MII_CTRL1000);
-- 
2.17.1

