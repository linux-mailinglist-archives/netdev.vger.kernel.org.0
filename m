Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3399391E9C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhEZSDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhEZSDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:03:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBFB613D2;
        Wed, 26 May 2021 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622052099;
        bh=qCF24aDvqymIhf4BNzt4adPmMhhIa5R/Qjb11z5q3DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENMDuCQAvIahtB5REBoPeNOjooyuE39J+GsdnuWQWLwktILf2ZgTE/UYDOIQt6uTL
         AD3p5eaxL3WMY+NBzS6Ke+CgIxXdAU27R2+QDmGYgOMXgUdVnhTFKUUQvvqVfQHNII
         BkGKgkbHPIuEgohyphmB5hT8kCn5apagWYOUIUWvTCFOyUtQLzX9aKx05rIWxbYo/j
         Y68Wx1dCguuEb0Zn3toZZkjKDQIOAk2nSnSrdAt1ZA4hWuiYfV1Uv+N8iaF7o62l2G
         HCzVPDJhBJB/NIDXu3Dl1ln8xmT5pCzb5LM938htFSAvq9ZPLDR0eKZPhZ4k+GXIrZ
         cEyNmL8laZcZA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v1 4/5] leds: trigger: netdev: support HW offloading
Date:   Wed, 26 May 2021 20:00:19 +0200
Message-Id: <20210526180020.13557-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210526180020.13557-1-kabel@kernel.org>
References: <20210526180020.13557-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for HW offloading of the netdev trigger.

We need to export the netdev_led_trigger variable so that drivers may
check whether the LED is set to this trigger.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 6 +++++-
 include/linux/ledtrig.h               | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index a611ad755036..b6d51b24c213 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -52,6 +52,9 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
+	if (!led_trigger_offload(led_cdev))
+		return;
+
 	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
 		led_set_brightness(led_cdev, LED_OFF);
 	else {
@@ -411,12 +414,13 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
 	kfree(trigger_data);
 }
 
-static struct led_trigger netdev_led_trigger = {
+struct led_trigger netdev_led_trigger = {
 	.name = "netdev",
 	.activate = netdev_trig_activate,
 	.deactivate = netdev_trig_deactivate,
 	.groups = netdev_trig_groups,
 };
+EXPORT_SYMBOL_GPL(netdev_led_trigger);
 
 static int __init netdev_trig_init(void)
 {
diff --git a/include/linux/ledtrig.h b/include/linux/ledtrig.h
index 1cb7f03e6c16..a6a813bb154a 100644
--- a/include/linux/ledtrig.h
+++ b/include/linux/ledtrig.h
@@ -33,6 +33,8 @@ struct led_netdev_data {
 #define NETDEV_LED_MODE_LINKUP	3
 };
 
+extern struct led_trigger netdev_led_trigger;
+
 #endif /* IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV) */
 
 #endif /* __LINUX_LEDTRIG_H__ */
-- 
2.26.3

