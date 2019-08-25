Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23249C175
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 05:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfHYD73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 23:59:29 -0400
Received: from mail.nic.cz ([217.31.204.67]:44190 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfHYD72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 23:59:28 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id F1BE21409A4;
        Sun, 25 Aug 2019 05:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566705563; bh=RuVSynhms01Ae6y6RiDxXYgQtNS7cLrZwNo2QAChQZU=;
        h=From:To:Date;
        b=i10oSJVFjCtWr4PPBnbCn1/AoTXIvUIOJVX6Ikaa4bQhF8Kk+KtgS6bjQy/t0dLZA
         00ZUuij5hiNlmBdzwGfuR9tRE34MylU7emmGvQm6sEAFrmB3zotf/20Ot2omJNGxWq
         bMa0y4Hl981z6dVd9/u93TMEv4U1YwF7ooHboEns=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v3 6/6] net: dsa: mv88e6xxx: fully support SERDES on Topaz family
Date:   Sun, 25 Aug 2019 05:59:15 +0200
Message-Id: <20190825035915.13112-7-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190825035915.13112-1-marek.behun@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
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
writable on the Topaz family, and enables cmode setting and SERDES IRQs.

Tested on Turris Mox.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  6 +++
 drivers/net/dsa/mv88e6xxx/port.c | 76 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/port.h |  4 ++
 3 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 202ccce65b1c..6525075f6bd3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2913,6 +2913,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
@@ -2929,6 +2930,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3608,6 +3611,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
+	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
@@ -3624,6 +3628,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7183c94a92ec..908b95434b4d 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -392,17 +392,37 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 	return PHY_INTERFACE_MODE_NA;
 }
 
-int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-			      phy_interface_t mode)
+static int mv88e6341_port_force_writable_cmode(struct mv88e6xxx_chip *chip,
+					       int port)
+{
+	int err, addr;
+	u16 reg, bits;
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
+static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+				    phy_interface_t mode, bool allow_over_2500,
+				    bool make_cmode_writable)
 {
 	s8 lane;
 	u16 cmode;
 	u16 reg;
 	int err;
 
-	if (port != 9 && port != 10)
-		return -EOPNOTSUPP;
-
 	/* Default to a slow mode, so freeing up SERDES interfaces for
 	 * other ports which might use them for SFPs.
 	 */
@@ -421,9 +441,13 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		break;
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
+		if (!allow_over_2500)
+			return -EINVAL;
 		cmode = MV88E6XXX_PORT_STS_CMODE_XAUI;
 		break;
 	case PHY_INTERFACE_MODE_RXAUI:
+		if (!allow_over_2500)
+			return -EINVAL;
 		cmode = MV88E6XXX_PORT_STS_CMODE_RXAUI;
 		break;
 	default:
@@ -457,6 +481,12 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 
+		if (make_cmode_writable) {
+			err = mv88e6341_port_force_writable_cmode(chip, port);
+			if (err)
+				return err;
+		}
+
 		reg &= ~MV88E6XXX_PORT_STS_CMODE_MASK;
 		reg |= cmode;
 
@@ -484,21 +514,37 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
+int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode)
+{
+	if (port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode, true, false);
+}
+
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode)
 {
-	switch (mode) {
-	case PHY_INTERFACE_MODE_NA:
+	if (port != 9 && port != 10)
+		return -EOPNOTSUPP;
+
+	if (mode == PHY_INTERFACE_MODE_NA)
+		return 0;
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false, false);
+}
+
+int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			     phy_interface_t mode)
+{
+	if (port != 5)
+		return -EOPNOTSUPP;
+
+	if (mode == PHY_INTERFACE_MODE_NA)
 		return 0;
-	case PHY_INTERFACE_MODE_XGMII:
-	case PHY_INTERFACE_MODE_XAUI:
-	case PHY_INTERFACE_MODE_RXAUI:
-		return -EINVAL;
-	default:
-		break;
-	}
 
-	return mv88e6390x_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false, true);
 }
 
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 04550cb3c3b3..4b7289a1fd8b 100644
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
@@ -334,6 +336,8 @@ int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
+int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			     phy_interface_t mode);
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			     phy_interface_t mode);
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-- 
2.21.0

