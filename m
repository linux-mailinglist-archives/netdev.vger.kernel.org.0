Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F192EBCB2
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbhAFKul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAFKuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:50:40 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EE2C06134D
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 02:50:00 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r4so2210811wmh.5
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 02:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OzrWtwD329kfifIWHgcYNhGhf/dx4oIAVUb+Kkcmpc0=;
        b=Fm6Y2ErHHzEYWvowMU3Rlycdr6WGKM18Y1x/OPNzEqHzMyqRJl1SvZM5xdmzXV8pGi
         ok46rjzS5Nm9YVcdBzSajZikb5ZMpkjVYhs4LoMVhPA62oscx50wiOwf+8j1OsuLQi3t
         Qu6ghQpbm7FEWKmAW8r+GkUmVdtmBQkHwDsO1XZipkgXC/mWXNSQq/iLlb5b1jgQJd9E
         hGSteZeUoSVb8GJSHH7oW88vt6TmStpalEe6k0eF8yWG7aMn+e22PuCmYs49R9ZS++8i
         MRhX+5QSPn77BQbSQfRfrqv9ecIrusSrfhOYUYSlpeqjctMB8Pgf78FfYdJlIzcEFTAf
         /Q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzrWtwD329kfifIWHgcYNhGhf/dx4oIAVUb+Kkcmpc0=;
        b=OhwNeYjJTemddVHhALBrDLMDfq3WalFjMYf77nQglDtfCcjqPiCiFSBS5W7Sc5G0FC
         GA2BHw8M0MpWcW26LleQ8RPTbxK1zj6dfw4/aZKIUHDF6ccFnv+Y/5rnMZKxe8QNdswQ
         8HiAHRU4H5faIj8LOoJWZxM732ZSjM3KwpSWUUTMeeVNavdtXqfA5ZnfwaIOBLk7QXKN
         bWGnrGlzX9sflsWV1sHfKfrAGGDY5gg/Te/b1SGzgh1a5QUZgKsMOPgp5mq4HU+SYor3
         Tmsbvh26uuumGnopyOuYUsjOEE5O0kq/3vZtjeLVGsTUM/Nb7YrSmsbTXsMXkgQHOAUG
         aeYg==
X-Gm-Message-State: AOAM531pFaj8ycWArIqhjU4ThQdawW8lxRYfvx2i0aHJ9yCtouXJAGGg
        Scsd+6eM/epMDaCcGB9P0dng0eFztj8=
X-Google-Smtp-Source: ABdhPJxNo5kcqrwMPOgKxq51dbUVPtRAMlPaaOZHJkVOVCSlpcyZE8AuNUZ/IZ1Jy9xqRf5OFVod0g==
X-Received: by 2002:a7b:cf08:: with SMTP id l8mr3169992wmg.189.1609930198895;
        Wed, 06 Jan 2021 02:49:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id s133sm2507402wmf.38.2021.01.06.02.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:49:58 -0800 (PST)
Subject: [PATCH net-next 2/2] r8169: improve RTL8168g PHY suspend quirk
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
Message-ID: <e7e99e0e-b684-f83c-de72-1764618af1c3@gmail.com>
Date:   Wed, 6 Jan 2021 11:49:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Realtek the ERI register 0x1a8 quirk is needed to work
around a hw issue with the PHY on RTL8168g. The register needs to be
changed before powering down the PHY. Currently we don't meet this
requirement, however I'm not aware of any problems caused by this.
Therefore I see the change as an improvement.

The PHY driver has no means to access the chip ERI registers,
therefore we have to intercept MDIO writes to BMCR register.
If the BMCR_PDOWN bit is going to be set, then let's apply the
quirk before actually powering down the PHY.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 52 +++++++++++------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dd56f33b2..a8284feb4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -872,6 +872,25 @@ static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
 	r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
 }
 
+/* Work around a hw issue with RTL8168g PHY, the quirk disables
+ * PHY MCU interrupts before PHY power-down.
+ */
+static void rtl8168g_phy_suspend_quirk(struct rtl8169_private *tp, int value)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_40:
+	case RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_49:
+		if (value & BMCR_RESET || !(value & BMCR_PDOWN))
+			rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
+		else
+			rtl_eri_clear_bits(tp, 0x1a8, 0xfc000000);
+		break;
+	default:
+		break;
+	}
+};
+
 static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
 {
 	if (reg == 0x1f) {
@@ -882,6 +901,9 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
 	if (tp->ocp_base != OCP_STD_PHY_BASE)
 		reg -= 0x10;
 
+	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
+		rtl8168g_phy_suspend_quirk(tp, value);
+
 	r8168_phy_ocp_write(tp, tp->ocp_base + reg * 2, value);
 }
 
@@ -2210,20 +2232,8 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39:
-	case RTL_GIGA_MAC_VER_43:
-	case RTL_GIGA_MAC_VER_44:
-	case RTL_GIGA_MAC_VER_45:
-	case RTL_GIGA_MAC_VER_46:
-	case RTL_GIGA_MAC_VER_47:
-	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
-		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
-		break;
-	case RTL_GIGA_MAC_VER_40:
-	case RTL_GIGA_MAC_VER_41:
-	case RTL_GIGA_MAC_VER_49:
-		rtl_eri_clear_bits(tp, 0x1a8, 0xfc000000);
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_43 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	default:
@@ -2241,19 +2251,9 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_43:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0x80);
 		break;
-	case RTL_GIGA_MAC_VER_44:
-	case RTL_GIGA_MAC_VER_45:
-	case RTL_GIGA_MAC_VER_46:
-	case RTL_GIGA_MAC_VER_47:
-	case RTL_GIGA_MAC_VER_48:
-	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_63:
-		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
-		break;
-	case RTL_GIGA_MAC_VER_40:
-	case RTL_GIGA_MAC_VER_41:
-	case RTL_GIGA_MAC_VER_49:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
-		rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
 		break;
 	default:
 		break;
-- 
2.30.0


