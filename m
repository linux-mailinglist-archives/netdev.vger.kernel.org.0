Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD26D6B9B94
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjCNQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCNQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6B9498B1;
        Tue, 14 Mar 2023 09:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C16EB81A3E;
        Tue, 14 Mar 2023 16:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DF1C433EF;
        Tue, 14 Mar 2023 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678811535;
        bh=3thpXw1wfRnYkdHGJfjXh0EGsAUsvI6i5bTHqTNtC9E=;
        h=From:To:Cc:Subject:Date:From;
        b=RYkH0LdbEiwbCQbc9yjG4sXc6ihlvS8e0JxUzYa2FclHhqwNHqi1M9YawkTjInntw
         wuHA/kPISG1MKQLGmE9xQQJAc3Wl9wVETwvHiMPkqvz6WWyBTMjh49lukfU5LbUNaw
         WeSL82gpDD7hSp6h+XPsuNvhtoJPIvcPeBaeCP5v2qVXNRMbKsGI5tVV48XE9c82Xx
         UFiNiVYLG5ql8n5iMTd9x5nx0EFkh4art5MZxG1ZUxHyhPsfl0vdwBqr36UZhJp3PK
         h27dr+ApbjSwjfiyjnwYOIZLPnP/kL0WqaH/LO26Fncsjr6qgNxKwe6KR9w2M7aFUp
         dk5yvgJvxZkww==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] p54spi: convert to devicetree
Date:   Tue, 14 Mar 2023 17:30:56 +0100
Message-Id: <20230314163201.955689-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The Prism54 SPI driver hardcodes GPIO numbers and expects users to
pass them as module parameters, apparently a relic from its life as a
staging driver. This works because there is only one user, the Nokia
N8x0 tablet.

Convert this to the gpio descriptor interface and move the gpio
line information into devicetree to improve this and simplify the
code at the same time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
As I don't have an N8x0, this is completely untested.

I listed the driver authors (Johannes and Christian) as the maintainers
of the binding document, but I don't know if they actually have this
hardware. It might be better to list someone who is actually using it.

Among the various chip identifications, I wasn't sure which one to
use for the compatible string and the name of the binding document.
I picked st,stlc4560 as that was cited as the version in the N800
on multiple websites.
---
 .../bindings/net/wireless/st,stlc45xx.yaml    | 64 +++++++++++++++++
 MAINTAINERS                                   |  1 +
 arch/arm/boot/dts/omap2.dtsi                  |  4 ++
 arch/arm/boot/dts/omap2420-n8x0-common.dtsi   | 12 ++++
 arch/arm/mach-omap2/board-n8x0.c              | 18 -----
 drivers/net/wireless/intersil/p54/p54spi.c    | 69 +++++++------------
 drivers/net/wireless/intersil/p54/p54spi.h    |  3 +
 7 files changed, 109 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml

diff --git a/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml b/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
new file mode 100644
index 000000000000..45bc4fab409a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/st,stlc45xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ST/Intersil/Conexant stlc45xx/p54spi/cx3110x SPI wireless device
+
+maintainers:
+  - Johannes Berg <johannes@sipsolutions.net>
+  - Christian Lamparter <chunkeey@web.de>
+
+description: |
+  The SPI variant of the Intersil Prism54 wireless device was sold
+  under a variety of names, including ST Microelectronics STLC5460
+  and Conexant CX3110x.
+
+allOf:
+  - $ref: ieee80211.yaml#
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+properties:
+  compatible:
+    enum:
+      - st,stlc4550
+      - st,stlc4560
+      - isil,p54spi
+      - cnxt,3110x
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  power-gpios:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  - |
+   gpio {
+     gpio-controller;
+     #gpio-cells = <1>;
+     #interupt-cells = <1>;
+   };
+   spi {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      wifi@0 {
+        reg = <0>;
+        compatible = "st,stlc4560";
+        spi-max-frequency = <48000000>;
+        interrupts-extended = <&gpio 23>;
+        power-gpios = <&gpio 1>;
+     };
+   };
diff --git a/MAINTAINERS b/MAINTAINERS
index 25a0981c74b6..a238b1ad5878 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15754,6 +15754,7 @@ M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/p54
+F:	Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml
 F:	drivers/net/wireless/intersil/p54/
 
 PACKET SOCKETS
