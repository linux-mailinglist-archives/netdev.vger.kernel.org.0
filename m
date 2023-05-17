Return-Path: <netdev+bounces-3466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA78707452
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 003E2281518
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7A2107B3;
	Wed, 17 May 2023 21:32:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A65333F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:32:18 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D7830ED;
	Wed, 17 May 2023 14:32:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 5979960177;
	Wed, 17 May 2023 23:32:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684359122; bh=2UIzJQv6U3IVyIe7FfBsKDq4TgdpbPwnJiasL/OapkM=;
	h=From:To:Cc:Subject:Date:From;
	b=VR+UdAKQ8iwx50Ni2q8aUPolHlSeRmeMqUd4CD0rT1SSOADiKY5UIU2WnS7c/D/qQ
	 zZeI0sQ8+zGrUMnKbmNa0H13BlPvD9UhvRZhfIqrTmwFMcn56lFzEWE45r7/wQiRAw
	 tqPVagB8D0e1vUMcJAYPR+4PiG0KY0fHqucc9bHM1sMbUCypl1FRwbf24VD8olffSM
	 AV3Hq/jSeylEWSyM+MZFUDhOqIaupoqKMqbc49Go2Y9Tpbjz4uPNFZHFxzjxZkP39l
	 AzPywTdByxqP4bRHHeTKgcxkUfd2vy7o6goap6HY6kLutC1+SutkWdApcW9pugnHpE
	 c0Ek5Nj+koO9A==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FvDIITb732VJ; Wed, 17 May 2023 23:31:59 +0200 (CEST)
Received: from defiant.. (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 8572260174;
	Wed, 17 May 2023 23:31:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684359119; bh=2UIzJQv6U3IVyIe7FfBsKDq4TgdpbPwnJiasL/OapkM=;
	h=From:To:Cc:Subject:Date:From;
	b=YRmGWXCFviVT+l3gho3OKeydVoubb8oEaRCjlSUCoz75YqXmzpn19lCO64OM3kbyg
	 j2QIq4k9YcP0BE+bk7howrD0P0oXyuASl3qoAkkndd3qm53ZRW2Hjj8rRaqmpoF5Cy
	 9QHK3B2gezVxbtoKoZ4Bc6wmoW6FCgRB89UJ21QdWha5G5IBNFnfaYhHG7HU2O7DCN
	 977qtYZE5DgvdRtWSA1xnM1g8WECug/kEFKDF3xgddaCHdKgUEYJizgTfABM2MYAPa
	 UEWpsq+dCVMr/ra6nyY1kEd82GwCOYOs+xkFEZocZS1FQP6ldYVcRnDZvWWWPkpInH
	 hkS2c5AK87uJg==
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v5 1/1] wifi: mac80211: fortify the spinlock against deadlock by interrupt
Date: Wed, 17 May 2023 23:31:02 +0200
Message-Id: <20230517213101.25617-1-mirsad.todorovac@alu.unizg.hr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the function ieee80211_tx_dequeue() there is a particular locking
sequence:

begin:
	spin_lock(&local->queue_stop_reason_lock);
	q_stopped = local->queue_stop_reasons[q];
	spin_unlock(&local->queue_stop_reason_lock);

However small the chance (increased by ftracetest), an asynchronous
interrupt can occur in between of spin_lock() and spin_unlock(),
and the interrupt routine will attempt to lock the same
&local->queue_stop_reason_lock again.

This will cause a costly reset of the CPU and the wifi device or an
altogether hang in the single CPU and single core scenario.

The only remaining spin_lock(&local->queue_stop_reason_lock) that
did not disable interrupts was patched, which should prevent any
deadlocks on the same CPU/core and the same wifi device.

This is the probable trace of the deadlock:

