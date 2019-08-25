Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5902A9C177
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 05:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfHYD73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 23:59:29 -0400
Received: from mail.nic.cz ([217.31.204.67]:44172 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfHYD72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 23:59:28 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 92FB114089B;
        Sun, 25 Aug 2019 05:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566705562; bh=jZCjVrzDwnNrlga8xAFcYzGTlZAXzk+agQ2VvHZiKaw=;
        h=From:To:Date;
        b=QMkv444W8eobLq5kuOz8YhuIx7TNoDmTW31KmxiVvSfsczR0dzb0RlVZ8+UBpwaFl
         YpShvl02cPWe/Wtkwz1EHKsjVyV7fzSjWeNyOMMYHIm1fkmHmU9wA7qTmwD463zOkY
         GQ7L5VkyZ5xJwpNMqc301TCAhxuOKuc8TNcx8HYw=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v3 3/6] net: dsa: mv88e6xxx: create serdes_get_lane chip operation
Date:   Sun, 25 Aug 2019 05:59:12 +0200
Message-Id: <20190825035915.13112-4-marek.behun@nic.cz>
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

Create a serdes_get_lane() method in the mv88e6xxx operations structure.
Use it instead of calling the different implementations.
Also change the methods so that their return value is used only for
error. The lane number is put into a place referred to by a pointer
given as argument. If the port does not have a lane, put -1 there.
Lanes are phy addresses, so use s8 as their type.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |   6 ++
 drivers/net/dsa/mv88e6xxx/chip.h   |   3 +
 drivers/net/dsa/mv88e6xxx/port.c   |  14 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c | 130 +++++++++++++++--------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  20 ++++-
 5 files changed, 99 insertions(+), 74 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ec4274d71145..5a3fff1971b9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3255,6 +3255,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3301,6 +3302,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390x_serdes_power,
+	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390x_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390x_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3347,6 +3349,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -3483,6 +3486,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3800,6 +3804,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6390_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -3850,6 +3855,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390x_serdes_power,
+	.serdes_get_lane = mv88e6390x_serdes_get_lane,
 	.serdes_irq_setup = mv88e6390x_serdes_irq_setup,
 	.serdes_irq_free = mv88e6390x_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index a406be2f5652..15d0c9f00f54 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -443,6 +443,9 @@ struct mv88e6xxx_ops {
 	/* Power on/off a SERDES interface */
 	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, bool on);
 
+	/* SERDES lane mapping */
+	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port, s8 *lane);
+
 	/* SERDES interrupt handling */
 	int (*serdes_irq_setup)(struct mv88e6xxx_chip *chip, int port);
 	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index c95cdb73e5a2..6a1fa5c72fdb 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -395,7 +395,7 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode)
 {
-	int lane;
+	s8 lane;
 	u16 cmode;
 	u16 reg;
 	int err;
@@ -434,9 +434,9 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (cmode == chip->ports[port].cmode)
 		return 0;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port);
-	if (lane < 0 && lane != -ENODEV)
-		return lane;
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err)
+		return err;
 
 	if (lane >= 0) {
 		if (chip->ports[port].serdes_irq) {
@@ -466,9 +466,9 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 
 		chip->ports[port].cmode = cmode;
 
-		lane = mv88e6390x_serdes_get_lane(chip, port);
-		if (lane < 0)
-			return lane;
+		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+		if (err)
+			return err;
 
 		err = mv88e6390x_serdes_power(chip, port, true);
 		if (err)
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 678aaba3d019..a9209465e06b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -286,36 +286,33 @@ void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 	chip->ports[port].serdes_irq = 0;
 }
 
-/* Return the SERDES lane address a port is using. Only Ports 9 and 10
- * have SERDES lanes. Returns -ENODEV if a port does not have a lane.
- */
-static int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 
+	*lane = -1;
+
 	switch (port) {
 	case 9:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			return MV88E6390_PORT9_LANE0;
-		return -ENODEV;
+			*lane = MV88E6390_PORT9_LANE0;
+		break;
 	case 10:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			return MV88E6390_PORT10_LANE0;
-		return -ENODEV;
+			*lane = MV88E6390_PORT10_LANE0;
+		break;
 	default:
-		return -ENODEV;
+		break;
 	}
+
+	return *lane == -1 ? -ENODEV : 0;
 }
 
