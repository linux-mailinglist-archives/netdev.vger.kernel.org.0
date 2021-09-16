Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE71340DE5E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbhIPPqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:46:08 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33106
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239309AbhIPPqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 11:46:05 -0400
Received: from HP-EliteBook-840-G7.. (1-171-209-135.dynamic-ip.hinet.net [1.171.209.135])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2D97241337;
        Thu, 16 Sep 2021 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631807083;
        bh=LvsEOQzKp932y4GbsUx/YluaBhXdBn4DLLIYXB/gwho=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kYVgKNQIFRmrly8f46nOQLdb4pLhuS2p6BaBAcEP5jSpaZBlisvF03pZC4qd2xWTE
         d+I5owt2hRu7RjTGjNv3ISp/2FVAc7Y7cHx1/O8aawps0gSsrxotCJ0+udIg4yIXvH
         bcN9MB9UDHg2ZdF500WH9dgBX8RMiekNL6dJKV3w9BE5cXoDxITqoMh+J+ZdnPGM7r
         JXKRSlqpdOFtIxL9AT8jjghkmtDc29s4AW5Y8XFwgfDxLYY2LPVs5Lsb97gZmhzr1I
         k1NfyYFjZy7DDqFNtqveNP5yDn2cq10vP1vdexquGm5/LKy3m5Inuz4xWfE1xpAjY8
         +Ygs/9EjH4M8Q==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v5 3/3] r8169: Implement dynamic ASPM mechanism
Date:   Thu, 16 Sep 2021 23:44:17 +0800
Message-Id: <20210916154417.664323-4-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916154417.664323-1-kai.heng.feng@canonical.com>
References: <20210916154417.664323-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
Same issue can be observed with older vendor drivers.

The issue is however solved by the latest vendor driver. There's a new
mechanism, which disables r8169's internal ASPM when the NIC traffic has
more than 10 packets, and vice versa. The possible reason for this is
likely because the buffer on the chip is too small for its ASPM exit
latency.

Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
use dynamic ASPM under Windows. So implement the same mechanism here to
resolve the issue.

Also introduce a lock to prevent race on accessing config registers.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
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

 drivers/net/ethernet/realtek/r8169_main.c | 58 +++++++++++++++++++++--
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6f1a9bec40c05..0994967aa971f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -622,6 +622,11 @@ struct rtl8169_private {
 	} wk;
 
 	unsigned supports_gmii:1;
+	unsigned rtl_aspm_enabled:1;
+	struct delayed_work aspm_toggle;
+	atomic_t aspm_packet_count;
+	struct mutex config_lock;
+
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -670,12 +675,14 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
+	mutex_lock(&tp->config_lock);
 	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
+	mutex_unlock(&tp->config_lock);
 }
 
 static void rtl_pci_commit(struct rtl8169_private *tp)
@@ -2669,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	if (!pcie_aspm_enabled(pdev) && enable)
 		return;
 
+	tp->rtl_aspm_enabled = enable;
+
 	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
@@ -4407,6 +4416,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 
+	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		u32 status;
@@ -4551,6 +4561,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 		rtl8169_mark_to_asic(desc);
 	}
 
+	atomic_add(count, &tp->aspm_packet_count);
+
 	return count;
 }
 
@@ -4658,8 +4670,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
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
 
@@ -4686,6 +4729,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
+
+	/* pcie_aspm_capable may change after system resume */
+	if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev))
+		schedule_delayed_work(&tp->aspm_toggle, 0);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -5273,11 +5320,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -5307,6 +5349,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	mutex_init(&tp->config_lock);
+
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
 	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
@@ -5344,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
+	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
+
+	atomic_set(&tp->aspm_packet_count, 0);
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
-- 
2.32.0

