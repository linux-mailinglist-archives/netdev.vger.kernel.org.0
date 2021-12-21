Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3347BD81
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbhLUJsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:48:35 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:49932 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236666AbhLUJs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:48:27 -0500
X-IronPort-AV: E=Sophos;i="5.88,223,1635174000"; 
   d="scan'208";a="104225073"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 21 Dec 2021 18:48:25 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 258344004D02;
        Tue, 21 Dec 2021 18:48:20 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 10/16] clk: renesas: Add support for RZ/V2L SoC
Date:   Tue, 21 Dec 2021 09:47:11 +0000
Message-Id: <20211221094717.16187-11-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

The clock structure for RZ/V2L is almost identical to RZ/G2L SoC. The only
difference being RZ/V2L has an additional registers to control clock and
reset for the DRP-AI block.

This patch adds minimal clock and reset entries required to boot the
system on Renesas RZ/V2L SMARC EVK and binds it with the RZ/G2L CPG core
driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/clk/renesas/Kconfig         |   7 +-
 drivers/clk/renesas/Makefile        |   1 +
 drivers/clk/renesas/r9a07g054-cpg.c | 184 ++++++++++++++++++++++++++++
 drivers/clk/renesas/rzg2l-cpg.c     |   6 +
 drivers/clk/renesas/rzg2l-cpg.h     |   1 +
 5 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/renesas/r9a07g054-cpg.c

diff --git a/drivers/clk/renesas/Kconfig b/drivers/clk/renesas/Kconfig
index 6d0280751bb1..dfb7f3d7ca65 100644
--- a/drivers/clk/renesas/Kconfig
+++ b/drivers/clk/renesas/Kconfig
@@ -33,6 +33,7 @@ config CLK_RENESAS
 	select CLK_R8A779A0 if ARCH_R8A779A0
 	select CLK_R9A06G032 if ARCH_R9A06G032
 	select CLK_R9A07G044 if ARCH_R9A07G044
+	select CLK_R9A07G054 if ARCH_R9A07G054
 	select CLK_SH73A0 if ARCH_SH73A0
 
 if CLK_RENESAS
@@ -159,6 +160,10 @@ config CLK_R9A07G044
 	bool "RZ/G2L clock support" if COMPILE_TEST
 	select CLK_RZG2L
 
+config CLK_R9A07G054
+	bool "RZ/V2L clock support" if COMPILE_TEST
+	select CLK_RZG2L
+
 config CLK_SH73A0
 	bool "SH-Mobile AG5 clock support" if COMPILE_TEST
 	select CLK_RENESAS_CPG_MSTP
@@ -186,7 +191,7 @@ config CLK_RCAR_USB2_CLOCK_SEL
 	  This is a driver for R-Car USB2 clock selector
 
 config CLK_RZG2L
-	bool "Renesas RZ/G2L family clock support" if COMPILE_TEST
+	bool "Renesas RZ/{G2L,V2L} family clock support" if COMPILE_TEST
 	select RESET_CONTROLLER
 
 # Generic
diff --git a/drivers/clk/renesas/Makefile b/drivers/clk/renesas/Makefile
index 7d018700d08b..b5649474eb27 100644
--- a/drivers/clk/renesas/Makefile
+++ b/drivers/clk/renesas/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_CLK_R8A77995)		+= r8a77995-cpg-mssr.o
 obj-$(CONFIG_CLK_R8A779A0)		+= r8a779a0-cpg-mssr.o
 obj-$(CONFIG_CLK_R9A06G032)		+= r9a06g032-clocks.o
 obj-$(CONFIG_CLK_R9A07G044)		+= r9a07g044-cpg.o
+obj-$(CONFIG_CLK_R9A07G054)		+= r9a07g054-cpg.o
 obj-$(CONFIG_CLK_SH73A0)		+= clk-sh73a0.o
 
 # Family
