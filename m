Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1082B12345F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfLQSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:07:15 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:36500 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfLQSHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 13:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576606032;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=UMXxJFiRafysqC5ToenIitB6VIK2rKk3aw2iJjhwYXI=;
        b=jPyk8Ja+RdOWhpFdqUTfsfA+H6ltACGPK5lQH4IPxGajY6gI/KZiwKv5k9nWwUsJQg
        PygrXs70zgHo6VNUVOd17tH5Yjic8n/6YO+tT4x1nTGqrK1ILzsYcjtvG9g23A9wnsLF
        anF/a6z+jusjZjHmGqvOj2qyJdc8CpU5jG1UMz4KXq47iB3zJHs2FG6AtUu6n2zdpk1k
        1f1+DxmggO0xBFnmwoNQGg5u9xZgw5kQdpfXVLey+e+AaoGo77XuD0oqmCUiJavU54oc
        ktSOBIA4/FcP7h1CB08jt/vTRNL+XpxN6SaXhWPK7Auh1Q/ZbBD0aOI3xEDZpBlolXjb
        I9sQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH5Hd8HaSCa"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id q020e2vBHI732eU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 17 Dec 2019 19:07:03 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: [PATCH v2 2/2] wl1251: remove ti,power-gpio for SDIO mode
Date:   Tue, 17 Dec 2019 19:07:00 +0100
Message-Id: <644b6f86c7ad5c24753a721cb262d8a9a371d914.1576606020.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1576606020.git.hns@goldelico.com>
References: <cover.1576606020.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove handling of this property from code.

Note that wl->power_gpio is still needed in
the header file for SPI mode (N900).

Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/net/wireless/ti/wl1251/sdio.c | 32 ++-------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index a032a1f92b57..4dff8bceb649 100644
--- a/drivers/net/wireless/ti/wl1251/sdio.c
+++ b/drivers/net/wireless/ti/wl1251/sdio.c
@@ -15,9 +15,7 @@
 #include <linux/wl12xx.h>
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
-#include <linux/gpio.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 
 #include "wl1251.h"
@@ -162,15 +160,6 @@ static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
 printk("%s %d\n", __func__, enable);
 
 	if (enable) {
-		/*
-		 * Power is controlled by runtime PM, but we still call board
-		 * callback in case it wants to do any additional setup,
-		 * for example enabling clock buffer for the module.
-		 */
-		if (gpio_is_valid(wl->power_gpio))
-			gpio_set_value(wl->power_gpio, true);
-
-
 		ret = pm_runtime_get_sync(&func->dev);
 		if (ret < 0) {
 			pm_runtime_put_sync(&func->dev);
@@ -188,9 +177,6 @@ printk("%s %d\n", __func__, enable);
 		ret = pm_runtime_put_sync(&func->dev);
 		if (ret < 0)
 			goto out;
-
-		if (gpio_is_valid(wl->power_gpio))
-			gpio_set_value(wl->power_gpio, false);
 	}
 
 out:
@@ -245,31 +231,17 @@ printk("%s: of=%pOFcC\n", __func__, np);
 
 	wl1251_board_data = wl1251_get_platform_data();
 	if (!IS_ERR(wl1251_board_data)) {
-		wl->power_gpio = wl1251_board_data->power_gpio;
 		wl->irq = wl1251_board_data->irq;
 		wl->use_eeprom = wl1251_board_data->use_eeprom;
 	} else if (np) {
-		wl->use_eeprom = of_property_read_bool(np,
-						       "ti,wl1251-has-eeprom");
-		wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);
+		wl->use_eeprom = of_property_read_bool(np, "ti,wl1251-has-eeprom");
 		wl->irq = of_irq_get(np, 0);
-
-		if (wl->power_gpio == -EPROBE_DEFER ||
-		    wl->irq == -EPROBE_DEFER) {
+		if (wl->irq == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
 			goto disable;
 		}
 	}
 
-	if (gpio_is_valid(wl->power_gpio)) {
-		ret = devm_gpio_request(&func->dev, wl->power_gpio,
-								"wl1251 power");
-		if (ret) {
-			wl1251_error("Failed to request gpio: %d\n", ret);
-			goto disable;
-		}
-	}
-
 	if (wl->irq) {
 		irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 		ret = request_irq(wl->irq, wl1251_line_irq, 0, "wl1251", wl);
-- 
2.23.0

