Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EF8396A7D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhFAAyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhFAAxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160AE61375;
        Tue,  1 Jun 2021 00:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508732;
        bh=z6Xsa2Rq528vEA4u9yW2RDF1eAQO1alQJELR9y3xA50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bK1+vC3zS2QJytjsq4sW5LxNpoQ+drm28iJLbpsWaukxBWOFgySKkDQGSaaj+bmXr
         zkH74Ep1aXo1XMZo2dXbwJG2P9PFtOmJ/e6US+NRXpMG7z1eAy1/9njojQdHXtPSVi
         QWT3m9JAPyQF0PrwxuffA/Qi9ocw7S9C3i+Pk+qkhIHsqA8m8eVb5Nd3UFvrJGH37H
         M4fwz7dZCk5w/CIHHoHLDZPRs5PZaX7OiaV6LPk8yAQREfilF0T7g3H7YaU83clx+a
         waZT4/NEdnRNpBzOxEmsd8o2GOG/4HsidsK/LxzBb9rFZK0w11IiCxyakdYIXBUQXg
         vdtKf1ixL2Ykw==
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
Subject: [PATCH leds v2 06/10] leds: core: inform trigger that it's deactivation is due to LED removal
Date:   Tue,  1 Jun 2021 02:51:51 +0200
Message-Id: <20210601005155.27997-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move setting of the LED_UNREGISTERING before deactivating the trigger in
led_classdev_unregister().

It can be useful for a LED trigger to know whether it is being
deactivated due to the LED being unregistered. This makes it possible
for LED drivers which implement trigger offloading to leave the LED in
HW triggering mode when the LED is unregistered, instead of disabling
it.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/led-class.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 2e495ff67856..0486129a7f31 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -436,6 +436,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	if (IS_ERR_OR_NULL(led_cdev->dev))
 		return;
 
+	led_cdev->flags |= LED_UNREGISTERING;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	down_write(&led_cdev->trigger_lock);
 	if (led_cdev->trigger)
@@ -443,8 +445,6 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	led_cdev->flags |= LED_UNREGISTERING;
-
 	/* Stop blinking */
 	led_stop_software_blink(led_cdev);
 
-- 
2.26.3

