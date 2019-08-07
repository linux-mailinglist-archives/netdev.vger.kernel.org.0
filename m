Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67151851AA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbfHGRFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:05:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38953 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389098AbfHGRFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:05:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so41778373pls.6
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 10:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F05sSw+VU0rzfotLUa63CaEZrG4zRotAGf06tMo1VOA=;
        b=CILuo5aN5ze70zh0vx+6Fq1nBx4l3fKH9UuBHDcGkUCVbReGgGxbo+EdkpPGO6j3ZQ
         ta4pS+7RkafrHrIfo3FGKp8czso9b5x96PJDnJXJytYIl0OqGJ9B4c2izWWLgDlVS3xM
         kyp/ofSmi0YIGpTra9+lklFtYk0129Y3msfvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F05sSw+VU0rzfotLUa63CaEZrG4zRotAGf06tMo1VOA=;
        b=Pzugm+CBLWaAaXQll2KX8AsYQPimRnLy0jUvfYtw4VKZCOkdvpwcF2+RjwSlT+EAAz
         biN4IHe5EbSYGy7jWysKJ2LaFM0tY/FUlZ6VvOMYZG/qmI6Kd9CQQe6qByFyjdbg6pxq
         sxJ5hd7HC9DCwyrT6bwVnlFJZ8bM3ywRkST6fOVSD0IGBdudXHIQi1UeJTTU9sb1gdSs
         fDCsTuRlCMi5rpPqY/l1DzP9FRUPdOY57g/MTU/AJTvJH3IHjynElpX5Yd/ybQMrrgYL
         8XyJmt8nVg9FxUfNW0uHhRVuyycsW4b6jMKu0hgzV/YoJQNEvH6C2Gf3o0I2ovWURfPh
         0QiQ==
X-Gm-Message-State: APjAAAX3F9gcpVXWb0gXStzHdb+Vm50JbpTZMGCbG3YwsiWpS9j66rND
        00aJSNML5HYiajkHxRkLVH2ueg==
X-Google-Smtp-Source: APXvYqwgcc3C5NzP6jD3BBlTrI++ipIvh7bo9B/KWKG1JIar6fhOBH/BZgx5rti7q7QBIS6lVXbmaw==
X-Received: by 2002:aa7:843c:: with SMTP id q28mr10527500pfn.152.1565197503725;
        Wed, 07 Aug 2019 10:05:03 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id m101sm834281pjb.7.2019.08.07.10.05.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:05:03 -0700 (PDT)
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
Subject: [PATCH v5 4/4] net: phy: realtek: Add LED configuration support for RTL8211E
Date:   Wed,  7 Aug 2019 10:04:49 -0700
Message-Id: <20190807170449.205378-5-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190807170449.205378-1-mka@chromium.org>
References: <20190807170449.205378-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a .config_led hook which is called by the PHY core when
configuration data for a PHY LED is available. Each LED can be
configured to be solid 'off, solid 'on' for certain (or all)
link speeds or to blink on RX/TX activity.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v5:
- use 'config_leds' driver callback instead of requesting the DT
  configuration
- added support for trigger 'none'
- always disable EEE LED mode when a LED is configured. We have no
  device data struct to keep track of its state, the number of LEDs
  is limited, so the overhead of disabling it multiple times (once for
  each LED that is configured) during initialization is negligible
