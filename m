Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9599987CE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfHUX1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:37 -0400
Received: from mail.nic.cz ([217.31.204.67]:38046 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730401AbfHUX1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:30 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id E1C1A140CA9;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430046; bh=w6SImRmA+duHF5eVgXPKvT4TwdtX8ccwixT4CUVdOGg=;
        h=From:To:Date;
        b=At2MAfWG4loUoKJIjomLwmtVS+7FGT6YOfa/Cn6Bu/NmGGrHohbNrHBE0MGVGth7X
         ynNrcKJC5+Hn3kUITP5Moixy247gvkfDKTHU9lBHLUGnMatyIq9dwm3FF7QM9x342Z
         FRfnMWBaPQB8HOYw1RfLeGDqNYdjJnC/Eky1th/Y=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 09/10] net: dsa: mv88e6xxx: support Block Address setting in hidden registers
Date:   Thu, 22 Aug 2019 01:27:23 +0200
Message-Id: <20190821232724.1544-10-marek.behun@nic.cz>
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

Add support for setting the Block Address parameter when reading/writing
hidden registers. Marvell's mdio examples for SERDES settings on Topaz
use Block Address 0x7 when reading/writing hidden registers, although
the specification says that block must be set to 0xf.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 4 ++--
 drivers/net/dsa/mv88e6xxx/hidden.c | 8 ++++----
 drivers/net/dsa/mv88e6xxx/hidden.h | 8 +++++---
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 96f7ac56dd02..9af6f3aeb83b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2326,7 +2326,7 @@ static bool mv88e6390_setup_errata_applied(struct mv88e6xxx_chip *chip)
 	u16 val;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6390_hidden_read(chip, port, 0, &val);
+		err = mv88e6390_hidden_read(chip, 0xf, port, 0, &val);
 		if (err) {
 			dev_err(chip->dev,
 				"Error reading hidden register: %d\n", err);
@@ -2359,7 +2359,7 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	}
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
-		err = mv88e6390_hidden_write(chip, port, 0, 0x01c0);
+		err = mv88e6390_hidden_write(chip, 0xf, port, 0, 0x01c0);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/dsa/mv88e6xxx/hidden.c b/drivers/net/dsa/mv88e6xxx/hidden.c
index efa93c776a30..d071c8810057 100644
--- a/drivers/net/dsa/mv88e6xxx/hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/hidden.c
@@ -16,7 +16,7 @@
 /* The mv88e6390 and mv88e6341 have some hidden registers used for debug and
  * development. The errata also makes use of them.
  */
-int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
+int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int block, int port,
 			   int reg, u16 val)
 {
 	u16 ctrl;
@@ -29,7 +29,7 @@ int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
 
 	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
 	       MV88E6XXX_PORT_RESERVED_1A_WRITE |
-	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       (block << MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT) |
 	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT | reg;
 
 	return mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
@@ -44,7 +44,7 @@ int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip)
 				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
-int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
+int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
 			  int reg, u16 *val)
 {
 	u16 ctrl;
@@ -52,7 +52,7 @@ int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
 
 	ctrl = MV88E6XXX_PORT_RESERVED_1A_BUSY |
 	       MV88E6XXX_PORT_RESERVED_1A_READ |
-	       MV88E6XXX_PORT_RESERVED_1A_BLOCK |
+	       (block << MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT) |
 	       port << MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT | reg;
 
 	err = mv88e6xxx_port_write(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
diff --git a/drivers/net/dsa/mv88e6xxx/hidden.h b/drivers/net/dsa/mv88e6xxx/hidden.h
index 632abbe4e139..71cc2f78fa30 100644
--- a/drivers/net/dsa/mv88e6xxx/hidden.h
+++ b/drivers/net/dsa/mv88e6xxx/hidden.h
@@ -18,14 +18,16 @@
 #define MV88E6XXX_PORT_RESERVED_1A_WRITE	BIT(14)
 #define MV88E6XXX_PORT_RESERVED_1A_READ		0
 #define MV88E6XXX_PORT_RESERVED_1A_PORT_SHIFT	5
-#define MV88E6XXX_PORT_RESERVED_1A_BLOCK	(0xf << 10)
+#define MV88E6XXX_PORT_RESERVED_1A_BLOCK_SHIFT	10
 #define MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT	4
 #define MV88E6XXX_PORT_RESERVED_1A_DATA_PORT	5
+#define MV88E6341_PORT_RESERVED_1A_FORCE_CMODE	BIT(15)
+#define MV88E6341_PORT_RESERVED_1A_SGMII_AN	BIT(13)
 
-int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int port,
+int mv88e6390_hidden_write(struct mv88e6xxx_chip *chip, int block, int port,
 			   int reg, u16 val);
 int mv88e6390_hidden_wait(struct mv88e6xxx_chip *chip);
-int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int port,
+int mv88e6390_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
 			  int reg, u16 *val);
 
 #endif /* _MV88E6XXX_HIDDEN_H */
-- 
2.21.0

