Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BBA15FF12
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBOPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:49:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34080 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=37Dv1wF77KoudRbiiWJlA926Ssn8gGaZJ39sVGHQzDU=; b=N53fYbAn9Bfb3V/cgWKUNr6TAB
        f0S3xDipCPTR6DdGNyI2eKx1a/t3fm1qLMtFIFHzOdT6ku/oWwzmQTcL19iTyVGG7Qjwo/srQNL/h
        54uKN4D0dYLHGOfwKFbx2tcH9MtUKB/hIvMruSheXfXkyRlfpIB+MszNjuTVvs6WgXDlOCTuKAzdR
        Xn3jSeZzAh6Esii9gB/W9SAgwQr6cHCPIVWZGuZhp2Oz5C/RsWqzsvECB9jEmOYvfLxxbHeIY3usA
        P/oXEGEeoyWBkoi5N6Uo60n8066ZjCGpumuQavokznwU61iAhSJMoinpDn4m+dgmDRvQO3Y7ZZvzZ
        iUiYTqhA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57244 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhF-0005jR-L8; Sat, 15 Feb 2020 15:49:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhE-0003XA-E4; Sat, 15 Feb 2020 15:49:32 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 03/10] net: add linkmode helper for setting flow
 control advertisement
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhE-0003XA-E4@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:32 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a linkmode helper to set the flow control advertisement in an
ethtool linkmode mask according to the tx/rx capabilities. This
implementation is moved from phylib, and documented with an
analysis of its shortcomings.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/linkmode.c   | 51 ++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 17 +-----------
 include/linux/linkmode.h     |  2 ++
 3 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
index 969918795228..f60560fe3499 100644
--- a/drivers/net/phy/linkmode.c
+++ b/drivers/net/phy/linkmode.c
@@ -42,3 +42,54 @@ void linkmode_resolve_pause(const unsigned long *local_adv,
 	}
 }
 EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
+
+/**
+ * linkmode_set_pause - set the pause mode advertisement
+ * @advertisement: advertisement in ethtool format
+ * @tx: boolean from ethtool struct ethtool_pauseparam tx_pause member
+ * @rx: boolean from ethtool struct ethtool_pauseparam rx_pause member
+ *
+ * Configure the advertised Pause and Asym_Pause bits according to the
+ * capabilities of provided in @tx and @rx.
+ *
+ * We convert as follows:
+ *  tx rx  Pause AsymDir
+ *  0  0   0     0
+ *  0  1   1     1
+ *  1  0   0     1
+ *  1  1   1     0
+ *
+ * Note: this translation from ethtool tx/rx notation to the advertisement
+ * is actually very problematical. Here are some examples:
+ *
+ * For tx=0 rx=1, meaning transmit is unsupported, receive is supported:
+ *
+ *  Local device  Link partner
+ *  Pause AsymDir Pause AsymDir Result
+ *    1     1       1     0     TX + RX - but we have no TX support.
+ *    1     1       0     1	Only this gives RX only
+ *
+ * For tx=1 rx=1, meaning we have the capability to transmit and receive
+ * pause frames:
+ *
+ *  Local device  Link partner
+ *  Pause AsymDir Pause AsymDir Result
+ *    1     0       0     1     Disabled - but since we do support tx and rx,
+ *				this should resolve to RX only.
+ *
+ * Hence, asking for:
+ *  rx=1 tx=0 gives Pause+AsymDir advertisement, but we may end up
+ *            resolving to tx+rx pause or only rx pause depending on
+ *            the partners advertisement.
+ *  rx=0 tx=1 gives AsymDir only, which will only give tx pause if
+ *            the partners advertisement allows it.
+ *  rx=1 tx=1 gives Pause only, which will only allow tx+rx pause
+ *            if the other end also advertises Pause.
+ */
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertisement, rx);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertisement,
+			 rx ^ tx);
+}
+EXPORT_SYMBOL_GPL(linkmode_set_pause);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f5a7a077ec1f..2a973265de80 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2361,22 +2361,7 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
 
 	linkmode_copy(oldadv, phydev->advertising);
-
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-			   phydev->advertising);
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-			   phydev->advertising);
-
-	if (rx) {
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				 phydev->advertising);
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				 phydev->advertising);
-	}
-
-	if (tx)
-		linkmode_change_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				    phydev->advertising);
+	linkmode_set_pause(phydev->advertising, tx, rx);
 
 	if (!linkmode_equal(oldadv, phydev->advertising) &&
 	    phydev->autoneg)
diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index 9ec210f31d06..c664c27a29a0 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -92,4 +92,6 @@ void linkmode_resolve_pause(const unsigned long *local_adv,
 			    const unsigned long *partner_adv,
 			    bool *tx_pause, bool *rx_pause);
 
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx);
+
 #endif /* __LINKMODE_H */
-- 
2.20.1

