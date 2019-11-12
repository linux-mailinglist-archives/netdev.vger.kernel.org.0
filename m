Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64656F9C3B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKLVZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:25:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42790 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLVZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:25:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so20143334wrf.9
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lhXbtTnVDS5IJUMpB5Oj2rwMSBp5mMVOSJLoNX8iIWU=;
        b=SeemqDuUOpNhNPAzj2mFtOPa3RwuMNNu47kCoJvqx2I6zu+sRs8pnifKXj8fd8hTQZ
         9K27RtKctjyWD51Yn9VlnkjfV4tpBRqBahMaO6QODKeYbb6aBnB5D7+0DZboV9vULE71
         5OWC4T7qUd3j3bJPV90LSyz4M1SQh7HE41w25Ktp5zYyXX3lEgvXAXccDzmOu+rjFqoN
         WmEb3RN36KMG6Yvv4jyampuOM/12EG3Hi7Yilf/ohwVVhgtaWQC0pjwaz719Mi5lhYfz
         k3yPh5tCnD3/LZBivb+ahESgiPVAWDN/GXHw25DMyv7AjUMk4Dct8UWHVUnku+zqKOTF
         M0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lhXbtTnVDS5IJUMpB5Oj2rwMSBp5mMVOSJLoNX8iIWU=;
        b=QKGaL2VqN8WnSGC466QrLrqd1XbdiVoBdlJwHjNFsI5RYb9mpPK3GmvYwRZMAQ24HR
         /YC3X9BOiHSDbC7drvuuM7YbxUjQy5jmfC7RkcA1IN7M/Hy7GmVRw95IbFsX3PkzhEbh
         CdzMveFJ1mijNEPx4LpIsBdwn0b9fU/UtZQXBMb30zqlffoD7VEQ6qY4YrrTAj9z9rkc
         uHwtXoBworP5MfxlFDYeVMh0XDFq0T30W878WKUscqAQ1G0RdHpvjSC9mRHuhVuMrVvY
         aSRN2OlFPSk3dqxIek3ZGhL0B7xOO6+K9MOfNHsdDmEkeh4LOTr7aN2sqzs/rSoSKpj+
         eXgg==
X-Gm-Message-State: APjAAAVs3EeAvcVHhoqwR2uNKAhfnc3JVkxvHC01jDa72tKdN6VTOkFh
        c7OV8Gh2+BFJ8XPkSSM90wtxdPiP
X-Google-Smtp-Source: APXvYqzAZaPC2kIneu13rG+p6i3XB8LlPA9n/nZhbAXZvvJuJkML5WNQDoGOXxy+pktriMbRlTCxpA==
X-Received: by 2002:adf:9527:: with SMTP id 36mr26723207wrs.398.1573593950280;
        Tue, 12 Nov 2019 13:25:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:7:bfb7:2ee9:e19? (p200300EA8F2D7D000007BFB72EE90E19.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:7:bfb7:2ee9:e19])
        by smtp.googlemail.com with ESMTPSA id y78sm6363365wmd.32.2019.11.12.13.25.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:25:49 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: use rtl821x_modify_extpage
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Message-ID: <2a191cbc-7f5b-43f5-85f7-3dbd406ea559@gmail.com>
Date:   Tue, 12 Nov 2019 22:24:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the "extended page" access function is exported by the
Realtek PHY driver we don't have to implement it too.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 40 +++++++++--------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c177837b9..785987aae 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/phy.h>
+#include <linux/realtek_phy.h>
 #include <linux/if_vlan.h>
 #include <linux/crc32.h>
 #include <linux/in.h>
@@ -1089,17 +1090,6 @@ static void rtl_w0w1_phy(struct rtl8169_private *tp, int reg_addr, int p, int m)
 	rtl_writephy(tp, reg_addr, (val & ~m) | p);
 }
 
-static void r8168d_modify_extpage(struct phy_device *phydev, int extpage,
-				  int reg, u16 mask, u16 val)
-{
-	int oldpage = phy_select_page(phydev, 0x0007);
-
-	__phy_write(phydev, 0x1e, extpage);
-	__phy_modify(phydev, reg, mask, val);
-
-	phy_restore_page(phydev, oldpage, 0);
-}
-
 static void r8168d_phy_param(struct phy_device *phydev, u16 parm,
 			     u16 mask, u16 val)
 {
@@ -2850,13 +2840,13 @@ static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp)
 
 	rtl_writephy_batch(tp, phy_reg_init);
 
-	r8168d_modify_extpage(tp->phydev, 0x0023, 0x16, 0xffff, 0x0000);
+	rtl821x_modify_extpage(tp->phydev, 0x0023, 0x16, 0xffff, 0x0000);
 }
 
 static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp)
 {
 	phy_write_paged(tp->phydev, 0x0001, 0x17, 0x0cc0);
-	r8168d_modify_extpage(tp->phydev, 0x002d, 0x18, 0xffff, 0x0040);
+	rtl821x_modify_extpage(tp->phydev, 0x002d, 0x18, 0xffff, 0x0040);
 	phy_set_bits(tp->phydev, 0x0d, BIT(5));
 }
 
@@ -2882,24 +2872,24 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy_batch(tp, phy_reg_init);
 
 	/* Update PFM & 10M TX idle timer */
-	r8168d_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
+	rtl821x_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
 
-	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+	rtl821x_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
 
 	/* DCO enable for 10M IDLE Power */
-	r8168d_modify_extpage(phydev, 0x0023, 0x17, 0x0000, 0x0006);
+	rtl821x_modify_extpage(phydev, 0x0023, 0x17, 0x0000, 0x0006);
 
 	/* For impedance matching */
 	phy_modify_paged(phydev, 0x0002, 0x08, 0x7f00, 0x8000);
 
 	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0050);
+	rtl821x_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0050);
 	phy_set_bits(phydev, 0x14, BIT(15));
 
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 	r8168d_phy_param(phydev, 0x8b85, 0x2000, 0x0000);
 
-	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0x1100, 0x0000);
+	rtl821x_modify_extpage(phydev, 0x0020, 0x15, 0x1100, 0x0000);
 	phy_write_paged(phydev, 0x0006, 0x00, 0x5a00);
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
@@ -2926,7 +2916,7 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_apply_firmware(tp);
 
 	/* Enable Delay cap */
-	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+	rtl821x_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
 
 	/* Channel estimation fine tune */
 	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
@@ -2943,7 +2933,7 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	rtl821x_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
 	phy_set_bits(phydev, 0x14, BIT(15));
 
 	/* improve 10M EEE waveform */
@@ -2976,7 +2966,7 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
 
 	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	rtl821x_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
 	phy_set_bits(phydev, 0x14, BIT(15));
 
 	/* Improve 10M EEE waveform */
@@ -3000,8 +2990,8 @@ static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00fb);
+	rtl821x_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	rtl821x_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00fb);
 
 	/* Modify green table for 10M */
 	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
@@ -3041,8 +3031,8 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp)
 	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
 	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00aa);
+	rtl821x_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	rtl821x_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00aa);
 
 	/* Modify green table for 10M */
 	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
-- 
2.24.0


