Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E205A28E7
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbiHZNzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344377AbiHZNzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:55:07 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAFE3DBE2;
        Fri, 26 Aug 2022 06:55:03 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 72867240017;
        Fri, 26 Aug 2022 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661522102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AHbjb2QKfJWi64tXxgD9Cr2PZaKfndc17diijMug5to=;
        b=IcpqLg+ZglQfOUNCSeYecq+JPigB5eD85iVMUHg5CpE3fMI24BlCGM3XaeZH2O8AhFSUpP
        UszH065SWZT/esU0+6MVVfXdsC7OINmzR/e9LJZZYa3jIW3GmDxq6mmM0bcKJwlfeAO6qZ
        i3mOuLeG+i0arMTaHny5cbkkl7WuKjhOn+UrY1gBCcCKEXsQJZfVwo+ic7bB90wAunwnCS
        IgaqJ75xFF7s7KF74VZVzLnOILfvSui1Kt9tHBSYQS31aeoQqSoxQnRVQy8E0n9Pd00u3H
        z7PCQhlm3z2a8F+Gvi4ajwsvbZ8sQ42+4M9EpPbvGBFUMwi+2iBGZRRJnfHQpQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next 3/5] net: pcs: add new PCS driver for altera TSE PCS
Date:   Fri, 26 Aug 2022 15:54:49 +0200
Message-Id: <20220826135451.526756-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
References: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Altera Triple Speed Ethernet has a SGMII/1000BaseC PCS that can be
integrated in several ways. It can either be part of the TSE MAC's
address space, accessed through 32 bits accesses on the mapped mdio
device 0, or through a dedicated 16 bits register set.

This driver allows using the TSE PCS outside of altera TSE's driver,
since it can be used standalone by other MACs.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 MAINTAINERS                      |   7 ++
 drivers/net/pcs/Kconfig          |   6 ++
 drivers/net/pcs/Makefile         |   1 +
 drivers/net/pcs/pcs-altera-tse.c | 162 +++++++++++++++++++++++++++++++
 include/linux/pcs-altera-tse.h   |  17 ++++
 5 files changed, 193 insertions(+)
 create mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/pcs-altera-tse.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ba954d5a9a2f..20bcfff8626d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -878,6 +878,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/altera/
 
+ALTERA TSE PCS
+M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/pcs/pcs-altera-tse.c
+F:	include/linux/pcs-altera-tse.h
+
 ALTERA UART/JTAG UART SERIAL DRIVERS
 M:	Tobias Klauser <tklauser@distanz.ch>
 L:	linux-serial@vger.kernel.org
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 6289b7c765f1..6e7e6c346a3e 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -26,4 +26,10 @@ config PCS_RZN1_MIIC
 	  on RZ/N1 SoCs. This PCS converts MII to RMII/RGMII or can be set in
 	  pass-through mode for MII.
 
+config PCS_ALTERA_TSE
+	tristate
+	help
+	  This module provides helper functions for the Altera Triple Speed
+	  Ethernet SGMII PCS, that can be found on the Intel Socfpga family.
+
 endmenu
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 0ff5388fcdea..4c780d8f2e98 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -6,3 +6,4 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
 obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
+obj-$(CONFIG_PCS_ALTERA_TSE)	+= pcs-altera-tse.o
diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
new file mode 100644
index 000000000000..d9794a5e5443
--- /dev/null
+++ b/drivers/net/pcs/pcs-altera-tse.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Bootlin
+ *
+ * Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/phylink.h>
+#include <linux/pcs-altera-tse.h>
+
+/* SGMII PCS register addresses
+ */
+#define SGMII_PCS_SCRATCH	0x10
+#define SGMII_PCS_REV		0x11
+#define SGMII_PCS_LINK_TIMER_0	0x12
+#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))
+#define SGMII_PCS_LINK_TIMER_1	0x13
+#define SGMII_PCS_IF_MODE	0x14
+#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
+#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
+#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
+#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
+#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
+#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)
+#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
+#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
+#define SGMII_PCS_DIS_READ_TO	0x15
+#define SGMII_PCS_READ_TO	0x16
+#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
+
+struct altera_tse_pcs {
+	struct phylink_pcs pcs;
+	void __iomem *base;
+	int reg_width;
+};
+
+static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct altera_tse_pcs, pcs);
+}
+
+static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
+{
+	if (tse_pcs->reg_width == 4)
+		return readl(tse_pcs->base + regnum * 4);
+	else
+		return readw(tse_pcs->base + regnum * 2);
+}
+
+static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
+			  u16 value)
+{
+	if (tse_pcs->reg_width == 4)
+		writel(value, tse_pcs->base + regnum * 4);
+	else
+		writew(value, tse_pcs->base + regnum * 2);
+}
+
+static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
+{
+	int i = 0;
+	u16 bmcr;
+
+	/* Reset PCS block */
+	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
+	bmcr |= BMCR_RESET;
+	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
+
+	for (i = 0; i < SGMII_PCS_SW_RESET_TIMEOUT; i++) {
+		if (!(tse_pcs_read(tse_pcs, MII_BMCR) & BMCR_RESET))
+			return 0;
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising,
+			      bool permit_pause_to_mac)
+{
+	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
+	u32 ctrl, if_mode;
+
+	if (interface != PHY_INTERFACE_MODE_SGMII &&
+	    interface != PHY_INTERFACE_MODE_1000BASEX)
+		return 0;
+
+	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
+	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
+
+	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
+	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
+	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
+
+	if (interface == PHY_INTERFACE_MODE_SGMII) {
+		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
+	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
+		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
+		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;
+	}
+
+	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
+
+	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
+	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
+
+	return tse_pcs_reset(tse_pcs);
+}
+
+static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
+				  struct phylink_link_state *state)
+{
+	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
+	u16 bmsr, lpa;
+
+	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
+	lpa = tse_pcs_read(tse_pcs, MII_LPA);
+
+	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
+}
+
+static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
+	u16 bmcr;
+
+	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
+	bmcr |= BMCR_ANRESTART;
+	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
+
+	tse_pcs_reset(tse_pcs);
+}
+
+static const struct phylink_pcs_ops alt_tse_pcs_ops = {
+	.pcs_get_state = alt_tse_pcs_get_state,
+	.pcs_config = alt_tse_pcs_config,
+	.pcs_an_restart = alt_tse_pcs_an_restart,
+};
+
+struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
+				       void __iomem *pcs_base, int reg_width)
+{
+	struct altera_tse_pcs *tse_pcs;
+
+	if (reg_width != 4 && reg_width != 2)
+		return ERR_PTR(-EINVAL);
+
+	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs), GFP_KERNEL);
+	if (!tse_pcs)
+		return ERR_PTR(-ENOMEM);
+
+	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
+	tse_pcs->base = pcs_base;
+	tse_pcs->reg_width = reg_width;
+
+	return &tse_pcs->pcs;
+}
+EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
new file mode 100644
index 000000000000..9c85e7c8ef70
--- /dev/null
+++ b/include/linux/pcs-altera-tse.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Bootlin
+ *
+ * Maxime Chevallier <maxime.chevallier@bootlin.com>
+ */
+
+#ifndef __LINUX_PCS_ALTERA_TSE_H
+#define __LINUX_PCS_ALTERA_TSE_H
+
+struct phylink;
+struct net_device;
+
+struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
+				       void __iomem *pcs_base, int reg_width);
+
+#endif /* __LINUX_PCS_ALTERA_TSE_H */
-- 
2.37.2