- print warning when disabling EEE LED mode fails
- updated commit message (previous subject was 'net: phy: realtek:
  configure RTL8211E LEDs')

Changes in v4:
- use the generic PHY LED binding
- keep default/current configuration if none is specified
- added rtl8211e_disable_eee_led_mode()
  - was previously in separate patch, however since we always want to
    disable EEE LED mode when a LED configuration is specified it makes
    sense to just add the function here.
- don't call phy_restore_page() in rtl8211e_config_leds() if
  selection of the extended page failed.
- use phydev_warn() instead of phydev_err() if LED configuration
  fails since we don't bail out
- use hex number to specify page for consistency
- add hex number to comment about ext page 44 to facilitate searching

Changes in v3:
- sanity check led-modes values
- set LACR bits in a more readable way
- use phydev_err() instead of dev_err()
- log an error if LED configuration fails

Changes in v2:
- patch added to the series
---
 drivers/net/phy/realtek.c | 101 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a5b3708dc4d8..5064ad732443 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,8 +9,9 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
-#include <linux/phy.h>
+#include <linux/bits.h>
 #include <linux/module.h>
+#include <linux/phy.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -26,6 +27,18 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+/* RTL8211E page 5 */
+#define RTL8211E_EEE_LED_MODE1			0x05
+#define RTL8211E_EEE_LED_MODE2			0x06
+
+/* RTL8211E extension page 44 (0x2c) */
+#define RTL8211E_LACR				0x1a
+#define RLT8211E_LACR_LEDACTCTRL_SHIFT		4
+#define RTL8211E_LCR				0x1c
+
+#define LACR_MASK(led)				BIT(4 + led)
+#define LCR_MASK(led)				GENMASK((led * 4) + 2, led * 4)
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -83,6 +96,91 @@ static int rtl8211x_modify_ext_paged(struct phy_device *phydev, int page,
 	return phy_restore_page(phydev, oldpage, ret);
 }
 
+static void rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
+{
+	int oldpage;
+	int err = 0;
+
+	oldpage = phy_select_page(phydev, 5);
+	if (oldpage < 0)
+		goto out;
+
+	/* write magic values to disable EEE LED mode */
+	err = __phy_write(phydev, RTL8211E_EEE_LED_MODE1, 0x8b82);
+	if (err)
+		goto out;
+
+	err = __phy_write(phydev, RTL8211E_EEE_LED_MODE2, 0x052b);
+
+out:
+	if (err)
+		phydev_warn(phydev, "failed to disable EEE LED mode: %d\n", err);
+
+	phy_restore_page(phydev, oldpage, err);
+}
+
+static int rtl8211e_config_led(struct phy_device *phydev, int led,
+			       struct phy_led_config *cfg)
+{
+	u16 lacr_bits = 0, lcr_bits = 0;
+	int oldpage, ret;
+
+	switch (cfg->trigger.t) {
+	case PHY_LED_TRIGGER_LINK:
+		lcr_bits = 7 << (led * 4);
+		break;
+
+	case PHY_LED_TRIGGER_LINK_10M:
+		lcr_bits = 1 << (led * 4);
+		break;
+
+	case PHY_LED_TRIGGER_LINK_100M:
+		lcr_bits = 2 << (led * 4);
+		break;
+
+	case PHY_LED_TRIGGER_LINK_1G:
+		lcr_bits |= 4 << (led * 4);
+		break;
+
+	case PHY_LED_TRIGGER_NONE:
+		break;
+
+	default:
+		phydev_warn(phydev,
+			    "unknown trigger for LED%d: %d\n",
+			    led, cfg->trigger.t);
+		return -EINVAL;
+	}
+
+	if (cfg->trigger.activity)
+		lacr_bits = BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + led);
+
+	rtl8211e_disable_eee_led_mode(phydev);
+
+	oldpage = rtl8211x_select_ext_page(phydev, 0x2c);
+	if (oldpage < 0) {
+		phydev_err(phydev, "failed to select extended page: %d\n", oldpage);
+		return oldpage;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LACR,
+			   LACR_MASK(led), lacr_bits);
+	if (ret) {
+		phydev_err(phydev, "failed to write LACR reg: %d\n",
+			   ret);
+		goto err;
+	}
+
+	ret = __phy_modify(phydev, RTL8211E_LCR,
+			   LCR_MASK(led), lcr_bits);
+	if (ret)
+		phydev_err(phydev, "failed to write LCR reg: %d\n",
+			   ret);
+
+err:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -330,6 +428,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
+		.config_led	= &rtl8211e_config_led,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.22.0.770.g0f2c4a37fd-goog

