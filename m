Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48A59C172
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 05:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfHYD70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 23:59:26 -0400
Received: from mail.nic.cz ([217.31.204.67]:44156 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfHYD7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 23:59:25 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 48D1E1407BE;
        Sun, 25 Aug 2019 05:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566705562; bh=SGbVI7o6Bmzx4pLhlOG+etiYvforRvUTdNmTv+tgpI4=;
        h=From:To:Date;
        b=oVBGa8KSzVTxvjWfdR/UlN08ll+KjjjJ7BtLWru7kq0WpiNjmIC+nppNvp35ju8k6
         9I4XyZvyfG49szRy+o3mCz4RWQ4BeXLXzTKEfejUvvGowYrHNNDlW6mxJUVGT9go+Y
         Vft8vSOgdrsUz/9sF2S2VVXlQEtEBPw/JqjI0mvs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v3 1/6] net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
Date:   Sun, 25 Aug 2019 05:59:10 +0200
Message-Id: <20190825035915.13112-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190825035915.13112-1-marek.behun@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
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

The mv88e6390_serdes_irq_link_sgmii IRQ handler reads the SERDES PHY
status register to determine speed, among other things. If cmode of the
port is set to 2500base-x, though, the PHY still reports 1000 Mbps (the
PHY register itself does not differentiate between 1000 Mbps and 2500
Mbps - it thinks it is running at 1000 Mbps, although clock is 2.5x
faster).
Look at the cmode and set SPEED_2500 if cmode is set to 2500base-x.
Also tell mv88e6xxx_port_setup_mac the PHY interface mode corresponding
to current cmode in terms of phy_interface_t.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 20c526c2a9ee..678aaba3d019 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -505,9 +505,11 @@ int mv88e6390x_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 					    int port, int lane)
 {
+	u8 cmode = chip->ports[port].cmode;
 	struct dsa_switch *ds = chip->ds;
 	int duplex = DUPLEX_UNKNOWN;
 	int speed = SPEED_UNKNOWN;
+	phy_interface_t mode;
 	int link, err;
 	u16 status;
 
@@ -527,7 +529,10 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 
 		switch (status & MV88E6390_SGMII_PHY_STATUS_SPEED_MASK) {
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_1000:
-			speed = SPEED_1000;
+			if (cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+				speed = SPEED_2500;
+			else
+				speed = SPEED_1000;
 			break;
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_100:
 			speed = SPEED_100;
@@ -541,8 +546,22 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 		}
 	}
 
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+		mode = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+		mode = PHY_INTERFACE_MODE_1000BASEX;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		mode = PHY_INTERFACE_MODE_2500BASEX;
+		break;
+	default:
+		mode = PHY_INTERFACE_MODE_NA;
+	}
+
 	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex,
-				       PAUSE_OFF, PHY_INTERFACE_MODE_NA);
+				       PAUSE_OFF, mode);
 	if (err)
 		dev_err(chip->dev, "can't propagate PHY settings to MAC: %d\n",
 			err);
-- 
2.21.0

