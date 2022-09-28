Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395125EDD6B
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI1ND2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiI1ND1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:03:27 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 951E2617D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 06:03:24 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 28SD2taG6032709, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 28SD2taG6032709
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 28 Sep 2022 21:02:55 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 21:03:21 +0800
Received: from localhost.localdomain (172.21.182.184) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 28 Sep 2022 21:03:20 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next v2] r8169: add rtl_disable_rxdvgate()
Date:   Wed, 28 Sep 2022 21:03:17 +0800
Message-ID: <20220928130317.3522-1-hau@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.184]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/28/2022 12:46:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzkvMjggpFekyCAwOTozOTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl_disable_rxdvgate() is used for disable RXDV_GATE. It is opposite function
of rtl_enable_rxdvgate().

Disable RXDV_GATE does not have to delay. So in this patch, also remove the
delay after disale RXDV_GATE.

v2:
- update commit message.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c21894d0518..956562797496 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2443,6 +2443,11 @@ static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_disable_rxdvgate(struct rtl8169_private *tp)
+{
+	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+}
+
 static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 {
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
@@ -2960,7 +2965,7 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f);
 
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+	rtl_disable_rxdvgate(tp);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -3198,7 +3203,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+	rtl_disable_rxdvgate(tp);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -3249,7 +3254,7 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+	rtl_disable_rxdvgate(tp);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -3313,7 +3318,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0x5f0, ERIAR_MASK_0011, 0x4f87);
 
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
+	rtl_disable_rxdvgate(tp);
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
@@ -3557,8 +3562,7 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	else
 		rtl8125a_config_eee_mac(tp);
 
-	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
-	udelay(10);
+	rtl_disable_rxdvgate(tp);
 }
 
 static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
-- 
2.25.1

