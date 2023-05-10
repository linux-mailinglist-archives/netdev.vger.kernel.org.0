Return-Path: <netdev+bounces-1532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1097C6FE248
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 274BC1C20DB9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0081F171A8;
	Wed, 10 May 2023 16:22:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5E174C0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:22:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C3C7AB9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683735765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MrfAzzTvSr4NM9cjx9eZc8ahJ2DJ06vyc3zvAB2kHlk=;
	b=RaZ0pTtj+x9hGrgCa9m0w0lw4Ean0GhU/4wQq1Lu24eEgKAYaxdldrtoFKtz/qSGqO7tMI
	CrfZkk7lKh2KXYjcHO3RygK8PqLCYjO98jCSFbS0gVQsPOV2gHPv1LgnCRBqipGC5NTNXs
	hnHzhVi9lFY5/af3pnfnufmmpvkXwow=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-XwFgT2OJMhOo4rseUA0DJw-1; Wed, 10 May 2023 12:22:43 -0400
X-MC-Unique: XwFgT2OJMhOo4rseUA0DJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27A46185A79C;
	Wed, 10 May 2023 16:22:42 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.195.159])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 106334078906;
	Wed, 10 May 2023 16:22:39 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Pavel Machek <pavel@ucw.cz>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sebastian Reichel <sre@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	linux-leds@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH RESEND 2/4] leds: Fix set_brightness_delayed() race
Date: Wed, 10 May 2023 18:22:32 +0200
Message-Id: <20230510162234.291439-3-hdegoede@redhat.com>
In-Reply-To: <20230510162234.291439-1-hdegoede@redhat.com>
References: <20230510162234.291439-1-hdegoede@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When a trigger wants to switch from blinking to LED on it needs to call:
	led_set_brightness(LED_OFF);
	led_set_brightness(LED_FULL);

To first call disables blinking and the second then turns the LED on
(the power-supply charging-blink-full-solid triggers do this).

These calls happen immediately after each other, so it is possible
that set_brightness_delayed() from the first call has not run yet
when the led_set_brightness(LED_FULL) call finishes.

If this race hits then this is causing problems for both
sw- and hw-blinking:

For sw-blinking set_brightness_delayed() clears delayed_set_value
when LED_BLINK_DISABLE is set causing the led_set_brightness(LED_FULL)
call effects to get lost when hitting the race, resulting in the LED
turning off instead of on.

For hw-blinking if the race hits delayed_set_value has been
set to LED_FULL by the time set_brightness_delayed() runs.
So led_cdev->brightness_set_blocking() is never called with
LED_OFF as argument and the hw-blinking is never disabled leaving
the LED blinking instead of on.

Fix both issues by adding LED_SET_BRIGHTNESS and LED_SET_BRIGHTNESS_OFF
work_flags making this 2 separate actions to be run by
set_brightness_delayed().

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Tested-by: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/leds/led-core.c | 57 +++++++++++++++++++++++++++++++----------
 include/linux/leds.h    |  3 +++
 2 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 4a97cb745788..e61acc785410 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -114,21 +114,14 @@ static void led_timer_function(struct timer_list *t)
 	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
 }
 
-static void set_brightness_delayed(struct work_struct *ws)
+static void set_brightness_delayed_set_brightness(struct led_classdev *led_cdev,
+						  unsigned int value)
 {
-	struct led_classdev *led_cdev =
-		container_of(ws, struct led_classdev, set_brightness_work);
 	int ret = 0;
 
-	if (test_and_clear_bit(LED_BLINK_DISABLE, &led_cdev->work_flags)) {
-		led_cdev->delayed_set_value = LED_OFF;
-		led_stop_software_blink(led_cdev);
-	}
-
-	ret = __led_set_brightness(led_cdev, led_cdev->delayed_set_value);
+	ret = __led_set_brightness(led_cdev, value);
 	if (ret == -ENOTSUPP)
-		ret = __led_set_brightness_blocking(led_cdev,
-					led_cdev->delayed_set_value);
+		ret = __led_set_brightness_blocking(led_cdev, value);
 	if (ret < 0 &&
 	    /* LED HW might have been unplugged, therefore don't warn */
 	    !(ret == -ENODEV && (led_cdev->flags & LED_UNREGISTERING) &&
@@ -137,6 +130,30 @@ static void set_brightness_delayed(struct work_struct *ws)
 			"Setting an LED's brightness failed (%d)\n", ret);
 }
 
+static void set_brightness_delayed(struct work_struct *ws)
+{
+	struct led_classdev *led_cdev =
+		container_of(ws, struct led_classdev, set_brightness_work);
+
+	if (test_and_clear_bit(LED_BLINK_DISABLE, &led_cdev->work_flags)) {
+		led_stop_software_blink(led_cdev);
+		set_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags);
+	}
+
+	/*
+	 * Triggers may call led_set_brightness(LED_OFF),
+	 * led_set_brightness(LED_FULL) in quick succession to disable blinking
+	 * and turn the LED on. Both actions may have been scheduled to run
+	 * before this work item runs once. To make sure this works properly
+	 * handle LED_SET_BRIGHTNESS_OFF first.
+	 */
+	if (test_and_clear_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags))
+		set_brightness_delayed_set_brightness(led_cdev, LED_OFF);
+
+	if (test_and_clear_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags))
+		set_brightness_delayed_set_brightness(led_cdev, led_cdev->delayed_set_value);
+}
+
 static void led_set_software_blink(struct led_classdev *led_cdev,
 				   unsigned long delay_on,
 				   unsigned long delay_off)
@@ -271,8 +288,22 @@ void led_set_brightness_nopm(struct led_classdev *led_cdev, unsigned int value)
 	if (!__led_set_brightness(led_cdev, value))
 		return;
 
-	/* If brightness setting can sleep, delegate it to a work queue task */
-	led_cdev->delayed_set_value = value;
+	/*
+	 * Brightness setting can sleep, delegate it to a work queue task.
+	 * value 0 / LED_OFF is special, since it also disables hw-blinking
+	 * (sw-blink disable is handled in led_set_brightness()).
+	 * To avoid a hw-blink-disable getting lost when a second brightness
+	 * change is done immediately afterwards (before the work runs),
+	 * it uses a separate work_flag.
+	 */
+	if (value) {
+		led_cdev->delayed_set_value = value;
+		set_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
+	} else {
+		clear_bit(LED_SET_BRIGHTNESS, &led_cdev->work_flags);
+		set_bit(LED_SET_BRIGHTNESS_OFF, &led_cdev->work_flags);
+	}
+
 	schedule_work(&led_cdev->set_brightness_work);
 }
 EXPORT_SYMBOL_GPL(led_set_brightness_nopm);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index c3dc22d184e2..de813fe96a20 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -124,6 +124,9 @@ struct led_classdev {
 #define LED_BLINK_INVERT		3
 #define LED_BLINK_BRIGHTNESS_CHANGE 	4
 #define LED_BLINK_DISABLE		5
+	/* Brightness off also disables hw-blinking so it is a separate action */
+#define LED_SET_BRIGHTNESS_OFF		6
+#define LED_SET_BRIGHTNESS		7
 
 	/* Set LED brightness level
 	 * Must not sleep. Use brightness_set_blocking for drivers
-- 
2.40.1