diff --git a/arch/arm/boot/dts/omap2.dtsi b/arch/arm/boot/dts/omap2.dtsi
index afabb36a8ac1..fdc1790adf43 100644
--- a/arch/arm/boot/dts/omap2.dtsi
+++ b/arch/arm/boot/dts/omap2.dtsi
@@ -129,6 +129,8 @@ i2c2: i2c@48072000 {
 		};
 
 		mcspi1: spi@48098000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi1";
 			reg = <0x48098000 0x100>;
@@ -140,6 +142,8 @@ mcspi1: spi@48098000 {
 		};
 
 		mcspi2: spi@4809a000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi2";
 			reg = <0x4809a000 0x100>;
diff --git a/arch/arm/boot/dts/omap2420-n8x0-common.dtsi b/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
index 63b0b4921e4e..483ad1411f99 100644
--- a/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
+++ b/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
@@ -109,3 +109,15 @@ partition@5 {
 		};
 	};
 };
+
+&mcspi2 {
+	status = "okay";
+
+	wifi@0 {
+		reg = <0>;
+		compatible = "st,stlc4560";
+		spi-max-frequency = <48000000>;
+		interrupts-extended = <&gpio3 23 IRQ_TYPE_EDGE_RISING>;
+		gpios = <&gpio4 1 GPIO_ACTIVE_HIGH>; /* gpio 97 */
+	};
+};
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 3353b0a923d9..6a2949f50653 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -19,7 +19,6 @@
 #include <linux/spi/spi.h>
 #include <linux/usb/musb.h>
 #include <linux/mmc/host.h>
-#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mmc-omap.h>
 #include <linux/mfd/menelaus.h>
 
@@ -142,21 +141,6 @@ static void __init n8x0_usb_init(void) {}
 
 #endif /*CONFIG_USB_MUSB_TUSB6010 */
 
