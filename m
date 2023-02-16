Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37D0698A08
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjBPBg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPBgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:42 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ADB457FF;
        Wed, 15 Feb 2023 17:36:25 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id z13so466135wmp.2;
        Wed, 15 Feb 2023 17:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iuGXaXqILaNTsxW+v3RUsYfQ+Yu3bUhjcC1ERhfRoBQ=;
        b=YpnJV1ZjewGu/0d+fLOxiXIUGio7nvM8OhLDpnzU6WTtK3owjw0dBtsFHvvJU7DF7Q
         CH51XQoVmZCbVctPGlli+ZuCvQCTltP6D8TcUL5CP9BcM1ZKWS4RF5N9fsMYyCWr85WG
         QxvSzbcMJkvJ+/gyiLX/KACm7o81ALXsHijpD/h3iKSIigSkU+X2QepFLUiebHJK3doN
         Ll5VfzFLH9iLzh43+T/lga/Qga6qWr6kG3daffHZOSoULx/oE2M45RYb82eYUI0ua7T8
         W6bZcYhTKLbcJj+X82wXTJZfy8keca2Yu/JtqgFMZ0F9VCyn7pvUv6h7GSCa2dkli5np
         nnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuGXaXqILaNTsxW+v3RUsYfQ+Yu3bUhjcC1ERhfRoBQ=;
        b=Snt3r5DQNIEAi7v7Ed/i2JqdMZdAqJKYJfM84RObHCHgoV96sqYZPXApkuHeVtLkYs
         xXGWFDtQLznE8sD0OjWVq6Cwu97bVcQNJo5IT+UZ5q1u9BqX+FfINxMli9GbLGKzQ6pe
         fnQ/Wb6pnNvxzVeZjULIU/dr+hq7W9ReRCOHSu4wQrbl6ZAzj16iH/JwXw/6SbqO5WIW
         kaB7ZRtx+Ztb24+4ZFblqmCKomYUlaJs+mVTh46PgSdhkx0lQmwP1RWkZEWOb+Q+iFC0
         IDnJ6OK5dOwClao4mfpJKd1SC2seeW2aO21UEZzmqpGsClLRNyVwGlUejR+1tfxZd5WS
         XXJg==
X-Gm-Message-State: AO0yUKWPiQES8dcxuhUBMwwHuKDI5L9qBdWghjhhFhXK9Hm+o0Zt7xvS
        Jd0a5Ufw1ssfF9zbJLa7tHI=
X-Google-Smtp-Source: AK7set/02v3/QImoPI+x2vebAqwY8KXEa7qrCPdACbl1ohohpA6XMKM1LbaKPtO9XeofPOko95IfWQ==
X-Received: by 2002:a05:600c:3509:b0:3df:a04a:1a7 with SMTP id h9-20020a05600c350900b003dfa04a01a7mr3277838wmq.22.1676511384528;
        Wed, 15 Feb 2023 17:36:24 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:24 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 06/13] leds: trigger: netdev: add hardware control support
Date:   Thu, 16 Feb 2023 02:32:23 +0100
Message-Id: <20230216013230.22978-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hardware control support for the Netdev trigger.
The trigger on config change will check if the requested trigger can set
to blink mode using LED hardware mode and if every blink mode is supported,
the trigger will enable hardware mode with the requested configuration.
If there is at least one trigger that is not supported and can't run in
hardware mode, then software mode will be used instead.
A validation is done on every value change and on fail the old value is
restored and -EINVAL is returned.

In HW blink mode interval setting is not supported as it's handled
internally.

To use HW blink mode, dev MUST be empty. If set, SW blink mode is
forced.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 175 ++++++++++++++++++++++++--
 1 file changed, 165 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index dd63cadb896e..d85be325e492 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -28,7 +28,9 @@
  * Configurable sysfs attributes:
  *
  * device_name - network device name to monitor
+ *               (not supported in hw mode)
  * interval - duration of LED blink, in milliseconds
+ *            (not supported in hw mode)
  * link -  LED's normal state reflects whether the link is up
  *         (has carrier) or not
  * tx -  LED blinks on transmitted data
