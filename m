Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EF72A0495
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgJ3Low (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgJ3Low (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:52 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2447207DE;
        Fri, 30 Oct 2020 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058290;
        bh=mYokQTUy6lsno3U1tjXMofY2tBJRANrDVXM+A08CQko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuoRdXsyT3cnIewel50zEWxyxvXkdAYGgFdQPsDUVFOuouvEVsgvoNysEVWOIGo/k
         LdF1HWCFTcRgxSEFeV3Bz8DJnU0Ze2ZMpLcKcjzUi6EkngX4Pff9Uv3x5u8AAK93c2
         /nt+twLbaZozDQXyB8yjD601juTLcSOKRkuEp0KY=
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
Subject: [PATCH RFC leds + net-next 4/7] leds: trigger: netdev: support HW offloading
Date:   Fri, 30 Oct 2020 12:44:32 +0100
Message-Id: <20201030114435.20169-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for HW offloading of the netdev trigger.

We need to change spinlock to mutex, because if spinlock is used, the
trigger_offload() method cannot sleep, which can happen for ethernet
PHYs.

We can change the spinlock to mutex because, according to Jacek:
  register_netdevice_notifier() registers raw notifier chain,
  whose callbacks are not called from atomic context and there are
  no restrictions on callbacks. See include/linux/notifier.h.

Move struct led_trigger_data into global include directory, into file
linux/ledtrig.h, so that drivers wanting to offload the trigger can
access its settings.

Also export the netdev_led_trigger variable and declare it in ledtrih.h
so that drivers may check whether the LED is set to this trigger.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 48 ++++++++++-----------------
 include/linux/ledtrig.h               | 40 ++++++++++++++++++++++
 2 files changed, 57 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/ledtrig.h

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8f013b6df4fa..d4fa031d3a9e 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -10,17 +10,16 @@
 //  Copyright 2005-2006 Openedhand Ltd.
 //  Author: Richard Purdie <rpurdie@openedhand.com>
 
-#include <linux/atomic.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
+#include <linux/ledtrig.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/spinlock.h>
 #include <linux/timer.h>
 #include "../leds.h"
 
@@ -36,26 +35,6 @@
  *
  */
 
-struct led_netdev_data {
-	spinlock_t lock;
-
-	struct delayed_work work;
-	struct notifier_block notifier;
-
-	struct led_classdev *led_cdev;
-	struct net_device *net_dev;
-
-	char device_name[IFNAMSIZ];
-	atomic_t interval;
-	unsigned int last_activity;
-
-	unsigned link:1;
-	unsigned tx:1;
-	unsigned rx:1;
-
-	unsigned linkup:1;
-};
-
 enum netdev_led_attr {
 	NETDEV_ATTR_LINK,
 	NETDEV_ATTR_TX,
@@ -73,6 +52,9 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
+	if (!led_trigger_offload(led_cdev))
+		return;
+
 	if (!trigger_data->linkup)
 		led_set_brightness(led_cdev, LED_OFF);
 	else {
@@ -96,9 +78,9 @@ static ssize_t device_name_show(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	ssize_t len;
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 	len = sprintf(buf, "%s\n", trigger_data->device_name);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return len;
 }
@@ -114,7 +96,7 @@ static ssize_t device_name_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	if (trigger_data->net_dev) {
 		dev_put(trigger_data->net_dev);
@@ -138,7 +120,7 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return size;
 }
@@ -295,6 +277,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		netdev_notifier_info_to_dev((struct netdev_notifier_info *)dv);
 	struct led_netdev_data *trigger_data =
 		container_of(nb, struct led_netdev_data, notifier);
+	bool reset = true;
 
 	if (evt != NETDEV_UP && evt != NETDEV_DOWN && evt != NETDEV_CHANGE
 	    && evt != NETDEV_REGISTER && evt != NETDEV_UNREGISTER
@@ -308,7 +291,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	trigger_data->linkup = 0;
 	switch (evt) {
@@ -327,12 +310,14 @@ static int netdev_trig_notify(struct notifier_block *nb,
 	case NETDEV_CHANGE:
 		if (netif_carrier_ok(dev))
 			trigger_data->linkup = 1;
+		reset = !trigger_data->led_cdev->offloaded;
 		break;
 	}
 
-	set_baseline_state(trigger_data);
+	if (reset)
+		set_baseline_state(trigger_data);
 
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return NOTIFY_DONE;
 }
@@ -389,7 +374,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	if (!trigger_data)
 		return -ENOMEM;
 
-	spin_lock_init(&trigger_data->lock);
+	mutex_init(&trigger_data->lock);
 
 	trigger_data->notifier.notifier_call = netdev_trig_notify;
 	trigger_data->notifier.priority = 10;
@@ -423,12 +408,13 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
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
new file mode 100644
index 000000000000..593b2bee6ca0
--- /dev/null
+++ b/include/linux/ledtrig.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * LED trigger shared structures
+ */
+
+#ifndef __LINUX_LEDTRIG_H__
+#define __LINUX_LEDTRIG_H__
+
+#include <linux/atomic.h>
+#include <linux/leds.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+
+#if IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV)
+
+struct led_netdev_data {
+	struct mutex lock;
+
+	struct delayed_work work;
+	struct notifier_block notifier;
+
+	struct led_classdev *led_cdev;
+	struct net_device *net_dev;
+
+	char device_name[IFNAMSIZ];
+	atomic_t interval;
+	unsigned int last_activity;
+
+	unsigned link:1;
+	unsigned tx:1;
+	unsigned rx:1;
+
+	unsigned linkup:1;
+};
+
+extern struct led_trigger netdev_led_trigger;
+
+#endif /* IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV) */
+
+#endif /* __LINUX_LEDTRIG_H__ */
-- 
2.26.2

