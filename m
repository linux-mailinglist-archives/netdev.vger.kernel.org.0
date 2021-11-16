Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13A8452EB4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhKPKMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhKPKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:12:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53547C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ldQW6ZEMywSbdgGYMPdCEC+0xDblPNMM4lZVskKQ0Q8=; b=pMxeRV4td5kO8IJ1JeIrBhU8Qz
        DTvSt/PFLwgj9WWDMaBiJaEhNMWVH2sY+ZZLbgk1KFxIYAAK9+AWSjUx63vZwYKLIOXpPDnWgfXZt
        VgK3PLtgOgZH4dTB/tJsUTKef5izSr0Ecw0XN2cJtYpFQN1qS/aC9CmFoN9MZdQnZLxVnHvFmt3FM
        skST1SL8zilskEmLjJN+LbgTlwt3eMO93zbC8wPEkV/jZ5rraY4pLSinqwlUY+QLQVilO5rNe8/xf
        8TcjwXUT3yRT6gyTgMTdctYv0zOG3Jm6SyPel9kojm5uc1rJ3pVpdboCGc72oxNbw+kRKRlCbPR9N
        TSiDPOLQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39854 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvPE-0000O1-P9; Tue, 16 Nov 2021 10:09:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvPE-0078fd-BV; Tue, 16 Nov 2021 10:09:36 +0000
In-Reply-To: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
References: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ocelot_net: remove interface checks in
 macb_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvPE-0078fd-BV@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 10:09:36 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode in the
validation function. Remove this to simplify it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 37c158df60ce..21df548dcf64 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1502,17 +1502,8 @@ static void vsc7514_phylink_validate(struct phylink_config *config,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct ocelot_port_private *priv = netdev_priv(ndev);
-	struct ocelot_port *ocelot_port = &priv->port;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {};
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != ocelot_port->phy_mode) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 
 	phylink_set(mask, Pause);
-- 
2.30.2

