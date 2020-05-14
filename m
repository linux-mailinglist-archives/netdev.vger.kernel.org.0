Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC25C1D2474
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgENBJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:09:02 -0400
Received: from 220-134-220-36.HINET-IP.hinet.net ([220.134.220.36]:52993 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgENBJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:09:01 -0400
Received: from ns.kevlo.org (localhost [127.0.0.1])
        by ns.kevlo.org (8.15.2/8.15.2) with ESMTPS id 04E0vaXM094977
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 14 May 2020 08:57:37 +0800 (CST)
        (envelope-from kevlo@ns.kevlo.org)
Received: (from kevlo@localhost)
        by ns.kevlo.org (8.15.2/8.15.2/Submit) id 04E0vYvb094976;
        Thu, 14 May 2020 08:57:34 +0800 (CST)
        (envelope-from kevlo)
Date:   Thu, 14 May 2020 08:57:33 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net: phy: broadcom: fix BCM54XX_SHD_SCR3_TRDDAPD
 value for BCM54810
Message-ID: <20200514005733.GA94953@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the correct bit when checking for PHY_BRCM_DIS_TXCRXC_NOENRGY on the 
BCM54810 PHY.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 97201d5cf007..45d0aefb964c 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -225,8 +225,12 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	else
 		val |= BCM54XX_SHD_SCR3_DLLAPD_DIS;
 
-	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY)
-		val |= BCM54XX_SHD_SCR3_TRDDAPD;
+	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
+		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810)
+			val |= BCM54810_SHD_SCR3_TRDDAPD;
+		else
+			val |= BCM54XX_SHD_SCR3_TRDDAPD;
+	}
 
 	if (orig != val)
 		bcm_phy_write_shadow(phydev, BCM54XX_SHD_SCR3, val);
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index d41624db6de2..1d339a862f7b 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -255,6 +255,7 @@
 #define BCM54810_EXP_BROADREACH_LRE_MISC_CTL_EN	(1 << 0)
 #define BCM54810_SHD_CLK_CTL			0x3
 #define BCM54810_SHD_CLK_CTL_GTXCLK_EN		(1 << 9)
+#define BCM54810_SHD_SCR3_TRDDAPD		0x0100
 
 /* BCM54612E Registers */
 #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
