Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18F8258F67
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgIANst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgIANsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56BBC061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E+FlazIPBJYBq9mE9KLCn8aaQ0ppEPoHKeH0Ka39cK8=; b=qWDFahZifAj5NND9VNypJ/J96U
        hKo4O2uiEERf/ARiV3i7XmDOuEvzdabcGhoZsFaFHKdcCnbtfY9V0XowGNEBGOjTmJiYXqPI8xQw+
        4F0XGVHWNt2Ww3AXbSWCcr7wVFvebRNbRtd1bXHX0Q3C4EB1Kg9tb6cCJw5SOC0m808uJc+9+WG3C
        5fMaSEZOU2Dso9p5Rbk7Ig+eLTXyqnNc6dhYe20RQifeMmBeX/vUzKoh+LnZQcv/pavGlCzEvYv5j
        iEqmNtUjcOQsjeF0luG21Xcp+sSt4k0d5N+6o6YrdoflXCLSgkmIseFLrOBnEDQwOgCmYg86OotvB
        4ATKRekQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36080 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6e1-0002YL-LX; Tue, 01 Sep 2020 14:48:17 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6e1-0007Ku-Ek; Tue, 01 Sep 2020 14:48:17 +0100
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
Subject: [PATCH net-next 2/6] net: mvpp2: convert to use
 mac_prepare()/mac_finish()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6e1-0007Ku-Ek@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:17 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mvpp2 to use the mac_prepare() and mac_finish() methods in
preparation to converting mvpp2 to split-PCS support.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 48 ++++++++++++++-----
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c35871e31ab6..7c0b0202d7ab 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5691,31 +5691,35 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 	}
 }
 
-static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
-			     const struct phylink_link_state *state)
+static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-	bool change_interface = port->phy_interface != state->interface;
 
 	/* Check for invalid configuration */
-	if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
+	if (mvpp2_is_xlg(interface) && port->gop_id != 0) {
 		netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
-		return;
+		return -EINVAL;
 	}
 
 	/* Make sure the port is disabled when reconfiguring the mode */
 	mvpp2_port_disable(port);
 
-	if (port->priv->hw_version == MVPP22 && change_interface) {
+	if (port->priv->hw_version == MVPP22 &&
+	    port->phy_interface != interface) {
 		mvpp22_gop_mask_irq(port);
 
-		port->phy_interface = state->interface;
-
-		/* Reconfigure the serdes lanes */
 		phy_power_off(port->comphy);
-		mvpp22_mode_reconfigure(port);
 	}
 
+	return 0;
+}
+
+static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+
 	/* mac (re)configuration */
 	if (mvpp2_is_xlg(state->interface))
 		mvpp2_xlg_config(port, mode, state);
@@ -5726,11 +5730,27 @@ static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 
 	if (port->priv->hw_version == MVPP21 && port->flags & MVPP2_F_LOOPBACK)
 		mvpp2_port_loopback_set(port, state);
+}
+
+static int mvpp2_mac_finish(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+
+	if (port->priv->hw_version == MVPP22 &&
+	    port->phy_interface != interface) {
+		port->phy_interface = interface;
 
-	if (port->priv->hw_version == MVPP22 && change_interface)
+		/* Reconfigure the serdes lanes */
+		mvpp22_mode_reconfigure(port);
+
+		/* Unmask interrupts */
 		mvpp22_gop_unmask_irq(port);
+	}
 
 	mvpp2_port_enable(port);
+
+	return 0;
 }
 
 static void mvpp2_mac_link_up(struct phylink_config *config,
@@ -5829,7 +5849,9 @@ static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.validate = mvpp2_phylink_validate,
 	.mac_pcs_get_state = mvpp2_phylink_mac_pcs_get_state,
 	.mac_an_restart = mvpp2_mac_an_restart,
+	.mac_prepare = mvpp2_mac_prepare,
 	.mac_config = mvpp2_mac_config,
+	.mac_finish = mvpp2_mac_finish,
 	.mac_link_up = mvpp2_mac_link_up,
 	.mac_link_down = mvpp2_mac_link_down,
 };
@@ -5844,7 +5866,11 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	struct phylink_link_state state = {
 		.interface = port->phy_interface,
 	};
+	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
+			  port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
+	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
+			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
 			  MLO_AN_INBAND, port->phy_interface,
 			  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false);
-- 
2.20.1

