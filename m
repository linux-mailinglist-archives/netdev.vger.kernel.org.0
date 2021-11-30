Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C8446390D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245371AbhK3PHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244778AbhK3PCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:02:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D43C08EACB
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xn0ImqhUoIfk30KSxW7TKlCShEeT2+yq/tEAQnylrJ4=; b=fm18l+SZDk0ADp4Z7gG6Jr2Hqk
        FfaRKhAjSRY2zUrbmkZybKimhZvbWTfqu7sJmTDSL9UshvMNp+f+L+Db2r+uu6wfjpQXFUn+XRseb
        pifQMJ0dDB8GOZUxxgOqOOVgORlWZhajBdQTDio2XsFSmm53cWIsAWEZVX1bwt26M3octUlHGSpjW
        aMFl5nMbY5AK0nNyDr4emBOS66lUL8FngAKpiNJ36lJ6/uASqei1mt445sEjj5A4CFHb6k0dSm7UN
        W/p5QgBgXWxx7/47FdfnjnjU0v74zrIIz5o9LkpPjlnAG/+XsXPEjzUij3HJjriWdL5s5n7pvrxcb
        wDHSFlEw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40190 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms4WE-00073P-4b; Tue, 30 Nov 2021 14:54:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms4WD-00EKLK-Ld; Tue, 30 Nov 2021 14:54:05 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: mvneta: program 1ms autonegotiation clock
 divisor
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ms4WD-00EKLK-Ld@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 30 Nov 2021 14:54:05 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program the 1ms autonegotiation clock divisor according to the clocking
rate of neta - without this, the 1ms clock ticks at about 660us on
Armada 38x configured for 250MHz. Bring this into correct specification.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2368ae3f0e10..ce810fc3c1a2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3948,7 +3948,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII mode receives the state from the PHY */
 		new_ctrl2 |= MVNETA_GMAC2_INBAND_AN_ENABLE;
-		new_clk |= MVNETA_GMAC_1MS_CLOCK_ENABLE;
+		new_clk = MVNETA_GMAC_1MS_CLOCK_ENABLE;
 		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
 				     MVNETA_GMAC_FORCE_LINK_PASS |
 				     MVNETA_GMAC_CONFIG_MII_SPEED |
@@ -3960,7 +3960,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	} else {
 		/* 802.3z negotiation - only 1000base-X */
 		new_ctrl0 |= MVNETA_GMAC0_PORT_1000BASE_X;
-		new_clk |= MVNETA_GMAC_1MS_CLOCK_ENABLE;
+		new_clk = MVNETA_GMAC_1MS_CLOCK_ENABLE;
 		new_an = (new_an & ~(MVNETA_GMAC_FORCE_LINK_DOWN |
 				     MVNETA_GMAC_FORCE_LINK_PASS |
 				     MVNETA_GMAC_CONFIG_MII_SPEED)) |
@@ -3973,6 +3973,10 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 			new_an |= MVNETA_GMAC_AN_FLOW_CTRL_EN;
 	}
 
+	/* Set the 1ms clock divisor */
+	if (new_clk == MVNETA_GMAC_1MS_CLOCK_ENABLE)
+		new_clk |= clk_get_rate(pp->clk) / 1000;
+
 	/* Armada 370 documentation says we can only change the port mode
 	 * and in-band enable when the link is down, so force it down
 	 * while making these changes. We also do this for GMAC_CTRL2
-- 
2.30.2

