Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D321082EB
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKXKgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:36:11 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:10875 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfKXKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 05:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574591762;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=G2q76eNt4fD7xNecIuKnJaMYN+pua9d0B6y+REMDix8=;
        b=C0cNMLno+xns5Uv2UtfG5nsVCTDAyAd5iw7jrhB3hRMkP9LVeIvhuPRhoKDZCxFI/6
        lesYCMa+6ISuoNCv9F4sM9gWqZJW0SJ7gPwCvvq0HKijJmNrb4uvMiBZPrHfmbsmxyLi
        xTQL22mkLXpAx8JOrNgXBpjChATkqUfsupBtOM21PNCLPoZBSkJ/LDaZzYjG7haKAlFW
        0QMUBSPxBvM9wL9nqXfhiKBq5Op7yb08haO7dxUsG12z9KzgfiFdznFdPKNZXt4bOIu9
        xnkE1H4MUoMvx0vRTdlQYkKyioMiFDjNsJw8reg6u/QVnFCNtogfbC8X6Lx1AUNre/1C
        BkLg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH4HEaKeuIV"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vAOAZmw8w
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sun, 24 Nov 2019 11:35:48 +0100 (CET)
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
Subject: [PATCH 2/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
Date:   Sun, 24 Nov 2019 11:35:46 +0100
Message-Id: <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1574591746.git.hns@goldelico.com>
References: <cover.1574591746.git.hns@goldelico.com>
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
 drivers/net/wireless/ti/wl1251/sdio.c | 30 ---------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
index df0c20a555e3..82446196f9a8 100644
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
@@ -245,27 +231,11 @@ printk("%s: of=%pOFcC\n", __func__, np);
 
 	wl1251_board_data = wl1251_get_platform_data();
 	if (!IS_ERR(wl1251_board_data)) {
-		wl->power_gpio = wl1251_board_data->power_gpio;
 		wl->irq = wl1251_board_data->irq;
 		wl->use_eeprom = wl1251_board_data->use_eeprom;
 	} else if (np) {
 		wl->use_eeprom =of_property_read_bool(np, "ti,wl1251-has-eeprom");
-		wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);
 		wl->irq = of_irq_get(np, 0);
-
-		if (wl->power_gpio == -EPROBE_DEFER || wl->irq == -EPROBE_DEFER) {
-			ret = -EPROBE_DEFER;
-			goto disable;
-		}
-	}
-
-	if (gpio_is_valid(wl->power_gpio)) {
-		ret = devm_gpio_request(&func->dev, wl->power_gpio,
-								"wl1251 power");
-		if (ret) {
-			wl1251_error("Failed to request gpio: %d\n", ret);
-			goto disable;
-		}
 	}
 
 	if (wl->irq) {
-- 
2.23.0

