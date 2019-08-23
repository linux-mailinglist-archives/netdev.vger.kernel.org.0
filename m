Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29F29B81B
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436892AbfHWV0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:10 -0400
Received: from mail.nic.cz ([217.31.204.67]:35860 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391289AbfHWV0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:09 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 98113140DB8;
        Fri, 23 Aug 2019 23:26:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595565; bh=O3EwFaOS3ULVImbf1aFtvpHZw8WZYBChBB+9r/ZGJ9Q=;
        h=From:To:Date;
        b=Gvi0fzUdXFer83KYAOI6IAnfN9W45T3yN6ZwIamP0H6AEcMaZwJf3tuJh2zI+HjKJ
         RP/2H3EMq0uQTvZZ/lfcSK7c6TY+VEkL9k3yiV5Vu3LvIdPrHzWuyvydHfEjO9B3zr
         sWQ0Nx2I37ffOwXfT/x9gQKS0SRea5zWsPgX0E8Q=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 8/9] net: dsa: mv88e6xxx: support Block Address setting in hidden registers
Date:   Fri, 23 Aug 2019 23:26:02 +0200
Message-Id: <20190823212603.13456-9-marek.behun@nic.cz>
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

Add support for setting the Block Address parameter when reading/writing
hidden registers. Marvell's mdio examples for SERDES settings on Topaz
use Block Address 0x7 when reading/writing hidden registers, although
the specification says that block must be set to 0xf.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c        |  4 ++--
 drivers/net/dsa/mv88e6xxx/port.h        | 10 +++++-----
 drivers/net/dsa/mv88e6xxx/port_hidden.c | 12 ++++++------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 43cb48e2ef5f..202ccce65b1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2325,7 +2325,7 @@ static bool mv88e6390_setup_errata_applied(struct mv88e6xxx_chip *chip)
 	u16 val;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6xxx_port_hidden_read(chip, port, 0, &val);
+		err = mv88e6xxx_port_hidden_read(chip, 0xf, port, 0, &val);
 		if (err) {
 			dev_err(chip->dev,
 				"Error reading hidden register: %d\n", err);
@@ -2358,7 +2358,7 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	}
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6xxx_port_hidden_write(chip, port, 0, 0x01c0);
+		err = mv88e6xxx_port_hidden_write(chip, 0xf, port, 0, 0x01c0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index cd7aa7392dfe..04550cb3c3b3 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -266,7 +266,7 @@
 #define MV88E6XXX_PORT_RESERVED_1A_WRITE	0x4000
 #define MV88E6XXX_PORT_RESERVED_1A_READ		0x0000
 #define MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT	5
-#define MV88E6XXX_PORT_RESERVED_1A_BLOCK	0x3c00
+#define MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT	10
 #define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	0x04
 #define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	0x05
 
@@ -353,10 +353,10 @@ int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port);
 
-int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
-				u16 val);
+int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int block, int port,
+				int reg, u16 val);
 int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip);
-int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, int reg,
-			       u16 *val);
+int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
+			       int reg, u16 *val);
 
 #endif /* _MV88E6XXX_PORT_H */
diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv88e6xxx/port_hidden.c
index 37520b6b8c89..fc0a45cb4f68 100644
--- a/drivers/net/dsa/mv88e6xxx/port_hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
@@ -15,8 +15,8 @@
 /* The mv88e6390 and mv88e6341 have some hidden registers used for debug and
  * development. The errata also makes use of them.
  */
-int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
-				u16 val)
+int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int block, int port,
+				int reg, u16 val)
 {
 	u16 ctrl;
 	int err;
@@ -28,7 +28,7 @@ int mv88e6xxx_port_hidden_write(struct mv88e6xxx_chip *chip, int port, int reg,
 
 	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
 	       MV88E6XXX_PORT_RESERVED_1A_WRITE |
-	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       block << MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT |
 	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT |
 	       reg;
 
@@ -44,15 +44,15 @@ int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip)
 				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
-int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int port, int reg,
-			       u16 *val)
+int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
+			       int reg, u16 *val)
 {
 	u16 ctrl;
 	int err;
 
 	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
 	       MV88E6XXX_PORT_RESERVED_1A_READ |
-	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       block << MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT |
 	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT |
 	       reg;
 
-- 
2.21.0

