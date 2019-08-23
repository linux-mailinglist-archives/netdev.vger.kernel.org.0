Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58BD9B819
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405183AbfHWV0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:26:09 -0400
Received: from mail.nic.cz ([217.31.204.67]:35854 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389903AbfHWV0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 17:26:08 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 37A76140D27;
        Fri, 23 Aug 2019 23:26:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566595565; bh=Kv+cA5n6/z0VWY+o7pIdJtR7a6YJE6PtPUmt+KCRyY0=;
        h=From:To:Date;
        b=TJ6OtHCeQzBdug5eXYN9P3N3isoqUwGyhhxjFn1kgLPhI2unW9xJSpz7MgqxipVhA
         dAfKKHti1sTLT10LTmMVkHW4X9xjBcTCaaIa/ICwkS3KTHSU/KD8uq90AkFC5CXtbj
         TBWZ2u7Ibld20ZVARkvU5mKwfLWbX5cUxRYfYlio=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v2 5/9] net: dsa: mv88e6xxx: add serdes_get_lane method for Topaz family
Date:   Fri, 23 Aug 2019 23:25:59 +0200
Message-Id: <20190823212603.13456-6-marek.behun@nic.cz>
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

The Topaz family has only one SERDES, on port 5, with address 0x15.
Currently we have MV88E6341_ADDR_SERDES macro used in the
mv88e6341_serdes_power method. Rename the macro to MV88E6341_PORT5_LANE
and use the new mv88e6xxx_serdes_get_lane method in
mv88e6341_serdes_power.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  2 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 25 ++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h |  3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dfffeaf925a4..6343af09fb1e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2928,6 +2928,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6341_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3622,6 +3623,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6341_serdes_power,
+	.serdes_get_lane = mv88e6341_serdes_get_lane,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 523f58c57972..1f40130bfb68 100644
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

