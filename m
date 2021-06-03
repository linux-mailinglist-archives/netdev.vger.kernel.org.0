Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0986739A1BD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFCNC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhFCNC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:02:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF10C061756
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 06:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6UQLh47qu95+hAUITg8HdqHFRusFYyMT5PIWlE027j4=; b=LfzUhCwdK/v0f6JfMJ6qBo1wPH
        2MaCR1PibhjDhLeMbePVEDiAtvcNd/TFzHMawPIuB5trNEDMjjIdAzyFEkTzpie8BVD1pXR3Dy3YH
        mksFzJ8NLjxRGIhbH8I+kbWNNb3EGqH8w5GzMZOot4saoVmlbDquVlyyZs6dWmiwFVK71YqgGkwKn
        X8fsTX2vy7yNUXJ3cBLVksa7K4k0YsHTA+o6r5A2gwvyGRaSGKSxYqSfShRw7hFICHX1qMMf+WMd9
        20pz6QB9TzhYOuLyy3dc/6MWuaQufcNgoUgLPa02Iu6HsxyQ0F+AsAzMPxgU9tT5P//1i0oKkei0p
        D+dIa0og==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57494 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lomyF-0002m0-2C; Thu, 03 Jun 2021 14:01:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lomyE-0003mc-RP; Thu, 03 Jun 2021 14:01:10 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phy: marvell: use phy_modify_changed() for
 marvell_set_polarity()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Jun 2021 14:01:10 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than open-coding the phy_modify_changed() sequence, use this
helper in marvell_set_polarity().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index e6721c1c26c2..23751d95855b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -367,39 +367,24 @@ static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
 
 static int marvell_set_polarity(struct phy_device *phydev, int polarity)
 {
-	int reg;
-	int err;
-	int val;
-
-	/* get the current settings */
-	reg = phy_read(phydev, MII_M1011_PHY_SCR);
-	if (reg < 0)
-		return reg;
+	u16 val;
 
-	val = reg;
-	val &= ~MII_M1011_PHY_SCR_AUTO_CROSS;
 	switch (polarity) {
 	case ETH_TP_MDI:
-		val |= MII_M1011_PHY_SCR_MDI;
+		val = MII_M1011_PHY_SCR_MDI;
 		break;
 	case ETH_TP_MDI_X:
-		val |= MII_M1011_PHY_SCR_MDI_X;
+		val = MII_M1011_PHY_SCR_MDI_X;
 		break;
 	case ETH_TP_MDI_AUTO:
 	case ETH_TP_MDI_INVALID:
 	default:
-		val |= MII_M1011_PHY_SCR_AUTO_CROSS;
+		val = MII_M1011_PHY_SCR_AUTO_CROSS;
 		break;
 	}
 
-	if (val != reg) {
-		/* Set the new polarity value in the register */
-		err = phy_write(phydev, MII_M1011_PHY_SCR, val);
-		if (err)
-			return err;
-	}
-
-	return val != reg;
+	return phy_modify_changed(phydev, MII_M1011_PHY_SCR,
+				  MII_M1011_PHY_SCR_AUTO_CROSS, val);
 }
 
 static int marvell_config_aneg(struct phy_device *phydev)
-- 
2.20.1

