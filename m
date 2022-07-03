Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C75646E5
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiGCKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiGCKrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:47:46 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2E66A447;
        Sun,  3 Jul 2022 03:47:44 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,241,1650898800"; 
   d="scan'208";a="124888170"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 03 Jul 2022 19:47:44 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 35B93427AD01;
        Sun,  3 Jul 2022 19:47:39 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller
Date:   Sun,  3 Jul 2022 11:47:05 +0100
Message-Id: <20220703104705.341070-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
References: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
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

The SJA1000 CAN controller on RZ/N1 SoC has no clock divider register
(CDR) support compared to others.

This patch adds support for RZ/N1 SJA1000 CAN Controller.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
v1->v2:
 * Updated commit description as SJA1000_NO_HW_LOOPBACK_QUIRK is removed
 * Added error handling on clk error path
 * Started using "devm_clk_get_optional_enabled" for clk get,prepare and enable.
---
 drivers/net/can/sja1000/sja1000_platform.c | 38 +++++++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 81bc741905fd..757fdb5da191 100644
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
+	priv->flags = SJA1000_QUIRK_NO_CDR_REG;
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
@@ -234,6 +248,11 @@ static int sp_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0)
 			return irq;
+
+		clk = devm_clk_get_optional_enabled(&pdev->dev, "can_clk");
+		if (IS_ERR(clk))
+			return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+					     "CAN clk operation failed");
 	} else {
 		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 		if (!res_irq)
@@ -262,6 +281,15 @@ static int sp_probe(struct platform_device *pdev)
 	priv->reg_base = addr;
 
 	if (of) {
+		if (clk) {
+			priv->can.clock.freq  = clk_get_rate(clk) / 2;
+			if (!priv->can.clock.freq) {
+				err = -EINVAL;
+				dev_err(&pdev->dev, "Zero CAN clk rate");
+				goto exit_free;
+			}
+		}
+
 		sp_populate_of(priv, of);
 
 		if (of_data && of_data->init)
-- 
2.25.1

