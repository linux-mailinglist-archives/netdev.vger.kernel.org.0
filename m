Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C966C5B961E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIOIUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiIOIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E775979D9
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6l-0004Ko-1i
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 43E1AE398F
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A3F21E3931;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 88027817;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/23] can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller
Date:   Thu, 15 Sep 2022 10:19:56 +0200
Message-Id: <20220915082013.369072-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

The SJA1000 CAN controller on RZ/N1 SoC has no clock divider register
(CDR) support compared to others.

This patch adds support for RZ/N1 SJA1000 CAN Controller, by adding
SoC specific compatible to handle this difference as well as using
clk framework to retrieve the CAN clock frequency.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/all/20220710115248.190280-7-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/sja1000_platform.c | 38 +++++++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
index 81bc741905fd..6779d5357069 100644
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
+		clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
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
2.35.1


