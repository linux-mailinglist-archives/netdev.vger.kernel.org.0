Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B696FF2CEC
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388024AbfKGLAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:00:53 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41663 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKGLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 06:00:53 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX1-0004bT-25; Thu, 07 Nov 2019 12:00:51 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX0-0003eT-2k; Thu, 07 Nov 2019 12:00:50 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Tristram.Ha@microchip.com, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: [PATCH v1 1/4] mdio-bitbang: add SMI0 mode support
Date:   Thu,  7 Nov 2019 12:00:27 +0100
Message-Id: <20191107110030.25199-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
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
MII_ADDR_SMI0 as an available interface to the mdiobb write and read
functions, as this interface can be easy realized using the bitbang mdio
driver.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
RFC -> v1: - moved the Protocol description to mdio-bitbang
           - renamed the protocol to SMI_KSZ88X3...

 drivers/net/phy/mdio-bitbang.c | 21 +++++++++++++++++++++
 include/linux/phy.h            |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index 5136275c8e739..9f6fb84f92f60 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -22,6 +22,21 @@
 #define MDIO_READ 2
 #define MDIO_WRITE 1
 
+/* KSZ8863 Serial Management Interface (SMI) uses the following frame format:
+ *
+ *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
+ *               |frame| OP code  |address |address|  |                  |
+ * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
+ * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
+ *
+ * The register number is encoded with the 5 least significant bits in REG
+ * and the 3 most significant bits in PHY
+ */
+
+#define SMI_KSZ88X3_RW_OPCODE	0
+#define SMI_KSZ88X3_READ_PHY	(1 << 4)
+#define SMI_KSZ88X3_WRITE_PHY	(0 << 4)
+
 #define MDIO_C45 (1<<15)
 #define MDIO_C45_ADDR (MDIO_C45 | 0)
 #define MDIO_C45_READ (MDIO_C45 | 3)
@@ -157,6 +172,9 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	if (reg & MII_ADDR_C45) {
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
+	} else if (reg & MII_ADDR_SMI_KSZ88X3) {
+		mdiobb_cmd(ctrl, SMI_KSZ88X3_RW_OPCODE,
+			   (reg & 0xE0) >> 5 | SMI_KSZ88X3_READ_PHY, reg);
 	} else
 		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
 
@@ -188,6 +206,9 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	if (reg & MII_ADDR_C45) {
 		reg = mdiobb_cmd_addr(ctrl, phy, reg);
 		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
+	} else if (reg & MII_ADDR_SMI_KSZ88X3) {
+		mdiobb_cmd(ctrl, SMI_KSZ88X3_RW_OPCODE,
+			   (reg & 0xE0) >> 5 | SMI_KSZ88X3_WRITE_PHY, reg);
 	} else
 		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 78436d58ce7ce..e569aa92ac6c8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -201,6 +201,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 #define MII_DEVADDR_C45_SHIFT	16
 #define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
+#define MII_ADDR_SMI_KSZ88X3 (1<<31)
+
 struct device;
 struct phylink;
 struct sk_buff;
-- 
2.24.0.rc1

