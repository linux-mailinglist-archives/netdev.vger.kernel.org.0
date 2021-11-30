Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D69463C67
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbhK3RFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbhK3RFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C92C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:01:59 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 200so20491303pga.1
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMWXvmoMGDWJ8smsNDQTVOeydgFdAHXtj4W20Rh9V5E=;
        b=j8OBIbBXg+hfpCno5XAd3yTHBbmSKLXjKmEexaWcvO3Ez3Yddw4JEauEEocIx8fmYv
         QXWPul6yCoLMktI6s0Qy2NnZPL8CaZPZgDnvzpxg6E1SgCRcu2Mvi4jav8529CLTpfuR
         ME8wPlsktuK/KJrETsGRanuD7jCPPzMHeWGodxSfJZLYpbk2AzQBxJNgLH/tIaGPiPV1
         BjPukSHXn/HZov+RHdrkue+aQRX2uJKtUHRXKlSLGCv50LdSneCjRUH2boCYnYerJw99
         NZ8c2anuQ/5IVmgeaZvpSYPrefjUuEw4IDjjpemeMyJnBAd7AozBzfsEkqDICIw3UotO
         eSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMWXvmoMGDWJ8smsNDQTVOeydgFdAHXtj4W20Rh9V5E=;
        b=XwA++L7CMHM5BOOGh4YFkSNzA/rbq/KxVg3GSHgPbKu/V8TYvBGXe4pXwQBJHvmG3n
         Ow0enbH/tChCfsW+mn4YPjOEcTBA2F4LVMLMIH9XaKB42eFm9MDisbkLznDcV6fmYMO3
         8CCRZUkEU+kMnDORhmRLDfiiJW7vfpEce3Z9USswhroAPvSG+sIReZt6XzjEXJ+HB/ez
         SO5/6vHCcQGgN0cOn/ov1A4wspWMhvMB3j8c4BcOWz24cG+Sw2B5u5mKEZQLdGIN3usk
         TJA0z0HXVGNdlVtS8ySV+9WQnKM47LI0fWAh+7b+qqVJ9xUwHnEcjOuToUskq9yKNLQK
         qJOQ==
X-Gm-Message-State: AOAM530xRS7hOP1tl50xNfpa3GAv/0nuIWMYMDHxwn2nh8JbSpcdUbNX
        DiCsI0bK4Bafy0Esz93uKZk=
X-Google-Smtp-Source: ABdhPJx4+ub+6d034I2EXZc5+G+gUycDgr9pPHAtzWMdjEWuRWU8ovA/oCY6Z/XEv7zcQp9Ak96x7w==
X-Received: by 2002:aa7:8891:0:b0:4a5:58ad:e2e6 with SMTP id z17-20020aa78891000000b004a558ade2e6mr119324pfe.42.1638291718612;
        Tue, 30 Nov 2021 09:01:58 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e80b:5c18:d3d:632a])
        by smtp.gmail.com with ESMTPSA id m3sm4252172pgj.25.2021.11.30.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:01:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: annotate data-races on txq->xmit_lock_owner
Date:   Tue, 30 Nov 2021 09:01:55 -0800
Message-Id: <20211130170155.2331929-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found that __dev_queue_xmit() is reading txq->xmit_lock_owner
without annotations.

No serious issue there, let's document what is happening there.

BUG: KCSAN: data-race in __dev_queue_xmit / __dev_queue_xmit

write to 0xffff888139d09484 of 4 bytes by interrupt on cpu 0:
 __netif_tx_unlock include/linux/netdevice.h:4437 [inline]
 __dev_queue_xmit+0x948/0xf70 net/core/dev.c:4229
 dev_queue_xmit_accel+0x19/0x20 net/core/dev.c:4265
 macvlan_queue_xmit drivers/net/macvlan.c:543 [inline]
 macvlan_start_xmit+0x2b3/0x3d0 drivers/net/macvlan.c:567
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3590
 dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
 sch_direct_xmit+0x1b2/0x7c0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0x83d/0x1370 net/core/dev.c:3817
 __dev_queue_xmit+0x590/0xf70 net/core/dev.c:4194
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4259
 neigh_hh_output include/net/neighbour.h:511 [inline]
 neigh_output include/net/neighbour.h:525 [inline]
 ip6_finish_output2+0x995/0xbb0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 ip6_finish_output+0x444/0x4c0 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x486/0x610 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x3b0/0x3e0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x370/0x540 net/ipv6/addrconf.c:3898
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x3e/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20

