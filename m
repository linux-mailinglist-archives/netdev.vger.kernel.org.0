Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934084611E7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhK2KSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:18:54 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38097 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhK2KQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:16:53 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1ATADYfsC027594, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1ATADYfsC027594
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Nov 2021 18:13:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 18:13:33 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 29 Nov
 2021 18:13:33 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [RFC PATCH 1/4] r8169: remove the relative code about dash
Date:   Mon, 29 Nov 2021 18:13:12 +0800
Message-ID: <20211129101315.16372-382-nic_swsd@realtek.com>
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
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the relative code of dash, except for RTL8111DP.

The flow of initialization is different when considering supporting the
dash, so remove the relative code first.

The RTL8111DP has the different design and is stopped to maintain, so
keep the current behavior is enough.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 70 ++---------------------
 1 file changed, 5 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3d6843332c77..fd295bcd125c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -245,10 +245,6 @@ enum rtl_registers {
 	FuncEvent	= 0xf0,
 	FuncEventMask	= 0xf4,
 	FuncPresetState	= 0xf8,
-	IBCR0           = 0xf8,
-	IBCR2           = 0xf9,
-	IBIMR0          = 0xfa,
-	IBISR0          = 0xfb,
 	FuncForceEvent	= 0xfc,
 };
 
@@ -1127,67 +1123,18 @@ DECLARE_RTL_COND(rtl_dp_ocp_read_cond)
 	return r8168dp_ocp_read(tp, reg) & 0x00000800;
 }
 
-DECLARE_RTL_COND(rtl_ep_ocp_read_cond)
-{
-	return r8168ep_ocp_read(tp, 0x124) & 0x00000001;
-}
-
-DECLARE_RTL_COND(rtl_ocp_tx_cond)
-{
-	return RTL_R8(tp, IBISR0) & 0x20;
-}
-
-static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
-{
-	RTL_W8(tp, IBCR2, RTL_R8(tp, IBCR2) & ~0x01);
-	rtl_loop_wait_high(tp, &rtl_ocp_tx_cond, 50000, 2000);
-	RTL_W8(tp, IBISR0, RTL_R8(tp, IBISR0) | 0x20);
-	RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
-}
-
 static void rtl8168dp_driver_start(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
 	rtl_loop_wait_high(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
-static void rtl8168ep_driver_start(struct rtl8169_private *tp)
-{
-	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_START);
-	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 10);
-}
-
-static void rtl8168_driver_start(struct rtl8169_private *tp)
-{
-	if (tp->dash_type == RTL_DASH_DP)
-		rtl8168dp_driver_start(tp);
-	else
-		rtl8168ep_driver_start(tp);
-}
-
 static void rtl8168dp_driver_stop(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_STOP);
 	rtl_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
-static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
-{
-	rtl8168ep_stop_cmac(tp);
-	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_STOP);
-	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
-}
-
-static void rtl8168_driver_stop(struct rtl8169_private *tp)
-{
-	if (tp->dash_type == RTL_DASH_DP)
-		rtl8168dp_driver_stop(tp);
-	else
-		rtl8168ep_driver_stop(tp);
-}
-
 static bool r8168dp_check_dash(struct rtl8169_private *tp)
 {
 	u16 reg = rtl8168_get_ocp_reg(tp);
@@ -3227,8 +3174,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 {
-	rtl8168ep_stop_cmac(tp);
-
 	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
 	rtl8168g_set_pause_thresholds(tp, 0x2f, 0x5f);
 
@@ -3324,8 +3269,6 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 	};
 	int rg_saw_cnt;
 
-	rtl8168ep_stop_cmac(tp);
-
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8117);
@@ -4968,8 +4911,8 @@ static void rtl_remove_one(struct pci_dev *pdev)
 
 	unregister_netdev(tp->dev);
 
-	if (tp->dash_type != RTL_DASH_NONE)
-		rtl8168_driver_stop(tp);
+	if (tp->dash_type == RTL_DASH_DP)
+		rtl8168dp_driver_stop(tp);
 
 	rtl_release_firmware(tp);
 
@@ -5161,10 +5104,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
-		rtl8168ep_stop_cmac(tp);
-		fallthrough;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		rtl_hw_init_8168g(tp);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
@@ -5443,9 +5383,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
 			    "ok" : "ko");
 
-	if (tp->dash_type != RTL_DASH_NONE) {
+	if (tp->dash_type == RTL_DASH_DP) {
 		netdev_info(dev, "DASH enabled\n");
-		rtl8168_driver_start(tp);
+		rtl8168dp_driver_start(tp);
 	}
 
 	if (pci_dev_run_wake(pdev))
-- 
2.31.1

