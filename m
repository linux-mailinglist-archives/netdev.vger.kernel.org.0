Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180622A0493
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgJ3Lou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgJ3Lot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:49 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA2F2076E;
        Fri, 30 Oct 2020 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058288;
        bh=tE/tC6ooCmEzLfRaff5aRxKd92c2myio+aCA0dshSZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9vacvq+Xr9z3JfGbRBVTt1nZL1juT4j6I0yEzQf94eCAWMVBGWALsRnUL7ZzWGXD
         Fo6Q0GzaW3YAillRICnDrD1/7jP6kHeOAUn/+IRDtWH4WppaCz9WiKEF1F5MIpqYva
         UhNhJ/EzeNcpI1aT7SQsAjHlEUX8tX/Ij8ZwZWtM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC leds + net-next 3/7] leds: trigger: add API for HW offloading of triggers
Date:   Fri, 30 Oct 2020 12:44:31 +0100
Message-Id: <20201030114435.20169-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
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

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/leds/leds-class.rst | 20 ++++++++++++++++++++
 drivers/leds/led-triggers.c       |  1 +
 include/linux/leds.h              | 27 +++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
index a0708d3f3d0b..45360ff99f8d 100644
--- a/Documentation/leds/leds-class.rst
+++ b/Documentation/leds/leds-class.rst
@@ -169,6 +169,26 @@ Setting the brightness to zero with brightness_set() callback function
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
+If trigger_offload() returns negative value, the trigger will be done in
+software, so any active offloading must also be disabled.
+
+If the second argument (enable) to the trigger_offload() method is false, any
+active HW offloading must be deactivated.
 
 Known Issues
 ============
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 91da90cfb11d..9056a66f4661 100644
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
index 6a8d6409c993..d7e17f1d6f3c 100644
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
@@ -405,6 +410,28 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
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
+	if (led_cdev->offloaded)
+		led_cdev->trigger_offload(led_cdev, false);
+}
+
 /**
  * led_trigger_rename_static - rename a trigger
  * @name: the new trigger name
-- 
2.26.2

