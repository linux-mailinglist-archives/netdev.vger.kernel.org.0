Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4023F231C14
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgG2J1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40629 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727920AbgG2J13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 760405C00BE;
        Wed, 29 Jul 2020 05:27:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KXqc5N9h9Urt37qFEVekikn9PjsTpiLNXO1/A10v+qI=; b=LJWLP91D
        3e4eFVIfLXdhCAhr2yvPn5RlG/+za61TsBdVj/IcaRRCmsEaEQjgH0aWFO5d0Hod
        MWa/JER++R/S26tXpvxuzutxMvrPoGrFxnO9GykG/LxoWc49L5BhgbuVT3u/SiPy
        uBjbuL4t9KjSudQMTo/42h8dNdyWlV6VkukuPpMOkH9zIoiHZLGl05kLmqeTJb9D
        R43BOcGrDZuCbnPc0Izn7LyzXdQbRdTp7TUAk5uP5/DtlHFRXyy/7//ufnR/3XCk
        gDHr4FpMNG4PQpOCO8O3rYXn9Usem0CqMJhx6pMVZdBzpu/hCZAwv+GAkA8cSF/h
        RXvxuXiH1+NI1w==
X-ME-Sender: <xms:_0AhXzx1SkmpbF2j-UM27UB-AnLJ1dNBMB5VWdTR4QBFLkfeZHrA_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefteeijedugfejheffffeigeeijeehke
    eltdfgudevgfefieekgefhffetgeduudenucffohhmrghinhepqhgvmhhurdhorhhgnecu
    kfhppedutdelrdeihedrudefjedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_0AhX7TuTX2mlAUESuA9o_cw0eFMyPy-_plojVOz0cQRA2cXcLqiPg>
    <xmx:_0AhX9Wy9Hsau7O0VfiZvS6VGxPBWW_Od6xjpcTF1_IQmuGwzH5BTA>
    <xmx:_0AhX9juGneLxW4RFmAA3x5n0Us0M4H3mmI4yZ0G3vgJ_V8CAL2gvA>
    <xmx:_0AhX0N8odscITNwQKGt8KO3YyZTnxcX5ueoux5EbPxpweYhQNKaCw>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78B483280059;
        Wed, 29 Jul 2020 05:27:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 4/6] mlxsw: core: Free EMAD transactions using kfree_rcu()
Date:   Wed, 29 Jul 2020 12:26:46 +0300
Message-Id: <20200729092648.2055488-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The lifetime of EMAD transactions (i.e., 'struct mlxsw_reg_trans') is
managed using RCU. They are freed using kfree_rcu() once the transaction
ends.

However, in case the transaction failed it is freed immediately after being
removed from the active transactions list. This is problematic because it is
still possible for a different CPU to dereference the transaction from an RCU
read-side critical section while traversing the active transaction list in
mlxsw_emad_rx_listener_func(). In which case, a use-after-free is triggered
[1].

Fix this by freeing the transaction after a grace period by calling
kfree_rcu().

[1]
BUG: KASAN: use-after-free in mlxsw_emad_rx_listener_func+0x969/0xac0 drivers/net/ethernet/mellanox/mlxsw/core.c:671
Read of size 8 at addr ffff88800b7964e8 by task syz-executor.2/2881

CPU: 0 PID: 2881 Comm: syz-executor.2 Not tainted 5.8.0-rc4+ #44
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 mlxsw_emad_rx_listener_func+0x969/0xac0 drivers/net/ethernet/mellanox/mlxsw/core.c:671
 mlxsw_core_skb_receive+0x571/0x700 drivers/net/ethernet/mellanox/mlxsw/core.c:2061
 mlxsw_pci_cqe_rdq_handle drivers/net/ethernet/mellanox/mlxsw/pci.c:595 [inline]
 mlxsw_pci_cq_tasklet+0x12a6/0x2520 drivers/net/ethernet/mellanox/mlxsw/pci.c:651
 tasklet_action_common.isra.0+0x13f/0x3e0 kernel/softirq.c:550
 __do_softirq+0x223/0x964 kernel/softirq.c:292
 asm_call_on_stack+0x12/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x109/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x16f/0x1a0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x4e/0xd0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3b/0x40 kernel/locking/spinlock.c:191
