Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9415069B464
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 22:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBQVJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 16:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBQVJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 16:09:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BFB5E5AC;
        Fri, 17 Feb 2023 13:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676668176; x=1708204176;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zMN3aYNfIW+JyY1QbhClboj5SXQ7zWCzbZZ1sgXCJz0=;
  b=ArhE6/mvIwRwblnpK60s9PivBmlacijuC3SE99Wm+o4gQf+8V94fsJhw
   2HQuOKHIESZ0dO6LSVUfpz8IXCGABuQezmOd1oSwQEcxuQVxS0Hs/mAOE
   vze3Ef9gh6NW+7t9CjB4QK0YlTkJcD1izw31BeH4/OcRSZCx4eDZ/alSq
   vr8bTVK+fEoqf5QUyf4HnF5M8VNXAb7ifVNHHq6PXYkxa4mS8AOP8z9Mx
   RnoyBzPyA1YE/i3B3bkxemlVvmY/0/xf8ahfmk029t5P9jcBJquqqKUNu
   68NCfO6FHrl+dwJaI3Jz3083igl2hstAOPBOoOEn9Xsz9CpsJny4bIa7Z
   w==;
X-IronPort-AV: E=Sophos;i="5.97,306,1669100400"; 
   d="scan'208";a="197578138"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 14:09:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 14:09:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 14:09:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix possible deadlock inside PTP
Date:   Fri, 17 Feb 2023 22:09:17 +0100
Message-ID: <20230217210917.2649365-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing timestamping in lan966x and having PROVE_LOCKING
enabled the following warning is shown.

