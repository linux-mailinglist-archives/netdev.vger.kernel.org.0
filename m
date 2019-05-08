Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F118184
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfEHVOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:14:06 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47809 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHVOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:14:06 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTt3-0005VN-44; Wed, 08 May 2019 23:14:01 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92-RC6)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTt2-000636-T0; Wed, 08 May 2019 23:14:00 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     Tristram.Ha@microchip.com
Cc:     kernel@pengutronix.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: [RFC 1/3] mdio-bitbang: add SMI0 mode support
Date:   Wed,  8 May 2019 23:13:28 +0200
Message-Id: <20190508211330.19328-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some microchip phys support the Serial Management Interface Protocol
(SMI) for the configuration of the extended register set. We add
MII_ADDR_SMI0 as an availabe interface to the mdiobb write and read
functions, as this interface can be easy realized using the bitbang mdio
driver.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/phy/mdio-bitbang.c | 10 ++++++++++
 include/linux/phy.h            | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e739..a978f8a9a172b 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -22,6 +22,10 @@
 #define MDIO_READ 2
 #define MDIO_WRITE 1
 
+#define SMI0_RW_OPCODE	0
+#define SMI0_READ_PHY	(1 << 4)
+#define SMI0_WRITE_PHY	(0 << 4)
+
 #define MDIO_C45 (1<<15)
 #define MDIO_C45_ADDR (MDIO_C45 | 0)
 #define MDIO_C45_READ (MDIO_C45 | 3)
@@ -157,6 +161,9 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	if (reg & MII_ADDR_C45) {
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
+	} else if (reg & MII_ADDR_SMI0) {
+		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
+			   (reg & 0xE0) >> 5 | SMI0_READ_PHY, reg);
 	} else
 		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
 
@@ -188,6 +195,9 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	if (reg & MII_ADDR_C45) {
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
+	} else if (reg & MII_ADDR_SMI0) {
+		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
+			   (reg & 0xE0) >> 5 | SMI0_WRITE_PHY, reg);
 	} else
 		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 073fb151b5a99..f011722fbd5c2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -199,6 +199,18 @@ static inline const char *phy_modes(phy_interface_t interface)
    IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
 #define MII_ADDR_C45 (1<<30)
 
+/* Serial Management Interface (SMI) uses the following frame format:
+ *
+ *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
+ *               |frame| OP code  |address |address|  |                  |
+ * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
+ * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
+ *
+ * The register number is encoded with the 5 least significant bits in REG
+ * and the 3 most significant bits in PHY
+ */
+#define MII_ADDR_SMI0 (1<<31)
+
 struct device;
 struct phylink;
 struct sk_buff;
-- 
2.20.1

