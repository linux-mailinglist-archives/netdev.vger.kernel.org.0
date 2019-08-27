Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7089C9F291
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfH0SnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:43:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33171 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbfH0SnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:43:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so19841428wrr.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j1UgRSlhb6HTBhPmaRkIWa1tEAnHMGqqYaxFTlP/M1s=;
        b=X/MZFdC7uDgHNhfYVYTlVVWzTME1uIzxlcdOpQ9jjjUj/O8WmUIhk8LBBjKrjcCQVc
         AdnVNLmIRTtMtm8mKmgVCmbubsajRMKbdFLbdphuQbPlbT1PwzR9vOt4uUZgzl6U8+za
         NPRd/r5my1y0Qv4MXNDZcW4+O5CXfkT1Zf1vHKe9sKTLXnk4NBNiKCf0BWTx/S37P7vS
         VZtM6GQp29DKgAJP/yXWQCBOmvC1Vuqabeap84D0ibUuYTL8xwFcU4TI9K4wZNTZq5fL
         0A5GFWcvLowup9i5OMYjSF+Qxof0pmjaLZD4eV1rj60MvPlB8Wi9IK44wPwUxXW7u2/o
         biqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j1UgRSlhb6HTBhPmaRkIWa1tEAnHMGqqYaxFTlP/M1s=;
        b=hn14wYdZqNf1l1P/wyNWWp0IC/UpnMKoCoS8efOkSq0YhRB5YkSm9Kb9pP3WZqUV0u
         GxvWd/Rlo4L3THwvoLhwM1w3OZWCPbHamjI/fOjYcxjg6YFxFMJgds/PbxClsSj/LvsQ
         cEQXKZ0CsS0a1ZsnlL6cC2NlWpUxaF5iqcI9gJTIM+YcAZFC3+wtiI1UtNX7V5j5jNk8
         m/cOfVR2uTNgEAMxnt078TP4X8vhscH9aMN+tus942ruxiUUXDbuvxCwgGmWFY8insUL
         WB65r5MNSW/EggilS+IMwfnpmNJq7lue0batPTtDVYcC08lbO4uZ0ApVYilZKg/kGhPS
         X3sw==
X-Gm-Message-State: APjAAAVt6t78xn3yzvVRxhtHFucnkLVIBED7zub0/0mAvo+JEJ0fucrE
        /4BvY79ELrU3W/dVceFlwL0=
X-Google-Smtp-Source: APXvYqx5aMLjC4GzfZYMtsdnh6spJZgm0ZmDbLqyfKfAJ91/wccUr/1aM+RYysRqTQVXqPjrEi3c2w==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr31112461wrv.299.1566931386482;
        Tue, 27 Aug 2019 11:43:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id d17sm2405977wre.27.2019.08.27.11.43.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:43:06 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: add RTL8125 PHY initialization
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
Message-ID: <3b4b5e0a-b112-1823-7f6c-4dac57413387@gmail.com>
Date:   Tue, 27 Aug 2019 20:42:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
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
index e7e953b7c..d9adc45fa 100644
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


