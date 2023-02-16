Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F9C6989F4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBPBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBPBgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC8942BE6;
        Wed, 15 Feb 2023 17:36:21 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so452729wmb.2;
        Wed, 15 Feb 2023 17:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLUjxnO2oij4OhBp9M0WGmuraYdVdBunDA6AnJELD5s=;
        b=YhbIoKaoSAQQg+5Y1FTs50x5i0/GhDoFVuxeGe9pdG5z9UuJdWe+98XHApZTFwBmfY
         n2FwhAcu8/WWmggdh1s5bzcv2J1YRr1C/iB8WwTEa6bSNhFQaclVEjRMr7o5n6lsWkI+
         Q/VhWlNUMxJxih85NyDL/7MEi5trwz1xtJZ0WdtiX4pOe6UKUxYJ8DLR3nWGBQCxdKwC
         1iYEeHb9l2U5kJrjIPJogdSahjVYgbo2ccMjQjlCpSqWM9KNy9gkEDkU0aZcl+dR/jPS
         yUYxWXN/+Krud81acrVRqYjJFO8g+RuKBK2MGeCMPwqCf6KvsGShcGkyO/hQaUssgVvy
         Tu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLUjxnO2oij4OhBp9M0WGmuraYdVdBunDA6AnJELD5s=;
        b=CUvUhUkmF/xlQnebZtl1jEbM22xxa3/5DCIA9AdbFHg1mRE+XUcEPpEjqAQU5aUN7Q
         4huoFi/60+qmev00RUYf1lnIWXuX5dPkFjkO3wBwQrhGuK8kSIaQdzIomrZ2lID8Reb+
         ekZd6QSWL4r6GqkbTm0fpyN95KrimRu6b69b5VSUfBJ1nWpmEEy+HfEI2w7Gj7VSftdE
         GPyDy7u0IfYYPJxXre89plOM6HoZ5d++rJ5yxpk2Q7MZfw8Q08E0jcjnky/cwaaz1epz
         ndROuITANig87Bogs0uZ3KRRr1RuVCrc1kaR3F9MmM23jogNezVW09AgyDIoDTm+O9hY
         3Hfg==
X-Gm-Message-State: AO0yUKWsGJCsSripW8+J2eADu1w0V+ja0g9sE8UyzWN0rxyLqvZVHuRC
        8U1cadBt4j5DBbtuwmThauk=
X-Google-Smtp-Source: AK7set/4Fjk6MqFb6N4r+YOX2UAjCiFVDG+2NZKe2UiYikgb9571oK4N13I7/2PNQuJ52M+YqqaUlw==
X-Received: by 2002:a05:600c:816:b0:3de:1d31:1043 with SMTP id k22-20020a05600c081600b003de1d311043mr3573991wmp.21.1676511380197;
        Wed, 15 Feb 2023 17:36:20 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:19 -0800 (PST)
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
Subject: [PATCH v8 03/13] leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
Date:   Thu, 16 Feb 2023 02:32:20 +0100
Message-Id: <20230216013230.22978-4-ansuelsmth@gmail.com>
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

Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
that will be true or false based on the carrier link. No functional
change intended.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..66a81cc9b64d 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -50,10 +50,10 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
+	bool carrier_link_up;
 #define NETDEV_LED_LINK	0
 #define NETDEV_LED_TX	1
 #define NETDEV_LED_RX	2
-#define NETDEV_LED_MODE_LINKUP	3
 };
 
 enum netdev_led_attr {
@@ -73,9 +73,9 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
+	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
-	else {
+	} else {
 		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
@@ -131,10 +131,9 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev =
 		    dev_get_by_name(&init_net, trigger_data->device_name);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->carrier_link_up = false;
 	if (trigger_data->net_dev != NULL)
-		if (netif_carrier_ok(trigger_data->net_dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		trigger_data->carrier_link_up = netif_carrier_ok(trigger_data->net_dev);
 
 	trigger_data->last_activity = 0;
 
@@ -315,7 +314,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	spin_lock_bh(&trigger_data->lock);
 
-	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+	trigger_data->carrier_link_up = false;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
 	case NETDEV_REGISTER:
@@ -330,8 +329,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		if (netif_carrier_ok(dev))
-			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		trigger_data->carrier_link_up = netif_carrier_ok(dev);
 		break;
 	}
 
-- 
2.38.1

