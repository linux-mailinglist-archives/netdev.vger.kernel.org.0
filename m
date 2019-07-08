Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB7662970
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391679AbfGHTZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46629 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391671AbfGHTZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id c73so3405959pfb.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c4uAWO2xmu252LdOM6iPnY9UopRO1Fi//IgaHZgpov0=;
        b=iNpeBQQtfqQ1TJgqESjgV+5IBBSVIreasZT6U7MhxHRWjaW9uKqclQb0B2/IdiMbRL
         O8n2L57pWVTNk6rXEkNDCaQ9bTUt1wgOqlFMrh/tLfuWRw9VDeYy8b979ZJcQQhnwvh2
         0coB/WG9kysdaS0v8smC8q682OH+v+ZBADAJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c4uAWO2xmu252LdOM6iPnY9UopRO1Fi//IgaHZgpov0=;
        b=RN68WcJ06YIJHkFGzpQyhYr8/RnrOaOyBE8Ky0KYYWWxb3+bSjQSvzrUreYVNKg0jF
         GVUe++OW2nr/vmIoiWpLE6qwRFH+uufUF9G6dfhQX3rR7L4ehuybGK/qS5aUU46+liXX
         DLIohleeGO1hBhBxcd+xXoNuiKVVCtX8ZShz/QTjVt5agSgrx2AlfVLC5unMdOg95QII
         MVnK6LP1541NSkCi6hBzCj4BNf9ugX+4OsSRtiW6ZkTneAZvLp4yOk+AGEd+uFHzrK2P
         tXuXKszlUlEiDMnDZ3w1M1EywjUmr3M5LmUNUsfcVKf6jiiQTjF3CANlMtvDphurg5No
         RpCw==
X-Gm-Message-State: APjAAAUV8meEFfcQwrtLLLGWrZlx6Yw5LHkFqcCKvyKHyc5egEtEWAWn
        0vNl3H8TZUXkFJ5jWNt2dFW4Kw==
X-Google-Smtp-Source: APXvYqxeCVlZXRSm30fM1wf1daKaYzqjidYa7WK1HTymDcqUGGTSmv1xpCiMrgFjDK0wArf5QNMt7A==
X-Received: by 2002:a17:90a:d996:: with SMTP id d22mr27797320pjv.86.1562613913084;
        Mon, 08 Jul 2019 12:25:13 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id t17sm20193715pgg.48.2019.07.08.12.25.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:12 -0700 (PDT)
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
Subject: [PATCH v3 2/7] net: phy: realtek: Allow disabling RTL8211E EEE LED mode
Date:   Mon,  8 Jul 2019 12:24:54 -0700
Message-Id: <20190708192459.187984-3-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
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
TODO: DT validation

Changes in v3:
- don't have two versions of rtl8211e_config_init()
  (was due to my dev kernel being 4.19, which doesn't have
   this function yet)
- changed return type of rtl8211e_disable_eee_led_mode() to void
- added empty line after rtl8211e_config_init()

Changes in v2:
- patch added to the series
---
 drivers/net/phy/realtek.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb829..827ea7ed080d 100644
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
@@ -53,6 +58,26 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
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
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -184,9 +209,13 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
 	int ret = 0, oldpage;
 	u16 val;
 
+	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
+		rtl8211e_disable_eee_led_mode(phydev);
+
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-- 
2.22.0.410.gd8fdbe21b5-goog

