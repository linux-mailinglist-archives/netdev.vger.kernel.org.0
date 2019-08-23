Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F269B820
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436912AbfHWV0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:22 -0400
Received: from mail.nic.cz ([217.31.204.67]:35822 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389949AbfHWV0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:09 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 17F88140D26;
        Fri, 23 Aug 2019 23:26:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595565; bh=YA4Y+xnQzZ0/t4UPZ1C/KVk0e0lgbCQoL2x9XOUjUiY=;
        h=From:To:Date;
        b=IGxsh9m2DbVorsMD8EOBYbxme/CuUzsVY9mclvoMzbvSp7pTd0Kl/3Sryqc3t8/ca
         +CON//AHQWRwEzrS0NnlXlSKYOwUy+kyf8moiCmaXDRmNztYv7ntzA/q0gc6f8J5Rs
         s6LfC/FFu5eQIdlCpwWZNylfj0FmN48DcCWmGQYc=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 4/9] net: dsa: mv88e6xxx: create chip->info->ops->serdes_get_lane method
Date:   Fri, 23 Aug 2019 23:25:58 +0200
Message-Id: <20190823212603.13456-5-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823212603.13456-1-marek.behun@nic.cz>
References: <20190823212603.13456-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a serdes_get_lane() method in the mv88e6xxx operations structure.
Use it instead of calling the different implementations.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  6 ++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  3 +++
 drivers/net/dsa/mv88e6xxx/port.c   |  4 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c | 29 +++++++++++++++++------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  2 ++
 5 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 47927df6d8e0..dfffeaf925a4 100644
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
index a406be2f5652..35faf5be598b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -443,6 +443,9 @@ struct mv88e6xxx_ops {
 	/* Power on/off a SERDES interface */
 	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, bool on);
 
+	/* SERDES lane mapping */
+	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
+
 	/* SERDES interrupt handling */
 	int (*serdes_irq_setup)(struct mv88e6xxx_chip *chip, int port);
 	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index c95cdb73e5a2..092176fd3d90 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -434,7 +434,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (cmode == chip->ports[port].cmode)
 		return 0;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane < 0 && lane != -ENODEV)
 		return lane;
 
@@ -466,7 +466,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 
 		chip->ports[port].cmode = cmode;
 
-		lane = mv88e6390x_serdes_get_lane(chip, port);
+		lane = mv88e6xxx_serdes_get_lane(chip, port);
 		if (lane < 0)
 			return lane;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 678aaba3d019..523f58c57972 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -286,10 +286,19 @@ void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 	chip->ports[port].serdes_irq = 0;
 }
 
-/* Return the SERDES lane address a port is using. Only Ports 9 and 10
- * have SERDES lanes. Returns -ENODEV if a port does not have a lane.
+/* Return the SERDES lane address a port is using. If a port has multiple lanes,
+ * should return the first lane the port is using. Should return -ENODEV if
+ * a port does not have a lane.
  */
-static int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+{
+	if (!chip->info->ops->serdes_get_lane)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->serdes_get_lane(chip, port);
+}
+
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
 
@@ -311,10 +320,6 @@ static int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	}
 }
 
-/* Return the SERDES lane address a port is using. Ports 9 and 10 can
- * use multiple lanes. If so, return the first lane the port uses.
- * Returns -ENODEV if a port does not have a lane.
- */
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode_port9, cmode_port10, cmode_port;
@@ -466,7 +471,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	int lane;
 
-	lane = mv88e6390_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane == -ENODEV)
 		return 0;
 
@@ -485,7 +490,7 @@ int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	int lane;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane == -ENODEV)
 		return 0;
 
@@ -638,7 +643,7 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	int lane;
 	int err;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port->port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port->port);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -666,7 +671,7 @@ int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 	int lane;
 	int err;
 
-	lane = mv88e6390x_serdes_get_lane(chip, port);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
 
 	if (lane == -ENODEV)
 		return 0;
@@ -711,7 +716,7 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 
 void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 {
-	int lane = mv88e6390x_serdes_get_lane(chip, port);
+	int lane = mv88e6xxx_serdes_get_lane(chip, port);
 
 	if (lane == -ENODEV)
 		return;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index ff5b94439335..f2ca3bcc3893 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -74,6 +74,8 @@
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
+int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
-- 
2.21.0

