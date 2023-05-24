Return-Path: <netdev+bounces-5029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2D470F75B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B0CC28136B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8F618AE3;
	Wed, 24 May 2023 13:08:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F1918AE2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:08:26 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0B9C1;
	Wed, 24 May 2023 06:08:23 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id CE408FF815;
	Wed, 24 May 2023 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LciOtxkjE+as8FL6TIv3Fh6dqqa2pGZ/t/S9+WbDP8=;
	b=CazfVY4SJ3qzSOcWtgOA4M0+AfaD72Ihyv3gnffD26NvTJzzFL3TVHhqqql0YRXNfU+ARz
	dj6v9vxT53UOfO6XPoLBQ647bC11InFG0w/Fpy8pnPzn8aYTcjXTyDmqryqqPYLfoheEOc
	XRm0KTuYsgVGmhTpXUvw7hBRl1CUJWqmmIh8NIQghDTbdCPHBVrxSLZGK1IdBX8g2pKBWm
	Nmh+kqua6KwjBmHcodcBG5put78usHU4wHPBsRK4pYXh+nkBXx5HVkpcj2uFhkDap8/Fiz
	9/7xAVkU3Cfchxj3hIpbHzwi3VrCCFSIcG0k3x/uQ6/KHLPVgCnZEf67zHr4Ig==
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH net-next 4/4] net: stmmac: dwmac-sogfpga: use the lynx pcs driver
Date: Wed, 24 May 2023 15:08:07 +0200
Message-Id: <20230524130807.310089-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
References: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

dwmac_socfpga re-implements support for the TSE PCS, which is identical
to the already existing TSE PCS, which in turn is the same as the Lynx
PCS. Drop the existing TSE re-implemenation and use the Lynx PCS
instead, relying on the regmap-mdio driver to translate MDIO accesses
into mmio accesses.

Instead of extending xpcs, allow using a generic phylink_pcs, populated
by lynx_pcs_create(), and use .mac_select_pcs() to return the relevant
PCS to be used.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   1 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 .../ethernet/stmicro/stmmac/altr_tse_pcs.c    | 257 ------------------
 .../ethernet/stmicro/stmmac/altr_tse_pcs.h    |  29 --
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  90 ++++--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +-
 7 files changed, 76 insertions(+), 316 deletions(-)
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
 delete mode 100644 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 5f5a997f21f3..62b484cca1c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -158,6 +158,7 @@ config DWMAC_SOCFPGA
 	default ARCH_INTEL_SOCFPGA
 	depends on OF && (ARCH_INTEL_SOCFPGA || COMPILE_TEST)
 	select MFD_SYSCON
+	select PCS_LYNX
 	help
 	  Support for ethernet controller on Altera SOCFPGA
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 8738fdbb4b2d..7dd3d388068b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -35,7 +35,7 @@ obj-$(CONFIG_DWMAC_IMX8)	+= dwmac-imx.o
 obj-$(CONFIG_DWMAC_TEGRA)	+= dwmac-tegra.o
 obj-$(CONFIG_DWMAC_VISCONTI)	+= dwmac-visconti.o
 stmmac-platform-objs:= stmmac_platform.o
-dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
+dwmac-altr-socfpga-objs := dwmac-socfpga.o
 
 obj-$(CONFIG_STMMAC_PCI)	+= stmmac-pci.o
 obj-$(CONFIG_DWMAC_INTEL)	+= dwmac-intel.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
