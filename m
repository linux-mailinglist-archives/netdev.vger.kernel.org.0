Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E017E30F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbfHATIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:08:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36576 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388398AbfHATIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:08:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so34714396pgm.3
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 12:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OVjdcXCPwuFsvnheb2FVh3Xzrvqr6Atdn2Iwx7oV+0=;
        b=Tg5UJX47uPAFj3X9l1nh1kTacYdQYspCbtB0tQ+L4p4sqSi1mcgIlqOMXWybeOWD8r
         WBGI54twdOSlHNtgdKgT1k9x3hZhXHHtR1ixan505WuTw+8t1taQ/fAPr9pSEPBv9H47
         AUQ8EYiEi7lbcdm/ZCCIv7ECf0bcU7CUko1dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OVjdcXCPwuFsvnheb2FVh3Xzrvqr6Atdn2Iwx7oV+0=;
        b=bq+yQguOiYgl2iluqAaekQO8EemKxg0y2lIq9phXC3d9SwVHwebj1JzmEJA6nNFytz
         a5tAOop+8ER0+u7KjnoS5APoNAzKiCsFXGN0FBG7i8Edd8t4H4ph6Ur0ToWJjUUckcor
         qGq10mM8wAaMAjUcZb8eqoKGUC04Z43MlxwcwF4XpXDth4zfbHs0m4Yje5NixuOsOZZl
         PH1lBoh1Mm+wfqBZzRzRZ351wmxBg4pnzo8IXHt+P51ODxhjljCVyNRYqmyAxLwhGxIz
         EM88rqosoKHy2k+WqQMfaB8Wq1E9GXHUGmfDWnmO1DyZFcZ9Na4JcdKLLxd3Vt9PnrT0
         CVpQ==
X-Gm-Message-State: APjAAAWCPpU22fRDWQoTxHY1Rhvy2jOukuUB7Lcvtfkmq81FZmI8OuK4
        6Pn15eSZtJbw3JMBzR6OEJ6dlg==
X-Google-Smtp-Source: APXvYqySqv4UWFLApIVrgFow3MNR0qCXgidPdh04SBiV2KFLAPagBOPHeNSxD7x8jsrFtFme+4yWWg==
X-Received: by 2002:a17:90a:350c:: with SMTP id q12mr334860pjb.46.1564686486184;
        Thu, 01 Aug 2019 12:08:06 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e13sm91452970pff.45.2019.08.01.12.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:08:05 -0700 (PDT)
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
Subject: [PATCH v4 2/4] net: phy: Add function to retrieve LED configuration from the DT
Date:   Thu,  1 Aug 2019 12:07:57 -0700
Message-Id: <20190801190759.28201-3-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190801190759.28201-1-mka@chromium.org>
References: <20190801190759.28201-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a phylib function for retrieving PHY LED configuration that
is specified in the device tree using the generic binding. LEDs
can be configured to be 'on' for a certain link speed or to blink
when there is TX/RX activity.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v4:
- patch added to the series
---
 drivers/net/phy/phy_device.c | 50 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 15 +++++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6b5cb87f3866..b4b48de45712 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2188,6 +2188,56 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->ack_interrupt;
 }
 
+int of_get_phy_led_cfg(struct phy_device *phydev, int led,
+		       struct phy_led_config *cfg)
+{
+	struct device_node *np, *child;
+	const char *trigger;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return -ENOENT;
+
+	np = of_find_node_by_name(phydev->mdio.dev.of_node, "leds");
+	if (!np)
+		return -ENOENT;
+
+	for_each_child_of_node(np, child) {
+		u32 val;
+
+		if (!of_property_read_u32(child, "reg", &val)) {
+			if (val == (u32)led)
+				break;
+		}
+	}
+
+	if (!child)
+		return -ENOENT;
+
+	ret = of_property_read_string(child, "linux,default-trigger",
+				      &trigger);
+	if (ret)
+		return ret;
+
+	if (!strcmp(trigger, "phy_link_10m_active")) {
+		cfg->trigger = PHY_LED_LINK_10M;
+	} else if (!strcmp(trigger, "phy_link_100m_active")) {
+		cfg->trigger = PHY_LED_LINK_100M;
+	} else if (!strcmp(trigger, "phy_link_1g_active")) {
+		cfg->trigger = PHY_LED_LINK_1G;
+	} else if (!strcmp(trigger, "phy_link_10g_active")) {
+		cfg->trigger = PHY_LED_LINK_10G;
+	}  else if (!strcmp(trigger, "phy_activity")) {
+		cfg->trigger = PHY_LED_ACTIVITY;
+	} else {
+		phydev_warn(phydev, "trigger '%s' for LED%d is invalid\n",
+			    trigger, led);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 462b90b73f93..b4693415be31 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1176,6 +1176,21 @@ int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
 
+enum phy_led_trigger {
+	PHY_LED_LINK_10M,
+	PHY_LED_LINK_100M,
+	PHY_LED_LINK_1G,
+	PHY_LED_LINK_10G,
+	PHY_LED_ACTIVITY,
+};
+
+struct phy_led_config {
+	enum phy_led_trigger trigger;
+};
+
+int of_get_phy_led_cfg(struct phy_device *phydev, int led,
+		       struct phy_led_config *cfg);
+
 #if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-- 
2.22.0.770.g0f2c4a37fd-goog

