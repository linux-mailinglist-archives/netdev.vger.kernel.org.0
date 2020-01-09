Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF23913612F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgAITft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33248 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbgAITfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so8740792wrq.0
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yml6pXAdz3mX8lJw9tffU2Xx/mgfV/pGnoNbX3i8nU4=;
        b=jr+4e0rk6L+jl6+uSqclRB47u+itPYYxMAGUJPgRBBj4ES+2W7zM0jD89aSP6kWc2e
         BvIMwJ7/7AXcnidt0AZFaXqPVFtkUYzm7mPRuWevhraqhEPMCzTr9k9Ow77Tp51fTrqW
         n1BVVbRZ7x9cIJKVz2HQigiFC+UQ+F1ur/2YZb22PeAGutJV/s2R8sUDuquA4YS+fY7W
         ltc644Cq9D/wjIDYVHQ0NLBzH0PKhUS2rInvbyKHKBixvRTSNK7fd1aJKstD5LEK8/pK
         AQFMPL1b5ZXu2RlvYqckjGYTzNk/ToKV5mtuE5Re0+yzwjXImyXqAUIk7iMnzv/y/Vb2
         vaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yml6pXAdz3mX8lJw9tffU2Xx/mgfV/pGnoNbX3i8nU4=;
        b=QxblR37REox1siO+TzYP6HsHmZVj4Ie8SUpshq2yoz/vpDQDMkIy27+tzp4vF7dL5q
         2aZN6OgCvjVFur09hLClKoj8AVWqhPbWCw0oyu+nntZ37N8e1rI5bfDHVfce76GxGAh/
         Ko+/Z3NlMwuW55GKYp3q8XKsoJzBdJhsKfy6+eHknAqWJh1z1hE48gVwG+s+CI3ZY+rc
         r5/4f+PxXV4oy/M4mCf0TvH10t2vS+Nt4nnvqHnouy9jD4+C8Q1WYbTdMzDp0sAoBDjc
         Y8xS3lB1K2kurivgAk9atVBSk1ZcrKOUZUhe7K7gFTJhqmfz9ZbVGdlKJzSOPqgowiAk
         gAbQ==
X-Gm-Message-State: APjAAAXo0cR86sv0dJ0LY/x/pwCixB+zsN8CoKZuE6uxEDtSF8YJqSLi
        ZRQwktwCJHdbxsXwAJJq99mR98kn
X-Google-Smtp-Source: APXvYqwzgPNZTrVo+PQW6T6nu13y8p9/3FDeTrQ3KanLcNJz+NWdUF5A8B13SmISagyCqI0qGmd9XQ==
X-Received: by 2002:a5d:4204:: with SMTP id n4mr12749009wrq.123.1578598545812;
        Thu, 09 Jan 2020 11:35:45 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id n16sm9690298wro.88.2020.01.09.11.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:45 -0800 (PST)
Subject: [PATCH net-next 11/15] r8169: use phy_read/write instead of
 rtl_readphy/writephy
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <f1b11d5e-d613-8549-2159-09df3dc120cc@gmail.com>
Date:   Thu, 9 Jan 2020 20:31:47 +0100
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

Replace rtl_writephy and rtl_readphy with the respective phylib
functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 107 +++++++++++-----------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 457c8cdec..595659c2b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2513,10 +2513,10 @@ static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
 				    struct phy_device *phydev)
 {
-	rtl_writephy(tp, 0x1f, 0x0001);
+	phy_write(phydev, 0x1f, 0x0001);
 	phy_set_bits(phydev, 0x16, BIT(0));
-	rtl_writephy(tp, 0x10, 0xf41b);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x10, 0xf41b);
+	phy_write(phydev, 0x1f, 0x0000);
 }
 
 static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp,
@@ -2671,15 +2671,16 @@ static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
 
 static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp, u16 val)
 {
+	struct phy_device *phydev = tp->phydev;
 	u16 reg_val;
 
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x001b);
-	reg_val = rtl_readphy(tp, 0x06);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0005);
+	phy_write(phydev, 0x05, 0x001b);
+	reg_val = phy_read(phydev, 0x06);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	if (reg_val != val)
-		netif_warn(tp, hw, tp->dev, "chipset not ready for firmware\n");
+		phydev_warn(phydev, "chipset not ready for firmware\n");
 	else
 		rtl_apply_firmware(tp);
 }
