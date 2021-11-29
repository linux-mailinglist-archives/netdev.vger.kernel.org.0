Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36C24611E8
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhK2KSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:18:54 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38098 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhK2KQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:16:54 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1ATADYTe8027598, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1ATADYTe8027598
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Nov 2021 18:13:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 18:13:34 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 29 Nov
 2021 18:13:33 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [RFC PATCH 2/4] r8169: add type2 access functions
Date:   Mon, 29 Nov 2021 18:13:13 +0800
Message-ID: <20211129101315.16372-383-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211129101315.16372-381-nic_swsd@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/29/2021 10:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzExLzI5IKRXpMggMDg6MjY6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type2 functions are used to access the OOB registers of RTL8111EP
and RTL8111FP(RTL8117). The OOB registers are used to control the
settings about dash.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.h      |  3 ++
 drivers/net/ethernet/realtek/r8169_main.c | 39 +++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 8da4b66b71b5..7db647b4796f 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -77,3 +77,6 @@ u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp);
 u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr);
 void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 			 enum mac_version ver);
+
+u32 r8168_type2_read(struct rtl8169_private *tp, u32 addr);
+void r8168_type2_write(struct rtl8169_private *tp, u8 mask, u32 addr, u32 val);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fd295bcd125c..eb56b91fe41b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1071,6 +1071,45 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
+static u32 r8168_dash_adjust_addr(struct rtl8169_private *tp, u32 addr)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_51:
+		return ((addr & 0xf000) << 8) | (addr & 0xfff);
+	case RTL_GIGA_MAC_VER_52 ... RTL_GIGA_MAC_VER_53:
+		return ((addr & 0xfff000) << 6) | (addr & 0xfff);
+	default:
+		WARN_ON_ONCE(1);
+		return (addr & 0xfff);
+	}
+}
+
+u32 r8168_type2_read(struct rtl8169_private *tp, u32 addr)
+{
+	u32 cmd = ERIAR_READ_CMD | ERIAR_OOB | ERIAR_MASK_1111;
+
+	cmd |= r8168_dash_adjust_addr(tp, addr);
+	RTL_W32(tp, ERIAR, cmd);
+
+	return rtl_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
+		RTL_R32(tp, ERIDR) : ~0;
+}
+
+void r8168_type2_write(struct rtl8169_private *tp, u8 mask, u32 addr, u32 val)
+{
+	u32 cmd = ERIAR_WRITE_CMD | ERIAR_OOB |
+		  ((u32)mask & 0x0f) << ERIAR_MASK_SHIFT;
+
+	if (WARN(addr & 3 || !mask, "addr: 0x%x, mask: 0x%08x\n", addr, mask))
+		return;
+
+	RTL_W32(tp, ERIDR, val);
+	cmd |= r8168_dash_adjust_addr(tp, addr);
+	RTL_W32(tp, ERIAR, cmd);
+
+	rtl_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
+}
+
 static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u16 reg)
 {
 	RTL_W32(tp, OCPAR, 0x0fu << 12 | (reg & 0x0fff));
-- 
2.31.1