deleted file mode 100644
index 00f6d347eaf7..000000000000
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ /dev/null
@@ -1,257 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* Copyright Altera Corporation (C) 2016. All rights reserved.
- *
- * Author: Tien Hock Loh <thloh@altera.com>
- */
-
-#include <linux/mfd/syscon.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_net.h>
-#include <linux/phy.h>
-#include <linux/regmap.h>
-#include <linux/reset.h>
-#include <linux/stmmac.h>
-
-#include "stmmac.h"
-#include "stmmac_platform.h"
-#include "altr_tse_pcs.h"
-
-#define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII	0
-#define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII		BIT(1)
-#define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII		BIT(2)
-#define SYSMGR_EMACGRP_CTRL_PHYSEL_WIDTH		2
-#define SYSMGR_EMACGRP_CTRL_PHYSEL_MASK			GENMASK(1, 0)
-
-#define TSE_PCS_CONTROL_AN_EN_MASK			BIT(12)
-#define TSE_PCS_CONTROL_REG				0x00
-#define TSE_PCS_CONTROL_RESTART_AN_MASK			BIT(9)
-#define TSE_PCS_CTRL_AUTONEG_SGMII			0x1140
-#define TSE_PCS_IF_MODE_REG				0x28
-#define TSE_PCS_LINK_TIMER_0_REG			0x24
-#define TSE_PCS_LINK_TIMER_1_REG			0x26
-#define TSE_PCS_SIZE					0x40
-#define TSE_PCS_STATUS_AN_COMPLETED_MASK		BIT(5)
-#define TSE_PCS_STATUS_LINK_MASK			0x0004
-#define TSE_PCS_STATUS_REG				0x02
-#define TSE_PCS_SGMII_SPEED_1000			BIT(3)
-#define TSE_PCS_SGMII_SPEED_100				BIT(2)
-#define TSE_PCS_SGMII_SPEED_10				0x0
-#define TSE_PCS_SW_RST_MASK				0x8000
-#define TSE_PCS_PARTNER_ABILITY_REG			0x0A
-#define TSE_PCS_PARTNER_DUPLEX_FULL			0x1000
-#define TSE_PCS_PARTNER_DUPLEX_HALF			0x0000
-#define TSE_PCS_PARTNER_DUPLEX_MASK			0x1000
-#define TSE_PCS_PARTNER_SPEED_MASK			GENMASK(11, 10)
-#define TSE_PCS_PARTNER_SPEED_1000			BIT(11)
-#define TSE_PCS_PARTNER_SPEED_100			BIT(10)
-#define TSE_PCS_PARTNER_SPEED_10			0x0000
-#define TSE_PCS_PARTNER_SPEED_1000			BIT(11)
-#define TSE_PCS_PARTNER_SPEED_100			BIT(10)
-#define TSE_PCS_PARTNER_SPEED_10			0x0000
-#define TSE_PCS_SGMII_SPEED_MASK			GENMASK(3, 2)
-#define TSE_PCS_SGMII_LINK_TIMER_0			0x0D40
-#define TSE_PCS_SGMII_LINK_TIMER_1			0x0003
-#define TSE_PCS_SW_RESET_TIMEOUT			100
-#define TSE_PCS_USE_SGMII_AN_MASK			BIT(1)
-#define TSE_PCS_USE_SGMII_ENA				BIT(0)
-#define TSE_PCS_IF_USE_SGMII				0x03
-
-#define AUTONEGO_LINK_TIMER				20
-
-static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
-{
-	int counter = 0;
-	u16 val;
-
-	val = readw(base + TSE_PCS_CONTROL_REG);
-	val |= TSE_PCS_SW_RST_MASK;
-	writew(val, base + TSE_PCS_CONTROL_REG);
-
-	while (counter < TSE_PCS_SW_RESET_TIMEOUT) {
-		val = readw(base + TSE_PCS_CONTROL_REG);
-		val &= TSE_PCS_SW_RST_MASK;
-		if (val == 0)
-			break;
-		counter++;
-		udelay(1);
-	}
-	if (counter >= TSE_PCS_SW_RESET_TIMEOUT) {
-		dev_err(pcs->dev, "PCS could not get out of sw reset\n");
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-
-int tse_pcs_init(void __iomem *base, struct tse_pcs *pcs)
-{
-	int ret = 0;
-
-	writew(TSE_PCS_IF_USE_SGMII, base + TSE_PCS_IF_MODE_REG);
-
-	writew(TSE_PCS_CTRL_AUTONEG_SGMII, base + TSE_PCS_CONTROL_REG);
-
-	writew(TSE_PCS_SGMII_LINK_TIMER_0, base + TSE_PCS_LINK_TIMER_0_REG);
-	writew(TSE_PCS_SGMII_LINK_TIMER_1, base + TSE_PCS_LINK_TIMER_1_REG);
-
-	ret = tse_pcs_reset(base, pcs);
-	if (ret == 0)
-		writew(SGMII_ADAPTER_ENABLE,
-		       pcs->sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-
-	return ret;
-}
-
-static void pcs_link_timer_callback(struct tse_pcs *pcs)
-{
-	u16 val = 0;
-	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
-
-	val = readw(tse_pcs_base + TSE_PCS_STATUS_REG);
-	val &= TSE_PCS_STATUS_LINK_MASK;
-
-	if (val != 0) {
-		dev_dbg(pcs->dev, "Adapter: Link is established\n");
-		writew(SGMII_ADAPTER_ENABLE,
-		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	} else {
-		mod_timer(&pcs->aneg_link_timer, jiffies +
-			  msecs_to_jiffies(AUTONEGO_LINK_TIMER));
-	}
-}
-
-static void auto_nego_timer_callback(struct tse_pcs *pcs)
-{
-	u16 val = 0;
-	u16 speed = 0;
-	u16 duplex = 0;
-	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
-
-	val = readw(tse_pcs_base + TSE_PCS_STATUS_REG);
-	val &= TSE_PCS_STATUS_AN_COMPLETED_MASK;
-
-	if (val != 0) {
-		dev_dbg(pcs->dev, "Adapter: Auto Negotiation is completed\n");
-		val = readw(tse_pcs_base + TSE_PCS_PARTNER_ABILITY_REG);
-		speed = val & TSE_PCS_PARTNER_SPEED_MASK;
-		duplex = val & TSE_PCS_PARTNER_DUPLEX_MASK;
-
-		if (speed == TSE_PCS_PARTNER_SPEED_10 &&
-		    duplex == TSE_PCS_PARTNER_DUPLEX_FULL)
-			dev_dbg(pcs->dev,
-				"Adapter: Link Partner is Up - 10/Full\n");
-		else if (speed == TSE_PCS_PARTNER_SPEED_100 &&
-			 duplex == TSE_PCS_PARTNER_DUPLEX_FULL)
-			dev_dbg(pcs->dev,
-				"Adapter: Link Partner is Up - 100/Full\n");
-		else if (speed == TSE_PCS_PARTNER_SPEED_1000 &&
-			 duplex == TSE_PCS_PARTNER_DUPLEX_FULL)
-			dev_dbg(pcs->dev,
-				"Adapter: Link Partner is Up - 1000/Full\n");
-		else if (speed == TSE_PCS_PARTNER_SPEED_10 &&
-			 duplex == TSE_PCS_PARTNER_DUPLEX_HALF)
-			dev_err(pcs->dev,
-				"Adapter does not support Half Duplex\n");
-		else if (speed == TSE_PCS_PARTNER_SPEED_100 &&
-			 duplex == TSE_PCS_PARTNER_DUPLEX_HALF)
-			dev_err(pcs->dev,
-				"Adapter does not support Half Duplex\n");
-		else if (speed == TSE_PCS_PARTNER_SPEED_1000 &&
-			 duplex == TSE_PCS_PARTNER_DUPLEX_HALF)
-			dev_err(pcs->dev,
-				"Adapter does not support Half Duplex\n");
-		else
-			dev_err(pcs->dev,
-				"Adapter: Invalid Partner Speed and Duplex\n");
-
-		if (duplex == TSE_PCS_PARTNER_DUPLEX_FULL &&
-		    (speed == TSE_PCS_PARTNER_SPEED_10 ||
-		     speed == TSE_PCS_PARTNER_SPEED_100 ||
-		     speed == TSE_PCS_PARTNER_SPEED_1000))
-			writew(SGMII_ADAPTER_ENABLE,
-			       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	} else {
-		val = readw(tse_pcs_base + TSE_PCS_CONTROL_REG);
-		val |= TSE_PCS_CONTROL_RESTART_AN_MASK;
-		writew(val, tse_pcs_base + TSE_PCS_CONTROL_REG);
-
-		tse_pcs_reset(tse_pcs_base, pcs);
-		mod_timer(&pcs->aneg_link_timer, jiffies +
-			  msecs_to_jiffies(AUTONEGO_LINK_TIMER));
-	}
-}
-
-static void aneg_link_timer_callback(struct timer_list *t)
-{
-	struct tse_pcs *pcs = from_timer(pcs, t, aneg_link_timer);
-
-	if (pcs->autoneg == AUTONEG_ENABLE)
-		auto_nego_timer_callback(pcs);
-	else if (pcs->autoneg == AUTONEG_DISABLE)
-		pcs_link_timer_callback(pcs);
-}
-
-void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
-			   unsigned int speed)
-{
-	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	u32 val;
-
-	pcs->autoneg = phy_dev->autoneg;
-
-	if (phy_dev->autoneg == AUTONEG_ENABLE) {
-		val = readw(tse_pcs_base + TSE_PCS_CONTROL_REG);
-		val |= TSE_PCS_CONTROL_AN_EN_MASK;
-		writew(val, tse_pcs_base + TSE_PCS_CONTROL_REG);
-
-		val = readw(tse_pcs_base + TSE_PCS_IF_MODE_REG);
-		val |= TSE_PCS_USE_SGMII_AN_MASK;
-		writew(val, tse_pcs_base + TSE_PCS_IF_MODE_REG);
-
-		val = readw(tse_pcs_base + TSE_PCS_CONTROL_REG);
-		val |= TSE_PCS_CONTROL_RESTART_AN_MASK;
-
-		tse_pcs_reset(tse_pcs_base, pcs);
-
-		timer_setup(&pcs->aneg_link_timer, aneg_link_timer_callback,
-			    0);
-		mod_timer(&pcs->aneg_link_timer, jiffies +
-			  msecs_to_jiffies(AUTONEGO_LINK_TIMER));
-	} else if (phy_dev->autoneg == AUTONEG_DISABLE) {
-		val = readw(tse_pcs_base + TSE_PCS_CONTROL_REG);
-		val &= ~TSE_PCS_CONTROL_AN_EN_MASK;
-		writew(val, tse_pcs_base + TSE_PCS_CONTROL_REG);
-
-		val = readw(tse_pcs_base + TSE_PCS_IF_MODE_REG);
-		val &= ~TSE_PCS_USE_SGMII_AN_MASK;
-		writew(val, tse_pcs_base + TSE_PCS_IF_MODE_REG);
-
-		val = readw(tse_pcs_base + TSE_PCS_IF_MODE_REG);
-		val &= ~TSE_PCS_SGMII_SPEED_MASK;
-
-		switch (speed) {
-		case 1000:
-			val |= TSE_PCS_SGMII_SPEED_1000;
-			break;
-		case 100:
-			val |= TSE_PCS_SGMII_SPEED_100;
-			break;
-		case 10:
-			val |= TSE_PCS_SGMII_SPEED_10;
-			break;
-		default:
-			return;
-		}
-		writew(val, tse_pcs_base + TSE_PCS_IF_MODE_REG);
-
-		tse_pcs_reset(tse_pcs_base, pcs);
-
-		timer_setup(&pcs->aneg_link_timer, aneg_link_timer_callback,
-			    0);
-		mod_timer(&pcs->aneg_link_timer, jiffies +
-			  msecs_to_jiffies(AUTONEGO_LINK_TIMER));
-	}
-}
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
deleted file mode 100644
index 694ac25ef426..000000000000
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright Altera Corporation (C) 2016. All rights reserved.
- *
- * Author: Tien Hock Loh <thloh@altera.com>
- */
-
-#ifndef __TSE_PCS_H__
-#define __TSE_PCS_H__
-
-#include <linux/phy.h>
-#include <linux/timer.h>
-
-#define SGMII_ADAPTER_CTRL_REG		0x00
-#define SGMII_ADAPTER_ENABLE		0x0000
-#define SGMII_ADAPTER_DISABLE		0x0001
-
-struct tse_pcs {
-	struct device *dev;
-	void __iomem *tse_pcs_base;
-	void __iomem *sgmii_adapter_base;
-	struct timer_list aneg_link_timer;
-	int autoneg;
-};
-
-int tse_pcs_init(void __iomem *base, struct tse_pcs *pcs);
-void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
-			   unsigned int speed);
-
-#endif /* __TSE_PCS_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 4ad692c4116c..34751524775a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -519,6 +519,7 @@ struct mac_device_info {
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
 	struct dw_xpcs *xpcs;
+	struct phylink_pcs *phylink_pcs; /* Generic external PCS */
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 6ee050300b31..5f61b33905fc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -10,14 +10,14 @@
 #include <linux/of_net.h>
 #include <linux/phy.h>
 #include <linux/regmap.h>
+#include <linux/mdio/mdio-regmap.h>
 #include <linux/reset.h>
 #include <linux/stmmac.h>
+#include <linux/pcs-lynx.h>
 
 #include "stmmac.h"
 #include "stmmac_platform.h"
 
-#include "altr_tse_pcs.h"
-
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -37,6 +37,10 @@
 #define EMAC_SPLITTER_CTRL_SPEED_100		0x3
 #define EMAC_SPLITTER_CTRL_SPEED_1000		0x0
 
+#define SGMII_ADAPTER_CTRL_REG		0x00
+#define SGMII_ADAPTER_ENABLE		0x0000
+#define SGMII_ADAPTER_DISABLE		0x0001
+
 struct socfpga_dwmac;
 struct socfpga_dwmac_ops {
 	int (*set_phy_mode)(struct socfpga_dwmac *dwmac_priv);
@@ -50,16 +54,18 @@ struct socfpga_dwmac {
 	struct reset_control *stmmac_rst;
 	struct reset_control *stmmac_ocp_rst;
 	void __iomem *splitter_base;
+	void __iomem *tse_pcs_base;
+	void __iomem *sgmii_adapter_base;
 	bool f2h_ptp_ref_clk;
-	struct tse_pcs pcs;
 	const struct socfpga_dwmac_ops *ops;
+	struct mdio_device *pcs_mdiodev;
 };
 
 static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
-	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
+	void __iomem *sgmii_adapter_base = dwmac->sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
@@ -89,11 +95,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	if (phy_dev && sgmii_adapter_base) {
+	if (phy_dev && sgmii_adapter_base)
 		writew(SGMII_ADAPTER_ENABLE,
 		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
-	}
 }
 
 static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *dev)
@@ -183,11 +187,11 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 				goto err_node_put;
 			}
 
-			dwmac->pcs.sgmii_adapter_base =
+			dwmac->sgmii_adapter_base =
 			    devm_ioremap_resource(dev, &res_sgmii_adapter);
 
-			if (IS_ERR(dwmac->pcs.sgmii_adapter_base)) {
-				ret = PTR_ERR(dwmac->pcs.sgmii_adapter_base);
+			if (IS_ERR(dwmac->sgmii_adapter_base)) {
+				ret = PTR_ERR(dwmac->sgmii_adapter_base);
 				goto err_node_put;
 			}
 		}
@@ -205,11 +209,11 @@ static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *
 				goto err_node_put;
 			}
 
-			dwmac->pcs.tse_pcs_base =
+			dwmac->tse_pcs_base =
 			    devm_ioremap_resource(dev, &res_tse_pcs);
 
-			if (IS_ERR(dwmac->pcs.tse_pcs_base)) {
-				ret = PTR_ERR(dwmac->pcs.tse_pcs_base);
+			if (IS_ERR(dwmac->tse_pcs_base)) {
+				ret = PTR_ERR(dwmac->tse_pcs_base);
 				goto err_node_put;
 			}
 		}
@@ -235,6 +239,13 @@ static int socfpga_get_plat_phymode(struct socfpga_dwmac *dwmac)
 	return priv->plat->interface;
 }
 
