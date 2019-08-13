Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC958C149
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfHMTMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:12:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33271 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfHMTL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:11:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so49570997plo.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 12:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf+xGPCkE88V8f+N3LFOWyEFFd8oY99DHKFNSz59Vzc=;
        b=W2aKmxcSCRDgnJ5yif0VeFy5UM0A2nMLW8Ww4W+za6uQAEK6a6ecgN6WtgatGIHIuK
         fS0RqyQOCTSKVi3s01NkESYy5JI/R/drXDnVwVHmONwTD/jRtYjmHd4dP3ZrxZzy6T8z
         ui5KNy/2buIYOx4CJm1A2CPuWWpJKlLcIDmW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf+xGPCkE88V8f+N3LFOWyEFFd8oY99DHKFNSz59Vzc=;
        b=taab9mi1lfU2v1UW/9gRyu3WHNUfSd2UlkTNhK/ZnT/KdE/DQqjPX0WEjcI+Nlu1eB
         r8eWEkzLtMk0Z7bpKdYXbIJNU1L+ZD203yOOMg5sNKb0pwg96IN4UFUMyqOKgRtNRHKZ
         nkTQAhcDJFMIsUulyABoQGAZenhmY5Ko74Y6LXVr0+23G6J0BqYjtiaPtrcvO78TdCn2
         7tv8vk+xLMQpUvb/tOpIyzu7R4aG5RI5x8EjKXc+wNnHLMaRkm9P7tUNfrb1Ji0Jq3je
         ychCsGyv/x5NOw5h5lFP04k2vW5kTkDZZUl7KcE1Fv/KiS/RK+Kk/RLOkm5GPa+p+g1Y
         V55g==
X-Gm-Message-State: APjAAAVubJi3CcJOyg8kRZpkZKb7vdfEiHY+Wgd+adibIMJtilYRs0RB
        VPsJgwSvmZT/VvlJ9EmEDizXMg==
X-Google-Smtp-Source: APXvYqyV3re8AhD0pKkRI8gLv84rBCbOMKsMXNv3ANRPsZAt47VPftjglh04U0u15HLfgoW5U0dIUw==
X-Received: by 2002:a17:902:b090:: with SMTP id p16mr17834984plr.93.1565723518007;
        Tue, 13 Aug 2019 12:11:58 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p8sm10245846pfq.129.2019.08.13.12.11.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 12:11:57 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v6 2/4] net: phy: Add support for generic LED configuration through the DT
Date:   Tue, 13 Aug 2019 12:11:45 -0700
Message-Id: <20190813191147.19936-3-mka@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190813191147.19936-1-mka@chromium.org>
References: <20190813191147.19936-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For PHYs with a device tree node look for LED trigger configuration
using the generic binding, if it exists try to apply it via the new
driver hook .config_led.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v6:
- delete unnecessary of_node_put() inside for_each_child_of_node()
  loop
- use continue instead of goto in of_phy_config_leds()
- check return value of ->config_led() and print a warning if !0

Changes in v5:
- add callback to configure a LED to the PHY driver, instead of
  having the driver retrieve the DT data
- use new trigger names
- added support for trigger 'none'
- release DT nodes after use
- renamed 'PHY_LED_LINK_*' to 'PHY_LED_TRIGGER_LINK_*'
- added anonymous struct to struct phy_led_config to track
  'activity' in a separate flag. this could be changed to 'flags' if
  needed/desired.
- updated commit message (previous subject was 'net: phy: Add
  function to retrieve LED configuration from the DT')

Changes in v4:
- patch added to the series
---
 drivers/net/phy/phy_device.c | 72 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 22 +++++++++++
 2 files changed, 94 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b5cb87f3866..80315777ae67 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -29,6 +29,7 @@
 #include <linux/phy_led_triggers.h>
 #include <linux/mdio.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("PHY library");
@@ -1064,6 +1065,75 @@ static int phy_poll_reset(struct phy_device *phydev)
 	return 0;
 }
 
+static void of_phy_config_leds(struct phy_device *phydev)
+{
+	struct device_node *np, *child;
+	struct phy_led_config cfg;
+	const char *trigger;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO) || !phydev->drv->config_led)
+		return;
+
+	np = of_find_node_by_name(phydev->mdio.dev.of_node, "leds");
+	if (!np)
+		return;
+
+	for_each_child_of_node(np, child) {
+		u32 led;
+
+		if (of_property_read_u32(child, "reg", &led))
+			continue;
+
+		ret = of_property_read_string(child, "linux,default-trigger",
+					      &trigger);
+		if (ret)
+			trigger = "none";
+
+		memset(&cfg, 0, sizeof(cfg));
+
+		if (!strcmp(trigger, "none")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_NONE;
+		} else if (!strcmp(trigger, "phy-link")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK;
+		} else if (!strcmp(trigger, "phy-link-10m")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10M;
+		} else if (!strcmp(trigger, "phy-link-100m")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_100M;
+		} else if (!strcmp(trigger, "phy-link-1g")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_1G;
+		} else if (!strcmp(trigger, "phy-link-10g")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10G;
+		} else if (!strcmp(trigger, "phy-link-activity")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK;
+			cfg.trigger.activity = true;
+		} else if (!strcmp(trigger, "phy-link-10m-activity")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10M;
+			cfg.trigger.activity = true;
+		} else if (!strcmp(trigger, "phy-link-100m-activity")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_100M;
+			cfg.trigger.activity = true;
+		} else if (!strcmp(trigger, "phy-link-1g-activity")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_1G;
+			cfg.trigger.activity = true;
+		} else if (!strcmp(trigger, "phy-link-10g-activity")) {
+			cfg.trigger.t = PHY_LED_TRIGGER_LINK_10G;
+			cfg.trigger.activity = true;
+		} else {
+			phydev_warn(phydev, "trigger '%s' for LED%d is invalid\n",
+				    trigger, led);
+			continue;
+		}
+
+		ret = phydev->drv->config_led(phydev, led, &cfg);
+		if (ret)
+			phydev_warn(phydev, "trigger '%s' for LED%d not supported\n",
+				    trigger, led);
+	}
+
+	of_node_put(np);
+}
+
 int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
@@ -1087,6 +1157,8 @@ int phy_init_hw(struct phy_device *phydev)
 	if (phydev->drv->config_init)
 		ret = phydev->drv->config_init(phydev);
 
+	of_phy_config_leds(phydev);
+
 	return ret;
 }
 EXPORT_SYMBOL(phy_init_hw);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 462b90b73f93..3a07390fc5e9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -325,6 +325,24 @@ struct phy_c45_device_ids {
 	u32 device_ids[8];
 };
 
+/* Triggers for PHY LEDs */
+enum phy_led_trigger {
+	PHY_LED_TRIGGER_NONE,
+	PHY_LED_TRIGGER_LINK,
+	PHY_LED_TRIGGER_LINK_10M,
+	PHY_LED_TRIGGER_LINK_100M,
+	PHY_LED_TRIGGER_LINK_1G,
+	PHY_LED_TRIGGER_LINK_10G,
+};
+
+/* Configuration of a single PHY LED */
+struct phy_led_config {
+	struct {
+		enum phy_led_trigger t;
+		bool activity;
+	} trigger;
+};
+
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
@@ -626,6 +644,10 @@ struct phy_driver {
 			    struct ethtool_tunable *tuna,
 			    const void *data);
 	int (*set_loopback)(struct phy_device *dev, bool enable);
+
+	/* Configure a PHY LED */
+	int (*config_led)(struct phy_device *dev, int led,
+			  struct phy_led_config *cfg);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.23.0.rc1.153.gdeed80330f-goog

