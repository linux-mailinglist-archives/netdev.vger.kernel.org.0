Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFD21C629
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGKUcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:32:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgGKUcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 16:32:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juMAg-004eo0-53; Sat, 11 Jul 2020 22:32:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Implement MTU change
Date:   Sat, 11 Jul 2020 22:32:05 +0200
Message-Id: <20200711203206.1110108-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711203206.1110108-1-andrew@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell Switches support jumbo packages. So implement the
callbacks needed for changing the MTU.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d995f5bf0d40..6f019955ae42 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2693,6 +2693,31 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
 }
 
+static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	if (chip->info->ops->port_set_jumbo_size)
+		return 10240;
+	return 1522;
+}
+
+static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int ret = 0;
+
+	mv88e6xxx_reg_lock(chip);
+	if (chip->info->ops->port_set_jumbo_size)
+		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
+	else
+		if (new_mtu > 1522)
+			ret = -EINVAL;
+	mv88e6xxx_reg_unlock(chip);
+
+	return ret;
+}
+
 static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 				 struct phy_device *phydev)
 {
@@ -5525,6 +5550,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_sset_count		= mv88e6xxx_get_sset_count,
 	.port_enable		= mv88e6xxx_port_enable,
 	.port_disable		= mv88e6xxx_port_disable,
+	.port_max_mtu		= mv88e6xxx_get_max_mtu,
+	.port_change_mtu	= mv88e6xxx_change_mtu,
 	.get_mac_eee		= mv88e6xxx_get_mac_eee,
 	.set_mac_eee		= mv88e6xxx_set_mac_eee,
 	.get_eeprom_len		= mv88e6xxx_get_eeprom_len,
-- 
2.27.0.rc2

