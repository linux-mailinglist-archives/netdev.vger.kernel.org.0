Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34666149CC0
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgAZUMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:12:20 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:14121 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZUMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 15:12:16 -0500
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2020 15:12:15 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580069534;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=9DXGwXErgXDHdL5PyUUKhEt+Tr0bMtP/eeo2aEv0+0w=;
        b=ghWMU6VBrG2JH4vAVV9uMWK3trWHUUL8XMw1LVj9YQ/9/I+W3NL7Ln1ARX9W+DVKM/
        1SsVFAyRLqRFnEWE6cD5M3HKQ43QrFHkiA+RF2OihB/lI1mWzFoC53cz3+qL9Ef2lrIV
        oDrnE/HykuQzEtFUrw+LSFvaoCmr4il1jTYMt7zO+3U/EYfq2W3RL8vHpjdCYhCeSVfs
        s8Te5xdPXveoRNeUs/JNvWU5G6uJEyQBRPNPkIwW7r+tLirKxjibR/ULT/CoIVjpdls5
        VpbwzyKdDcqiii9H9BltZphEb4juHxRh2VAG5HojKB09g/azof+ueV6URZr6MVZM4s/E
        bUjA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2AyPQjcv7w="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.7 DYNA|AUTH)
        with ESMTPSA id k0645aw0QK0FF2G
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 26 Jan 2020 21:00:15 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: [PATCH v3 2/2] wl1251: remove ti,power-gpio for SDIO mode
Date:   Sun, 26 Jan 2020 21:00:14 +0100
Message-Id: <e77b49bb475f63dd7b07bfb76a75651e80bbace7.1580068813.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1580068813.git.hns@goldelico.com>
References: <cover.1580068813.git.hns@goldelico.com>
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
index 94569cd695c8..c9a4e9a43400 100644
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
@@ -160,15 +158,6 @@ static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
 	int ret;
 
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
@@ -186,9 +175,6 @@ static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
 		ret = pm_runtime_put_sync(&func->dev);
 		if (ret < 0)
 			goto out;
-
-		if (gpio_is_valid(wl->power_gpio))
-			gpio_set_value(wl->power_gpio, false);
 	}
 
 out:
@@ -241,31 +227,17 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 
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

