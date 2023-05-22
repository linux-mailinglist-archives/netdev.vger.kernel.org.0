Return-Path: <netdev+bounces-4310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E67170BFEA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B24F280F62
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464B313AF3;
	Mon, 22 May 2023 13:41:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D9AAD4C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:41:26 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680D9C2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:41:24 -0700 (PDT)
Date: Mon, 22 May 2023 15:41:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684762883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5hEM2knjxoast+Im6aNxvRSwg38VOD2U1VS1eoqeiQY=;
	b=vjqEqEcDblSOW1QFg5G3NPWh9GzaSe7FDc1y+2qx9qAp0KSvpBz4VxvfSHr1C0cQE0lX5u
	nYjccK6j5GA8RttbezUfnh5jk7j6PaL8rwUOPVF3jYkurtE4x8ipuiuVMYFZOCgJSkJBDK
	YKMa7nR0TjzR67449X8uwApuQrOMgEbo4a4ExUnoBWEusRMbB8D352pBsAikuc+V3B3+Ho
	TXFL93AOILtndW0zGAZ0mh22PRk39FzgonDgQX39FLBa+/guyk6rHjHnmfc02rzJ/vZ+b1
	eD2UeK5pfg9cdhBtLywB3Lhzl1zPBgiW+wdVibmfqE5buMPDi1FipLPnR8SnWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684762883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5hEM2knjxoast+Im6aNxvRSwg38VOD2U1VS1eoqeiQY=;
	b=M67ztaxljyUNjV6lPfBTG3SXGiZdI/0UEZ05sHhVPmQYEwHTZIo/7ZGydkHiEzjkAzO5e7
	33YrAjiRdZWlF4Cg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Mike Galbraith <efault@gmx.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, nic_swsd@realtek.com
Subject: [PATCH net-next] r8169: Use a raw_spinlock_t for the register locks.
Message-ID: <20230522134121.uxjax0F5@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The driver's interrupt service routine is requested with the
IRQF_NO_THREAD if MSI is available. This means that the routine is
invoked in hardirq context even on PREEMPT_RT. The routine itself is
relatively short and schedules a worker, performs register access and
schedules NAPI. On PREEMPT_RT, scheduling NAPI from hardirq results in
waking ksoftirqd for further processing so using NAPI threads with this
driver is highly recommended since it NULL routes the threaded-IRQ
efforts.

Adding rtl_hw_aspm_clkreq_enable() to the ISR is problematic on
PREEMPT_RT because the function uses spinlock_t locks which become
sleeping locks on PREEMPT_RT. The locks are only used to protect
register access and don't nest into other functions or locks. They are
also not used for unbounded period of time. Therefore it looks okay to
convert them to raw_spinlock_t.

Convert the three locks which are used from the interrupt service
routine to raw_spinlock_t.

Fixes: e1ed3e4d91112 ("r8169: disable ASPM during NAPI poll")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

This is the only ethernet driver doing IRQF_NO_THREAD. It was recently
enabled and based on thread it was argued to offer better performance
with threaded interrupts and NAPI threads. So I'm trying this instead of
reverting the whole thing since it does not seem necessary. Maybe the
NAPI-threads could some special treats, I take a look.

 drivers/net/ethernet/realtek/r8169_main.c | 44 +++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a7e376e7e689c..4b19803a7dd01 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -616,10 +616,10 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
-	spinlock_t config25_lock;
-	spinlock_t mac_ocp_lock;
+	raw_spinlock_t config25_lock;
+	raw_spinlock_t mac_ocp_lock;
 
-	spinlock_t cfg9346_usage_lock;
+	raw_spinlock_t cfg9346_usage_lock;
 	int cfg9346_usage_count;
 
 	unsigned supports_gmii:1;
@@ -671,20 +671,20 @@ static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
+	raw_spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
 	if (!--tp->cfg9346_usage_count)
 		RTL_W8(tp, Cfg9346, Cfg9346_Lock);
-	spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
+	raw_spin_lock_irqsave(&tp->cfg9346_usage_lock, flags);
 	if (!tp->cfg9346_usage_count++)
 		RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
-	spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->cfg9346_usage_lock, flags);
 }
 
 static void rtl_pci_commit(struct rtl8169_private *tp)
@@ -698,10 +698,10 @@ static void rtl_mod_config2(struct rtl8169_private *tp, u8 clear, u8 set)
 	unsigned long flags;
 	u8 val;
 
-	spin_lock_irqsave(&tp->config25_lock, flags);
+	raw_spin_lock_irqsave(&tp->config25_lock, flags);
 	val = RTL_R8(tp, Config2);
 	RTL_W8(tp, Config2, (val & ~clear) | set);
-	spin_unlock_irqrestore(&tp->config25_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->config25_lock, flags);
 }
 
 static void rtl_mod_config5(struct rtl8169_private *tp, u8 clear, u8 set)
@@ -709,10 +709,10 @@ static void rtl_mod_config5(struct rtl8169_private *tp, u8 clear, u8 set)
 	unsigned long flags;
 	u8 val;
 
-	spin_lock_irqsave(&tp->config25_lock, flags);
+	raw_spin_lock_irqsave(&tp->config25_lock, flags);
 	val = RTL_R8(tp, Config5);
 	RTL_W8(tp, Config5, (val & ~clear) | set);
-	spin_unlock_irqrestore(&tp->config25_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->config25_lock, flags);
 }
 
 static bool rtl_is_8125(struct rtl8169_private *tp)
@@ -899,9 +899,9 @@ static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	raw_spin_lock_irqsave(&tp->mac_ocp_lock, flags);
 	__r8168_mac_ocp_write(tp, reg, data);
-	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
 }
 
 static u16 __r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
@@ -919,9 +919,9 @@ static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 	unsigned long flags;
 	u16 val;
 
-	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	raw_spin_lock_irqsave(&tp->mac_ocp_lock, flags);
 	val = __r8168_mac_ocp_read(tp, reg);
-	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
 
 	return val;
 }
@@ -932,10 +932,10 @@ static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
 	unsigned long flags;
 	u16 data;
 
-	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	raw_spin_lock_irqsave(&tp->mac_ocp_lock, flags);
 	data = __r8168_mac_ocp_read(tp, reg);
 	__r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
-	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
 }
 
 /* Work around a hw issue with RTL8168g PHY, the quirk disables
@@ -1420,14 +1420,14 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 			r8168_mac_ocp_modify(tp, 0xc0b6, BIT(0), 0);
 	}
 
-	spin_lock_irqsave(&tp->config25_lock, flags);
+	raw_spin_lock_irqsave(&tp->config25_lock, flags);
 	for (i = 0; i < tmp; i++) {
 		options = RTL_R8(tp, cfg[i].reg) & ~cfg[i].mask;
 		if (wolopts & cfg[i].opt)
 			options |= cfg[i].mask;
 		RTL_W8(tp, cfg[i].reg, options);
 	}
-	spin_unlock_irqrestore(&tp->config25_lock, flags);
+	raw_spin_unlock_irqrestore(&tp->config25_lock, flags);
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
@@ -5179,9 +5179,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
-	spin_lock_init(&tp->cfg9346_usage_lock);
-	spin_lock_init(&tp->config25_lock);
-	spin_lock_init(&tp->mac_ocp_lock);
+	raw_spin_lock_init(&tp->cfg9346_usage_lock);
+	raw_spin_lock_init(&tp->config25_lock);
+	raw_spin_lock_init(&tp->mac_ocp_lock);
 
 	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
 						   struct pcpu_sw_netstats);
-- 
2.40.1

