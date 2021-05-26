Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5164390F94
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhEZEcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEZEcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B1EC06138E
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Ox-Bn; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002cq-NK; Wed, 26 May 2021 06:30:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v3 7/9] net: dsa: microchip: ksz8795: add LINK_MD register support
Date:   Wed, 26 May 2021 06:30:35 +0200
Message-Id: <20210526043037.9830-8-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210526043037.9830-1-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <linux@rempel-privat.de>

Add mapping for LINK_MD register to enable cable testing functionality.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     | 22 ++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz8795_reg.h |  5 +++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 55da8ec175da..ae5fe9c829da 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -6,6 +6,7 @@
  *	Tristram Ha <Tristram.Ha@microchip.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
@@ -728,6 +729,7 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 	struct ksz8 *ksz8 = dev->priv;
 	u8 restart, speed, ctrl, link;
 	const u8 *regs = ksz8->regs;
+	u8 val1, val2;
 	int processed = true;
 	u16 data = 0;
 	u8 p = phy;
@@ -816,6 +818,22 @@ static void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		if (data & ~LPA_SLCT)
 			data |= LPA_LPACK;
 		break;
+	case PHY_REG_LINK_MD:
+		ksz_pread8(dev, p, REG_PORT_LINK_MD_CTRL, &val1);
+		ksz_pread8(dev, p, REG_PORT_LINK_MD_RESULT, &val2);
+		if (val1 & PORT_START_CABLE_DIAG)
+			data |= PHY_START_CABLE_DIAG;
+
+		if (val1 & PORT_CABLE_10M_SHORT)
+			data |= PHY_CABLE_10M_SHORT;
+
+		data |= FIELD_PREP(PHY_CABLE_DIAG_RESULT_M,
+				FIELD_GET(PORT_CABLE_DIAG_RESULT_M, val1));
+
+		data |= FIELD_PREP(PHY_CABLE_FAULT_COUNTER_M,
+				(FIELD_GET(PORT_CABLE_FAULT_COUNTER_H, val1) << 8) |
+				FIELD_GET(PORT_CABLE_FAULT_COUNTER_L, val2));
+		break;
 	case PHY_REG_PHY_CTRL:
 		ksz_pread8(dev, p, regs[P_LINK_STATUS], &link);
 		if (link & PORT_MDIX_STATUS)
@@ -932,6 +950,10 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		if (data != ctrl)
 			ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
 		break;
+	case PHY_REG_LINK_MD:
+		if (val & PHY_START_CABLE_DIAG)
+			ksz_port_cfg(dev, p, REG_PORT_LINK_MD_CTRL, PORT_START_CABLE_DIAG, true);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index f925ddee5238..a32355624f31 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -249,7 +249,7 @@
 #define REG_PORT_4_LINK_MD_CTRL		0x4A
 
 #define PORT_CABLE_10M_SHORT		BIT(7)
-#define PORT_CABLE_DIAG_RESULT_M	0x3
+#define PORT_CABLE_DIAG_RESULT_M	GENMASK(6, 5)
 #define PORT_CABLE_DIAG_RESULT_S	5
 #define PORT_CABLE_STAT_NORMAL		0
 #define PORT_CABLE_STAT_OPEN		1
@@ -753,13 +753,14 @@
 #define PHY_REG_LINK_MD			0x1D
 
 #define PHY_START_CABLE_DIAG		BIT(15)
+#define PHY_CABLE_DIAG_RESULT_M		GENMASK(14, 13)
 #define PHY_CABLE_DIAG_RESULT		0x6000
 #define PHY_CABLE_STAT_NORMAL		0x0000
 #define PHY_CABLE_STAT_OPEN		0x2000
 #define PHY_CABLE_STAT_SHORT		0x4000
 #define PHY_CABLE_STAT_FAILED		0x6000
 #define PHY_CABLE_10M_SHORT		BIT(12)
-#define PHY_CABLE_FAULT_COUNTER		0x01FF
+#define PHY_CABLE_FAULT_COUNTER_M	GENMASK(8, 0)
 
 #define PHY_REG_PHY_CTRL		0x1F
 
-- 
2.29.2

