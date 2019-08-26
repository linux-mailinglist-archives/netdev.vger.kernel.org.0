Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2F9D867
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfHZVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:32:06 -0400
Received: from mail.nic.cz ([217.31.204.67]:35110 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbfHZVcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 17:32:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 74F0D140B41;
        Mon, 26 Aug 2019 23:31:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566855119; bh=ynQ6yZa7b+PivtNUZv1tkaPYZTzTc3OKD5cvlYKPb9E=;
        h=From:To:Date;
        b=hKlNNnHRFGVpgMuMq+3gj/hqXAAHxe5mzKIZwbIsmGrZPcJFJMehh4AsFasvGtbre
         I4oJbmO2GWYt/pysvCpgU+tqPOwTD57nnL+Yu05FMRc0SJfaZ++xpUrbZ6RXRZ0uJu
         unagibQi1mU/+HHeqQlYd/ESilYB7aai0lJ+2IM0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v5 4/6] net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
Date:   Mon, 26 Aug 2019 23:31:53 +0200
Message-Id: <20190826213155.14685-5-marek.behun@nic.cz>
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

By adding an additional serdes_get_lane implementation (for Topaz), we
can merge the implementations of other SERDES functions (powering and
IRQs). We can skip checking port numbers, since the serdes_get_lane()
methods inform if there is no lane on a port or if the lane cannot be
used for given cmode.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  18 ++---
 drivers/net/dsa/mv88e6xxx/port.c   |   4 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 105 ++++++++---------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |   7 +-
 4 files changed, 42 insertions(+), 92 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5a3fff1971b9..202ccce65b1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2927,7 +2927,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.serdes_power = mv88e6341_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3301,10 +3302,10 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
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
@@ -3621,7 +3622,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
-	.serdes_power = mv88e6341_serdes_power,
+	.serdes_power = mv88e6390_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3854,10 +3856,10 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
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
index 4b0c58c30fea..dde863166da7 100644
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
 		if (err)
 			return err;
 
-		err = mv88e6390x_serdes_power(chip, port, true);
+		err = mv88e6390_serdes_power(chip, port, true);
 		if (err)
 			return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index e58bccc25b7e..12fcc512afad 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -286,6 +286,23 @@ void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 	chip->ports[port].serdes_irq = 0;
 }
 
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (port != 5)
+		return -ENODEV;
+
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX) {
+		*lane = MV88E6341_PORT5_LANE;
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -467,26 +484,9 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	return err;
 }
 
-static int mv88e6390_serdes_power_lane(struct mv88e6xxx_chip *chip, int port,
-				       u8 lane, bool on)
-{
-	u8 cmode = chip->ports[port].cmode;
-
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
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
+	u8 cmode = chip->ports[port].cmode;
 	u8 lane;
 	int err;
 
@@ -497,31 +497,14 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 		return err;
 	}
 
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
-	u8 lane;
-	int err;
-
-	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
-	if (err) {
-		if (err == -ENODEV)
-			err = 0;
-		return err;
-	}
-
-	switch (port) {
-	case 2 ... 4:
-	case 5 ... 7:
-	case 9 ... 10:
-		return mv88e6390_serdes_power_lane(chip, port, lane, on);
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+	case MV88E6XXX_PORT_STS_CMODE_XAUI:
+	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
+		return mv88e6390_serdes_power_10g(chip, lane, on);
 	}
 
 	return 0;
@@ -686,7 +669,7 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 	return ret;
 }
 
-int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 {
 	int err;
 	u8 lane;
@@ -725,15 +708,7 @@ int mv88e6390x_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
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
 	int err;
 	u8 lane;
@@ -757,27 +732,3 @@ void mv88e6390x_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 
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
-
-	if (port != 5)
-		return 0;
-
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
-	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-		return mv88e6390_serdes_power_sgmii(chip, MV88E6341_ADDR_SERDES,
-						    on);
-
-	return 0;
-}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 959b8cef0b67..c2e6fc3ddf8b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -28,7 +28,7 @@
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
 
-#define MV88E6341_ADDR_SERDES		0x15
+#define MV88E6341_PORT5_LANE		0x15
 
 #define MV88E6390_PORT9_LANE0		0x09
 #define MV88E6390_PORT9_LANE1		0x12
@@ -87,16 +87,13 @@ static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->serdes_get_lane(chip, port, lane);
 }
 
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
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

