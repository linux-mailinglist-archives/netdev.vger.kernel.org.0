Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132C246B9AA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhLGLCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 06:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbhLGLCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 06:02:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F9AC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yfP7YSjblkyHyyRmwv0zgSJel8+IGYcpOziTm2Z1cao=; b=wDIi5Ck+FXEkJpq1XU6Y61eum+
        bkyP0Jx6jANXhCdfXuVsUNzpJiQ92rKVvjTLvi2LX5C0JxaI4TCh3WmR9BBXLoQ2P8hejey7o5813
        hcVMbf0HfMiYJ63o1yX3IdmXslwNbkR0zGT+BFSHs9TF6uBRxTFgjPnG4M4dQV5TDnNOgbrSks7DB
        qV6o59dmA4B2adblvBLBDQZgIOROP134UHsxMsbWnFVRd/S2L25jCNXxFEzBsUauJGr+h0hJ0UDCT
        zHStDw1SFmSZlD41/2bEuHIhn+BfmvtqZrwisUFjs7jBDwQjt2eESJruieRns0atfT+HWtI0CK96M
        4xXqUwrg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54666 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1muYBr-00064J-N2; Tue, 07 Dec 2021 10:59:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1muYBr-00EwOF-9C; Tue, 07 Dec 2021 10:59:19 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA
 ports
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Dec 2021 10:59:19 +0000
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
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This patch requires:
https://lore.kernel.org/r/E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk

If we convert Marvell DSA filly to split PCS (we have 6185 and 6352
complete, 6390 and 6393 remain), the "legacy_march2020" patches, and
the phylink get_caps patches, we can then make Marvell DSA a non-
legacy phylink driver. This gives much cleaner semantics concerning
when the phylink_mac_config() method is called. Specifically, being
non-legacy means phylink_mac_config() will no longer be called just
before every phylink_mac_link_up() method call, and will not be called
for in-band advertisement changes.

This means that phylink_mac_config() will only be called when the port
needs to be reconfigured, which allows drivers to force the link down
for safe reconfiguration without potentially causing an infinite loop
of link-down link-up events that can occur with the legacy behaviour.

Thus, being non-legacy and allowing the forcing removes the need for
DSA to synthesise a call to phylink_mac_link_down() at initialisation
time for this driver... but we need all DSA drivers to be non-legacy
before we can safely remove that.

 drivers/net/dsa/mv88e6xxx/chip.c | 56 +++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9f675464efc3..b033e653d3f4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -698,7 +698,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port *p;
-	int err;
+	int err = 0;
 
 	p = &chip->ports[port];
 
@@ -711,31 +711,43 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
-	/* In inband mode, the link may come up at any time while the link
-	 * is not forced down. Force the link down while we reconfigure the
-	 * interface mode.
-	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
-		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 
-	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
-	if (err && err != -EOPNOTSUPP)
-		goto err_unlock;
-
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

