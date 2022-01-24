Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EBA498824
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbiAXSTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:19:46 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36787 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiAXSTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:19:45 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20OIJidM6007118, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20OIJidM6007118
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Jan 2022 02:19:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 02:19:44 +0800
Received: from localhost.localdomain (172.21.182.163) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 25 Jan 2022 02:19:43 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
Date:   Tue, 25 Jan 2022 02:19:37 +0800
Message-ID: <20220124181937.6331-1-hau@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.163]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/24/2022 18:00:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMjQgpFWkyCAwMjo1OTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will enable RTL8125 ASPM L1.2 on the platforms that have
tested RTL8125 with ASPM L1.2 enabled.
Register mac ocp 0xc0b2 will help to identify if RTL8125 has been tested
on L1.2 enabled platform. If it is, this register will be set to 0xf.
If not, this register will be default value 0.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 99 ++++++++++++++++++-----
 1 file changed, 79 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 19e2621e0645..b1e013969d4c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2238,21 +2238,6 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
 			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
 }
 
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
@@ -2650,6 +2635,34 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Rdy_to_L23);
 }
 
+static void rtl_disable_exit_l1(struct rtl8169_private *tp)
+{
+	/* Bits control which events trigger ASPM L1 exit:
+	 * Bit 12: rxdv
+	 * Bit 11: ltr_msg
+	 * Bit 10: txdma_poll
+	 * Bit  9: xadm
+	 * Bit  8: pktavi
+	 * Bit  7: txpla
+	 */
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_36:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
+		break;
+	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
+		rtl_eri_clear_bits(tp, 0xd4, 0x0c00);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
+		rtl_eri_clear_bits(tp, 0xd4, 0x1f80);
+		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
+		break;
+	default:
+		break;
+	}
+}
+
 static void rtl_enable_exit_l1(struct rtl8169_private *tp)
 {
 	/* Bits control which events trigger ASPM L1 exit:
@@ -2692,6 +2705,33 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	udelay(10);
 }
 
+static void rtl_hw_aspm_l12_enable(struct rtl8169_private *tp, bool enable)
+{
+	/* Don't enable L1.2 in the chip if OS can't control ASPM */
+	if (enable && tp->aspm_manageable) {
+		r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
+		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
+	} else {
+		r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
+	}
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
+		rtl_disable_exit_l1(tp);
+		phy_speed_down(tp->phydev, false);
+		rtl_wol_enable_rx(tp);
+	}
+}
+
 static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
 			      u16 tx_stat, u16 rx_dyn, u16 tx_dyn)
 {
@@ -3675,6 +3715,7 @@ static void rtl_hw_start_8125b(struct rtl8169_private *tp)
 	rtl_ephy_init(tp, e_info_8125b);
 	rtl_hw_start_8125_common(tp);
 
+	rtl_hw_aspm_l12_enable(tp, true);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
@@ -5255,6 +5296,20 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	rtl_rar_set(tp, mac_addr);
 }
 
+/* mac ocp 0xc0b2 will help to identify if RTL8125 has been tested
+ * on L1.2 enabled platform. If it is, this register will be set to 0xf.
+ * If not, this register will be default value 0.
+ */
+static bool rtl_platform_l12_enabled(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+		return (r8168_mac_ocp_read(tp, 0xc0b2) & 0xf) ? true : false;
+	default:
+		return false;
+	}
+}
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
@@ -5333,11 +5388,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Chips from RTL8168h partially have issues with L1.2, but seem
 	 * to work fine with L1 and L1.1.
 	 */
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
-	else
-		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
+	if (!rtl_platform_l12_enabled(tp)) {
+		if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
+			rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
+		else
+			rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
+		tp->aspm_manageable = !rc;
+	} else {
+		tp->aspm_manageable = pcie_aspm_enabled(pdev);
+	}
 
 	tp->dash_type = rtl_check_dash(tp);
 
-- 
2.25.1

