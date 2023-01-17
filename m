Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7689166D63F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbjAQGSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbjAQGQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:16:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05870298E9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 22:15:48 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFf-0002TU-Ct; Tue, 17 Jan 2023 07:15:19 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFZ-006c0G-Le; Tue, 17 Jan 2023 07:15:13 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pHfFW-00FciG-RF; Tue, 17 Jan 2023 07:15:10 +0100
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
Subject: [PATCH v2 01/19] clk: imx: add clk-gpr-mux driver
Date:   Tue, 17 Jan 2023 07:14:35 +0100
Message-Id: <20230117061453.3723649-2-o.rempel@pengutronix.de>
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

Almost(?) every i'MX variant has clk mux for ethernet (rgmii/rmii) reference
clock located in the GPR1 register. So far this clk is configured in
different ways:
- mach-imx6q is doing mux configuration based on ptp vs enet_ref clk
  comparison.
- mach-imx7d is setting mux to PAD for all boards
- mach-imx6ul is setting mux to internal clock for all boards.

Since we have imx7d and imx6ul board variants which do not work with
configurations forced by kernel mach code, we need to implement this clk
mux properly as part of the clk framework. Which is done by this patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/clk/imx/Makefile      |   1 +
 drivers/clk/imx/clk-gpr-mux.c | 119 ++++++++++++++++++++++++++++++++++
 drivers/clk/imx/clk.h         |   5 ++
 3 files changed, 125 insertions(+)
 create mode 100644 drivers/clk/imx/clk-gpr-mux.c

diff --git a/drivers/clk/imx/Makefile b/drivers/clk/imx/Makefile
index e8aacb0ee6ac..a75d59f7cb8a 100644
--- a/drivers/clk/imx/Makefile
+++ b/drivers/clk/imx/Makefile
@@ -22,6 +22,7 @@ mxc-clk-objs += clk-pllv3.o
 mxc-clk-objs += clk-pllv4.o
 mxc-clk-objs += clk-pll14xx.o
 mxc-clk-objs += clk-sscg-pll.o
+mxc-clk-objs += clk-gpr-mux.o
 obj-$(CONFIG_MXC_CLK) += mxc-clk.o
 
 obj-$(CONFIG_CLK_IMX8MM) += clk-imx8mm.o
diff --git a/drivers/clk/imx/clk-gpr-mux.c b/drivers/clk/imx/clk-gpr-mux.c
new file mode 100644
index 000000000000..47a3e3cdcc82
--- /dev/null
+++ b/drivers/clk/imx/clk-gpr-mux.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ */
+
+#define pr_fmt(fmt) "imx:clk-gpr-mux: " fmt
+
+#include <linux/module.h>
+
+#include <linux/clk-provider.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+
+#include "clk.h"
+
+struct imx_clk_gpr {
+	struct clk_hw hw;
+	struct regmap *regmap;
+	u32 mask;
+	u32 reg;
+	const u32 *mux_table;
+};
+
+static struct imx_clk_gpr *to_imx_clk_gpr(struct clk_hw *hw)
+{
+	return container_of(hw, struct imx_clk_gpr, hw);
+}
+
+static u8 imx_clk_gpr_mux_get_parent(struct clk_hw *hw)
+{
+	struct imx_clk_gpr *priv = to_imx_clk_gpr(hw);
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(priv->regmap, priv->reg, &val);
+	if (ret)
+		goto get_parent_err;
+
+	val &= priv->mask;
+
+	ret = clk_mux_val_to_index(hw, priv->mux_table, 0, val);
+	if (ret < 0)
+		goto get_parent_err;
+
+	return ret;
+
+get_parent_err:
+	pr_err("failed to get parent (%pe)\n", ERR_PTR(ret));
+
+	/* return some realistic non negative value. Potentially we could
+	 * give index to some dummy error parent.
+	 */
+	return 0;
+}
+
+static int imx_clk_gpr_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct imx_clk_gpr *priv = to_imx_clk_gpr(hw);
+	unsigned int val = clk_mux_index_to_val(priv->mux_table, 0, index);
+
+	return regmap_update_bits(priv->regmap, priv->reg, priv->mask, val);
+}
+
+static int imx_clk_gpr_mux_determine_rate(struct clk_hw *hw,
+					 struct clk_rate_request *req)
+{
+	return clk_mux_determine_rate_flags(hw, req, 0);
+}
+
+const struct clk_ops imx_clk_gpr_mux_ops = {
+	.get_parent = imx_clk_gpr_mux_get_parent,
+	.set_parent = imx_clk_gpr_mux_set_parent,
+	.determine_rate = imx_clk_gpr_mux_determine_rate,
+};
+
+struct clk_hw *imx_clk_gpr_mux(const char *name, const char *compatible,
+			       u32 reg, const char **parent_names,
+			       u8 num_parents, const u32 *mux_table, u32 mask)
+{
+	struct clk_init_data init  = { };
+	struct imx_clk_gpr *priv;
+	struct regmap *regmap;
+	struct clk_hw *hw;
+	int ret;
+
+	regmap = syscon_regmap_lookup_by_compatible(compatible);
+	if (IS_ERR(regmap)) {
+		pr_err("failed to find %s regmap\n", compatible);
+		return ERR_CAST(regmap);
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &imx_clk_gpr_mux_ops;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	priv->hw.init = &init;
+	priv->regmap = regmap;
+	priv->mux_table = mux_table;
+	priv->reg = reg;
+	priv->mask = mask;
+
+	hw = &priv->hw;
+	ret = clk_hw_register(NULL, &priv->hw);
+	if (ret) {
+		kfree(priv);
+		hw = ERR_PTR(ret);
+	}
+
+	return hw;
+}
diff --git a/drivers/clk/imx/clk.h b/drivers/clk/imx/clk.h
index 689b3ad927c0..801213109697 100644
--- a/drivers/clk/imx/clk.h
+++ b/drivers/clk/imx/clk.h
@@ -458,4 +458,9 @@ struct clk_hw *imx_clk_hw_divider_gate(const char *name, const char *parent_name
 		unsigned long flags, void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
+
+struct clk_hw *imx_clk_gpr_mux(const char *name, const char *compatible,
+			       u32 reg, const char **parent_names,
+			       u8 num_parents, const u32 *mux_table, u32 mask);
+
 #endif
-- 
2.30.2

