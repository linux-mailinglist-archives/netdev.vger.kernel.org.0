Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94020F29F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbgF3KZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732515AbgF3KZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:25:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CA3C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bGpOXcydolGp5f9frE6u/iKipmimlvSmxxsfyHL/I7A=; b=PoJ+jdFZ01e2oVPwLLju5CSicJ
        QorKTU6CVXO3k9CIXWLPvbk6HngpfEP3V4XlQaro3ZcU1E+6pVZZ0UL42YXgGE+XOcrsG8GlZf3XA
        tX+TGXbpmUoW7NDaXdPYj2jwUqFbJB/xj7dJ8TOHyRE+qw/iix1WnMoN2vwgXXvwZyQChpqOTwzmH
        jzxUzgf5uZDL+9kXRtCVOLtJDOG6eK84G55Urzmrtdp+z804xFt83AUV+4xB6yFaH/2JWVn4Ytd65
        7ul3gX7o7qi8s7gidkAWwlgxoGV7Nm3O51lYbBE5K1PmMe4yPWeMtEBLsfiqVLtke2lmzToogJOAk
        l53fyUzg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45936 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDRl-0000Oq-E7; Tue, 30 Jun 2020 11:25:01 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDRk-0004q2-V5; Tue, 30 Jun 2020 11:25:01 +0100
In-Reply-To: <20200630102430.GZ1551@shell.armlinux.org.uk>
References: <20200630102430.GZ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: dsa/b53: change b53_force_port_config()
 pause argument
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqDRk-0004q2-V5@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:25:00 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the b53_force_port_config() pause argument, which is based on
phylink's MLO_PAUSE_* definitions, to use a pair of booleans.  This
will allow us to move b53_force_port_config() from
b53_phylink_mac_config() to b53_phylink_mac_link_up().

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1df05841ab6b..8a7fa6092b01 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1037,7 +1037,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 }
 
 static void b53_force_port_config(struct b53_device *dev, int port,
-				  int speed, int duplex, int pause)
+				  int speed, int duplex,
+				  bool tx_pause, bool rx_pause)
 {
 	u8 reg, val, off;
 
@@ -1075,9 +1076,9 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 		return;
 	}
 
-	if (pause & MLO_PAUSE_RX)
+	if (rx_pause)
 		reg |= PORT_OVERRIDE_RX_FLOW;
-	if (pause & MLO_PAUSE_TX)
+	if (tx_pause)
 		reg |= PORT_OVERRIDE_TX_FLOW;
 
 	b53_write8(dev, B53_CTRL_PAGE, off, reg);
@@ -1089,22 +1090,24 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 	u8 rgmii_ctrl = 0, reg = 0, off;
-	int pause = 0;
+	bool tx_pause = false;
+	bool rx_pause = false;
 
 	if (!phy_is_pseudo_fixed_link(phydev))
 		return;
 
 	/* Enable flow control on BCM5301x's CPU port */
 	if (is5301x(dev) && port == dev->cpu_port)
-		pause = MLO_PAUSE_TXRX_MASK;
+		tx_pause = rx_pause = true;
 
 	if (phydev->pause) {
 		if (phydev->asym_pause)
-			pause |= MLO_PAUSE_TX;
-		pause |= MLO_PAUSE_RX;
+			tx_pause = true;
+		rx_pause = true;
 	}
 
-	b53_force_port_config(dev, port, phydev->speed, phydev->duplex, pause);
+	b53_force_port_config(dev, port, phydev->speed, phydev->duplex,
+			      tx_pause, rx_pause);
 	b53_force_link(dev, port, phydev->link);
 
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
@@ -1166,7 +1169,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	} else if (is5301x(dev)) {
 		if (port != dev->cpu_port) {
 			b53_force_port_config(dev, dev->cpu_port, 2000,
-					      DUPLEX_FULL, MLO_PAUSE_TXRX_MASK);
+					      DUPLEX_FULL, true, true);
 			b53_force_link(dev, dev->cpu_port, 1);
 		}
 	}
@@ -1256,7 +1259,9 @@ void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	if (mode == MLO_AN_FIXED) {
 		b53_force_port_config(dev, port, state->speed,
-				      state->duplex, state->pause);
+				      state->duplex,
+				      !!(state->pause & MLO_PAUSE_TX),
+				      !!(state->pause & MLO_PAUSE_RX));
 		return;
 	}
 
-- 
2.20.1