-/* Return the SERDES lane address a port is using. Ports 9 and 10 can
- * use multiple lanes. If so, return the first lane the port uses.
- * Returns -ENODEV if a port does not have a lane.
- */
-int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 {
 	u8 cmode_port9, cmode_port10, cmode_port;
 
@@ -323,76 +320,80 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	cmode_port10 = chip->ports[10].cmode;
 	cmode_port = chip->ports[port].cmode;
 
+	*lane = -1;
+
 	switch (port) {
 	case 2:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT9_LANE1;
-		return -ENODEV;
+				*lane = MV88E6390_PORT9_LANE1;
+		break;
 	case 3:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT9_LANE2;
-		return -ENODEV;
+				*lane = MV88E6390_PORT9_LANE2;
+		break;
 	case 4:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT9_LANE3;
-		return -ENODEV;
+				*lane = MV88E6390_PORT9_LANE3;
+		break;
 	case 5:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT10_LANE1;
-		return -ENODEV;
+				*lane = MV88E6390_PORT10_LANE1;
+		break;
 	case 6:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT10_LANE2;
-		return -ENODEV;
+				*lane = MV88E6390_PORT10_LANE2;
+		break;
 	case 7:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
-				return MV88E6390_PORT10_LANE3;
-		return -ENODEV;
+				*lane = MV88E6390_PORT10_LANE3;
+		break;
 	case 9:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			return MV88E6390_PORT9_LANE0;
-		return -ENODEV;
+			*lane = MV88E6390_PORT9_LANE0;
+		break;
 	case 10:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			return MV88E6390_PORT10_LANE0;
-		return -ENODEV;
+			*lane = MV88E6390_PORT10_LANE0;
+		break;
 	default:
-		return -ENODEV;
+		break;
 	}
+
+	return *lane == -1 ? -ENODEV : 0;
 }
 
 /* Set the power on/off for 10GBASE-R and 10GBASE-X4/X2 */
-static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
+static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, s8 lane,
 				      bool on)
 {
 	u16 val, new_val;
@@ -419,7 +420,7 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
 }
 
 /* Set the power on/off for SGMII and 1000Base-X */
-static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
+static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, s8 lane,
 					bool on)
 {
 	u16 val, new_val;
@@ -445,7 +446,7 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
 }
 
 static int mv88e6390_serdes_power_lane(struct mv88e6xxx_chip *chip, int port,
-				       int lane, bool on)
+				       s8 lane, bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
 
@@ -464,14 +465,14 @@ static int mv88e6390_serdes_power_lane(struct mv88e6xxx_chip *chip, int port,
 
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
-	int lane;
-
-	lane = mv88e6390_serdes_get_lane(chip, port);
-	if (lane == -ENODEV)
-		return 0;
+	s8 lane;
+	int err;
 
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err)
+		return err;
 	if (lane < 0)
-		return lane;
+		return 0;
 
 	switch (port) {
 	case 9 ... 10:
@@ -483,14 +484,14 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 
 int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
-	int lane;
-
-	lane = mv88e6390x_serdes_get_lane(chip, port);
-	if (lane == -ENODEV)
-		return 0;
+	s8 lane;
+	int err;
 
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err)
+		return err;
 	if (lane < 0)
-		return lane;
+		return 0;
 
 	switch (port) {
 	case 2 ... 4:
@@ -503,7 +504,7 @@ int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, int lane)
+					    int port, s8 lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	struct dsa_switch *ds = chip->ds;
@@ -570,7 +571,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     int lane)
+					     s8 lane)
 {
 	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
 				      MV88E6390_SGMII_INT_ENABLE,
@@ -579,14 +580,14 @@ static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_disable_sgmii(struct mv88e6xxx_chip *chip,
-					      int lane)
+					      s8 lane)
 {
 	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
 				      MV88E6390_SGMII_INT_ENABLE, 0);
 }
 
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				int lane)
+				s8 lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	int err = 0;
@@ -602,7 +603,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
-				 int lane)
+				 s8 lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	int err = 0;
@@ -618,7 +619,7 @@ int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
-					     int lane, u16 *status)
+					     s8 lane, u16 *status)
 {
 	int err;
 
@@ -635,10 +636,10 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 	u8 cmode = port->cmode;
 	u16 status;
-	int lane;
 	int err;
+	s8 lane;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port->port);
+	mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -663,16 +664,14 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 
 int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
-	int lane;
 	int err;
+	s8 lane;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port);
-
-	if (lane == -ENODEV)
-		return 0;
-
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err)
+		return err;
 	if (lane < 0)
-		return lane;
+		return 0;
 
 	chip->ports[port].serdes_irq = irq_find_mapping(chip->g2_irq.domain,
 							port);
@@ -711,11 +710,14 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 
 void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 {
-	int lane = mv88e6390x_serdes_get_lane(chip, port);
+	int err;
+	s8 lane;
 
-	if (lane == -ENODEV)
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err) {
+		dev_err(chip->dev, "Unable to free SERDES irq: %d\n", err);
 		return;
-
+	}
 	if (lane < 0)
 		return;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index ff5b94439335..1ddb8fb3aab9 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -74,7 +74,21 @@
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
-int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+/* Put the SERDES lane address a port is using into *lane. If a port has
+ * multiple lanes, should put the first lane the port is using. If a port does
+ * not have a lane, put -1 into *lane.
+ */
+static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
+					    int port, s8 *lane)
+{
+	if (!chip->info->ops->serdes_get_lane)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_get_lane(chip, port, lane);
+}
+
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane);
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane);
 int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
@@ -89,9 +103,9 @@ int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-				int lane);
+				s8 lane);
 int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
-				 int lane);
+				 s8 lane);
 int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 
-- 
2.21.0

