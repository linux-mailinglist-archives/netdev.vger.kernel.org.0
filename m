Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5153DF16D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhHCP37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:29:59 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:58284
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236864AbhHCP3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:29:04 -0400
Received: from localhost (36-229-239-123.dynamic-ip.hinet.net [36.229.239.123])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7FD523F07E;
        Tue,  3 Aug 2021 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628004515;
        bh=vG/mdcvhjFHm43VGopi8z7l3Sq5+1VzRuGB94PyIYAo=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=slRUaB08+pOfAwPunNoAbN/i5SaQ/TNvmX1gArogt8u6i3eeKu/7/Bva8zjuoaOZ0
         WHpYiqIzHo2+k4sLQzs8yjv2Zqtv/47lX89ulwuL/kFuEKbjCKm0upSIegDwDRfVol
         tzpdKI0g8RxXEFsFoDr+HjeyLBeC1fSNsSdwvUzJ7du2FKkYMEexBfTfca+lNVkm8K
         yKjxKYBLvEFxFWy9fEOPVZ4LAF1k5TnsbyKdqqz6EnLbg/LvGM8gdod2+hA7+q2ONl
         9gNXSb5nZMXYS6g0tsP+FOCzPTl/23GYEpxMOnx6FQgEa4s2E+DvIUykSikNTkHcae
         GukUuu9AO0TjA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] r8169: Implement dynamic ASPM mechanism
Date:   Tue,  3 Aug 2021 23:28:22 +0800
Message-Id: <20210803152823.515849-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
Same issue can be observed with older vendor drivers.

The issue is however solved by the latest vendor driver. There's a new
mechanism, which disables r8169's internal ASPM when the NIC has
substantial network traffic, and vice versa.

So implement the same mechanism here to resolve the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 36 +++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c7af5bc3b8af..e257d3cd885e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -624,6 +624,10 @@ struct rtl8169_private {
 
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
+	unsigned aspm_enabled:1;
+	struct timer_list aspm_timer;
+	u32 aspm_packet_count;
+
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
@@ -2671,6 +2675,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
 	}
 
+	tp->aspm_enabled = enable;
+
 	udelay(10);
 }
 
@@ -4408,6 +4414,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	dirty_tx = tp->dirty_tx;
 
+	tp->aspm_packet_count += tp->cur_tx - dirty_tx;
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		u32 status;
@@ -4552,6 +4559,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
 		rtl8169_mark_to_asic(desc);
 	}
 
+	tp->aspm_packet_count += count;
+
 	return count;
 }
 
@@ -4659,8 +4668,31 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
+#define ASPM_PACKET_THRESHOLD 10
+#define ASPM_TIMER_INTERVAL 1000
+
+static void rtl8169_aspm_timer(struct timer_list *timer)
+{
+	struct rtl8169_private *tp = from_timer(tp, timer, aspm_timer);
+	bool enable;
+
+	enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
+
+	if (tp->aspm_enabled != enable) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, enable);
+		rtl_lock_config_regs(tp);
+	}
+
+	tp->aspm_packet_count = 0;
+
+	mod_timer(timer, jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
+}
+
 static void rtl8169_down(struct rtl8169_private *tp)
 {
+	del_timer_sync(&tp->aspm_timer);
+
 	/* Clear all task flags */
 	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
@@ -4687,6 +4719,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
+
+	timer_setup(&tp->aspm_timer, rtl8169_aspm_timer, 0);
+	mod_timer(&tp->aspm_timer,
+		  jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
 }
 
 static int rtl8169_close(struct net_device *dev)
-- 
2.31.1

