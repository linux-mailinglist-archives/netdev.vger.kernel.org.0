Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C422B135DD
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 00:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfECWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 18:50:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35657 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfECWuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 18:50:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id e5so8625588qtq.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 15:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tQOYHZuPm2LETszd3728VSa9v8SdVavDZmrhYVUW5mk=;
        b=mPHBuuW//faiwwdQcpz55YTgfznK072a0SXhTvr+P+/hj7HSYnU0RhjeD8q9pQ2CTN
         YgkvqddxyvOQiNtkeAc/pU9S+j/sIbBSBjIxGfB3y+qlrEK/bM1cHncx3R2oZlDr7UWC
         cV8MkRPcdZwlAl+3IzzyqYqPgJ03+JZys91DMwoDul2v59k6SdCTZHazMJC+iSz43f2r
         Yd+02gEv3hAtbIjIFe8oQQo4mimtVVyaiK35+0QJSaCu4QCoB2pgXZ1B/6eUmC69MrYN
         NUrRARzzTYvOST96FrxkxeLwcQuVPlwJ34m+sx7Wmsm91s403X3BIJ0w5EhbhRh42k2c
         iErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tQOYHZuPm2LETszd3728VSa9v8SdVavDZmrhYVUW5mk=;
        b=aWmet4Af1FBuZtMTw92lpQIrdQE6IxtL89DrG/r6WLSNeklno2/J/m+A7XuUntH8CW
         HKNbSPzue01YlBOyMbgCs4kcVAEVp5Gvr6u6d063z7SjtJsm2JRsBL94xU4D7XlclNfT
         OSADKS9mNNIlPo95S9YrQFIjM/Pbh+ibS5IkjU9cNAdH0UChbH6LZGscAGYbDtbYAL08
         W1QNWPkK8qBbkqCGHHQPeitBqTrW5PO4+X1Av89RT8xrjFXbaN3CTV2QLcNnF7zk7j6x
         aHHq3PmnWePHfLzBChT4WaxVXbxYlLi5EAs8GdtwJdR5MYIFndMWg/9FvmaouzObOVMe
         bksQ==
X-Gm-Message-State: APjAAAUjp7ZDP6WlM9y3sCKSQ8wmMCSAwZSAWzZt47OdO9xRc2JNY3gX
        YOUmqGLQYFz0DeX16mlg+tbhzeB6d68=
X-Google-Smtp-Source: APXvYqwPqPCNo0ZjAX1CxWEmqCL4YAypZsdlQ891OdjOLTmym0KL6VzhNh0KV74IyWRP2HsX8rFeJQ==
X-Received: by 2002:aed:3822:: with SMTP id j31mr11250118qte.321.1556923815530;
        Fri, 03 May 2019 15:50:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k63sm1803717qkf.97.2019.05.03.15.50.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 15:50:14 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH] net: dsa: mv88e6xxx: refine SMI support
Date:   Fri,  3 May 2019 18:49:37 -0400
Message-Id: <20190503224937.1598-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell SOHO switches have several ways to access the internal
registers. One of them being the System Management Interface (SMI),
using the MDC and MDIO pins, with direct and indirect variants.

In preparation for adding support for other register accesses, move
the SMI code into its own files. At the same time, refine the code
to make it clear that the indirect variant is implemented using the
direct variant accessing only two registers for command and data.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c   | 172 ++---------------------------
 drivers/net/dsa/mv88e6xxx/chip.h   |  11 --
 drivers/net/dsa/mv88e6xxx/smi.c    | 158 ++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/smi.h    |  41 +++++++
 5 files changed, 211 insertions(+), 172 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/smi.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/smi.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index 50de304abe2f..e85755dde90b 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -12,3 +12,4 @@ mv88e6xxx-objs += phy.o
 mv88e6xxx-objs += port.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
+mv88e6xxx-objs += smi.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 489a899c80b6..4c0d06686d53 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -43,6 +43,7 @@
 #include "port.h"
 #include "ptp.h"
 #include "serdes.h"
+#include "smi.h"
 
 static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 {
@@ -52,156 +53,17 @@ static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 	}
 }
 
