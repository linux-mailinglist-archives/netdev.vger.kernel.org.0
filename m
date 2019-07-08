Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB6362961
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391710AbfGHTZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41849 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391693AbfGHTZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so8177796pgj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gsMzjspqX3PBUZb1UD3dZ0p1pkEN9yJx+z3bVdge6HE=;
        b=gBmEy4V1hNpseoZ1vK24G6r5sQQc1WuGEApGLyKkyTNhv0IB3fQZ75F/tS+bVGBQqV
         CqgCf+0auXNgyWW7hepUDvcm6z98KEU0Hlp07b0I/8EzahCCwsVZo3aMY8NK/M5CwB46
         IV6J4WwKYIdMJZnbU0ngbzbYBrt88Bfb/nEYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gsMzjspqX3PBUZb1UD3dZ0p1pkEN9yJx+z3bVdge6HE=;
        b=F2sBegrQwjrZdzsHsiaFotfxJt/ngkgAGzB5Dc7O3ei1InF5bo+qWNYDlR2QQB26U/
         NHQuH+wzYxj2W0sR3ninw26Qj5tw91KnvKiwJp4IYezIemoYtYGc5FRxKW8Ncqzpfphu
         QpnsrkP6HhsCpfFuZDK4poJW4Gcm36mngMkJ1lZprewfJL7SHXWXolAcAchjP+BobrQr
         WD06V6Z6LQZ/2mOIjD6TiwN+gZN5DqLdhVqkHpsRVhgzwPlynFRDz8NZfhCY8mRXClBs
         6/TYFo3s4dxwdar4CyZL3fMgQndgFZu3xqS+/0SnimRXC7soghM3Vdcl4PQLK/ppwEbJ
         cxuw==
X-Gm-Message-State: APjAAAX1Znqza8ThGB4bLjSo+GOSzKFrsORYaeNrcAUYoO1s8D5mVWBi
        6rwOPySo3OQCQH9k5mbHWo2XXg==
X-Google-Smtp-Source: APXvYqylcRq50zbSzhERqOYxz7ym2pNAUb3Qod4Wqyjxbm7tazdrmWPBYtrJXN3TGqm1Hyv4LvCP5A==
X-Received: by 2002:a17:90a:71ca:: with SMTP id m10mr28247509pjs.27.1562613916243;
        Mon, 08 Jul 2019 12:25:16 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p13sm351144pjb.30.2019.07.08.12.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:15 -0700 (PDT)
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
Subject: [PATCH v3 4/7] net: phy: realtek: Add helpers for accessing RTL8211E extension pages
Date:   Mon,  8 Jul 2019 12:24:56 -0700
Message-Id: <20190708192459.187984-5-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708192459.187984-1-mka@chromium.org>
References: <20190708192459.187984-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8211E has extension pages, which can be accessed after
selecting a page through a custom method. Add a function to
modify bits in a register of an extension page and a helper for
selecting an ext page. Use rtl8211e_modify_ext_paged() in
rtl8211e_config_init() instead of doing things 'manually'.

rtl8211e_modify_ext_paged() is inspired by its counterpart
phy_modify_paged().

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v3:
- use the new function in rtl8211e_config_init() instead of
  doing things 'manually'
- use existing RTL8211E_EXT_PAGE instead of adding a new define
- updated commit message

Changes in v2:
- use phy_select_page() and phy_restore_page(), get rid of
  rtl8211e_restore_page()
- s/rtl821e_select_ext_page/rtl8211e_select_ext_page/
- updated commit message
---
 drivers/net/phy/realtek.c | 57 +++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 827ea7ed080d..fa11ae5ebd91 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -27,6 +27,8 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+#define RTL8211E_EXT_PAGE			7
+
 /* RTL8211E page 5 */
 #define RTL8211E_EEE_LED_MODE1			0x05
 #define RTL8211E_EEE_LED_MODE2			0x06
@@ -58,6 +60,44 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)
+{
+	int ret, oldpage;
+
+	oldpage = phy_select_page(phydev, RTL8211E_EXT_PAGE);
+	if (oldpage < 0)
+		return oldpage;
+
+	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, page);
+	if (ret)
+		return phy_restore_page(phydev, page, ret);
+
+	return 0;
+}
+
+static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
+				     u32 regnum, u16 mask, u16 set)
+{
+	int ret = 0;
+	int oldpage;
+	int new;
+
+	oldpage = rtl8211e_select_ext_page(phydev, page);
+	if (oldpage < 0)
+		goto out;
+
+	ret = __phy_read(phydev, regnum);
+	if (ret < 0)
+		goto out;
+
+	new = (ret & ~mask) | set;
+	if (new != ret)
+		ret = __phy_write(phydev, regnum, new);
+
+out:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static void rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
 {
 	int oldpage;
@@ -210,7 +250,6 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
-	int ret = 0, oldpage;
 	u16 val;
 
 	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
@@ -242,19 +281,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
 	 * for details).
 	 */
-	oldpage = phy_select_page(phydev, 0x7);
-	if (oldpage < 0)
-		goto err_restore_page;
-
-	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
-	if (ret)
-		goto err_restore_page;
-
-	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
-			   val);
-
-err_restore_page:
-	return phy_restore_page(phydev, oldpage, ret);
+	return rtl8211e_modify_ext_paged(phydev, 0xa4, 0x1c,
+					 RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+					 val);
 }
 
 static int rtl8211b_suspend(struct phy_device *phydev)
-- 
2.22.0.410.gd8fdbe21b5-goog

