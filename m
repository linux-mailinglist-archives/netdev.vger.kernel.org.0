Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C1F552E8D
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348833AbiFUJhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243785AbiFUJhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:37:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C166227164
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gDtd6HHbs2IzYQqdxYP2J1Zep3i/k0VY/FzemLqde4s=; b=VJX9oUXVLc7flSMhRjZ0ueohqQ
        JlIS0QJ961S4hLaesOvHJHP2vGAroSPa6Yzz5ernG/H3OQkBbZTl7V8lRAnbWSvfLBOfXeoraNX+y
        diC7Ek/NeIzSI2eLvzJA/MWweBJHqNtUWslqRILJeXzlx0j2vbK3rAIVKuvISp1wgajdRx5i4nbdM
        aPQJMJ/DeO+v3cNgjC002CfWsWH//RnD72veymBSCm0xK09bNAksnj4kXTvDM3bkxEJVlDOivBoK9
        ZSlArK3Ke9BhLjFbQ8/cI/Kfx7+16Lk2ZzrdhNHNUcQYikoAYNgEjL8mxDFr0ejti6mkE98Ne7lLj
        kEKbALQQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56736 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o3aKL-00028m-Q1; Tue, 21 Jun 2022 10:37:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o3aKK-0031Zc-MS; Tue, 21 Jun 2022 10:37:40 +0100
In-Reply-To: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
References: <YrGQBssOvQBZiDS4@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: get rid of SPEED_MAX
 setting
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o3aKK-0031Zc-MS@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Jun 2022 10:37:40 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all the device specific speed setting functions convert
SPEED_MAX to the actual speed of the port. Rather than having each
of the mv88e6xxx chip specifics handling SPEED_MAX, derive it from
the mac_capabilities instead.

This is only needed for CPU and DSA ports, so move the logic up into
mv88e6xxx_setup_port() - which allows us to kill off all users of
SPEED_MAX throughout the driver.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 39 ++++++++++++++++++++++++--------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 +--
 drivers/net/dsa/mv88e6xxx/port.c | 21 -----------------
 3 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0b49d243e00b..37b649501500 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -449,9 +449,6 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 			goto restore_link;
 	}
 
-	if (speed == SPEED_MAX && chip->info->ops->port_max_speed_mode)
-		mode = chip->info->ops->port_max_speed_mode(port);
-
 	if (chip->info->ops->port_set_pause) {
 		err = chip->info->ops->port_set_pause(chip, port, pause);
 		if (err)
@@ -3280,28 +3277,51 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct device_node *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
+	phy_interface_t mode;
 	struct dsa_port *dp;
-	int tx_amp;
+	int tx_amp, speed;
 	int err;
 	u16 reg;
 
 	chip->ports[port].chip = chip;
 	chip->ports[port].port = port;
 
+	dp = dsa_to_port(ds, port);
+
 	/* MAC Forcing register: don't force link, speed, duplex or flow control
 	 * state to any particular values on physical ports, but force the CPU
 	 * port and all DSA ports to their maximum bandwidth and full duplex.
 	 */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
+		unsigned long caps = dp->pl_config.mac_capabilities;
+
+		if (chip->info->ops->port_max_speed_mode)
+			mode = chip->info->ops->port_max_speed_mode(port);
+		else
+			mode = PHY_INTERFACE_MODE_NA;
+
+		if (caps & MAC_10000FD)
+			speed = SPEED_10000;
+		else if (caps & MAC_5000FD)
+			speed = SPEED_5000;
+		else if (caps & MAC_2500FD)
+			speed = SPEED_2500;
+		else if (caps & MAC_1000)
+			speed = SPEED_1000;
+		else if (caps & MAC_100)
+			speed = SPEED_100;
+		else
+			speed = SPEED_10;
+
 		err = mv88e6xxx_port_setup_mac(chip, port, LINK_FORCED_UP,
-					       SPEED_MAX, DUPLEX_FULL,
-					       PAUSE_OFF,
-					       PHY_INTERFACE_MODE_NA);
-	else
+					       speed, DUPLEX_FULL,
+					       PAUSE_OFF, mode);
+	} else {
 		err = mv88e6xxx_port_setup_mac(chip, port, LINK_UNFORCED,
 					       SPEED_UNFORCED, DUPLEX_UNFORCED,
 					       PAUSE_ON,
 					       PHY_INTERFACE_MODE_NA);
+	}
 	if (err)
 		return err;
 
@@ -3473,7 +3493,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	}
 
 	if (chip->info->ops->serdes_set_tx_amplitude) {
-		dp = dsa_to_port(ds, port);
 		if (dp)
 			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 5e03cfe50156..e693154cf803 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -488,14 +488,13 @@ struct mv88e6xxx_ops {
 	int (*port_set_pause)(struct mv88e6xxx_chip *chip, int port,
 			      int pause);
 
-#define SPEED_MAX		INT_MAX
 #define SPEED_UNFORCED		-2
 #define DUPLEX_UNFORCED		-2
 
 	/* Port's MAC speed (in Mbps) and MAC duplex mode
 	 *
 	 * Depending on the chip, 10, 100, 200, 1000, 2500, 10000 are valid.
-	 * Use SPEED_UNFORCED for normal detection, SPEED_MAX for max value.
+	 * Use SPEED_UNFORCED for normal detection.
 	 *
 	 * Use DUPLEX_HALF or DUPLEX_FULL to force half or full duplex,
 	 * or DUPLEX_UNFORCED for normal duplex detection.
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 3cdc985b79e2..90c55f23b7c9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -298,9 +298,6 @@ static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = 1000;
-
 	if (speed == 200 || speed > 1000)
 		return -EOPNOTSUPP;
 
@@ -312,9 +309,6 @@ int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6250_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = 100;
-
 	if (speed > 100)
 		return -EOPNOTSUPP;
 
@@ -326,9 +320,6 @@ int mv88e6250_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = port < 5 ? 1000 : 2500;
-
 	if (speed > 2500)
 		return -EOPNOTSUPP;
 
@@ -354,9 +345,6 @@ phy_interface_t mv88e6341_port_max_speed_mode(int port)
 int mv88e6352_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = 1000;
-
 	if (speed > 1000)
 		return -EOPNOTSUPP;
 
@@ -371,9 +359,6 @@ int mv88e6352_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				    int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = port < 9 ? 1000 : 2500;
-
 	if (speed > 2500)
 		return -EOPNOTSUPP;
 
@@ -399,9 +384,6 @@ phy_interface_t mv88e6390_port_max_speed_mode(int port)
 int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex)
 {
-	if (speed == SPEED_MAX)
-		speed = port < 9 ? 1000 : 10000;
-
 	if (speed == 200 && port != 0)
 		return -EOPNOTSUPP;
 
@@ -430,9 +412,6 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	u16 reg, ctrl;
 	int err;
 
-	if (speed == SPEED_MAX)
-		speed = (port > 0 && port < 9) ? 1000 : 10000;
-
 	if (speed == 200 && port != 0)
 		return -EOPNOTSUPP;
 
-- 
2.30.2

