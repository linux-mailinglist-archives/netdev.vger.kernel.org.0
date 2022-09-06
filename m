Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08485AF653
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIFUtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiIFUt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:49:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD68F4F;
        Tue,  6 Sep 2022 13:49:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v5so12446556plo.9;
        Tue, 06 Sep 2022 13:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ezx5JxGhsyYC+yP3MEYLgoFlyhvMPcG49uTzbCjAwnc=;
        b=aWfALvi5zcPKF/wB5z5teeb6d4zqa7DUZdEcSXz5lGS5XcoAapeYwzldvGDu0P/tf7
         jabJJFWI32vmzK/WxYMEJ7pzAAFecjis5JlpcIkUplX1J07NfseG+LAFfcdUNPK4+i1m
         9u2gp8EATUhokT74/Jf+FefpHOESfV2yb0jBMe0Zc8HIzFU9kMAQY5tTujSmyROs/LK1
         sGTEHZYvTUOHSdTJmOEMiLnPEvroBPK8kbLKOEvNerUlHXYqJsHLdOv8PIiVkL1J1sJH
         SV5NrAygePGoNmQDkIWNZhhH57o7e0LLo5ErlCs0oWbjyMC6CzmF3TPtWCnsD+kRZ1PL
         +Yhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ezx5JxGhsyYC+yP3MEYLgoFlyhvMPcG49uTzbCjAwnc=;
        b=Is4d/wmHMBMmH2cL4hf939n/AGnM7qkZRHijdz5hxcENVWIl10jFgFVLSoO44jJPFF
         7VtZbQfJ1XC6UQfmc7HwyJvq7Pvna46KisXq1PvNibkHxnMiNDWPsMiU1nvQ1hv5Jfqn
         GXSWMejR9KBKWbXjHA+6CUL0bYqV/KUo/0n9nkVI5nXOsnOj/CwMaoTRgElXlam2H7m9
         5ead/a8L+ifj4FU96cfvvZYApBPquZi82gbaIZKNiVbP4YB4qk00IelwRwLNitFgBA0Y
         YdidfvBTLg7ucCgtbtIWgBMkkWPR1+m6L8MVL4Is4COly48kERPlB9LUNr2Pt7E6EMEW
         Nz5w==
X-Gm-Message-State: ACgBeo3OT/I/jjP2fzlepd7EoCWHZ4co3yLKHPMk9r7D1npjDBnWmXPN
        cu9jNDmpsHHV/t1RCEhR8/Y=
X-Google-Smtp-Source: AA6agR4oJt5HM1LY2n980dXQKzU0ApWQ9A116cH4nI3ede1BKIE7s43W35ADcfrm+irY+R6MUDPCwQ==
X-Received: by 2002:a17:90a:70cb:b0:200:2849:41b7 with SMTP id a11-20020a17090a70cb00b00200284941b7mr245931pjm.108.1662497365992;
        Tue, 06 Sep 2022 13:49:25 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:abc4:5d24:5a73:a96b])
        by smtp.gmail.com with ESMTPSA id e6-20020a656886000000b00434e2e1a82bsm61664pgt.66.2022.09.06.13.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:49:25 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: ks8851: switch to using gpiod API
Date:   Tue,  6 Sep 2022 13:49:21 -0700
Message-Id: <20220906204922.3789922-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch switches the driver away from legacy gpio/of_gpio API to
gpiod API, and removes use of of_get_named_gpio_flags() which I want to
make private to gpiolib.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/net/ethernet/micrel/ks8851.h        |  2 +-
 drivers/net/ethernet/micrel/ks8851_common.c | 40 ++++++++++-----------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.h b/drivers/net/ethernet/micrel/ks8851.h
index 6f34a61739b6..fecd43754cea 100644
--- a/drivers/net/ethernet/micrel/ks8851.h
+++ b/drivers/net/ethernet/micrel/ks8851.h
@@ -403,7 +403,7 @@ struct ks8851_net {
 	struct eeprom_93cx6	eeprom;
 	struct regulator	*vdd_reg;
 	struct regulator	*vdd_io;
-	int			gpio;
+	struct gpio_desc	*gpio;
 	struct mii_bus		*mii_bus;
 
 	void			(*lock)(struct ks8851_net *ks,
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index ec8457e61b45..cfbc900d4aeb 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -17,10 +17,9 @@
 #include <linux/cache.h>
 #include <linux/crc32.h>
 #include <linux/mii.h>
+#include <linux/gpio/consumer.h>
 #include <linux/regulator/consumer.h>
 
-#include <linux/gpio.h>
-#include <linux/of_gpio.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 
@@ -1117,24 +1116,23 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 {
 	struct ks8851_net *ks = netdev_priv(netdev);
 	unsigned cider;
-	int gpio;
 	int ret;
 
 	ks->netdev = netdev;
 	ks->tx_space = 6144;
 
-	gpio = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0, NULL);
-	if (gpio == -EPROBE_DEFER)
-		return gpio;
-
-	ks->gpio = gpio;
-	if (gpio_is_valid(gpio)) {
-		ret = devm_gpio_request_one(dev, gpio,
-					    GPIOF_OUT_INIT_LOW, "ks8851_rst_n");
-		if (ret) {
-			dev_err(dev, "reset gpio request failed\n");
-			return ret;
-		}
+	ks->gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	ret = PTR_ERR_OR_ZERO(ks->gpio);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "reset gpio request failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = gpiod_set_consumer_name(ks->gpio, "ks8851_rst_n");
+	if (ret) {
+		dev_err(dev, "failed to set reset gpio name: %d\n", ret);
+		return ret;
 	}
 
 	ks->vdd_io = devm_regulator_get(dev, "vdd-io");
@@ -1161,9 +1159,9 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 		goto err_reg;
 	}
 
-	if (gpio_is_valid(gpio)) {
+	if (ks->gpio) {
 		usleep_range(10000, 11000);
-		gpio_set_value(gpio, 1);
+		gpiod_set_value_cansleep(ks->gpio, 0);
 	}
 
 	spin_lock_init(&ks->statelock);
@@ -1239,8 +1237,8 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 err_id:
 	ks8851_unregister_mdiobus(ks);
 err_mdio:
-	if (gpio_is_valid(gpio))
-		gpio_set_value(gpio, 0);
+	if (ks->gpio)
+		gpiod_set_value_cansleep(ks->gpio, 1);
 	regulator_disable(ks->vdd_reg);
 err_reg:
 	regulator_disable(ks->vdd_io);
@@ -1259,8 +1257,8 @@ void ks8851_remove_common(struct device *dev)
 		dev_info(dev, "remove\n");
 
 	unregister_netdev(priv->netdev);
-	if (gpio_is_valid(priv->gpio))
-		gpio_set_value(priv->gpio, 0);
+	if (priv->gpio)
+		gpiod_set_value_cansleep(priv->gpio, 1);
 	regulator_disable(priv->vdd_reg);
 	regulator_disable(priv->vdd_io);
 }
-- 
2.37.2.789.g6183377224-goog

