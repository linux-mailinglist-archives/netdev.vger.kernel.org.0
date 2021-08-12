Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB82B3EA811
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbhHLPzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:55:13 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:38248
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238351AbhHLPzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:55:12 -0400
Received: from localhost.localdomain (1.general.khfeng.us.vpn [10.172.68.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9B2223F361;
        Thu, 12 Aug 2021 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628783686;
        bh=g7fffiyI+X9n230LWqj+hlksotyPWg3/QPgjjGTFyIQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=QjMFiNlWSA8ciPbMCVp9ulCkLwFDDYkt0BtlolB13eOGjiF7ezJjmrQId7xig+Y1l
         tOicONzOc2mc7iS7BQg2F0DHu0EdYahxWK05CfIIbpGBMTiBOkKIw/GQUMqvgDJDRm
         M/WHYZSoIbQlZ8Z6HX0JXhOdtIH8YAp4nt4vSjbfuRylVFHkp4kSGU4alp3UpL/fvp
         C6iNeHX88tbfPcDbOUNTTWfy5RaYHLNxQA5lFGkm0cT9dOj1GmC8Xx5Sc+8cN82fUk
         TMj8XJmp07rfsQvmd1iuFA/mFt5oCUVlMLDJ3+ly1xogdHHH9iNZidGlVdHyc4fV6K
         we15bpwmOKF6g==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
Date:   Thu, 12 Aug 2021 23:53:40 +0800
Message-Id: <20210812155341.817031-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
Same issue can be observed with older vendor drivers.

The issue is however solved by the latest vendor driver. There's a new
mechanism, which disables r8169's internal ASPM when the NIC traffic has
more than 10 packets, and vice versa.

Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
use dynamic ASPM under Windows. So implement the same mechanism here to
resolve the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2: 
 - Use delayed_work instead of timer_list to avoid interrupt context
 - Use mutex to serialize packet counter read/write
 - Wording change

 drivers/net/ethernet/realtek/r8169_main.c | 45 +++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c7af5bc3b8af..7ab2e841dc69 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -624,6 +624,11 @@ struct rtl8169_private {
 
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
+	unsigned aspm_enabled:1;
+	struct delayed_work aspm_toggle;
+	struct mutex aspm_mutex;
+	u32 aspm_packet_count;
+
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -2671,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
 	}
 
+	tp->aspm_enabled = enable;
+
 	udelay(10);
 }
 
@@ -4408,6 +4415,9 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 
+	mutex_lock(&tp->aspm_mutex);
+	tp->aspm_packet_count += tp->cur_tx - dirty_tx;
+	mutex_unlock(&tp->aspm_mutex);
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		u32 status;
@@ -4552,6 +4562,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 		rtl8169_mark_to_asic(desc);
 	}
 
+	mutex_lock(&tp->aspm_mutex);
+	tp->aspm_packet_count += count;
+	mutex_unlock(&tp->aspm_mutex);
+
 	return count;
 }
 
@@ -4659,8 +4673,33 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
+#define ASPM_PACKET_THRESHOLD 10
+#define ASPM_TOGGLE_INTERVAL 1000
+
+static void rtl8169_aspm_toggle(struct work_struct *work)
+{
+	struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
+						  aspm_toggle.work);
+	bool enable;
+
+	mutex_lock(&tp->aspm_mutex);
+	enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
+	tp->aspm_packet_count = 0;
+	mutex_unlock(&tp->aspm_mutex);
+
+	if (tp->aspm_enabled != enable) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, enable);
+		rtl_lock_config_regs(tp);
+	}
+
+	schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
+}
+
 static void rtl8169_down(struct rtl8169_private *tp)
 {
+	cancel_delayed_work_sync(&tp->aspm_toggle);
+
 	/* Clear all task flags */
 	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
@@ -4687,6 +4726,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
+
+	schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -5347,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
+	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
+
+	mutex_init(&tp->aspm_mutex);
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
-- 
2.32.0

