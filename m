Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7343A136133
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbgAITf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45300 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730954AbgAITfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so8609978wrj.12
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8MgOi2N7n8fhpz4NWJ0k6mDhTzRibhZnYY6gnnhxh6w=;
        b=mOutiyPODTKxZMvGd2oc9xyTzlOvfVaPWsQsN3xSYkrQLGKWqAA1kOnYVsSQZ55vG2
         nfrg1LmGeIIoSzCd7PgCEs4+BcCPMOYs28ftUAWNpR7Rdk19EuUPQ/vYxcMv6DQyHX0k
         rN6xL0qgXFmrPdrqj3MChZBeA5aItoSCJaKuLFSJ74GPS2J85cDx2REQ6FFP7LwrZBxt
         JxlsqqgJDMo/A++Io2ESHvQ+ChYmUCi0MU3+vNXCJoZypCuTr6AXkKmRBr0Ev3U5R0AU
         mIonxjUtPg/Ero7Er5N/L+/Ue3X37SBs+atWaaQRwoTLgj+KhgSvNXTTvg7DTKpb67Xx
         wIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8MgOi2N7n8fhpz4NWJ0k6mDhTzRibhZnYY6gnnhxh6w=;
        b=qcQdhVWWOV/su4OYP08K9mH0iYU+WAs6TUsSFkp05mK+ojQsx4eAZHOtyaaNeZVkYy
         e3zragu8AfAEl7lA2oUbjgpiqEsMOelJcKEDw9Sa83dfbhNlSUfRII1P0EPDlr3QCdQa
         EBZ22loWaVvRM1aEhsQ9hEwbOadEs+jRwyUbdPo7YsI6ibQRARQSVHllZ0T5jMqTbpam
         5Kw8RLfnOco/AiARK9FkgWucQio0GBTqtyplWYD3IwPTI54y548DJG9Z47tzbwwK/aTV
         oa3aiDIG+WF9oi1tPdD22WRZy8I76H8dgvPl2poLNIfQEbyE51ghBzLd533hTXFqMmfo
         v7Lw==
X-Gm-Message-State: APjAAAVo3OTrO7OtmwyO/dlbptbEWDff4sg67lmDFZHKFS+p4FKhv8UN
        Rxben1xYDVaC8jIhW8pyP0u49lCm
X-Google-Smtp-Source: APXvYqwydcbThKyHA14tyKx3ebqUEhVelJUV1vZowpWAXO44i8NIaD29rROCdqrOKjnI735JBFBFVg==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr12432810wrq.396.1578598549824;
        Thu, 09 Jan 2020 11:35:49 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id c5sm4213331wmb.9.2020.01.09.11.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:49 -0800 (PST)
Subject: [PATCH net-next 15/15] r8169: factor out PHY configuration to
 r8169_phy_config.c
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <04a8dbc7-1113-d8e1-346b-0221253b4493@gmail.com>
Date:   Thu, 9 Jan 2020 20:34:55 +0100
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

Move chip-specific PHY configurations to separate source file
r8169_phy_config.c. This improves maintainability of the driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/Makefile         |    2 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 1291 ----------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 1307 +++++++++++++++++
 3 files changed, 1308 insertions(+), 1292 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169_phy_config.c

diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
index d5304bad2..2e1d78b10 100644
--- a/drivers/net/ethernet/realtek/Makefile
+++ b/drivers/net/ethernet/realtek/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_8139CP) += 8139cp.o
 obj-$(CONFIG_8139TOO) += 8139too.o
 obj-$(CONFIG_ATP) += atp.o
-r8169-objs += r8169_main.o r8169_firmware.o
+r8169-objs += r8169_main.o r8169_firmware.o r8169_phy_config.o
 obj-$(CONFIG_R8169) += r8169.o
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7bbc9794d..6d699df7d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -636,8 +636,6 @@ struct rtl8169_private {
 };
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
-typedef void (*rtl_phy_cfg_fct)(struct rtl8169_private *tp,
-				struct phy_device *phydev);
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
@@ -1024,39 +1022,6 @@ static int rtl_readphy(struct rtl8169_private *tp, int location)
 	}
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
-static void r8168d_phy_param(struct phy_device *phydev, u16 parm,
-			     u16 mask, u16 val)
-{
-	int oldpage = phy_select_page(phydev, 0x0005);
-
-	__phy_write(phydev, 0x05, parm);
-	__phy_modify(phydev, 0x06, mask, val);
-
-	phy_restore_page(phydev, oldpage, 0);
-}
-
-static void r8168g_phy_param(struct phy_device *phydev, u16 parm,
-			     u16 mask, u16 val)
-{
-	int oldpage = phy_select_page(phydev, 0x0a43);
-
-	__phy_write(phydev, 0x13, parm);
-	__phy_modify(phydev, 0x14, mask, val);
-
-	phy_restore_page(phydev, oldpage, 0);
-}
-
 DECLARE_RTL_COND(rtl_ephyar_cond)
 {
 	return RTL_R32(tp, EPHYAR) & EPHYAR_FLAG;
@@ -2201,26 +2166,6 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 	}
 }
 
