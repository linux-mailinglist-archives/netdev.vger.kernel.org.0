Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A4C8863F
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfHIWu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38916 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbfHIWuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9so97329926qtu.6
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JhlMx+XHqsvUJoMlKzlcY2+h5n3Y7N5troC4VlOpjJs=;
        b=rapn+jFCPldeoE5FKYeOOxmALFNBIkZBpXApMt4hQ6BUYB7w4h8WqfHKsIF6yyNndu
         t1gj8pgnFP4jbjimfSlQYwfSwO6okqrlrIu/+uRXsnYPs/gYD1YVKHr2qS5dPlM8119l
         0zbbNMoMb4mNhX7PnJfz7s2vmBe8161B7fIRREizwZb7lqlUkd+metJNXqpNSbmkNbm9
         Ls9L2JfHhcYER3PF5htwwAXfgZI3J/alBr94SlrCLTXKqLo7QSlHGc0/A4F4vvsx/Lgc
         2Jz0TC4d5+FbgxfzbsaDaozyyw1Zb1xnr7R3eXVyjFqy7JqAfhcZs39o/0XD7CYbtLJ7
         WBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JhlMx+XHqsvUJoMlKzlcY2+h5n3Y7N5troC4VlOpjJs=;
        b=l93k4BYK1IQfBWcis0wBVNZ38iS5nTFdWsw7NkWTD4oiZr83tzlQGSv2ETOIzOpsl1
         6Z6rcc90ZrDNog5To47evxZR2LdsT0ivMGzvoDa27j6cwfsKsxaYwNzwPTnYlE5a45AF
         RH/f6sxyQhA2LuyKg68psPXJNLh7cFyRUz6hd9DiccgJuXPSqUokyCtFzex6w45hKbda
         vaQNhwU2qqwEBi3c0NOQLNwRYrf14+nm8Yv6D7gXbL2Ca5UdmAxQPnP3c/BhjKGTO9mD
         0K6LUHCINi6yHLsmxCGpy50i0j+by5m/JtxVKgEsE9fLyeeJKxFkPAdnHcXEF1KVIQiV
         NIeg==
X-Gm-Message-State: APjAAAWdqAVLHkUYUYXMqDy6aaD1vF/n5R8qobXxKM0Zim+sHA67zgZ2
        xoXge20h9phRfyMIgSud3toqRD+K
X-Google-Smtp-Source: APXvYqzdJUUY+8Pi00STNdSWyVVZmjpi57Cnz4zUrLNNQlGChtbjKpMngo+c8b9ZhOeMm179VsD7hA==
X-Received: by 2002:ad4:5250:: with SMTP id s16mr20257753qvq.50.1565391023791;
        Fri, 09 Aug 2019 15:50:23 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b202sm43880796qkg.83.2019.08.09.15.50.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:23 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 3/7] net: dsa: mv88e6xxx: introduce wait bit routine
Date:   Fri,  9 Aug 2019 18:47:55 -0400
Message-Id: <20190809224759.5743-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many portions of the driver need to wait until a given bit is set
or cleared. Some busses even have a specific implementation for this
operation. In preparation for such variant, implement a generic Wait
Bit routine that can be used by the driver core functions.

This allows us to get rid of the custom implementations we may find
in the driver. Note that for the EEPROM bits, BUSY and RUNNING bits
are independent, thus it is more efficient to wait independently for
each bit instead of waiting for their mask.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c        | 14 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h        |  2 +
 drivers/net/dsa/mv88e6xxx/global1.c     | 49 +++++++------------------
 drivers/net/dsa/mv88e6xxx/global1.h     |  2 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  7 +++-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |  6 ++-
 drivers/net/dsa/mv88e6xxx/global2.c     | 35 +++++++++++++-----
 drivers/net/dsa/mv88e6xxx/global2.h     |  8 ++++
 8 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd61d0d3a245..b7e0513c675a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -10,6 +10,7 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -103,6 +104,13 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 	return -ETIMEDOUT;
 }
 
+int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
+		       int bit, int val)
+{
+	return mv88e6xxx_wait_mask(chip, addr, reg, BIT(bit),
+				   val ? BIT(bit) : 0x0000);
+}
+
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus;
@@ -2360,8 +2368,10 @@ static int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
 
 static int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_wait(chip, PORT_RESERVED_1A_CTRL_PORT,
-			      PORT_RESERVED_1A, PORT_RESERVED_1A_BUSY);
+	int bit = __bf_shf(PORT_RESERVED_1A_BUSY);
+
+	return mv88e6xxx_wait_bit(chip, PORT_RESERVED_1A_CTRL_PORT,
+				  PORT_RESERVED_1A, bit, 0);
 }
 
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 95b44532a282..9cdb6bfead25 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -592,6 +592,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			u16 mask, u16 val);
 int mv88e6xxx_update(struct mv88e6xxx_chip *chip, int addr, int reg,
 		     u16 update);
