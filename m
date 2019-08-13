Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF18C14E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfHMTMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:12:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46848 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfHMTMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:12:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id q139so3847677pfc.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kx7hXRRKFHX0BuedwQZzNXNcuv3a7cFx9ZeS3n0LxTk=;
        b=mDnp/9ImreJem/DrAUC6vZR7sY5twl97eb3aIFbCe7gHNvE6cr3+oYO9MQLf9GTQG6
         VF5dZeGYH1ifQL3L9/O80vK/i8cBDleeSzjkHm/lfoe1TanfayBU+isCuOxCLkCN2JO2
         zKtKsKSPv+l8C8h7x+tB8KAK8vp7huycnHXt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kx7hXRRKFHX0BuedwQZzNXNcuv3a7cFx9ZeS3n0LxTk=;
        b=obocbjq/HatL0Dla268P5wB0IHP+M30lXZsXDQssGPfzWMDgEouRox0BWZeKaPxCIK
         4+OyDE9lvAm/LrxhFlmkuU0ibVb5PL/9oFJyXIr04GijguqMZGL94fXq+jqLuXMKJjps
         oWY56NMk9hmg3pJDByk9izS0uFZb/nP/eNAtyn5AbRq71dnTQKqH3Ev67fo4vQB1M65/
         c0ZwCzLM+jdgzTRVuVD8uHbLbeGKrCwlYc3/0dX9SsPAMSAwGmnNuUJpSaX/SIIbd8/r
         sITDRTeV+nLYEW+TF6vajzzQmbxpDbVaigiy8Norxmr4Uq4aAWyoWOXLpm/CytMykORi
         EHgw==
X-Gm-Message-State: APjAAAUhdg3DBarg2T9LQq4nicvR6oY4tagQYRyHDBPDQ/jFliNraUyL
        l4vEwr3DiYNU/Oh8jXRTFaqLmFIjuvI=
X-Google-Smtp-Source: APXvYqw7qIZJ5iHbSUcNoDmoCgiwtG+7dNb/PeZ/XL9Sbk5C42ZSFE1/DUtV8id/CG0U/tJ3UC5fpg==
X-Received: by 2002:a62:1bd5:: with SMTP id b204mr3752057pfb.14.1565723520778;
        Tue, 13 Aug 2019 12:12:00 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id t7sm4408176pgp.68.2019.08.13.12.11.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 12:12:00 -0700 (PDT)
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
Subject: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support for RTL8211E
Date:   Tue, 13 Aug 2019 12:11:47 -0700
Message-Id: <20190813191147.19936-5-mka@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190813191147.19936-1-mka@chromium.org>
References: <20190813191147.19936-1-mka@chromium.org>
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
Changes in v6:
- return -EOPNOTSUPP if trigger is not supported, don't log warning
- don't log errors if MDIO ops fail, this is rare and the phy_device
  will log a warning
- added parentheses around macro argument used in arithmetics to
  avoid possible operator precedence issues
- minor formatting changes

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
 drivers/net/phy/realtek.c | 90 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a5b3708dc4d8..2bca3b91d43d 100644
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
@@ -26,6 +27,19 @@
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
+#define LACR_MASK(led)				BIT(4 + (led))
+#define LCR_MASK(led)				GENMASK(((led) * 4) + 2,\
+							(led) * 4)
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -83,6 +97,79 @@ static int rtl8211x_modify_ext_paged(struct phy_device *phydev, int page,
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
+		phydev_warn(phydev, "failed to disable EEE LED mode: %d\n",
+			    err);
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
+		return -EOPNOTSUPP;
+	}
+
+	if (cfg->trigger.activity)
+		lacr_bits = BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + led);
+
+	rtl8211e_disable_eee_led_mode(phydev);
+
+	oldpage = rtl8211x_select_ext_page(phydev, 0x2c);
+	if (oldpage < 0)
+		return oldpage;
+
+	ret = __phy_modify(phydev, RTL8211E_LACR, LACR_MASK(led), lacr_bits);
+	if (ret)
+		goto err;
+
+	ret = __phy_modify(phydev, RTL8211E_LCR, LCR_MASK(led), lcr_bits);
+
+err:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -330,6 +417,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
+		.config_led	= &rtl8211e_config_led,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.23.0.rc1.153.gdeed80330f-goog

