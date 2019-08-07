Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5281F851A2
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389113AbfHGRFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:05:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44131 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389098AbfHGRFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:05:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so41693684plr.11
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 10:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hOVkpljzYUmTwIx0wK5I0XqpoB+svzyJi3RWI0VTg84=;
        b=BGRcWBHnJhM6VxYGEIiHSWiRcwKmpraw9Ixza8jIf2ICJ+MiTBnbiFtNtTFglbmeSl
         DCiVQaXc3P3PPj0j4s0lSkvmbGP6M1hOyKgK7G5pT78NWptZC1cTLLKQLrXCXnFVNc30
         dqlwp2YE4YZ1dKSdBgo8EUerLNlL0ST8OPtDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hOVkpljzYUmTwIx0wK5I0XqpoB+svzyJi3RWI0VTg84=;
        b=EoVzOWEO7iDmgDa2E8wk+KGScyomozFWQ9fdztWzR7vX1XTKLQh2AjXg1CoB4ua+g8
         RQlaU7GS8pJlQOsPWZA5OCmThWHTNDoY0qO2HsZk+G00G8ztf4Y62v9NEBoHokRpwrZo
         h79RmrC104yJgUhZ2mLaAMkV/Duggjg3taUnQVpy0nSWoCeBr5H4q9rUPJU9FWDsqavC
         z9srctrMwKiQASRpsWuh/AbuXTEIWWu1dLbn5jvfdtv8TezVxx2x7L9YZxglShYjFk4q
         JGp3YISIVOgFzLWUWRCG4vagljfcuyZ1WxYF84hG34V7k+V1W8uaJU902Y7wfjal/00d
         UGKA==
X-Gm-Message-State: APjAAAUyC0z1t8rMi8evp00dPkZeaKDhiEWkMTZYPktfURgfygQ7egAG
        5Urhfv28LRp/4g+g4tV/L8Eh5g==
X-Google-Smtp-Source: APXvYqyoJ2RmE6G+aeUGVjoAnFTrrVbiHhXfMAQNWIyweFTLc7SkfqVWa2cWFVHFBqK0BMw+WGFWfA==
X-Received: by 2002:a17:902:7b98:: with SMTP id w24mr8863485pll.163.1565197501710;
        Wed, 07 Aug 2019 10:05:01 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id e10sm95041792pfi.173.2019.08.07.10.05.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:05:01 -0700 (PDT)
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
Subject: [PATCH v5 3/4] net: phy: realtek: Add helpers for accessing RTL8211x extension pages
Date:   Wed,  7 Aug 2019 10:04:48 -0700
Message-Id: <20190807170449.205378-4-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190807170449.205378-1-mka@chromium.org>
References: <20190807170449.205378-1-mka@chromium.org>
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
2.22.0.770.g0f2c4a37fd-goog

