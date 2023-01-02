Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7A65B5EC
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbjABRam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 12:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbjABRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:30:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF91AE7C
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 09:30:13 -0800 (PST)
Received: from dude05.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::54])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOdK-0003fo-3G; Mon, 02 Jan 2023 18:29:58 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
Date:   Mon, 02 Jan 2023 18:29:34 +0100
Subject: [PATCH v2 2/2] net: rfkill: gpio: add DT support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230102-rfkill-gpio-dt-v2-2-d1b83758c16d@pengutronix.de>
References: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
In-Reply-To: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
X-Mailer: b4 0.11.0-dev-e429b
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::54
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
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

Allow probing rfkill-gpio via device tree. This hooks up the already
existing support that was started in commit 262c91ee5e52 ("net:
rfkill: gpio: prepare for DT and ACPI support") via the "rfkill-gpio"
compatible, with the "name" and "type" properties renamed to "label"
and "radio-type", respectively, in the device tree case.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- Use __maybe_unused instead of #ifdef CONFIG_OF (Krzysztof)
- Support renamed "label" and "radio-type" property names
---
 net/rfkill/rfkill-gpio.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index f5afc9bcdee6..786dbfdad772 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -75,6 +75,8 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill;
 	struct gpio_desc *gpio;
+	const char *name_property;
+	const char *type_property;
 	const char *type_name;
 	int ret;
 
@@ -82,8 +84,15 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (!rfkill)
 		return -ENOMEM;
 
-	device_property_read_string(&pdev->dev, "name", &rfkill->name);
-	device_property_read_string(&pdev->dev, "type", &type_name);
+	if (dev_of_node(&pdev->dev)) {
+		name_property = "label";
+		type_property = "radio-type";
+	} else {
+		name_property = "name";
+		type_property = "type";
+	}
+	device_property_read_string(&pdev->dev, name_property, &rfkill->name);
+	device_property_read_string(&pdev->dev, type_property, &type_name);
 
 	if (!rfkill->name)
 		rfkill->name = dev_name(&pdev->dev);
@@ -157,12 +166,19 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
 #endif
 
+static const struct of_device_id rfkill_of_match[] __maybe_unused = {
+	{ .compatible = "rfkill-gpio", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rfkill_of_match);
+
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
 	.remove = rfkill_gpio_remove,
 	.driver = {
 		.name = "rfkill_gpio",
 		.acpi_match_table = ACPI_PTR(rfkill_acpi_match),
+		.of_match_table = of_match_ptr(rfkill_of_match),
 	},
 };
 

-- 
2.30.2
