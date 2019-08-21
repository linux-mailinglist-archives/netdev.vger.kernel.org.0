Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DD987D2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbfHUX1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:38026 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730162AbfHUX13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:29 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 1E663140C6D;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=yMsMoYFjI0gNMibZfgvjdsqnmAz1R4+9czRcuChSS38=;
        h=From:To:Date;
        b=jRqECGUhOfSvTvE/r0+wDh0Sl1yqy0iTyBl5KC65WAaBHn6qp7UuTa0Qrs2dSm9Si
         ChrMVHA+WFfoo65BZl3tXUBGAF5Y+aw3Qs4JF0AjUESLt5wmEtwIomB+N0cpEcaVqc
         /ysGOE0iqEAckHY7rMRgAzgI2bJOv0ebss6aFqzU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 03/10] net: dsa: mv88e6xxx: move hidden registers operations in own file
Date:   Thu, 22 Aug 2019 01:27:17 +0200
Message-Id: <20190821232724.1544-4-marek.behun@nic.cz>
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

This patch moves the functions operating on the hidden debug registers
into it's own file, hidden.c.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/Makefile |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c   | 54 +-----------------------
 drivers/net/dsa/mv88e6xxx/hidden.c | 67 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/hidden.h | 31 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h   | 10 -----
 5 files changed, 100 insertions(+), 63 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/hidden.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/hidden.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index e85755dde90b..40f52d8f478a 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -7,6 +7,7 @@ mv88e6xxx-objs += global1_vtu.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2_avb.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2) += global2_scratch.o
+mv88e6xxx-objs += hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += hwtstamp.o
 mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 176173d96512..2dab46ad1d63 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -34,6 +34,7 @@
 #include "chip.h"
 #include "global1.h"
 #include "global2.h"
+#include "hidden.h"
 #include "hwtstamp.h"
 #include "phy.h"
 #include "port.h"
@@ -2317,59 +2318,6 @@ static int mv88e6xxx_stats_setup(struct mv88e6xxx_chip *chip)
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
diff --git a/drivers/net/dsa/mv88e6xxx/hidden.c b/drivers/net/dsa/mv88e6xxx/hidden.c
new file mode 100644
index 000000000000..6ea47b03679f
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/hidden.c
@@ -0,0 +1,67 @@
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
+#include "hidden.h"
+
+/* The mv88e6390 and mv88e6341 have some hidden registers used for debug and
+ * development. The errata also makes use of them.
+ */
+int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
+			   int reg, u16 val)
+{
+	u16 ctrl;
+	int err;
+
+	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_DATA_PORT,
+				   PORT_RESERVED_1A, val);
+	if (err)
+		return err;
+
+	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_WRITE |
+	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
+	       reg;
+
+	return mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
+				    PORT_RESERVED_1A, ctrl);
+}
+
+int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
+{
+	int bit = __bf_shf(PORT_RESERVED_1A_BUSY);
+
+	return mv88e6xxx_wait_bit(chip, PORT_RESERVED_1A_CTRL_PORT,
+				  PORT_RESERVED_1A, bit, 0);
+}
+
+int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
+			  int reg, u16 *val)
+{
+	u16 ctrl;
+	int err;
+
+	ctrl = PORT_RESERVED_1A_BUSY | PORT_RESERVED_1A_READ |
+	       PORT_RESERVED_1A_BLOCK | port << PORT_RESERVED_1A_PORT_SHIFT |
+	       reg;
+
+	err = mv88e6xxx_port_write(chip, PORT_RESERVED_1A_CTRL_PORT,
+				   PORT_RESERVED_1A, ctrl);
+	if (err)
+		return err;
+
+	err = mv88e6390_hidden_wait(chip);
+	if (err)
+		return err;
+
+	return mv88e6xxx_port_read(chip, PORT_RESERVED_1A_DATA_PORT,
+				   PORT_RESERVED_1A, val);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/hidden.h b/drivers/net/dsa/mv88e6xxx/hidden.h
new file mode 100644
index 000000000000..5e2de0a7f22d
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/hidden.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Marvell 88E6xxx Switch Hidden Registers support
+ *
+ * Copyright (c) 2008 Marvell Semiconductor
+ *
+ * Copyright (c) 2019 Andrew Lunn <andrew@lunn.ch>
+ */
+
+#ifndef _MV88E6XXX_HIDDEN_H
+#define _MV88E6XXX_HIDDEN_H
+
+#include "chip.h"
+
+/* Offset 0x1a: Magic undocumented errata register */
+#define PORT_RESERVED_1A			0x1a
+#define PORT_RESERVED_1A_BUSY			BIT(15)
+#define PORT_RESERVED_1A_WRITE			BIT(14)
+#define PORT_RESERVED_1A_READ			0
+#define PORT_RESERVED_1A_PORT_SHIFT		5
+#define PORT_RESERVED_1A_BLOCK			(0xf << 10)
+#define PORT_RESERVED_1A_CTRL_PORT		4
+#define PORT_RESERVED_1A_DATA_PORT		5
+
+int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
+			   int reg, u16 val);
+int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip);
+int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
+			  int reg, u16 *val);
+
+#endif /* _MV88E6XXX_HIDDEN_H */
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 1abf5ea033e2..5c5e8e7397eb 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -260,16 +260,6 @@
 /* Offset 0x19: Port IEEE Priority Remapping Registers (4-7) */
 #define MV88E6095_PORT_IEEE_PRIO_REMAP_4567	0x19
 
-/* Offset 0x1a: Magic undocumented errata register */
-#define PORT_RESERVED_1A			0x1a
-#define PORT_RESERVED_1A_BUSY			BIT(15)
-#define PORT_RESERVED_1A_WRITE			BIT(14)
-#define PORT_RESERVED_1A_READ			0
-#define PORT_RESERVED_1A_PORT_SHIFT		5
-#define PORT_RESERVED_1A_BLOCK			(0xf << 10)
-#define PORT_RESERVED_1A_CTRL_PORT		4
-#define PORT_RESERVED_1A_DATA_PORT		5
-
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val);
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
-- 
2.21.0

