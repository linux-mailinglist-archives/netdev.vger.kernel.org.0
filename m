Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB68231A9CD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 04:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhBMDrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 22:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhBMDrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 22:47:20 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CE5C061786;
        Fri, 12 Feb 2021 19:46:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d13so857337plg.0;
        Fri, 12 Feb 2021 19:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ycEZD6+lGycl7jzGlqgxg/WeXj7vcT8Oor6/VJW+6Uo=;
        b=sDXdUOIqZLgSJqhQUBczAKHhu+hl3H/sBr7LzBsLxZPXox9Xt7u85ytWM2OYL84gxz
         IcePSId8RJ0Jf/73iTEiLPuggDaQzSYs3qwnyfJuImPb0pg9l2MaIEdKLT/GPY6u6lPY
         hOtKhw1AJbJbmIs/zJV1aK/MaO2e2MqTVwXbrPgbtEP/fp1yEWKrQtszyGgO0ybrB+x9
         +A+n5d33CuPHG27mRRS6hhoeNb2Ln2DAcB4KYE/8gp8BZoMnfV0NlfGltEymmRny6plZ
         z6YYt292YFru7e4g4OKn+Fg7bP+LIEDzrJrh9rVoNUoI9BHcxa6Mf8tQk5n7CjgE8Z2P
         Xq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ycEZD6+lGycl7jzGlqgxg/WeXj7vcT8Oor6/VJW+6Uo=;
        b=WiIAJTxja4tjp4tpu0bvZsCS4ZGHvPblEgQCvqTrNLrXw96XielHkRM2koiS8BZK4P
         j78LJDzKbWCib/kHIq8Vm0iGwbT8L54X7fxlX8stxDv3NAxWoLwndFHdqvaYiC3j/Alu
         VcVtsFu1owfIOA/VdIhEjXDyHaB9cCf4OPpOARsHGj+BPWQuskN/hbRdkIENFn4vGK8x
         yDIQkjc+Qko92chvv5TT1aGC750yHV74xnFYgysZzHDmMSYqIF0L9bBKkM0nhkFhdQsX
         5xkQyKR1NevpsTyySY2WdvP4733TPFbbv7WCF1sAFDnm9WEi96RQdQqw6+iQCvyU1tax
         JE8Q==
X-Gm-Message-State: AOAM530dnTGueda5phSd1LIwlnFs4vb5azUwr05fI4w37m5JkPCJ8TPf
        lzbko1DudrwMA2qGtUopzKnk226Weqw=
X-Google-Smtp-Source: ABdhPJye//t3e87Yz+o9cWwSYRA2jTLHXEzAfT7+CdXS/C7TF+jq+OKmtgiwTsR6xfSqFEX31ygKXw==
X-Received: by 2002:a17:90a:4d88:: with SMTP id m8mr5605649pjh.45.1613187999699;
        Fri, 12 Feb 2021 19:46:39 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y14sm10399057pfg.9.2021.02.12.19.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:46:39 -0800 (PST)
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
Subject: [PATCH net-next v2 3/3] net: phy: broadcom: Allow BCM54210E to configure APD
Date:   Fri, 12 Feb 2021 19:46:32 -0800
Message-Id: <20210213034632.2420998-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213034632.2420998-1-f.fainelli@gmail.com>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM54210E/BCM50212E has been verified to work correctly with the
auto-power down configuration done by bcm54xx_adjust_rxrefclk(), add it
to the list of PHYs working.

While we are at it, provide an appropriate name for the bit we are
changing which disables the RXC and TXC during auto-power down when
there is no energy on the cable.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 8 +++++---
 include/linux/brcmphy.h    | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 3ce266ab521b..91fbd26c809e 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -193,6 +193,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54210E &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
 		return;
@@ -227,9 +228,10 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
 
 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
-		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
-		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
-			val |= BCM54810_SHD_SCR3_TRDDAPD;
+		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
+		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
+		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
+			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
 		else
 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
 	}
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 844dcfe789a2..16597d3fa011 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -193,6 +193,7 @@
 #define  BCM54XX_SHD_SCR3_DEF_CLK125	0x0001
 #define  BCM54XX_SHD_SCR3_DLLAPD_DIS	0x0002
 #define  BCM54XX_SHD_SCR3_TRDDAPD	0x0004
+#define  BCM54XX_SHD_SCR3_RXCTXC_DIS	0x0100
 
 /* 01010: Auto Power-Down */
 #define BCM54XX_SHD_APD			0x0a
@@ -253,7 +254,6 @@
 #define BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN	(1 << 0)
 #define BCM54810_SHD_CLK_CTL			0x3
 #define BCM54810_SHD_CLK_CTL_GTXCLK_EN		(1 << 9)
-#define BCM54810_SHD_SCR3_TRDDAPD		0x0100
 
 /* BCM54612E Registers */
 #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
-- 
2.25.1

