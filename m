Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE24987C9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfHUX13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:29 -0400
Received: from mail.nic.cz ([217.31.204.67]:38046 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbfHUX12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:28 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 87495140C96;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=n7mf11nqbF97H6ifG6vXHqj9Qwf7OrQlDzzcPDdEGpM=;
        h=From:To:Date;
        b=ZfZ0INUkdAIErCTdPoqjFPbnGXXJ9oP7fOu19Kk7a/Ps6wSkNo9dtjp/XcDvfMUns
         yTDuOS2jnZZ+dTPPIzUfLzPGwtSYe/Xty76EBS4Di24xBUSPSrCUzC5JBfXglFlqVM
         eb6YY2/FcrN+Qvvz6D4va3OuhdKOYa7Zvl9r9L4E=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 06/10] net: dsa: mv88e6xxx: add serdes_get_lane method for Topaz family
Date:   Thu, 22 Aug 2019 01:27:20 +0200
Message-Id: <20190821232724.1544-7-marek.behun@nic.cz>
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

The Topaz family has only one SERDES, on port 5, with address 0x15.
Currently we have MV88E6341_ADDR_SERDES macro used in the
mv88e6341_serdes_power method. Rename the macro to MV88E6341_PORT5_LANE
and use the new mv88e6xxx_serdes_get_lane method in
mv88e6341_serdes_power.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  2 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 25 ++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h |  3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2340634aab27..080a5d707714 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2929,6 +2929,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6341_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3623,6 +3624,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6341_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 011322fa24ae..87c967e7f1ae 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -298,6 +298,21 @@ int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return chip->info->ops->serdes_get_lane(chip, port);
 }
 
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+{
+	u8 cmode = chip->ports[port].cmode;
+
+	if (port != 5)
+		return -ENODEV;
+
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
+	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+		return MV88E6341_PORT5_LANE;
+
+	return -ENODEV;
+}
+
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -747,15 +762,19 @@ void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
 int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
+	int lane;
 
-	if (port != 5)
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane == -ENODEV)
 		return 0;
 
+	if (lane < 0)
+		return lane;
+
 	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-		return mv88e6390_serdes_power_sgmii(chip, MV88E6341_ADDR_SERDES,
-						    on);
+		return mv88e6390_serdes_power_sgmii(chip, lane, on);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index f2ca3bcc3893..de6f1939c541 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -28,7 +28,7 @@
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
 
-#define MV88E6341_ADDR_SERDES		0x15
+#define MV88E6341_PORT5_LANE		0x15
 
 #define MV88E6390_PORT9_LANE0		0x09
 #define MV88E6390_PORT9_LANE1		0x12
@@ -75,6 +75,7 @@
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
 int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on);
-- 
2.21.0

