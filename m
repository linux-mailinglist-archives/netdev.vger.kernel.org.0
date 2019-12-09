Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB25A117027
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLIPSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:18:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35426 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfLIPSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=shbtuvf8tn/7bQPfQ0S85b8rkHI5BoP51CbFF6hBUxU=; b=O3ZXxNlWKQLwc3w5EmDkVKyN2K
        lzLB8bVXkSxanHRcaqWtk38UYSNzneUSvnChORlRUHJJOklR8sE4kFGtdc/qKIcvItMdXtKx3Lrr+
        KMX7HiUmJpn+rWOKD94mgmHMaLw4U02p81sYGIiBIK517NIsc7UrHgM/iRy0g1dv30UhDHewF6nEA
        LIIU5vQqSrizaYdhtBV3ypJXoR3cweJZMq98MBxDGsdeqYh9ZDmEaalbcGZ3lOzgdEYEobKs7TNL6
        T9nXfhPKP9Y2bqx802eDt36LYO37v2pR9hHL6nLNiC0O3zsi3/gv6pRZtSqEukqGfLUWa/8d+enZ5
        4DKDWE+g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54600 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKnt-0003pr-NZ; Mon, 09 Dec 2019 15:18:29 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieKnt-0004uY-4b; Mon, 09 Dec 2019 15:18:29 +0000
In-Reply-To: <20191209151553.GP25745@shell.armlinux.org.uk>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 01/14] net: sfp: remove incomplete 100BASE-FX and
 100BASE-LX support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieKnt-0004uY-4b@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 15:18:29 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 100BASE-FX and 100BASE-LX support assumes a PHY is present; this
is probably an incorrect assumption. In any case, sfp_parse_support()
will fail such a module. Let's stop pretending we support these
modules.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c |  4 +---
 drivers/net/phy/sfp.c     | 13 +------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 5a72093ab6e7..02ab07624c89 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -342,9 +342,7 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	if (phylink_test(link_modes, 2500baseX_Full))
 		return PHY_INTERFACE_MODE_2500BASEX;
 
-	if (id->base.e1000_base_t ||
-	    id->base.e100_base_lx ||
-	    id->base.e100_base_fx)
+	if (id->base.e1000_base_t)
 		return PHY_INTERFACE_MODE_SGMII;
 
 	if (phylink_test(link_modes, 1000baseX_Full))
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 27360d1840b2..ae6a52a19458 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1489,18 +1489,7 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 
 static void sfp_sm_probe_for_phy(struct sfp *sfp)
 {
-	/* Setting the serdes link mode is guesswork: there's no
-	 * field in the EEPROM which indicates what mode should
-	 * be used.
-	 *
-	 * If it's a gigabit-only fiber module, it probably does
-	 * not have a PHY, so switch to 802.3z negotiation mode.
-	 * Otherwise, switch to SGMII mode (which is required to
-	 * support non-gigabit speeds) and probe for a PHY.
-	 */
-	if (sfp->id.base.e1000_base_t ||
-	    sfp->id.base.e100_base_lx ||
-	    sfp->id.base.e100_base_fx)
+	if (sfp->id.base.e1000_base_t)
 		sfp_sm_probe_phy(sfp);
 }
 
-- 
2.20.1

