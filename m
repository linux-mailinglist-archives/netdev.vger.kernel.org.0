Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AE72F042D
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbhAIWyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIWyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:54:12 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BB6C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:53:32 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 190so10650280wmz.0
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K9gHEz8IHKtBbNaZOSh8MP8yyWwnWmopWLSOb9gR2xk=;
        b=W6A8MnhpnmL1BwHvvLAIJwlZOL8HAe3jwsP/rMtCeUJ+HbvSAkxSJdZdgRlMgaclG4
         mzooDGeaRc8EXOlCcEEjmdQI94MuUXuhEdTjT7zqky1vaurRARWbz/MeCFU9gOH/rag9
         kOs3QrD5vJCuc3pd+Pbya+Gul88qrvso4fZS1ps8HXyC8A40a8lVeKsejOKg8BloB17n
         rgbWOFNlgDtNCJQqfK+TF2ajKTS/1WUAaRcFnSAvltAAVTUm2bOK8+nWf5RRa+EAlrYE
         f+cJpXJxq2JQZQ16D0SHTIhfiRV7SPkYoAQ3oPIkDwC1m2umu/QnlxrB2qLI8ae0MR7v
         /kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K9gHEz8IHKtBbNaZOSh8MP8yyWwnWmopWLSOb9gR2xk=;
        b=Lm+FD3YHvwAsQBysH+Q/pN4QiEYjmRj0Ry/N6uKbhv1gkthqM8nSm0+P4B93XzQzJ9
         N79p4qYuAO4nGq9FzN/nmQtdVpdxVCIbDbWOBu654PUapEj1b4Olafe/esHqLr3YxIpp
         OWewRDGTJ6DqYv/I+wQxOH727kyTb5J5uM7Od3/fFwZT+C6wFMSwRqzonMyqXll0Bu2V
         tXDrp5r/UaX0heob7Cg2Wzxj1vxi6ZchxVzP/kWCmrpADK3OsB8Y6eH13EIVE26/vu/j
         lfvEtAN3BGN91wSaBoetk8NEQV2mGlZaIVRfjA2A2IHWwOMY/pm1S7r/mdHONi/etHaV
         CZAQ==
X-Gm-Message-State: AOAM530hr37bUgBGeSvdWp+Je15Ng95SbUnfGeEh8cvei43R96JgndOI
        QxQN9WdT8AxurNFbftJgUE2PHkaYWKA=
X-Google-Smtp-Source: ABdhPJzAzaC+avszbP4yxcYNGTjMQQiUcC97IzJD4v2gxwqotEW/JREjOitRKgTpYhBSt9ncnvxV2g==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr8690319wmg.125.1610232810996;
        Sat, 09 Jan 2021 14:53:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a584:5efe:3c65:46c1? (p200300ea8f065500a5845efe3c6546c1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a584:5efe:3c65:46c1])
        by smtp.googlemail.com with ESMTPSA id j13sm16344930wmi.36.2021.01.09.14.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 14:53:30 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: make use of the unaligned access helpers
Message-ID: <cfaf9176-e4f9-c32d-4d4d-e8fb52009f35@gmail.com>
Date:   Sat, 9 Jan 2021 23:53:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding unaligned access let's use the predefined
unaligned access helpers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 35 +++++++++--------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c1ca1337a..c199d8a51 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -28,6 +28,7 @@
 #include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
+#include <asm/unaligned.h>
 #include <net/ip6_checksum.h>
 
 #include "r8169.h"
@@ -2074,18 +2075,12 @@ static void rtl8125b_config_eee_mac(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xe040, 0, BIT(1) | BIT(0));
 }
 
-static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
+static void rtl_rar_exgmac_set(struct rtl8169_private *tp, const u8 *addr)
 {
-	const u16 w[] = {
-		addr[0] | (addr[1] << 8),
-		addr[2] | (addr[3] << 8),
-		addr[4] | (addr[5] << 8)
-	};
-
-	rtl_eri_write(tp, 0xe0, ERIAR_MASK_1111, w[0] | (w[1] << 16));
-	rtl_eri_write(tp, 0xe4, ERIAR_MASK_1111, w[2]);
-	rtl_eri_write(tp, 0xf0, ERIAR_MASK_1111, w[0] << 16);
-	rtl_eri_write(tp, 0xf4, ERIAR_MASK_1111, w[1] | (w[2] << 16));
+	rtl_eri_write(tp, 0xe0, ERIAR_MASK_1111, get_unaligned_le32(addr));
+	rtl_eri_write(tp, 0xe4, ERIAR_MASK_1111, get_unaligned_le16(addr + 4));
+	rtl_eri_write(tp, 0xf0, ERIAR_MASK_1111, get_unaligned_le16(addr) << 16);
+	rtl_eri_write(tp, 0xf4, ERIAR_MASK_1111, get_unaligned_le32(addr + 2));
 }
 
 u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
@@ -2135,14 +2130,14 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
 	genphy_soft_reset(tp->phydev);
 }
 
-static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
+static void rtl_rar_set(struct rtl8169_private *tp, const u8 *addr)
 {
 	rtl_unlock_config_regs(tp);
 
-	RTL_W32(tp, MAC4, addr[4] | addr[5] << 8);
+	RTL_W32(tp, MAC4, get_unaligned_le16(addr + 4));
 	rtl_pci_commit(tp);
 
-	RTL_W32(tp, MAC0, addr[0] | addr[1] << 8 | addr[2] << 16 | addr[3] << 24);
+	RTL_W32(tp, MAC0, get_unaligned_le32(addr));
 	rtl_pci_commit(tp);
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_34)
@@ -4965,16 +4960,12 @@ static void rtl_read_mac_address(struct rtl8169_private *tp,
 {
 	/* Get MAC address */
 	if (rtl_is_8168evl_up(tp) && tp->mac_version != RTL_GIGA_MAC_VER_34) {
-		u32 value = rtl_eri_read(tp, 0xe0);
-
-		mac_addr[0] = (value >>  0) & 0xff;
-		mac_addr[1] = (value >>  8) & 0xff;
-		mac_addr[2] = (value >> 16) & 0xff;
-		mac_addr[3] = (value >> 24) & 0xff;
+		u32 value;
 
+		value = rtl_eri_read(tp, 0xe0);
+		put_unaligned_le32(value, mac_addr);
 		value = rtl_eri_read(tp, 0xe4);
-		mac_addr[4] = (value >>  0) & 0xff;
-		mac_addr[5] = (value >>  8) & 0xff;
+		put_unaligned_le16(value, mac_addr + 4);
 	} else if (rtl_is_8125(tp)) {
 		rtl_read_mac_from_reg(tp, mac_addr, MAC0_BKP);
 	}
-- 
2.29.2

