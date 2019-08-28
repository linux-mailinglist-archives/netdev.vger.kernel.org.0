Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BEA0B87
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfH1U3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37345 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbfH1U3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so1118946wrt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=riqi5MR+tqkFqhRuQExHa0xRub2TLb+K8OW8HWrcsdk=;
        b=tr6MlCF3RqYlJppbDB51tpICB5z/uwBItN7ZB4ke3VH7xsrsC2cQuKYWiJbhAqktdc
         xwT+XiDb2L5Bpf7OV2hqnYldoFHkvXaCcOpbJTfWb2f/GHudrgb50zHY1et548gTnAnt
         B4vW87cwg1aMlbA+X25isS7N4u/j+fxie7UFzL+oYKhDfZ3+iqVQWWc8REr9gxG4IJW+
         l73zVV8315bUGlbjvJedNOxnuXFg1x61XSP20N+oSACqc9bjUTVW58JabAFslB7x2/KK
         04Kv1tVBv7o7lcsrynXyBqUDywC8tcTzbVzxrQ5xqUtxYp6/fOffX1k5LdkSZo4pBGDP
         KIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riqi5MR+tqkFqhRuQExHa0xRub2TLb+K8OW8HWrcsdk=;
        b=tVHv/3Ra19QPYkpJl46XQlvxMId2etrG3IJGBt7EC/A12GCKSTXsdMWcx9Yq4jIqIc
         zKRlk1apWIe2GXaxH8pwVRE4qP3+MohLPsm83HraZs00wSw2SSxX3v2tIKV/Q4ZiVRIB
         3HMi2cG7RSXtPGU83IlUPdbtIcjWf2CHAhlv9kT6FO9vu5z41QsrCUT88koU1Yo7UZJ6
         JEZm42dUpIerq/TqE7iK/mJgtBDkYNo1CTow9ObBR3K1532m9+qZQOg6J8ViA9G2dH2d
         fOUzVAFCWhqK/C1f1sJG6lu7OsKciddiAMKYc3V6sxp6G/cMzTylMJ5z/QFkujGz3AX/
         RMmg==
X-Gm-Message-State: APjAAAXdhBAjPA92s70mELVD+vP695eA/m5DSDOUL0gJvWs06fR4EpMS
        Xy02nA/HSUAtfHAZndYJKpowMOgM
X-Google-Smtp-Source: APXvYqzeWjTp5FXK8SWtn9SvpPS1VMOv+jOFDjwkIWmhftk6iyHiZ5YD7BeHbIxKPBMJg6Ubfx/JZA==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr7319126wrs.56.1567024172226;
        Wed, 28 Aug 2019 13:29:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id w8sm10906290wmc.1.2019.08.28.13.29.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:31 -0700 (PDT)
Subject: [PATCH net-next v2 8/9] r8169: add RTL8125 PHY initialization
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <df381d8c-fcca-a024-b914-9d0d79753f87@gmail.com>
Date:   Wed, 28 Aug 2019 22:28:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds PHY initialization magic copied from the r8125 vendor
driver. In addition it supports loading the firmware for chip version
RTL_GIGA_MAC_VER_61.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 130 +++++++++++++++++++++-
 1 file changed, 127 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4d1779e39..99176a9a8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -55,6 +55,7 @@
 #define FIRMWARE_8168H_2	"rtl_nic/rtl8168h-2.fw"
 #define FIRMWARE_8107E_1	"rtl_nic/rtl8107e-1.fw"
 #define FIRMWARE_8107E_2	"rtl_nic/rtl8107e-2.fw"
+#define FIRMWARE_8125A_3	"rtl_nic/rtl8125a-3.fw"
 
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
@@ -203,7 +204,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
-	[RTL_GIGA_MAC_VER_61] = {"RTL8125"				},
+	[RTL_GIGA_MAC_VER_61] = {"RTL8125",		FIRMWARE_8125A_3},
 };
 
 static const struct pci_device_id rtl8169_pci_tbl[] = {
@@ -714,6 +715,7 @@ MODULE_FIRMWARE(FIRMWARE_8168H_1);
 MODULE_FIRMWARE(FIRMWARE_8168H_2);
 MODULE_FIRMWARE(FIRMWARE_8107E_1);
 MODULE_FIRMWARE(FIRMWARE_8107E_2);
+MODULE_FIRMWARE(FIRMWARE_8125A_3);
 
 static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 {
@@ -3619,6 +3621,128 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp)
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 }
 
