Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A2A6989F8
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBPBgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBPBgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:43 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4B5460A8;
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f23-20020a05600c491700b003dff4480a17so3255977wmp.1;
        Wed, 15 Feb 2023 17:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Emg45XsaXtug12JKPR+eF5BojCRRPqwZT9u/94eP10k=;
        b=DISZgrx6BCflOTggDTSc+82B6r5D4O9inMgejdTfDAERynqaLqtieqAbdGEIlC/442
         RL5ZcmRa0Yiq6HHRmtU/jzkOc9lo9rad6jSl0ZfyoSt6AFlfj/8jIF6sPUfgFcbzCXQm
         f9/9grXb68O+cQwLpEN59TJEN3KxGe2vW1OzcTWMYnSq+vXKuGXAFEX8m/c4F5BfrFnL
         N1HtHIqPN3CuHDgz9vDSqkwymhWImmYyJfiU+yPfDL/gPaknjSg7svVQpSRmnADQUqb5
         WtcKm5ZNw18PmtWnWDbd4k8jrgxa++2bO8lC7qA9xWsgXDDjS960v5lfpR8S4fWfCWdb
         V0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emg45XsaXtug12JKPR+eF5BojCRRPqwZT9u/94eP10k=;
        b=OYnV3aNb89OvjFIkAfEAPicYPNlaC4PsecLZf/CGZx2ndJBuiCKvm/IlBWa9kzeyxa
         DLh31O5D9amTu4egbYzfBQVnl5W6F3n1LaCBN/tfZREuqVHMHi9Ns72hPr7hNTpmyEFh
         sbmf68Yp80Hr6hoVz/D7dHaT38nW+S1jU3X7ryEJbde1W8+q2rP0bCduPT+4ptS+81YM
         NLTTpPFq87sgvusrw0ql8VVY1+H1C8wxJ0xfruIknN6YlXl0eB1JUVgjKSvxNtby21RV
         Qxn6QkfKuuiOGCzCLQpTpiVMzZMKEA4QL09kgviSeWTlaU3L1xOKR29CzRz7sHxOl0p7
         vOjw==
X-Gm-Message-State: AO0yUKUezpm0PrWCEOIhJw96n2fgarskWKCG9s8xGcFxWrjPNBwHfJQK
        yTCY/wYFKc2Mfi7Qp0mgvWU=
X-Google-Smtp-Source: AK7set8lGzEmrqhx8KiQzqZUxydMkwIXl10F0C4+Nsmrut5crIf08p4Xe/sgv0BsKFrW3H4phQ949A==
X-Received: by 2002:a05:600c:318f:b0:3df:e468:17dc with SMTP id s15-20020a05600c318f00b003dfe46817dcmr3383094wmp.40.1676511385969;
        Wed, 15 Feb 2023 17:36:25 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:25 -0800 (PST)
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
Subject: [PATCH v8 07/13] leds: trigger: netdev: use mutex instead of spinlocks
Date:   Thu, 16 Feb 2023 02:32:24 +0100
Message-Id: <20230216013230.22978-8-ansuelsmth@gmail.com>
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

Some LEDs may require to sleep to apply their hardware rules. Convert to
mutex lock to fix warning for sleeping under spinlock softirq.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d85be325e492..6dd04f4d70ea 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -20,7 +20,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/timer.h>
 #include "../leds.h"
 
@@ -40,7 +40,7 @@
 
 struct led_netdev_data {
 	enum led_blink_modes blink_mode;
-	spinlock_t lock;
+	struct mutex lock;
 
 	struct delayed_work work;
 	struct notifier_block notifier;
@@ -191,9 +191,9 @@ static ssize_t device_name_show(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	ssize_t len;
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 	len = sprintf(buf, "%s\n", trigger_data->device_name);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return len;
 }
@@ -211,7 +211,7 @@ static ssize_t device_name_store(struct device *dev,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	/* Backup old device name and save old net */
 	old_net = trigger_data->net_dev;
@@ -236,7 +236,7 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev = old_net;
 		memcpy(trigger_data->device_name, old_device_name, IFNAMSIZ);
 
-		spin_unlock_bh(&trigger_data->lock);
+		mutex_unlock(&trigger_data->lock);
 		return -EINVAL;
 	}
 
@@ -250,7 +250,7 @@ static ssize_t device_name_store(struct device *dev,
 	trigger_data->last_activity = 0;
 
 	set_baseline_state(trigger_data);
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return size;
 }
@@ -412,7 +412,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	cancel_delayed_work_sync(&trigger_data->work);
 
-	spin_lock_bh(&trigger_data->lock);
+	mutex_lock(&trigger_data->lock);
 
 	trigger_data->carrier_link_up = false;
 	switch (evt) {
@@ -435,7 +435,7 @@ static int netdev_trig_notify(struct notifier_block *nb,
 
 	set_baseline_state(trigger_data);
 
-	spin_unlock_bh(&trigger_data->lock);
+	mutex_unlock(&trigger_data->lock);
 
 	return NOTIFY_DONE;
 }
@@ -496,7 +496,7 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	if (!trigger_data)
 		return -ENOMEM;
 
-	spin_lock_init(&trigger_data->lock);
+	mutex_init(&trigger_data->lock);
 
 	trigger_data->notifier.notifier_call = netdev_trig_notify;
 	trigger_data->notifier.priority = 10;
-- 
2.38.1

