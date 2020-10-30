Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA22A0491
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgJ3Los (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3Lor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:47 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6B622210;
        Fri, 30 Oct 2020 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058285;
        bh=cryOkmKl8L3TgEJqLbJ8D9YdHNR4WBDJ0yPKZfD9574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPokpCHbiUOTXeZcaNpfYxKyv6II4WoNwxDO/Hz5P7ZryapStNfWJi5k61eHhVVbA
         FZsGQDtDcQF5tK+xPzrVdH1b18v7vO5Ihd3JKY3s/tRodovPj/OhDhbPP9j+p2Wnwe
         5S9X/fHhJjwLlex3nVKgekMNUluFM/SCCLBfWP3E=
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
Subject: [PATCH RFC leds + net-next 2/7] leds: trigger: netdev: simplify the driver by using bit field members
Date:   Fri, 30 Oct 2020 12:44:30 +0100
Message-Id: <20201030114435.20169-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bit fields members in struct led_netdev_data instead of one mode
member and set_bit/clear_bit/test_bit functions. These functions are
suitable for longer or variable length bit arrays.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 69 ++++++++++++---------------
 1 file changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4f6b73e3b491..8f013b6df4fa 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -49,11 +49,11 @@ struct led_netdev_data {
 	atomic_t interval;
 	unsigned int last_activity;
 
-	unsigned long mode;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
-#define NETDEV_LED_MODE_LINKUP	3
+	unsigned link:1;
+	unsigned tx:1;
+	unsigned rx:1;
+
+	unsigned linkup:1;
 };
 
 enum netdev_led_attr {
@@ -73,10 +73,10 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
+	if (!trigger_data->linkup)
 		led_set_brightness(led_cdev, LED_OFF);
 	else {
-		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
+		if (trigger_data->link)
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -85,8 +85,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 		/* If we are looking for RX/TX start periodically
 		 * checking stats
 		 */
-		if (test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
-		    test_bit(NETDEV_LED_RX, &trigger_data->mode))
+		if (trigger_data->tx || trigger_data->rx)
 			schedule_delayed_work(&trigger_data->work, 0);
 	}
 }
@@ -131,10 +130,10 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev =
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->linkup = 0;
 	if (trigger_data->net_dev != NULL)
 		if (netif_carrier_ok(trigger_data->net_dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+			trigger_data->linkup = 1;
 
 	trigger_data->last_activity = 0;
 
@@ -150,23 +149,24 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 	enum netdev_led_attr attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	int bit;
+	int val;
 
 	switch (attr) {
 	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
+		val = trigger_data->link;
 		break;
 	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
+		val = trigger_data->tx;
 		break;
 	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+		val = trigger_data->rx;
 		break;
 	default:
-		return -EINVAL;
+		/* unreachable */
+		break;
 	}
 
-	return sprintf(buf, "%u\n", test_bit(bit, &trigger_data->mode));
+	return sprintf(buf, "%u\n", val);
 }
 
 static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
@@ -175,33 +175,28 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	unsigned long state;
 	int ret;
-	int bit;
 
 	ret = kstrtoul(buf, 0, &state);
 	if (ret)
 		return ret;
 
+	cancel_delayed_work_sync(&trigger_data->work);
+
 	switch (attr) {
 	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
+		trigger_data->link = state;
 		break;
 	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
+		trigger_data->tx = state;
 		break;
 	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+		trigger_data->rx = state;
 		break;
 	default:
-		return -EINVAL;
+		/* unreachable */
+		break;
 	}
 
-	cancel_delayed_work_sync(&trigger_data->work);
-
-	if (state)
-		set_bit(bit, &trigger_data->mode);
-	else
-		clear_bit(bit, &trigger_data->mode);
-
 	set_baseline_state(trigger_data);
 
 	return size;
@@ -315,7 +310,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	spin_lock_bh(&trigger_data->lock);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->linkup = 0;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
 	case NETDEV_REGISTER:
@@ -331,7 +326,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
 		if (netif_carrier_ok(dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+			trigger_data->linkup = 1;
 		break;
 	}
 
@@ -360,21 +355,17 @@ static void netdev_trig_work(struct work_struct *work)
 	}
 
 	/* If we are not looking for RX/TX then return  */
-	if (!test_bit(NETDEV_LED_TX, &trigger_data->mode) &&
-	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
+	if (!trigger_data->tx && !trigger_data->rx)
 		return;
 
 	dev_stats = dev_get_stats(trigger_data->net_dev, &temp);
-	new_activity =
-	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
-		dev_stats->tx_packets : 0) +
-	    (test_bit(NETDEV_LED_RX, &trigger_data->mode) ?
-		dev_stats->rx_packets : 0);
+	new_activity = (trigger_data->tx ? dev_stats->tx_packets : 0) +
+		       (trigger_data->rx ? dev_stats->rx_packets : 0);
 
 	if (trigger_data->last_activity != new_activity) {
 		led_stop_software_blink(trigger_data->led_cdev);
 
-		invert = test_bit(NETDEV_LED_LINK, &trigger_data->mode);
+		invert = trigger_data->link;
 		interval = jiffies_to_msecs(
 				atomic_read(&trigger_data->interval));
 		/* base state is ON (link present) */
-- 
2.26.2

