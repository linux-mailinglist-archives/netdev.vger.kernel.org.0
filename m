Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC6C5F28A7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiJCGq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJCGq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:46:57 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC3773EA4A
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:46:54 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2936k6M41005956, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2936k6M41005956
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 3 Oct 2022 14:46:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 14:46:32 +0800
Received: from localhost.localdomain (172.21.182.184) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 3 Oct 2022 14:46:31 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <kuba@kernel.org>, <grundler@chromium.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next] r8169: fix rtl8125b dmar pte write access not set error
Date:   Mon, 3 Oct 2022 14:46:20 +0800
Message-ID: <20221003064620.28194-1-hau@realtek.com>
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
X-KSE-Antiphishing-Bases: 10/03/2022 06:28:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzMgpFekyCAwMTo0ODowMA==?=
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

When close device, rx will be enabled if wol is enabeld. When open device
it will cause rx to dma to wrong address after pci_set_master().

In this patch, driver will disable tx/rx when close device. If wol is
eanbled only enable rx filter and disable rxdv_gate to let hardware can
receive packet to fifo but not to dma it.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 57 +++++++++++------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73d061d9fcb..25d02b0467b9 100644
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
@@ -2455,6 +2433,30 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 	rtl_wait_txrx_fifo_empty(tp);
 }
 
+static void rtl_wol_enable_rx(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
+		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
+			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
+
+	rtl_disable_rxdvgate(tp);
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
@@ -3872,7 +3874,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
-static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
+static void rtl8169_cleanup(struct rtl8169_private *tp)
 {
 	napi_disable(&tp->napi);
 
@@ -3884,9 +3886,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 
 	rtl_rx_close(tp);
 
-	if (going_down && tp->dev->wol_enabled)
-		goto no_reset;
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
@@ -3907,7 +3906,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
 	}
 
 	rtl_hw_reset(tp);
-no_reset:
+
 	rtl8169_tx_clear(tp);
 	rtl8169_init_ring_indexes(tp);
 }
@@ -3918,7 +3917,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 
 	netif_stop_queue(tp->dev);
 
-	rtl8169_cleanup(tp, false);
+	rtl8169_cleanup(tp);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
@@ -4604,7 +4603,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	pci_clear_master(tp->pci_dev);
 	rtl_pci_commit(tp);
 
-	rtl8169_cleanup(tp, true);
+	rtl8169_cleanup(tp);
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 }
-- 
2.25.1

