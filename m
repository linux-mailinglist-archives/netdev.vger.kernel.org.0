Return-Path: <netdev+bounces-7645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EFD720F19
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B08FE281A6C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 10:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64995C13C;
	Sat,  3 Jun 2023 10:08:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54259EA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 10:08:09 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055B71A6
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 03:08:05 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QYFn46tZkz18LY6;
	Sat,  3 Jun 2023 18:03:20 +0800 (CST)
Received: from huawei.com (10.136.112.231) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 3 Jun
 2023 18:08:02 +0800
From: zhangrui <zhangrui182@huawei.com>
To: <netdev@vger.kernel.org>
CC: <borisp@nvidia.com>, <john.fastabend@gmail.com>, <kuba@kernel.org>,
	<fengtao40@huawei.com>, <yanan@huawei.com>, <zhangrui182@huawei.com>,
	<majun65@huawei.com>, <caowangbao@huawei.com>
Subject: KASAN: gcmaes_crypt_by_sg null ptr deref
Date: Sat, 3 Jun 2023 18:07:59 +0800
Message-ID: <20230603100759.42632-1-zhangrui182@huawei.com>
X-Mailer: git-send-email 2.20.1.windows.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.136.112.231]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,
We found the following issue using syzkaller on linux v5.10.0

The brief report is below:
========================================================