@@ -37,6 +39,7 @@
  */
 
 struct led_netdev_data {
+	enum led_blink_modes blink_mode;
 	spinlock_t lock;
 
 	struct delayed_work work;
@@ -53,11 +56,111 @@ struct led_netdev_data {
 	bool carrier_link_up;
 };
 
+struct netdev_led_attr_detail {
+	char *name;
+	bool hardware_only;
+	enum led_trigger_netdev_modes bit;
+};
+
+static struct netdev_led_attr_detail attr_details[] = {
+	{ .name = "link", .bit = TRIGGER_NETDEV_LINK},
+	{ .name = "tx", .bit = TRIGGER_NETDEV_TX},
+	{ .name = "rx", .bit = TRIGGER_NETDEV_RX},
+};
+
+static bool validate_baseline_state(struct led_netdev_data *trigger_data)
+{
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
+	unsigned long hw_blink_modes = 0, sw_blink_modes = 0;
+	struct netdev_led_attr_detail *detail;
+	bool force_sw = false;
+	int i;
+
+	/* Check if we need to force sw mode for some feature */
+	if (trigger_data->net_dev)
+		force_sw = true;
+
+	/* Hardware only controlled LED can't run in sw mode */
+	if (force_sw && led_cdev->blink_mode == LED_BLINK_HW_CONTROLLED)
+		return false;
+
+	/* Check each attr and make sure they are all supported */
+	for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+		detail = &attr_details[i];
+
+		/* Mode not active, skip */
+		if (!test_bit(detail->bit, &trigger_data->mode))
+			continue;
+
+		/* Hardware only mode enabled on software controlled LED */
+		if ((force_sw || led_cdev->blink_mode == LED_BLINK_SW_CONTROLLED) &&
+		    detail->hardware_only)
+			return false;
+
+		/* Check if the mode supports hardware mode */
+		if (led_cdev->blink_mode != LED_BLINK_SW_CONTROLLED) {
+			/* Track modes that should be handled by sw */
+			if (force_sw) {
+				sw_blink_modes |= BIT(detail->bit);
+				continue;
+			}
+
+			/* Check if the mode is supported */
+			if (led_trigger_blink_mode_is_supported(led_cdev, BIT(detail->bit)))
+				hw_blink_modes |= BIT(detail->bit);
+		} else {
+			sw_blink_modes |= BIT(detail->bit);
+		}
+	}
+
+	/* We can't run modes handled by both software and hardware. */
+	if (hw_blink_modes && sw_blink_modes)
+		return false;
+
+	/* Make sure we support each requested mode */
+	if (hw_blink_modes && hw_blink_modes != trigger_data->mode)
+		return false;
+
+	/* Modes are valid. Decide now the running mode to later
+	 * set the baseline.
+	 */
+	if (sw_blink_modes)
+		trigger_data->blink_mode = LED_BLINK_SW_CONTROLLED;
+	else
+		trigger_data->blink_mode = LED_BLINK_HW_CONTROLLED;
+
+	return true;
+}
+
 static void set_baseline_state(struct led_netdev_data *trigger_data)
 {
+	int i;
 	int current_brightness;
+	struct netdev_led_attr_detail *detail;
 	struct led_classdev *led_cdev = trigger_data->led_cdev;
 
+	/* Modes already validated. Directly apply hw trigger modes */
+	if (trigger_data->blink_mode == LED_BLINK_HW_CONTROLLED) {
+		/* We are refreshing the blink modes. Reset them */
+		led_cdev->hw_control_configure(led_cdev, 0,
+					       LED_BLINK_HW_RESET);
+
+		for (i = 0; i < ARRAY_SIZE(attr_details); i++) {
+			detail = &attr_details[i];
+
+			if (!test_bit(detail->bit, &trigger_data->mode))
+				continue;
+
+			led_cdev->hw_control_configure(led_cdev, BIT(detail->bit),
+						       LED_BLINK_HW_ENABLE);
+		}
+
+		led_cdev->hw_control_start(led_cdev);
+
+		return;
+	}
+
+	/* Handle trigger modes by software */
 	current_brightness = led_cdev->brightness;
 	if (current_brightness)
 		led_cdev->blink_brightness = current_brightness;
@@ -100,6 +203,8 @@ static ssize_t device_name_store(struct device *dev,
 				 size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	char old_device_name[IFNAMSIZ];
+	struct net_device *old_net;
 
 	if (size >= IFNAMSIZ)
 		return -EINVAL;
@@ -108,11 +213,12 @@ static ssize_t device_name_store(struct device *dev,
 
 	spin_lock_bh(&trigger_data->lock);
 
-	if (trigger_data->net_dev) {
-		dev_put(trigger_data->net_dev);
-		trigger_data->net_dev = NULL;
-	}
+	/* Backup old device name and save old net */
+	old_net = trigger_data->net_dev;
+	trigger_data->net_dev = NULL;
+	memcpy(old_device_name, trigger_data->device_name, IFNAMSIZ);
 
+	/* Set the new device name */
 	memcpy(trigger_data->device_name, buf, size);
 	trigger_data->device_name[size] = 0;
 	if (size > 0 && trigger_data->device_name[size - 1] == '\n')
@@ -122,6 +228,21 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev =
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old net_dev and device_name */
+		dev_put(trigger_data->net_dev);
+
+		/* Restore device settings */
+		trigger_data->net_dev = old_net;
+		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
+
+		spin_unlock_bh(&trigger_data->lock);
+		return -EINVAL;
+	}
+
+	/* Everything is ok. We can drop reference to the old net */
+	dev_put(old_net);
+
 	trigger_data->carrier_link_up = false;
 	if (trigger_data->net_dev != NULL)
 		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
@@ -159,7 +280,7 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	unsigned long state;
+	unsigned long state, old_mode = trigger_data->mode;
 	int ret;
 	int bit;
 
@@ -184,6 +305,12 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	else
 		clear_bit(bit, &trigger_data->mode);
 
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old mode on validation fail */
+		trigger_data->mode = old_mode;
+		return -EINVAL;
+	}
+
 	set_baseline_state(trigger_data);
 
 	return size;
@@ -220,6 +347,8 @@ static ssize_t interval_store(struct device *dev,
 			      size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	int old_interval = atomic_read(&trigger_data->interval);
+	u32 old_mode = trigger_data->mode;
 	unsigned long value;
 	int ret;
 
@@ -228,13 +357,26 @@ static ssize_t interval_store(struct device *dev,
 		return ret;
 
 	/* impose some basic bounds on the timer interval */
-	if (value >= 5 && value <= 10000) {
-		cancel_delayed_work_sync(&trigger_data->work);
+	if (value < 5 || value > 10000)
+		return -EINVAL;
+
+	/* With hw blink the blink interval is handled internally */
+	if (trigger_data->blink_mode == LED_BLINK_HW_CONTROLLED)
+		return -EINVAL;
+
+	cancel_delayed_work_sync(&trigger_data->work);
+
+	atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
 
-		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
-		set_baseline_state(trigger_data);	/* resets timer */
+	if (!validate_baseline_state(trigger_data)) {
+		/* Restore old interval on validation error */
+		atomic_set(&trigger_data->interval, old_interval);
+		trigger_data->mode = old_mode;
+		return -EINVAL;
 	}
 
+	set_baseline_state(trigger_data);	/* resets timer */
+
 	return size;
 }
 
@@ -368,13 +510,25 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	trigger_data->mode = 0;
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
 	trigger_data->last_activity = 0;
+	if (led_cdev->blink_mode != LED_BLINK_SW_CONTROLLED) {
+		/* With hw mode enabled reset any rule set by default */
+		if (led_cdev->hw_control_status(led_cdev)) {
+			rc = led_cdev->hw_control_configure(led_cdev, 0,
+							    LED_BLINK_HW_RESET);
+			if (rc)
+				goto err;
+		}
+	}
 
 	led_set_trigger_data(led_cdev, trigger_data);
 
 	rc = register_netdevice_notifier(&trigger_data->notifier);
 	if (rc)
-		kfree(trigger_data);
+		goto err;
 
+	return 0;
+err:
+	kfree(trigger_data);
 	return rc;
 }
 
@@ -394,6 +548,7 @@ static void netdev_trig_deactivate(struct led_classdev *led_cdev)
 
 static struct led_trigger netdev_led_trigger = {
 	.name = "netdev",
+	.supported_blink_modes = LED_TRIGGER_SWHW,
 	.activate = netdev_trig_activate,
 	.deactivate = netdev_trig_deactivate,
 	.groups = netdev_trig_groups,
-- 
2.38.1

