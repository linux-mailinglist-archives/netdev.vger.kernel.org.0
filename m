Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981626827AA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjAaIyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjAaIxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:53:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7BA4DE33
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:49:23 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-0003sD-5O; Tue, 31 Jan 2023 09:46:47 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-001eLt-57; Tue, 31 Jan 2023 09:46:46 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHr-002ybV-AO; Tue, 31 Jan 2023 09:46:43 +0100
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
Subject: [PATCH v3 18/19] ARM: mach-imx: imx6ul: remove not optional ethernet refclock overwrite
Date:   Tue, 31 Jan 2023 09:46:41 +0100
Message-Id: <20230131084642.709385-19-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230131084642.709385-1-o.rempel@pengutronix.de>
References: <20230131084642.709385-1-o.rempel@pengutronix.de>
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

Ethernet refclock direction is board specific and should be configurable
by devicetree. In fact there are board not working with this defaults,
which will be fixed by separate patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6ul.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6ul.c b/arch/arm/mach-imx/mach-imx6ul.c
index 35e81201cb5d..9208a2d6a9da 100644
--- a/arch/arm/mach-imx/mach-imx6ul.c
+++ b/arch/arm/mach-imx/mach-imx6ul.c
@@ -4,8 +4,6 @@
  */
 #include <linux/irqchip.h>
 #include <linux/mfd/syscon.h>
-#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
-#include <linux/micrel_phy.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/regmap.h>
@@ -16,30 +14,12 @@
 #include "cpuidle.h"
 #include "hardware.h"
 
-static void __init imx6ul_enet_clk_init(void)
-{
-	struct regmap *gpr;
-
-	gpr = syscon_regmap_lookup_by_compatible("fsl,imx6ul-iomuxc-gpr");
-	if (!IS_ERR(gpr))
-		regmap_update_bits(gpr, IOMUXC_GPR1, IMX6UL_GPR1_ENET_CLK_DIR,
-				   IMX6UL_GPR1_ENET_CLK_OUTPUT);
-	else
-		pr_err("failed to find fsl,imx6ul-iomux-gpr regmap\n");
-}
-
-static inline void imx6ul_enet_init(void)
-{
-	imx6ul_enet_clk_init();
-}
-
 static void __init imx6ul_init_machine(void)
 {
 	imx_print_silicon_rev(cpu_is_imx6ull() ? "i.MX6ULL" : "i.MX6UL",
 		imx_get_soc_revision());
 
 	of_platform_default_populate(NULL, NULL, NULL);
-	imx6ul_enet_init();
 	imx_anatop_init();
 	imx6ul_pm_init();
 }
-- 
2.30.2