[ 3033.467159][T12933] IPVS: ftp: loaded support on port[0] = 21
[ 3033.469333][T20738] general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
[ 3033.472162][T20738] KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
[ 3033.472176][T20738] CPU: 3 PID: 20738 Comm: kworker/u10:1 Not tainted 5.10.0 #1
[ 3033.472190][T20738] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 3033.472241][T20738] Workqueue: pencrypt_parallel padata_parallel_worker
[ 3033.472293][T20738] RIP: 0010:gcmaes_crypt_by_sg+0xa4f/0x1720
[ 3033.472307][T20738] Code: 85 fe 09 00 00 03 45 0c 44 39 e8 77 32 e8 f9 de 36 00 48 89 ef e8 a1 3a d3 01 48 89 c5 48 8d 40 08 48 89 44 24 10 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 19 0a 00 00 44 8b 6d 08 e8
[ 3033.472313][T20738] RSP: 0000:ffff8881090b78b0 EFLAGS: 00010202
[ 3033.472323][T20738] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[ 3033.472341][T20738] RDX: 0000000000000000 RSI: ffffffff8312e0b5 RDI: ffff88812e657258
[ 3033.492044][T20738] RBP: 0000000000000000 R08: ffff88812e65730c R09: 0000000000000002
[ 3033.492050][T20738] R10: 0000000000000ffb R11: 0000000000000000 R12: ffff88812e657300
[ 3033.492053][T20738] R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000005
[ 3033.492059][T20738] FS:  0000000000000000(0000) GS:ffff888134d00000(0000) knlGS:0000000000000000
[ 3033.492065][T20738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3033.492069][T20738] CR2: 0000001b30522000 CR3: 0000000021792000 CR4: 0000000000150ee0
[ 3033.492072][T20738] Call Trace:
[ 3033.492107][T20738]  ? ecb_encrypt+0x170/0x170
[ 3033.492128][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3033.504777][T20738]  ? stack_trace_save+0x91/0xd0
[ 3033.504788][T20738]  ? filter_irq_stacks+0xa0/0xa0
[ 3033.504796][T20738]  ? wq_worker_running+0x19/0x120
[ 3033.504805][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3033.504829][T20738]  ? kasan_save_stack+0x32/0x40
[ 3033.509859][T20738]  ? kasan_save_stack+0x1b/0x40
[ 3033.509865][T20738]  ? kasan_set_track+0x1c/0x30
[ 3033.509872][T20738]  ? kasan_set_free_info+0x20/0x40
[ 3033.509877][T20738]  ? __kasan_slab_free+0x152/0x180
[ 3033.509882][T20738]  ? kmem_cache_free+0x91/0x550
[ 3033.509889][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3033.509895][T20738]  ? fsnotify_mark_destroy_workfn+0x205/0x320
[ 3033.509902][T20738]  ? process_one_work+0x682/0xe80
[ 3033.509906][T20738]  ? worker_thread+0x99/0xd00
[ 3033.509913][T20738]  ? kthread+0x2f8/0x400
[ 3033.509920][T20738]  ? ret_from_fork+0x22/0x30
[ 3033.509951][T20738]  ? bit_wait_io_timeout+0x160/0x160
[ 3033.509961][T20738]  ? srcu_gp_start_if_needed+0x537/0xb70
[ 3033.509974][T20738]  ? __perf_event_task_sched_in+0x1ef/0x750
[ 3033.509984][T20738]  ? set_next_entity+0x235/0x2190
[ 3033.509998][T20738]  ? generic_gcmaes_encrypt+0x13c/0x1b0
[ 3033.510008][T20738]  ? helper_rfc4106_decrypt+0x360/0x360
[ 3033.510018][T20738]  ? sched_clock_cpu+0x18/0x190
[ 3033.510034][T20738]  ? crypto_aead_encrypt+0xa7/0xf0
[ 3033.510044][T20738]  ? crypto_aead_encrypt+0xa7/0xf0
[ 3033.510054][T20738]  ? pcrypt_aead_enc+0x18/0x60
[ 3033.510066][T20738]  ? padata_parallel_worker+0x68/0xc0
[ 3033.510075][T20738]  ? process_one_work+0x682/0xe80
[ 3033.510102][T20738]  ? worker_thread+0x99/0xd00
[ 3033.534976][T20738]  ? process_one_work+0xe80/0xe80
[ 3033.534985][T20738]  ? kthread+0x2f8/0x400
[ 3033.534995][T20738]  ? __kthread_cancel_work+0x1a0/0x1a0
[ 3033.535006][T20738]  ? ret_from_fork+0x22/0x30
[ 3033.535027][T20738] Modules linked in:
[ 3033.539004][T20738] kernel fault(0x1) notification starting on CPU 3
[ 3033.539009][T20738] kernel fault(0x1) notification finished on CPU 3
[ 3033.539109][T20738] ---[ end trace f4dff6228a7d0992 ]---
[ 3033.543656][T20738] RIP: 0010:gcmaes_crypt_by_sg+0xa4f/0x1720
[ 3033.544827][T20738] Code: 85 fe 09 00 00 03 45 0c 44 39 e8 77 32 e8 f9 de 36 00 48 89 ef e8 a1 3a d3 01 48 89 c5 48 8d 40 08 48 89 44 24 10 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 19 0a 00 00 44 8b 6d 08 e8
[ 3033.548733][T20738] RSP: 0000:ffff8881090b78b0 EFLAGS: 00010202
[ 3033.549897][T20738] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[ 3033.551431][T20738] RDX: 0000000000000000 RSI: ffffffff8312e0b5 RDI: ffff88812e657258
[ 3033.553010][T20738] RBP: 0000000000000000 R08: ffff88812e65730c R09: 0000000000000002
[ 3033.554639][T20738] R10: 0000000000000ffb R11: 0000000000000000 R12: ffff88812e657300
[ 3033.556281][T20738] R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000005
[ 3033.557901][T20738] FS:  0000000000000000(0000) GS:ffff888134d00000(0000) knlGS:0000000000000000
[ 3033.559811][T20738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3033.561330][T20738] CR2: 0000001b30522000 CR3: 0000000021792000 CR4: 0000000000150ee0
[ 3033.563113][T20738] Kernel panic - not syncing: Fatal exception in interrupt
[ 3033.564817][T20738] kernel fault(0x5) notification starting on CPU 3
[ 3033.565965][T20738] kernel fault(0x5) notification finished on CPU 3
[ 3033.568219][T20738] Kernel Offset: disabled
[ 3033.569181][T20738] kernel reboot(0x2) notification starting on CPU 3
[ 3033.570794][T20738] kernel reboot(0x2) notification finished on CPU 3
[ 3033.572102][T20738] Rebooting in 3 seconds..
[ 3036.631658][T20738] kernel reboot(0x5) notification starting on CPU 3
[ 3036.632958][T20738] kernel reboot(0x5) notification finished on CPU 3
[ 3036.634209][T20738] ------------[ cut here ]------------
[ 3036.635281][T20738] list_add double add: new=ffffffff8f587200, prev=ffffffff8f529788, next=ffffffff8f587200.
[ 3036.637233][T20738] WARNING: CPU: 3 PID: 20738 at lib/list_debug.c:33 __list_add_valid+0xf3/0x130
[ 3036.638991][T20738] Modules linked in:
[ 3036.639741][T20738] CPU: 3 PID: 20738 Comm: kworker/u10:1 Tainted: G      D           5.10.0 #1
[ 3036.641416][T20738] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 3036.643326][T20738] Workqueue: pencrypt_parallel padata_parallel_worker
[ 3036.644585][T20738] RIP: 0010:__list_add_valid+0xf3/0x130
[ 3036.645582][T20738] Code: 48 c7 c7 40 64 f0 8c 4c 89 e6 e8 c8 1d 8a 08 0f 0b 31 c0 eb 99 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 c0 64 f0 8c e8 ad 1d 8a 08 <0f> 0b 31 c0 e9 7b ff ff ff 48 89 f7 48 89 34 24 e8 48 28 a5 fe 48
[ 3036.649021][T20738] RSP: 0000:ffff8881090b7540 EFLAGS: 00010082
[ 3036.650196][T20738] RAX: 0000000000000000 RBX: ffffffff8f587200 RCX: 0000000000000000
[ 3036.651859][T20738] RDX: 0000000000000000 RSI: ffffffff81604a22 RDI: ffffed1021216e9a
[ 3036.653295][T20738] RBP: ffffffff8f587200 R08: 0000000000000001 R09: ffffed1021216e31
[ 3036.654748][T20738] R10: ffff8881090b7187 R11: ffffed1021216e30 R12: ffffffff8f587200
[ 3036.656132][T20738] R13: 0000000000000046 R14: ffffffff8f529780 R15: 0000000000000000
[ 3036.657642][T20738] FS:  0000000000000000(0000) GS:ffff888134d00000(0000) knlGS:0000000000000000
[ 3036.659206][T20738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3036.660389][T20738] CR2: 0000001b30522000 CR3: 0000000021792000 CR4: 0000000000150ee0
[ 3036.661751][T20738] Call Trace:
[ 3036.662434][T20738]  __register_nmi_handler+0x1f9/0x390
[ 3036.663544][T20738]  nmi_shootdown_cpus+0x8e/0x150
[ 3036.664439][T20738]  native_machine_emergency_restart+0x44e/0x520
[ 3036.665522][T20738]  ? nmi_shootdown_cpus+0x150/0x150
[ 3036.666447][T20738]  ? down_trylock+0x88/0xc0
[ 3036.667259][T20738]  ? kmsg_dump+0x19d/0x210
[ 3036.668010][T20738]  ? atomic_notifier_call_chain+0xbd/0xf0
[ 3036.669060][T20738]  panic+0x75b/0x811
[ 3036.669717][T20738]  ? print_oops_end_marker.cold+0x15/0x15
[ 3036.670766][T20738]  ? __show_regs.cold+0x44c/0x57b
[ 3036.671677][T20738]  ? vprintk_func+0xb2/0x1d0
[ 3036.672584][T20738]  oops_end.cold+0xc/0x18
[ 3036.673398][T20738]  exc_general_protection+0x16a/0x2c0
[ 3036.674371][T20738]  asm_exc_general_protection+0x1e/0x30
[ 3036.675381][T20738] RIP: 0010:gcmaes_crypt_by_sg+0xa4f/0x1720
[ 3036.676462][T20738] Code: 85 fe 09 00 00 03 45 0c 44 39 e8 77 32 e8 f9 de 36 00 48 89 ef e8 a1 3a d3 01 48 89 c5 48 8d 40 08 48 89 44 24 10 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 19 0a 00 00 44 8b 6d 08 e8
[ 3036.679811][T20738] RSP: 0000:ffff8881090b78b0 EFLAGS: 00010202
[ 3036.680916][T20738] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[ 3036.682282][T20738] RDX: 0000000000000000 RSI: ffffffff8312e0b5 RDI: ffff88812e657258
[ 3036.683693][T20738] RBP: 0000000000000000 R08: ffff88812e65730c R09: 0000000000000002
[ 3036.685145][T20738] R10: 0000000000000ffb R11: 0000000000000000 R12: ffff88812e657300
[ 3036.686546][T20738] R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000005
[ 3036.687952][T20738]  ? sg_next+0x65/0xa0
[ 3036.688706][T20738]  ? ecb_encrypt+0x170/0x170
[ 3036.689528][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3036.690533][T20738]  ? stack_trace_save+0x91/0xd0
[ 3036.691381][T20738]  ? filter_irq_stacks+0xa0/0xa0
[ 3036.692483][T20738]  ? wq_worker_running+0x19/0x120
[ 3036.693328][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3036.694535][T20738]  ? kasan_save_stack+0x32/0x40
[ 3036.695556][T20738]  ? kasan_save_stack+0x1b/0x40
[ 3036.696707][T20738]  ? kasan_set_track+0x1c/0x30
[ 3036.697799][T20738]  ? kasan_set_free_info+0x20/0x40
[ 3036.698699][T20738]  ? __kasan_slab_free+0x152/0x180
[ 3036.699614][T20738]  ? kmem_cache_free+0x91/0x550
[ 3036.700541][T20738]  ? fsnotify_final_mark_destroy+0x7c/0xc0
[ 3036.701576][T20738]  ? fsnotify_mark_destroy_workfn+0x205/0x320
[ 3036.702751][T20738]  ? process_one_work+0x682/0xe80
[ 3036.703636][T20738]  ? worker_thread+0x99/0xd00
[ 3036.704528][T20738]  ? kthread+0x2f8/0x400
[ 3036.705347][T20738]  ? ret_from_fork+0x22/0x30
[ 3036.706241][T20738]  ? bit_wait_io_timeout+0x160/0x160
[ 3036.707250][T20738]  ? srcu_gp_start_if_needed+0x537/0xb70
[ 3036.708242][T20738]  ? __perf_event_task_sched_in+0x1ef/0x750
[ 3036.709282][T20738]  ? set_next_entity+0x235/0x2190
[ 3036.710180][T20738]  ? generic_gcmaes_encrypt+0x13c/0x1b0
[ 3036.711191][T20738]  ? helper_rfc4106_decrypt+0x360/0x360
[ 3036.712194][T20738]  ? sched_clock_cpu+0x18/0x190
[ 3036.713059][T20738]  ? crypto_aead_encrypt+0xa7/0xf0
[ 3036.714021][T20738]  ? crypto_aead_encrypt+0xa7/0xf0
[ 3036.714882][T20738]  ? pcrypt_aead_enc+0x18/0x60
[ 3036.715727][T20738]  ? padata_parallel_worker+0x68/0xc0
[ 3036.716673][T20738]  ? process_one_work+0x682/0xe80
[ 3036.717876][T20738]  ? worker_thread+0x99/0xd00
[ 3036.719030][T20738]  ? process_one_work+0xe80/0xe80
[ 3036.720252][T20738]  ? kthread+0x2f8/0x400
[ 3036.721285][T20738]  ? __kthread_cancel_work+0x1a0/0x1a0
[ 3036.722264][T20738]  ? ret_from_fork+0x22/0x30
[ 3036.723088][T20738] Kernel panic - not syncing: panic_on_warn set ...
[ 3036.724214][T20738] kernel fault(0x5) notification starting on CPU 3
[ 3036.725376][T20738] kernel fault(0x5) notification finished on CPU 3
[ 3036.726535][T20738] Kernel Offset: disabled
[ 3036.727294][T20738] kernel reboot(0x2) notification starting on CPU 3
[ 3036.728557][T20738] kernel reboot(0x2) notification finished on CPU 3
[ 3036.729738][T20738] Rebooting in 3 seconds..
[ 3039.786213][T20738] kernel reboot(0x5) notification starting on CPU 3
[ 3039.792695][T20738] kernel reboot(0x5) notification finished on CPU 3