-struct phy_reg {
-	u16 reg;
-	u16 val;
-};
-
-static void __rtl_writephy_batch(struct phy_device *phydev,
-				 const struct phy_reg *regs, int len)
-{
-	phy_lock_mdio_bus(phydev);
-
-	while (len-- > 0) {
-		__phy_write(phydev, regs->reg, regs->val);
-		regs++;
-	}
-
-	phy_unlock_mdio_bus(phydev);
-}
-
-#define rtl_writephy_batch(p, a) __rtl_writephy_batch(p, a, ARRAY_SIZE(a))
-
 static void rtl_release_firmware(struct rtl8169_private *tp)
 {
 	if (tp->rtl_fw) {
@@ -2252,587 +2197,6 @@ static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
 }
 
-static void rtl8168f_config_eee_phy(struct phy_device *phydev)
-{
-	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0, BIT(8));
-	r8168d_phy_param(phydev, 0x8b85, 0, BIT(13));
-}
-
-static void rtl8168g_config_eee_phy(struct phy_device *phydev)
-{
-	phy_modify_paged(phydev, 0x0a43, 0x11, 0, BIT(4));
-}
-
-static void rtl8168h_config_eee_phy(struct phy_device *phydev)
-{
-	rtl8168g_config_eee_phy(phydev);
-
-	phy_modify_paged(phydev, 0xa4a, 0x11, 0x0000, 0x0200);
-	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
-}
-
-static void rtl8125_config_eee_phy(struct phy_device *phydev)
-{
-	rtl8168h_config_eee_phy(phydev);
-
-	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
-	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
-}
-
-static void rtl8169s_hw_phy_config(struct rtl8169_private *tp,
-				   struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x06, 0x006e },
-		{ 0x08, 0x0708 },
-		{ 0x15, 0x4000 },
-		{ 0x18, 0x65c7 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x03, 0x00a1 },
-		{ 0x02, 0x0008 },
-		{ 0x01, 0x0120 },
-		{ 0x00, 0x1000 },
-		{ 0x04, 0x0800 },
-		{ 0x04, 0x0000 },
-
-		{ 0x03, 0xff41 },
-		{ 0x02, 0xdf60 },
-		{ 0x01, 0x0140 },
-		{ 0x00, 0x0077 },
-		{ 0x04, 0x7800 },
-		{ 0x04, 0x7000 },
-
-		{ 0x03, 0x802f },
-		{ 0x02, 0x4f02 },
-		{ 0x01, 0x0409 },
-		{ 0x00, 0xf0f9 },
-		{ 0x04, 0x9800 },
-		{ 0x04, 0x9000 },
-
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0xff95 },
-		{ 0x00, 0xba00 },
-		{ 0x04, 0xa800 },
-		{ 0x04, 0xa000 },
-
-		{ 0x03, 0xff41 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x0140 },
-		{ 0x00, 0x00bb },
-		{ 0x04, 0xb800 },
-		{ 0x04, 0xb000 },
-
-		{ 0x03, 0xdf41 },
-		{ 0x02, 0xdc60 },
-		{ 0x01, 0x6340 },
-		{ 0x00, 0x007d },
-		{ 0x04, 0xd800 },
-		{ 0x04, 0xd000 },
-
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x100a },
-		{ 0x00, 0xa0ff },
-		{ 0x04, 0xf800 },
-		{ 0x04, 0xf000 },
-
-		{ 0x1f, 0x0000 },
-		{ 0x0b, 0x0000 },
-		{ 0x00, 0x9200 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-}
-
-static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
-{
-	phy_write_paged(phydev, 0x0002, 0x01, 0x90d0);
-}
-
-static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x04, 0x0000 },
-		{ 0x03, 0x00a1 },
-		{ 0x02, 0x0008 },
-		{ 0x01, 0x0120 },
-		{ 0x00, 0x1000 },
-		{ 0x04, 0x0800 },
-		{ 0x04, 0x9000 },
-		{ 0x03, 0x802f },
-		{ 0x02, 0x4f02 },
-		{ 0x01, 0x0409 },
-		{ 0x00, 0xf099 },
-		{ 0x04, 0x9800 },
-		{ 0x04, 0xa000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0xff95 },
-		{ 0x00, 0xba00 },
-		{ 0x04, 0xa800 },
-		{ 0x04, 0xf000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x101a },
-		{ 0x00, 0xa0ff },
-		{ 0x04, 0xf800 },
-		{ 0x04, 0x0000 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x10, 0xf41b },
-		{ 0x14, 0xfb54 },
-		{ 0x18, 0xf5c7 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-}
-
-static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x04, 0x0000 },
-		{ 0x03, 0x00a1 },
-		{ 0x02, 0x0008 },
-		{ 0x01, 0x0120 },
-		{ 0x00, 0x1000 },
-		{ 0x04, 0x0800 },
-		{ 0x04, 0x9000 },
-		{ 0x03, 0x802f },
-		{ 0x02, 0x4f02 },
-		{ 0x01, 0x0409 },
-		{ 0x00, 0xf099 },
-		{ 0x04, 0x9800 },
-		{ 0x04, 0xa000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0xff95 },
-		{ 0x00, 0xba00 },
-		{ 0x04, 0xa800 },
-		{ 0x04, 0xf000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x101a },
-		{ 0x00, 0xa0ff },
-		{ 0x04, 0xf800 },
-		{ 0x04, 0x0000 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x0b, 0x8480 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x18, 0x67c7 },
-		{ 0x04, 0x2000 },
-		{ 0x03, 0x002f },
-		{ 0x02, 0x4360 },
-		{ 0x01, 0x0109 },
-		{ 0x00, 0x3022 },
-		{ 0x04, 0x2800 },
-		{ 0x1f, 0x0000 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-}
-
-static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
-{
-	phy_write(phydev, 0x1f, 0x0001);
-	phy_set_bits(phydev, 0x16, BIT(0));
-	phy_write(phydev, 0x10, 0xf41b);
-	phy_write(phydev, 0x1f, 0x0000);
-}
-
-static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	phy_write_paged(phydev, 0x0001, 0x10, 0xf41b);
-}
-
-static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp,
-				      struct phy_device *phydev)
-{
-	phy_write(phydev, 0x1d, 0x0f00);
-	phy_write_paged(phydev, 0x0002, 0x0c, 0x1ec8);
-}
-
-static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp,
-				      struct phy_device *phydev)
-{
-	phy_set_bits(phydev, 0x14, BIT(5));
-	phy_set_bits(phydev, 0x0d, BIT(5));
-	phy_write_paged(phydev, 0x0001, 0x1d, 0x3d98);
-}
-
-static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x12, 0x2300 },
-		{ 0x1f, 0x0002 },
-		{ 0x00, 0x88d4 },
-		{ 0x01, 0x82b1 },
-		{ 0x03, 0x7002 },
-		{ 0x08, 0x9e30 },
-		{ 0x09, 0x01f0 },
-		{ 0x0a, 0x5500 },
-		{ 0x0c, 0x00c8 },
-		{ 0x1f, 0x0003 },
-		{ 0x12, 0xc096 },
-		{ 0x16, 0x000a },
-		{ 0x1f, 0x0000 },
-		{ 0x1f, 0x0000 },
-		{ 0x09, 0x2000 },
-		{ 0x09, 0x0000 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-
-	phy_set_bits(phydev, 0x14, BIT(5));
-	phy_set_bits(phydev, 0x0d, BIT(5));
-}
-
-static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x12, 0x2300 },
-		{ 0x03, 0x802f },
-		{ 0x02, 0x4f02 },
-		{ 0x01, 0x0409 },
-		{ 0x00, 0xf099 },
-		{ 0x04, 0x9800 },
-		{ 0x04, 0x9000 },
-		{ 0x1d, 0x3d98 },
-		{ 0x1f, 0x0002 },
-		{ 0x0c, 0x7eb8 },
-		{ 0x06, 0x0761 },
-		{ 0x1f, 0x0003 },
-		{ 0x16, 0x0f0a },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-
-	phy_set_bits(phydev, 0x16, BIT(0));
-	phy_set_bits(phydev, 0x14, BIT(5));
-	phy_set_bits(phydev, 0x0d, BIT(5));
-}
-
-static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0001 },
-		{ 0x12, 0x2300 },
-		{ 0x1d, 0x3d98 },
-		{ 0x1f, 0x0002 },
-		{ 0x0c, 0x7eb8 },
-		{ 0x06, 0x5461 },
-		{ 0x1f, 0x0003 },
-		{ 0x16, 0x0f0a },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-
-	phy_set_bits(phydev, 0x16, BIT(0));
-	phy_set_bits(phydev, 0x14, BIT(5));
-	phy_set_bits(phydev, 0x0d, BIT(5));
-}
-
-static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
-	/* Channel Estimation */
-	{ 0x1f, 0x0001 },
-	{ 0x06, 0x4064 },
-	{ 0x07, 0x2863 },
-	{ 0x08, 0x059c },
-	{ 0x09, 0x26b4 },
-	{ 0x0a, 0x6a19 },
-	{ 0x0b, 0xdcc8 },
-	{ 0x10, 0xf06d },
-	{ 0x14, 0x7f68 },
-	{ 0x18, 0x7fd9 },
-	{ 0x1c, 0xf0ff },
-	{ 0x1d, 0x3d9c },
-	{ 0x1f, 0x0003 },
-	{ 0x12, 0xf49f },
-	{ 0x13, 0x070b },
-	{ 0x1a, 0x05ad },
-	{ 0x14, 0x94c0 },
-
-	/*
-	 * Tx Error Issue
-	 * Enhance line driver power
-	 */
-	{ 0x1f, 0x0002 },
-	{ 0x06, 0x5561 },
-	{ 0x1f, 0x0005 },
-	{ 0x05, 0x8332 },
-	{ 0x06, 0x5561 },
-
-	/*
-	 * Can not link to 1Gbps with bad cable
-	 * Decrease SNR threshold form 21.07dB to 19.04dB
-	 */
-	{ 0x1f, 0x0001 },
-	{ 0x17, 0x0cc0 },
-
-	{ 0x1f, 0x0000 },
-	{ 0x0d, 0xf880 }
-};
-
-static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
-	{ 0x1f, 0x0002 },
-	{ 0x05, 0x669a },
-	{ 0x1f, 0x0005 },
-	{ 0x05, 0x8330 },
-	{ 0x06, 0x669a },
-	{ 0x1f, 0x0002 }
-};
-
-static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
-					 struct phy_device *phydev,
-					 u16 val)
-{
-	u16 reg_val;
-
-	phy_write(phydev, 0x1f, 0x0005);
-	phy_write(phydev, 0x05, 0x001b);
-	reg_val = phy_read(phydev, 0x06);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	if (reg_val != val)
-		phydev_warn(phydev, "chipset not ready for firmware\n");
-	else
-		r8169_apply_firmware(tp);
-}
-
-static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
-
-	/*
-	 * Rx Error Issue
-	 * Fine Tune Switching regulator parameter
-	 */
-	phy_write(phydev, 0x1f, 0x0002);
-	phy_modify(phydev, 0x0b, 0x00ef, 0x0010);
-	phy_modify(phydev, 0x0c, 0x5d00, 0xa200);
-
-	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		int val;
-
-		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
-
-		val = phy_read(phydev, 0x0d);
-
-		if ((val & 0x00ff) != 0x006c) {
-			static const u32 set[] = {
-				0x0065, 0x0066, 0x0067, 0x0068,
-				0x0069, 0x006a, 0x006b, 0x006c
-			};
-			int i;
-
-			phy_write(phydev, 0x1f, 0x0002);
-
-			val &= 0xff00;
-			for (i = 0; i < ARRAY_SIZE(set); i++)
-				phy_write(phydev, 0x0d, val | set[i]);
-		}
-	} else {
-		phy_write_paged(phydev, 0x0002, 0x05, 0x6662);
-		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x6662);
-	}
-
-	/* RSET couple improve */
-	phy_write(phydev, 0x1f, 0x0002);
-	phy_set_bits(phydev, 0x0d, 0x0300);
-	phy_set_bits(phydev, 0x0f, 0x0010);
-
-	/* Fine tune PLL performance */
-	phy_write(phydev, 0x1f, 0x0002);
-	phy_modify(phydev, 0x02, 0x0600, 0x0100);
-	phy_clear_bits(phydev, 0x03, 0xe000);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	rtl8168d_apply_firmware_cond(tp, phydev, 0xbf00);
-}
-
-static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
-
-	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		int val;
-
-		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
-
-		val = phy_read(phydev, 0x0d);
-		if ((val & 0x00ff) != 0x006c) {
-			static const u32 set[] = {
-				0x0065, 0x0066, 0x0067, 0x0068,
-				0x0069, 0x006a, 0x006b, 0x006c
-			};
-			int i;
-
-			phy_write(phydev, 0x1f, 0x0002);
-
-			val &= 0xff00;
-			for (i = 0; i < ARRAY_SIZE(set); i++)
-				phy_write(phydev, 0x0d, val | set[i]);
-		}
-	} else {
-		phy_write_paged(phydev, 0x0002, 0x05, 0x2642);
-		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x2642);
-	}
-
-	/* Fine tune PLL performance */
-	phy_write(phydev, 0x1f, 0x0002);
-	phy_modify(phydev, 0x02, 0x0600, 0x0100);
-	phy_clear_bits(phydev, 0x03, 0xe000);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	/* Switching regulator Slew rate */
-	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0017);
-
-	rtl8168d_apply_firmware_cond(tp, phydev, 0xb300);
-}
-
-static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0002 },
-		{ 0x10, 0x0008 },
-		{ 0x0d, 0x006c },
-
-		{ 0x1f, 0x0000 },
-		{ 0x0d, 0xf880 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-
-		{ 0x1f, 0x0001 },
-		{ 0x0b, 0xa4d8 },
-		{ 0x09, 0x281c },
-		{ 0x07, 0x2883 },
-		{ 0x0a, 0x6b35 },
-		{ 0x1d, 0x3da4 },
-		{ 0x1c, 0xeffd },
-		{ 0x14, 0x7f52 },
-		{ 0x18, 0x7fc6 },
-		{ 0x08, 0x0601 },
-		{ 0x06, 0x4063 },
-		{ 0x10, 0xf074 },
-		{ 0x1f, 0x0003 },
-		{ 0x13, 0x0789 },
-		{ 0x12, 0xf4bd },
-		{ 0x1a, 0x04fd },
-		{ 0x14, 0x84b0 },
-		{ 0x1f, 0x0000 },
-		{ 0x00, 0x9200 },
-
-		{ 0x1f, 0x0005 },
-		{ 0x01, 0x0340 },
-		{ 0x1f, 0x0001 },
-		{ 0x04, 0x4000 },
-		{ 0x03, 0x1d21 },
-		{ 0x02, 0x0c32 },
-		{ 0x01, 0x0200 },
-		{ 0x00, 0x5554 },
-		{ 0x04, 0x4800 },
-		{ 0x04, 0x4000 },
-		{ 0x04, 0xf000 },
-		{ 0x03, 0xdf01 },
-		{ 0x02, 0xdf20 },
-		{ 0x01, 0x101a },
-		{ 0x00, 0xa0ff },
-		{ 0x04, 0xf800 },
-		{ 0x04, 0xf000 },
-		{ 0x1f, 0x0000 },
-	};
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-	r8168d_modify_extpage(phydev, 0x0023, 0x16, 0xffff, 0x0000);
-}
-
-static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	phy_write_paged(phydev, 0x0001, 0x17, 0x0cc0);
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0xffff, 0x0040);
-	phy_set_bits(phydev, 0x0d, BIT(5));
-}
-
-static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		/* Channel estimation fine tune */
-		{ 0x1f, 0x0001 },
-		{ 0x0b, 0x6c20 },
-		{ 0x07, 0x2872 },
-		{ 0x1c, 0xefff },
-		{ 0x1f, 0x0003 },
-		{ 0x14, 0x6420 },
-		{ 0x1f, 0x0000 },
-	};
-
-	r8169_apply_firmware(tp);
-
-	/* Enable Delay cap */
-	r8168d_phy_param(phydev, 0x8b80, 0xffff, 0xc896);
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-
-	/* Update PFM & 10M TX idle timer */
-	r8168d_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
-
-	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
-
-	/* DCO enable for 10M IDLE Power */
-	r8168d_modify_extpage(phydev, 0x0023, 0x17, 0x0000, 0x0006);
-
-	/* For impedance matching */
-	phy_modify_paged(phydev, 0x0002, 0x08, 0x7f00, 0x8000);
-
-	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0050);
-	phy_set_bits(phydev, 0x14, BIT(15));
-
-	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
-	r8168d_phy_param(phydev, 0x8b85, 0x2000, 0x0000);
-
-	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0x1100, 0x0000);
-	phy_write_paged(phydev, 0x0006, 0x00, 0x5a00);
-
-	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
-}
-
 static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 {
 	const u16 w[] = {
@@ -2847,280 +2211,6 @@ static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 	rtl_eri_write(tp, 0xf4, ERIAR_MASK_1111, w[1] | (w[2] << 16));
 }
 
-static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	r8169_apply_firmware(tp);
-
-	/* Enable Delay cap */
-	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
-
-	/* Channel estimation fine tune */
-	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
-
-	/* Green Setting */
-	r8168d_phy_param(phydev, 0x8b5b, 0xffff, 0x9222);
-	r8168d_phy_param(phydev, 0x8b6d, 0xffff, 0x8000);
-	r8168d_phy_param(phydev, 0x8b76, 0xffff, 0x8000);
-
-	/* For 4-corner performance improve */
-	phy_write(phydev, 0x1f, 0x0005);
-	phy_write(phydev, 0x05, 0x8b80);
-	phy_set_bits(phydev, 0x17, 0x0006);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
-	phy_set_bits(phydev, 0x14, BIT(15));
-
-	/* improve 10M EEE waveform */
-	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
-
-	/* Improve 2-pair detection performance */
-	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
-
-	rtl8168f_config_eee_phy(phydev);
-
-	/* Green feature */
-	phy_write(phydev, 0x1f, 0x0003);
-	phy_set_bits(phydev, 0x19, BIT(0));
-	phy_set_bits(phydev, 0x10, BIT(10));
-	phy_write(phydev, 0x1f, 0x0000);
-	phy_modify_paged(phydev, 0x0005, 0x01, 0, BIT(8));
-}
-
-static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
-				   struct phy_device *phydev)
-{
-	/* For 4-corner performance improve */
-	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
-
-	/* PHY auto speed down */
-	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
-	phy_set_bits(phydev, 0x14, BIT(15));
-
-	/* Improve 10M EEE waveform */
-	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
-
-	rtl8168f_config_eee_phy(phydev);
-}
-
-static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	r8169_apply_firmware(tp);
-
-	/* Channel estimation fine tune */
-	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
-
-	/* Modify green table for giga & fnet */
-	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00fb);
-
-	/* Modify green table for 10M */
-	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
-
-	/* Disable hiimpedance detection (RTCT) */
-	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
-
-	rtl8168f_hw_phy_config(tp, phydev);
-
-	/* Improve 2-pair detection performance */
-	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
-}
-
-static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	r8169_apply_firmware(tp);
-
-	rtl8168f_hw_phy_config(tp, phydev);
-}
-
-static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
-				  struct phy_device *phydev)
-{
-	r8169_apply_firmware(tp);
-
-	rtl8168f_hw_phy_config(tp, phydev);
-
-	/* Improve 2-pair detection performance */
-	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
-
-	/* Channel estimation fine tune */
-	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
-
-	/* Modify green table for giga & fnet */
-	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
-	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
-	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00aa);
-
-	/* Modify green table for 10M */
-	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
-
-	/* Disable hiimpedance detection (RTCT) */
-	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
-
-	/* Modify green table for giga */
-	r8168d_phy_param(phydev, 0x8b54, 0x0800, 0x0000);
-	r8168d_phy_param(phydev, 0x8b5d, 0x0800, 0x0000);
-	r8168d_phy_param(phydev, 0x8a7c, 0x0100, 0x0000);
-	r8168d_phy_param(phydev, 0x8a7f, 0x0000, 0x0100);
-	r8168d_phy_param(phydev, 0x8a82, 0x0100, 0x0000);
-	r8168d_phy_param(phydev, 0x8a85, 0x0100, 0x0000);
-	r8168d_phy_param(phydev, 0x8a88, 0x0100, 0x0000);
-
-	/* uc same-seed solution */
-	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x8000);
-
-	/* Green feature */
-	phy_write(phydev, 0x1f, 0x0003);
-	phy_clear_bits(phydev, 0x19, BIT(0));
-	phy_clear_bits(phydev, 0x10, BIT(10));
-	phy_write(phydev, 0x1f, 0x0000);
-}
-
-static void rtl8168g_disable_aldps(struct phy_device *phydev)
-{
-	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
-}
-
-static void rtl8168g_phy_adjust_10m_aldps(struct phy_device *phydev)
-{
-	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(7) | BIT(6));
-	r8168g_phy_param(phydev, 0x8084, 0x6000, 0x0000);
-	phy_modify_paged(phydev, 0x0a43, 0x10, 0x0000, 0x1003);
-}
-
-static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	int ret;
-
-	r8169_apply_firmware(tp);
-
-	ret = phy_read_paged(phydev, 0x0a46, 0x10);
-	if (ret & BIT(8))
-		phy_modify_paged(phydev, 0x0bcc, 0x12, BIT(15), 0);
-	else
-		phy_modify_paged(phydev, 0x0bcc, 0x12, 0, BIT(15));
-
-	ret = phy_read_paged(phydev, 0x0a46, 0x13);
-	if (ret & BIT(8))
-		phy_modify_paged(phydev, 0x0c41, 0x15, 0, BIT(1));
-	else
-		phy_modify_paged(phydev, 0x0c41, 0x15, BIT(1), 0);
-
-	/* Enable PHY auto speed down */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
-
-	rtl8168g_phy_adjust_10m_aldps(phydev);
-
-	/* EEE auto-fallback function */
-	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
-
-	/* Enable UC LPF tune function */
-	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
-
-	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
-
-	/* Improve SWR Efficiency */
-	phy_write(phydev, 0x1f, 0x0bcd);
-	phy_write(phydev, 0x14, 0x5065);
-	phy_write(phydev, 0x14, 0xd065);
-	phy_write(phydev, 0x1f, 0x0bc8);
-	phy_write(phydev, 0x11, 0x5655);
-	phy_write(phydev, 0x1f, 0x0bcd);
-	phy_write(phydev, 0x14, 0x1065);
-	phy_write(phydev, 0x14, 0x9065);
-	phy_write(phydev, 0x14, 0x1065);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168g_config_eee_phy(phydev);
-}
-
-static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	r8169_apply_firmware(tp);
-	rtl8168g_config_eee_phy(phydev);
-}
-
-static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	u16 dout_tapbin;
-	u32 data;
-
-	r8169_apply_firmware(tp);
-
-	/* CHN EST parameters adjust - giga master */
-	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
-	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x8000);
-	r8168g_phy_param(phydev, 0x80a4, 0xff00, 0x8500);
-	r8168g_phy_param(phydev, 0x809c, 0xff00, 0xbd00);
-
-	/* CHN EST parameters adjust - giga slave */
-	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x7000);
-	r8168g_phy_param(phydev, 0x80b4, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x80ac, 0xff00, 0x4000);
-
-	/* CHN EST parameters adjust - fnet */
-	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x1200);
-	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xe500);
-	r8168g_phy_param(phydev, 0x8092, 0xff00, 0x9f00);
-
-	/* enable R-tune & PGA-retune function */
-	dout_tapbin = 0;
-	data = phy_read_paged(phydev, 0x0a46, 0x13);
-	data &= 3;
-	data <<= 2;
-	dout_tapbin |= data;
-	data = phy_read_paged(phydev, 0x0a46, 0x12);
-	data &= 0xc000;
-	data >>= 14;
-	dout_tapbin |= data;
-	dout_tapbin = ~(dout_tapbin^0x08);
-	dout_tapbin <<= 12;
-	dout_tapbin &= 0xf000;
-
-	r8168g_phy_param(phydev, 0x827a, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827b, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827c, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x827d, 0xf000, dout_tapbin);
-	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
-	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
-
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
-
-	/* SAR ADC performance */
-	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
-
-	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x804f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8057, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x805f, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x8067, 0x3000, 0x0000);
-	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
-
-	/* disable phy pfm mode */
-	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168h_config_eee_phy(phydev);
-}
-
 u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
 {
 	u16 data1, data2, ioffset;
@@ -3137,387 +2227,6 @@ u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
 	return ioffset;
 }
 