Code: e8 2a c3 f4 fc 48 89 ef e8 12 96 f5 fc f6 c7 02 75 11 53 9d e8 d6 db 11 fd 65 ff 0d 1f 21 b3 56 5b 5d c3 e8 a7 d7 11 fd 53 9d <eb> ed 0f 1f 00 55 48 89 fd 65 ff 05 05 21 b3 56 ff 74 24 08 48 8d
RSP: 0018:ffff8880446ffd80 EFLAGS: 00000286
RAX: 0000000000000006 RBX: 0000000000000286 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa94ecea9
RBP: ffff888012934408 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff57be301 R12: 1ffff110088dffc1
R13: ffff888037b817c0 R14: ffff88802442415a R15: ffff888024424000
 __do_sys_perf_event_open+0x1b5d/0x2bd0 kernel/events/core.c:11874
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x473dbd
Code: Bad RIP value.
RSP: 002b:00007f21e5e9cc28 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000057bf00 RCX: 0000000000473dbd
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000040
RBP: 000000000057bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 000000000057bf0c
R13: 00007ffd0493503f R14: 00000000004d0f46 R15: 00007f21e5e9cd80

Allocated by task 871:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:467
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 mlxsw_core_reg_access_emad+0x70/0x1410 drivers/net/ethernet/mellanox/mlxsw/core.c:1812
 mlxsw_core_reg_access+0xeb/0x540 drivers/net/ethernet/mellanox/mlxsw/core.c:1991
 mlxsw_sp_port_get_hw_xstats+0x335/0x7e0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1130
 update_stats_cache+0xf4/0x140 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1173
 process_one_work+0xa3e/0x17a0 kernel/workqueue.c:2269
 worker_thread+0x9e/0x1050 kernel/workqueue.c:2415
 kthread+0x355/0x470 kernel/kthread.c:291
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

Freed by task 871:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x12c/0x170 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1474 [inline]
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3072 [inline]
 kfree+0xe6/0x320 mm/slub.c:4052
 mlxsw_core_reg_access_emad+0xd45/0x1410 drivers/net/ethernet/mellanox/mlxsw/core.c:1819
 mlxsw_core_reg_access+0xeb/0x540 drivers/net/ethernet/mellanox/mlxsw/core.c:1991
 mlxsw_sp_port_get_hw_xstats+0x335/0x7e0 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1130
 update_stats_cache+0xf4/0x140 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1173
 process_one_work+0xa3e/0x17a0 kernel/workqueue.c:2269
 worker_thread+0x9e/0x1050 kernel/workqueue.c:2415
 kthread+0x355/0x470 kernel/kthread.c:291
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88800b796400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 232 bytes inside of
 512-byte region [ffff88800b796400, ffff88800b796600)
The buggy address belongs to the page:
page:ffffea00002de500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00002de500 order:2 compound_mapcount:0 compound_pincount:0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 dead000000000100 dead000000000122 ffff88806c402500
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88800b796380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88800b796400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88800b796480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff88800b796500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800b796580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: caf7297e7ab5 ("mlxsw: core: Introduce support for asynchronous EMAD register access")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 5e76a96a118e..71b6185b4904 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1814,7 +1814,7 @@ static int mlxsw_core_reg_access_emad(struct mlxsw_core *mlxsw_core,
 	err = mlxsw_emad_reg_access(mlxsw_core, reg, payload, type, trans,
 				    bulk_list, cb, cb_priv, tid);
 	if (err) {
-		kfree(trans);
+		kfree_rcu(trans, rcu);
 		return err;
 	}
 	return 0;
-- 
2.26.2

