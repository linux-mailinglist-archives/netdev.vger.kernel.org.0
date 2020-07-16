Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A6B2228D3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgGPRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:17:33 -0400
Received: from mail.nic.cz ([217.31.204.67]:53308 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbgGPRRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 13:17:33 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 3C50C140A8D;
        Thu, 16 Jul 2020 19:17:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594919851; bh=5aWK9bcuNcHRqhyEhDtoFmIPPFIlMkbkUbrKp1qgHSA=;
        h=From:To:Date;
        b=F/nx+tgvQvHYjEGMYUkvMuuhIDJmDc3VyNf0Bhr/u0/oI92lgOEs8+qBH8faFyLLm
         4nkVS2uYTI6GZNLc3QRMBCMPgLNUC6gsht2a5ms2cc58PdMlagOqCbmxFBvtWVONH/
         txJsfyXdAVdm56cSDa9w9kIOY+4QI4YXTDtYP8ek=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     linux-leds@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, jacek.anaszewski@gmail.com,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC leds + net-next 2/3] leds: trigger: return error value if .activate() failed
Date:   Thu, 16 Jul 2020 19:17:29 +0200
Message-Id: <20200716171730.13227-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716171730.13227-1-marek.behun@nic.cz>
References: <20200716171730.13227-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when the .activate() method fails and returns a negative error
code while writing to the /sys/class/leds/<LED>/trigger file, the write
system call does not inform the user abouth this failure.

This patch fixes this.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/leds/led-triggers.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 81e758d5a048..804e0d624f47 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -40,7 +40,7 @@ ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_trigger *trig;
-	int ret = count;
+	int ret;
 
 	mutex_lock(&led_cdev->led_access);
 
@@ -58,7 +58,7 @@ ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 	list_for_each_entry(trig, &trigger_list, next_trig) {
 		if (sysfs_streq(buf, trig->name) && trigger_relevant(led_cdev, trig)) {
 			down_write(&led_cdev->trigger_lock);
-			led_trigger_set(led_cdev, trig);
+			ret = led_trigger_set(led_cdev, trig);
 			up_write(&led_cdev->trigger_lock);
 
 			up_read(&triggers_list_lock);
@@ -71,7 +71,7 @@ ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 
 unlock:
 	mutex_unlock(&led_cdev->led_access);
-	return ret;
+	return ret < 0 ? ret : count;
 }
 EXPORT_SYMBOL_GPL(led_trigger_write);
 
-- 
2.26.2

