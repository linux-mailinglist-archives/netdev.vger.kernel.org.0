Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC40C7E30D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbfHATIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:08:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37387 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388435AbfHATIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:08:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so1900725pgp.4
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 12:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7zHWj9uTE898xNsFgNreOOl7M4AlQGC8nY/kzspFO0=;
        b=cdolFD+t3qlExdtL2mwioJzGR1pyV/iW375YSsUWcZFBve/MIlrkO8QohNIWAkKHm/
         cnZS1TY5ULaH/vUFVWpAk4srdOuOK5CRqOfy9dcmlPvUZzBPscYSQRjOj0fVy7Ll55bg
         J17+3SUy6JAShcfeUdc4upc4r1/4Kzx/QURKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7zHWj9uTE898xNsFgNreOOl7M4AlQGC8nY/kzspFO0=;
        b=YsjuUhVR56MXkepf/OgKFmghPxtmg+Gl+NvXCIONOPYOAgnEjCw50e8G/VaztLAeKx
         n4cQhGnEkNNoY2JIeNY16E8cWawJKKnMuUToXeFrL0wCnoJUS30Tql+sYuxuRpTUlWaP
         5XGuYtCITXwSoF3AnqCCpTp5ZZ2guLBxZ1ItPcIj2hk4S4TNZxyjll01qGGV+4k1amyC
         GbFqiP09pZRdISPNWMB1WGLECIUalX5W3IO/TJULA4Zhgo/sHm7EEbPgtyvoRkl0C5Fk
         26WpMZq74G7nU/k7dGPVNvZhnkB/vh5d6jiIQwviT7E1XvM/Vb80+56v6E4FwuUz/98g
         eHHQ==
X-Gm-Message-State: APjAAAXzzKgDRaI1W+P3cUXjCOs3Dzbj7R61clq/18leRfkPZRa8cvcQ
        OzLBPA+o3c2zDdMSAALVyM5BbA==
X-Google-Smtp-Source: APXvYqyLppyi7G54tMIgHrVIgaDlvaNg0NBQ+64G+XU7m58ZMFxnyLnXrYT2feFR83kV6qwS8st6QQ==
X-Received: by 2002:a63:c013:: with SMTP id h19mr90640936pgg.108.1564686489164;
        Thu, 01 Aug 2019 12:08:09 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id q63sm95084100pfb.81.2019.08.01.12.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:08:08 -0700 (PDT)
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
Subject: [PATCH v4 4/4] net: phy: realtek: configure RTL8211E LEDs
Date:   Thu,  1 Aug 2019 12:07:59 -0700
Message-Id: <20190801190759.28201-5-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190801190759.28201-1-mka@chromium.org>
References: <20190801190759.28201-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure the RTL8211E LEDs behavior when the device tree property
'realtek,led-modes' is specified.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
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
---
 drivers/net/phy/realtek.c | 121 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index e09d3b0da2c7..46e3d77d41b6 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,8 +9,11 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
-#include <linux/phy.h>
+#include <linux/bits.h>
 #include <linux/module.h>
+#include <linux/phy.h>
+
+#define RTL821x_NUM_LEDS			3
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -26,6 +29,19 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+/* RTL8211E page 5 */
+#define RTL8211E_EEE_LED_MODE1			0x05
+#define RTL8211E_EEE_LED_MODE2			0x06
+
+/* RTL8211E extension page 44 (0x2c) */
+#define RTL8211E_LACR				0x1a
+#define RLT8211E_LACR_LEDACTCTRL_SHIFT		4
+#define RLT8211E_LACR_LEDACTCTRL_MASK		GENMASK(6, 4)
+#define RTL8211E_LCR				0x1c
+#define RTL8211E_LCR_LEDCTRL_MASK		(GENMASK(2, 0) | \
+						 GENMASK(6, 4) | \
+						 GENMASK(10, 8))
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -83,6 +99,105 @@ static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
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
+	phy_restore_page(phydev, oldpage, err);
+}
+
+static int rtl8211e_config_leds(struct phy_device *phydev)
+{
+	int i, oldpage, ret;
+	u16 lacr_bits = 0, lcr_bits = 0;
+	u16 lacr_mask = RLT8211E_LACR_LEDACTCTRL_MASK;
+	u16 lcr_mask = RTL8211E_LCR_LEDCTRL_MASK;
+	bool eed_led_mode_disabled = false;
+
+	for (i = 0; i < RTL821x_NUM_LEDS; i++) {
+		struct phy_led_config cfg;
+
+		ret = of_get_phy_led_cfg(phydev, i, &cfg);
+		if (ret) {
+			lacr_mask &= ~BIT(4 + i);
+			lcr_mask &= ~GENMASK((i * 4) + 2, i * 4);
+			continue;
+		}
+
+		if (!eed_led_mode_disabled) {
+			rtl8211e_disable_eee_led_mode(phydev);
+			eed_led_mode_disabled = true;
+		}
+
+		switch (cfg.trigger) {
+		case PHY_LED_LINK_10M:
+			lcr_bits |= 1 << (i * 4);
+			break;
+
+		case PHY_LED_LINK_100M:
+			lcr_bits |= 2 << (i * 4);
+			break;
+
+		case PHY_LED_LINK_1G:
+			lcr_bits |= 4 << (i * 4);
+			break;
+
+		case PHY_LED_ACTIVITY:
+			lacr_bits |= BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);
+			break;
+
+		default:
+			phydev_warn(phydev,
+				    "unknown trigger for LED%d: %d\n",
+				    i, cfg.trigger);
+		}
+	}
+
+	oldpage = rtl8211e_select_ext_page(phydev, 0x2c);
+	if (oldpage < 0) {
+		phydev_err(phydev, "failed to select extended page: %d\n", oldpage);
+		return oldpage;
+	}
+
+	if (lacr_mask == 0)
+		goto skip_lacr;
+
+	ret = __phy_modify(phydev, RTL8211E_LACR,
+			   lacr_mask, lacr_bits);
+	if (ret) {
+		phydev_err(phydev, "failed to write LACR reg: %d\n",
+			   ret);
+		goto err;
+	}
+
+skip_lacr:
+	if (lcr_mask == 0)
+		goto skip_lcr;
+
+	ret = __phy_modify(phydev, RTL8211E_LCR,
+			   lcr_mask, lcr_bits);
+	if (ret)
+		phydev_err(phydev, "failed to write LCR reg: %d\n",
+			   ret);
+
+skip_lcr:
+err:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -217,6 +332,10 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	int ret;
 	u16 val;
 
+	ret = rtl8211e_config_leds(phydev);
+	if (ret)
+		phydev_warn(phydev, "LED configuration failed: %d\n", ret);
+
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-- 
2.22.0.770.g0f2c4a37fd-goog

