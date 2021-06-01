Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BC1396A7B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhFAAx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232517AbhFAAxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC7AC613AD;
        Tue,  1 Jun 2021 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508730;
        bh=Nu/uf/ccww5gMoSX6cDd3d8bysChi7qjNX8MVEc2FMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCUd4yCuYC+w4CZx7hXJJ40s3wA3Fu4IqnCQ5K+MlU+Abnpbs+Kl0XJWyWEi7di7b
         dImId6l4WTdkcnnLlQ0nzlFFb3nXCs3bQtCEytv+pEeaObt+ovQjW9n1S4E5+l5rQR
         lpEVnGvusmY85GTI4kSymLzWO0WNpuMv9uoV+bCxxlQDGKLnwj/bM0odvbImVvyoCu
         78RsWCx9k5CPqdWpU36y7HQN9QzLXlC7KrrK54gpaRZ+XF20R33COWjJoOtkBuRh8H
         dmT5CbIci4QWP4kH22VrKjZf6rTwLTdgSEijaYH8pzwb6JV4Hxs8kBnos9z4V6xHGt
         77iG83CjR6LlQ==
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
Subject: [PATCH leds v2 05/10] leds: trigger: netdev: change spinlock to mutex
Date:   Tue,  1 Jun 2021 02:51:50 +0200
Message-Id: <20210601005155.27997-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
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
 include/linux/ledtrig-netdev.h        |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 1f1b63d5a78d..341e1f174c5b 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -83,9 +83,9 @@ static ssize_t device_name_show(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	ssize_t len;
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 	len = sprintf(buf, "%s\n", trigger_data->device_name);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return len;
 }
@@ -101,7 +101,7 @@ static ssize_t device_name_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	if (trigger_data->net_dev) {
 		dev_put(trigger_data->net_dev);
@@ -125,7 +125,7 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return size;
 }
@@ -299,7 +299,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
 	switch (evt) {
@@ -323,7 +323,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	set_baseline_state(trigger_data);
 
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return NOTIFY_DONE;
 }
@@ -384,7 +384,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	if (!trigger_data)
 		return -ENOMEM;
 
-	spin_lock_init(&trigger_data->lock);
+	mutex_init(&trigger_data->lock);
 
 	trigger_data->notifier.notifier_call = netdev_trig_notify;
 	trigger_data->notifier.priority = 10;
diff --git a/include/linux/ledtrig-netdev.h b/include/linux/ledtrig-netdev.h
index d6be039e1247..b93687ecc801 100644
--- a/include/linux/ledtrig-netdev.h
+++ b/include/linux/ledtrig-netdev.h
@@ -8,11 +8,11 @@
 
 #include <linux/atomic.h>
 #include <linux/leds.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
-#include <linux/spinlock.h>
 
 struct led_netdev_data {
-	spinlock_t lock;
+	struct mutex lock;
 
 	struct delayed_work work;
 	struct notifier_block notifier;
-- 
2.26.3

