Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5035068279C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjAaIxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjAaIxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:53:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23AB4DCC8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:49:05 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-0003u1-Oi; Tue, 31 Jan 2023 09:46:47 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHv-001eM4-FY; Tue, 31 Jan 2023 09:46:46 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pMmHr-002yav-84; Tue, 31 Jan 2023 09:46:43 +0100
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
        Abel Vesa <abel.vesa@linaro.org>, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 14/19] clk: imx: add imx_obtain_fixed_of_clock()
Date:   Tue, 31 Jan 2023 09:46:37 +0100
Message-Id: <20230131084642.709385-15-o.rempel@pengutronix.de>
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

Add imx_obtain_fixed_of_clock() to optionally add clock not configured in
the devicetree.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
---
 drivers/clk/imx/clk.c | 14 ++++++++++++++
 drivers/clk/imx/clk.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 4f7db3c9e144..19cde59a20cb 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -110,6 +110,20 @@ struct clk_hw *imx_obtain_fixed_clock_hw(
 	return __clk_get_hw(clk);
 }
 
+struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
+					 const char *name, unsigned long rate)
+{
+	struct clk *clk = of_clk_get_by_name(np, name);
+	struct clk_hw *hw;
+
+	if (IS_ERR(clk))
+		hw = imx_obtain_fixed_clock_hw(name, rate);
+	else
+		hw = __clk_get_hw(clk);
+
+	return hw;
+}
+
 struct clk_hw *imx_get_clk_hw_by_name(struct device_node *np, const char *name)
 {
 	struct clk *clk;
diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index afc1ea0f5bcf..3d94722bbf99 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -288,6 +288,9 @@ struct clk * imx_obtain_fixed_clock(
 struct clk_hw *imx_obtain_fixed_clock_hw(
 			const char *name, unsigned long rate);
 
+struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
+					 const char *name, unsigned long rate);
+
 struct clk_hw *imx_get_clk_hw_by_name(struct device_node *np, const char *name);
 
 struct clk_hw *imx_clk_hw_gate_exclusive(const char *name, const char *parent,
-- 
2.30.2