+int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
+		       int bit, int val);
 int mv88e6xxx_wait(struct mv88e6xxx_chip *chip, int addr, int reg, u16 mask);
 int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
 			     int speed, int duplex, int pause,
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 482f9f8465af..5ace6490695b 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -32,6 +32,13 @@ int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
 	return mv88e6xxx_wait(chip, chip->info->global1_addr, reg, mask);
 }
 
+int mv88e6xxx_g1_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
+			  bit, int val)
+{
+	return mv88e6xxx_wait_bit(chip, chip->info->global1_addr, reg,
+				  bit, val);
+}
+
 int mv88e6xxx_g1_wait_mask(struct mv88e6xxx_chip *chip, int reg,
 			   u16 mask, u16 val)
 {
@@ -57,49 +64,20 @@ static int mv88e6185_g1_wait_ppu_polling(struct mv88e6xxx_chip *chip)
 
 static int mv88e6352_g1_wait_ppu_polling(struct mv88e6xxx_chip *chip)
 {
-	u16 state;
-	int i, err;
+	int bit = __bf_shf(MV88E6352_G1_STS_PPU_STATE);
 
-	for (i = 0; i < 16; ++i) {
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &state);
-		if (err)
-			return err;
-
-		/* Check the value of the PPUState (or InitState) bit 15 */
-		if (state & MV88E6352_G1_STS_PPU_STATE)
-			return 0;
-
-		usleep_range(1000, 2000);
-	}
-
-	return -ETIMEDOUT;
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
 static int mv88e6xxx_g1_wait_init_ready(struct mv88e6xxx_chip *chip)
 {
-	const unsigned long timeout = jiffies + 1 * HZ;
-	u16 val;
-	int err;
+	int bit = __bf_shf(MV88E6XXX_G1_STS_INIT_READY);
 
 	/* Wait up to 1 second for the switch to be ready. The InitReady bit 11
 	 * is set to a one when all units inside the device (ATU, VTU, etc.)
 	 * have finished their initialization and are ready to accept frames.
 	 */
-	while (time_before(jiffies, timeout)) {
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &val);
-		if (err)
-			return err;
-
-		if (val & MV88E6XXX_G1_STS_INIT_READY)
-			break;
-
-		usleep_range(1000, 2000);
-	}
-
-	if (time_after(jiffies, timeout))
-		return -ETIMEDOUT;
-
-	return 0;
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
 /* Offset 0x01: Switch MAC Address Register Bytes 0 & 1
@@ -455,8 +433,9 @@ int mv88e6xxx_g1_set_device_number(struct mv88e6xxx_chip *chip, int index)
 
 static int mv88e6xxx_g1_stats_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g1_wait(chip, MV88E6XXX_G1_STATS_OP,
-				 MV88E6XXX_G1_STATS_OP_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G1_STATS_OP_BUSY);
+
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STATS_OP, bit, 0);
 }
 
 int mv88e6095_g1_stats_set_histogram(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 48869d7984f4..ffa11749fecb 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -250,6 +250,8 @@
 int mv88e6xxx_g1_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g1_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
 int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask);
+int mv88e6xxx_g1_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
+			  bit, int val);
 int mv88e6xxx_g1_wait_mask(struct mv88e6xxx_chip *chip, int reg,
 			   u16 mask, u16 val);
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 1cf388e9bd94..18b86515b6bc 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -5,6 +5,8 @@
  * Copyright (c) 2008 Marvell Semiconductor
  * Copyright (c) 2017 Savoir-faire Linux, Inc.
  */
+
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 
@@ -75,8 +77,9 @@ int mv88e6xxx_g1_atu_set_age_time(struct mv88e6xxx_chip *chip,
 
 static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g1_wait(chip, MV88E6XXX_G1_ATU_OP,
-				 MV88E6XXX_G1_ATU_OP_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G1_ATU_OP_BUSY);
+
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
 }
 
 static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 6cac997360e8..33056a609e96 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2017 Savoir-faire Linux, Inc.
  */
 
+#include <linux/bitfield.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 
@@ -67,8 +68,9 @@ static int mv88e6xxx_g1_vtu_sid_write(struct mv88e6xxx_chip *chip,
 
 static int mv88e6xxx_g1_vtu_op_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g1_wait(chip, MV88E6XXX_G1_VTU_OP,
-				 MV88E6XXX_G1_VTU_OP_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G1_VTU_OP_BUSY);
+
+	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_VTU_OP, bit, 0);
 }
 
 static int mv88e6xxx_g1_vtu_op(struct mv88e6xxx_chip *chip, u16 op)
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 2305b94b3051..b5acf45f30cb 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -36,6 +36,13 @@ int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
 	return mv88e6xxx_wait(chip, chip->info->global2_addr, reg, mask);
 }
 
