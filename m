Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011FC6A4545
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjB0Oyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjB0Oys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:54:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1DC22009;
        Mon, 27 Feb 2023 06:54:44 -0800 (PST)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PQNl41KZrzKqBd;
        Mon, 27 Feb 2023 22:52:32 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Feb 2023 22:54:29 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <kuba@kernel.org>, <liaichun@huawei.com>, <yanan@huawei.com>
Subject: panic in mld_newpack
Date:   Mon, 27 Feb 2023 22:54:43 +0800
Message-ID: <20230227145443.2189961-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I was executing the syzkaller test case, I accidentally triggered a panic
 similar to the following: 020ef930b826 (mld: fix panic in mld_newpack()) 
I confirm that my kernel version has merged this commit, I can't understand
 how this problem arises.By the way,this problem only came up once.

==============================================================================
09:22:42 executing program 0:
r0 = timerfd_create(0x0, 0x0)
ioctl$sock_inet_SIOCSARP(r0, 0x5451, 0x0)

[ 1775.166505][    C1] skbuff: skb_over_panic: text:ffffffff8acae9b4 len:40 put:40 head:ffff88806120dc00 data:ffff88806120dd00 tail:0x128 end:0xc0 dev:ip6erspan0
[ 1775.172690][    C1] ------------[ cut here ]------------
[ 1775.179233][    C1] kernel BUG at net/core/skbuff.c:110!
[ 1775.180688][    C1] invalid opcode: 0000 [#1] SMP KASAN PTI
[ 1775.183238][    C1] CPU: 1 PID: 25239 Comm: syz-executor.1 Not tainted 5.10.0 #1
[ 1775.187004][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1775.189767][    C1] RIP: 0010:skb_panic+0x171/0x183
[ 1775.191286][    C1] Code: f5 4c 8b 4c 24 10 41 56 8b 4b 70 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 a0 ae 2d 8e ff 74 24 10 ff 74 24 20 e8 0c 6d 62 ff <0f> 0b 48 c7 c7 a0 db 5d 92 48 83 c4 20 e8 7e 7a 6d ff e8 50 c0 5d
[ 1775.195221][    C1] RSP: 0018:ffff888134009a48 EFLAGS: 00010286
[ 1775.196462][    C1] RAX: 000000000000008a RBX: ffff88812885aa00 RCX: 0000000000000000
[ 1775.198064][    C1] RDX: 0000000000000000 RSI: ffffffff815fe682 RDI: ffffed102680133b
[ 1775.199662][    C1] RBP: ffffffff8e2db3e0 R08: 000000000000008a R09: ffffed10268012d2
[ 1775.201276][    C1] R10: ffff88813400968f R11: ffffed10268012d1 R12: ffffffff8acae9b4
[ 1775.202874][    C1] R13: 0000000000000028 R14: ffff888060ad6000 R15: 00000000000000c0
[ 1775.208819][    C1] FS:  00007f1191620700(0000) GS:ffff888134000000(0000) knlGS:0000000000000000
[ 1775.214244][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1775.218370][    C1] CR2: 00007f119161ebd8 CR3: 000000011f95e000 CR4: 0000000000150ee0
[ 1775.223324][    C1] Call Trace:
[ 1775.225501][    C1]  <IRQ>
[ 1775.233024][    C1]  ? ip6_mc_hdr.isra.0.constprop.0+0x124/0x5a0
[ 1775.234738][    C1]  skb_put.cold+0x24/0x24
[ 1775.235951][    C1]  ip6_mc_hdr.isra.0.constprop.0+0x124/0x5a0
[ 1775.237639][    C1]  ? tcp_gro_receive+0xdd0/0xdd0
[ 1775.239008][    C1]  mld_newpack+0x38c/0x7a0
[ 1775.240162][    C1]  ? ip6_mc_hdr.isra.0.constprop.0+0x5a0/0x5a0
[ 1775.241900][    C1]  ? enqueue_entity+0xca2/0x3ab0
[ 1775.243236][    C1]  ? find_first_bit+0x6c/0x90
[ 1775.244763][    C1]  add_grhead.isra.0+0x2a6/0x380
[ 1775.247156][    C1]  add_grec+0xcdc/0xf70
[ 1775.249187][    C1]  ? add_grhead.isra.0+0x380/0x380
[ 1775.251671][    C1]  ? _raw_spin_lock_bh+0x85/0xe0
[ 1775.254022][    C1]  ? _raw_read_unlock_irqrestore+0x30/0x30
[ 1775.256935][    C1]  ? clear_posix_cputimers_work+0x90/0x90
[ 1775.259881][    C1]  ? perf_event_task_tick+0x804/0xd90
[ 1775.262620][    C1]  mld_ifc_timer_expire+0x34b/0x810
[ 1775.265234][    C1]  ? mld_send_initial_cr.part.0+0x150/0x150
[ 1775.267741][    C1]  call_timer_fn+0x3f/0x200
[ 1775.269050][    C1]  expire_timers+0x21c/0x3b0
[ 1775.270364][    C1]  ? mld_send_initial_cr.part.0+0x150/0x150
[ 1775.272020][    C1]  run_timer_softirq+0x2ad/0x7f0
[ 1775.273434][    C1]  ? expire_timers+0x3b0/0x3b0
[ 1775.274743][    C1]  ? ktime_get+0xd5/0x120
[ 1775.275944][    C1]  ? kvm_sched_clock_read+0xd/0x20
[ 1775.277371][    C1]  ? sched_clock+0x5/0x10
[ 1775.278586][    C1]  ? sched_clock_cpu+0x18/0x190
[ 1775.278596][    C1]  ? tick_program_event+0x7c/0x110
[ 1775.278607][    C1]  __do_softirq+0x19b/0x612
[ 1775.278621][    C1]  asm_call_irq_on_stack+0x12/0x20
[ 1775.278625][    C1]  </IRQ>
[ 1775.278635][    C1]  do_softirq_own_stack+0x37/0x50
[ 1775.278643][    C1]  irq_exit_rcu+0x1a2/0x240
[ 1775.278653][    C1]  sysvec_apic_timer_interrupt+0x36/0x80
[ 1775.278664][    C1]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 1775.278675][    C1] RIP: 0010:security_socket_create+0x35/0xc0
[ 1775.278686][    C1] Code: 56 41 89 f6 41 55 41 89 d5 41 54 41 89 cc 55 48 bd 00 00 00 00 00 fc ff df 53 48 83 ec 08 e8 d2 74 c5 fe 48 8b 1d fb fd 68 12 <48> 85 db 74 49 e8 c1 74 c5 fe 48 8d 7b 18 48 89 f8 48 c1 e8 03 80
[ 1775.278691][    C1] RSP: 0018:ffff8880608efdf0 EFLAGS: 00000216
[ 1775.278702][    C1] RAX: 0000000000040000 RBX: ffffffff8fe5f4f0 RCX: ffffc90006b18000
[ 1775.278708][    C1] RDX: 00000000000000f4 RSI: ffffffff82b08dae RDI: 0000000000000010
[ 1775.278714][    C1] RBP: dffffc0000000000 R08: ffff8880608efeb0 R09: 0000000000000000
[ 1775.278719][    C1] R10: ffffffff94f30687 R11: fffffbfff29e60d0 R12: 0000000000000000
[ 1775.278725][    C1] R13: 0000000000000010 R14: 0000000000000003 R15: 0000000000000010
[ 1775.278735][    C1]  ? security_socket_create+0x2e/0xc0
[ 1775.278747][    C1]  __sock_create+0x66/0x4a0
[ 1775.278757][    C1]  __sys_socket+0xe3/0x1d0
[ 1775.278765][    C1]  ? move_addr_to_kernel+0x60/0x60
[ 1775.278776][    C1]  ? exit_to_user_mode_prepare+0x24/0x150
[ 1775.278786][    C1]  __x64_sys_socket+0x74/0xb0
[ 1775.278795][    C1]  do_syscall_64+0x33/0x40
[ 1775.278805][    C1]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[ 1775.278812][    C1] RIP: 0033:0x7f11930d61eb
[ 1775.278824][    C1] Code: f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[ 1775.278829][    C1] RSP: 002b:00007f119161eb58 EFLAGS: 00000286 ORIG_RAX: 0000000000000029
[ 1775.278839][    C1] RAX: ffffffffffffffda RBX: 00007f119320f050 RCX: 00007f11930d61eb
[ 1775.278844][    C1] RDX: 0000000000000010 RSI: 0000000000000003 RDI: 0000000000000010
[ 1775.278850][    C1] RBP: 00007f1193140d75 R08: 0000000000000000 R09: 0000000000000000
[ 1775.278856][    C1] R10: 0000000020000280 R11: 0000000000000286 R12: 00000000ffffffff
[ 1775.278862][    C1] R13: 00007fff7153e8bf R14: 00007fff7153ea60 R15: 00007f119161fd80
[ 1775.278880][    C1] Modules linked in:
[ 1775.278894][    C1] kernel fault(0x1) notification starting on CPU 1
[ 1775.278900][    C1] kernel fault(0x1) notification finished on CPU 1
[ 1775.279032][    C1] ---[ end trace 0dbd9a08e777fbed ]---
[ 1775.279043][    C1] RIP: 0010:skb_panic+0x171/0x183
[ 1775.279052][    C1] Code: f5 4c 8b 4c 24 10 41 56 8b 4b 70 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 a0 ae 2d 8e ff 74 24 10 ff 74 24 20 e8 0c 6d 62 ff <0f> 0b 48 c7 c7 a0 db 5d 92 48 83 c4 20 e8 7e 7a 6d ff e8 50 c0 5d
[ 1775.279058][    C1] RSP: 0018:ffff888134009a48 EFLAGS: 00010286
[ 1775.279066][    C1] RAX: 000000000000008a RBX: ffff88812885aa00 RCX: 0000000000000000
[ 1775.279072][    C1] RDX: 0000000000000000 RSI: ffffffff815fe682 RDI: ffffed102680133b
[ 1775.279078][    C1] RBP: ffffffff8e2db3e0 R08: 000000000000008a R09: ffffed10268012d2
[ 1775.279084][    C1] R10: ffff88813400968f R11: ffffed10268012d1 R12: ffffffff8acae9b4
[ 1775.279090][    C1] R13: 0000000000000028 R14: ffff888060ad6000 R15: 00000000000000c0
[ 1775.279097][    C1] FS:  00007f1191620700(0000) GS:ffff888134000000(0000) knlGS:0000000000000000
[ 1775.279107][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1775.279113][    C1] CR2: 00007f119161ebd8 CR3: 000000011f95e000 CR4: 0000000000150ee0
[ 1775.279118][    C1] Kernel panic - not syncing: Fatal exception in interrupt
[ 1775.279128][    C1] kernel fault(0x5) notification starting on CPU 1
[ 1775.279134][    C1] kernel fault(0x5) notification finished on CPU 1
[ 1775.280189][    C1] Kernel Offset: disabled
[ 1775.378438][    C1] kernel reboot(0x2) notification starting on CPU 1
[ 1775.379930][    C1] kernel reboot(0x2) notification finished on CPU 1
[ 1775.381407][    C1] Rebooting in 3 seconds..
[ 1778.475964][    C1] kernel reboot(0x5) notification starting on CPU 1
[ 1778.481790][    C1] kernel reboot(0x5) notification finished on CPU 1
[ 1778.483273][    C1] ------------[ cut here ]------------
[ 1778.484532][    C1] list_add double add: new=ffffffff8f385700, prev=ffffffff8f327ec8, next=ffffffff8f385700.
[ 1778.486793][    C1] WARNING: CPU: 1 PID: 25239 at lib/list_debug.c:33 __list_add_valid+0xf3/0x130
[ 1778.488600][    C1] Modules linked in:
[ 1778.489401][    C1] CPU: 1 PID: 25239 Comm: syz-executor.1 Tainted: G      D           5.10.0 #1
[ 1778.491185][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1778.493682][    C1] RIP: 0010:__list_add_valid+0xf3/0x130
[ 1778.494975][    C1] Code: 48 c7 c7 80 69 cd 8c 4c 89 e6 e8 d1 15 8b 08 0f 0b 31 c0 eb 99 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 00 6a cd 8c e8 b6 15 8b 08 <0f> 0b 31 c0 e9 7b ff ff ff 48 89 f7 48 89 34 24 e8 28 c8 cd fe 48
[ 1778.499459][    C1] RSP: 0018:ffff8881340096a8 EFLAGS: 00010086
[ 1778.500890][    C1] RAX: 0000000000000000 RBX: ffffffff8f385700 RCX: 0000000000000000
[ 1778.502717][    C1] RDX: 0000000000000000 RSI: ffffffff815fe682 RDI: ffffed10268012c7
[ 1778.504558][    C1] RBP: ffffffff8f385700 R08: 0000000000000001 R09: ffffed102680125e
[ 1778.506388][    C1] R10: ffff8881340092ef R11: ffffed102680125d R12: ffffffff8f385700
[ 1778.508645][    C1] R13: 0000000000000046 R14: ffffffff8f327ec0 R15: 0000000000000000
[ 1778.510509][    C1] FS:  00007f1191620700(0000) GS:ffff888134000000(0000) knlGS:0000000000000000
[ 1778.512616][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1778.514179][    C1] CR2: 00007f119161ebd8 CR3: 000000011f95e000 CR4: 0000000000150ee0
[ 1778.515940][    C1] Call Trace:
[ 1778.516690][    C1]  <IRQ>
[ 1778.517372][    C1]  __register_nmi_handler+0x1f9/0x390
[ 1778.518596][    C1]  nmi_shootdown_cpus+0x8e/0x150
[ 1778.519716][    C1]  native_machine_emergency_restart+0x44e/0x520
[ 1778.521139][    C1]  ? nmi_shootdown_cpus+0x150/0x150
[ 1778.522381][    C1]  ? down_trylock+0x88/0xc0
[ 1778.523413][    C1]  ? kmsg_dump+0x19d/0x210
[ 1778.524464][    C1]  ? atomic_notifier_call_chain+0xbd/0xf0
[ 1778.525818][    C1]  panic+0x75b/0x811
[ 1778.526771][    C1]  ? print_oops_end_marker.cold+0x15/0x15
[ 1778.528062][    C1]  ? __show_regs.cold+0x44c/0x57b
[ 1778.529262][    C1]  ? vprintk_func+0xb2/0x1d0
[ 1778.530310][    C1]  oops_end.cold+0xc/0x18
[ 1778.531309][    C1]  do_trap+0x1a5/0x260
[ 1778.532282][    C1]  ? skb_panic+0x171/0x183
[ 1778.533250][    C1]  do_error_trap+0x8a/0xf0
[ 1778.534272][    C1]  ? skb_panic+0x171/0x183
[ 1778.535423][    C1]  exc_invalid_op+0x4e/0x70
[ 1778.536537][    C1]  ? skb_panic+0x171/0x183
[ 1778.537605][    C1]  asm_exc_invalid_op+0x12/0x20
[ 1778.538580][    C1] RIP: 0010:skb_panic+0x171/0x183
[ 1778.539590][    C1] Code: f5 4c 8b 4c 24 10 41 56 8b 4b 70 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 a0 ae 2d 8e ff 74 24 10 ff 74 24 20 e8 0c 6d 62 ff <0f> 0b 48 c7 c7 a0 db 5d 92 48 83 c4 20 e8 7e 7a 6d ff e8 50 c0 5d
[ 1778.543875][    C1] RSP: 0018:ffff888134009a48 EFLAGS: 00010286
[ 1778.545337][    C1] RAX: 000000000000008a RBX: ffff88812885aa00 RCX: 0000000000000000
[ 1778.547205][    C1] RDX: 0000000000000000 RSI: ffffffff815fe682 RDI: ffffed102680133b
[ 1778.548991][    C1] RBP: ffffffff8e2db3e0 R08: 000000000000008a R09: ffffed10268012d2
[ 1778.551004][    C1] R10: ffff88813400968f R11: ffffed10268012d1 R12: ffffffff8acae9b4
[ 1778.553242][    C1] R13: 0000000000000028 R14: ffff888060ad6000 R15: 00000000000000c0
[ 1778.554779][    C1]  ? ip6_mc_hdr.isra.0.constprop.0+0x124/0x5a0
[ 1778.556491][    C1]  ? vprintk_func+0xb2/0x1d0
[ 1778.557538][    C1]  ? skb_panic+0x171/0x183
[ 1778.558413][    C1]  ? ip6_mc_hdr.isra.0.constprop.0+0x124/0x5a0
[ 1778.559619][    C1]  skb_put.cold+0x24/0x24
[ 1778.561447][    C1]  ip6_mc_hdr.isra.0.constprop.0+0x124/0x5a0
[ 1778.563045][    C1]  ? tcp_gro_receive+0xdd0/0xdd0
[ 1778.564144][    C1]  mld_newpack+0x38c/0x7a0
[ 1778.565266][    C1]  ? ip6_mc_hdr.isra.0.constprop.0+0x5a0/0x5a0
[ 1778.566675][    C1]  ? enqueue_entity+0xca2/0x3ab0
[ 1778.567892][    C1]  ? find_first_bit+0x6c/0x90
[ 1778.569147][    C1]  add_grhead.isra.0+0x2a6/0x380
[ 1778.570281][    C1]  add_grec+0xcdc/0xf70
[ 1778.571394][    C1]  ? add_grhead.isra.0+0x380/0x380
[ 1778.572655][    C1]  ? _raw_spin_lock_bh+0x85/0xe0
[ 1778.573758][    C1]  ? _raw_read_unlock_irqrestore+0x30/0x30
[ 1778.575413][    C1]  ? clear_posix_cputimers_work+0x90/0x90
[ 1778.576964][    C1]  ? perf_event_task_tick+0x804/0xd90
[ 1778.578290][    C1]  mld_ifc_timer_expire+0x34b/0x810
[ 1778.580459][    C1]  ? mld_send_initial_cr.part.0+0x150/0x150
[ 1778.583421][    C1]  call_timer_fn+0x3f/0x200
[ 1778.584651][    C1]  expire_timers+0x21c/0x3b0
[ 1778.586838][    C1]  ? mld_send_initial_cr.part.0+0x150/0x150
[ 1778.589528][    C1]  run_timer_softirq+0x2ad/0x7f0
[ 1778.591333][    C1]  ? expire_timers+0x3b0/0x3b0
[ 1778.593040][    C1]  ? ktime_get+0xd5/0x120
[ 1778.594181][    C1]  ? kvm_sched_clock_read+0xd/0x20
[ 1778.595540][    C1]  ? sched_clock+0x5/0x10
[ 1778.596695][    C1]  ? sched_clock_cpu+0x18/0x190
[ 1778.597983][    C1]  ? tick_program_event+0x7c/0x110
[ 1778.599609][    C1]  __do_softirq+0x19b/0x612
[ 1778.600949][    C1]  asm_call_irq_on_stack+0x12/0x20
[ 1778.602316][    C1]  </IRQ>
[ 1778.603094][    C1]  do_softirq_own_stack+0x37/0x50
[ 1778.604407][    C1]  irq_exit_rcu+0x1a2/0x240
[ 1778.605623][    C1]  sysvec_apic_timer_interrupt+0x36/0x80
[ 1778.607612][    C1]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 1778.609617][    C1] RIP: 0010:security_socket_create+0x35/0xc0
[ 1778.611229][    C1] Code: 56 41 89 f6 41 55 41 89 d5 41 54 41 89 cc 55 48 bd 00 00 00 00 00 fc ff df 53 48 83 ec 08 e8 d2 74 c5 fe 48 8b 1d fb fd 68 12 <48> 85 db 74 49 e8 c1 74 c5 fe 48 8d 7b 18 48 89 f8 48 c1 e8 03 80
[ 1778.617288][    C1] RSP: 0018:ffff8880608efdf0 EFLAGS: 00000216
[ 1778.618970][    C1] RAX: 0000000000040000 RBX: ffffffff8fe5f4f0 RCX: ffffc90006b18000
[ 1778.621507][    C1] RDX: 00000000000000f4 RSI: ffffffff82b08dae RDI: 0000000000000010
[ 1778.625961][    C1] RBP: dffffc0000000000 R08: ffff8880608efeb0 R09: 0000000000000000
[ 1778.628778][    C1] R10: ffffffff94f30687 R11: fffffbfff29e60d0 R12: 0000000000000000
[ 1778.630921][    C1] R13: 0000000000000010 R14: 0000000000000003 R15: 0000000000000010
[ 1778.633134][    C1]  ? security_socket_create+0x2e/0xc0
[ 1778.636572][    C1]  __sock_create+0x66/0x4a0
[ 1778.639473][    C1]  __sys_socket+0xe3/0x1d0
[ 1778.641563][    C1]  ? move_addr_to_kernel+0x60/0x60
[ 1778.644707][    C1]  ? exit_to_user_mode_prepare+0x24/0x150
[ 1778.646641][    C1]  __x64_sys_socket+0x74/0xb0
[ 1778.647942][    C1]  do_syscall_64+0x33/0x40
[ 1778.649407][    C1]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[ 1778.651355][    C1] RIP: 0033:0x7f11930d61eb
[ 1778.652974][    C1] Code: f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[ 1778.659704][    C1] RSP: 002b:00007f119161eb58 EFLAGS: 00000286 ORIG_RAX: 0000000000000029
[ 1778.662918][    C1] RAX: ffffffffffffffda RBX: 00007f119320f050 RCX: 00007f11930d61eb
[ 1778.665308][    C1] RDX: 0000000000000010 RSI: 0000000000000003 RDI: 0000000000000010
[ 1778.668092][    C1] RBP: 00007f1193140d75 R08: 0000000000000000 R09: 0000000000000000
[ 1778.670520][    C1] R10: 0000000020000280 R11: 0000000000000286 R12: 00000000ffffffff
[ 1778.672812][    C1] R13: 00007fff7153e8bf R14: 00007fff7153ea60 R15: 00007f119161fd80
[ 1778.675425][    C1] Kernel panic - not syncing: panic_on_warn set ...
[ 1778.676862][    C1] kernel fault(0x5) notification starting on CPU 1
[ 1778.679271][    C1] kernel fault(0x5) notification finished on CPU 1
[ 1778.682848][    C1] Kernel Offset: disabled
[ 1778.686107][    C1] kernel reboot(0x2) notification starting on CPU 1
[ 1778.689209][    C1] kernel reboot(0x2) notification finished on CPU 1
[ 1778.691073][    C1] Rebooting in 3 seconds..
[ 1782.003404][    C1] kernel reboot(0x5) notification starting on CPU 1
[ 1782.011818][    C1] kernel reboot(0x5) notification finished on CPU 1