========================================================
WARNING: possible irq lock inversion dependency detected
6.2.0-rc7-01749-gc54e1f7f7e36 #2786 Tainted: G                 N
--------------------------------------------------------
swapper/0/0 just changed the state of lock:
c2609f50 (_xmit_ETHER#2){+.-.}-{2:2}, at: sch_direct_xmit+0x16c/0x2e8
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (&lan966x->ptp_ts_id_lock){+.+.}-{2:2}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&lan966x->ptp_ts_id_lock);
                               local_irq_disable();
                               lock(_xmit_ETHER#2);
                               lock(&lan966x->ptp_ts_id_lock);
  <Interrupt>
    lock(_xmit_ETHER#2);

 *** DEADLOCK ***

5 locks held by swapper/0/0:
 #0: c1001e18 ((&ndev->rs_timer)){+.-.}-{0:0}, at: call_timer_fn+0x0/0x33c
 #1: c105e7c4 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x134/0x81c
 #2: c105e7d8 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x17c/0xc64
 #3: c105e7d8 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x4c/0x1224
 #4: c3056174 (dev->qdisc_tx_busylock ?: &qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x354/0x1224

the shortest dependencies between 2nd lock and 1st lock:
 -> (&lan966x->ptp_ts_id_lock){+.+.}-{2:2} {
    HARDIRQ-ON-W at:
                      lock_acquire.part.0+0xb0/0x248
                      _raw_spin_lock+0x38/0x48
                      lan966x_ptp_irq_handler+0x164/0x2a8
                      irq_thread_fn+0x1c/0x78
                      irq_thread+0x130/0x278
                      kthread+0xec/0x110
                      ret_from_fork+0x14/0x28
    SOFTIRQ-ON-W at:
                      lock_acquire.part.0+0xb0/0x248
                      _raw_spin_lock+0x38/0x48
                      lan966x_ptp_irq_handler+0x164/0x2a8
                      irq_thread_fn+0x1c/0x78
                      irq_thread+0x130/0x278
                      kthread+0xec/0x110
                      ret_from_fork+0x14/0x28
    INITIAL USE at:
                     lock_acquire.part.0+0xb0/0x248
                     _raw_spin_lock_irqsave+0x4c/0x68
                     lan966x_ptp_txtstamp_request+0x128/0x1cc
                     lan966x_port_xmit+0x224/0x43c
                     dev_hard_start_xmit+0xa8/0x2f0
                     sch_direct_xmit+0x108/0x2e8
                     __dev_queue_xmit+0x41c/0x1224
                     packet_sendmsg+0xdb4/0x134c
                     __sys_sendto+0xd0/0x154
                     sys_send+0x18/0x20
                     ret_fast_syscall+0x0/0x1c
  }
  ... key      at: [<c174ba0c>] __key.2+0x0/0x8
  ... acquired at:
   _raw_spin_lock_irqsave+0x4c/0x68
   lan966x_ptp_txtstamp_request+0x128/0x1cc
   lan966x_port_xmit+0x224/0x43c
   dev_hard_start_xmit+0xa8/0x2f0
   sch_direct_xmit+0x108/0x2e8
   __dev_queue_xmit+0x41c/0x1224
   packet_sendmsg+0xdb4/0x134c
   __sys_sendto+0xd0/0x154
   sys_send+0x18/0x20
   ret_fast_syscall+0x0/0x1c

-> (_xmit_ETHER#2){+.-.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire.part.0+0xb0/0x248
                    _raw_spin_lock+0x38/0x48
                    netif_freeze_queues+0x38/0x68
                    dev_deactivate_many+0xac/0x388
                    dev_deactivate+0x38/0x6c
                    linkwatch_do_dev+0x70/0x8c
                    __linkwatch_run_queue+0xd4/0x1e8
                    linkwatch_event+0x24/0x34
                    process_one_work+0x284/0x744
                    worker_thread+0x28/0x4bc
                    kthread+0xec/0x110
                    ret_from_fork+0x14/0x28
   IN-SOFTIRQ-W at:
                    lock_acquire.part.0+0xb0/0x248
                    _raw_spin_lock+0x38/0x48
                    sch_direct_xmit+0x16c/0x2e8
                    __dev_queue_xmit+0x41c/0x1224
                    ip6_finish_output2+0x5f4/0xc64
                    ndisc_send_skb+0x4cc/0x81c
                    addrconf_rs_timer+0xb0/0x2f8
                    call_timer_fn+0xb4/0x33c
                    expire_timers+0xb4/0x10c
                    run_timer_softirq+0xf8/0x2a8
                    __do_softirq+0xd4/0x5fc
                    __irq_exit_rcu+0x138/0x17c
                    irq_exit+0x8/0x28
                    __irq_svc+0x90/0xbc
                    arch_cpu_idle+0x30/0x3c
                    default_idle_call+0x44/0xac
                    do_idle+0xc8/0x138
                    cpu_startup_entry+0x18/0x1c
                    rest_init+0xcc/0x168
                    arch_post_acpi_subsys_init+0x0/0x8
   INITIAL USE at:
                   lock_acquire.part.0+0xb0/0x248
                   _raw_spin_lock+0x38/0x48
                   netif_freeze_queues+0x38/0x68
                   dev_deactivate_many+0xac/0x388
                   dev_deactivate+0x38/0x6c
                   linkwatch_do_dev+0x70/0x8c
                   __linkwatch_run_queue+0xd4/0x1e8
                   linkwatch_event+0x24/0x34
                   process_one_work+0x284/0x744
                   worker_thread+0x28/0x4bc
                   kthread+0xec/0x110
                   ret_from_fork+0x14/0x28
 }
 ... key      at: [<c175974c>] netdev_xmit_lock_key+0x8/0x1c8
 ... acquired at:
   __lock_acquire+0x978/0x2978
   lock_acquire.part.0+0xb0/0x248
   _raw_spin_lock+0x38/0x48
   sch_direct_xmit+0x16c/0x2e8
   __dev_queue_xmit+0x41c/0x1224
   ip6_finish_output2+0x5f4/0xc64
   ndisc_send_skb+0x4cc/0x81c
   addrconf_rs_timer+0xb0/0x2f8
   call_timer_fn+0xb4/0x33c
   expire_timers+0xb4/0x10c
   run_timer_softirq+0xf8/0x2a8
   __do_softirq+0xd4/0x5fc
   __irq_exit_rcu+0x138/0x17c
   irq_exit+0x8/0x28
   __irq_svc+0x90/0xbc
   arch_cpu_idle+0x30/0x3c
   default_idle_call+0x44/0xac
   do_idle+0xc8/0x138
   cpu_startup_entry+0x18/0x1c
   rest_init+0xcc/0x168
   arch_post_acpi_subsys_init+0x0/0x8

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G                 N 6.2.0-rc7-01749-gc54e1f7f7e36 #2786
Hardware name: Generic DT based system
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x58/0x70
 dump_stack_lvl from mark_lock.part.0+0x59c/0x93c
 mark_lock.part.0 from __lock_acquire+0x978/0x2978
 __lock_acquire from lock_acquire.part.0+0xb0/0x248
 lock_acquire.part.0 from _raw_spin_lock+0x38/0x48
 _raw_spin_lock from sch_direct_xmit+0x16c/0x2e8
 sch_direct_xmit from __dev_queue_xmit+0x41c/0x1224
 __dev_queue_xmit from ip6_finish_output2+0x5f4/0xc64
 ip6_finish_output2 from ndisc_send_skb+0x4cc/0x81c
 ndisc_send_skb from addrconf_rs_timer+0xb0/0x2f8
 addrconf_rs_timer from call_timer_fn+0xb4/0x33c
 call_timer_fn from expire_timers+0xb4/0x10c
 expire_timers from run_timer_softirq+0xf8/0x2a8
 run_timer_softirq from __do_softirq+0xd4/0x5fc
 __do_softirq from __irq_exit_rcu+0x138/0x17c
 __irq_exit_rcu from irq_exit+0x8/0x28
 irq_exit from __irq_svc+0x90/0xbc
Exception stack(0xc1001f20 to 0xc1001f68)
1f20: ffffffff ffffffff 00000001 c011f840 c100e000 c100e000 c1009314 c1009370
1f40: c10f0c1a c0d5e564 c0f5da8c 00000000 00000000 c1001f70 c010f0bc c010f0c0
1f60: 600f0013 ffffffff
 __irq_svc from arch_cpu_idle+0x30/0x3c
 arch_cpu_idle from default_idle_call+0x44/0xac
 default_idle_call from do_idle+0xc8/0x138
 do_idle from cpu_startup_entry+0x18/0x1c
 cpu_startup_entry from rest_init+0xcc/0x168
 rest_init from arch_post_acpi_subsys_init+0x0/0x8

Fix this by using spin_lock_irqsave/spin_lock_irqrestore also
inside lan966x_ptp_irq_handler.

Fixes: e85a96e48e33 ("net: lan966x: Add support for ptp interrupts")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index ded9ab79ccc21..931e37b9a0ada 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -523,9 +523,9 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
 		if (WARN_ON(!skb_match))
 			continue;
 
-		spin_lock(&lan966x->ptp_ts_id_lock);
+		spin_lock_irqsave(&lan966x->ptp_ts_id_lock, flags);
 		lan966x->ptp_skbs--;
-		spin_unlock(&lan966x->ptp_ts_id_lock);
+		spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
 
 		/* Get the h/w timestamp */
 		lan966x_get_hwtimestamp(lan966x, &ts, delay);
-- 
2.38.0

