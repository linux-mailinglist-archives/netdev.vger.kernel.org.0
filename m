Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358F16BDEC2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCQCdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCQCda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:30 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FBC3B87F;
        Thu, 16 Mar 2023 19:33:27 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j42-20020a05600c1c2a00b003ed363619ddso2707955wms.1;
        Thu, 16 Mar 2023 19:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM3DoNMLu3F/k6wPO3qYiXVgdAsBr9H+lF3WwRw8JHY=;
        b=GI3I0nTOe0aBeLI0l3/lUpIAY7Pet947XD0nFynMbOz6OX8jfYop8gvJZHiLq1O3Xo
         rcHANTn9UTVOALoTXuXcKBprhvxFjsmTK3W72xmyTFGPfERQj6rg2Fz7N1I3iCG8a30e
         Gyz0o2jBWMN4XUnPY0qsSFkk8CogUxAZsdiIrl9ObI0TVov2j2i6l37Ftwtnjdl2s9ei
         6n/MEl+U4oEGOoygSea+KB9B9/7ccQYCNDBI5eXRQLyi1nPxMZ3voYJLEJnyrszEXhFX
         fHmHGKqsc4SM8MJo2Eu659xoog8RDZ+D5EuQ8mW+nSqjIORg/cbzza7H+xNx3Z0R+GR8
         KcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM3DoNMLu3F/k6wPO3qYiXVgdAsBr9H+lF3WwRw8JHY=;
        b=zVN5eh/GBboxcAoVfgZXCMPC0B1aTjPUug9af4qI76fsbSVZg2yiIhsYZOqF7G6oBc
         BUXdwGDByD8l60ALgbPQfueRWSMEgCL/MCI+uOO8U160ntaWvRocvkreL4MUK5Ui/iZO
         1oLCOaKRIiQa2VpLUG5DL5pv0fz30qIggLhAJXxQAMxpx21jraFR7NlapO+LxLWkuv7a
         4Fw3atNv6NwKWgx5pqppchvU77jCSlQNVsoroiJ5ah/EI0wRWKYSfj/tgkOoaOngs00Q
         RROWig2zgg0ZdXqegCJTWebPr/O18Nx/RM0++MiF6Ks8MBe4Ck/7bAJftwEoWV1iMztN
         KPeg==
X-Gm-Message-State: AO0yUKV0YTY8wsdXlNLIqsBPBR6E/NZkG5XKDAbzMIK808A+MAOv2ChA
        eiWAhk8RLlRTTH9wr7xjB74=
X-Google-Smtp-Source: AK7set8En2UX5kQiJ8dea62WOoksLYAyaSxUNMq66Q16vu1obaE5O124QZhmeoMBq8MFnUSQ1UeOsw==
X-Received: by 2002:a1c:f701:0:b0:3ed:809b:79ac with SMTP id v1-20020a1cf701000000b003ed809b79acmr405573wmh.19.1679020405234;
        Thu, 16 Mar 2023 19:33:25 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:24 -0700 (PDT)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Date:   Fri, 17 Mar 2023 03:31:15 +0100
Message-Id: <20230317023125.486-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

Define common binding parsing for all PHY drivers with LEDs using
phylib. Parse the DT as part of the phy_probe and add LEDs to the
linux LED class infrastructure. For the moment, provide a dummy
brightness function, which will later be replaced with a call into the
PHY driver.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/phy/Kconfig      |  1 +
 drivers/net/phy/phy_device.c | 75 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 16 ++++++++
 3 files changed, 92 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f5df2edc94a5..666efa6b1c8e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -16,6 +16,7 @@ config PHYLINK
 menuconfig PHYLIB
 	tristate "PHY Device support and infrastructure"
 	depends on NETDEVICES
+	depends on LEDS_CLASS
 	select MDIO_DEVICE
 	select MDIO_DEVRES
 	help
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9ba8f973f26f..ee800f93c8c3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -19,10 +19,12 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
@@ -658,6 +660,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
+	INIT_LIST_HEAD(&dev->leds);
 
 	mutex_init(&dev->lock);
 	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
@@ -2964,6 +2967,73 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/* Dummy implementation until calls into PHY driver are added */
+static int phy_led_set_brightness(struct led_classdev *led_cdev,
+				  enum led_brightness value)
+{
+	return 0;
+}
+
+static int of_phy_led(struct phy_device *phydev,
+		      struct device_node *led)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct led_init_data init_data = {};
+	struct led_classdev *cdev;
+	struct phy_led *phyled;
+	int err;
+
+	phyled = devm_kzalloc(dev, sizeof(*phyled), GFP_KERNEL);
+	if (!phyled)
+		return -ENOMEM;
+
+	cdev = &phyled->led_cdev;
+
+	err = of_property_read_u32(led, "reg", &phyled->index);
+	if (err)
+		return err;
+
+	cdev->brightness_set_blocking = phy_led_set_brightness;
+	cdev->max_brightness = 1;
+	init_data.devicename = dev_name(&phydev->mdio.dev);
+	init_data.fwnode = of_fwnode_handle(led);
+
+	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
+	if (err)
+		return err;
+
+	list_add(&phyled->list, &phydev->leds);
+
+	return 0;
+}
+
+static int of_phy_leds(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct device_node *leds, *led;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (!node)
+		return 0;
+
+	leds = of_get_child_by_name(node, "leds");
+	if (!leds)
+		return 0;
+
+	for_each_available_child_of_node(leds, led) {
+		err = of_phy_led(phydev, led);
+		if (err) {
+			of_node_put(led);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
  * @fwnode: pointer to the mdio_device's fwnode
@@ -3142,6 +3212,11 @@ static int phy_probe(struct device *dev)
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
+	/* Get the LEDs from the device tree, and instantiate standard
+	 * LEDs for them.
+	 */
+	err = of_phy_leds(phydev);
+
 out:
 	/* Assert the reset signal */
 	if (err)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fbeba4fee8d4..88a77ff60be9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
+#include <linux/leds.h>
 #include <linux/linkmode.h>
 #include <linux/netlink.h>
 #include <linux/mdio.h>
@@ -595,6 +596,7 @@ struct macsec_ops;
  * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
  * @led_link_trigger: LED trigger for link up/down
  * @last_triggered: last LED trigger for link speed
+ * @leds: list of PHY LED structures
  * @master_slave_set: User requested master/slave configuration
  * @master_slave_get: Current master/slave advertisement
  * @master_slave_state: Current master/slave configuration
@@ -690,6 +692,7 @@ struct phy_device {
 
 	struct phy_led_trigger *led_link_trigger;
 #endif
+	struct list_head leds;
 
 	/*
 	 * Interrupt number for this PHY
@@ -825,6 +828,19 @@ struct phy_plca_status {
 	bool pst;
 };
 
+/**
+ * struct phy_led: An LED driven by the PHY
+ *
+ * @list: List of LEDs
+ * @led_cdev: Standard LED class structure
+ * @index: Number of the LED
+ */
+struct phy_led {
+	struct list_head list;
+	struct led_classdev led_cdev;
+	u32 index;
+};
+
 /**
  * struct phy_driver - Driver structure for a particular PHY type
  *
-- 
2.39.2

