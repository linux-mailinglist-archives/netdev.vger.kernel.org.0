Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292E95C3DA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfGATwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:52:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45850 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbfGATwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:52:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so2012944pgp.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAYVgFrVyDEWW2kNMp3bRnTvQ9QblfVV1v8XIkrYm00=;
        b=md3MkgWYd9QIP3p2MmWnvrUvBzm99KGfssPqgfPa6k4JMEh9NKrI6Nk9yhJaYtunNJ
         VKLTVCTBAkGA6DAB0gtRI6byTewFkDnwSJEJXy4ftSVw5uPtJ2hx6zlz2xnwlDlVxK9l
         Yve3yGn9fvm/tLGAblJm3gVchSbYM57oi8mdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAYVgFrVyDEWW2kNMp3bRnTvQ9QblfVV1v8XIkrYm00=;
        b=MXyfYlQR81eKfpNTbazM7y4vH4bowFouP/AgGMJqvuZEzOg+0uX2P3D6pMPOZSsWZt
         mysMZOH5B8px2bnC4Kbxl4An90V2PE2hodABzM+dfurOfXB9qTKAIyUAk4XsNbhVYTJz
         ZIBLhCG/RP9e1slVkIerillONLEOOxGnhHIuYIvrk0F8+lV7v9PFnWgoy3jaJcD/4qkD
         4vAXCpMlQLKX6e9mW1HIYSdzqSdIFCUm1/HkAAizsaBvMMMHk1x1HrMdSvuHkuY4XRt8
         t6QPbMIKMkq+Z6GDZF3iRtKg8oGSymegh95UVA2QEOjYF3igDUEsiAkNSxJQjW6lN+uG
         JlXg==
X-Gm-Message-State: APjAAAW3xcWkxDstvOCym99pk/MJ899rifYu7UQuFACJ0964J+UsXJhd
        D8Po39dXkZeL+4fKKF0O1pBoAA==
X-Google-Smtp-Source: APXvYqw31m0prNXo5zqWrfyoNPVVsfqH9E3kf7BjlmUv7dGnkfIM1MGNRGL73hYzPIggSDT1kBD7og==
X-Received: by 2002:a17:90a:206a:: with SMTP id n97mr1147365pjc.10.1562010753344;
        Mon, 01 Jul 2019 12:52:33 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p68sm13020863pfb.80.2019.07.01.12.52.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:52:32 -0700 (PDT)
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
Subject: [PATCH 3/3] net: phy: realtek: Support SSC for the RTL8211E
Date:   Mon,  1 Jul 2019 12:52:25 -0700
Message-Id: <20190701195225.120808-3-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701195225.120808-1-mka@chromium.org>
References: <20190701195225.120808-1-mka@chromium.org>
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
 drivers/net/phy/realtek.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index dfc2e20ef335..b617169ccc8c 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -9,8 +9,10 @@
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
  */
 #include <linux/bitops.h>
-#include <linux/phy.h>
+#include <linux/device.h>
+#include <linux/of.h>
 #include <linux/module.h>
+#include <linux/phy.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -28,6 +30,8 @@
 
 #define RTL8211E_EXT_PAGE			7
 #define RTL8211E_EPAGSR				0x1e
+#define RTL8211E_SCR				0x1a
+#define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
 
 #define RTL8211F_INSR				0x1d
 
@@ -87,8 +91,8 @@ static int rtl821e_restore_page(struct phy_device *phydev, int oldpage, int ret)
 	return ret;
 }
 
-static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
-				    int page, u32 regnum, u16 mask, u16 set)
+static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
+				     u32 regnum, u16 mask, u16 set)
 {
 	int ret = 0;
 	int oldpage;
@@ -114,6 +118,22 @@ static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
 	return rtl821e_restore_page(phydev, oldpage, ret);
 }
 
+static int rtl8211e_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int err;
+
+	if (of_property_read_bool(dev->of_node, "realtek,enable-ssc")) {
+		err = rtl8211e_modify_ext_paged(phydev, 0xa0, RTL8211E_SCR,
+						RTL8211E_SCR_DISABLE_RXC_SSC,
+						0);
+		if (err)
+			dev_err(dev, "failed to enable SSC on RXC: %d\n", err);
+	}
+
+	return 0;
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -372,6 +392,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
+		.probe          = rtl8211e_probe,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.22.0.410.gd8fdbe21b5-goog

