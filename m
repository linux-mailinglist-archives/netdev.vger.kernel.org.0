Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08824637DF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbhK3O4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbhK3Oyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:54:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AF5C061763
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 06:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YEinrairKTdo02mxPsf+96PtVu7lPvrxZkoITCgtFVU=; b=g5GA/AqNB0yO5EKUEQRxzPrwaW
        pFiew24xpnQmaDeRZOVU00jYfwuesfECR34XzEmKMC9OmALjKIzI+TglVOtQMBtIoN3byyFpcmuHs
        GUqFLI5EHGcm/ubnR1ZxrZlKvjxS27eBxGjgY5kFj0Zn4h6nAcaZ3O0M2KUdwkO7bEP8G8SkErJ6/
        vb7TzzvQrhYdkZUbNKeIqTHNavXLc84HC6VZ6vBoE1PrXDIqZNdRBTkKE3yIsBJrqtg16UtXW//5b
        Lf75Apolcr6f6b1rvJy5PC4/Lnx3izNc+P0PwFOqsDbntlKHwdF0yDz6K6XqgRndTEcx0XCdtf4zL
        cquiCftw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40154 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms4Rx-00073E-Ua; Tue, 30 Nov 2021 14:49:42 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms4Rx-00EKEc-En; Tue, 30 Nov 2021 14:49:41 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: tidy up disable bit clearing
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 30 Nov 2021 14:49:41 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tidy up the disable bit clearing where we clear a bit and the run the
link resolver.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index eacbb0e6a24b..8e3861f09b4f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1090,6 +1090,12 @@ static void phylink_run_resolve_and_disable(struct phylink *pl, int bit)
 	}
 }
 
+static void phylink_enable_and_run_resolve(struct phylink *pl, int bit)
+{
+	clear_bit(bit, &pl->phylink_disable_state);
+	phylink_run_resolve(pl);
+}
+
 static void phylink_fixed_poll(struct timer_list *t)
 {
 	struct phylink *pl = container_of(t, struct phylink, link_poll);
@@ -1574,8 +1580,7 @@ void phylink_start(struct phylink *pl)
 	 */
 	phylink_mac_initial_config(pl, true);
 
-	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
-	phylink_run_resolve(pl);
+	phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_STOPPED);
 
 	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
 		int irq = gpiod_to_irq(pl->link_gpio);
@@ -1715,8 +1720,7 @@ void phylink_resume(struct phylink *pl)
 		phylink_mac_initial_config(pl, true);
 
 		/* Re-enable and re-resolve the link parameters */
-		clear_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
-		phylink_run_resolve(pl);
+		phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_MAC_WOL);
 	} else {
 		phylink_start(pl);
 	}
@@ -2645,8 +2649,7 @@ static void phylink_sfp_link_up(void *upstream)
 
 	ASSERT_RTNL();
 
-	clear_bit(PHYLINK_DISABLE_LINK, &pl->phylink_disable_state);
-	phylink_run_resolve(pl);
+	phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_LINK);
 }
 
 /* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
-- 
2.30.2

