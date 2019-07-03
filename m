Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9F85ECE9
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfGCTiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:38:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45860 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfGCThd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so1752122plb.12
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ObSoOwNahBPZUZYDMVvW9w2T4Vm1rMQuDVX+x2QRuQo=;
        b=hwhxF63MuuOC2Tg5Ij0XJc1BOjuLS3H1pZ9vIY7+quYs6/a6IQjHwIGD1C8K0i80vL
         mRIk185e4fOw7Q6TTbZZCS6Jz3vWOCDim9FGNYF+qpD4SI5mI/HgwNKKhc99RkOWbYkj
         Q3zW54bVLpAXPtabPYuHuZ4DCV4On86ziLCUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ObSoOwNahBPZUZYDMVvW9w2T4Vm1rMQuDVX+x2QRuQo=;
        b=bHb/GKWaPRQgcHikqQdoChZeUnWUqZC0isjDfnVZr4h9J1qdKvyiJ+vaOCVxxL4xNC
         ZIYuQh1/4IFRaIqRM4tqUgI+IFzsuQaMG1fctmxRwYzXeFjKJhhiVvs5rnE3uIGe0XsT
         sM0Lu0wJllB/t6BGK4/ak4YsZzUMbfyGFDNQZzaM3UZnEFE7/7x0fCaCxkM9SItYiyqd
         8/PuUjkcakoLXGk1Sl4/3CoSZbomKdPgt1WEDvjMOau/zlwLnqhpwtHn3XI1gnVZbb3Q
         DqUdsQnyhy20EUaiuq+EnvEwgbNuxyUFoZ+9LVsQvLevy5yn82T8jq0U5XSuiZpIXPxQ
         kGtA==
X-Gm-Message-State: APjAAAWUr3jSf/H6xSpAPL57Vi8dO27KLBZ7NxIKqi1yf+t5yzcwkBSq
        I8AERGpc5Z1dzgSP4YZokwe/NQ==
X-Google-Smtp-Source: APXvYqw3Zj0mT7dJn2Ndzj1lmhsUKhu6oRQ6geSA1HhEXIWu/OaROx9rokVkGZb/FvDnGOIBBcWE9g==
X-Received: by 2002:a17:902:2e81:: with SMTP id r1mr44727474plb.0.1562182652424;
        Wed, 03 Jul 2019 12:37:32 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id h18sm5119014pfr.75.2019.07.03.12.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:32 -0700 (PDT)
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
Subject: [PATCH v2 2/7] net: phy: realtek: Allow disabling RTL8211E EEE LED mode
Date:   Wed,  3 Jul 2019 12:37:19 -0700
Message-Id: <20190703193724.246854-2-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE LED mode is enabled by default on the RTL8211E. Disable it when
the device tree property 'realtek,eee-led-mode-disable' exists.

The magic values to disable EEE LED mode were taken from the RTL8211E
datasheet, unfortunately they are not further documented.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- patch added to the series
---
 drivers/net/phy/realtek.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb829..eb815cbe1e72 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,8 +9,9 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
-#include <linux/phy.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -26,6 +27,10 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+/* RTL8211E page 5 */
+#define RTL8211E_EEE_LED_MODE1			0x05
+#define RTL8211E_EEE_LED_MODE2			0x06
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -53,6 +58,35 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
+{
+	int ret = 0;
+	int oldpage;
+
+	oldpage = phy_select_page(phydev, 5);
+	if (oldpage < 0)
+		goto out;
+
+	/* write magic values to disable EEE LED mode */
+	ret = __phy_write(phydev, RTL8211E_EEE_LED_MODE1, 0x8b82);
+	if (ret)
+		goto out;
+
+	ret = __phy_write(phydev, RTL8211E_EEE_LED_MODE2, 0x052b);
+
+out:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static int rtl8211e_config_init(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+
+	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
+		rtl8211e_disable_eee_led_mode(phydev);
+
+	return 0;
+}
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -310,6 +344,7 @@ static struct phy_driver realtek_drvs[] = {
 		.name		= "RTL8211E Gigabit Ethernet",
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
+		.config_init	= &rtl8211e_config_init,
 		.config_intr	= &rtl8211e_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
-- 
2.22.0.410.gd8fdbe21b5-goog