@@ -2693,7 +2694,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	 * Rx Error Issue
 	 * Fine Tune Switching regulator parameter
 	 */
-	rtl_writephy(tp, 0x1f, 0x0002);
+	phy_write(phydev, 0x1f, 0x0002);
 	phy_modify(phydev, 0x0b, 0x00ef, 0x0010);
 	phy_modify(phydev, 0x0c, 0x5d00, 0xa200);
 
@@ -2702,7 +2703,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 
 		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
 
-		val = rtl_readphy(tp, 0x0d);
+		val = phy_read(phydev, 0x0d);
 
 		if ((val & 0x00ff) != 0x006c) {
 			static const u32 set[] = {
@@ -2711,11 +2712,11 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 			};
 			int i;
 
-			rtl_writephy(tp, 0x1f, 0x0002);
+			phy_write(phydev, 0x1f, 0x0002);
 
 			val &= 0xff00;
 			for (i = 0; i < ARRAY_SIZE(set); i++)
-				rtl_writephy(tp, 0x0d, val | set[i]);
+				phy_write(phydev, 0x0d, val | set[i]);
 		}
 	} else {
 		phy_write_paged(phydev, 0x0002, 0x05, 0x6662);
@@ -2723,15 +2724,15 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	}
 
 	/* RSET couple improve */
-	rtl_writephy(tp, 0x1f, 0x0002);
+	phy_write(phydev, 0x1f, 0x0002);
 	phy_set_bits(phydev, 0x0d, 0x0300);
 	phy_set_bits(phydev, 0x0f, 0x0010);
 
 	/* Fine tune PLL performance */
-	rtl_writephy(tp, 0x1f, 0x0002);
+	phy_write(phydev, 0x1f, 0x0002);
 	phy_modify(phydev, 0x02, 0x0600, 0x0100);
 	phy_clear_bits(phydev, 0x03, 0xe000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	rtl8168d_apply_firmware_cond(tp, 0xbf00);
 }
@@ -2746,7 +2747,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 
 		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
 
-		val = rtl_readphy(tp, 0x0d);
+		val = phy_read(phydev, 0x0d);
 		if ((val & 0x00ff) != 0x006c) {
 			static const u32 set[] = {
 				0x0065, 0x0066, 0x0067, 0x0068,
@@ -2754,11 +2755,11 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 			};
 			int i;
 
-			rtl_writephy(tp, 0x1f, 0x0002);
+			phy_write(phydev, 0x1f, 0x0002);
 
 			val &= 0xff00;
 			for (i = 0; i < ARRAY_SIZE(set); i++)
-				rtl_writephy(tp, 0x0d, val | set[i]);
+				phy_write(phydev, 0x0d, val | set[i]);
 		}
 	} else {
 		phy_write_paged(phydev, 0x0002, 0x05, 0x2642);
@@ -2766,10 +2767,10 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 	}
 
 	/* Fine tune PLL performance */
-	rtl_writephy(tp, 0x1f, 0x0002);
+	phy_write(phydev, 0x1f, 0x0002);
 	phy_modify(phydev, 0x02, 0x0600, 0x0100);
 	phy_clear_bits(phydev, 0x03, 0xe000);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	/* Switching regulator Slew rate */
 	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0017);
@@ -2919,10 +2920,10 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 	r8168d_phy_param(phydev, 0x8b76, 0xffff, 0x8000);
 
 	/* For 4-corner performance improve */
-	rtl_writephy(tp, 0x1f, 0x0005);
-	rtl_writephy(tp, 0x05, 0x8b80);
+	phy_write(phydev, 0x1f, 0x0005);
+	phy_write(phydev, 0x05, 0x8b80);
 	phy_set_bits(phydev, 0x17, 0x0006);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	/* PHY auto speed down */
 	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
@@ -2937,10 +2938,10 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168f_config_eee_phy(phydev);
 
 	/* Green feature */