-/* The switch ADDR[4:1] configuration pins define the chip SMI device address
- * (ADDR[0] is always zero, thus only even SMI addresses can be strapped).
- *
- * When ADDR is all zero, the chip uses Single-chip Addressing Mode, assuming it
- * is the only device connected to the SMI master. In this mode it responds to
- * all 32 possible SMI addresses, and thus maps directly the internal devices.
- *
- * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
- * multiple devices to share the SMI interface. In this mode it responds to only
- * 2 registers, used to indirectly access the internal SMI devices.
- */
-
-static int mv88e6xxx_smi_read(struct mv88e6xxx_chip *chip,
-			      int addr, int reg, u16 *val)
-{
-	if (!chip->smi_ops)
-		return -EOPNOTSUPP;
-
-	return chip->smi_ops->read(chip, addr, reg, val);
-}
-
-static int mv88e6xxx_smi_write(struct mv88e6xxx_chip *chip,
-			       int addr, int reg, u16 val)
-{
-	if (!chip->smi_ops)
-		return -EOPNOTSUPP;
-
-	return chip->smi_ops->write(chip, addr, reg, val);
-}
-
-static int mv88e6xxx_smi_single_chip_read(struct mv88e6xxx_chip *chip,
-					  int addr, int reg, u16 *val)
-{
-	int ret;
-
-	ret = mdiobus_read_nested(chip->bus, addr, reg);
-	if (ret < 0)
-		return ret;
-
-	*val = ret & 0xffff;
-
-	return 0;
-}
-
-static int mv88e6xxx_smi_single_chip_write(struct mv88e6xxx_chip *chip,
-					   int addr, int reg, u16 val)
-{
-	int ret;
-
-	ret = mdiobus_write_nested(chip->bus, addr, reg, val);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_single_chip_ops = {
-	.read = mv88e6xxx_smi_single_chip_read,
-	.write = mv88e6xxx_smi_single_chip_write,
-};
-
-static int mv88e6xxx_smi_multi_chip_wait(struct mv88e6xxx_chip *chip)
-{
-	int ret;
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		ret = mdiobus_read_nested(chip->bus, chip->sw_addr, SMI_CMD);
-		if (ret < 0)
-			return ret;
-
-		if ((ret & SMI_CMD_BUSY) == 0)
-			return 0;
-	}
-
-	return -ETIMEDOUT;
-}
-
-static int mv88e6xxx_smi_multi_chip_read(struct mv88e6xxx_chip *chip,
-					 int addr, int reg, u16 *val)
-{
-	int ret;
-
-	/* Wait for the bus to become free. */
-	ret = mv88e6xxx_smi_multi_chip_wait(chip);
-	if (ret < 0)
-		return ret;
-
-	/* Transmit the read command. */
-	ret = mdiobus_write_nested(chip->bus, chip->sw_addr, SMI_CMD,
-				   SMI_CMD_OP_22_READ | (addr << 5) | reg);
-	if (ret < 0)
-		return ret;
-
-	/* Wait for the read command to complete. */
-	ret = mv88e6xxx_smi_multi_chip_wait(chip);
-	if (ret < 0)
-		return ret;
-
-	/* Read the data. */
-	ret = mdiobus_read_nested(chip->bus, chip->sw_addr, SMI_DATA);
-	if (ret < 0)
-		return ret;
-
-	*val = ret & 0xffff;
-
-	return 0;
-}
-
-static int mv88e6xxx_smi_multi_chip_write(struct mv88e6xxx_chip *chip,
-					  int addr, int reg, u16 val)
-{
-	int ret;
-
-	/* Wait for the bus to become free. */
-	ret = mv88e6xxx_smi_multi_chip_wait(chip);
-	if (ret < 0)
-		return ret;
-
-	/* Transmit the data to write. */
-	ret = mdiobus_write_nested(chip->bus, chip->sw_addr, SMI_DATA, val);
-	if (ret < 0)
-		return ret;
-
-	/* Transmit the write command. */
-	ret = mdiobus_write_nested(chip->bus, chip->sw_addr, SMI_CMD,
-				   SMI_CMD_OP_22_WRITE | (addr << 5) | reg);
-	if (ret < 0)
-		return ret;
-
-	/* Wait for the write command to complete. */
-	ret = mv88e6xxx_smi_multi_chip_wait(chip);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_multi_chip_ops = {
-	.read = mv88e6xxx_smi_multi_chip_read,
-	.write = mv88e6xxx_smi_multi_chip_write,
-};
-
 int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val)
 {
 	int err;
 
 	assert_reg_lock(chip);
 
-	err = mv88e6xxx_smi_read(chip, addr, reg, val);
+	if (chip->smi_ops)
+		err = chip->smi_ops->read(chip, addr, reg, val);
+	else
+		err = -EOPNOTSUPP;
+
 	if (err)
 		return err;
 
@@ -217,7 +79,11 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
 
 	assert_reg_lock(chip);
 
-	err = mv88e6xxx_smi_write(chip, addr, reg, val);
+	if (chip->smi_ops)
+		err = chip->smi_ops->write(chip, addr, reg, val);
+	else
+		err = -EOPNOTSUPP;
+
 	if (err)
 		return err;
 
@@ -4632,22 +4498,6 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 	return chip;
 }
 
