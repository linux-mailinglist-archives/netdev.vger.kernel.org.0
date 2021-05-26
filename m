Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB1391E9E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhEZSDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235414AbhEZSDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:03:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14805613C5;
        Wed, 26 May 2021 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622052101;
        bh=YYukrN0gtN9kwTFXmThy4546a/7oLlBsJI81+BNz9/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a//HXFXo35dDN1h8bbn/ar2X9NNjvm/24NE5UPYchG0HWzw9+YWZj6SaV4uaZ4Jon
         NCQzTDNprsUKr2zzxylukjk7WCGJyVL2VxU7AG2u2G0UV9apaQPU/xz8kmCicLTlYk
         UW2GvcQQU46HEYhu7k1scQTuz2fJFgD53w4jgDMcC8PjshqXEbunwsUcsx3q8aOp4o
         ltfYEDoFrp+hUER9eHiqEThvx+Q/p2YyLndbd0qrc+n1iToMI82AEZiCTtDt5tE3w5
         byRVih5+yR+jhbFkaVv3/QurVkGZlUe1KXn2/1IoYiEqlj97myVVh+Pog54aH4Rm21
         uH6ujIU9ry19g==
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
Subject: [PATCH leds v1 5/5] leds: trigger: netdev: change spinlock to mutex
Date:   Wed, 26 May 2021 20:00:20 +0200
Message-Id: <20210526180020.13557-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210526180020.13557-1-kabel@kernel.org>
References: <20210526180020.13557-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using spinlocks requires that the trigger_offload() method cannot sleep.
This can be problematic for some hardware, since access to registers may
sleep.

We can change the spinlock to mutex because, according to Jacek:
  register_netdevice_notifier() registers raw notifier chain,
  whose callbacks are not called from atomic context and there are
  no restrictions on callbacks. See include/linux/notifier.h.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 14 +++++++-------
 include/linux/ledtrig.h               |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index b6d51b24c213..7073cc6b8ca2 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -79,9 +79,9 @@ static ssize_t device_name_show(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	ssize_t len;
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 	len = sprintf(buf, "%s\n", trigger_data->device_name);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return len;
 }
@@ -97,7 +97,7 @@ static ssize_t device_name_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	if (trigger_data->net_dev) {
 		dev_put(trigger_data->net_dev);
@@ -121,7 +121,7 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return size;
 }
@@ -295,7 +295,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
 	switch (evt) {
@@ -319,7 +319,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	set_baseline_state(trigger_data);
 
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return NOTIFY_DONE;
 }
@@ -380,7 +380,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	if (!trigger_data)
 		return -ENOMEM;
 
-	spin_lock_init(&trigger_data->lock);
+	mutex_init(&trigger_data->lock);
 
 	trigger_data->notifier.notifier_call = netdev_trig_notify;
 	trigger_data->notifier.priority = 10;
diff --git a/include/linux/ledtrig.h b/include/linux/ledtrig.h
index a6a813bb154a..bd8cdcfaf232 100644
--- a/include/linux/ledtrig.h
+++ b/include/linux/ledtrig.h
@@ -8,13 +8,13 @@
 
 #include <linux/atomic.h>
 #include <linux/leds.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
-#include <linux/spinlock.h>
 
 #if IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV)
 
 struct led_netdev_data {
-	spinlock_t lock;
+	struct mutex lock;
 
 	struct delayed_work work;
 	struct notifier_block notifier;
-- 
2.26.3