read to 0xffff888139d09484 of 4 bytes by interrupt on cpu 1:
 __dev_queue_xmit+0x5e3/0xf70 net/core/dev.c:4213
 dev_queue_xmit_accel+0x19/0x20 net/core/dev.c:4265
 macvlan_queue_xmit drivers/net/macvlan.c:543 [inline]
 macvlan_start_xmit+0x2b3/0x3d0 drivers/net/macvlan.c:567
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one+0x105/0x2f0 net/core/dev.c:3590
 dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
 sch_direct_xmit+0x1b2/0x7c0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0x83d/0x1370 net/core/dev.c:3817
 __dev_queue_xmit+0x590/0xf70 net/core/dev.c:4194
 dev_queue_xmit+0x13/0x20 net/core/dev.c:4259
 neigh_resolve_output+0x3db/0x410 net/core/neighbour.c:1523
 neigh_output include/net/neighbour.h:527 [inline]
 ip6_finish_output2+0x9be/0xbb0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 ip6_finish_output+0x444/0x4c0 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0x486/0x610 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x3b0/0x3e0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x370/0x540 net/ipv6/addrconf.c:3898
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 kcsan_setup_watchpoint+0x94/0x420 kernel/kcsan/core.c:443
 folio_test_anon include/linux/page-flags.h:581 [inline]
 PageAnon include/linux/page-flags.h:586 [inline]
 zap_pte_range+0x5ac/0x10e0 mm/memory.c:1347
 zap_pmd_range mm/memory.c:1467 [inline]
 zap_pud_range mm/memory.c:1496 [inline]
 zap_p4d_range mm/memory.c:1517 [inline]
 unmap_page_range+0x2dc/0x3d0 mm/memory.c:1538
 unmap_single_vma+0x157/0x210 mm/memory.c:1583
 unmap_vmas+0xd0/0x180 mm/memory.c:1615
 exit_mmap+0x23d/0x470 mm/mmap.c:3170
 __mmput+0x27/0x1b0 kernel/fork.c:1113
 mmput+0x3d/0x50 kernel/fork.c:1134
 exit_mm+0xdb/0x170 kernel/exit.c:507
 do_exit+0x608/0x17a0 kernel/exit.c:819
 do_group_exit+0xce/0x180 kernel/exit.c:929
 get_signal+0xfc3/0x1550 kernel/signal.c:2852
 arch_do_signal_or_restart+0x8c/0x2e0 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x113/0x190 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:300
 do_syscall_64+0x50/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0xffffffff

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 28712 Comm: syz-executor.0 Tainted: G        W         5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/linux/netdevice.h | 19 +++++++++++++------
 net/core/dev.c            |  5 ++++-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a56dbd51fecd166d572a9e586e3e4..be5cb3360b944ca1519f2da335b3b6053c18e443 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4404,7 +4404,8 @@ static inline u32 netif_msg_init(int debug_value, int default_msg_enable_bits)
 static inline void __netif_tx_lock(struct netdev_queue *txq, int cpu)
 {
 	spin_lock(&txq->_xmit_lock);
-	txq->xmit_lock_owner = cpu;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, cpu);
 }
 
 static inline bool __netif_tx_acquire(struct netdev_queue *txq)
@@ -4421,26 +4422,32 @@ static inline void __netif_tx_release(struct netdev_queue *txq)
 static inline void __netif_tx_lock_bh(struct netdev_queue *txq)
 {
 	spin_lock_bh(&txq->_xmit_lock);
-	txq->xmit_lock_owner = smp_processor_id();
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
 }
 
 static inline bool __netif_tx_trylock(struct netdev_queue *txq)
 {
 	bool ok = spin_trylock(&txq->_xmit_lock);
-	if (likely(ok))
-		txq->xmit_lock_owner = smp_processor_id();
+
+	if (likely(ok)) {
+		/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+		WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
+	}
 	return ok;
 }
 
 static inline void __netif_tx_unlock(struct netdev_queue *txq)
 {
-	txq->xmit_lock_owner = -1;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock(&txq->_xmit_lock);
 }
 
 static inline void __netif_tx_unlock_bh(struct netdev_queue *txq)
 {
-	txq->xmit_lock_owner = -1;
+	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock_bh(&txq->_xmit_lock);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 15ac064b5562d7b99f885610a3d12733b63aa325..2a352e668d103948121970350d344f18b98f4aba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4210,7 +4210,10 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	if (dev->flags & IFF_UP) {
 		int cpu = smp_processor_id(); /* ok because BHs are off */
 
-		if (txq->xmit_lock_owner != cpu) {
+		/* Other cpus might concurrently change txq->xmit_lock_owner
+		 * to -1 or to their cpu id, but not to our id.
+		 */
+		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
 			if (dev_xmit_recursion())
 				goto recursion_alert;
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