========================================================
kasan

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 3 PID: 20738 Comm: kworker/u10:1 Not tainted 5.10.0 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Workqueue: pencrypt_parallel padata_parallel_worker
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:93 [inline]
RIP: 0010:scatterwalk_done include/crypto/scatterwalk.h:101 [inline]
RIP: 0010:gcmaes_crypt_by_sg+0xa4f/0x1720 arch/x86/crypto/aesni-intel_glue.c:764
Code: 85 fe 09 00 00 03 45 0c 44 39 e8 77 32 e8 f9 de 36 00 48 89 ef e8 a1 3a d3 01 48 89 c5 48 8d 40 08 48 89 44 24 10 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 19 0a 00 00 44 8b 6d 08 e8
RSP: 0000:ffff8881090b78b0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8312e0b5 RDI: ffff88812e657258
RBP: 0000000000000000 R08: ffff88812e65730c R09: 0000000000000002
R10: 0000000000000ffb R11: 0000000000000000 R12: ffff88812e657300
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff888134d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30522000 CR3: 0000000021792000 CR4: 0000000000150ee0
Call Trace:
Modules linked in:
kernel fault(0x1) notification starting on CPU 3
kernel fault(0x1) notification finished on CPU 3
---[ end trace f4dff6228a7d0992 ]---
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:93 [inline]
RIP: 0010:scatterwalk_done include/crypto/scatterwalk.h:101 [inline]
RIP: 0010:gcmaes_crypt_by_sg+0xa4f/0x1720 arch/x86/crypto/aesni-intel_glue.c:764
Code: 85 fe 09 00 00 03 45 0c 44 39 e8 77 32 e8 f9 de 36 00 48 89 ef e8 a1 3a d3 01 48 89 c5 48 8d 40 08 48 89 44 24 10 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 19 0a 00 00 44 8b 6d 08 e8
RSP: 0000:ffff8881090b78b0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8312e0b5 RDI: ffff88812e657258
RBP: 0000000000000000 R08: ffff88812e65730c R09: 0000000000000002
R10: 0000000000000ffb R11: 0000000000000000 R12: ffff88812e657300
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff888134d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30522000 CR3: 0000000021792000 CR4: 0000000000150ee0
----------------
Code disassembly (best guess):
   0:   85 fe                   test   %edi,%esi
   2:   09 00                   or     %eax,(%rax)
   4:   00 03                   add    %al,(%rbx)
   6:   45 0c 44                rex.RB or $0x44,%al
   9:   39 e8                   cmp    %ebp,%eax
   b:   77 32                   ja     0x3f
   d:   e8 f9 de 36 00          callq  0x36df0b
  12:   48 89 ef                mov    %rbp,%rdi
  15:   e8 a1 3a d3 01          callq  0x1d33abb
  1a:   48 89 c5                mov    %rax,%rbp
  1d:   48 8d 40 08             lea    0x8(%rax),%rax
  21:   48 89 44 24 10          mov    %rax,0x10(%rsp)
  26:   48 c1 e8 03             shr    $0x3,%rax
* 2a:   42 0f b6 04 30          movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:   84 c0                   test   %al,%al
  31:   74 08                   je     0x3b
  33:   3c 03                   cmp    $0x3,%al
  35:   0f 8e 19 0a 00 00       jle    0xa54
  3b:   44 8b 6d 08             mov    0x8(%rbp),%r13d
  3f:   e8                      .byte 0xe8

