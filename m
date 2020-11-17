Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BF42B6FA0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbgKQUHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1918 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d910000>; Tue, 17 Nov 2020 12:07:45 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:40 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Michael Guralnik" <michaelgur@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        "Maor Gottlieb" <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/9] net/mlx5: Add handling of port type in rule deletion
Date:   Tue, 17 Nov 2020 11:56:58 -0800
Message-ID: <20201117195702.386113-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643665; bh=67icKT6NycTpUpAz6eJqL3ZPvES8rLunBy+OoBjsfV4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=gwTYcfZnnId8buROIIiJzXwKor9vn2giB/ERdh7bITup9kwPqWOzm1dJwSNPYuSsO
         lP9fQhVcU6cUVwbz8pKljSbAflB1gkz/NBpf3Vw4C29rNu1M9Kq6Drt7E4iN+4aXCI
         LY63q76IcQ59szCKhsJaCJiCkVRtTO4eqB6KQZR7KlfGM6TyFl1OoGXqeWIxnG48lx
         GxnMIdd3d8k4mMjb0tJiDJnl32v2/lmqRiT9goKliZog5fMslO0kCS7RXw2qxNy+j/
         1p1rKz7pdQc+FIXdfNvIJ0uL147lXPkwXtiadbkaJepsgjF0kDx0tLLNJ0pHgemoqN
         QeGYg5qo0nXww==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@nvidia.com>

Handle destruction of rules with port destination type to enable
full destruction of flow.

Without this handling of TX rules the deletion of these rules fails.
Dmesg of flow destruction failure:

