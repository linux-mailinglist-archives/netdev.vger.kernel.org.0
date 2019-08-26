Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559AD9D866
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfHZVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:32:06 -0400
Received: from mail.nic.cz ([217.31.204.67]:35122 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728835AbfHZVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 17:32:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id B7FBD140B50;
        Mon, 26 Aug 2019 23:31:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566855119; bh=18PBcpj0KmpUiSVakzDOzIS2C1+QrrrT2iSIxhR4LPw=;
        h=From:To:Date;
        b=pv1ZfBR3xtVSP1MMP1JHeN1UBBVoqcuxiVA16uU8zQB1KC/tB+SdoMJsFoqJuEkT8
         hN94FLcYUsSpviwoKhCkSqp/dTC2RIX49qyx+eaop5WxvOQos2wNDQxVICfkAnGq0w
         TNAciGMOIXLCK/mFGQTM5X9QQ9xRWPwPkhH0I/0A=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v5 6/6] net: dsa: mv88e6xxx: fully support SERDES on Topaz family
Date:   Mon, 26 Aug 2019 23:31:55 +0200
Message-Id: <20190826213155.14685-7-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826213155.14685-1-marek.behun@nic.cz>
References: <20190826213155.14685-1-marek.behun@nic.cz>
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

Currently we support SERDES on the Topaz family in a limited way: no
IRQs and the cmode is not writable, thus the mode is determined by
strapping pins.

Marvell's examples though show how to make cmode writable on port 5 and
support SGMII autonegotiation. It is done by writing hidden registers,
for which we already have code.

This patch adds support for making the cmode for the SERDES port
writable on the Topaz family, via a new chip operation,
.port_set_cmode_writable, which is called from mv88e6xxx_port_setup_mac
just before .port_set_cmode.

SERDES IRQs are also enabled for Topaz.

Tested on Turris Mox.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 14 +++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.c | 65 +++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/port.h |  5 +++
 4 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 202ccce65b1c..54e88aafba2f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -454,6 +454,12 @@ int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			goto restore_link;
 	}
 
+	if (chip->info->ops->port_set_cmode_writable) {
+		err = chip->info->ops->port_set_cmode_writable(chip, port);
+		if (err && err != -EOPNOTSUPP)
+			goto restore_link;
+	}
+
 	if (chip->info->ops->port_set_cmode) {
 		err = chip->info->ops->port_set_cmode(chip, port, mode);
 		if (err && err != -EOPNOTSUPP)
@@ -2913,6 +2919,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode_writable = mv88e6341_port_set_cmode_writable,
+	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
@@ -2929,6 +2937,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3608,6 +3618,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode_writable = mv88e6341_port_set_cmode_writable,
+	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
@@ -3624,6 +3636,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 421e8b84bec3..d6b1aa35aa1a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -400,6 +400,7 @@ struct mv88e6xxx_ops {
 	/* CMODE control what PHY mode the MAC will use, eg. SGMII, RGMII, etc.
 	 * Some chips allow this to be configured on specific ports.
 	 */
+	int (*port_set_cmode_writable)(struct mv88e6xxx_chip *chip, int port);
 	int (*port_set_cmode)(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
 	int (*port_get_cmode)(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index c7630dab18a8..542201214c36 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -392,17 +392,14 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 	return PHY_INTERFACE_MODE_NA;
 }
 
-int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-			      phy_interface_t mode)
+static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+				    phy_interface_t mode)
 {
 	u8 lane;
 	u16 cmode;
 	u16 reg;
 	int err;
 
-	if (port != 9 && port != 10)
-		return -EOPNOTSUPP;
-
 	/* Default to a slow mode, so freeing up SERDES interfaces for
 	 * other ports which might use them for SFPs.
 	 */
@@ -484,9 +481,65 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
+int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode)
+{
+	if (port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode);
+}
+
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode)
 {
+	if (port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	switch (mode) {
+	case PHY_INTERFACE_MODE_NA:
+		return 0;
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+		return -EINVAL;
+	default:
+		break;
+	}
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode);
+}
+
+int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip, int port)
+{
+	int err, addr;
+	u16 reg, bits;
+
+	if (port != 5)
+		return -EOPNOTSUPP;
+
+	addr = chip->info->port_base_addr + port;
+
+	err = mv88e6xxx_port_hidden_read(chip, 0x7, addr, 0, &reg);
+	if (err)
+		return err;
+
+	bits = MV88E6341_PORT_RESERVED_1A_FORCE_CMODE |
+	       MV88E6341_PORT_RESERVED_1A_SGMII_AN;
+
+	if ((reg & bits) == bits)
+		return 0;
+
+	reg |= bits;
+	return mv88e6xxx_port_hidden_write(chip, 0x7, addr, 0, reg);
+}
+
+int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			     phy_interface_t mode)
+{
+	if (port != 5)
+		return -EOPNOTSUPP;
+
 	switch (mode) {
 	case PHY_INTERFACE_MODE_NA:
 		return 0;
@@ -498,7 +551,7 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		break;
 	}
 
-	return mv88e6390x_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode);
 }
 
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 6d7a067da0f5..e78d68c3e671 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -269,6 +269,8 @@
 #define MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT	10
 #define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	0x04
 #define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	0x05
+#define MV88E6341_PORT_RESERVED_1A_FORCE_CMODE	0x8000
+#define MV88E6341_PORT_RESERVED_1A_SGMII_AN	0x2000
 
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val);
@@ -334,6 +336,9 @@ int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
+int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip, int port);
+int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			     phy_interface_t mode);
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode);
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-- 
2.21.0

