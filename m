Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26B5598B0
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 13:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiFXLmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 07:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFXLmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 07:42:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6994E7A1BF
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n/aymNz4Y0HJ9GUQg+H1tg6FWbqURMPdOK+sJTRuAWA=; b=WKQyr30DjE11qW9fPmE69ll+xy
        vWpmBIiYwRbrT081o2mJFYV8YIgLpKth++jwlh/R+MG0nIhly8zk6cyPAxEq+Vcl0qw3K9d20lNda
        COHDZP1rKtsB+E6qU43eBwILcZT0i0JxPrykt2SNhG2DIkC91vrjPN21l/A2hfrelUmIuP3yRrwK0
        yJ8tDx7xEp0qj/Rr3I/kfKCTNCujptwMoFzvtFPx6JXPbkYp31M7iYubKpzy5BrpcLnnfcWnE0BAN
        hiJYripJ93bX5ZX64YC/ovNM0KeBNz1zw94I7yfjlHER1Cs9FrVP3RvaOk1avchS61AjwrQBSQGRL
        nwyVnDQA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41616 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o4hhS-0005sh-5j; Fri, 24 Jun 2022 12:42:10 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o4hhR-004Ap4-HJ; Fri, 24 Jun 2022 12:42:09 +0100
In-Reply-To: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH RFC net-next 4/4] net: dsa: always use phylink for CPU and DSA
 ports
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o4hhR-004Ap4-HJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Jun 2022 12:42:09 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we only use phylink for CPU and DSA ports if there is a
fixed-link specification, or a PHY specified. The reason for this
behaviour is that when neither is specified, there was no way for
phylink to know the link parameters.

Now that we have phylink_set_max_link_speed() (which has become
possible through the addition of mac_capabilities) we now have the
ability to know the maximum link speed for a specific link, and can
now use phylink for this case as well.

However, we need DSA drivers to report the interface mode being used
on these ports so that we can select a maximum speed appropriate for
the interface mode that hardware may have configured for the port.

This is especially important with the conversion of DSA drivers to
phylink_pcs, as the PCS code only gets called if we are using
phylink for the port.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++----------------------------
 net/dsa/port.c                   | 19 +++++++--------
 2 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1c6b4b00d58d..e19732782742 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3287,9 +3287,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct device_node *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
-	phy_interface_t mode;
 	struct dsa_port *dp;
-	int tx_amp, speed;
+	int tx_amp;
 	int err;
 	u16 reg;
 
@@ -3298,40 +3297,10 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 
 	dp = dsa_to_port(ds, port);
 
-	/* MAC Forcing register: don't force link, speed, duplex or flow control
-	 * state to any particular values on physical ports, but force the CPU
-	 * port and all DSA ports to their maximum bandwidth and full duplex.
-	 */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
-		unsigned long caps = dp->pl_config.mac_capabilities;
-
-		if (chip->info->ops->port_max_speed_mode)
-			mode = chip->info->ops->port_max_speed_mode(port);
-		else
-			mode = PHY_INTERFACE_MODE_NA;
-
-		if (caps & MAC_10000FD)
-			speed = SPEED_10000;
-		else if (caps & MAC_5000FD)
-			speed = SPEED_5000;
-		else if (caps & MAC_2500FD)
-			speed = SPEED_2500;
-		else if (caps & MAC_1000)
-			speed = SPEED_1000;
-		else if (caps & MAC_100)
-			speed = SPEED_100;
-		else
-			speed = SPEED_10;
-
-		err = mv88e6xxx_port_setup_mac(chip, port, LINK_FORCED_UP,
-					       speed, DUPLEX_FULL,
-					       PAUSE_OFF, mode);
-	} else {
-		err = mv88e6xxx_port_setup_mac(chip, port, LINK_UNFORCED,
-					       SPEED_UNFORCED, DUPLEX_UNFORCED,
-					       PAUSE_ON,
-					       PHY_INTERFACE_MODE_NA);
-	}
+	err = mv88e6xxx_port_setup_mac(chip, port, LINK_UNFORCED,
+				       SPEED_UNFORCED, DUPLEX_UNFORCED,
+				       PAUSE_ON,
+				       PHY_INTERFACE_MODE_NA);
 	if (err)
 		return err;
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 35b4e1f8dc05..a1232eaa5d21 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1559,6 +1559,9 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 		return PTR_ERR(dp->pl);
 	}
 
+	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA)
+		phylink_set_max_fixed_link(dp->pl);
+
 	return 0;
 }
 
@@ -1663,20 +1666,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
 	int port = dp->index;
 
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
-			if (ds->ops->phylink_mac_link_down)
-				ds->ops->phylink_mac_link_down(ds, port,
-					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
-		}
-		of_node_put(phy_np);
-		return 0;
+		if (ds->ops->phylink_mac_link_down)
+			ds->ops->phylink_mac_link_down(ds, port,
+				MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
+
+		return dsa_port_phylink_register(dp);
 	}
 
 	dev_warn(ds->dev,
-- 
2.30.2

