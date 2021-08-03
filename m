Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6973DF171
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhHCPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:30:06 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:58306
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236820AbhHCP3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:29:04 -0400
Received: from localhost (36-229-239-123.dynamic-ip.hinet.net [36.229.239.123])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 940D43F0F8;
        Tue,  3 Aug 2021 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628004520;
        bh=LqOeJ8mEKmfOoRP9FP3XOeFTzokfryMcK7iPHjhmqGE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MjDRJEezUxjRkBPtMVv3lTpsQrx2fmWVsbBXc1zIoK9jRt6yLLwKAlc1qUUDlpSjE
         qSV+TgiNXaMBE/R7YNuXFIl4j8BUPYuSHtnfe4H3Ic5k9x1KIxwnxpDTwdlRO8OimE
         rV6WmIHlZmGVVBkbvmrmjeMscn0m3S+HWDCDt3P8WvBt9FU/fKaXz20aD3ioq79qrW
         webKg9s9YvZV3XruH1WTGy+Rl55nYX8fQLUyjsfyi6RKasjF9LwiB1DSxAPjGVXJiC
         Lep9ezES7XJsja5h8RJZdrJ30OIo/ng4At1yh0cKhKQQUaGcUS6OvTTlm2LfSzGN95
         1Ge9pTHcFbGGw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] r8169: Enable ASPM for selected NICs
Date:   Tue,  3 Aug 2021 23:28:23 +0800
Message-Id: <20210803152823.515849-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803152823.515849-1-kai.heng.feng@canonical.com>
References: <20210803152823.515849-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The latest vendor driver enables ASPM for more recent r8168 NICs, do the
same here to match the behavior.

In addition, pci_disable_link_state() is only used for RTL8168D/8111D in
vendor driver, also match that.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++++++++------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e257d3cd885e..ec09c13514bd 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -623,7 +623,7 @@ struct rtl8169_private {
 	} wk;
 
 	unsigned supports_gmii:1;
-	unsigned aspm_manageable:1;
+	unsigned aspm_supported:1;
 	unsigned aspm_enabled:1;
 	struct timer_list aspm_timer;
 	u32 aspm_packet_count;
@@ -2666,8 +2666,11 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
+	if (!tp->aspm_supported)
+		return;
+
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
-	if (enable && tp->aspm_manageable) {
+	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 	} else {
@@ -5279,6 +5282,21 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	rtl_rar_set(tp, mac_addr);
 }
 
+static int rtl_hw_aspm_supported(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_36:
+	case RTL_GIGA_MAC_VER_38:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
+	case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_46:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_63:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
@@ -5310,12 +5328,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM completely as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
-					  PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
+	if (tp->mac_version == RTL_GIGA_MAC_VER_25)
+		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
+				       PCIE_LINK_STATE_L1 |
+				       PCIE_LINK_STATE_CLKPM);
+
+	tp->aspm_supported = rtl_hw_aspm_supported(tp);
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
-- 
2.31.1