VM DIAGNOSIS:
08:12:23  Registers:
info registers vcpu 0
RAX=1ffff11026621efc RBX=ffff88813310f7a8 RCX=ffff88813310f838 RDX=dffffc0000000000
RSI=ffff888134165100 RDI=ffff88813310f7a8 RBP=ffff88813310f6a0 RSP=ffff88813310f660
R8 =0000000000000001 R9 =ffff88813310f7a8 R10=ffff88813310f807 R11=ffffed1026621f00
R12=ffffed1026621ef7 R13=ffffed1026621ef6 R14=ffff88813310f7a8 R15=ffff88813310f7b0
RIP=ffffffff8136180a RFL=00000286 [--S--P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 0000555556ca6980 ffffffff 00c00000
GS =0000 ffff888019e00000 ffffffff 00c00000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe0000003000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 0000ffff
CR0=80050033 CR2=00007fff964d1cb8 CR3=0000000133104000 CR4=00150ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000a60ce07b00000000cec3662e XMM01=00000000000000003f0e3cf1ddeaf46c
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=000000000000000000000000000000ff XMM05=00000000000000000000000000000000
XMM06=0000000000000000000000524f525245 XMM07=00000000000000000000000000000000
XMM08=000000000000000000524f5252450040 XMM09=00000000000000000000000000000000
XMM10=00000000000000000000000000000000 XMM11=00000000000000000000000000000000
XMM12=00000000000000000000000000000000 XMM13=00000000000000000000000000000000
XMM14=00000000000000000000000000000000 XMM15=00000000000000000000000000000000
info registers vcpu 1
RAX=dffffc0000000060 RBX=00000000000003fd RCX=0000000000000000 RDX=00000000000003fd
RSI=ffffffff83444604 RDI=ffffffff95a09448 RBP=ffffffff95a09440 RSP=ffff8881340093b0
R8 =0000000000000001 R9 =ffffed1026801282 R10=0000000000000003 R11=ffffed1026801281
R12=0000000000000000 R13=fffffbfff2b412d3 R14=fffffbfff2b4128b R15=ffffffff95a09458
RIP=ffffffff8344462f RFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 00007f1191620700 ffffffff 00c00000
GS =0000 ffff888134000000 ffffffff 00c00000
LDT=0000 0000000000000000 00000000 00000000
TR =0040 fffffe000004a000 00000067 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000048000 0000007f
IDT=     fffffe0000000000 0000ffff
CR0=80050033 CR2=00007f119161ebd8 CR3=000000011f95e000 CR4=00150ee0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00007f11931e56c000007f11931e56a8 XMM03=00007f11931e56a000007f11931e56a0
XMM04=0000000000000000000000ff00000000 XMM05=00000000000000000000000000001000
XMM06=63e772d7f3a22482dabb339f3c035440 XMM07=bd0dad416e16bee646815929601aad29
XMM08=000000000000000000524f5252450040 XMM09=00000000000000000000000000000000
XMM10=00000000000000000000000000000000 XMM11=00000000000000000000000000000000
XMM12=00000000000000000000000000000000 XMM13=00000000000000000000000000000000
XMM14=00000000000000000000000000000000 XMM15=00000000000000000000000000000000
