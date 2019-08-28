Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E2A0B88
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfH1U3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39679 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfH1U3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id n2so42493wmk.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfo7dcRrfMqsJOD9wbmhoG1nvGt3A1BKQEcCALV7Lo0=;
        b=Rh9HS5CIpKgOQeDKhvcCXjKHGpjopbQ/K2qufik0A+Bh6iOLiu0vDo4yHqCwiXcAx/
         HOnSnpabKp9JUhkeNUArIohIjFUqqxr84it3w0iezR48LxnIh3F8F59iOxvyMZo6OjPG
         zaQjg8tvpbRCsArdEJe39/PJ5Hu+io104pk5aRz2ry6YnR+w78s16xsCZgBu6RvXXlJu
         7w/oRfemCp9Bh2oWom2N6tAvONP0zbyZFJ0QHJvFGf+EG94mWxDO4LjhkvXzHfUMIkpS
         2Fn0VfC5l02eHEQthSDM5Cxjve3chkC8grtaW6mk4qrx/njwsVu8QZnGmEGCUZn1dCov
         Ao0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfo7dcRrfMqsJOD9wbmhoG1nvGt3A1BKQEcCALV7Lo0=;
        b=q/a069TTwZFbGRfplAfM2R590H0IY/SiiZydc5axXPpJjQG8QAjjDgRP/MvLYWajsK
         +WmtxYCON2G8i+lfE6aJQUGrzrBhI/oohswdp6HjYUzIU/kYHrl6/fJbJRvd7rZqc17s
         gjZ1uAQnlkhpbVHwxJC/I+ebnLt1snXb+yIvrsE4UGg3fMGRueQQI60Nbr2E5D7/DEVE
         fkTVb1B1g37IpqI0OEAyaonpSbVM0pnn031saC1jFe5yocRFfH3P0ezyHKR3shRR83Pc
         eeZqGGXyqma+A3x/tnMSEik8ybO/4VEbfIh+ztJikASSPQ0Mgkf1dxG42hc2MO8sSBw5
         sqvA==
X-Gm-Message-State: APjAAAU779639F+br/M/HxBzm3IU6mwPiw8y0CZQeUV7lMbPFKweGVsx
        Ma/ZoXPx9ZN5j5uTUUfJqSB9sVUB
X-Google-Smtp-Source: APXvYqx/eGTcmwWpsg3po0yxOeNS2MtvYa/BN5nEwdVkuV9YffPeO8+QOge0FAWCzvJbyY+IQLkG6A==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr4011889wml.169.1567024173493;
        Wed, 28 Aug 2019 13:29:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id r190sm594432wmf.0.2019.08.28.13.29.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:33 -0700 (PDT)
Subject: [PATCH net-next v2 9/9] r8169: add support for EEE on RTL8125
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <9dd5c8fe-a3c1-9cba-ab5e-9b58ec1c28bd@gmail.com>
Date:   Wed, 28 Aug 2019 22:29:05 +0200
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

This adds EEE support for RTL8125 based on the vendor driver.
Supported is EEE for 100Mbps and 1Gbps. Realtek recommended to not yet
enable EEE for 2.5Gbps due to potential compatibility issues. Also
ethtool doesn't support yet controlling EEE for 2.5Gbps and 5Gbps.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 99176a9a8..f337f81e4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2271,6 +2271,12 @@ static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_1111, 0x0003);
 }
 
+static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
+{
+	r8168_mac_ocp_modify(tp, 0xe040, 0, BIT(1) | BIT(0));
+	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
+}
+
 static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
@@ -2301,6 +2307,16 @@ static void rtl8168h_config_eee_phy(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
 }
 
+static void rtl8125_config_eee_phy(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->phydev;
+
+	rtl8168h_config_eee_phy(tp);
+
+	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
+}
+
 static void rtl8169s_hw_phy_config(struct rtl8169_private *tp)
 {
 	static const struct phy_reg phy_reg_init[] = {
@@ -3672,6 +3688,9 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
 	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(tp);
+	rtl_enable_eee(tp);
 }
 
 static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
@@ -3741,6 +3760,9 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp)
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(tp);
+	rtl_enable_eee(tp);
 }
 
 static void rtl_hw_phy_config(struct net_device *dev)
@@ -5263,6 +5285,8 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 
 	rtl_udelay_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
 
+	rtl8125_config_eee_mac(tp);
+
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
 	udelay(10);
 }
-- 
2.23.0


