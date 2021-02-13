Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2F231A9CA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 04:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhBMDrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 22:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhBMDrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 22:47:18 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2363C061756;
        Fri, 12 Feb 2021 19:46:37 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z15so747910pfc.3;
        Fri, 12 Feb 2021 19:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TBmeTOvvLEyeKvYi7UxAA6GFutE9ZvCzYPjuoJndh9A=;
        b=sKg7P3H4BvcFKh6hnMh3ob8p8CAFPVmd9b4JJ7WfTS4DpDGLL09W0CaLl3ddwnwy1r
         S+55w9ShjYEnBl7b9B+f5MUqlh4W8/Ws+NfZOOSlgNQNi8hA2ks3r2yJXLJweA9ceQR2
         rb7JZ27moJPmxXGq9a1awJ+hKSV7KMuGen1cdYjrmica6iViMyOauR5cK213KTqBTHhT
         DoKc3pII1CpiisxXwK6z4bglY4F8b9RaQsCqZ+nzGw1VmIUYOsB7y43eJrKOzexWTVCI
         npNPrBEdHI8BrpaTdbteW5qwuiQ5y2T7igZnnCwsCddFwit0KjWjj6i+sR7N7lgjqrnj
         7bEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TBmeTOvvLEyeKvYi7UxAA6GFutE9ZvCzYPjuoJndh9A=;
        b=uoGed/3vRI2vpJXD5KceBs8wvTi0jUIlBSr5yKNveMQFfGxeGCfHBlbIPyMZ0e5K1F
         eIjyAZEKjGGuUhoo84iyOjn06P3AmUkhHQOWxjJjvc8zkGkx3m+WVQ4DS8VS94AIg7yp
         a3kUkBBJfGHok67rDyKCQLEbjqWbIT9TZykiE1k4ganuu2lghksxgQBnJFJ2yyis29N6
         h4k6O0Xt5AQ5JjyJd7bYkPFBoQol+alOuwcASU1lCSVepa7zZ0j1XRgteiPdPd0MDRJx
         UKcFLm/XzvOJ3w0kH0SRChkFgMN19OT4PnRGso9kwB/lgaMatVceqXj2wEzQhBFwpGTA
         BqHQ==
X-Gm-Message-State: AOAM532Stsku5Zqn1bv6n5gHVyRr4Xbjl7C4cSptdZMCwSOF1ppyvnA7
        /rL46NY8y1lh04L6ln4M2oiHndnjFfM=
X-Google-Smtp-Source: ABdhPJx2rMPGpKigW1CofWSnKP32W1cZUGN7xIqXDdn+1mo93C5Awa99xg8TbLHze74kXRJXPWysTg==
X-Received: by 2002:a63:4713:: with SMTP id u19mr5912488pga.209.1613187997023;
        Fri, 12 Feb 2021 19:46:37 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y14sm10399057pfg.9.2021.02.12.19.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:46:36 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next v2 1/3] net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()
Date:   Fri, 12 Feb 2021 19:46:30 -0800
Message-Id: <20210213034632.2420998-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213034632.2420998-1-f.fainelli@gmail.com>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a forward declaration by moving the callers of
bcm54xx_config_clock_delay() below its body.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 74 +++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 0472b3470c59..4142f69c1530 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -26,44 +26,6 @@ MODULE_DESCRIPTION("Broadcom PHY driver");
 MODULE_AUTHOR("Maciej W. Rozycki");
 MODULE_LICENSE("GPL");
 
-static int bcm54xx_config_clock_delay(struct phy_device *phydev);
-
-static int bcm54210e_config_init(struct phy_device *phydev)
-{
-	int val;
-
-	bcm54xx_config_clock_delay(phydev);
-
-	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
-		val = phy_read(phydev, MII_CTRL1000);
-		val |= CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER;
-		phy_write(phydev, MII_CTRL1000, val);
-	}
-
-	return 0;
-}
-
-static int bcm54612e_config_init(struct phy_device *phydev)
-{
-	int reg;
-
-	bcm54xx_config_clock_delay(phydev);
-
-	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
-	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
-		int err;
-
-		reg = bcm_phy_read_exp(phydev, BCM54612E_EXP_SPARE0);
-		err = bcm_phy_write_exp(phydev, BCM54612E_EXP_SPARE0,
-					BCM54612E_LED4_CLK125OUT_EN | reg);
-
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
-}
-
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -105,6 +67,42 @@ static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54210e_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	bcm54xx_config_clock_delay(phydev);
+
+	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
+		val = phy_read(phydev, MII_CTRL1000);
+		val |= CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER;
+		phy_write(phydev, MII_CTRL1000, val);
+	}
+
+	return 0;
+}
+
+static int bcm54612e_config_init(struct phy_device *phydev)
+{
+	int reg;
+
+	bcm54xx_config_clock_delay(phydev);
+
+	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
+	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
+		int err;
+
+		reg = bcm_phy_read_exp(phydev, BCM54612E_EXP_SPARE0);
+		err = bcm_phy_write_exp(phydev, BCM54612E_EXP_SPARE0,
+					BCM54612E_LED4_CLK125OUT_EN | reg);
+
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 /* Needs SMDSP clock enabled via bcm54xx_phydsp_config() */
 static int bcm50610_a0_workaround(struct phy_device *phydev)
 {
-- 
2.25.1

