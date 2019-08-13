Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF208C14B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHMTML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:12:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42248 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfHMTMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:12:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so1440283pgb.9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 12:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5T2awAbmTODH86MSd7SOI9tSGo/wo5wEB+/mqImgxg=;
        b=BwfIYO4zc4aWUmrI9UD8lz5ygEX8EVRpdxerDlRtdyz2XP4BYiNkSSfDBHqFlUXw9k
         0F+e02hsK+86/zfo8/RjjGW7tujQkUySggNYtSSDPsUsCvU6uqjiBl4GLE5BBc+ZSRfC
         SnhmjxzUhp+LGmyn7K6Dg1+FJL4ieXqYUcDN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5T2awAbmTODH86MSd7SOI9tSGo/wo5wEB+/mqImgxg=;
        b=L/AcxxOing/MFo5xBOPnVG2gnpP6hUZ+D4bJr1eS9glA0lvYtu0SOFk5bbtJCvbSWx
         0fAiNsioox3Qw5Ou1JpkbjjYs5yjzrlE81Jde52S4t7pK+pfDgjuQFXKUJqLXsVllVTK
         MwqbSvb3fnXbf8hwWkq9IOZM8zeIa+9kQyCidPnTJfBGOmHZmvrf8aXbunZWyCKhj0Eu
         m0txUPBSDM/fbgg8ZjVLJ67e3hLrzwse5hRPJZGrJjyHyxKmt1KEN0fVhh49ZySvIw2i
         2wEQBpsUXvcymVEd5tA0wzz058puOD9t6ij2+Ueg8v9jRCIkDLMnTYj6+Ls3I5INtzpm
         1Z/g==
X-Gm-Message-State: APjAAAXN44E+g1em/zGIgujDDFqvojlQL1vgcI53Yj0jYsmCy4gF3IvI
        uuCLWyoHNAmLfVAa52Iyjw4mcOgexMU=
X-Google-Smtp-Source: APXvYqw9ePu/VxnJMlXN5kUdq67hALwKfkwbmoCzjB0VdgjhNfAO9qJZ0Sp3c1dphks1gDrVbpqZyQ==
X-Received: by 2002:a65:684c:: with SMTP id q12mr33364685pgt.405.1565723519347;
        Tue, 13 Aug 2019 12:11:59 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p10sm6806603pff.132.2019.08.13.12.11.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 12:11:58 -0700 (PDT)
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
Subject: [PATCH v6 3/4] net: phy: realtek: Add helpers for accessing RTL8211x extension pages
Date:   Tue, 13 Aug 2019 12:11:46 -0700
Message-Id: <20190813191147.19936-4-mka@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190813191147.19936-1-mka@chromium.org>
References: <20190813191147.19936-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some RTL8211x PHYs have extension pages, which can be accessed
after selecting a page through a custom method. Add a function to
modify bits in a register of an extension page and a helper for
selecting an ext page. Use rtl8211x_modify_ext_paged() in
rtl8211e_config_init() instead of doing things 'manually'.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v6:
- none

Changes in v5:
- renamed 'rtl8211e_<action>_ext_page' to 'rtl8211x_<action>_ext_page'
- updated commit message

Changes in v4:
- don't add constant RTL8211E_EXT_PAGE, it's only used once,
  use a literal instead
- pass 'oldpage' to phy_restore_page() in rtl8211e_select_ext_page(),
  not 'page'
- return 'oldpage' in rtl8211e_select_ext_page()
- use __phy_modify() in rtl8211e_modify_ext_paged() instead of
  reimplementing __phy_modify_changed()
- in rtl8211e_modify_ext_paged() return directly when
  rtl8211e_select_ext_page() fails

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
 drivers/net/phy/realtek.c | 47 +++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb829..a5b3708dc4d8 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -53,6 +53,36 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+static int rtl8211x_select_ext_page(struct phy_device *phydev, int page)
+{
+	int ret, oldpage;
+
+	oldpage = phy_select_page(phydev, 7);
+	if (oldpage < 0)
+		return oldpage;
+
+	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, page);
+	if (ret)
+		return phy_restore_page(phydev, oldpage, ret);
+
+	return oldpage;
+}
+
+static int rtl8211x_modify_ext_paged(struct phy_device *phydev, int page,
+				     u32 regnum, u16 mask, u16 set)
+{
+	int ret = 0;
+	int oldpage;
+
+	oldpage = rtl8211x_select_ext_page(phydev, page);
+	if (oldpage < 0)
+		return oldpage;
+
+	ret = __phy_modify(phydev, regnum, mask, set);
+
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -184,7 +214,6 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
-	int ret = 0, oldpage;
 	u16 val;
 
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
@@ -213,19 +242,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
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
+	return rtl8211x_modify_ext_paged(phydev, 0xa4, 0x1c,
+					 RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+					 val);
 }
 
 static int rtl8211b_suspend(struct phy_device *phydev)
-- 
2.23.0.rc1.153.gdeed80330f-goog

