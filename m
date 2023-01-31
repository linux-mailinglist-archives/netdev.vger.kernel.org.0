Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC716827A7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjAaIyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjAaIx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:53:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630A147EDB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:49:21 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-0003tF-9d; Tue, 31 Jan 2023 09:46:47 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-001eLx-9n; Tue, 31 Jan 2023 09:46:46 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHr-002yZK-1d; Tue, 31 Jan 2023 09:46:43 +0100
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
Subject: [PATCH v3 03/19] ARM: imx6q: skip ethernet refclock reconfiguration if enet_clk_ref is present
Date:   Tue, 31 Jan 2023 09:46:26 +0100
Message-Id: <20230131084642.709385-4-o.rempel@pengutronix.de>
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

Current mach-imx6q code has following logic:
- if ptp clock of the ethernet controller node is attached to the SoC
  internal enet_ref clock, then we configure RMII reference clock pin as
  output by setting IOMUXC_GPR1 BIT(21).
  In this case - MAC (SoC) is the clock provider, PHY is the clock consumer.
- if ptp clock of the ethernet controller node is not attached to the
  enet_ref clock, then we configure RMII reference clock pin as input by
  clearing IOMUXC_GPR1 BIT(21).
  In this case - PHY is the clock provider, MAC is the clock consumer.

According to the Freescale MX6SDL ReferenceManual v4, IOMUXC_GPR1 BIT(21)
(page 2033) this configuration bit is not related to the PTP (IEEE1588)
clock:
21 ENET_CLK_SEL - choose enet reference clk mode:
   0 - get enet tx reference clk from pad (external OSC for both external
       PHY and Internal Controller)
   1 - get enet tx reference clk from internal clock from anatop (loopback
       through pad), this clock also sent out to external PHY.

According to the Documentation/devicetree/bindings/net/fsl,fec.yaml:
      The "ptp"(option), for IEEE1588 timer clock that requires the clock.
      The "enet_clk_ref"(option), for MAC transmit/receiver reference clock
      like RGMII TXC clock or RMII reference clock. It depends on board
      design, the clock is required if RGMII TXC and RMII reference clock
      source from SOC internal PLL.
      The "enet_out"(option), output clock for external device, like supply
      clock for PHY. The clock is required if PHY clock source from SOC.

We can see, that "enet_clk_ref" clock is the best fit for this purpose.
Other properties like "ptp" is designed for IEEE1588 and "enet_out" do
not have real functionality within imx related clock infrastructure.

Since the "enet_clk_ref" is not used by the imx6qdl devicetrees, we can
use it as indicator of potentially properly configured DT. At same time
we can keep ptp clock based logic as the fallback for old DTs.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6q.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index c9d7c29d95e1..7f6200925752 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -79,7 +79,7 @@ static void __init imx6q_enet_phy_init(void)
 static void __init imx6q_1588_init(void)
 {
 	struct device_node *np;
-	struct clk *ptp_clk;
+	struct clk *ptp_clk, *fec_enet_ref;
 	struct clk *enet_ref;
 	struct regmap *gpr;
 	u32 clksel;
@@ -90,6 +90,14 @@ static void __init imx6q_1588_init(void)
 		return;
 	}
 
+	/*
+	 * If enet_clk_ref configured, we assume DT did it properly and .
+	 * clk-imx6q.c will do needed configuration.
+	 */
+	fec_enet_ref = of_clk_get_by_name(np, "enet_clk_ref");
+	if (!IS_ERR(fec_enet_ref))
+		goto put_node;
+
 	ptp_clk = of_clk_get(np, 2);
 	if (IS_ERR(ptp_clk)) {
 		pr_warn("%s: failed to get ptp clock\n", __func__);
-- 
2.30.2

