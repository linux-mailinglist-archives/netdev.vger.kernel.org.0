Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82E7258F68
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgIANsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgIANs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098DCC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gi0HLw6CEo6j3XEbNVkbfgm0DSAEA7TfIgH9HFNf1UE=; b=PNH+gn6AbsLKAglC1KXi4Ra4iB
        3I8lZfq7/bPMtNAbtdKFFNmQdKjGzCq3VFP0S2Bn+92yuoEx4qAEQ1HVOlaFqhILRqIErQ2O/OU7i
        TF0KwTgfGSaRyNCTtlqRRqWbbU4NqsR5glPFSm6GSRNcH/2DnDIlozwmWfL9O889L61MEmZrUSUJb
        rtVkrh/g2pSCSWRdll5iLSHpnqxxRXRN4UKpkaFurqcvZL0SHAe0duA+U6NICJ4YEdYrjvi8BpKZ3
        1duQy3tRD6Y6H3ZnM2V407FDy0fkMtPvXvsFoTM8hop6+O8hBhkiyg48R0VX/KA1lhVdAOgMWKgRJ
        BwG03Ujg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36082 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6e6-0002YY-PQ; Tue, 01 Sep 2020 14:48:22 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6e6-0007L8-Ia; Tue, 01 Sep 2020 14:48:22 +0100
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/6] net: mvpp2: ensure the port is forced down while
 changing modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6e6-0007L8-Ia@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:22 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the port is forced down while reconfiguring, controlling
this via mac_prepare() and mac_finish() so that it is down while we
are configuring our (future) PCS.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 47 ++++++++++++++-----
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7c0b0202d7ab..1f5f8416cec0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5622,9 +5622,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 		/* SGMII in-band mode receives the speed and duplex from
 		 * the PHY. Flow control information is not received. */
-		an &= ~(MVPP2_GMAC_FORCE_LINK_DOWN |
-			MVPP2_GMAC_FORCE_LINK_PASS |
-			MVPP2_GMAC_CONFIG_MII_SPEED |
+		an &= ~(MVPP2_GMAC_CONFIG_MII_SPEED |
 			MVPP2_GMAC_CONFIG_GMII_SPEED |
 			MVPP2_GMAC_CONFIG_FULL_DUPLEX);
 		an |= MVPP2_GMAC_IN_BAND_AUTONEG |
@@ -5637,9 +5635,7 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		 * speed and full duplex here.
 		 */
 		ctrl0 |= MVPP2_GMAC_PORT_TYPE_MASK;
-		an &= ~(MVPP2_GMAC_FORCE_LINK_DOWN |
-			MVPP2_GMAC_FORCE_LINK_PASS |
-			MVPP2_GMAC_CONFIG_MII_SPEED |
+		an &= ~(MVPP2_GMAC_CONFIG_MII_SPEED |
 			MVPP2_GMAC_CONFIG_GMII_SPEED |
 			MVPP2_GMAC_CONFIG_FULL_DUPLEX);
 		an |= MVPP2_GMAC_IN_BAND_AUTONEG |
@@ -5663,11 +5659,6 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	if ((old_ctrl0 ^ ctrl0) & MVPP2_GMAC_PORT_TYPE_MASK ||
 	    (old_ctrl2 ^ ctrl2) & MVPP2_GMAC_INBAND_AN_MASK ||
 	    (old_an ^ an) & MVPP2_GMAC_AN_PORT_DOWN_MASK) {
-		/* Force link down */
-		old_an &= ~MVPP2_GMAC_FORCE_LINK_PASS;
-		old_an |= MVPP2_GMAC_FORCE_LINK_DOWN;
-		writel(old_an, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-
 		/* Set the GMAC in a reset state - do this in a way that
 		 * ensures we clear it below.
 		 */
@@ -5702,6 +5693,26 @@ static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
 		return -EINVAL;
 	}
 
+	if (port->phy_interface != interface ||
+	    phylink_autoneg_inband(mode)) {
+		/* Force the link down when changing the interface or if in
+		 * in-band mode to ensure we do not change the configuration
+		 * while the hardware is indicating link is up. We force both
+		 * XLG and GMAC down to ensure that they're both in a known
+		 * state.
+		 */
+		mvpp2_modify(port->base + MVPP2_GMAC_AUTONEG_CONFIG,
+			     MVPP2_GMAC_FORCE_LINK_PASS |
+			     MVPP2_GMAC_FORCE_LINK_DOWN,
+			     MVPP2_GMAC_FORCE_LINK_DOWN);
+
+		if (mvpp2_port_supports_xlg(port))
+			mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
+				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS |
+				     MVPP22_XLG_CTRL0_FORCE_LINK_DOWN,
+				     MVPP22_XLG_CTRL0_FORCE_LINK_DOWN);
+	}
+
 	/* Make sure the port is disabled when reconfiguring the mode */
 	mvpp2_port_disable(port);
 
@@ -5750,6 +5761,20 @@ static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
 
 	mvpp2_port_enable(port);
 
+	/* Allow the link to come up if in in-band mode, otherwise the
+	 * link is forced via mac_link_down()/mac_link_up()
+	 */
+	if (phylink_autoneg_inband(mode)) {
+		if (mvpp2_is_xlg(interface))
+			mvpp2_modify(port->base + MVPP22_XLG_CTRL0_REG,
+				     MVPP22_XLG_CTRL0_FORCE_LINK_PASS |
+				     MVPP22_XLG_CTRL0_FORCE_LINK_DOWN, 0);
+		else
+			mvpp2_modify(port->base + MVPP2_GMAC_AUTONEG_CONFIG,
+				     MVPP2_GMAC_FORCE_LINK_PASS |
+				     MVPP2_GMAC_FORCE_LINK_DOWN, 0);
+	}
+
 	return 0;
 }
 
-- 
2.20.1

