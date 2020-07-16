Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402692228CF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgGPRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:17:35 -0400
Received: from mail.nic.cz ([217.31.204.67]:53292 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgGPRRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 13:17:33 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 15E24140A88;
        Thu, 16 Jul 2020 19:17:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594919851; bh=J5jzELM/OTNfIr+ix5KDxNNLPfsFIRMv3tJh8oyvZlU=;
        h=From:To:Date;
        b=btRxgrzUg921ZHzJKUrYMVPbiLzT5KjtLBS/fOPmiTs7H1GQd2kCd3PK31KQwBMIu
         u8ZYsjRB9c44apXYEzxdrPxHgoc8pkwOusq+EWsU2eBv0v0be5eIOeOoLPqJ2NDhMm
         mg4gCXstgldPh4vuxynaX+bHTW4BKvovf8T1vrj8=
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
Subject: [PATCH RFC leds + net-next 1/3] leds: trigger: add support for LED-private device triggers
Date:   Thu, 16 Jul 2020 19:17:28 +0200
Message-Id: <20200716171730.13227-2-marek.behun@nic.cz>
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

Some LED controllers may come with an internal HW triggering mechanism
for the LED and the ability to switch between SW control and the
internal HW control. This includes most PHYs, various ethernet switches,
the Turris Omnia LED controller or AXP20X PMIC.

This adds support for registering such triggers.

This code is based on work by Pavel Machek <pavel@ucw.cz> and
Ondřej Jirman <megous@megous.com>.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/leds/led-triggers.c | 26 ++++++++++++++++++++------
 include/linux/leds.h        | 10 ++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 79e30d2cb7a5..81e758d5a048 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -27,6 +27,12 @@ LIST_HEAD(trigger_list);
 
  /* Used by LED Class */
 
+static inline bool
+trigger_relevant(struct led_classdev *led_cdev, struct led_trigger *trig)
+{
+	return !trig->trigger_type || trig->trigger_type == led_cdev->trigger_type;
+}
+
 ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 			  struct bin_attribute *bin_attr, char *buf,
 			  loff_t pos, size_t count)
@@ -50,7 +56,7 @@ ssize_t led_trigger_write(struct file *filp, struct kobject *kobj,
 
 	down_read(&triggers_list_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
-		if (sysfs_streq(buf, trig->name)) {
+		if (sysfs_streq(buf, trig->name) && trigger_relevant(led_cdev, trig)) {
 			down_write(&led_cdev->trigger_lock);
 			led_trigger_set(led_cdev, trig);
 			up_write(&led_cdev->trigger_lock);
@@ -93,8 +99,12 @@ static int led_trigger_format(char *buf, size_t size,
 				       led_cdev->trigger ? "none" : "[none]");
 
 	list_for_each_entry(trig, &trigger_list, next_trig) {
-		bool hit = led_cdev->trigger &&
-			!strcmp(led_cdev->trigger->name, trig->name);
+		bool hit;
+
+		if (!trigger_relevant(led_cdev, trig))
+			continue;
+
+		hit = led_cdev->trigger && !strcmp(led_cdev->trigger->name, trig->name);
 
 		len += led_trigger_snprintf(buf + len, size - len,
 					    " %s%s%s", hit ? "[" : "",
@@ -243,7 +253,8 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 	down_read(&triggers_list_lock);
 	down_write(&led_cdev->trigger_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
-		if (!strcmp(led_cdev->default_trigger, trig->name)) {
+		if (!strcmp(led_cdev->default_trigger, trig->name) &&
+		    trigger_relevant(led_cdev, trig)) {
 			led_cdev->flags |= LED_INIT_DEFAULT_TRIGGER;
 			led_trigger_set(led_cdev, trig);
 			break;
@@ -280,7 +291,9 @@ int led_trigger_register(struct led_trigger *trig)
 	down_write(&triggers_list_lock);
 	/* Make sure the trigger's name isn't already in use */
 	list_for_each_entry(_trig, &trigger_list, next_trig) {
-		if (!strcmp(_trig->name, trig->name)) {
+		if (!strcmp(_trig->name, trig->name) &&
+		    (trig->trigger_type == _trig->trigger_type ||
+		     !trig->trigger_type || !_trig->trigger_type)) {
 			up_write(&triggers_list_lock);
 			return -EEXIST;
 		}
@@ -294,7 +307,8 @@ int led_trigger_register(struct led_trigger *trig)
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		down_write(&led_cdev->trigger_lock);
 		if (!led_cdev->trigger && led_cdev->default_trigger &&
-			    !strcmp(led_cdev->default_trigger, trig->name)) {
+		    !strcmp(led_cdev->default_trigger, trig->name) &&
+		    trigger_relevant(led_cdev, trig)) {
 			led_cdev->flags |= LED_INIT_DEFAULT_TRIGGER;
 			led_trigger_set(led_cdev, trig);
 		}
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 2451962d1ec5..6a8d6409c993 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -57,6 +57,10 @@ struct led_init_data {
 	bool devname_mandatory;
 };
 
+struct led_hw_trigger_type {
+	int dummy;
+};
+
 struct led_classdev {
 	const char		*name;
 	enum led_brightness	 brightness;
@@ -141,6 +145,9 @@ struct led_classdev {
 	void			*trigger_data;
 	/* true if activated - deactivate routine uses it to do cleanup */
 	bool			activated;
+
+	/* LEDs that have private triggers have this set */
+	struct led_hw_trigger_type	*trigger_type;
 #endif
 
 #ifdef CONFIG_LEDS_BRIGHTNESS_HW_CHANGED
@@ -345,6 +352,9 @@ struct led_trigger {
 	int		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
+	/* LED-private triggers have this set */
+	struct led_hw_trigger_type *trigger_type;
+
 	/* LEDs under control by this trigger (for simple triggers) */
 	rwlock_t	  leddev_list_lock;
 	struct list_head  led_cdevs;
-- 
2.26.2

