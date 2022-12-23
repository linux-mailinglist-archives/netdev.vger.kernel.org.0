Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7D654CF4
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 08:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiLWHnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 02:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbiLWHnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 02:43:33 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B09681AA08
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 23:43:31 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BN7gZ241030432, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BN7gZ241030432
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 23 Dec 2022 15:42:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 23 Dec 2022 15:43:27 +0800
Received: from localhost.localdomain (172.21.182.190) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 23 Dec 2022 15:43:26 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net v2] r8169: fix rtl8125b dmar pte write access not set error
Date:   Fri, 23 Dec 2022 15:43:21 +0800
Message-ID: <20221223074321.4862-1-hau@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.190]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/23/2022 07:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzIzIKRXpMggMDQ6MjY6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When close device, if wol is enabled, rx will be enabled. When open device
it will cause rx to dma to the wrong memory address after pci_set_master().
System log will show blow messages.

DMAR: DRHD: handling fault status reg 3
DMAR: [DMA Write] Request device [02:00.0] PASID ffffffff fault addr ffdd4000 [fault reason 05] PTE Write access is not set

In this patch, driver disable tx/rx when close device. If wol is
enabled, only enable rx filter and disable rxdv_gate to let hardware only
receive packet to fifo but not to dma it.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
v1 -> v2: update commit message and adjust the code according to current kernel code.

 drivers/net/ethernet/realtek/r8169_main.c | 58 +++++++++++------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a9dcc98b6af1..24592d972523 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2210,28 +2210,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void rtl_wol_enable_rx(struct rtl8169_private *tp)
-{
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
-		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
-			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
-}
-
-static void rtl_prepare_power_down(struct rtl8169_private *tp)
-{
-	if (tp->dash_type != RTL_DASH_NONE)
-		return;
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_33)
-		rtl_ephy_write(tp, 0x19, 0xff64);
-
-	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
-		rtl_wol_enable_rx(tp);
-	}
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -2455,6 +2433,31 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 	rtl_wait_txrx_fifo_empty(tp);
 }
 
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
+		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
+			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
+		rtl_disable_rxdvgate(tp);
+}
+
+static void rtl_prepare_power_down(struct rtl8169_private *tp)
+{
+	if (tp->dash_type != RTL_DASH_NONE)
+		return;
+
+	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_33)
+		rtl_ephy_write(tp, 0x19, 0xff64);
+
+	if (device_may_wakeup(tp_to_dev(tp))) {
+		phy_speed_down(tp->phydev, false);
+		rtl_wol_enable_rx(tp);
+	}
+}
+
 static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
 {
 	u32 val = TX_DMA_BURST << TxDMAShift |
@@ -3872,7 +3875,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
-static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
+static void rtl8169_cleanup(struct rtl8169_private *tp)
 {
 	napi_disable(&tp->napi);
 
@@ -3884,9 +3887,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 
 	rtl_rx_close(tp);
 
-	if (going_down && tp->dev->wol_enabled)
-		goto no_reset;
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
@@ -3907,7 +3907,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 	}
 
 	rtl_hw_reset(tp);
-no_reset:
+
 	rtl8169_tx_clear(tp);
 	rtl8169_init_ring_indexes(tp);
 }
@@ -3918,7 +3918,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 
 	netif_stop_queue(tp->dev);
 
-	rtl8169_cleanup(tp, false);
+	rtl8169_cleanup(tp);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
@@ -4605,7 +4605,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	pci_clear_master(tp->pci_dev);
 	rtl_pci_commit(tp);
 
-	rtl8169_cleanup(tp, true);
+	rtl8169_cleanup(tp);
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 }
-- 
2.25.1