diff --git a/drivers/clk/renesas/r9a07g054-cpg.c b/drivers/clk/renesas/r9a07g054-cpg.c
new file mode 100644
index 000000000000..a8682cfae550
--- /dev/null
+++ b/drivers/clk/renesas/r9a07g054-cpg.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * RZ/V2L CPG driver
+ *
+ * Copyright (C) 2021 Renesas Electronics Corp.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+
+#include <dt-bindings/clock/r9a07g054-cpg.h>
+
+#include "rzg2l-cpg.h"
+
+enum clk_ids {
+	/* Core Clock Outputs exported to DT */
+	LAST_DT_CORE_CLK = R9A07G054_CLK_P0_DIV2,
+
+	/* External Input Clocks */
+	CLK_EXTAL,
+
+	/* Internal Core Clocks */
+	CLK_OSC_DIV1000,
+	CLK_PLL1,
+	CLK_PLL2,
+	CLK_PLL2_DIV2,
+	CLK_PLL2_DIV16,
+	CLK_PLL3,
+	CLK_PLL3_DIV2,
+	CLK_PLL3_DIV2_4,
+	CLK_PLL3_DIV2_4_2,
+	CLK_PLL3_DIV4,
+	CLK_PLL5,
+	CLK_PLL5_FOUT3,
+	CLK_PLL5_250,
+	CLK_PLL6,
+	CLK_PLL6_250,
+	CLK_P1_DIV2,
+
+	/* Module Clocks */
+	MOD_CLK_BASE,
+};
+
+/* Divider tables */
+static const struct clk_div_table dtable_1_32[] = {
+	{0, 1},
+	{1, 2},
+	{2, 4},
+	{3, 8},
+	{4, 32},
+	{0, 0},
+};
+
+/* Mux clock tables */
+static const char * const sel_pll6_2[]	= { ".pll6_250", ".pll5_250" };
+
+static const struct cpg_core_clk r9a07g054_core_clks[] __initconst = {
+	/* External Clock Inputs */
+	DEF_INPUT("extal", CLK_EXTAL),
+
+	/* Internal Core Clocks */
+	DEF_FIXED(".osc", R9A07G054_OSCCLK, CLK_EXTAL, 1, 1),
+	DEF_FIXED(".osc_div1000", CLK_OSC_DIV1000, CLK_EXTAL, 1, 1000),
+	DEF_SAMPLL(".pll1", CLK_PLL1, CLK_EXTAL, PLL146_CONF(0)),
+	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 133, 2),
+	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 133, 2),
+
+	DEF_FIXED(".pll5", CLK_PLL5, CLK_EXTAL, 125, 1),
+	DEF_FIXED(".pll5_fout3", CLK_PLL5_FOUT3, CLK_PLL5, 1, 6),
+
+	DEF_FIXED(".pll6", CLK_PLL6, CLK_EXTAL, 125, 6),
+
+	DEF_FIXED(".pll2_div2", CLK_PLL2_DIV2, CLK_PLL2, 1, 2),
+	DEF_FIXED(".pll2_div16", CLK_PLL2_DIV16, CLK_PLL2, 1, 16),
+
+	DEF_FIXED(".pll3_div2", CLK_PLL3_DIV2, CLK_PLL3, 1, 2),
+	DEF_FIXED(".pll3_div2_4", CLK_PLL3_DIV2_4, CLK_PLL3_DIV2, 1, 4),
+	DEF_FIXED(".pll3_div2_4_2", CLK_PLL3_DIV2_4_2, CLK_PLL3_DIV2_4, 1, 2),
+	DEF_FIXED(".pll3_div4", CLK_PLL3_DIV4, CLK_PLL3, 1, 4),
+
+	DEF_FIXED(".pll5_250", CLK_PLL5_250, CLK_PLL5_FOUT3, 1, 2),
+	DEF_FIXED(".pll6_250", CLK_PLL6_250, CLK_PLL6, 1, 2),
+
+	/* Core output clk */
+	DEF_FIXED("I", R9A07G054_CLK_I, CLK_PLL1, 1, 1),
+	DEF_DIV("P0", R9A07G054_CLK_P0, CLK_PLL2_DIV16, DIVPL2A,
+		dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
+	DEF_FIXED("P0_DIV2", R9A07G054_CLK_P0_DIV2, R9A07G054_CLK_P0, 1, 2),
+	DEF_DIV("P1", R9A07G054_CLK_P1, CLK_PLL3_DIV2_4,
+		DIVPL3B, dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
+	DEF_FIXED("P1_DIV2", CLK_P1_DIV2, R9A07G054_CLK_P1, 1, 2),
+	DEF_DIV("P2", R9A07G054_CLK_P2, CLK_PLL3_DIV2_4_2,
+		DIVPL3A, dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
+	DEF_FIXED("M0", R9A07G054_CLK_M0, CLK_PLL3_DIV2_4, 1, 1),
+	DEF_FIXED("ZT", R9A07G054_CLK_ZT, CLK_PLL3_DIV2_4_2, 1, 1),
+	DEF_MUX("HP", R9A07G054_CLK_HP, SEL_PLL6_2,
+		sel_pll6_2, ARRAY_SIZE(sel_pll6_2), 0, CLK_MUX_HIWORD_MASK),
+};
+
+static struct rzg2l_mod_clk r9a07g054_mod_clks[] = {
+	DEF_MOD("gic",		R9A07G054_GIC600_GICCLK, R9A07G054_CLK_P1,
+				0x514, 0),
+	DEF_MOD("ia55_pclk",	R9A07G054_IA55_PCLK, R9A07G054_CLK_P2,
+				0x518, 0),
+	DEF_MOD("ia55_clk",	R9A07G054_IA55_CLK, R9A07G054_CLK_P1,
+				0x518, 1),
+	DEF_MOD("dmac_aclk",	R9A07G054_DMAC_ACLK, R9A07G054_CLK_P1,
+				0x52c, 0),
+	DEF_MOD("dmac_pclk",	R9A07G054_DMAC_PCLK, CLK_P1_DIV2,
+				0x52c, 1),
+	DEF_COUPLED("eth0_axi",	R9A07G054_ETH0_CLK_AXI, R9A07G054_CLK_M0,
+				0x57c, 0),
+	DEF_COUPLED("eth0_chi",	R9A07G054_ETH0_CLK_CHI, R9A07G054_CLK_ZT,
+				0x57c, 0),
+	DEF_COUPLED("eth1_axi",	R9A07G054_ETH1_CLK_AXI, R9A07G054_CLK_M0,
+				0x57c, 1),
+	DEF_COUPLED("eth1_chi",	R9A07G054_ETH1_CLK_CHI, R9A07G054_CLK_ZT,
+				0x57c, 1),
+	DEF_MOD("scif0",	R9A07G054_SCIF0_CLK_PCK, R9A07G054_CLK_P0,
+				0x584, 0),
+	DEF_MOD("scif1",	R9A07G054_SCIF1_CLK_PCK, R9A07G054_CLK_P0,
+				0x584, 1),
+	DEF_MOD("scif2",	R9A07G054_SCIF2_CLK_PCK, R9A07G054_CLK_P0,
+				0x584, 2),
+	DEF_MOD("scif3",	R9A07G054_SCIF3_CLK_PCK, R9A07G054_CLK_P0,
+				0x584, 3),
+	DEF_MOD("scif4",	R9A07G054_SCIF4_CLK_PCK, R9A07G054_CLK_P0,
+				0x584, 4),
+	DEF_MOD("sci0",		R9A07G054_SCI0_CLKP, R9A07G054_CLK_P0,
+				0x588, 0),
+	DEF_MOD("sci1",		R9A07G054_SCI1_CLKP, R9A07G054_CLK_P0,
+				0x588, 1),
+	DEF_MOD("gpio",		R9A07G054_GPIO_HCLK, R9A07G054_OSCCLK,
+				0x598, 0),
+};
+
+static struct rzg2l_reset r9a07g054_resets[] = {
+	DEF_RST(R9A07G054_GIC600_GICRESET_N, 0x814, 0),
+	DEF_RST(R9A07G054_GIC600_DBG_GICRESET_N, 0x814, 1),
+	DEF_RST(R9A07G054_IA55_RESETN, 0x818, 0),
+	DEF_RST(R9A07G054_DMAC_ARESETN, 0x82c, 0),
+	DEF_RST(R9A07G054_DMAC_RST_ASYNC, 0x82c, 1),
+	DEF_RST(R9A07G054_ETH0_RST_HW_N, 0x87c, 0),
+	DEF_RST(R9A07G054_ETH1_RST_HW_N, 0x87c, 1),
+	DEF_RST(R9A07G054_SCIF0_RST_SYSTEM_N, 0x884, 0),
+	DEF_RST(R9A07G054_SCIF1_RST_SYSTEM_N, 0x884, 1),
+	DEF_RST(R9A07G054_SCIF2_RST_SYSTEM_N, 0x884, 2),
+	DEF_RST(R9A07G054_SCIF3_RST_SYSTEM_N, 0x884, 3),
+	DEF_RST(R9A07G054_SCIF4_RST_SYSTEM_N, 0x884, 4),
+	DEF_RST(R9A07G054_SCI0_RST, 0x888, 0),
+	DEF_RST(R9A07G054_SCI1_RST, 0x888, 1),
+	DEF_RST(R9A07G054_GPIO_RSTN, 0x898, 0),
+	DEF_RST(R9A07G054_GPIO_PORT_RESETN, 0x898, 1),
+	DEF_RST(R9A07G054_GPIO_SPARE_RESETN, 0x898, 2),
+};
+
+static const unsigned int r9a07g054_crit_mod_clks[] __initconst = {
+	MOD_CLK_BASE + R9A07G054_GIC600_GICCLK,
+	MOD_CLK_BASE + R9A07G054_IA55_CLK,
+	MOD_CLK_BASE + R9A07G054_DMAC_ACLK,
+};
+
+const struct rzg2l_cpg_info r9a07g054_cpg_info = {
+	/* Core Clocks */
+	.core_clks = r9a07g054_core_clks,
+	.num_core_clks = ARRAY_SIZE(r9a07g054_core_clks),
+	.last_dt_core_clk = LAST_DT_CORE_CLK,
+	.num_total_core_clks = MOD_CLK_BASE,
+
+	/* Critical Module Clocks */
+	.crit_mod_clks = r9a07g054_crit_mod_clks,
+	.num_crit_mod_clks = ARRAY_SIZE(r9a07g054_crit_mod_clks),
+
+	/* Module Clocks */
+	.mod_clks = r9a07g054_mod_clks,
+	.num_mod_clks = ARRAY_SIZE(r9a07g054_mod_clks),
+	.num_hw_mod_clks = R9A07G054_TSU_PCLK + 1,
+
+	/* Resets */
+	.resets = r9a07g054_resets,
+	.num_resets = ARRAY_SIZE(r9a07g054_resets),
+};
diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 4021f6cabda4..396496ce0dce 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -940,6 +940,12 @@ static const struct of_device_id rzg2l_cpg_match[] = {
 		.compatible = "renesas,r9a07g044-cpg",
 		.data = &r9a07g044_cpg_info,
 	},
+#endif
+#ifdef CONFIG_CLK_R9A07G054
+	{
+		.compatible = "renesas,r9a07g054-cpg",
+		.data = &r9a07g054_cpg_info,
+	},
 #endif
 	{ /* sentinel */ }
 };
diff --git a/drivers/clk/renesas/rzg2l-cpg.h b/drivers/clk/renesas/rzg2l-cpg.h
index 7fb6b4030f72..43e828064704 100644
--- a/drivers/clk/renesas/rzg2l-cpg.h
+++ b/drivers/clk/renesas/rzg2l-cpg.h
@@ -194,5 +194,6 @@ struct rzg2l_cpg_info {
 };
 
 extern const struct rzg2l_cpg_info r9a07g044_cpg_info;
+extern const struct rzg2l_cpg_info r9a07g054_cpg_info;
 
 #endif
-- 
2.17.1

