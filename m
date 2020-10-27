Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478AA29A0E5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409287AbgJZXvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409267AbgJZXvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F76320882;
        Mon, 26 Oct 2020 23:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756259;
        bh=QNw/VZ9SsWKsdyIr54dYZ9gwVS7GhSz5128+PI41nQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOo41OC39NkUgIkpcOUnaSTLvvcpS6MGirVtXbRT8eMyaUi7nPzmDZlCJfawOytQN
         KX8mG5DaCW4lgBrTtpJEJUxwKxu+piZTVAFgNkHGcuIRDOD4vLTEyC/QuOxIc+AY15
         LR85kEqjQLH6xH6pv92hFQQ5q6GYXa+OrbiSEZo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 093/147] ath11k: change to disable softirqs for ath11k_regd_update to solve deadlock
Date:   Mon, 26 Oct 2020 19:48:11 -0400
Message-Id: <20201026234905.1022767-93-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit df648808c6b9989555e247530d8ca0ad0094b361 ]

After base_lock which occupy by ath11k_regd_update, the softirq run for
WMI_REG_CHAN_LIST_CC_EVENTID maybe arrived and it also need to accuire
the spin lock, then deadlock happend, change to disable softirqis to solve it.

[  235.576990] ================================
[  235.576991] WARNING: inconsistent lock state
[  235.576993] 5.9.0-rc5-wt-ath+ #196 Not tainted
[  235.576994] --------------------------------
[  235.576995] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  235.576997] kworker/u16:1/98 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  235.576998] ffff9655f75cad98 (&ab->base_lock){+.?.}-{2:2}, at: ath11k_regd_update+0x28/0x1d0 [ath11k]
[  235.577009] {IN-SOFTIRQ-W} state was registered at:
[  235.577013]   __lock_acquire+0x219/0x6e0
[  235.577015]   lock_acquire+0xb6/0x270
[  235.577018]   _raw_spin_lock+0x2c/0x70
[  235.577023]   ath11k_reg_chan_list_event.isra.0+0x10d/0x1e0 [ath11k]
[  235.577028]   ath11k_wmi_tlv_op_rx+0x3c3/0x560 [ath11k]
[  235.577033]   ath11k_htc_rx_completion_handler+0x207/0x370 [ath11k]
[  235.577039]   ath11k_ce_recv_process_cb+0x15e/0x1e0 [ath11k]
[  235.577041]   ath11k_pci_ce_tasklet+0x10/0x30 [ath11k_pci]
[  235.577043]   tasklet_action_common.constprop.0+0xd4/0xf0
[  235.577045]   __do_softirq+0xc9/0x482
[  235.577046]   asm_call_on_stack+0x12/0x20
[  235.577048]   do_softirq_own_stack+0x49/0x60
[  235.577049]   irq_exit_rcu+0x9a/0xd0
[  235.577050]   common_interrupt+0xa1/0x190
[  235.577052]   asm_common_interrupt+0x1e/0x40
[  235.577053]   cpu_idle_poll.isra.0+0x2e/0x60
[  235.577055]   do_idle+0x5f/0xe0
[  235.577056]   cpu_startup_entry+0x14/0x20
[  235.577058]   start_kernel+0x443/0x464
[  235.577060]   secondary_startup_64+0xa4/0xb0
[  235.577061] irq event stamp: 432035
[  235.577063] hardirqs last  enabled at (432035): [<ffffffff968d12b4>] _raw_spin_unlock_irqrestore+0x34/0x40
[  235.577064] hardirqs last disabled at (432034): [<ffffffff968d10d3>] _raw_spin_lock_irqsave+0x63/0x80
[  235.577066] softirqs last  enabled at (431998): [<ffffffff967115c1>] inet6_fill_ifla6_attrs+0x3f1/0x430
[  235.577067] softirqs last disabled at (431996): [<ffffffff9671159f>] inet6_fill_ifla6_attrs+0x3cf/0x430
[  235.577068]
[  235.577068] other info that might help us debug this:
[  235.577069]  Possible unsafe locking scenario:
[  235.577069]
[  235.577070]        CPU0
[  235.577070]        ----
[  235.577071]   lock(&ab->base_lock);
[  235.577072]   <Interrupt>
[  235.577073]     lock(&ab->base_lock);
[  235.577074]
[  235.577074]  *** DEADLOCK ***
[  235.577074]
[  235.577075] 3 locks held by kworker/u16:1/98:
[  235.577076]  #0: ffff9655f75b1d48 ((wq_completion)ath11k_qmi_driver_event){+.+.}-{0:0}, at: process_one_work+0x1d3/0x5d0
[  235.577079]  #1: ffffa33cc02f3e70 ((work_completion)(&ab->qmi.event_work)){+.+.}-{0:0}, at: process_one_work+0x1d3/0x5d0
[  235.577081]  #2: ffff9655f75cad50 (&ab->core_lock){+.+.}-{3:3}, at: ath11k_core_qmi_firmware_ready.part.0+0x4e/0x160 [ath11k]
[  235.577087]
[  235.577087] stack backtrace:
[  235.577088] CPU: 3 PID: 98 Comm: kworker/u16:1 Not tainted 5.9.0-rc5-wt-ath+ #196
[  235.577089] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0049.2018.0801.1601 08/01/2018
[  235.577095] Workqueue: ath11k_qmi_driver_event ath11k_qmi_driver_event_work [ath11k]
[  235.577096] Call Trace:
[  235.577100]  dump_stack+0x77/0xa0
[  235.577102]  mark_lock_irq.cold+0x15/0x3c
[  235.577104]  mark_lock+0x1d7/0x540
[  235.577105]  mark_usage+0xc7/0x140
[  235.577107]  __lock_acquire+0x219/0x6e0
[  235.577108]  ? sched_clock_cpu+0xc/0xb0
[  235.577110]  lock_acquire+0xb6/0x270
[  235.577116]  ? ath11k_regd_update+0x28/0x1d0 [ath11k]
[  235.577118]  ? atomic_notifier_chain_register+0x2d/0x40
[  235.577120]  _raw_spin_lock+0x2c/0x70
[  235.577125]  ? ath11k_regd_update+0x28/0x1d0 [ath11k]
[  235.577130]  ath11k_regd_update+0x28/0x1d0 [ath11k]
[  235.577136]  __ath11k_mac_register+0x3fb/0x480 [ath11k]
[  235.577141]  ath11k_mac_register+0x119/0x180 [ath11k]
[  235.577146]  ath11k_core_pdev_create+0x17/0xe0 [ath11k]
[  235.577150]  ath11k_core_qmi_firmware_ready.part.0+0x65/0x160 [ath11k]
[  235.577155]  ath11k_qmi_driver_event_work+0x1c5/0x230 [ath11k]
[  235.577158]  process_one_work+0x265/0x5d0
[  235.577160]  worker_thread+0x49/0x300
[  235.577161]  ? process_one_work+0x5d0/0x5d0
[  235.577163]  kthread+0x135/0x150
[  235.577164]  ? kthread_create_worker_on_cpu+0x60/0x60
[  235.577166]  ret_from_fork+0x22/0x30

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1601399736-3210-7-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 7c9dc91cc48a9..c79a7c7eb56ee 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -206,7 +206,7 @@ int ath11k_regd_update(struct ath11k *ar, bool init)
 	ab = ar->ab;
 	pdev_id = ar->pdev_idx;
 
-	spin_lock(&ab->base_lock);
+	spin_lock_bh(&ab->base_lock);
 
 	if (init) {
 		/* Apply the regd received during init through
@@ -227,7 +227,7 @@ int ath11k_regd_update(struct ath11k *ar, bool init)
 
 	if (!regd) {
 		ret = -EINVAL;
-		spin_unlock(&ab->base_lock);
+		spin_unlock_bh(&ab->base_lock);
 		goto err;
 	}
 
@@ -238,7 +238,7 @@ int ath11k_regd_update(struct ath11k *ar, bool init)
 	if (regd_copy)
 		ath11k_copy_regd(regd, regd_copy);
 
-	spin_unlock(&ab->base_lock);
+	spin_unlock_bh(&ab->base_lock);
 
 	if (!regd_copy) {
 		ret = -ENOMEM;
-- 
2.25.1

