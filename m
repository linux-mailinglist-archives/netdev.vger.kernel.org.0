Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9826246E588
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhLIJa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbhLIJa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:30:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE07C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 01:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LmrkliJWBKJIEwdtXm04u9l1XX1D9YLHNQXiAFlWplE=; b=qnZJaGxPE6RPsDKyik9TN4Uyls
        +txJJvg7Es1+ndVFc6bOQkGvoJIsaT63WcbOftIDujWma5oq5+ra6ey+TnmONrtKKAuPb3sCqdte9
        gEqSrNWVs7F6oHZpl23FpETYN1YNNj3aiCE5jAeCF528g5kICcJYTU0tLuY+y4do5HiZbNTq6hRES
        KrxIShGHR0bQkl9JRLc+xrFnJk+TNYzUa4PjuyGqArroi3JdDI00Vy54S7rUvVVJ58BxOMLXvNFdt
        dS0k6DdzaqC7h4ym1tvDeqHaifXKnxgpzynjCiBZ4n2/Fq3t57dg9SVaS7lvJHyTynHhlne6fTgzx
        P9VlYsyg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43858 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvFhQ-0008Hc-Cw; Thu, 09 Dec 2021 09:26:48 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvFhP-00F8Zb-Ul; Thu, 09 Dec 2021 09:26:48 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA
 ports
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mvFhP-00F8Zb-Ul@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 09 Dec 2021 09:26:47 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martyn Welch reports that his CPU port is unable to link where it has
been necessary to use one of the switch ports with an internal PHY for
the CPU port. The reason behind this is the port control register is
left forcing the link down, preventing traffic flow.

This occurs because during initialisation, phylink expects the link to
be down, and DSA forces the link down by synthesising a call to the
DSA drivers phylink_mac_link_down() method, but we don't touch the
forced-link state when we later reconfigure the port.

Resolve this by also unforcing the link state when we are operating in
PHY mode and the PPU is set to poll the PHY to retrieve link status
information.

Reported-by: Martyn Welch <martyn.welch@collabora.com>
Tested-by: Martyn Welch <martyn.welch@collabora.com>
Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
Cc: <stable@vger.kernel.org> # 5.7: 2b29cb9e3f7f: net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 64 +++++++++++++++++---------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9f675464efc3..14f87f6ac479 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -698,44 +698,48 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port *p;
-	int err;
+	int err = 0;
 
 	p = &chip->ports[port];
 
-	/* FIXME: is this the correct test? If we're in fixed mode on an
-	 * internal port, why should we process this any different from
-	 * PHY mode? On the other hand, the port may be automedia between
-	 * an internal PHY and the serdes...
-	 */
-	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
-		return;
-
 	mv88e6xxx_reg_lock(chip);
-	/* In inband mode, the link may come up at any time while the link
-	 * is not forced down. Force the link down while we reconfigure the
-	 * interface mode.
-	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
-		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
-
-	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
-	if (err && err != -EOPNOTSUPP)
-		goto err_unlock;
 
-	err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state->interface,
-					  state->advertising);
-	/* FIXME: we should restart negotiation if something changed - which
-	 * is something we get if we convert to using phylinks PCS operations.
-	 */
-	if (err > 0)
-		err = 0;
+	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
+		/* In inband mode, the link may come up at any time while the
+		 * link is not forced down. Force the link down while we
+		 * reconfigure the interface mode.
+		 */
+		if (mode == MLO_AN_INBAND &&
+		    p->interface != state->interface &&
+		    chip->info->ops->port_set_link)
+			chip->info->ops->port_set_link(chip, port,
+						       LINK_FORCED_DOWN);
+
+		err = mv88e6xxx_port_config_interface(chip, port,
+						      state->interface);
+		if (err && err != -EOPNOTSUPP)
+			goto err_unlock;
+
+		err = mv88e6xxx_serdes_pcs_config(chip, port, mode,
+						  state->interface,
+						  state->advertising);
+		/* FIXME: we should restart negotiation if something changed -
+		 * which is something we get if we convert to using phylinks
+		 * PCS operations.
+		 */
+		if (err > 0)
+			err = 0;
+	}
 
 	/* Undo the forced down state above after completing configuration
-	 * irrespective of its state on entry, which allows the link to come up.
+	 * irrespective of its state on entry, which allows the link to come
+	 * up in the in-band case where there is no separate SERDES. Also
+	 * ensure that the link can come up if the PPU is in use and we are
+	 * in PHY mode (we treat the PPU as an effective in-band mechanism.)
 	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
+	if (chip->info->ops->port_set_link &&
+	    ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
+	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
 		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
 
 	p->interface = state->interface;
-- 
2.30.2

