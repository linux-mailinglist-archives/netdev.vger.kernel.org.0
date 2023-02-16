Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618F16989F5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBPBgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBPBgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:24 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F4645F59;
        Wed, 15 Feb 2023 17:36:22 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso433103wms.4;
        Wed, 15 Feb 2023 17:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsNctLKC2ZYWHMMx8Al2bXYZJ6p8YrBC+LD3cRvN9GI=;
        b=nENG8ceOVhAZUJewR/tmeUy+LmnLxGY1L0BllbpKxbI+XjlsmBil7tteYMAfW9r2Ux
         vgKKyX+j8PUNcvKa3F/CiKtdgHPahjhTRH86R3X3QWPxRg8w5tVOJRpeehhBd+PB1xi6
         B2kCIG4NutlMmW7s4jpvbAJAoAF035fYX18TsmGHPeEwZPjDD4pq5V7ZRZCCgWwLZZIJ
         3YDXbgQLabZCeEJK2z53Z012EmN8WhqqNYE+buIzgrVkYVN1MQj9oPQOE+N9TQzxY989
         4KCD/D6zsdzEWhW6DeKFAuzMheUIQuS9In/W8fFm+kNvpl7bHrS2u9k8KEPpaODxycRk
         TfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsNctLKC2ZYWHMMx8Al2bXYZJ6p8YrBC+LD3cRvN9GI=;
        b=w63Dlk0rw+hybqCrXbJmZk3zGPYdpbnk2ihLnV453SWZaA18dVQNKU9kPWRD3Q/6Mc
         HakUWynXtI9XJmKiJobnE9zBTbtbMg3ELjrL+7VByx5zG317NeUIMz/Fg1esg4OSFCaZ
         dkL4US7i5n7H8qiL+1GmmbEgPedvl4WgY/1Xdg6dZfv+TzqaaDAghuJq2avyDD5OcQQc
         jDQgt0Cl4xUkSBGFdpb8yVREbpHkvJzWZdKSZfaAuDgBfy0fJvVq/ZJuU8ypHl4m+bUC
         WuFeNCxUJBvGaYhJ3hfSkyqDFw7b4bLADD3VxtFbiqk1GVkemlfFpkQGv73ihEathz7Y
         ZftA==
X-Gm-Message-State: AO0yUKXSjT/KIZYrfUvDqrBgH8wEiL5xvny4xx1v9KXeK3KtRUhd9Q/E
        5aEa5tUgFJavAmTGw5iqr8I=
X-Google-Smtp-Source: AK7set8hToIouIzfFiZh790fyd4lbNu7ntR/g/k6PTd+0LfSxVXOkYTXysoqkSTZwCIGcpeuNyMi4Q==
X-Received: by 2002:a05:600c:3317:b0:3dc:4318:d00d with SMTP id q23-20020a05600c331700b003dc4318d00dmr3643486wmp.11.1676511381604;
        Wed, 15 Feb 2023 17:36:21 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:21 -0800 (PST)
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
Subject: [PATCH v8 04/13] leds: trigger: netdev: rename and expose NETDEV trigger enum modes
Date:   Thu, 16 Feb 2023 02:32:21 +0100
Message-Id: <20230216013230.22978-5-ansuelsmth@gmail.com>
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

Rename NETDEV trigger enum modes to a more symbolic name and move them
in leds.h to make them accessible by any user.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 53 +++++++++------------------
 include/linux/leds.h                  |  7 ++++
 2 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 66a81cc9b64d..6872da08676b 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -51,15 +51,6 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	bool carrier_link_up;
-#define NETDEV_LED_LINK	0
-#define NETDEV_LED_TX	1
-#define NETDEV_LED_RX	2
-};
-
-enum netdev_led_attr {
-	NETDEV_ATTR_LINK,
-	NETDEV_ATTR_TX,
-	NETDEV_ATTR_RX
 };
 
 static void set_baseline_state(struct led_netdev_data *trigger_data)
@@ -76,7 +67,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!trigger_data->carrier_link_up) {
 		led_set_brightness(led_cdev, LED_OFF);
 	} else {
-		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
 		else
@@ -85,8 +76,8 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 		/* If we are looking for RX/TX start periodically
 		 * checking stats
 		 */
-		if (test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
-		    test_bit(NETDEV_LED_RX, &trigger_data->mode))
+		if (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ||
+		    test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
 			schedule_delayed_work(&trigger_data->work, 0);
 	}
 }
@@ -146,20 +137,16 @@ static ssize_t device_name_store(struct device *dev,
 static DEVICE_ATTR_RW(device_name);
 
 static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
-	enum netdev_led_attr attr)
+				    enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	int bit;
 
 	switch (attr) {
-	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
-		break;
-	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
-		break;
-	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_TX:
+	case TRIGGER_NETDEV_RX:
+		bit = attr;
 		break;
 	default:
 		return -EINVAL;
@@ -169,7 +156,7 @@ static ssize_t netdev_led_attr_show(struct device *dev, char *buf,
 }
 
 static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
-	size_t size, enum netdev_led_attr attr)
+				     size_t size, enum led_trigger_netdev_modes attr)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	unsigned long state;
@@ -181,14 +168,10 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 		return ret;
 
 	switch (attr) {
-	case NETDEV_ATTR_LINK:
-		bit = NETDEV_LED_LINK;
-		break;
-	case NETDEV_ATTR_TX:
-		bit = NETDEV_LED_TX;
-		break;
-	case NETDEV_ATTR_RX:
-		bit = NETDEV_LED_RX;
+	case TRIGGER_NETDEV_LINK:
+	case TRIGGER_NETDEV_TX:
+	case TRIGGER_NETDEV_RX:
+		bit = attr;
 		break;
 	default:
 		return -EINVAL;
@@ -358,21 +341,21 @@ static void netdev_trig_work(struct work_struct *work)
 	}
 
 	/* If we are not looking for RX/TX then return  */
-	if (!test_bit(NETDEV_LED_TX, &trigger_data->mode) &&
-	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
+	if (!test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) &&
+	    !test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode))
 		return;
 
 	dev_stats = dev_get_stats(trigger_data->net_dev, &temp);
 	new_activity =
-	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
+	    (test_bit(TRIGGER_NETDEV_TX, &trigger_data->mode) ?
 		dev_stats->tx_packets : 0) +
-	    (test_bit(NETDEV_LED_RX, &trigger_data->mode) ?
+	    (test_bit(TRIGGER_NETDEV_RX, &trigger_data->mode) ?
 		dev_stats->rx_packets : 0);
 
 	if (trigger_data->last_activity != new_activity) {
 		led_stop_software_blink(trigger_data->led_cdev);
 
-		invert = test_bit(NETDEV_LED_LINK, &trigger_data->mode);
+		invert = test_bit(TRIGGER_NETDEV_LINK, &trigger_data->mode);
 		interval = jiffies_to_msecs(
 				atomic_read(&trigger_data->interval));
 		/* base state is ON (link present) */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index c25558ca5f85..a31f158e5351 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -571,6 +571,13 @@ static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
 
 #endif /* CONFIG_LEDS_TRIGGERS */
 
+/* Trigger specific enum */
+enum led_trigger_netdev_modes {
+	TRIGGER_NETDEV_LINK = 1,
+	TRIGGER_NETDEV_TX,
+	TRIGGER_NETDEV_RX,
+};
+
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_DISK
 void ledtrig_disk_activity(bool write);
-- 
2.38.1

