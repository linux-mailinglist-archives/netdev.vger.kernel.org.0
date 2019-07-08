Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351C762962
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403941AbfGHTZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38440 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391703AbfGHTZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id z75so8176517pgz.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yhjmcbV2ehplgv1QV+Zl9fbD+UT5ueIX0KgPkxwPbM4=;
        b=kHdDHUnNFnPDmo4NVnb87jN5iS2og6ATWyIQ2wCl6x8KC4rRyBnZxEpNptNQVjqKTi
         Zgn791KWE/eGCWNRgxxS8okCx8VMKAbszS6qKV+6BwKxrJqykUaO7ee0mJt5LAKuYDQa
         zA4wefcFeWrseB6eWHdqwIOReXoFhXucgvkTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yhjmcbV2ehplgv1QV+Zl9fbD+UT5ueIX0KgPkxwPbM4=;
        b=ascTGe79mA2NLjy59EXOH1BwOgbtUBS3IBf/D4SMbSyq7GKJA7d+51KIsrEEvpBACL
         VmEkWTjBSjBwuyWIIc8fetvJyog9Xb/Cn5H3jdFGO4gTiD5RJ8RJnUauEqkf3MaQHFfB
         yNXdmybiPI5qaDS07BxBrF5nRnk0UBtc0IwN7OuP8er4qREA5AVCdlb1uCfZSMAOWEI9
         35ctgx1bczNRT66wvymjA+MxeySnZeA2aQa1kvchgvBnwyvscwu0Gay0M1Dj/NQp3yzJ
         LvzRCv8i1FA/j7IVadrdOdNd43WBTWaHLcPk22iITf2c+y1qpohxVFVCB4PEmrxgfmCY
         Sm6A==
X-Gm-Message-State: APjAAAWQ+jv7U/ZK07q9A9XJfHrKd5mYh2648b56xBN1BZZ5Yn+yJDVR
        xsEkAhhJpLHyNEqtF9ipEW5NIA==
X-Google-Smtp-Source: APXvYqzk/btNxdow+2ZIFqdj3S5nbf/OeqJTH+i0wuTjm8uK2z+v9CcMmD5Y8UAaLrIThcSFUZNg0w==
X-Received: by 2002:a63:b102:: with SMTP id r2mr5197426pgf.370.1562613917562;
        Mon, 08 Jul 2019 12:25:17 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id t8sm261797pji.24.2019.07.08.12.25.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:17 -0700 (PDT)
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
Subject: [PATCH v3 5/7] net: phy: realtek: Support SSC for the RTL8211E
Date:   Mon,  8 Jul 2019 12:24:57 -0700
Message-Id: <20190708192459.187984-6-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default Spread-Spectrum Clocking (SSC) is disabled on the RTL8211E.
Enable it if the device tree property 'realtek,enable-ssc' exists.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
TODO: DT validation

Changes in v3:
- use phydev_err() instead of dev_err()

Changes in v2:
- enable SSC in config_init() instead of probe()
- fixed error check after enabling SSC
---
 drivers/net/phy/realtek.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fa11ae5ebd91..5854412403b5 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,6 +9,7 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/phy.h>
@@ -33,6 +34,10 @@
 #define RTL8211E_EEE_LED_MODE1			0x05
 #define RTL8211E_EEE_LED_MODE2			0x06
 
+/* RTL8211E extension page 160 */
+#define RTL8211E_SCR				0x1a
+#define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
+
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
@@ -250,8 +255,18 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
+	int ret;
 	u16 val;
 
+	if (of_property_read_bool(dev->of_node, "realtek,enable-ssc")) {
+		ret = rtl8211e_modify_ext_paged(phydev, 0xa0, RTL8211E_SCR,
+						RTL8211E_SCR_DISABLE_RXC_SSC,
+						0);
+		if (ret < 0)
+			phydev_err(phydev, "failed to enable SSC on RXC: %d\n",
+				   ret);
+	}
+
 	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
 		rtl8211e_disable_eee_led_mode(phydev);
 
-- 
2.22.0.410.gd8fdbe21b5-goog

