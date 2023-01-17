Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E366D61F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbjAQGQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbjAQGPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:15:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A56B26855
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 22:15:44 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFb-0002TC-Dx; Tue, 17 Jan 2023 07:15:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFY-006bzn-M7; Tue, 17 Jan 2023 07:15:12 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFW-00FciP-S2; Tue, 17 Jan 2023 07:15:10 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 02/19] clk: imx6q: add ethernet refclock mux support
Date:   Tue, 17 Jan 2023 07:14:36 +0100
Message-Id: <20230117061453.3723649-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117061453.3723649-1-o.rempel@pengutronix.de>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
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
default. This configuration will not affect existing boards since
machine code currently overwrites this default.

The machine code will be fixed in a separate patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/clk/imx/clk-imx6q.c               | 13 +++++++++++++
 include/dt-bindings/clock/imx6qdl-clock.h |  4 +++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index de36f58d551c..22b464ca22c8 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -12,6 +12,7 @@
 #include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -115,6 +116,10 @@ static struct clk_div_table video_div_table[] = {
 	{ /* sentinel */ }
 };
 
+static const char * enet_ref_sels[] = { "enet_ref", "enet_ref_pad", };
+static const u32 enet_ref_sels_table[] = { IMX6Q_GPR1_ENET_CLK_SEL_ANATOP, IMX6Q_GPR1_ENET_CLK_SEL_PAD };
+static const u32 enet_ref_sels_table_mask = IMX6Q_GPR1_ENET_CLK_SEL_ANATOP;
+
 static unsigned int share_count_esai;
 static unsigned int share_count_asrc;
 static unsigned int share_count_ssi1;
@@ -908,6 +913,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	if (clk_on_imx6q() && imx_get_soc_revision() == IMX_CHIP_REVISION_1_0)
 		hws[IMX6QDL_CLK_GPT_3M] = hws[IMX6QDL_CLK_GPT_IPG_PER];
 
+	hws[IMX6QDL_CLK_ENET_REF_PAD] = imx6q_obtain_fixed_clk_hw(ccm_node, "enet_ref_pad", 0);
+
+	hws[IMX6QDL_CLK_ENET_REF_SEL] = imx_clk_gpr_mux("enet_ref_sel", "fsl,imx6q-iomuxc-gpr",
+				IOMUXC_GPR1, enet_ref_sels, ARRAY_SIZE(enet_ref_sels),
+				enet_ref_sels_table, enet_ref_sels_table_mask);
+
 	imx_check_clk_hws(hws, IMX6QDL_CLK_END);
 
 	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
@@ -974,6 +985,8 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
 	}
 
+	clk_set_parent(hws[IMX6QDL_CLK_ENET_REF_SEL]->clk, hws[IMX6QDL_CLK_ENET_REF]->clk);
+
 	imx_register_uart_clocks(2);
 }
 CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index e20c43cc36f6..e5b2a1ba02bc 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -273,6 +273,8 @@
 #define IMX6QDL_CLK_MMDC_P0_IPG			263
 #define IMX6QDL_CLK_DCIC1			264
 #define IMX6QDL_CLK_DCIC2			265
-#define IMX6QDL_CLK_END				266
+#define IMX6QDL_CLK_ENET_REF_SEL		266
+#define IMX6QDL_CLK_ENET_REF_PAD		267
+#define IMX6QDL_CLK_END				268
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
2.30.2

