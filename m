Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E266D640
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbjAQGSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbjAQGQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:16:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067B52685D
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 22:15:48 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFb-0002TT-Dt; Tue, 17 Jan 2023 07:15:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFZ-006c0D-K1; Tue, 17 Jan 2023 07:15:13 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFX-00FckR-3x; Tue, 17 Jan 2023 07:15:11 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Lee Jones <lee@kernel.org>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 16/19] clk: imx6ul: add ethernet refclock mux support
Date:   Tue, 17 Jan 2023 07:14:50 +0100
Message-Id: <20230117061453.3723649-17-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117061453.3723649-1-o.rempel@pengutronix.de>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet refclock mux support and set it to internal clock by
default. This configuration will not affect existing boards.

clock tree before this patch:
fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
                                                       |- pll6_enet
fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´

after this patch:
fec1 <- enet1_ref_sel(mux) <- enet1_ref_125m (gate) <- ...
               `--<> enet1_ref_pad                      |- pll6_enet
fec2 <- enet2_ref_sel(mux) <- enet2_ref_125m (gate) <- ...
               `--<> enet2_ref_pad

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Lee Jones <lee@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c                | 26 +++++++++++++++++++++
 include/dt-bindings/clock/imx6ul-clock.h    |  6 ++++-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h |  6 +++--
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index c3c465c1b0e7..2836adb817b7 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -10,6 +10,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -94,6 +95,17 @@ static const struct clk_div_table video_div_table[] = {
 	{ }
 };
 
+static const char * enet1_ref_sels[] = { "enet1_ref_125m", "enet1_ref_pad", };
+static const u32 enet1_ref_sels_table[] = { IMX6UL_GPR1_ENET1_TX_CLK_DIR,
+					    IMX6UL_GPR1_ENET1_CLK_SEL };
+static const u32 enet1_ref_sels_table_mask = IMX6UL_GPR1_ENET1_TX_CLK_DIR |
+					     IMX6UL_GPR1_ENET1_CLK_SEL;
+static const char * enet2_ref_sels[] = { "enet2_ref_125m", "enet2_ref_pad", };
+static const u32 enet2_ref_sels_table[] = { IMX6UL_GPR1_ENET2_TX_CLK_DIR,
+					    IMX6UL_GPR1_ENET2_CLK_SEL };
+static const u32 enet2_ref_sels_table_mask = IMX6UL_GPR1_ENET2_TX_CLK_DIR |
+					     IMX6UL_GPR1_ENET2_CLK_SEL;
+
 static u32 share_count_asrc;
 static u32 share_count_audio;
 static u32 share_count_sai1;
@@ -472,6 +484,17 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	/* mask handshake of mmdc */
 	imx_mmdc_mask_handshake(base, 0);
 
+	hws[IMX6UL_CLK_ENET1_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
+
+	hws[IMX6UL_CLK_ENET1_REF_SEL] = imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
+				IOMUXC_GPR1, enet1_ref_sels, ARRAY_SIZE(enet1_ref_sels),
+				enet1_ref_sels_table, enet1_ref_sels_table_mask);
+	hws[IMX6UL_CLK_ENET2_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet2_ref_pad", 0);
+
+	hws[IMX6UL_CLK_ENET2_REF_SEL] = imx_clk_gpr_mux("enet2_ref_sel", "fsl,imx6ul-iomuxc-gpr",
+				IOMUXC_GPR1, enet2_ref_sels, ARRAY_SIZE(enet2_ref_sels),
+				enet2_ref_sels_table, enet2_ref_sels_table_mask);
+
 	imx_check_clk_hws(hws, IMX6UL_CLK_END);
 
 	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
@@ -516,6 +539,9 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 		clk_set_parent(hws[IMX6ULL_CLK_EPDC_PRE_SEL]->clk, hws[IMX6UL_CLK_PLL3_PFD2]->clk);
 
 	clk_set_parent(hws[IMX6UL_CLK_ENFC_SEL]->clk, hws[IMX6UL_CLK_PLL2_PFD2]->clk);
+
+	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
 }
 
 CLK_OF_DECLARE(imx6ul, "fsl,imx6ul-ccm", imx6ul_clocks_init);
diff --git a/include/dt-bindings/clock/imx6ul-clock.h b/include/dt-bindings/clock/imx6ul-clock.h
index b44920f1edb0..66239ebc0e23 100644
--- a/include/dt-bindings/clock/imx6ul-clock.h
+++ b/include/dt-bindings/clock/imx6ul-clock.h
@@ -257,7 +257,11 @@
 #define IMX6UL_CLK_GPIO5		248
 #define IMX6UL_CLK_MMDC_P1_IPG		249
 #define IMX6UL_CLK_ENET1_REF_125M	250
+#define IMX6UL_CLK_ENET1_REF_SEL	251
+#define IMX6UL_CLK_ENET1_REF_PAD	252
+#define IMX6UL_CLK_ENET2_REF_SEL	253
+#define IMX6UL_CLK_ENET2_REF_PAD	254
 
-#define IMX6UL_CLK_END			251
+#define IMX6UL_CLK_END			255
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6UL_H */
diff --git a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
index d4b5e527a7a3..09c6b3184bb0 100644
--- a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
+++ b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
@@ -451,8 +451,10 @@
 #define IMX6SX_GPR12_PCIE_RX_EQ_2			(0x2 << 0)
 
 /* For imx6ul iomux gpr register field define */
-#define IMX6UL_GPR1_ENET1_CLK_DIR		(0x1 << 17)
-#define IMX6UL_GPR1_ENET2_CLK_DIR		(0x1 << 18)
+#define IMX6UL_GPR1_ENET2_TX_CLK_DIR		BIT(18)
+#define IMX6UL_GPR1_ENET1_TX_CLK_DIR		BIT(17)
+#define IMX6UL_GPR1_ENET2_CLK_SEL		BIT(14)
+#define IMX6UL_GPR1_ENET1_CLK_SEL		BIT(13)
 #define IMX6UL_GPR1_ENET1_CLK_OUTPUT		(0x1 << 17)
 #define IMX6UL_GPR1_ENET2_CLK_OUTPUT		(0x1 << 18)
 #define IMX6UL_GPR1_ENET_CLK_DIR		(0x3 << 17)
-- 
2.30.2

