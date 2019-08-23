Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0339B81A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436873AbfHWV0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:09 -0400
Received: from mail.nic.cz ([217.31.204.67]:35814 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389963AbfHWV0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:08 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id CF93A140D24;
        Fri, 23 Aug 2019 23:26:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595564; bh=nbqepBio2uXo7bvD2XNXf8NDHlHWu9qy+FDwoFQk1E8=;
        h=From:To:Date;
        b=Aa0JRpiVW/9Q5/bMbZlPbaQdM4AHE5N9pr1Uswl6NXfKRx3hU6ckxva1PcM2GIPjh
         PiX+LyrouL1xoMjjFgZivP74vrphmBfWXmt3UMqpNdwXXcGO9DHkH5nLj4vAEWOEPo
         OrHDwgCFRU6RB7l48wrlDYv7TUJ+R+MGtMA9Hmec=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 2/9] net: dsa: mv88e6xxx: move hidden registers operations in own file
Date:   Fri, 23 Aug 2019 23:25:56 +0200
Message-Id: <20190823212603.13456-3-marek.behun@nic.cz>
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

This patch moves the functions operating on the hidden debug registers
into it's own file, port_hidden.c. The functions prefix is renamed from
mv88e6390_hidden_ to mv88e6xxx_port_hidden_, to be consistent with the
rest of this driver.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c        | 58 +-------------------
 drivers/net/dsa/mv88e6xxx/port.h        |  6 +++
 drivers/net/dsa/mv88e6xxx/port_hidden.c | 70 +++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 56 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index e85755dde90b..aa645ff86f64 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -10,6 +10,7 @@ mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2_scratch.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
+mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0bf98c10b2b..47927df6d8e0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2317,60 +2317,6 @@ static int mv88e6xxx_stats_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_stats_clear(chip);
 }
 
-/* The mv88e6390 has some hidden registers used for debug and
- * development. The errata also makes use of them.
- */
-static int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
-				  int reg, u16 val)
-{
-	u16 ctrl;
-	int err;
-
-	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_DATA_PORT,
-				   PORT_RESERVED_1A, val);
-	if (err)
-		return err;
-
-	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_WRITE |
-	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
-	       reg;
-
-	return mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
-				    PORT_RESERVED_1A, ctrl);
-}
-
-static int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
-{
-	int bit = __bf_shf(PORT_RESERVED_1A_BUSY);
-
-	return mv88e6xxx_wait_bit(chip, PORT_RESERVED_1A_CTRL_PORT,
-				  PORT_RESERVED_1A, bit, 0);
-}
-
-
-static int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
-				  int reg, u16 *val)
-{
-	u16 ctrl;
-	int err;
-
-	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_READ |
-	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
-	       reg;
-
-	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
-				   PORT_RESERVED_1A, ctrl);
-	if (err)
-		return err;
-
-	err = mv88e6390_hidden_wait(chip);
-	if (err)
-		return err;
-
-	return 	mv88e6xxx_port_read(chip, PORT_RESERVED_1A_DATA_PORT,
-				    PORT_RESERVED_1A, val);
-}
-
 /* Check if the errata has already been applied. */
 static bool mv88e6390_setup_errata_applied(struct mv88e6xxx_chip *chip)
 {
@@ -2379,7 +2325,7 @@ static bool mv88e6390_setup_errata_applied(struct mv88e6xxx_chip *chip)
 	u16 val;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6390_hidden_read(chip, port, 0, &val);
+		err = mv88e6xxx_port_hidden_read(chip, port, 0, &val);
 		if (err) {
 			dev_err(chip->dev,
 				"Error reading hidden register: %d\n", err);
@@ -2412,7 +2358,7 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	}
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6390_hidden_write(chip, port, 0, 0x01c0);
+		err = mv88e6xxx_port_hidden_write(chip, port, 0, 0x01c0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 1abf5ea033e2..2b251ba30e52 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -353,4 +353,10 @@ int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port);
 
+int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
+				u16 val);
+int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, int reg,
+			       u16 *val);
+
 #endif /* _MV88E6XXX_PORT_H */
diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv88e6xxx/port_hidden.c
new file mode 100644
index 000000000000..37520b6b8c89
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Marvell 88E6xxx Switch Hidden Registers support
+ *
+ * Copyright (c) 2008 Marvell Semiconductor
+ *
+ * Copyright (c) 2019 Andrew Lunn <andrew@lunn.ch>
+ */
+
+#include <linux/bitfield.h>
+
+#include "chip.h"
+#include "port.h"
+
+/* The mv88e6390 and mv88e6341 have some hidden registers used for debug and
+ * development. The errata also makes use of them.
+ */
+int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
+				u16 val)
+{
+	u16 ctrl;
+	int err;
+
+	err = mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_DATA_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, val);
+	if (err)
+		return err;
+
+	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
+	       MV88E6XXX_PORT_RESERVED_1A_WRITE |
+	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT |
+	       reg;
+
+	return mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				    MV88E6XXX_PORT_RESERVED_1A, ctrl);
+}
+
+int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip)
+{
+	int bit = __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
+
+	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
+}
+
+int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, int reg,
+			       u16 *val)
+{
+	u16 ctrl;
+	int err;
+
+	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
+	       MV88E6XXX_PORT_RESERVED_1A_READ |
+	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT |
+	       reg;
+
+	err = mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, ctrl);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_hidden_wait(chip);
+	if (err)
+		return err;
+
+	return mv88e6xxx_port_read(chip, MV88E6XXX_PORT_RESERVED_1A_DATA_PORT,
+				   MV88E6XXX_PORT_RESERVED_1A, val);
+}
-- 
2.21.0