[  203.714146] mlx5_core 0000:00:0b.0: mlx5_cmd_check:753:(pid 342): SET_FL=
OW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndro=
me (0x144b7a)
[  210.547387] ------------[ cut here ]------------
[  210.548663] refcount_t: decrement hit 0; leaking memory.
[  210.550651] WARNING: CPU: 4 PID: 342 at lib/refcount.c:31 refcount_warn_=
saturate+0x5c/0x110
[  210.550654] Modules linked in: mlx5_ib mlx5_core ib_ipoib rdma_ucm rdma_=
cm iw_cm ib_cm ib_umad ib_uverbs ib_core
[  210.550675] CPU: 4 PID: 342 Comm: test Not tainted 5.8.0-rc2+ #116
[  210.550678] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel=
-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[  210.550680] RIP: 0010:refcount_warn_saturate+0x5c/0x110
[  210.550685] Code: c6 d1 1b 01 00 0f 84 ad 00 00 00 5b 5d c3 80 3d b5 d1 =
1b 01 00 75 f4 48 c7 c7 20 d1 15 82 c6 05 a5 d1 1b 01 01 e8 a7 eb af ff <0f=
> 0b eb dd 80 3d 99 d1 1b 01 00 75 d4 48 c7 c7 c0 cf 15 82 c6 05
[  210.550687] RSP: 0018:ffff8881642e77e8 EFLAGS: 00010282
[  210.550691] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000000=
00000
[  210.550694] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ffffed102c8=
5ceef
[  210.550696] RBP: ffff888161720428 R08: ffffffff8124c10e R09: ffffed10324=
3beae
[  210.550698] R10: ffff8881921df56b R11: ffffed103243bead R12: ffff8881841=
b4180
[  210.550701] R13: ffff888161720428 R14: ffff8881616d0000 R15: ffff8881617=
20380
[  210.550704] FS:  00007fc27f025740(0000) GS:ffff888192000000(0000) knlGS:=
0000000000000000
[  210.550706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  210.550708] CR2: 0000557e4b41a6a0 CR3: 0000000002415004 CR4: 00000000003=
60ea0
[  210.550711] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  210.550713] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  210.550715] Call Trace:
[  210.550717]  mlx5_del_flow_rules+0x484/0x490 [mlx5_core]
[  210.550720]  ? mlx5_cmd_set_fte+0xa80/0xa80 [mlx5_core]
[  210.550722]  mlx5_ib_destroy_flow+0x17f/0x280 [mlx5_ib]
[  210.550724]  uverbs_free_flow+0x4c/0x90 [ib_uverbs]
[  210.550726]  destroy_hw_idr_uobject+0x41/0xb0 [ib_uverbs]
[  210.550728]  uverbs_destroy_uobject+0xaa/0x390 [ib_uverbs]
[  210.550731]  __uverbs_cleanup_ufile+0x129/0x1b0 [ib_uverbs]
[  210.550733]  ? uverbs_destroy_uobject+0x390/0x390 [ib_uverbs]
[  210.550735]  uverbs_destroy_ufile_hw+0x78/0x190 [ib_uverbs]
[  210.550737]  ib_uverbs_close+0x36/0x140 [ib_uverbs]
[  210.550739]  __fput+0x181/0x380
[  210.550741]  task_work_run+0x88/0xd0
[  210.550743]  do_exit+0x5f6/0x13b0
[  210.550745]  ? sched_clock_cpu+0x30/0x140
[  210.550747]  ? is_current_pgrp_orphaned+0x70/0x70
[  210.550750]  ? lock_downgrade+0x360/0x360
[  210.550752]  ? mark_held_locks+0x1d/0x90
[  210.550754]  do_group_exit+0x8a/0x140
[  210.550756]  get_signal+0x20a/0xf50
[  210.550758]  do_signal+0x8c/0xbe0
[  210.550760]  ? hrtimer_nanosleep+0x1d8/0x200
[  210.550762]  ? nanosleep_copyout+0x50/0x50
[  210.550764]  ? restore_sigcontext+0x320/0x320
[  210.550766]  ? __hrtimer_init+0xf0/0xf0
[  210.550768]  ? timespec64_add_safe+0x150/0x150
[  210.550770]  ? mark_held_locks+0x1d/0x90
[  210.550772]  ? lockdep_hardirqs_on_prepare+0x14c/0x240
[  210.550774]  __prepare_exit_to_usermode+0x119/0x170
[  210.550776]  do_syscall_64+0x65/0x300
[  210.550778]  ? trace_hardirqs_off+0x10/0x120
[  210.550781]  ? mark_held_locks+0x1d/0x90
[  210.550783]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[  210.550785]  ? lockdep_hardirqs_on+0x112/0x190
[  210.550787]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  210.550789] RIP: 0033:0x7fc27f1cd157
[  210.550791] Code: Bad RIP value.
[  210.550793] RSP: 002b:00007ffd4db27ea8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000023
[  210.550798] RAX: fffffffffffffdfc RBX: ffffffffffffff80 RCX: 00007fc27f1=
cd157
[  210.550800] RDX: 00007fc27f025740 RSI: 00007ffd4db27eb0 RDI: 00007ffd4db=
27eb0
[  210.550803] RBP: 0000000000000016 R08: 0000000000000000 R09: 00000000000=
0000e
[  210.550805] R10: 00007ffd4db27dc7 R11: 0000000000000246 R12: 00000000004=
00c00
[  210.550808] R13: 00007ffd4db285f0 R14: 0000000000000000 R15: 00000000000=
00000
[  210.550809] irq event stamp: 49399
[  210.550812] hardirqs last  enabled at (49399): [<ffffffff81172d36>] cons=
ole_unlock+0x556/0x6f0
[  210.550815] hardirqs last disabled at (49398): [<ffffffff81172897>] cons=
ole_unlock+0xb7/0x6f0
[  210.550818] softirqs last  enabled at (48706): [<ffffffff81e0037b>] __do=
_softirq+0x37b/0x60c
[  210.550820] softirqs last disabled at (48697): [<ffffffff81c00e2f>] asm_=
call_on_stack+0xf/0x20
[  210.550822] ---[ end trace ad18c0e6fa846454 ]---
[  210.581862] mlx5_core 0000:00:0c.0: mlx5_destroy_flow_table:2132:(pid 34=
2): Flow table 262150 wasn't destroyed, refcount > 1

Fixes: a7ee18bdee83 ("RDMA/mlx5: Allow creating a matcher for a NIC TX flow=
 table")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 325a5b0d6829..9fdd99272e31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -534,6 +534,13 @@ static void del_sw_hw_rule(struct fs_node *node)
 		goto out;
 	}
=20
+	if (rule->dest_attr.type =3D=3D MLX5_FLOW_DESTINATION_TYPE_PORT &&
+	    --fte->dests_size) {
+		fte->modify_mask |=3D BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_ACTION);
+		fte->action.action &=3D ~MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+		goto out;
+	}
+
 	if ((fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) &&
 	    --fte->dests_size) {
 		fte->modify_mask |=3D
--=20
2.26.2

