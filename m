Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5381F564095
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiGBOCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiGBOCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:02:10 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9C1FBF56;
        Sat,  2 Jul 2022 07:02:07 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,240,1650898800"; 
   d="scan'208";a="124846520"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Jul 2022 23:02:07 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 8793E43676A8;
        Sat,  2 Jul 2022 23:02:03 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller
Date:   Sat,  2 Jul 2022 15:01:30 +0100
Message-Id: <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
to others like it has no clock divider register (CDR) support and it has
no HW loopback(HW doesn't see tx messages on rx).

This patch adds support for RZ/N1 SJA1000 CAN Controller.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/can/sja1000/sja1000_platform.c | 34 ++++++++++++++++++----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 5f3d362e0da5..8e63af76a013 100644
--- a/drivers/net/can/sja1000/sja1000_platform.c
+++ b/drivers/net/can/sja1000/sja1000_platform.c
@@ -14,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/can/dev.h>
 #include <linux/can/platform/sja1000.h>
+#include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -103,6 +104,11 @@ static void sp_technologic_init(struct sja1000_priv *priv, struct device_node *o
 	spin_lock_init(&tp->io_lock);
 }
 
+static void sp_rzn1_init(struct sja1000_priv *priv, struct device_node *of)
+{
+	priv->flags = SJA1000_NO_CDR_REG_QUIRK | SJA1000_NO_HW_LOOPBACK_QUIRK;
+}
+
 static void sp_populate(struct sja1000_priv *priv,
 			struct sja1000_platform_data *pdata,
 			unsigned long resource_mem_flags)
@@ -153,11 +159,13 @@ static void sp_populate_of(struct sja1000_priv *priv, struct device_node *of)
 		priv->write_reg = sp_write_reg8;
 	}
 
-	err = of_property_read_u32(of, "nxp,external-clock-frequency", &prop);
-	if (!err)
-		priv->can.clock.freq = prop / 2;
-	else
-		priv->can.clock.freq = SP_CAN_CLOCK; /* default */
+	if (!priv->can.clock.freq) {
+		err = of_property_read_u32(of, "nxp,external-clock-frequency", &prop);
+		if (!err)
+			priv->can.clock.freq = prop / 2;
+		else
+			priv->can.clock.freq = SP_CAN_CLOCK; /* default */
+	}
 
 	err = of_property_read_u32(of, "nxp,tx-output-mode", &prop);
 	if (!err)
@@ -192,8 +200,13 @@ static struct sja1000_of_data technologic_data = {
 	.init = sp_technologic_init,
 };
 
+static struct sja1000_of_data renesas_data = {
+	.init = sp_rzn1_init,
+};
+
 static const struct of_device_id sp_of_table[] = {
 	{ .compatible = "nxp,sja1000", .data = NULL, },
+	{ .compatible = "renesas,rzn1-sja1000", .data = &renesas_data, },
 	{ .compatible = "technologic,sja1000", .data = &technologic_data, },
 	{ /* sentinel */ },
 };
@@ -210,6 +223,7 @@ static int sp_probe(struct platform_device *pdev)
 	struct device_node *of = pdev->dev.of_node;
 	const struct sja1000_of_data *of_data = NULL;
 	size_t priv_sz = 0;
+	struct clk *clk;
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata && !of) {
@@ -262,6 +276,16 @@ static int sp_probe(struct platform_device *pdev)
 	priv->reg_base = addr;
 
 	if (of) {
+		clk = devm_clk_get_optional(&pdev->dev, "can_clk");
+		if (IS_ERR(clk))
+			return dev_err_probe(&pdev->dev, PTR_ERR(clk), "no CAN clk");
+
+		if (clk) {
+			priv->can.clock.freq  = clk_get_rate(clk) / 2;
+			if (!priv->can.clock.freq)
+				return dev_err_probe(&pdev->dev, -EINVAL, "Zero CAN clk rate");
+		}
+
 		sp_populate_of(priv, of);
 
 		if (of_data && of_data->init)
-- 
2.25.1

