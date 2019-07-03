Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A75ECD8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfGCThi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:37:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34568 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfGCThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:37:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so1739774pgn.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RKIrgvh7sGmN+nvcMnq9P4cm7n9OuJv7Ut7+3W8C7kc=;
        b=D8XQ5HrwQA5U9yvrAHAibO5HussHc6q57yKUDYTkK02CZCcAW0hxmFsXOwn3ZQmWMB
         1dHfwa8hN1a/OWhikx6OdcfAHQj4ze3gI1jdZqBSOencj8YfyJzLy0XwFKW6dBkiZB2p
         PgP9Rl4ChwIzVwkhCx431pNh0YY749xTadsBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RKIrgvh7sGmN+nvcMnq9P4cm7n9OuJv7Ut7+3W8C7kc=;
        b=eQlHQaJkyYBw0XLoH1PL95284RIuFUzSF1ANO1iotvTR0ANz1FzyUu3NiQYGRVU9xn
         ramHpBgfbtngE11wd4rqOevw8MZDIPoiIvUMtIENMOiU+Ci8jy0ZBxIjjQilXa38xosg
         5FaBLYBfvYPqAJad0U0HoOXY1YFHVzUTa+XTvzV0LGdzEBrHIM3wgbfK/r41LUTn47nc
         zRLh/j4nRk9hoOQ9BNxBIJkS3lrk35TYp//tjtEf/CEmWPUjsZVG96Xe0feQjfWq7igN
         qd2arT36ydwMdNvC0EJNLjbB0QxCm0Qkr0bvnYGBN8eFzfUxC0xYb6vOUiktZ3UrrgZN
         Ocgg==
X-Gm-Message-State: APjAAAUHg1QKSmyND92kPzdz1U3dyxXhZ9Q4hi54bJEpkr9VWbs7RXzp
        betbLXuKtWuq0xj8nEwD54NU9w==
X-Google-Smtp-Source: APXvYqwoyYkBvIC9NTJ5kb+MMFMxSaG8yPrlQuls9+4Hk+NSQGqEE8CCDTsFQiPuPUJC9C5PyWj5Lw==
X-Received: by 2002:a63:6883:: with SMTP id d125mr39438812pgc.281.1562182655194;
        Wed, 03 Jul 2019 12:37:35 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id r6sm2635735pji.0.2019.07.03.12.37.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 12:37:34 -0700 (PDT)
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
Subject: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E extension pages
Date:   Wed,  3 Jul 2019 12:37:21 -0700
Message-Id: <20190703193724.246854-4-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8211E has extension pages, which can be accessed after
selecting a page through a custom method. Add a function to
modify bits in a register of an extension page and a helper for
selecting an ext page.

rtl8211e_modify_ext_paged() is inspired by its counterpart
phy_modify_paged().

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- assign .read/write_page handlers for RTL8211E
- use phy_select_page() and phy_restore_page(), get rid of
  rtl8211e_restore_page()
- s/rtl821e_select_ext_page/rtl8211e_select_ext_page/
- updated commit message
---
 drivers/net/phy/realtek.c | 42 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index eb815cbe1e72..9cd6241e2a6d 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -27,6 +27,9 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+#define RTL8211E_EXT_PAGE			7
+#define RTL8211E_EPAGSR				0x1e
+
 /* RTL8211E page 5 */
 #define RTL8211E_EEE_LED_MODE1			0x05
 #define RTL8211E_EEE_LED_MODE2			0x06
@@ -58,6 +61,44 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
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
+	ret = __phy_write(phydev, RTL8211E_EPAGSR, page);
+	if (ret)
+		return phy_restore_page(phydev, page, ret);
+
+	return 0;
+}
+
+static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
+				    int page, u32 regnum, u16 mask, u16 set)
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
 static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
 {
 	int ret = 0;
@@ -87,6 +128,7 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 
 	return 0;
 }
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
-- 
2.22.0.410.gd8fdbe21b5-goog

