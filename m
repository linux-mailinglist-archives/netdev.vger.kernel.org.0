Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1FB136129
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgAITfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:45 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40310 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730685AbgAITfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so4121665wmi.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/gwouNnkS0xJIxEj3fEWjyuOVq0DyXRVBmqT2jjLT10=;
        b=TPg/eiLK3mLVV5c6vsRSkt8MDyhQCPbHKXJl4OuTAu3S4iijZvgZ614XkVxxOJGlrx
         Evt7ARRH26qk50Nv6DGzDxfQ1xolTtIWPKQv0LfasNRBqzgyiyiM35gzoJhhbgG49IHu
         FmY4zgA1M93PbRBNB7D2AyW1fL7HbvLOuNjDGKDi5j64ArRCtXfZF5BsN0MpdEu33a5m
         6EcA7fLtQc5KGs3hPTmdSS5BksHdgIImg325EBVgCHkoX4qkq+vdFChJXPWfnuiDy25t
         pjzqX+9UgQGmSAo4qOSMMe630LGsTx6iIppJzpXs9mmthEjV/wRaLlUrgiXb6r7i3CdA
         VQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/gwouNnkS0xJIxEj3fEWjyuOVq0DyXRVBmqT2jjLT10=;
        b=iPCTvHkznaCHrwut32U2OJb/M9S4vmCi00YmF9lTqEyxq3p7zMcqCYnJCJPmL99X/8
         nZ5BeVcKQrM41LiS+LBH9crl5oVzOTZSDjPgUUXsYYxQMPV0icUaCtz9i0MS3rFfLGcH
         mS037HfGgSFfw+lj5kld8aaVFZ27+qU9517qlRveqGy0u6x5UzOShiloqRuYU/rkk9sO
         WFfimKkWB3ne+ba869kNRGovOME9Y1TUXjmes4Pb4aWL6kMFuIaLYJ7ntouMMgfgqyOX
         PM4wdCC6Z7hLkuOfmS71cZZvDqV9zV9+4UPRmSKlEgRGPbGUG1aB1zwLYvlkKtRRZnz4
         y7cw==
X-Gm-Message-State: APjAAAVByIIVyAVTiqocg13Xr2LX0M1zmqRY+r9SI4lPg6fhsYvh4guf
        ZDpO0IhIidaCwiQG1uG/BCDtMo6T
X-Google-Smtp-Source: APXvYqw89kGXHTKJuS17FRsIzoSDmU4o6rAUQImgLqkWut1petQwWExSS3sLGiCS40/mozd3Vz3ZCA==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr6620770wml.43.1578598540578;
        Thu, 09 Jan 2020 11:35:40 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id l19sm3850774wmj.12.2020.01.09.11.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:40 -0800 (PST)
Subject: [PATCH net-next 06/15] r8169: switch to phylib functions in
 rtl_writephy_batch
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <424b6198-d51c-108c-85d5-84ee4bb19279@gmail.com>
Date:   Thu, 9 Jan 2020 20:28:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch rtl_writephy_batch() to phylib functions, as a result we can
avoid passing a rtl8169_private parameter.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 39 ++++++++++++-----------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 94bad2b09..dccc5a1d3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2276,16 +2276,20 @@ struct phy_reg {
 	u16 val;
 };
 
-static void __rtl_writephy_batch(struct rtl8169_private *tp,
+static void __rtl_writephy_batch(struct phy_device *phydev,
 				 const struct phy_reg *regs, int len)
 {
+	phy_lock_mdio_bus(phydev);
+
 	while (len-- > 0) {
-		rtl_writephy(tp, regs->reg, regs->val);
+		__phy_write(phydev, regs->reg, regs->val);
 		regs++;
 	}
+
+	phy_unlock_mdio_bus(phydev);
 }
 
-#define rtl_writephy_batch(tp, a) __rtl_writephy_batch(tp, a, ARRAY_SIZE(a))
+#define rtl_writephy_batch(p, a) __rtl_writephy_batch(p, a, ARRAY_SIZE(a))
 
 static void rtl_release_firmware(struct rtl8169_private *tp)
 {
@@ -2410,7 +2414,7 @@ static void rtl8169s_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x00, 0x9200 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
 static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp,
@@ -2462,7 +2466,7 @@ static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
 static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
@@ -2516,7 +2520,7 @@ static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
 static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
@@ -2572,7 +2576,7 @@ static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x09, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 
 	rtl_patchphy(tp, 0x14, 1 << 5);
 	rtl_patchphy(tp, 0x0d, 1 << 5);
@@ -2600,7 +2604,7 @@ static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 
 	rtl_patchphy(tp, 0x16, 1 << 0);
 	rtl_patchphy(tp, 0x14, 1 << 5);
@@ -2623,7 +2627,7 @@ static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 }
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 
 	rtl_patchphy(tp, 0x16, 1 << 0);
 	rtl_patchphy(tp, 0x14, 1 << 5);
@@ -2699,7 +2703,7 @@ static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp, u16 val)
 static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
+	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
 
 	/*
 	 * Rx Error Issue
@@ -2712,7 +2716,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
 		int val;
 
-		rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_1);
+		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
 
 		val = rtl_readphy(tp, 0x0d);
 
@@ -2751,12 +2755,12 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
+	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
 		int val;
 
-		rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_1);
+		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
 
 		val = rtl_readphy(tp, 0x0d);
 		if ((val & 0x00ff) != 0x006c) {
@@ -2844,8 +2848,7 @@ static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 },
 	};
 
-	rtl_writephy_batch(tp, phy_reg_init);
-
+	rtl_writephy_batch(phydev, phy_reg_init);
 	r8168d_modify_extpage(phydev, 0x0023, 0x16, 0xffff, 0x0000);
 }
 
@@ -2876,7 +2879,7 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp,
 	/* Enable Delay cap */
 	r8168d_phy_param(phydev, 0x8b80, 0xffff, 0xc896);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 
 	/* Update PFM & 10M TX idle timer */
 	r8168d_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
@@ -3370,7 +3373,7 @@ static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
 	rtl_patchphy(tp, 0x19, 1 << 13);
 	rtl_patchphy(tp, 0x10, 1 << 15);
 
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
 static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
@@ -3421,7 +3424,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 	rtl_apply_firmware(tp);
 
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
-	rtl_writephy_batch(tp, phy_reg_init);
+	rtl_writephy_batch(phydev, phy_reg_init);
 
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 }
-- 
2.24.1