+int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg, int
+			  bit, int val)
+{
+	return mv88e6xxx_wait_bit(chip, chip->info->global2_addr, reg,
+				  bit, val);
+}
+
 /* Offset 0x00: Interrupt Source Register */
 
 static int mv88e6xxx_g2_int_source(struct mv88e6xxx_chip *chip, u16 *src)
@@ -178,8 +185,9 @@ int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_g2_irl_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g2_wait(chip, MV88E6XXX_G2_IRL_CMD,
-				 MV88E6XXX_G2_IRL_CMD_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G2_IRL_CMD_BUSY);
+
+	return mv88e6xxx_g2_wait_bit(chip, MV88E6XXX_G2_IRL_CMD, bit, 0);
 }
 
 static int mv88e6xxx_g2_irl_op(struct mv88e6xxx_chip *chip, u16 op, int port,
@@ -214,8 +222,9 @@ int mv88e6390_g2_irl_init_all(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_g2_pvt_op_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g2_wait(chip, MV88E6XXX_G2_PVT_ADDR,
-				 MV88E6XXX_G2_PVT_ADDR_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G2_PVT_ADDR_BUSY);
+
+	return mv88e6xxx_g2_wait_bit(chip, MV88E6XXX_G2_PVT_ADDR, bit, 0);
 }
 
 static int mv88e6xxx_g2_pvt_op(struct mv88e6xxx_chip *chip, int src_dev,
@@ -308,9 +317,16 @@ int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_g2_eeprom_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g2_wait(chip, MV88E6XXX_G2_EEPROM_CMD,
-				 MV88E6XXX_G2_EEPROM_CMD_BUSY |
-				 MV88E6XXX_G2_EEPROM_CMD_RUNNING);
+	int bit = __bf_shf(MV88E6XXX_G2_EEPROM_CMD_BUSY);
+	int err;
+
+	err = mv88e6xxx_g2_wait_bit(chip, MV88E6XXX_G2_EEPROM_CMD, bit, 0);
+	if (err)
+		return err;
+
+	bit = __bf_shf(MV88E6XXX_G2_EEPROM_CMD_RUNNING);
+
+	return mv88e6xxx_g2_wait_bit(chip, MV88E6XXX_G2_EEPROM_CMD, bit, 0);
 }
 
 static int mv88e6xxx_g2_eeprom_cmd(struct mv88e6xxx_chip *chip, u16 cmd)
@@ -572,8 +588,9 @@ int mv88e6xxx_g2_set_eeprom16(struct mv88e6xxx_chip *chip,
 
 static int mv88e6xxx_g2_smi_phy_wait(struct mv88e6xxx_chip *chip)
 {
-	return mv88e6xxx_g2_wait(chip, MV88E6XXX_G2_SMI_PHY_CMD,
-				 MV88E6XXX_G2_SMI_PHY_CMD_BUSY);
+	int bit = __bf_shf(MV88E6XXX_G2_SMI_PHY_CMD_BUSY);
+
+	return mv88e6xxx_g2_wait_bit(chip, MV88E6XXX_G2_SMI_PHY_CMD, bit, 0);
 }
 
 static int mv88e6xxx_g2_smi_phy_cmd(struct mv88e6xxx_chip *chip, u16 cmd)
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index a664fc25f132..f5574e463a92 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -297,6 +297,8 @@ int mv88e6xxx_g2_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g2_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
 int mv88e6xxx_g2_update(struct mv88e6xxx_chip *chip, int reg, u16 update);
 int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask);
+int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg,
+			  int bit, int val);
 
 int mv88e6352_g2_irl_init_all(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g2_irl_init_all(struct mv88e6xxx_chip *chip, int port);
@@ -386,6 +388,12 @@ static inline int mv88e6xxx_g2_wait(struct mv88e6xxx_chip *chip, int reg, u16 ma
 	return -EOPNOTSUPP;
 }
 
+static inline int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip,
+					int reg, int bit, int val)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int mv88e6352_g2_irl_init_all(struct mv88e6xxx_chip *chip,
 					    int port)
 {
-- 
2.22.0