-
-static struct omap2_mcspi_device_config p54spi_mcspi_config = {
-	.turbo_mode	= 0,
-};
-
-static struct spi_board_info n800_spi_board_info[] __initdata = {
-	{
-		.modalias	= "p54spi",
-		.bus_num	= 2,
-		.chip_select	= 0,
-		.max_speed_hz   = 48000000,
-		.controller_data = &p54spi_mcspi_config,
-	},
-};
-
 #if defined(CONFIG_MENELAUS) && IS_ENABLED(CONFIG_MMC_OMAP)
 
 /*
@@ -585,7 +569,5 @@ omap_late_initcall(n8x0_late_initcall);
 void * __init n8x0_legacy_init(void)
 {
 	board_check_revision();
-	spi_register_board_info(n800_spi_board_info,
-				ARRAY_SIZE(n800_spi_board_info));
 	return &mmc1_data;
 }
diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index 19152fd449ba..8e294ba806e3 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/firmware.h>
@@ -15,7 +16,7 @@
 #include <linux/irq.h>
 #include <linux/spi/spi.h>
 #include <linux/etherdevice.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/slab.h>
 
 #include "p54spi.h"
@@ -29,19 +30,6 @@
 
 MODULE_FIRMWARE("3826.arm");
 
-/* gpios should be handled in board files and provided via platform data,
- * but because it's currently impossible for p54spi to have a header file
- * in include/linux, let's use module paramaters for now
- */
-
-static int p54spi_gpio_power = 97;
-module_param(p54spi_gpio_power, int, 0444);
-MODULE_PARM_DESC(p54spi_gpio_power, "gpio number for power line");
-
-static int p54spi_gpio_irq = 87;
-module_param(p54spi_gpio_irq, int, 0444);
-MODULE_PARM_DESC(p54spi_gpio_irq, "gpio number for irq line");
-
 static void p54spi_spi_read(struct p54s_priv *priv, u8 address,
 			      void *buf, size_t len)
 {
@@ -261,14 +249,14 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 
 static void p54spi_power_off(struct p54s_priv *priv)
 {
-	disable_irq(gpio_to_irq(p54spi_gpio_irq));
-	gpio_set_value(p54spi_gpio_power, 0);
+	disable_irq(priv->irq);
+	gpiod_set_value(priv->gpio_power, 0);
 }
 
 static void p54spi_power_on(struct p54s_priv *priv)
 {
-	gpio_set_value(p54spi_gpio_power, 1);
-	enable_irq(gpio_to_irq(p54spi_gpio_irq));
+	gpiod_set_value(priv->gpio_power, 1);
+	enable_irq(priv->irq);
 
 	/* need to wait a while before device can be accessed, the length
 	 * is just a guess
@@ -607,32 +595,20 @@ static int p54spi_probe(struct spi_device *spi)
 		goto err_free;
 	}
 
-	ret = gpio_request(p54spi_gpio_power, "p54spi power");
-	if (ret < 0) {
+	priv->gpio_power = gpiod_get(&spi->dev, "power", GPIOD_OUT_LOW);
+	if (IS_ERR(priv->gpio_power)) {
+		ret = PTR_ERR(priv->gpio_power);
 		dev_err(&priv->spi->dev, "power GPIO request failed: %d", ret);
 		goto err_free;
 	}
 
-	ret = gpio_request(p54spi_gpio_irq, "p54spi irq");
-	if (ret < 0) {
-		dev_err(&priv->spi->dev, "irq GPIO request failed: %d", ret);
-		goto err_free_gpio_power;
-	}
-
-	gpio_direction_output(p54spi_gpio_power, 0);
-	gpio_direction_input(p54spi_gpio_irq);
-
-	ret = request_irq(gpio_to_irq(p54spi_gpio_irq),
-			  p54spi_interrupt, 0, "p54spi",
-			  priv->spi);
+	ret = request_irq(spi->irq, p54spi_interrupt, 0, "p54spi", priv->spi);
 	if (ret < 0) {
 		dev_err(&priv->spi->dev, "request_irq() failed");
-		goto err_free_gpio_irq;
+		goto err_free_gpio_power;
 	}
 
-	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
-
-	disable_irq(gpio_to_irq(p54spi_gpio_irq));
+	disable_irq(priv->irq);
 
 	INIT_WORK(&priv->work, p54spi_work);
 	init_completion(&priv->fw_comp);
@@ -660,11 +636,9 @@ static int p54spi_probe(struct spi_device *spi)
 
 err_free_common:
 	release_firmware(priv->firmware);
-	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
-err_free_gpio_irq:
-	gpio_free(p54spi_gpio_irq);
+	free_irq(priv->irq, spi);
 err_free_gpio_power:
-	gpio_free(p54spi_gpio_power);
+	gpiod_put(priv->gpio_power);
 err_free:
 	p54_free_common(priv->hw);
 	return ret;
@@ -676,10 +650,8 @@ static void p54spi_remove(struct spi_device *spi)
 
 	p54_unregister_common(priv->hw);
 
-	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
-
-	gpio_free(p54spi_gpio_power);
-	gpio_free(p54spi_gpio_irq);
+	free_irq(priv->irq, spi);
+	gpiod_put(priv->gpio_power);
 	release_firmware(priv->firmware);
 
 	mutex_destroy(&priv->mutex);
@@ -687,10 +659,19 @@ static void p54spi_remove(struct spi_device *spi)
 	p54_free_common(priv->hw);
 }
 
+struct of_device_id p54spi_of_ids[] = {
+	{ .compatible = "cnxt,3110x", },
+	{ .compatible = "isil,p54spi", },
+	{ .compatible = "st,stlc4550", },
+	{ .compatible = "st,stlc4560", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, p54spi_of_ids);
 
 static struct spi_driver p54spi_driver = {
 	.driver = {
 		.name		= "p54spi",
+		.of_match_table = p54spi_of_ids,
 	},
 
 	.probe		= p54spi_probe,
diff --git a/drivers/net/wireless/intersil/p54/p54spi.h b/drivers/net/wireless/intersil/p54/p54spi.h
index e5619a13fd61..aae6fc64972a 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.h
+++ b/drivers/net/wireless/intersil/p54/p54spi.h
@@ -107,6 +107,9 @@ struct p54s_priv {
 
 	enum fw_state fw_state;
 	const struct firmware *firmware;
+
+	struct gpio_desc *gpio_power;
+	int irq;
 };
 
 #endif /* P54SPI_H */
-- 
2.39.2