kernel: ================================
kernel: WARNING: inconsistent lock state
kernel: 6.3.0-rc6-mt-20230401-00001-gf86822a1170f #4 Tainted: G        W
kernel: --------------------------------
kernel: inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
kernel: kworker/5:0/25656 [HC0[0]:SC0[0]:HE1:SE1] takes:
kernel: ffff9d6190779478 (&local->queue_stop_reason_lock){+.?.}-{2:2}, at: return_to_handler+0x0/0x40
kernel: {IN-SOFTIRQ-W} state was registered at:
kernel:   lock_acquire+0xc7/0x2d0
kernel:   _raw_spin_lock+0x36/0x50
kernel:   ieee80211_tx_dequeue+0xb4/0x1330 [mac80211]
kernel:   iwl_mvm_mac_itxq_xmit+0xae/0x210 [iwlmvm]
kernel:   iwl_mvm_mac_wake_tx_queue+0x2d/0xd0 [iwlmvm]
kernel:   ieee80211_queue_skb+0x450/0x730 [mac80211]
kernel:   __ieee80211_xmit_fast.constprop.66+0x834/0xa50 [mac80211]
kernel:   __ieee80211_subif_start_xmit+0x217/0x530 [mac80211]
kernel:   ieee80211_subif_start_xmit+0x60/0x580 [mac80211]
kernel:   dev_hard_start_xmit+0xb5/0x260
kernel:   __dev_queue_xmit+0xdbe/0x1200
kernel:   neigh_resolve_output+0x166/0x260
kernel:   ip_finish_output2+0x216/0xb80
kernel:   __ip_finish_output+0x2a4/0x4d0
kernel:   ip_finish_output+0x2d/0xd0
kernel:   ip_output+0x82/0x2b0
kernel:   ip_local_out+0xec/0x110
kernel:   igmpv3_sendpack+0x5c/0x90
kernel:   igmp_ifc_timer_expire+0x26e/0x4e0
kernel:   call_timer_fn+0xa5/0x230
kernel:   run_timer_softirq+0x27f/0x550
kernel:   __do_softirq+0xb4/0x3a4
kernel:   irq_exit_rcu+0x9b/0xc0
kernel:   sysvec_apic_timer_interrupt+0x80/0xa0
kernel:   asm_sysvec_apic_timer_interrupt+0x1f/0x30
kernel:   _raw_spin_unlock_irqrestore+0x3f/0x70
kernel:   free_to_partial_list+0x3d6/0x590
kernel:   __slab_free+0x1b7/0x310
kernel:   kmem_cache_free+0x52d/0x550
kernel:   putname+0x5d/0x70
kernel:   do_sys_openat2+0x1d7/0x310
kernel:   do_sys_open+0x51/0x80
kernel:   __x64_sys_openat+0x24/0x30
kernel:   do_syscall_64+0x5c/0x90
kernel:   entry_SYSCALL_64_after_hwframe+0x72/0xdc
kernel: irq event stamp: 5120729
kernel: hardirqs last  enabled at (5120729): [<ffffffff9d149936>] trace_graph_return+0xd6/0x120
kernel: hardirqs last disabled at (5120728): [<ffffffff9d149950>] trace_graph_return+0xf0/0x120
kernel: softirqs last  enabled at (5069900): [<ffffffff9cf65b60>] return_to_handler+0x0/0x40
kernel: softirqs last disabled at (5067555): [<ffffffff9cf65b60>] return_to_handler+0x0/0x40
kernel:
        other info that might help us debug this:
kernel:  Possible unsafe locking scenario:
kernel:        CPU0
kernel:        ----
kernel:   lock(&local->queue_stop_reason_lock);
kernel:   <Interrupt>
kernel:     lock(&local->queue_stop_reason_lock);
kernel:
         *** DEADLOCK ***
kernel: 8 locks held by kworker/5:0/25656:
kernel:  #0: ffff9d618009d138 ((wq_completion)events_freezable){+.+.}-{0:0}, at: process_one_work+0x1ca/0x530
kernel:  #1: ffffb1ef4637fe68 ((work_completion)(&local->restart_work)){+.+.}-{0:0}, at: process_one_work+0x1ce/0x530
kernel:  #2: ffffffff9f166548 (rtnl_mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
kernel:  #3: ffff9d6190778728 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
kernel:  #4: ffff9d619077b480 (&mvm->mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
kernel:  #5: ffff9d61907bacd8 (&trans_pcie->mutex){+.+.}-{3:3}, at: return_to_handler+0x0/0x40
kernel:  #6: ffffffff9ef9cda0 (rcu_read_lock){....}-{1:2}, at: iwl_mvm_queue_state_change+0x59/0x3a0 [iwlmvm]
kernel:  #7: ffffffff9ef9cda0 (rcu_read_lock){....}-{1:2}, at: iwl_mvm_mac_itxq_xmit+0x42/0x210 [iwlmvm]
kernel:
        stack backtrace:
