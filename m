Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D3430102
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbhJPH52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:57:28 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59664
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243865AbhJPH5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:57:24 -0400
Received: from HP-EliteBook-840-G7.. (36-229-230-94.dynamic-ip.hinet.net [36.229.230.94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id DC87C40006;
        Sat, 16 Oct 2021 07:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634370915;
        bh=WbQv6oPb1QFRBHz9o1HwS5Mct/9dMxmdCirjkKp6IZQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MYwwx3roTtFeDMTbBOWAMCQF7fK2MqHnVsTw8SRPlkcAKKUYCbdGtQ+mtiieEENUI
         D+iIblVy5oaLLvtPfOATySorIlFPitCijzCx8K/YlHjimT7ZJAPceA/gPbWNr9X3Uf
         n4ETXDaY5HG7VEObbd4AHH0s5MxHsGCEgrtwtOEoHqBbEx/rzRCYjS8ZLCkbYhFAg1
         4OiMfmTOSjC39BN4OFFmXQbVcjhvlzCBe2mtyoBUwvkYZZkhlpIylbBoyuQAbkvmPt
         F4Lo99+/hJQnbzWaGCKQGY+xSL7J/O24nq/AU8/+CkjrCLlE/ympoAr91HW5WxCwDz
         //MiDXH6wbaqg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v7 4/4] r8169: Implement dynamic ASPM mechanism
Date:   Sat, 16 Oct 2021 15:54:42 +0800
Message-Id: <20211016075442.650311-5-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211016075442.650311-1-kai.heng.feng@canonical.com>
References: <20211016075442.650311-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
Same issue can be observed with older vendor drivers.

The issue is however solved by the latest vendor driver. There's a new
mechanism, which disables r8169's internal ASPM when the NIC traffic has
more than 10 packets per second, and vice versa. The possible reason for
this is likely because the buffer on the chip is too small for its ASPM
exit latency.

Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
use dynamic ASPM under Windows. So implement the same mechanism here to
resolve the issue.

Also introduce a lock to prevent race on accessing config registers.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214307
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v7:
 - Split out mutex into another patch.

v6:
 - Wording change.
 - Add bugzilla link.

v5:
 - Split out aspm_manageable replacement as another patch.
 - Introduce a lock for lock_config_regs() and unlock_config_regs().

v4:
 - Squash two patches
 - Remove aspm_manageable and use pcie_aspm_capable()
   pcie_aspm_enabled() accordingly

v3:
 - Use msecs_to_jiffies() for delay time
 - Use atomic_t instead of mutex for bh
 - Mention the buffer size and ASPM exit latency in commit message

v2: 
 - Use delayed_work instead of timer_list to avoid interrupt context
 - Use mutex to serialize packet counter read/write
 - Wording change

 drivers/net/ethernet/realtek/r8169_main.c | 53 ++++++++++++++++++++---
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b91de853e60f0..b8f9811a32a3b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -624,6 +624,10 @@ struct rtl8169_private {
 	struct mutex config_lock;
 
 	unsigned supports_gmii:1;
+	unsigned rtl_aspm_enabled:1;
+	struct delayed_work aspm_toggle;
+	atomic_t aspm_packet_count;
+
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -2673,6 +2677,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
 		return;
 
+	tp->rtl_aspm_enabled = enable;
+
 	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
@@ -4411,6 +4417,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 
+	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		u32 status;
@@ -4555,6 +4562,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 		rtl8169_mark_to_asic(desc);
 	}
 
+	atomic_add(count, &tp->aspm_packet_count);
+
 	return count;
 }
 
@@ -4662,8 +4671,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
+#define ASPM_PACKET_THRESHOLD 10
+#define ASPM_TOGGLE_INTERVAL 1000
+
+static void rtl8169_aspm_toggle(struct work_struct *work)
+{
+	struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
+						  aspm_toggle.work);
+	int packet_count;
+	bool enable;
+
+	packet_count = atomic_xchg(&tp->aspm_packet_count, 0);
+
+	if (pcie_aspm_enabled(tp->pci_dev)) {
+		enable = packet_count <= ASPM_PACKET_THRESHOLD;
+
+		if (tp->rtl_aspm_enabled != enable) {
+			rtl_unlock_config_regs(tp);
+			rtl_hw_aspm_clkreq_enable(tp, enable);
+			rtl_lock_config_regs(tp);
+		}
+	} else if (tp->rtl_aspm_enabled) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, false);
+		rtl_lock_config_regs(tp);
+	}
+
+	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
+}
+
 static void rtl8169_down(struct rtl8169_private *tp)
 {
+	cancel_delayed_work_sync(&tp->aspm_toggle);
+
 	/* Clear all task flags */
 	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
@@ -4690,6 +4730,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
+
+	/* pcie_aspm_capable may change after system resume */
+	if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev))
+		schedule_delayed_work(&tp->aspm_toggle, 0);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -5277,11 +5321,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM L1 as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
 	if (rc < 0) {
@@ -5350,6 +5389,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
+	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
+
+	atomic_set(&tp->aspm_packet_count, 0);
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
-- 
2.32.0

