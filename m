Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D91D2F096B
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbhAJTvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJTvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:51:51 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D05AC061794
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:10 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m5so14279100wrx.9
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dmg6OWJn2j9OEnjloodqETRWHNBteqRgpFZfdHMZr9w=;
        b=ZWF7pJo30vMu56FJ2DzFR5fC9Zc4DTyrdpKBfvDYR/NFwEPSeg72UUJkyK7XAGM0VD
         TQKAU2G/8ZEaDQgH8MZdb5qFmBEn33IsTzmn3Pb+zN7zaKwhXa+xvDWtcSW8cc4LnBbk
         2mW5cF+YWMjsGAhp4ZN5hx4J64EKNA7P2jQxc162MfXkDYoVU5NwrG58A1YUp3MHtYFD
         AXeZWGYA5h6hbTY3jKtS0KjrJjVkdEzhXBheXNNjQvFZi+npUOdDiuIHGS4Nl+5LftDW
         4ucMT3+QHWyVbY3ScsHiYiW7d9qTamXotLTlOsbFQn9RXgtZX26S5xDt6MMqBUx1GVRr
         A+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dmg6OWJn2j9OEnjloodqETRWHNBteqRgpFZfdHMZr9w=;
        b=TKoL9ERwlKBtlKd1D1vwzd9LEma5VXeDorLsWRatmpZSLiWCztr5eWh4VWA0fNOZEn
         Hx0OAdBA32MwFoQ8RqRBbE5D4IBULnV+qKY5ePayeEA2ykVH9gzmM2oWGiRHzyw/2/nc
         N2VJcrWcoGeEUAXbYfkVykBgrTZxkEPdNWUMCsJjU0lJ3q/xRkMbCezDB/A3aMARytcx
         pFpcF98jJi4Soo2NF/l+2TVH+bXUWGEuZzgG0m8aYeehpDWP/dmqCe77gHmBxoK/MzzV
         vksXZWhnfO/tIaB4t7ZwJH89Jzth8R7ApgDGfz39YE9Nmtq102vVngD6BC74ch+FEBjG
         ndpw==
X-Gm-Message-State: AOAM531XzH0470e3UDR3IVeKh0jpZ28LLwQlDhgzNt6ER1mlAVmSNEb/
        4/H2qNfoHIYBnxke9tHEAd4OU0j3zVI=
X-Google-Smtp-Source: ABdhPJyWx80oGUJrtvcGljkEhEj99kLNmsYeh8VhNbpYEl3TBCzmcdqyX3cssofh9NmHDUkDXMpaYw==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr12781592wrw.188.1610308268922;
        Sun, 10 Jan 2021 11:51:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5449:e139:28a3:e114? (p200300ea8f0655005449e13928a3e114.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5449:e139:28a3:e114])
        by smtp.googlemail.com with ESMTPSA id f14sm21765682wre.69.2021.01.10.11.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 11:51:08 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: improve handling D3 PLL power-down
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Message-ID: <a65f5e07-f676-7b16-07ff-f4d2ff8931bf@gmail.com>
Date:   Sun, 10 Jan 2021 20:50:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek provided a description of bits 6 and 7 in register PMCH.
They configure whether the chip powers down certain PLL in D3hot and
D3cold respectively. They do not actually power down the PLL.
Reflect this in the code and configure D3 PLL powerdown based on
whether WOL is enabled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 51 ++++++++++-------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c87fb9f1..64fdc168f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -261,6 +261,9 @@ enum rtl8168_8101_registers {
 #define	CSIAR_BYTE_ENABLE		0x0000f000
 #define	CSIAR_ADDR_MASK			0x00000fff
 	PMCH			= 0x6f,
+#define D3COLD_NO_PLL_DOWN		BIT(7)
+#define D3HOT_NO_PLL_DOWN		BIT(6)
+#define D3_NO_PLL_DOWN			(BIT(7) | BIT(6))
 	EPHYAR			= 0x80,
 #define	EPHYAR_FLAG			0x80000000
 #define	EPHYAR_WRITE_CMD		0x80000000
@@ -1250,6 +1253,22 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
+		if (enable)
+			RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~D3_NO_PLL_DOWN);
+		else
+			RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | D3_NO_PLL_DOWN);
+		break;
+	default:
+		break;
+	}
+}
+
 static void rtl_reset_packet_filter(struct rtl8169_private *tp)
 {
 	rtl_eri_clear_bits(tp, 0xdc, BIT(0));
@@ -1416,6 +1435,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
+	rtl_set_d3_pll_down(tp, !wolopts);
 	tp->dev->wol_enabled = wolopts ? 1 : 0;
 }
 
@@ -2221,37 +2241,11 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	if (device_may_wakeup(tp_to_dev(tp))) {
 		phy_speed_down(tp->phydev, false);
 		rtl_wol_suspend_quirk(tp);
-		return;
-	}
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
-	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
-		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
-		break;
-	default:
-		break;
 	}
 }
 
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
-	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39:
-	case RTL_GIGA_MAC_VER_43:
-		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0x80);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
-	case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_63:
-		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
-		break;
-	default:
-		break;
-	}
-
 	phy_resume(tp->phydev);
 }
 
@@ -5330,6 +5324,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
 
+	rtl_set_d3_pll_down(tp, true);
+
 	jumbo_max = rtl_jumbo_max(tp);
 	if (jumbo_max)
 		dev->max_mtu = jumbo_max;
@@ -5350,9 +5346,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* chip gets powered up in rtl_open() */
-	rtl_pll_power_down(tp);
-
 	rc = register_netdev(dev);
 	if (rc)
 		return rc;
-- 
2.30.0


