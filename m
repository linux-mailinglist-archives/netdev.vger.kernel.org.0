Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4663F9D68
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhH0RQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:16:10 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56030
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237109AbhH0RQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:16:06 -0400
Received: from HP-EliteBook-840-G7.. (36-229-239-33.dynamic-ip.hinet.net [36.229.239.33])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 4E5CF3F365;
        Fri, 27 Aug 2021 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630084516;
        bh=JZTBe+6D0b0nwb0hC4USY+7kj8DQrqSm1hUn4WQZTPU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kMdV511CysiOPiydh2ZP9QzP7cyZQK5a9/eWjzZbXWjgE2cOeuFLfLQ0ptZeNYDJV
         5j2nsJ+aOCYGGUoX3BHjoa5CsPpoNYDSQI8VISnPzBEFyoK3UElNq9FVKimDp+bC+D
         FLjCRhfpKI4UfdUBnOMoYIa+KvdSX/6lFX/9L9ID10E/5bP7o1qUcfogvZQpjokSwR
         KD1oErBswNcHzSZMZj7ve6ngNl5cK/ei987fOTnSniZoVI3sQWgWr5OM+rjaAGGJwW
         qm4BMNSRN94nTLCN9tt32fPt/iewLPEJOLOv8JSPkcluGZ3b/Ulc8wYZgLjecVNX+i
         ADoiWIZcHNHRw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic ASPM mechanism
Date:   Sat, 28 Aug 2021 01:14:52 +0800
Message-Id: <20210827171452.217123-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210827171452.217123-1-kai.heng.feng@canonical.com>
References: <20210827171452.217123-1-kai.heng.feng@canonical.com>
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

Because ASPM control may not be granted by BIOS while ASPM is enabled,
remove aspm_manageable and use pcie_aspm_capable() instead. If BIOS
enables ASPM for the device, we want to enable dynamic ASPM on it.

In addition, since PCIe ASPM can be switched via sysfs, enable/disable
dynamic ASPM accordingly by checking pcie_aspm_enabled().

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
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
 drivers/net/ethernet/realtek/r8169_main.c | 77 ++++++++++++++++++++---
 1 file changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46a6ff9a782d7..97dba8f437b78 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -623,7 +623,10 @@ struct rtl8169_private {
 	} wk;
 
 	unsigned supports_gmii:1;
-	unsigned aspm_manageable:1;
+	unsigned rtl_aspm_enabled:1;
+	struct delayed_work aspm_toggle;
+	atomic_t aspm_packet_count;
+
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -698,6 +701,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 	       tp->mac_version <= RTL_GIGA_MAC_VER_53;
 }
 
+static int rtl_supports_aspm(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_31:
+	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_39:
+	case RTL_GIGA_MAC_VER_43:
+	case RTL_GIGA_MAC_VER_47:
+		return 0;
+	default:
+		return 1;
+	}
+}
+
 static bool rtl_supports_eee(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
@@ -2699,8 +2716,15 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
+	struct pci_dev *pdev = tp->pci_dev;
+
+	if (!pcie_aspm_enabled(pdev) && enable)
+		return;
+
+	tp->rtl_aspm_enabled = enable;
+
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
-	if (enable && tp->aspm_manageable) {
+	if (enable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 	} else {
@@ -4440,6 +4464,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 
+	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		u32 status;
@@ -4584,6 +4609,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 		rtl8169_mark_to_asic(desc);
 	}
 
+	atomic_add(count, &tp->aspm_packet_count);
+
 	return count;
 }
 
@@ -4691,8 +4718,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
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
 
@@ -4719,6 +4777,11 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
+
+	/* pcie_aspm_capable may change after system resume */
+	if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev) &&
+	    rtl_supports_aspm(tp))
+		schedule_delayed_work(&tp->aspm_toggle, 0);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -5306,12 +5369,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* Disable ASPM L1 as that cause random device stop working
-	 * problems as well as full system hangs for some PCIe devices users.
-	 */
-	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-	tp->aspm_manageable = !rc;
-
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
 	if (rc < 0) {
@@ -5378,6 +5435,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
+	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
+
+	atomic_set(&tp->aspm_packet_count, 0);
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
-- 
2.32.0

