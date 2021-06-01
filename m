Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933E7396A75
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhFAAxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232448AbhFAAxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A0361378;
        Tue,  1 Jun 2021 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508726;
        bh=Ki2jGCnqGAph6ha7Ohk+RDeT3gTHa2qj3aSUzC9cNX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/JKgmMU/UNqulRBTa9IQIhDEvJlq7P3D+Qd47vzMebIhknhxwd6vkug2TzXMHnej
         eIWGNSea2Sp7fHMWKeLufc0MIc5qWTjWKPmC9CVw1+U5JpZ7/im2RaxYHpqrkImOh0
         a/Hfv2RLqyeKlhuUu7dXUsM0UkUeqmMXxSSttlb8rQACX9YepF+sXE2oVEpT1U4egc
         4xPP8L6skUHh3trz36iC91ruG1celxbcUcG0AgEJLEKsUSgJ0c5c1VIy24Z0pN7GH6
         wvv0TaSUQ1pyE22lwUGFqLJOJcNcd2dsfLPQSg4YcM1ILlNLTHRqv6wDsUJAgCVeAk
         LyKK/FKidZ5rg==
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
Subject: [PATCH leds v2 03/10] leds: trigger: netdev: move trigger data structure to global include dir
Date:   Tue,  1 Jun 2021 02:51:48 +0200
Message-Id: <20210601005155.27997-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for HW offloading of netdev trigger, move struct
led_netdev_data into global include directory, into file
linux/ledtrig-netdev.h, so that drivers wanting to offload the trigger
can see the requested settings.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 23 +-----------------
 include/linux/ledtrig-netdev.h        | 34 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/ledtrig-netdev.h

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4f6b73e3b491..9a98f9c5b8d0 100644
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
+#include <linux/ledtrig-netdev.h>
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
-	unsigned long mode;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
-#define NETDEV_LED_MODE_LINKUP	3
-};
-
 enum netdev_led_attr {
 	NETDEV_ATTR_LINK,
 	NETDEV_ATTR_TX,
diff --git a/include/linux/ledtrig-netdev.h b/include/linux/ledtrig-netdev.h
new file mode 100644
index 000000000000..d6be039e1247
--- /dev/null
+++ b/include/linux/ledtrig-netdev.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * LED trigger shared structures
+ */
+
+#ifndef __LINUX_LEDTRIG_NETDEV_H__
+#define __LINUX_LEDTRIG_NETDEV_H__
+
+#include <linux/atomic.h>
+#include <linux/leds.h>
+#include <linux/netdevice.h>
+#include <linux/spinlock.h>
+
+struct led_netdev_data {
+	spinlock_t lock;
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
+	unsigned long mode;
+#define NETDEV_LED_LINK		0
+#define NETDEV_LED_TX		1
+#define NETDEV_LED_RX		2
+#define NETDEV_LED_MODE_LINKUP	3
+};
+
+#endif /* __LINUX_LEDTRIG_NETDEV_H__ */
-- 
2.26.3