-static int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
-			      struct mii_bus *bus, int sw_addr)
-{
-	if (sw_addr == 0)
-		chip->smi_ops = &mv88e6xxx_smi_single_chip_ops;
-	else if (chip->info->multi_chip)
-		chip->smi_ops = &mv88e6xxx_smi_multi_chip_ops;
-	else
-		return -EINVAL;
-
-	chip->bus = bus;
-	chip->sw_addr = sw_addr;
-
-	return 0;
-}
-
 static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 							int port)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 19c07dff0440..faa3fa889f19 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -21,17 +21,6 @@
 #include <linux/timecounter.h>
 #include <net/dsa.h>
 
-#define SMI_CMD			0x00
-#define SMI_CMD_BUSY		BIT(15)
-#define SMI_CMD_CLAUSE_22	BIT(12)
-#define SMI_CMD_OP_22_WRITE	((1 << 10) | SMI_CMD_BUSY | SMI_CMD_CLAUSE_22)
-#define SMI_CMD_OP_22_READ	((2 << 10) | SMI_CMD_BUSY | SMI_CMD_CLAUSE_22)
-#define SMI_CMD_OP_45_WRITE_ADDR	((0 << 10) | SMI_CMD_BUSY)
-#define SMI_CMD_OP_45_WRITE_DATA	((1 << 10) | SMI_CMD_BUSY)
-#define SMI_CMD_OP_45_READ_DATA		((2 << 10) | SMI_CMD_BUSY)
-#define SMI_CMD_OP_45_READ_DATA_INC	((3 << 10) | SMI_CMD_BUSY)
-#define SMI_DATA		0x01
-
 #define MV88E6XXX_N_FID		4096
 
 /* PVT limits for 4-bit port and 5-bit switch */
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
new file mode 100644
index 000000000000..96f7d2685bdc
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -0,0 +1,158 @@
+/*
+ * Marvell 88E6xxx System Management Interface (SMI) support
+ *
+ * Copyright (c) 2008 Marvell Semiconductor
+ *
+ * Copyright (c) 2019 Vivien Didelot <vivien.didelot@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "chip.h"
+#include "smi.h"
+
+/* The switch ADDR[4:1] configuration pins define the chip SMI device address
+ * (ADDR[0] is always zero, thus only even SMI addresses can be strapped).
+ *
+ * When ADDR is all zero, the chip uses Single-chip Addressing Mode, assuming it
+ * is the only device connected to the SMI master. In this mode it responds to
+ * all 32 possible SMI addresses, and thus maps directly the internal devices.
+ *
+ * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
+ * multiple devices to share the SMI interface. In this mode it responds to only
+ * 2 registers, used to indirectly access the internal SMI devices.
+ */
+
+static int mv88e6xxx_smi_direct_read(struct mv88e6xxx_chip *chip,
+				     int dev, int reg, u16 *data)
+{
+	int ret;
+
+	ret = mdiobus_read_nested(chip->bus, dev, reg);
+	if (ret < 0)
+		return ret;
+
+	*data = ret & 0xffff;
+
+	return 0;
+}
+
+static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
+				      int dev, int reg, u16 data)
+{
+	int ret;
+
+	ret = mdiobus_write_nested(chip->bus, dev, reg, data);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
+				     int dev, int reg, int bit, int val)
+{
+	u16 data;
+	int err;
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		err = mv88e6xxx_smi_direct_read(chip, dev, reg, &data);
+		if (err)
+			return err;
+
+		if (!!(data >> bit) == !!val)
+			return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
+	.read = mv88e6xxx_smi_direct_read,
+	.write = mv88e6xxx_smi_direct_write,
+};
+
+/* Offset 0x00: SMI Command Register
+ * Offset 0x01: SMI Data Register
+ */
+
+static int mv88e6xxx_smi_indirect_read(struct mv88e6xxx_chip *chip,
+				       int dev, int reg, u16 *data)
+{
+	int err;
+
+	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
+					MV88E6XXX_SMI_CMD, 15, 0);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_CMD,
+					 MV88E6XXX_SMI_CMD_BUSY |
+					 MV88E6XXX_SMI_CMD_MODE_22 |
+					 MV88E6XXX_SMI_CMD_OP_22_READ |
+					 (dev << 5) | reg);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
+					MV88E6XXX_SMI_CMD, 15, 0);
+	if (err)
+		return err;
+
+	return mv88e6xxx_smi_direct_read(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_DATA, data);
+}
+
+static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
+					int dev, int reg, u16 data)
+{
+	int err;
+
+	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
+					MV88E6XXX_SMI_CMD, 15, 0);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_DATA, data);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_CMD,
+					 MV88E6XXX_SMI_CMD_BUSY |
+					 MV88E6XXX_SMI_CMD_MODE_22 |
+					 MV88E6XXX_SMI_CMD_OP_22_WRITE |
+					 (dev << 5) | reg);
+	if (err)
+		return err;
+
+	return mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_CMD, 15, 0);
+}
+
+static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
+	.read = mv88e6xxx_smi_indirect_read,
+	.write = mv88e6xxx_smi_indirect_write,
+};
+
+int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
+		       struct mii_bus *bus, int sw_addr)
+{
+	if (sw_addr == 0)
+		chip->smi_ops = &mv88e6xxx_smi_direct_ops;
+	else if (chip->info->multi_chip)
+		chip->smi_ops = &mv88e6xxx_smi_indirect_ops;
+	else
+		return -EINVAL;
+
+	chip->bus = bus;
+	chip->sw_addr = sw_addr;
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/smi.h b/drivers/net/dsa/mv88e6xxx/smi.h
new file mode 100644
index 000000000000..566bfa174354
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/smi.h
@@ -0,0 +1,41 @@
+/*
+ * Marvell 88E6xxx System Management Interface (SMI) support
+ *
+ * Copyright (c) 2008 Marvell Semiconductor
+ *
+ * Copyright (c) 2019 Vivien Didelot <vivien.didelot@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _MV88E6XXX_SMI_H
+#define _MV88E6XXX_SMI_H
+
+#include "chip.h"
+
+/* Offset 0x00: SMI Command Register */
+#define MV88E6XXX_SMI_CMD			0x00
+#define MV88E6XXX_SMI_CMD_BUSY			0x8000
+#define MV88E6XXX_SMI_CMD_MODE_MASK		0x1000
+#define MV88E6XXX_SMI_CMD_MODE_45		0x0000
+#define MV88E6XXX_SMI_CMD_MODE_22		0x1000
+#define MV88E6XXX_SMI_CMD_OP_MASK		0x0c00
+#define MV88E6XXX_SMI_CMD_OP_22_WRITE		0x0400
+#define MV88E6XXX_SMI_CMD_OP_22_READ		0x0800
+#define MV88E6XXX_SMI_CMD_OP_45_WRITE_ADDR	0x0000
+#define MV88E6XXX_SMI_CMD_OP_45_WRITE_DATA	0x0400
+#define MV88E6XXX_SMI_CMD_OP_45_READ_DATA	0x0800
+#define MV88E6XXX_SMI_CMD_OP_45_READ_DATA_INC	0x0c00
+#define MV88E6XXX_SMI_CMD_DEV_ADDR_MASK		0x003e
+#define MV88E6XXX_SMI_CMD_REG_ADDR_MASK		0x001f
+
+/* Offset 0x01: SMI Data Register */
+#define MV88E6XXX_SMI_DATA			0x01
+
+int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
+		       struct mii_bus *bus, int sw_addr);
+
+#endif /* _MV88E6XXX_SMI_H */
-- 
2.21.0