kernel: CPU: 5 PID: 25656 Comm: kworker/5:0 Tainted: G        W          6.3.0-rc6-mt-20230401-00001-gf86822a1170f #4
kernel: Hardware name: LENOVO 82H8/LNVNB161216, BIOS GGCN51WW 11/16/2022
kernel: Workqueue: events_freezable ieee80211_restart_work [mac80211]
kernel: Call Trace:
kernel:  <TASK>
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  dump_stack_lvl+0x5f/0xa0
kernel:  dump_stack+0x14/0x20
kernel:  print_usage_bug.part.46+0x208/0x2a0
kernel:  mark_lock.part.47+0x605/0x630
kernel:  ? sched_clock+0xd/0x20
kernel:  ? trace_clock_local+0x14/0x30
kernel:  ? __rb_reserve_next+0x5f/0x490
kernel:  ? _raw_spin_lock+0x1b/0x50
kernel:  __lock_acquire+0x464/0x1990
kernel:  ? mark_held_locks+0x4e/0x80
kernel:  lock_acquire+0xc7/0x2d0
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  ? ftrace_return_to_handler+0x8b/0x100
kernel:  ? preempt_count_add+0x4/0x70
kernel:  _raw_spin_lock+0x36/0x50
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  ieee80211_tx_dequeue+0xb4/0x1330 [mac80211]
kernel:  ? prepare_ftrace_return+0xc5/0x190
kernel:  ? ftrace_graph_func+0x16/0x20
kernel:  ? 0xffffffffc02ab0b1
kernel:  ? lock_acquire+0xc7/0x2d0
kernel:  ? iwl_mvm_mac_itxq_xmit+0x42/0x210 [iwlmvm]
kernel:  ? ieee80211_tx_dequeue+0x9/0x1330 [mac80211]
kernel:  ? __rcu_read_lock+0x4/0x40
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_mvm_mac_itxq_xmit+0xae/0x210 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_mvm_queue_state_change+0x311/0x3a0 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_mvm_wake_sw_queue+0x17/0x20 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_txq_gen2_unmap+0x1c9/0x1f0 [iwlwifi]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_txq_gen2_free+0x55/0x130 [iwlwifi]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_txq_gen2_tx_free+0x63/0x80 [iwlwifi]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  _iwl_trans_pcie_gen2_stop_device+0x3f3/0x5b0 [iwlwifi]
kernel:  ? _iwl_trans_pcie_gen2_stop_device+0x9/0x5b0 [iwlwifi]
kernel:  ? mutex_lock_nested+0x4/0x30
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_trans_pcie_gen2_stop_device+0x5f/0x90 [iwlwifi]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_mvm_stop_device+0x78/0xd0 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  __iwl_mvm_mac_start+0x114/0x210 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  iwl_mvm_mac_start+0x76/0x150 [iwlmvm]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  drv_start+0x79/0x180 [mac80211]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  ieee80211_reconfig+0x1523/0x1ce0 [mac80211]
kernel:  ? synchronize_net+0x4/0x50
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  ieee80211_restart_work+0x108/0x170 [mac80211]
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  process_one_work+0x250/0x530
kernel:  ? ftrace_regs_caller_end+0x66/0x66
kernel:  worker_thread+0x48/0x3a0
kernel:  ? __pfx_worker_thread+0x10/0x10
kernel:  kthread+0x10f/0x140
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork+0x29/0x50
kernel:  </TASK>

Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
Link: https://lore.kernel.org/all/1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr/
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Link: https://lore.kernel.org/all/cdc80531-f25f-6f9d-b15f-25e16130b53a@alu.unizg.hr/
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/mac80211/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a3327407552..0d9fbc8458fd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3791,6 +3791,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
 	int q = vif->hw_queue[txq->ac];
+	unsigned long flags;
 	bool q_stopped;
 
 	WARN_ON_ONCE(softirq_count() == 0);
@@ -3799,9 +3800,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		return NULL;
 
 begin:
-	spin_lock(&local->queue_stop_reason_lock);
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	q_stopped = local->queue_stop_reasons[q];
-	spin_unlock(&local->queue_stop_reason_lock);
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	if (unlikely(q_stopped)) {
 		/* mark for waking later */
-- 
2.34.1