+static void socfpga_sgmii_config(struct socfpga_dwmac *dwmac, bool enable)
+{
+	u16 val = enable ? SGMII_ADAPTER_ENABLE : SGMII_ADAPTER_DISABLE;
+
+	writew(val, dwmac->sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+}
+
 static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 {
 	switch (phymode) {
@@ -310,12 +321,8 @@ static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 	 */
 	reset_control_deassert(dwmac->stmmac_ocp_rst);
 	reset_control_deassert(dwmac->stmmac_rst);
-	if (phymode == PHY_INTERFACE_MODE_SGMII) {
-		if (tse_pcs_init(dwmac->pcs.tse_pcs_base, &dwmac->pcs) != 0) {
-			dev_err(dwmac->dev, "Unable to initialize TSE PCS");
-			return -EINVAL;
-		}
-	}
+	if (phymode == PHY_INTERFACE_MODE_SGMII)
+		socfpga_sgmii_config(dwmac, true);
 
 	return 0;
 }
@@ -367,12 +374,8 @@ static int socfpga_gen10_set_phy_mode(struct socfpga_dwmac *dwmac)
 	 */
 	reset_control_deassert(dwmac->stmmac_ocp_rst);
 	reset_control_deassert(dwmac->stmmac_rst);
-	if (phymode == PHY_INTERFACE_MODE_SGMII) {
-		if (tse_pcs_init(dwmac->pcs.tse_pcs_base, &dwmac->pcs) != 0) {
-			dev_err(dwmac->dev, "Unable to initialize TSE PCS");
-			return -EINVAL;
-		}
-	}
+	if (phymode == PHY_INTERFACE_MODE_SGMII)
+		socfpga_sgmii_config(dwmac, true);
 	return 0;
 }
 
@@ -386,6 +389,14 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	struct net_device	*ndev;
 	struct stmmac_priv	*stpriv;
 	const struct socfpga_dwmac_ops *ops;
+	struct regmap_config pcs_regmap_cfg;
+	struct regmap *pcs_regmap;
+	struct mii_bus *pcs_bus;
+
+	struct mdio_regmap_config mrc = {
+		.parent = &pdev->dev,
+		.valid_addr = 0x0,
+	};
 
 	ops = device_get_match_data(&pdev->dev);
 	if (!ops) {
@@ -443,6 +454,35 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dvr_remove;
 
+	memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));
+	pcs_regmap_cfg.reg_bits = 16;
+	pcs_regmap_cfg.val_bits = 16;
+	pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
+
+	/* Create a regmap for the PCS so that it can be used by the PCS driver,
+	 * if we have such a PCS
+	 */
+	if (dwmac->tse_pcs_base) {
+		pcs_regmap = devm_regmap_init_mmio(&pdev->dev, dwmac->tse_pcs_base,
+						   &pcs_regmap_cfg);
+		if (IS_ERR(pcs_regmap)) {
+			ret = PTR_ERR(pcs_regmap);
+			goto err_dvr_remove;
+		}
+
+		mrc.regmap = pcs_regmap;
+
+		snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
+		pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
+		if (IS_ERR(pcs_bus)) {
+			ret = PTR_ERR(pcs_bus);
+			goto err_dvr_remove;
+		}
+
+		dwmac->pcs_mdiodev = mdio_device_create(pcs_bus, 0);
+		stpriv->hw->phylink_pcs = lynx_pcs_create(dwmac->pcs_mdiodev);
+	}
+
 	return 0;
 
 err_dvr_remove:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0fca81507a77..e570a95dd8d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -937,10 +937,13 @@ static struct phylink_pcs *stmmac_mac_select_pcs(struct phylink_config *config,
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
-	if (!priv->hw->xpcs)
-		return NULL;
+	if (priv->hw->xpcs)
+		return &priv->hw->xpcs->pcs;
+
+	if (priv->hw->phylink_pcs)
+		return priv->hw->phylink_pcs;
 
-	return &priv->hw->xpcs->pcs;
+	return NULL;
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
@@ -3813,7 +3816,8 @@ static int __stmmac_open(struct net_device *dev,
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    (!priv->hw->xpcs ||
-	     xpcs_get_an_mode(priv->hw->xpcs, mode) != DW_AN_C73)) {
+	     xpcs_get_an_mode(priv->hw->xpcs, mode) != DW_AN_C73) &&
+	    !priv->hw->phylink_pcs) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
-- 
2.40.1


