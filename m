Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54481987CD
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbfHUX1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:36 -0400
Received: from mail.nic.cz ([217.31.204.67]:38048 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbfHUX1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:30 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id BF5F3140CA7;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=o9b77+JIo4bc4t3WIU2/V5K5TKLVmX/qtv231pl+k/Y=;
        h=From:To:Date;
        b=IBjKGraRrXvG+wLv5alByXS+lBOW+WRo3IaBjmTUJn4qrvxv9oyvwwThfGGQgHh7P
         KEnEC9AkFKX8GAjePVWVHMaC3Y+BFuE5DthSJ9KErhb+DHVXIxK50RGfldOm4qSOL2
         GUYWGKb1NO8b8f8IZWoQqlnd25kd4vBnqwZrZQ/M=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 08/10] net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
Date:   Thu, 22 Aug 2019 01:27:22 +0200
Message-Id: <20190821232724.1544-9-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821232724.1544-1-marek.behun@nic.cz>
References: <20190821232724.1544-1-marek.behun@nic.cz>
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

Now that we have correct serdes_get_lane() for Topaz and Peridot
families, we can merge the implementations of their other SERDES
functions. We can skip checking port number, since the serdes_get_lane()
method return -ENODEV if a given port does not have a lane or does not
support given cmode.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 16 +++---
 drivers/net/dsa/mv88e6xxx/port.c   |  4 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 91 ++++--------------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 --
 4 files changed, 21 insertions(+), 94 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 080a5d707714..96f7ac56dd02 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2928,7 +2928,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.serdes_power = mv88e6341_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
@@ -3303,10 +3303,10 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
-	.serdes_power = mv88e6390x_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
-	.serdes_irq_setup = mv88e6390x_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390x_serdes_irq_free,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
@@ -3623,7 +3623,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.serdes_power = mv88e6341_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -3857,10 +3857,10 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.rmu_disable = mv88e6390_g1_rmu_disable,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
-	.serdes_power = mv88e6390x_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
-	.serdes_irq_setup = mv88e6390x_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390x_serdes_irq_free,
+	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
+	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index b1f66ea833ed..815a7371977b 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -445,7 +445,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				return err;
 		}
 
-		err = mv88e6390x_serdes_power(chip, port, false);
+		err = mv88e6390_serdes_power(chip, port, false);
 		if (err)
 			return err;
 	}
@@ -470,7 +470,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		if (lane < 0)
 			return lane;
 
-		err = mv88e6390x_serdes_power(chip, port, true);
+		err = mv88e6390_serdes_power(chip, port, true);
 		if (err)
 			return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index fd27b60875e0..09182690f021 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -464,27 +464,10 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
 	return err;
 }
 
-static int mv88e6390_serdes_power_lane(struct mv88e6xxx_chip *chip, int port,
-				       int lane, bool on)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, on);
-	case MV88E6XXX_PORT_STS_CMODE_XAUI:
-	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		return mv88e6390_serdes_power_10g(chip, lane, on);
-	}
-
-	return 0;
-}
-
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	int lane;
+	u8 cmode = chip->ports[port].cmode;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane == -ENODEV)
@@ -493,30 +476,14 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 	if (lane < 0)
 		return lane;
 
-	switch (port) {
-	case 9 ... 10:
-		return mv88e6390_serdes_power_lane(chip, port, lane, on);
-	}
-
-	return 0;
-}
-
-int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
-{
-	int lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == -ENODEV)
-		return 0;
-
-	if (lane < 0)
-		return lane;
-
-	switch (port) {
-	case 2 ... 4:
-	case 5 ... 7:
-	case 9 ... 10:
-		return mv88e6390_serdes_power_lane(chip, port, lane, on);
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+	case MV88E6XXX_PORT_STS_CMODE_XAUI:
+	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
+		return mv88e6390_serdes_power_10g(chip, lane, on);
 	}
 
 	return 0;
@@ -681,7 +648,7 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	return ret;
 }
 
-int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
 	int lane;
 	int err;
@@ -721,15 +688,7 @@ int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 	return mv88e6390_serdes_irq_enable(chip, port, lane);
 }
 
-int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
-{
-	if (port < 9)
-		return 0;
-
-	return mv88e6390x_serdes_irq_setup(chip, port);
-}
-
-void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
+void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 {
 	int lane = mv88e6xxx_serdes_get_lane(chip, port);
 
@@ -750,31 +709,3 @@ void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 
 	chip->ports[port].serdes_irq = 0;
 }
-
-void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
-{
-	if (port < 9)
-		return;
-
-	mv88e6390x_serdes_irq_free(chip, port);
-}
-
-int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
-{
-	u8 cmode = chip->ports[port].cmode;
-	int lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == -ENODEV)
-		return 0;
-
-	if (lane < 0)
-		return lane;
-
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-		return mv88e6390_serdes_power_sgmii(chip, lane, on);
-
-	return 0;
-}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index de6f1939c541..7b4fd25fc4ea 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -78,14 +78,10 @@ int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
-int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
 int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
-int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
-void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-- 
2.21.0

