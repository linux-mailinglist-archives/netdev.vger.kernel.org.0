Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E66391E9B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhEZSDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhEZSDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE942613EC;
        Wed, 26 May 2021 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622052097;
        bh=IcrTTUXB12OA3E1dGQSEXA9SbqeA5iFFzo+wGhFn9vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2d7b3+N5s5HYdJEYBIPG9iIlP55DbTBwnpMV7H3284VjK+H5ycDu9EN+TTcLeb6q
         c7+1WleIstR4iAOEKxBlmFDtOkLX5BTAxKXiPSxW9/SgWzoH04mZ2WxwGfXQVlPLC4
         YDWjmBq8Z5txmLcGIjXKnO/8frXo6CxmNlqu6ciod/Hk86UOD5kQcMCxtZBxx5sj01
         RreWpon6GunxigHX5HuamwWdSxL+ssWOmkxmzO6b74NkytHGml+9hcCPET+7j/Z7gW
         yh1RprXzajTcfjp+zduQEpYpFYVABiEG3hAvGwoitpdKN8nwSCiK1NilXKzQlOHpfy
         C0DOaQumkXCnQ==
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
Subject: [PATCH leds v1 3/5] leds: trigger: netdev: move trigger data structure to global include dir
Date:   Wed, 26 May 2021 20:00:18 +0200
Message-Id: <20210526180020.13557-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210526180020.13557-1-kabel@kernel.org>
References: <20210526180020.13557-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for HW offloading of netdev trigger, move struct
led_trigger_data into global include directory, into file
linux/ledtrig.h, so that drivers wanting to offload the trigger can see
the requested settings.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 23 +---------------
 include/linux/ledtrig.h               | 38 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/ledtrig.h

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4f6b73e3b491..a611ad755036 100644
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
diff --git a/include/linux/ledtrig.h b/include/linux/ledtrig.h
new file mode 100644
index 000000000000..1cb7f03e6c16
--- /dev/null
+++ b/include/linux/ledtrig.h
@@ -0,0 +1,38 @@
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
+#include <linux/netdevice.h>
+#include <linux/spinlock.h>
+
+#if IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV)
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
+#endif /* IS_ENABLED(CONFIG_LEDS_TRIGGER_NETDEV) */
+
+#endif /* __LINUX_LEDTRIG_H__ */
-- 
2.26.3

