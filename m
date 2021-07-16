Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65F33CBBCD
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 20:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhGPS02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 14:26:28 -0400
Received: from phobos.denx.de ([85.214.62.61]:53494 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPS00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 14:26:26 -0400
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E0CF282BE8;
        Fri, 16 Jul 2021 20:23:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1626459810;
        bh=3r5fIQrYWK0hiHreSsehhPP7aroB2oCq1VtKIF/snPI=;
        h=From:To:Cc:Subject:Date:From;
        b=pPkTAnnZkiHCA/DbBlaNKTkXH27eYLEnotn3twms8um0xfZ9YQNgiewLRhjJirNGh
         C0uHYI/IR3YVOUsdXbwGNsvDiiI8kllQ06CF7tqSS/4AidSewtWDMkEqRjtxpgdKg4
         rXLUxECtzT/N3R7UYr09h0eXAPdVrO05u+vO4HrNXjOcmCJkp197cWYD/VPuHmSg+d
         FY+kO29HSJ5Vm83ZoqLPkGbeVYtQ+/CclAW55EaE8kLuZfMSupJKdltEiotjd5Qun5
         ifFa3NHt3HLErObanSlMpsjs+rN5JFvD0zZBs20Eq9zV11YYuz2+buglpMDpmrP2KI
         RHV9nSlTGzysQ==
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: phy: Add RGMII_ID/TXID/RXID handling to the DP83822 driver
Date:   Fri, 16 Jul 2021 20:23:28 +0200
Message-Id: <20210716182328.218768-1-marex@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting the internal clock shift of the PHY based on
the interface requirements. RX/TX/both is supported for RGMII.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/dp83822.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index f7a2ec150e54..971c8d6b85d2 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -72,6 +72,10 @@
 #define DP83822_ANEG_ERR_INT_EN		BIT(6)
 #define DP83822_EEE_ERROR_CHANGE_INT_EN	BIT(7)
 
+/* RCSR bits */
+#define DP83822_RGMII_RX_CLOCK_SHIFT	BIT(12)
+#define DP83822_RGMII_TX_CLOCK_SHIFT	BIT(11)
+
 /* INT_STAT1 bits */
 #define DP83822_WOL_INT_EN	BIT(4)
 #define DP83822_WOL_INT_STAT	BIT(12)
@@ -326,11 +330,36 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
 
 static int dp8382x_disable_wol(struct phy_device *phydev)
 {
-	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
-		    DP83822_WOL_SECURE_ON;
+	u16 val = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON;
+
+	ret = phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
+				 MII_DP83822_WOL_CFG, val);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		ret = phy_modify_mmd(phydev, DP83822_DEVADDR, MII_DP83822_RCSR,
+				     DP83822_RGMII_RX_CLOCK_SHIFT,
+				     DP83822_RGMII_RX_CLOCK_SHIFT);
+	} else {
+		ret = phy_modify_mmd(phydev, DP83822_DEVADDR, MII_DP83822_RCSR,
+				     DP83822_RGMII_RX_CLOCK_SHIFT, 0);
+	}
+	if (ret < 0)
+		return ret;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		ret = phy_modify_mmd(phydev, DP83822_DEVADDR, MII_DP83822_RCSR,
+				     DP83822_RGMII_TX_CLOCK_SHIFT,
+				     DP83822_RGMII_TX_CLOCK_SHIFT);
+	} else {
+		ret = phy_modify_mmd(phydev, DP83822_DEVADDR, MII_DP83822_RCSR,
+				     DP83822_RGMII_TX_CLOCK_SHIFT, 0);
+	}
 
-	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
-				  MII_DP83822_WOL_CFG, value);
+	return ret;
 }
 
 static int dp83822_read_status(struct phy_device *phydev)
-- 
2.30.2

