Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58ED90460
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfHPPIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:08:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:32870 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfHPPIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:08:42 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id F1B8A140CDF;
        Fri, 16 Aug 2019 17:08:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565968119; bh=WP7vOSOuRP24DU4xBBueR+LHlsNyCSHZfsqHpMThghI=;
        h=From:To:Date;
        b=oP15WurON/mn1NSPwC+LrjwEQIoPOr9BMw5CY7qPgadn+CVhgnyX54Ry9n0vqicPV
         30RGKbc8wF+U3dddJsae3+PxXrInWjbduw+O8reBwgUluw1EJ7GYD1Se02ggAOZEDp
         JljVRrDZmgYfT2GiAM8nt2CqR8jWLBkajojfAu5g=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq also for CPU/DSA ports
Date:   Fri, 16 Aug 2019 17:08:34 +0200
Message-Id: <20190816150834.26939-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816150834.26939-1-marek.behun@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CPU/DSA port is put into for example into 2500base-x mode, the
SERDES irq has to be enabled so that port's MAC is configured properly
after autonegotiation.

When SERDES irq is being enabled, the port's phylink structure already
has to exist. Otherwise if the IRQ fires immediately, the IRQ routine's
access to the nonexistent phylink structure results in an exception.

We therefore enable SERDES irqs for CPU/DSA ports in the .port_setup()
method, which is called by DSA from dsa_setup_port after the port is
registered and phylink structures exist.

We also move SERDES powering on for CPU/DSA ports to this method.

We also free the IRQ and power off SERDESes for these ports in the
.port_teardown() method.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 54 ++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9b3ad22a5b98..23d3e39d2b9c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2151,16 +2151,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Enable the SERDES interface for DSA and CPU ports. Normal
-	 * ports SERDES are enabled when the port is enabled, thus
-	 * saving a bit of power.
-	 */
-	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
-		err = mv88e6xxx_serdes_power(chip, port, true);
-		if (err)
-			return err;
-	}
-
 	/* Port Control 2: don't force a good FCS, set the maximum frame size to
 	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
@@ -2557,6 +2547,48 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	return err;
 }
 
+static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	/* Enable the SERDES interface for DSA and CPU ports. Normal
+	 * ports SERDES are enabled when the port is enabled, thus
+	 * saving a bit of power.
+	 */
+	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
+		mv88e6xxx_reg_lock(chip);
+
+		err = mv88e6xxx_serdes_power(chip, port, true);
+
+		if (!err && chip->info->ops->serdes_irq_setup)
+			err = chip->info->ops->serdes_irq_setup(chip, port);
+
+		mv88e6xxx_reg_unlock(chip);
+
+		return err;
+	}
+
+	return 0;
+}
+
+static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
+		mv88e6xxx_reg_lock(chip);
+
+		if (chip->info->ops->serdes_irq_free)
+			chip->info->ops->serdes_irq_free(chip, port);
+
+		if (mv88e6xxx_serdes_power(chip, port, false))
+			dev_err(chip->dev, "failed to power off SERDES\n");
+
+		mv88e6xxx_reg_unlock(chip);
+	}
+}
+
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
@@ -4692,6 +4724,8 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
+	.port_setup		= mv88e6xxx_port_setup,
+	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_link_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
-- 
2.21.0

