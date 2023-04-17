Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64A86E4CDA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjDQPWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjDQPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:10 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E377EFC;
        Mon, 17 Apr 2023 08:21:13 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so13286463wms.1;
        Mon, 17 Apr 2023 08:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744870; x=1684336870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0YYZ7SwCQ04rm/iigLtXpTTa80qoaqR0QMHYPp6JmVI=;
        b=OAf/1088HNqJXQAQBMzqSc1ifdu1eQ6Haa3qlu5QKk99xK7o3cV8+mmTw+1uswREy8
         crvqfFOU2F4w9oQorogwnEgaVPC1mmvRK5wciua+bJh36hwgCefw5mivrR99KcaI1yJV
         HW5JqbzE+O8fDDPMugVk+UUrGXR96hSWGfUd8fxr0IWdCJ6DzH479BNU1QMUB9+hQe1S
         MPNhB3RaKysqR9O6smvjwWZP+TGELyb6AyvPg1YYAxm3NM2EcEBdwCAYYg1DRc1ed/n7
         nDHYhZXtWX2Ncg3e4HhaouuhvBiPnyQaugI7uWS0EUJoz3BJ4gy3sKSSpK87UgA51PTH
         Dl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744870; x=1684336870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0YYZ7SwCQ04rm/iigLtXpTTa80qoaqR0QMHYPp6JmVI=;
        b=T69QKMfjj/6QzW/Qplm8NZitQBIsU/rXaNeHWCzV6GD/xlS9aAPw8IukIbG30WLsJj
         RIDLfSiXU401CJbNL7OYNGrG6rzfQ9LCbx1wIMH+trju7T1Sk93kweXEHjiRnpID6GkA
         NfWcUPmvxI5RSoNWWG4qMvpuzypDT1x6zAjS3LSYMMWbJiTn2PuuoJrd5fRyjNW1UOIP
         Nwq5l7KOaLFZCWrcoyLErHgiD2RX4gEOLBAfLEUi/Ib3CWh/ecLjlreVLrgnhtY85afN
         99qci7v60kVq2fAAhnQT4X6vyvucqg6l4qsaHuIWgYVW/KWPiRVqc2k2bnYx3YYgSIhn
         BsfQ==
X-Gm-Message-State: AAQBX9fu28yyPu3M9FiIhySRD3zK2MAZMU/zMf5TEXJmeanBHxZNfGlI
        2ebkWWsje3s3lWfppxKAOhA=
X-Google-Smtp-Source: AKy350bNkYePTpwHhda2y/bA29Ro7+vCA9c1Zxn6kPqkkwZZcHFgHxInUONl7Wn6rc1n6AS7ElEOrw==
X-Received: by 2002:a05:600c:ac8:b0:3f1:6fe2:c4b2 with SMTP id c8-20020a05600c0ac800b003f16fe2c4b2mr4085691wmr.23.1681744870027;
        Mon, 17 Apr 2023 08:21:10 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:03 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 08/16] net: phy: phy_device: Call into the PHY driver to set LED blinking
Date:   Mon, 17 Apr 2023 17:17:30 +0200
Message-Id: <20230417151738.19426-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Linux LEDs can be requested to perform hardware accelerated
blinking. Pass this to the PHY driver, if it implements the op.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 18 ++++++++++++++++++
 include/linux/phy.h          | 12 ++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5c1200160c51..538523a7cd51 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3005,6 +3005,22 @@ static int phy_led_set_brightness(struct led_classdev *led_cdev,
 	return err;
 }
 
+static int phy_led_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_blink_set(phydev, phyled->index,
+					 delay_on, delay_off);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
 static int of_phy_led(struct phy_device *phydev,
 		      struct device_node *led)
 {
@@ -3027,6 +3043,8 @@ static int of_phy_led(struct phy_device *phydev,
 
 	if (phydev->drv->led_brightness_set)
 		cdev->brightness_set_blocking = phy_led_set_brightness;
+	if (phydev->drv->led_blink_set)
+		cdev->blink_set = phy_led_blink_set;
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f3c7e3c99f24..c5a0dc829714 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1085,6 +1085,18 @@ struct phy_driver {
 	 */
 	int (*led_brightness_set)(struct phy_device *dev,
 				  u8 index, enum led_brightness value);
+
+	/**
+	 * @led_blink_set: Set a PHY LED brightness.  Index indicates
+	 * which of the PHYs led should be configured to blink. Delays
+	 * are in milliseconds and if both are zero then a sensible
+	 * default should be chosen.  The call should adjust the
+	 * timings in that case and if it can't match the values
+	 * specified exactly.
+	 */
+	int (*led_blink_set)(struct phy_device *dev, u8 index,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.39.2

