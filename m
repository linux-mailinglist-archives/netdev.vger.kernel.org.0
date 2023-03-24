Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC26C7B9E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjCXJiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjCXJhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:37 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10624BD3;
        Fri, 24 Mar 2023 02:37:21 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 06868100006;
        Fri, 24 Mar 2023 09:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=za8AOVXueg+FjzCZ7CZ6vNt9s/rL1y1jmlagfOqWjbU=;
        b=GmC2Apq3q5y9NgKIseSa/8qxd5n6B1VFTt3Esb+wffgtk9imn0pl6yO6idivqYWu7UQp2+
        87//YxT1pZkzhBqDmZp129WMEconkE7icHGMO/StbUs6zN3m6j00IHd1Duv4Nx7PCL20O+
        SgdWP/spCgsxtXF9I8PKk5jBMCLWypsODVph+ipSe5sp78f/JC2rqIzvmi7rWbTbP3VJCm
        y8J/mcH48Zow9vyWnOZ+YOJ817xgfcWcgud3f/ndvVV1zi/rfVCnmUHcrqrmzPfEJuglh3
        le74FYixxJKRWbf+OHf4FG+figLJN9Xabj8JcJMypRc0Irzg2eYsh3OwqxHUkQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 7/7] net: pcs: Drop the TSE PCS driver
Date:   Fri, 24 Mar 2023 10:36:44 +0100
Message-Id: <20230324093644.464704-8-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we can easily create a mdio-device that represents a
memory-mapped device that exposes an MDIO-like register layout, we don't
need the Altera TSE PCS anymore, since we can use the Lynx PCS instead.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 MAINTAINERS                      |   7 --
 drivers/net/pcs/Kconfig          |   6 --
 drivers/net/pcs/Makefile         |   1 -
 drivers/net/pcs/pcs-altera-tse.c | 160 -------------------------------
 include/linux/pcs-altera-tse.h   |  17 ----
 5 files changed, 191 deletions(-)
 delete mode 100644 drivers/net/pcs/pcs-altera-tse.c
 delete mode 100644 include/linux/pcs-altera-tse.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 10b3a1800e0d..e2e648a46e3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -909,13 +909,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/altera/
 
-ALTERA TSE PCS
-M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/net/pcs/pcs-altera-tse.c
-F:	include/linux/pcs-altera-tse.h
-
 ALTERA UART/JTAG UART SERIAL DRIVERS
 M:	Tobias Klauser <tklauser@distanz.ch>
 L:	linux-serial@vger.kernel.org
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 6e7e6c346a3e..6289b7c765f1 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -26,10 +26,4 @@ config PCS_RZN1_MIIC
 	  on RZ/N1 SoCs. This PCS converts MII to RMII/RGMII or can be set in
 	  pass-through mode for MII.
 
-config PCS_ALTERA_TSE
-	tristate
-	help
-	  This module provides helper functions for the Altera Triple Speed
-	  Ethernet SGMII PCS, that can be found on the Intel Socfpga family.
-
 endmenu
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 4c780d8f2e98..0ff5388fcdea 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -6,4 +6,3 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
 obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
-obj-$(CONFIG_PCS_ALTERA_TSE)	+= pcs-altera-tse.o
diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
deleted file mode 100644
index d616749761f4..000000000000
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ /dev/null
@@ -1,160 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2022 Bootlin
- *
- * Maxime Chevallier <maxime.chevallier@bootlin.com>
- */
-
-#include <linux/netdevice.h>
-#include <linux/phy.h>
-#include <linux/phylink.h>
-#include <linux/pcs-altera-tse.h>
-
-/* SGMII PCS register addresses
- */
-#define SGMII_PCS_LINK_TIMER_0	0x12
-#define SGMII_PCS_LINK_TIMER_1	0x13
-#define SGMII_PCS_IF_MODE	0x14
-#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
-#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
-#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
-#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
-#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
-
-struct altera_tse_pcs {
-	struct phylink_pcs pcs;
-	void __iomem *base;
-	int reg_width;
-};
-
-static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct phylink_pcs *pcs)
-{
-	return container_of(pcs, struct altera_tse_pcs, pcs);
-}
-
-static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
-{
-	if (tse_pcs->reg_width == 4)
-		return readl(tse_pcs->base + regnum * 4);
-	else
-		return readw(tse_pcs->base + regnum * 2);
-}
-
-static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
-			  u16 value)
-{
-	if (tse_pcs->reg_width == 4)
-		writel(value, tse_pcs->base + regnum * 4);
-	else
-		writew(value, tse_pcs->base + regnum * 2);
-}
-
-static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
-{
-	u16 bmcr;
-
-	/* Reset PCS block */
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_RESET;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
-
-	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
-				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
-				 tse_pcs, MII_BMCR);
-}
-
-static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
-				unsigned long *supported,
-				const struct phylink_link_state *state)
-{
-	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	    state->interface == PHY_INTERFACE_MODE_1000BASEX)
-		return 1;
-
-	return -EINVAL;
-}
-
-static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			      phy_interface_t interface,
-			      const unsigned long *advertising,
-			      bool permit_pause_to_mac)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u32 ctrl, if_mode;
-
-	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
-	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
-
-	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
-
-	if (interface == PHY_INTERFACE_MODE_SGMII) {
-		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
-	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
-		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
-	}
-
-	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-
-	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
-	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
-
-	return tse_pcs_reset(tse_pcs);
-}
-
-static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
-				  struct phylink_link_state *state)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmsr, lpa;
-
-	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
-	lpa = tse_pcs_read(tse_pcs, MII_LPA);
-
-	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
-}
-
-static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmcr;
-
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_ANRESTART;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
-
-	/* This PCS seems to require a soft reset to re-sync the AN logic */
-	tse_pcs_reset(tse_pcs);
-}
-
-static const struct phylink_pcs_ops alt_tse_pcs_ops = {
-	.pcs_validate = alt_tse_pcs_validate,
-	.pcs_get_state = alt_tse_pcs_get_state,
-	.pcs_config = alt_tse_pcs_config,
-	.pcs_an_restart = alt_tse_pcs_an_restart,
-};
-
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width)
-{
-	struct altera_tse_pcs *tse_pcs;
-
-	if (reg_width != 4 && reg_width != 2)
-		return ERR_PTR(-EINVAL);
-
-	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs), GFP_KERNEL);
-	if (!tse_pcs)
-		return ERR_PTR(-ENOMEM);
-
-	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
-	tse_pcs->base = pcs_base;
-	tse_pcs->reg_width = reg_width;
-
-	return &tse_pcs->pcs;
-}
-EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Altera TSE PCS driver");
-MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
deleted file mode 100644
index 92ab9f08e835..000000000000
--- a/include/linux/pcs-altera-tse.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2022 Bootlin
- *
- * Maxime Chevallier <maxime.chevallier@bootlin.com>
- */
-
-#ifndef __LINUX_PCS_ALTERA_TSE_H
-#define __LINUX_PCS_ALTERA_TSE_H
-
-struct phylink_pcs;
-struct net_device;
-
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width);
-
-#endif /* __LINUX_PCS_ALTERA_TSE_H */
-- 
2.39.2