+static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+
+	phy_modify_paged(phydev, 0xad4, 0x10, 0x03ff, 0x0084);
+	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
+	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x0006);
+	phy_modify_paged(phydev, 0xad3, 0x11, 0x003f, 0x0006);
+	phy_modify_paged(phydev, 0xac0, 0x14, 0x0000, 0x1100);
+	phy_modify_paged(phydev, 0xac8, 0x15, 0xf000, 0x7000);
+	phy_modify_paged(phydev, 0xad1, 0x14, 0x0000, 0x0400);
+	phy_modify_paged(phydev, 0xad1, 0x15, 0x0000, 0x03ff);
+	phy_modify_paged(phydev, 0xad1, 0x16, 0x0000, 0x03ff);
+
+	phy_write(phydev, 0x1f, 0x0a43);
+	phy_write(phydev, 0x13, 0x80ea);
+	phy_modify(phydev, 0x14, 0xff00, 0xc400);
+	phy_write(phydev, 0x13, 0x80eb);
+	phy_modify(phydev, 0x14, 0x0700, 0x0300);
+	phy_write(phydev, 0x13, 0x80f8);
+	phy_modify(phydev, 0x14, 0xff00, 0x1c00);
+	phy_write(phydev, 0x13, 0x80f1);
+	phy_modify(phydev, 0x14, 0xff00, 0x3000);
+	phy_write(phydev, 0x13, 0x80fe);
+	phy_modify(phydev, 0x14, 0xff00, 0xa500);
+	phy_write(phydev, 0x13, 0x8102);
+	phy_modify(phydev, 0x14, 0xff00, 0x5000);
+	phy_write(phydev, 0x13, 0x8105);
+	phy_modify(phydev, 0x14, 0xff00, 0x3300);
+	phy_write(phydev, 0x13, 0x8100);
+	phy_modify(phydev, 0x14, 0xff00, 0x7000);
+	phy_write(phydev, 0x13, 0x8104);
+	phy_modify(phydev, 0x14, 0xff00, 0xf000);
+	phy_write(phydev, 0x13, 0x8106);
+	phy_modify(phydev, 0x14, 0xff00, 0x6500);
+	phy_write(phydev, 0x13, 0x80dc);
+	phy_modify(phydev, 0x14, 0xff00, 0xed00);
+	phy_write(phydev, 0x13, 0x80df);
+	phy_set_bits(phydev, 0x14, BIT(8));
+	phy_write(phydev, 0x13, 0x80e1);
+	phy_clear_bits(phydev, 0x14, BIT(8));
+	phy_write(phydev, 0x1f, 0x0000);
+
+	phy_modify_paged(phydev, 0xbf0, 0x13, 0x003f, 0x0038);
+	phy_write_paged(phydev, 0xa43, 0x13, 0x819f);
+	phy_write_paged(phydev, 0xa43, 0x14, 0xd0b6);
+
+	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
+	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
+	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
+	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+}
+
+static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+	int i;
+
+	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
+	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x03ff);
+	phy_modify_paged(phydev, 0xad3, 0x11, 0x003f, 0x0006);
+	phy_modify_paged(phydev, 0xac0, 0x14, 0x1100, 0x0000);
+	phy_modify_paged(phydev, 0xacc, 0x10, 0x0003, 0x0002);
+	phy_modify_paged(phydev, 0xad4, 0x10, 0x00e7, 0x0044);
+	phy_modify_paged(phydev, 0xac1, 0x12, 0x0080, 0x0000);
+	phy_modify_paged(phydev, 0xac8, 0x10, 0x0300, 0x0000);
+	phy_modify_paged(phydev, 0xac5, 0x17, 0x0007, 0x0002);
+	phy_write_paged(phydev, 0xad4, 0x16, 0x00a8);
+	phy_write_paged(phydev, 0xac5, 0x16, 0x01ff);
+	phy_modify_paged(phydev, 0xac8, 0x15, 0x00f0, 0x0030);
+
+	phy_write(phydev, 0x1f, 0x0b87);
+	phy_write(phydev, 0x16, 0x80a2);
+	phy_write(phydev, 0x17, 0x0153);
+	phy_write(phydev, 0x16, 0x809c);
+	phy_write(phydev, 0x17, 0x0153);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	phy_write(phydev, 0x1f, 0x0a43);
+	phy_write(phydev, 0x13, 0x81B3);
+	phy_write(phydev, 0x14, 0x0043);
+	phy_write(phydev, 0x14, 0x00A7);
+	phy_write(phydev, 0x14, 0x00D6);
+	phy_write(phydev, 0x14, 0x00EC);
+	phy_write(phydev, 0x14, 0x00F6);
+	phy_write(phydev, 0x14, 0x00FB);
+	phy_write(phydev, 0x14, 0x00FD);
+	phy_write(phydev, 0x14, 0x00FF);
+	phy_write(phydev, 0x14, 0x00BB);
+	phy_write(phydev, 0x14, 0x0058);
+	phy_write(phydev, 0x14, 0x0029);
+	phy_write(phydev, 0x14, 0x0013);
+	phy_write(phydev, 0x14, 0x0009);
+	phy_write(phydev, 0x14, 0x0004);
+	phy_write(phydev, 0x14, 0x0002);
+	for (i = 0; i < 25; i++)
+		phy_write(phydev, 0x14, 0x0000);
+
+	phy_write(phydev, 0x13, 0x8257);
+	phy_write(phydev, 0x14, 0x020F);
+
+	phy_write(phydev, 0x13, 0x80EA);
+	phy_write(phydev, 0x14, 0x7843);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	rtl_apply_firmware(tp);
+
+	phy_modify_paged(phydev, 0xd06, 0x14, 0x0000, 0x2000);
+
+	phy_write(phydev, 0x1f, 0x0a43);
+	phy_write(phydev, 0x13, 0x81a2);
+	phy_set_bits(phydev, 0x14, BIT(8));
+	phy_write(phydev, 0x1f, 0x0000);
+
+	phy_modify_paged(phydev, 0xb54, 0x16, 0xff00, 0xdb00);
+	phy_modify_paged(phydev, 0xa45, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa5d, 0x12, 0x0000, 0x0020);
+	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
+	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+}
+
 static void rtl_hw_phy_config(struct net_device *dev)
 {
 	static const rtl_generic_fct phy_configs[] = {
@@ -3674,8 +3798,8 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_60] = NULL,
-		[RTL_GIGA_MAC_VER_61] = NULL,
+		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
 	};
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-- 
2.23.0