-static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
-				     struct phy_device *phydev)
-{
-	u16 ioffset, rlen;
-	u32 data;
-
-	r8169_apply_firmware(tp);
-
-	/* CHIN EST parameter update */
-	r8168g_phy_param(phydev, 0x808a, 0x003f, 0x000a);
-
-	/* enable R-tune & PGA-retune function */
-	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
-	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
-
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
-
-	ioffset = rtl8168h_2_get_adc_bias_ioffset(tp);
-	if (ioffset != 0xffff)
-		phy_write_paged(phydev, 0x0bcf, 0x16, ioffset);
-
-	/* Modify rlen (TX LPF corner frequency) level */
-	data = phy_read_paged(phydev, 0x0bcd, 0x16);
-	data &= 0x000f;
-	rlen = 0;
-	if (data > 3)
-		rlen = data - 3;
-	data = rlen | (rlen<<4) | (rlen<<8) | (rlen<<12);
-	phy_write_paged(phydev, 0x0bcd, 0x17, data);
-
-	/* disable phy pfm mode */
-	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168g_config_eee_phy(phydev);
-}
-
-static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
-				      struct phy_device *phydev)
-{
-	/* Enable PHY auto speed down */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
-
-	rtl8168g_phy_adjust_10m_aldps(phydev);
-
-	/* Enable EEE auto-fallback function */
-	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
-
-	/* Enable UC LPF tune function */
-	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
-
-	/* set rg_sel_sdm_rate */
-	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168g_config_eee_phy(phydev);
-}
-
-static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
-				      struct phy_device *phydev)
-{
-	rtl8168g_phy_adjust_10m_aldps(phydev);
-
-	/* Enable UC LPF tune function */
-	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
-
-	/* Set rg_sel_sdm_rate */
-	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
-
-	/* Channel estimation parameters */
-	r8168g_phy_param(phydev, 0x80f3, 0xff00, 0x8b00);
-	r8168g_phy_param(phydev, 0x80f0, 0xff00, 0x3a00);
-	r8168g_phy_param(phydev, 0x80ef, 0xff00, 0x0500);
-	r8168g_phy_param(phydev, 0x80f6, 0xff00, 0x6e00);
-	r8168g_phy_param(phydev, 0x80ec, 0xff00, 0x6800);
-	r8168g_phy_param(phydev, 0x80ed, 0xff00, 0x7c00);
-	r8168g_phy_param(phydev, 0x80f2, 0xff00, 0xf400);
-	r8168g_phy_param(phydev, 0x80f4, 0xff00, 0x8500);
-	r8168g_phy_param(phydev, 0x8110, 0xff00, 0xa800);
-	r8168g_phy_param(phydev, 0x810f, 0xff00, 0x1d00);
-	r8168g_phy_param(phydev, 0x8111, 0xff00, 0xf500);
-	r8168g_phy_param(phydev, 0x8113, 0xff00, 0x6100);
-	r8168g_phy_param(phydev, 0x8115, 0xff00, 0x9200);
-	r8168g_phy_param(phydev, 0x810e, 0xff00, 0x0400);
-	r8168g_phy_param(phydev, 0x810c, 0xff00, 0x7c00);
-	r8168g_phy_param(phydev, 0x810b, 0xff00, 0x5a00);
-	r8168g_phy_param(phydev, 0x80d1, 0xff00, 0xff00);
-	r8168g_phy_param(phydev, 0x80cd, 0xff00, 0x9e00);
-	r8168g_phy_param(phydev, 0x80d3, 0xff00, 0x0e00);
-	r8168g_phy_param(phydev, 0x80d5, 0xff00, 0xca00);
-	r8168g_phy_param(phydev, 0x80d7, 0xff00, 0x8400);
-
-	/* Force PWM-mode */
-	phy_write(phydev, 0x1f, 0x0bcd);
-	phy_write(phydev, 0x14, 0x5065);
-	phy_write(phydev, 0x14, 0xd065);
-	phy_write(phydev, 0x1f, 0x0bc8);
-	phy_write(phydev, 0x12, 0x00ed);
-	phy_write(phydev, 0x1f, 0x0bcd);
-	phy_write(phydev, 0x14, 0x1065);
-	phy_write(phydev, 0x14, 0x9065);
-	phy_write(phydev, 0x14, 0x1065);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168g_config_eee_phy(phydev);
-}
-
-static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
-				  struct phy_device *phydev)
-{
-	/* CHN EST parameters adjust - fnet */
-	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x4800);
-	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xcc00);
-	r8168g_phy_param(phydev, 0x8092, 0xff00, 0xb000);
-
-	r8168g_phy_param(phydev, 0x8088, 0xff00, 0x6000);
-	r8168g_phy_param(phydev, 0x808b, 0x3f00, 0x0b00);
-	r8168g_phy_param(phydev, 0x808d, 0x1f00, 0x0600);
-	r8168g_phy_param(phydev, 0x808c, 0xff00, 0xb000);
-	r8168g_phy_param(phydev, 0x80a0, 0xff00, 0x2800);
-	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x809b, 0xf800, 0xb000);
-	r8168g_phy_param(phydev, 0x809a, 0xff00, 0x4b00);
-	r8168g_phy_param(phydev, 0x809d, 0x3f00, 0x0800);
-	r8168g_phy_param(phydev, 0x80a1, 0xff00, 0x7000);
-	r8168g_phy_param(phydev, 0x809f, 0x1f00, 0x0300);
-	r8168g_phy_param(phydev, 0x809e, 0xff00, 0x8800);
-	r8168g_phy_param(phydev, 0x80b2, 0xff00, 0x2200);
-	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x9800);
-	r8168g_phy_param(phydev, 0x80af, 0x3f00, 0x0800);
-	r8168g_phy_param(phydev, 0x80b3, 0xff00, 0x6f00);
-	r8168g_phy_param(phydev, 0x80b1, 0x1f00, 0x0300);
-	r8168g_phy_param(phydev, 0x80b0, 0xff00, 0x9300);
-
-	r8168g_phy_param(phydev, 0x8011, 0x0000, 0x0800);
-
-	/* enable GPHY 10M */
-	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
-
-	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
-
-	rtl8168g_disable_aldps(phydev);
-	rtl8168h_config_eee_phy(phydev);
-}
-
-static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
-				   struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0003 },
-		{ 0x08, 0x441d },
-		{ 0x01, 0x9100 },
-		{ 0x1f, 0x0000 }
-	};
-
-	phy_set_bits(phydev, 0x11, BIT(12));
-	phy_set_bits(phydev, 0x19, BIT(13));
-	phy_set_bits(phydev, 0x10, BIT(15));
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-}
-
-static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
-				   struct phy_device *phydev)
-{
-	/* Disable ALDPS before ram code */
-	phy_write(phydev, 0x18, 0x0310);
-	msleep(100);
-
-	r8169_apply_firmware(tp);
-
-	phy_write_paged(phydev, 0x0005, 0x1a, 0x0000);
-	phy_write_paged(phydev, 0x0004, 0x1c, 0x0000);
-	phy_write_paged(phydev, 0x0001, 0x15, 0x7701);
-}
-
-static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
-				  struct phy_device *phydev)
-{
-	/* Disable ALDPS before setting firmware */
-	phy_write(phydev, 0x18, 0x0310);
-	msleep(20);
-
-	r8169_apply_firmware(tp);
-
-	/* EEE setting */
-	phy_write(phydev, 0x1f, 0x0004);
-	phy_write(phydev, 0x10, 0x401f);
-	phy_write(phydev, 0x19, 0x7030);
-	phy_write(phydev, 0x1f, 0x0000);
-}
-
-static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
-				   struct phy_device *phydev)
-{
-	static const struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0004 },
-		{ 0x10, 0xc07f },
-		{ 0x19, 0x7030 },
-		{ 0x1f, 0x0000 }
-	};
-
-	/* Disable ALDPS before ram code */
-	phy_write(phydev, 0x18, 0x0310);
-	msleep(100);
-
-	r8169_apply_firmware(tp);
-
-	rtl_writephy_batch(phydev, phy_reg_init);
-}
-
-static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
-{
-	phy_modify_paged(phydev, 0xad4, 0x10, 0x03ff, 0x0084);
-	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
-	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x0006);
-	phy_modify_paged(phydev, 0xad3, 0x11, 0x003f, 0x0006);
-	phy_modify_paged(phydev, 0xac0, 0x14, 0x0000, 0x1100);
-	phy_modify_paged(phydev, 0xac8, 0x15, 0xf000, 0x7000);
-	phy_modify_paged(phydev, 0xad1, 0x14, 0x0000, 0x0400);
-	phy_modify_paged(phydev, 0xad1, 0x15, 0x0000, 0x03ff);
-	phy_modify_paged(phydev, 0xad1, 0x16, 0x0000, 0x03ff);
-
-	r8168g_phy_param(phydev, 0x80ea, 0xff00, 0xc400);
-	r8168g_phy_param(phydev, 0x80eb, 0x0700, 0x0300);
-	r8168g_phy_param(phydev, 0x80f8, 0xff00, 0x1c00);
-	r8168g_phy_param(phydev, 0x80f1, 0xff00, 0x3000);
-	r8168g_phy_param(phydev, 0x80fe, 0xff00, 0xa500);
-	r8168g_phy_param(phydev, 0x8102, 0xff00, 0x5000);
-	r8168g_phy_param(phydev, 0x8105, 0xff00, 0x3300);
-	r8168g_phy_param(phydev, 0x8100, 0xff00, 0x7000);
-	r8168g_phy_param(phydev, 0x8104, 0xff00, 0xf000);
-	r8168g_phy_param(phydev, 0x8106, 0xff00, 0x6500);
-	r8168g_phy_param(phydev, 0x80dc, 0xff00, 0xed00);
-	r8168g_phy_param(phydev, 0x80df, 0x0000, 0x0100);
-	r8168g_phy_param(phydev, 0x80e1, 0x0100, 0x0000);
-
-	phy_modify_paged(phydev, 0xbf0, 0x13, 0x003f, 0x0038);
-	r8168g_phy_param(phydev, 0x819f, 0xffff, 0xd0b6);
-
-	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
-	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
-	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
-	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
-
-	rtl8125_config_eee_phy(phydev);
-}
-
-static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
-{
-	int i;
-
-	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
-	phy_modify_paged(phydev, 0xad1, 0x13, 0x03ff, 0x03ff);
-	phy_modify_paged(phydev, 0xad3, 0x11, 0x003f, 0x0006);
-	phy_modify_paged(phydev, 0xac0, 0x14, 0x1100, 0x0000);
-	phy_modify_paged(phydev, 0xacc, 0x10, 0x0003, 0x0002);
-	phy_modify_paged(phydev, 0xad4, 0x10, 0x00e7, 0x0044);
-	phy_modify_paged(phydev, 0xac1, 0x12, 0x0080, 0x0000);
-	phy_modify_paged(phydev, 0xac8, 0x10, 0x0300, 0x0000);
-	phy_modify_paged(phydev, 0xac5, 0x17, 0x0007, 0x0002);
-	phy_write_paged(phydev, 0xad4, 0x16, 0x00a8);
-	phy_write_paged(phydev, 0xac5, 0x16, 0x01ff);
-	phy_modify_paged(phydev, 0xac8, 0x15, 0x00f0, 0x0030);
-
-	phy_write(phydev, 0x1f, 0x0b87);
-	phy_write(phydev, 0x16, 0x80a2);
-	phy_write(phydev, 0x17, 0x0153);
-	phy_write(phydev, 0x16, 0x809c);
-	phy_write(phydev, 0x17, 0x0153);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	phy_write(phydev, 0x1f, 0x0a43);
-	phy_write(phydev, 0x13, 0x81B3);
-	phy_write(phydev, 0x14, 0x0043);
-	phy_write(phydev, 0x14, 0x00A7);
-	phy_write(phydev, 0x14, 0x00D6);
-	phy_write(phydev, 0x14, 0x00EC);
-	phy_write(phydev, 0x14, 0x00F6);
-	phy_write(phydev, 0x14, 0x00FB);
-	phy_write(phydev, 0x14, 0x00FD);
-	phy_write(phydev, 0x14, 0x00FF);
-	phy_write(phydev, 0x14, 0x00BB);
-	phy_write(phydev, 0x14, 0x0058);
-	phy_write(phydev, 0x14, 0x0029);
-	phy_write(phydev, 0x14, 0x0013);
-	phy_write(phydev, 0x14, 0x0009);
-	phy_write(phydev, 0x14, 0x0004);
-	phy_write(phydev, 0x14, 0x0002);
-	for (i = 0; i < 25; i++)
-		phy_write(phydev, 0x14, 0x0000);
-	phy_write(phydev, 0x1f, 0x0000);
-
-	r8168g_phy_param(phydev, 0x8257, 0xffff, 0x020F);
-	r8168g_phy_param(phydev, 0x80ea, 0xffff, 0x7843);
-
-	r8169_apply_firmware(tp);
-
-	phy_modify_paged(phydev, 0xd06, 0x14, 0x0000, 0x2000);
-
-	r8168g_phy_param(phydev, 0x81a2, 0x0000, 0x0100);
-
-	phy_modify_paged(phydev, 0xb54, 0x16, 0xff00, 0xdb00);
-	phy_modify_paged(phydev, 0xa45, 0x12, 0x0001, 0x0000);
-	phy_modify_paged(phydev, 0xa5d, 0x12, 0x0000, 0x0020);
-	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
-	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
-	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
-
-	rtl8125_config_eee_phy(phydev);
-}
-
-void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
-			 enum mac_version ver)
-{
-	static const rtl_phy_cfg_fct phy_configs[] = {
-		/* PCI devices. */
-		[RTL_GIGA_MAC_VER_02] = rtl8169s_hw_phy_config,
-		[RTL_GIGA_MAC_VER_03] = rtl8169s_hw_phy_config,
-		[RTL_GIGA_MAC_VER_04] = rtl8169sb_hw_phy_config,
-		[RTL_GIGA_MAC_VER_05] = rtl8169scd_hw_phy_config,
-		[RTL_GIGA_MAC_VER_06] = rtl8169sce_hw_phy_config,
-		/* PCI-E devices. */
-		[RTL_GIGA_MAC_VER_07] = rtl8102e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_08] = rtl8102e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_09] = rtl8102e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_10] = NULL,
-		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
-		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
-		[RTL_GIGA_MAC_VER_13] = NULL,
-		[RTL_GIGA_MAC_VER_14] = NULL,
-		[RTL_GIGA_MAC_VER_15] = NULL,
-		[RTL_GIGA_MAC_VER_16] = NULL,
-		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
-		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_19] = rtl8168c_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_20] = rtl8168c_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_21] = rtl8168c_3_hw_phy_config,
-		[RTL_GIGA_MAC_VER_22] = rtl8168c_3_hw_phy_config,
-		[RTL_GIGA_MAC_VER_23] = rtl8168cp_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_24] = rtl8168cp_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_25] = rtl8168d_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_26] = rtl8168d_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_27] = rtl8168d_3_hw_phy_config,
-		[RTL_GIGA_MAC_VER_28] = rtl8168d_4_hw_phy_config,
-		[RTL_GIGA_MAC_VER_29] = rtl8105e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_30] = rtl8105e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_31] = NULL,
-		[RTL_GIGA_MAC_VER_32] = rtl8168e_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_33] = rtl8168e_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_34] = rtl8168e_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_35] = rtl8168f_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_36] = rtl8168f_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_37] = rtl8402_hw_phy_config,
-		[RTL_GIGA_MAC_VER_38] = rtl8411_hw_phy_config,
-		[RTL_GIGA_MAC_VER_39] = rtl8106e_hw_phy_config,
-		[RTL_GIGA_MAC_VER_40] = rtl8168g_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_41] = NULL,
-		[RTL_GIGA_MAC_VER_42] = rtl8168g_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_43] = rtl8168g_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_45] = rtl8168h_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_47] = rtl8168h_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
-		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
-		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
-	};
-
-	if (phy_configs[ver])
-		phy_configs[ver](tp, phydev);
-}
-
 static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
 {
 	if (!test_and_set_bit(flag, tp->wk.flags))
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
new file mode 100644
index 000000000..e367e77c7
--- /dev/null
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -0,0 +1,1307 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * r8169_phy_config.c: RealTek 8169/8168/8101 ethernet driver.
+ *
+ * Copyright (c) 2002 ShuChen <shuchen@realtek.com.tw>
+ * Copyright (c) 2003 - 2007 Francois Romieu <romieu@fr.zoreil.com>
+ * Copyright (c) a lot of people too. Please respect their work.
+ *
+ * See MAINTAINERS file for support contact information.
+ */
+
+#include <linux/delay.h>
+#include <linux/phy.h>
+
+#include "r8169.h"
+
+typedef void (*rtl_phy_cfg_fct)(struct rtl8169_private *tp,
+				struct phy_device *phydev);
+
+static void r8168d_modify_extpage(struct phy_device *phydev, int extpage,
+				  int reg, u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0007);
+
+	__phy_write(phydev, 0x1e, extpage);
+	__phy_modify(phydev, reg, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
+static void r8168d_phy_param(struct phy_device *phydev, u16 parm,
+			     u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0005);
+
+	__phy_write(phydev, 0x05, parm);
+	__phy_modify(phydev, 0x06, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
+static void r8168g_phy_param(struct phy_device *phydev, u16 parm,
+			     u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0a43);
+
+	__phy_write(phydev, 0x13, parm);
+	__phy_modify(phydev, 0x14, mask, val);
+
+	phy_restore_page(phydev, oldpage, 0);
+}
+
+struct phy_reg {
+	u16 reg;
+	u16 val;
+};
+
+static void __rtl_writephy_batch(struct phy_device *phydev,
+				 const struct phy_reg *regs, int len)
+{
+	phy_lock_mdio_bus(phydev);
+
+	while (len-- > 0) {
+		__phy_write(phydev, regs->reg, regs->val);
+		regs++;
+	}
+
+	phy_unlock_mdio_bus(phydev);
+}
+
+#define rtl_writephy_batch(p, a) __rtl_writephy_batch(p, a, ARRAY_SIZE(a))
+
+static void rtl8168f_config_eee_phy(struct phy_device *phydev)
+{
+	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0, BIT(8));
+	r8168d_phy_param(phydev, 0x8b85, 0, BIT(13));
+}
+
+static void rtl8168g_config_eee_phy(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0x0a43, 0x11, 0, BIT(4));
+}
+
+static void rtl8168h_config_eee_phy(struct phy_device *phydev)
+{
+	rtl8168g_config_eee_phy(phydev);
+
+	phy_modify_paged(phydev, 0xa4a, 0x11, 0x0000, 0x0200);
+	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
+}
+
+static void rtl8125_config_eee_phy(struct phy_device *phydev)
+{
+	rtl8168h_config_eee_phy(phydev);
+
+	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
+}
+
+static void rtl8169s_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x06, 0x006e },
+		{ 0x08, 0x0708 },
+		{ 0x15, 0x4000 },
+		{ 0x18, 0x65c7 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x03, 0x00a1 },
+		{ 0x02, 0x0008 },
+		{ 0x01, 0x0120 },
+		{ 0x00, 0x1000 },
+		{ 0x04, 0x0800 },
+		{ 0x04, 0x0000 },
+
+		{ 0x03, 0xff41 },
+		{ 0x02, 0xdf60 },
+		{ 0x01, 0x0140 },
+		{ 0x00, 0x0077 },
+		{ 0x04, 0x7800 },
+		{ 0x04, 0x7000 },
+
+		{ 0x03, 0x802f },
+		{ 0x02, 0x4f02 },
+		{ 0x01, 0x0409 },
+		{ 0x00, 0xf0f9 },
+		{ 0x04, 0x9800 },
+		{ 0x04, 0x9000 },
+
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0xff95 },
+		{ 0x00, 0xba00 },
+		{ 0x04, 0xa800 },
+		{ 0x04, 0xa000 },
+
+		{ 0x03, 0xff41 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0x0140 },
+		{ 0x00, 0x00bb },
+		{ 0x04, 0xb800 },
+		{ 0x04, 0xb000 },
+
+		{ 0x03, 0xdf41 },
+		{ 0x02, 0xdc60 },
+		{ 0x01, 0x6340 },
+		{ 0x00, 0x007d },
+		{ 0x04, 0xd800 },
+		{ 0x04, 0xd000 },
+
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0x100a },
+		{ 0x00, 0xa0ff },
+		{ 0x04, 0xf800 },
+		{ 0x04, 0xf000 },
+
+		{ 0x1f, 0x0000 },
+		{ 0x0b, 0x0000 },
+		{ 0x00, 0x9200 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+}
+
+static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
+{
+	phy_write_paged(phydev, 0x0002, 0x01, 0x90d0);
+}
+
+static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x04, 0x0000 },
+		{ 0x03, 0x00a1 },
+		{ 0x02, 0x0008 },
+		{ 0x01, 0x0120 },
+		{ 0x00, 0x1000 },
+		{ 0x04, 0x0800 },
+		{ 0x04, 0x9000 },
+		{ 0x03, 0x802f },
+		{ 0x02, 0x4f02 },
+		{ 0x01, 0x0409 },
+		{ 0x00, 0xf099 },
+		{ 0x04, 0x9800 },
+		{ 0x04, 0xa000 },
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0xff95 },
+		{ 0x00, 0xba00 },
+		{ 0x04, 0xa800 },
+		{ 0x04, 0xf000 },
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0x101a },
+		{ 0x00, 0xa0ff },
+		{ 0x04, 0xf800 },
+		{ 0x04, 0x0000 },
+		{ 0x1f, 0x0000 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x10, 0xf41b },
+		{ 0x14, 0xfb54 },
+		{ 0x18, 0xf5c7 },
+		{ 0x1f, 0x0000 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x17, 0x0cc0 },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+}
+
+static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x04, 0x0000 },
+		{ 0x03, 0x00a1 },
+		{ 0x02, 0x0008 },
+		{ 0x01, 0x0120 },
+		{ 0x00, 0x1000 },
+		{ 0x04, 0x0800 },
+		{ 0x04, 0x9000 },
+		{ 0x03, 0x802f },
+		{ 0x02, 0x4f02 },
+		{ 0x01, 0x0409 },
+		{ 0x00, 0xf099 },
+		{ 0x04, 0x9800 },
+		{ 0x04, 0xa000 },
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0xff95 },
+		{ 0x00, 0xba00 },
+		{ 0x04, 0xa800 },
+		{ 0x04, 0xf000 },
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0x101a },
+		{ 0x00, 0xa0ff },
+		{ 0x04, 0xf800 },
+		{ 0x04, 0x0000 },
+		{ 0x1f, 0x0000 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x0b, 0x8480 },
+		{ 0x1f, 0x0000 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x18, 0x67c7 },
+		{ 0x04, 0x2000 },
+		{ 0x03, 0x002f },
+		{ 0x02, 0x4360 },
+		{ 0x01, 0x0109 },
+		{ 0x00, 0x3022 },
+		{ 0x04, 0x2800 },
+		{ 0x1f, 0x0000 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x17, 0x0cc0 },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+}
+
+static void rtl8168bb_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
+{
+	phy_write(phydev, 0x1f, 0x0001);
+	phy_set_bits(phydev, 0x16, BIT(0));
+	phy_write(phydev, 0x10, 0xf41b);
+	phy_write(phydev, 0x1f, 0x0000);
+}
+
+static void rtl8168bef_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	phy_write_paged(phydev, 0x0001, 0x10, 0xf41b);
+}
+
+static void rtl8168cp_1_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
+{
+	phy_write(phydev, 0x1d, 0x0f00);
+	phy_write_paged(phydev, 0x0002, 0x0c, 0x1ec8);
+}
+
+static void rtl8168cp_2_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
+{
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
+	phy_write_paged(phydev, 0x0001, 0x1d, 0x3d98);
+}
+
+static void rtl8168c_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x12, 0x2300 },
+		{ 0x1f, 0x0002 },
+		{ 0x00, 0x88d4 },
+		{ 0x01, 0x82b1 },
+		{ 0x03, 0x7002 },
+		{ 0x08, 0x9e30 },
+		{ 0x09, 0x01f0 },
+		{ 0x0a, 0x5500 },
+		{ 0x0c, 0x00c8 },
+		{ 0x1f, 0x0003 },
+		{ 0x12, 0xc096 },
+		{ 0x16, 0x000a },
+		{ 0x1f, 0x0000 },
+		{ 0x1f, 0x0000 },
+		{ 0x09, 0x2000 },
+		{ 0x09, 0x0000 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
+}
+
+static void rtl8168c_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x12, 0x2300 },
+		{ 0x03, 0x802f },
+		{ 0x02, 0x4f02 },
+		{ 0x01, 0x0409 },
+		{ 0x00, 0xf099 },
+		{ 0x04, 0x9800 },
+		{ 0x04, 0x9000 },
+		{ 0x1d, 0x3d98 },
+		{ 0x1f, 0x0002 },
+		{ 0x0c, 0x7eb8 },
+		{ 0x06, 0x0761 },
+		{ 0x1f, 0x0003 },
+		{ 0x16, 0x0f0a },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+
+	phy_set_bits(phydev, 0x16, BIT(0));
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
+}
+
+static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x12, 0x2300 },
+		{ 0x1d, 0x3d98 },
+		{ 0x1f, 0x0002 },
+		{ 0x0c, 0x7eb8 },
+		{ 0x06, 0x5461 },
+		{ 0x1f, 0x0003 },
+		{ 0x16, 0x0f0a },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+
+	phy_set_bits(phydev, 0x16, BIT(0));
+	phy_set_bits(phydev, 0x14, BIT(5));
+	phy_set_bits(phydev, 0x0d, BIT(5));
+}
+
+static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
+	/* Channel Estimation */
+	{ 0x1f, 0x0001 },
+	{ 0x06, 0x4064 },
+	{ 0x07, 0x2863 },
+	{ 0x08, 0x059c },
+	{ 0x09, 0x26b4 },
+	{ 0x0a, 0x6a19 },
+	{ 0x0b, 0xdcc8 },
+	{ 0x10, 0xf06d },
+	{ 0x14, 0x7f68 },
+	{ 0x18, 0x7fd9 },
+	{ 0x1c, 0xf0ff },
+	{ 0x1d, 0x3d9c },
+	{ 0x1f, 0x0003 },
+	{ 0x12, 0xf49f },
+	{ 0x13, 0x070b },
+	{ 0x1a, 0x05ad },
+	{ 0x14, 0x94c0 },
+
+	/*
+	 * Tx Error Issue
+	 * Enhance line driver power
+	 */
+	{ 0x1f, 0x0002 },
+	{ 0x06, 0x5561 },
+	{ 0x1f, 0x0005 },
+	{ 0x05, 0x8332 },
+	{ 0x06, 0x5561 },
+
+	/*
+	 * Can not link to 1Gbps with bad cable
+	 * Decrease SNR threshold form 21.07dB to 19.04dB
+	 */
+	{ 0x1f, 0x0001 },
+	{ 0x17, 0x0cc0 },
+
+	{ 0x1f, 0x0000 },
+	{ 0x0d, 0xf880 }
+};
+
+static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
+	{ 0x1f, 0x0002 },
+	{ 0x05, 0x669a },
+	{ 0x1f, 0x0005 },
+	{ 0x05, 0x8330 },
+	{ 0x06, 0x669a },
+	{ 0x1f, 0x0002 }
+};
+
+static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
+					 struct phy_device *phydev,
+					 u16 val)
+{
+	u16 reg_val;
+
+	phy_write(phydev, 0x1f, 0x0005);
+	phy_write(phydev, 0x05, 0x001b);
+	reg_val = phy_read(phydev, 0x06);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	if (reg_val != val)
+		phydev_warn(phydev, "chipset not ready for firmware\n");
+	else
+		r8169_apply_firmware(tp);
+}
+
+static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
+
+	/*
+	 * Rx Error Issue
+	 * Fine Tune Switching regulator parameter
+	 */
+	phy_write(phydev, 0x1f, 0x0002);
+	phy_modify(phydev, 0x0b, 0x00ef, 0x0010);
+	phy_modify(phydev, 0x0c, 0x5d00, 0xa200);
+
+	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
+		int val;
+
+		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
+
+		val = phy_read(phydev, 0x0d);
+
+		if ((val & 0x00ff) != 0x006c) {
+			static const u32 set[] = {
+				0x0065, 0x0066, 0x0067, 0x0068,
+				0x0069, 0x006a, 0x006b, 0x006c
+			};
+			int i;
+
+			phy_write(phydev, 0x1f, 0x0002);
+
+			val &= 0xff00;
+			for (i = 0; i < ARRAY_SIZE(set); i++)
+				phy_write(phydev, 0x0d, val | set[i]);
+		}
+	} else {
+		phy_write_paged(phydev, 0x0002, 0x05, 0x6662);
+		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x6662);
+	}
+
+	/* RSET couple improve */
+	phy_write(phydev, 0x1f, 0x0002);
+	phy_set_bits(phydev, 0x0d, 0x0300);
+	phy_set_bits(phydev, 0x0f, 0x0010);
+
+	/* Fine tune PLL performance */
+	phy_write(phydev, 0x1f, 0x0002);
+	phy_modify(phydev, 0x02, 0x0600, 0x0100);
+	phy_clear_bits(phydev, 0x03, 0xe000);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	rtl8168d_apply_firmware_cond(tp, phydev, 0xbf00);
+}
+
+static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
+
+	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
+		int val;
+
+		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
+
+		val = phy_read(phydev, 0x0d);
+		if ((val & 0x00ff) != 0x006c) {
+			static const u32 set[] = {
+				0x0065, 0x0066, 0x0067, 0x0068,
+				0x0069, 0x006a, 0x006b, 0x006c
+			};
+			int i;
+
+			phy_write(phydev, 0x1f, 0x0002);
+
+			val &= 0xff00;
+			for (i = 0; i < ARRAY_SIZE(set); i++)
+				phy_write(phydev, 0x0d, val | set[i]);
+		}
+	} else {
+		phy_write_paged(phydev, 0x0002, 0x05, 0x2642);
+		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x2642);
+	}
+
+	/* Fine tune PLL performance */
+	phy_write(phydev, 0x1f, 0x0002);
+	phy_modify(phydev, 0x02, 0x0600, 0x0100);
+	phy_clear_bits(phydev, 0x03, 0xe000);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	/* Switching regulator Slew rate */
+	phy_modify_paged(phydev, 0x0002, 0x0f, 0x0000, 0x0017);
+
+	rtl8168d_apply_firmware_cond(tp, phydev, 0xb300);
+}
+
+static void rtl8168d_3_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0002 },
+		{ 0x10, 0x0008 },
+		{ 0x0d, 0x006c },
+
+		{ 0x1f, 0x0000 },
+		{ 0x0d, 0xf880 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x17, 0x0cc0 },
+
+		{ 0x1f, 0x0001 },
+		{ 0x0b, 0xa4d8 },
+		{ 0x09, 0x281c },
+		{ 0x07, 0x2883 },
+		{ 0x0a, 0x6b35 },
+		{ 0x1d, 0x3da4 },
+		{ 0x1c, 0xeffd },
+		{ 0x14, 0x7f52 },
+		{ 0x18, 0x7fc6 },
+		{ 0x08, 0x0601 },
+		{ 0x06, 0x4063 },
+		{ 0x10, 0xf074 },
+		{ 0x1f, 0x0003 },
+		{ 0x13, 0x0789 },
+		{ 0x12, 0xf4bd },
+		{ 0x1a, 0x04fd },
+		{ 0x14, 0x84b0 },
+		{ 0x1f, 0x0000 },
+		{ 0x00, 0x9200 },
+
+		{ 0x1f, 0x0005 },
+		{ 0x01, 0x0340 },
+		{ 0x1f, 0x0001 },
+		{ 0x04, 0x4000 },
+		{ 0x03, 0x1d21 },
+		{ 0x02, 0x0c32 },
+		{ 0x01, 0x0200 },
+		{ 0x00, 0x5554 },
+		{ 0x04, 0x4800 },
+		{ 0x04, 0x4000 },
+		{ 0x04, 0xf000 },
+		{ 0x03, 0xdf01 },
+		{ 0x02, 0xdf20 },
+		{ 0x01, 0x101a },
+		{ 0x00, 0xa0ff },
+		{ 0x04, 0xf800 },
+		{ 0x04, 0xf000 },
+		{ 0x1f, 0x0000 },
+	};
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+	r8168d_modify_extpage(phydev, 0x0023, 0x16, 0xffff, 0x0000);
+}
+
+static void rtl8168d_4_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	phy_write_paged(phydev, 0x0001, 0x17, 0x0cc0);
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0xffff, 0x0040);
+	phy_set_bits(phydev, 0x0d, BIT(5));
+}
+
+static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		/* Channel estimation fine tune */
+		{ 0x1f, 0x0001 },
+		{ 0x0b, 0x6c20 },
+		{ 0x07, 0x2872 },
+		{ 0x1c, 0xefff },
+		{ 0x1f, 0x0003 },
+		{ 0x14, 0x6420 },
+		{ 0x1f, 0x0000 },
+	};
+
+	r8169_apply_firmware(tp);
+
+	/* Enable Delay cap */
+	r8168d_phy_param(phydev, 0x8b80, 0xffff, 0xc896);
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+
+	/* Update PFM & 10M TX idle timer */
+	r8168d_modify_extpage(phydev, 0x002f, 0x15, 0xffff, 0x1919);
+
+	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+
+	/* DCO enable for 10M IDLE Power */
+	r8168d_modify_extpage(phydev, 0x0023, 0x17, 0x0000, 0x0006);
+
+	/* For impedance matching */
+	phy_modify_paged(phydev, 0x0002, 0x08, 0x7f00, 0x8000);
+
+	/* PHY auto speed down */
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0050);
+	phy_set_bits(phydev, 0x14, BIT(15));
+
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
+	r8168d_phy_param(phydev, 0x8b85, 0x2000, 0x0000);
+
+	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0x1100, 0x0000);
+	phy_write_paged(phydev, 0x0006, 0x00, 0x5a00);
+
+	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0000);
+}
+
+static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+
+	/* Enable Delay cap */
+	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
+
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
+
+	/* Green Setting */
+	r8168d_phy_param(phydev, 0x8b5b, 0xffff, 0x9222);
+	r8168d_phy_param(phydev, 0x8b6d, 0xffff, 0x8000);
+	r8168d_phy_param(phydev, 0x8b76, 0xffff, 0x8000);
+
+	/* For 4-corner performance improve */
+	phy_write(phydev, 0x1f, 0x0005);
+	phy_write(phydev, 0x05, 0x8b80);
+	phy_set_bits(phydev, 0x17, 0x0006);
+	phy_write(phydev, 0x1f, 0x0000);
+
+	/* PHY auto speed down */
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	phy_set_bits(phydev, 0x14, BIT(15));
+
+	/* improve 10M EEE waveform */
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
+
+	/* Improve 2-pair detection performance */
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
+
+	rtl8168f_config_eee_phy(phydev);
+
+	/* Green feature */
+	phy_write(phydev, 0x1f, 0x0003);
+	phy_set_bits(phydev, 0x19, BIT(0));
+	phy_set_bits(phydev, 0x10, BIT(10));
+	phy_write(phydev, 0x1f, 0x0000);
+	phy_modify_paged(phydev, 0x0005, 0x01, 0, BIT(8));
+}
+
+static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	/* For 4-corner performance improve */
+	r8168d_phy_param(phydev, 0x8b80, 0x0000, 0x0006);
+
+	/* PHY auto speed down */
+	r8168d_modify_extpage(phydev, 0x002d, 0x18, 0x0000, 0x0010);
+	phy_set_bits(phydev, 0x14, BIT(15));
+
+	/* Improve 10M EEE waveform */
+	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
+
+	rtl8168f_config_eee_phy(phydev);
+}
+
+static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
+
+	/* Modify green table for giga & fnet */
+	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00fb);
+
+	/* Modify green table for 10M */
+	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
+
+	/* Disable hiimpedance detection (RTCT) */
+	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
+
+	rtl8168f_hw_phy_config(tp, phydev);
+
+	/* Improve 2-pair detection performance */
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
+}
+
+static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+
+	rtl8168f_hw_phy_config(tp, phydev);
+}
+
+static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+
+	rtl8168f_hw_phy_config(tp, phydev);
+
+	/* Improve 2-pair detection performance */
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
+
+	/* Channel estimation fine tune */
+	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
+
+	/* Modify green table for giga & fnet */
+	r8168d_phy_param(phydev, 0x8b55, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5e, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b67, 0xffff, 0x0000);
+	r8168d_phy_param(phydev, 0x8b70, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x17, 0xffff, 0x0000);
+	r8168d_modify_extpage(phydev, 0x0078, 0x19, 0xffff, 0x00aa);
+
+	/* Modify green table for 10M */
+	r8168d_phy_param(phydev, 0x8b79, 0xffff, 0xaa00);
+
+	/* Disable hiimpedance detection (RTCT) */
+	phy_write_paged(phydev, 0x0003, 0x01, 0x328a);
+
+	/* Modify green table for giga */
+	r8168d_phy_param(phydev, 0x8b54, 0x0800, 0x0000);
+	r8168d_phy_param(phydev, 0x8b5d, 0x0800, 0x0000);
+	r8168d_phy_param(phydev, 0x8a7c, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a7f, 0x0000, 0x0100);
+	r8168d_phy_param(phydev, 0x8a82, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a85, 0x0100, 0x0000);
+	r8168d_phy_param(phydev, 0x8a88, 0x0100, 0x0000);
+
+	/* uc same-seed solution */
+	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x8000);
+
+	/* Green feature */
+	phy_write(phydev, 0x1f, 0x0003);
+	phy_clear_bits(phydev, 0x19, BIT(0));
+	phy_clear_bits(phydev, 0x10, BIT(10));
+	phy_write(phydev, 0x1f, 0x0000);
+}
+
+static void rtl8168g_disable_aldps(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
+}
+
+static void rtl8168g_phy_adjust_10m_aldps(struct phy_device *phydev)
+{
+	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(7) | BIT(6));
+	r8168g_phy_param(phydev, 0x8084, 0x6000, 0x0000);
+	phy_modify_paged(phydev, 0x0a43, 0x10, 0x0000, 0x1003);
+}
+
+static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	int ret;
+
+	r8169_apply_firmware(tp);
+
+	ret = phy_read_paged(phydev, 0x0a46, 0x10);
+	if (ret & BIT(8))
+		phy_modify_paged(phydev, 0x0bcc, 0x12, BIT(15), 0);
+	else
+		phy_modify_paged(phydev, 0x0bcc, 0x12, 0, BIT(15));
+
+	ret = phy_read_paged(phydev, 0x0a46, 0x13);
+	if (ret & BIT(8))
+		phy_modify_paged(phydev, 0x0c41, 0x15, 0, BIT(1));
+	else
+		phy_modify_paged(phydev, 0x0c41, 0x15, BIT(1), 0);
+
+	/* Enable PHY auto speed down */
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
+
+	rtl8168g_phy_adjust_10m_aldps(phydev);
+
+	/* EEE auto-fallback function */
+	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
+
+	/* Enable UC LPF tune function */
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
+
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+
+	/* Improve SWR Efficiency */
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
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168g_config_eee_phy(phydev);
+}
+
+static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	r8169_apply_firmware(tp);
+	rtl8168g_config_eee_phy(phydev);
+}
+
+static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	u16 dout_tapbin;
+	u32 data;
+
+	r8169_apply_firmware(tp);
+
+	/* CHN EST parameters adjust - giga master */
+	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
+	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x8000);
+	r8168g_phy_param(phydev, 0x80a4, 0xff00, 0x8500);
+	r8168g_phy_param(phydev, 0x809c, 0xff00, 0xbd00);
+
+	/* CHN EST parameters adjust - giga slave */
+	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x7000);
+	r8168g_phy_param(phydev, 0x80b4, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x80ac, 0xff00, 0x4000);
+
+	/* CHN EST parameters adjust - fnet */
+	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x1200);
+	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xe500);
+	r8168g_phy_param(phydev, 0x8092, 0xff00, 0x9f00);
+
+	/* enable R-tune & PGA-retune function */
+	dout_tapbin = 0;
+	data = phy_read_paged(phydev, 0x0a46, 0x13);
+	data &= 3;
+	data <<= 2;
+	dout_tapbin |= data;
+	data = phy_read_paged(phydev, 0x0a46, 0x12);
+	data &= 0xc000;
+	data >>= 14;
+	dout_tapbin |= data;
+	dout_tapbin = ~(dout_tapbin ^ 0x08);
+	dout_tapbin <<= 12;
+	dout_tapbin &= 0xf000;
+
+	r8168g_phy_param(phydev, 0x827a, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827b, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827c, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x827d, 0xf000, dout_tapbin);
+	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
+	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
+
+	/* enable GPHY 10M */
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+
+	/* SAR ADC performance */
+	phy_modify_paged(phydev, 0x0bca, 0x17, BIT(12) | BIT(13), BIT(14));
+
+	r8168g_phy_param(phydev, 0x803f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8047, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x804f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8057, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x805f, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x8067, 0x3000, 0x0000);
+	r8168g_phy_param(phydev, 0x806f, 0x3000, 0x0000);
+
+	/* disable phy pfm mode */
+	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168h_config_eee_phy(phydev);
+}
+
+static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
+{
+	u16 ioffset, rlen;
+	u32 data;
+
+	r8169_apply_firmware(tp);
+
+	/* CHIN EST parameter update */
+	r8168g_phy_param(phydev, 0x808a, 0x003f, 0x000a);
+
+	/* enable R-tune & PGA-retune function */
+	r8168g_phy_param(phydev, 0x0811, 0x0000, 0x0800);
+	phy_modify_paged(phydev, 0x0a42, 0x16, 0x0000, 0x0002);
+
+	/* enable GPHY 10M */
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+
+	ioffset = rtl8168h_2_get_adc_bias_ioffset(tp);
+	if (ioffset != 0xffff)
+		phy_write_paged(phydev, 0x0bcf, 0x16, ioffset);
+
+	/* Modify rlen (TX LPF corner frequency) level */
+	data = phy_read_paged(phydev, 0x0bcd, 0x16);
+	data &= 0x000f;
+	rlen = 0;
+	if (data > 3)
+		rlen = data - 3;
+	data = rlen | (rlen << 4) | (rlen << 8) | (rlen << 12);
+	phy_write_paged(phydev, 0x0bcd, 0x17, data);
+
+	/* disable phy pfm mode */
+	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168g_config_eee_phy(phydev);
+}
+
+static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
+{
+	/* Enable PHY auto speed down */
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
+
+	rtl8168g_phy_adjust_10m_aldps(phydev);
+
+	/* Enable EEE auto-fallback function */
+	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
+
+	/* Enable UC LPF tune function */
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
+
+	/* set rg_sel_sdm_rate */
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168g_config_eee_phy(phydev);
+}
+
+static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
+				      struct phy_device *phydev)
+{
+	rtl8168g_phy_adjust_10m_aldps(phydev);
+
+	/* Enable UC LPF tune function */
+	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
+
+	/* Set rg_sel_sdm_rate */
+	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
+
+	/* Channel estimation parameters */
+	r8168g_phy_param(phydev, 0x80f3, 0xff00, 0x8b00);
+	r8168g_phy_param(phydev, 0x80f0, 0xff00, 0x3a00);
+	r8168g_phy_param(phydev, 0x80ef, 0xff00, 0x0500);
+	r8168g_phy_param(phydev, 0x80f6, 0xff00, 0x6e00);
+	r8168g_phy_param(phydev, 0x80ec, 0xff00, 0x6800);
+	r8168g_phy_param(phydev, 0x80ed, 0xff00, 0x7c00);
+	r8168g_phy_param(phydev, 0x80f2, 0xff00, 0xf400);
+	r8168g_phy_param(phydev, 0x80f4, 0xff00, 0x8500);
+	r8168g_phy_param(phydev, 0x8110, 0xff00, 0xa800);
+	r8168g_phy_param(phydev, 0x810f, 0xff00, 0x1d00);
+	r8168g_phy_param(phydev, 0x8111, 0xff00, 0xf500);
+	r8168g_phy_param(phydev, 0x8113, 0xff00, 0x6100);
+	r8168g_phy_param(phydev, 0x8115, 0xff00, 0x9200);
+	r8168g_phy_param(phydev, 0x810e, 0xff00, 0x0400);
+	r8168g_phy_param(phydev, 0x810c, 0xff00, 0x7c00);
+	r8168g_phy_param(phydev, 0x810b, 0xff00, 0x5a00);
+	r8168g_phy_param(phydev, 0x80d1, 0xff00, 0xff00);
+	r8168g_phy_param(phydev, 0x80cd, 0xff00, 0x9e00);
+	r8168g_phy_param(phydev, 0x80d3, 0xff00, 0x0e00);
+	r8168g_phy_param(phydev, 0x80d5, 0xff00, 0xca00);
+	r8168g_phy_param(phydev, 0x80d7, 0xff00, 0x8400);
+
+	/* Force PWM-mode */
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
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168g_config_eee_phy(phydev);
+}
+
+static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
+{
+	/* CHN EST parameters adjust - fnet */
+	r8168g_phy_param(phydev, 0x808e, 0xff00, 0x4800);
+	r8168g_phy_param(phydev, 0x8090, 0xff00, 0xcc00);
+	r8168g_phy_param(phydev, 0x8092, 0xff00, 0xb000);
+
+	r8168g_phy_param(phydev, 0x8088, 0xff00, 0x6000);
+	r8168g_phy_param(phydev, 0x808b, 0x3f00, 0x0b00);
+	r8168g_phy_param(phydev, 0x808d, 0x1f00, 0x0600);
+	r8168g_phy_param(phydev, 0x808c, 0xff00, 0xb000);
+	r8168g_phy_param(phydev, 0x80a0, 0xff00, 0x2800);
+	r8168g_phy_param(phydev, 0x80a2, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x809b, 0xf800, 0xb000);
+	r8168g_phy_param(phydev, 0x809a, 0xff00, 0x4b00);
+	r8168g_phy_param(phydev, 0x809d, 0x3f00, 0x0800);
+	r8168g_phy_param(phydev, 0x80a1, 0xff00, 0x7000);
+	r8168g_phy_param(phydev, 0x809f, 0x1f00, 0x0300);
+	r8168g_phy_param(phydev, 0x809e, 0xff00, 0x8800);
+	r8168g_phy_param(phydev, 0x80b2, 0xff00, 0x2200);
+	r8168g_phy_param(phydev, 0x80ad, 0xf800, 0x9800);
+	r8168g_phy_param(phydev, 0x80af, 0x3f00, 0x0800);
+	r8168g_phy_param(phydev, 0x80b3, 0xff00, 0x6f00);
+	r8168g_phy_param(phydev, 0x80b1, 0x1f00, 0x0300);
+	r8168g_phy_param(phydev, 0x80b0, 0xff00, 0x9300);
+
+	r8168g_phy_param(phydev, 0x8011, 0x0000, 0x0800);
+
+	/* enable GPHY 10M */
+	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(11));
+
+	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
+
+	rtl8168g_disable_aldps(phydev);
+	rtl8168h_config_eee_phy(phydev);
+}
+
+static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0003 },
+		{ 0x08, 0x441d },
+		{ 0x01, 0x9100 },
+		{ 0x1f, 0x0000 }
+	};
+
+	phy_set_bits(phydev, 0x11, BIT(12));
+	phy_set_bits(phydev, 0x19, BIT(13));
+	phy_set_bits(phydev, 0x10, BIT(15));
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+}
+
+static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	/* Disable ALDPS before ram code */
+	phy_write(phydev, 0x18, 0x0310);
+	msleep(100);
+
+	r8169_apply_firmware(tp);
+
+	phy_write_paged(phydev, 0x0005, 0x1a, 0x0000);
+	phy_write_paged(phydev, 0x0004, 0x1c, 0x0000);
+	phy_write_paged(phydev, 0x0001, 0x15, 0x7701);
+}
+
+static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
+				  struct phy_device *phydev)
+{
+	/* Disable ALDPS before setting firmware */
+	phy_write(phydev, 0x18, 0x0310);
+	msleep(20);
+
+	r8169_apply_firmware(tp);
+
+	/* EEE setting */
+	phy_write(phydev, 0x1f, 0x0004);
+	phy_write(phydev, 0x10, 0x401f);
+	phy_write(phydev, 0x19, 0x7030);
+	phy_write(phydev, 0x1f, 0x0000);
+}
+
+static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
+				   struct phy_device *phydev)
+{
+	static const struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0004 },
+		{ 0x10, 0xc07f },
+		{ 0x19, 0x7030 },
+		{ 0x1f, 0x0000 }
+	};
+
+	/* Disable ALDPS before ram code */
+	phy_write(phydev, 0x18, 0x0310);
+	msleep(100);
+
+	r8169_apply_firmware(tp);
+
+	rtl_writephy_batch(phydev, phy_reg_init);
+}
+
+static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
+{
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
+	r8168g_phy_param(phydev, 0x80ea, 0xff00, 0xc400);
+	r8168g_phy_param(phydev, 0x80eb, 0x0700, 0x0300);
+	r8168g_phy_param(phydev, 0x80f8, 0xff00, 0x1c00);
+	r8168g_phy_param(phydev, 0x80f1, 0xff00, 0x3000);
+	r8168g_phy_param(phydev, 0x80fe, 0xff00, 0xa500);
+	r8168g_phy_param(phydev, 0x8102, 0xff00, 0x5000);
+	r8168g_phy_param(phydev, 0x8105, 0xff00, 0x3300);
+	r8168g_phy_param(phydev, 0x8100, 0xff00, 0x7000);
+	r8168g_phy_param(phydev, 0x8104, 0xff00, 0xf000);
+	r8168g_phy_param(phydev, 0x8106, 0xff00, 0x6500);
+	r8168g_phy_param(phydev, 0x80dc, 0xff00, 0xed00);
+	r8168g_phy_param(phydev, 0x80df, 0x0000, 0x0100);
+	r8168g_phy_param(phydev, 0x80e1, 0x0100, 0x0000);
+
+	phy_modify_paged(phydev, 0xbf0, 0x13, 0x003f, 0x0038);
+	r8168g_phy_param(phydev, 0x819f, 0xffff, 0xd0b6);
+
+	phy_write_paged(phydev, 0xbc3, 0x12, 0x5555);
+	phy_modify_paged(phydev, 0xbf0, 0x15, 0x0e00, 0x0a00);
+	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
+	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(phydev);
+}
+
+static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
+				    struct phy_device *phydev)
+{
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
+	phy_write(phydev, 0x1f, 0x0000);
+
+	r8168g_phy_param(phydev, 0x8257, 0xffff, 0x020F);
+	r8168g_phy_param(phydev, 0x80ea, 0xffff, 0x7843);
+
+	r8169_apply_firmware(tp);
+
+	phy_modify_paged(phydev, 0xd06, 0x14, 0x0000, 0x2000);
+
+	r8168g_phy_param(phydev, 0x81a2, 0x0000, 0x0100);
+
+	phy_modify_paged(phydev, 0xb54, 0x16, 0xff00, 0xdb00);
+	phy_modify_paged(phydev, 0xa45, 0x12, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa5d, 0x12, 0x0000, 0x0020);
+	phy_modify_paged(phydev, 0xad4, 0x17, 0x0010, 0x0000);
+	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
+	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
+
+	rtl8125_config_eee_phy(phydev);
+}
+
+void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
+			 enum mac_version ver)
+{
+	static const rtl_phy_cfg_fct phy_configs[] = {
+		/* PCI devices. */
+		[RTL_GIGA_MAC_VER_02] = rtl8169s_hw_phy_config,
+		[RTL_GIGA_MAC_VER_03] = rtl8169s_hw_phy_config,
+		[RTL_GIGA_MAC_VER_04] = rtl8169sb_hw_phy_config,
+		[RTL_GIGA_MAC_VER_05] = rtl8169scd_hw_phy_config,
+		[RTL_GIGA_MAC_VER_06] = rtl8169sce_hw_phy_config,
+		/* PCI-E devices. */
+		[RTL_GIGA_MAC_VER_07] = rtl8102e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_08] = rtl8102e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_09] = rtl8102e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_10] = NULL,
+		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
+		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
+		[RTL_GIGA_MAC_VER_13] = NULL,
+		[RTL_GIGA_MAC_VER_14] = NULL,
+		[RTL_GIGA_MAC_VER_15] = NULL,
+		[RTL_GIGA_MAC_VER_16] = NULL,
+		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
+		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_19] = rtl8168c_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_20] = rtl8168c_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_21] = rtl8168c_3_hw_phy_config,
+		[RTL_GIGA_MAC_VER_22] = rtl8168c_3_hw_phy_config,
+		[RTL_GIGA_MAC_VER_23] = rtl8168cp_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_24] = rtl8168cp_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_25] = rtl8168d_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_26] = rtl8168d_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_27] = rtl8168d_3_hw_phy_config,
+		[RTL_GIGA_MAC_VER_28] = rtl8168d_4_hw_phy_config,
+		[RTL_GIGA_MAC_VER_29] = rtl8105e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_30] = rtl8105e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_31] = NULL,
+		[RTL_GIGA_MAC_VER_32] = rtl8168e_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_33] = rtl8168e_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_34] = rtl8168e_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_35] = rtl8168f_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_36] = rtl8168f_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_37] = rtl8402_hw_phy_config,
+		[RTL_GIGA_MAC_VER_38] = rtl8411_hw_phy_config,
+		[RTL_GIGA_MAC_VER_39] = rtl8106e_hw_phy_config,
+		[RTL_GIGA_MAC_VER_40] = rtl8168g_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_41] = NULL,
+		[RTL_GIGA_MAC_VER_42] = rtl8168g_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_43] = rtl8168g_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_44] = rtl8168g_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_45] = rtl8168h_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_46] = rtl8168h_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_47] = rtl8168h_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_48] = rtl8168h_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_49] = rtl8168ep_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
+		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
+	};
+
+	if (phy_configs[ver])
+		phy_configs[ver](tp, phydev);
+}
-- 
2.24.1


