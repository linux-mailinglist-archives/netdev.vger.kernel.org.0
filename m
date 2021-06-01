Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AEF396A73
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhFAAxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232437AbhFAAxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9232861375;
        Tue,  1 Jun 2021 00:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508724;
        bh=bFOrxpR/PUGl/FkcGxVH/b9ufR5syYBjPvKhU1yW9Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ6ilhjolG8h4EH0OD/Ktew9w+fq0TQV8zKloE3rzbq8QStJA50QeO22n7vpSTctE
         QsjxhdtpcTKl1PQwVE0A0mooCv3SpJa/aAWjQZcIJk5Hk9RExc1oML3aEd2l697cdX
         AbwpFITEQnKiJPljIyqyQFfD9qDlu5GJVqcFgVtw8uO+WnFu24W3FSGgZtVDpAXOT+
         OekCwCLH7UxblqrsylvuyylZVeLeiAWbZIcETCJ7BJ+3Uv4a0ZEiku12wKeG5a++ct
         yCX0JqujlE4R0qMJ29YUpzpSvRtPNvcqRcLtK42+zZvQjiU9XqRqsNX8ErUC7Jjrh5
         8sP8jCCg+RPaQ==
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
Subject: [PATCH leds v2 02/10] leds: trigger: add API for HW offloading of triggers
Date:   Tue,  1 Jun 2021 02:51:47 +0200
Message-Id: <20210601005155.27997-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add method trigger_offload() and member variable `offloaded` to struct
led_classdev. Add helper functions led_trigger_offload() and
led_trigger_offload_stop().

The trigger_offload() method, when implemented by the LED driver, should
be called (via led_trigger_offload() function) from trigger code wanting
to be offloaded at the moment when configuration of the trigger changes.

If the trigger is successfully offloaded, this method returns 0 and the
trigger does not have to blink the LED in software.

If the trigger with given configuration cannot be offloaded, the method
should return -EOPNOTSUPP, in which case the trigger must blink the LED
in SW.

The second argument to trigger_offload() being false means that the
offloading is being disabled. In this case the function must return 0,
errors are not permitted.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/leds/leds-class.rst | 22 ++++++++++++++++++++++
 drivers/leds/led-triggers.c       |  1 +
 include/linux/leds.h              | 29 +++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index cd155ead8703..15fa05c14afe 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,28 @@ Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
 hardware blinking function, if any.
 
+Hardware offloading of LED triggers
+===================================
+
+Some LEDs can offload SW triggers to hardware (for example a LED connected to
+an ethernet PHY or an ethernet switch can be configured to blink on activity on
+the network, which in software is done by the netdev trigger).
+
+To do such offloading, both the trigger code and LED driver must support this.
+The LED must implement the trigger_offload() method and the trigger code must
+try to call this method (via led_trigger_offload() function) when configuration
+of the trigger (trigger_data) changes.
+
+The implementation of the trigger_offload() method by the LED driver must return
+0 if the offload is successful and -EOPNOTSUPP if the requested trigger
+configuration is not supported and the trigger should be executed in software.
+If trigger_offload() returns negative value, the triggering will be done in
+software, so any active offloading must also be disabled.
+
+If the second argument (enable) to the trigger_offload() method is false, any
+active HW offloading must be deactivated. In this case errors are not permitted
+in the trigger_offload() method.
+
 
 Known Issues
 ============
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 4e7b78a84149..372980791b87 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -177,6 +177,7 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 			flags);
 		cancel_work_sync(&led_cdev->set_brightness_work);
 		led_stop_software_blink(led_cdev);
+		led_trigger_offload_stop(led_cdev);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		device_remove_groups(led_cdev->dev, led_cdev->trigger->groups);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 329fd914cf24..b331e7bceac3 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -148,6 +148,11 @@ struct led_classdev {
 
 	/* LEDs that have private triggers have this set */
 	struct led_hw_trigger_type	*trigger_type;
+
+	/* some LEDs may be able to offload some SW triggers to HW */
+	int		(*trigger_offload)(struct led_classdev *led_cdev,
+					   bool enable);
+	bool			offloaded;
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -403,6 +408,30 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 	return led_cdev->trigger_data;
 }
 
+static inline int led_trigger_offload(struct led_classdev *led_cdev)
+{
+	int ret;
+
+	if (!led_cdev->trigger_offload)
+		return -EOPNOTSUPP;
+
+	ret = led_cdev->trigger_offload(led_cdev, true);
+	led_cdev->offloaded = !ret;
+
+	return ret;
+}
+
+static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
+{
+	if (!led_cdev->trigger_offload)
+		return;
+
+	if (led_cdev->offloaded) {
+		led_cdev->trigger_offload(led_cdev, false);
+		led_cdev->offloaded = false;
+	}
+}
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.26.3