-	rtl_writephy(tp, 0x1f, 0x0003);
+	phy_write(phydev, 0x1f, 0x0003);
 	phy_set_bits(phydev, 0x19, BIT(0));
 	phy_set_bits(phydev, 0x10, BIT(10));
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0000);
 	phy_modify_paged(phydev, 0x0005, 0x01, 0, BIT(8));
 }
 
@@ -3036,10 +3037,10 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
 	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x8000);
 
 	/* Green feature */
-	rtl_writephy(tp, 0x1f, 0x0003);
+	phy_write(phydev, 0x1f, 0x0003);
 	phy_clear_bits(phydev, 0x19, BIT(0));
 	phy_clear_bits(phydev, 0x10, BIT(10));
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0000);
 }
 
 static void rtl8168g_disable_aldps(struct phy_device *phydev)
@@ -3088,16 +3089,16 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	/* Improve SWR Efficiency */
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	rtl_writephy(tp, 0x14, 0x5065);
-	rtl_writephy(tp, 0x14, 0xd065);
-	rtl_writephy(tp, 0x1f, 0x0bc8);
-	rtl_writephy(tp, 0x11, 0x5655);
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	rtl_writephy(tp, 0x14, 0x1065);
-	rtl_writephy(tp, 0x14, 0x9065);
-	rtl_writephy(tp, 0x14, 0x1065);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0bcd);
+	phy_write(phydev, 0x14, 0x5065);
+	phy_write(phydev, 0x14, 0xd065);
+	phy_write(phydev, 0x1f, 0x0bc8);
+	phy_write(phydev, 0x11, 0x5655);
+	phy_write(phydev, 0x1f, 0x0bcd);
+	phy_write(phydev, 0x14, 0x1065);
+	phy_write(phydev, 0x14, 0x9065);
+	phy_write(phydev, 0x14, 0x1065);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
@@ -3286,16 +3287,16 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
 	r8168g_phy_param(phydev, 0x80d7, 0xff00, 0x8400);
 
 	/* Force PWM-mode */
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	rtl_writephy(tp, 0x14, 0x5065);
-	rtl_writephy(tp, 0x14, 0xd065);
-	rtl_writephy(tp, 0x1f, 0x0bc8);
-	rtl_writephy(tp, 0x12, 0x00ed);
-	rtl_writephy(tp, 0x1f, 0x0bcd);
-	rtl_writephy(tp, 0x14, 0x1065);
-	rtl_writephy(tp, 0x14, 0x9065);
-	rtl_writephy(tp, 0x14, 0x1065);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0bcd);
+	phy_write(phydev, 0x14, 0x5065);
+	phy_write(phydev, 0x14, 0xd065);
+	phy_write(phydev, 0x1f, 0x0bc8);
+	phy_write(phydev, 0x12, 0x00ed);
+	phy_write(phydev, 0x1f, 0x0bcd);
+	phy_write(phydev, 0x14, 0x1065);
+	phy_write(phydev, 0x14, 0x9065);
+	phy_write(phydev, 0x14, 0x1065);
+	phy_write(phydev, 0x1f, 0x0000);
 
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
@@ -3380,10 +3381,10 @@ static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
 	rtl_apply_firmware(tp);
 
 	/* EEE setting */
-	rtl_writephy(tp, 0x1f, 0x0004);
-	rtl_writephy(tp, 0x10, 0x401f);
-	rtl_writephy(tp, 0x19, 0x7030);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	phy_write(phydev, 0x1f, 0x0004);
+	phy_write(phydev, 0x10, 0x401f);
+	phy_write(phydev, 0x19, 0x7030);
+	phy_write(phydev, 0x1f, 0x0000);
 }
 
 static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
@@ -4680,9 +4681,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_pcie_state_l2l3_disable(tp);
 
-	rtl_writephy(tp, 0x1f, 0x0c42);
-	rg_saw_cnt = (rtl_readphy(tp, 0x13) & 0x3fff);
-	rtl_writephy(tp, 0x1f, 0x0000);
+	rg_saw_cnt = phy_read_paged(tp->phydev, 0x0c42, 0x13) & 0x3fff;
 	if (rg_saw_cnt > 0) {
 		u16 sw_cnt_1ms_ini;
 
-- 
2.24.1


