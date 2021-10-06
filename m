Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F404239B6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhJFI0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbhJFI0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:26:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE34AC061749;
        Wed,  6 Oct 2021 01:24:44 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m5so1708023pfk.7;
        Wed, 06 Oct 2021 01:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=F5bZ0nTv6mDljUpG134jWYJCyXKp//Ue/TWHZ2TtjH4=;
        b=g8qYfQNIedQRfw2jjjtzx27zLwxe492lIcMcopTdj8/sd9Fo+Wn1zUIBJRcic5Bjfi
         /QZdFHP5fC943kt3xD0rv4TsF0VPfzlFKkVjkqGHVbO0Cdm2JdujusGBCL7tspZ13ZUS
         zgajJ+GxHKnzoY/2exBGV1lTlrtrQiajjnIu78k94lSyyN97Klm1m84+31Y/gc67d4Cb
         Bv1eKBLXUAh2kokU0AI2Qd0nov0i1GR+fHGEsWY/L8l/BSkFiH/OzbvFrGMDQSIVJWvQ
         mXsnqq72dsVNoVaQdLiHzPyV3/FZoNqKMRUHN+8/Tkwdto/Fl3qkxl7BbJTKScc6hQbH
         IJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=F5bZ0nTv6mDljUpG134jWYJCyXKp//Ue/TWHZ2TtjH4=;
        b=SYImkZhZ5E2HoHLBqslQiIyJcCnbnwBsGnmbmLdIu9VXVQsL8ObI6NjU/Wf1a0JX6i
         S9OZwIoBToVVh9Hs6Ho4FC/4mka/HpxNmJ3P3n/ZSvW69jYC5HAGVRh0pQhceDI29MTY
         RXCvMNMUw1kNYqZxsr7nsTLFW17OYmW0NPlv1wbsl5pldmJiwdEjT4OwXWrEU9rtsR7a
         75Vzo1HVtSVqRbqGo5NFdOIsak2chGuRrn/X7jLXBzxd5ZuSKFMA6dmon98E1F7rHhU6
         Nq7uobPGAJ4fisFVyXl02YwIQ4xyrELvaCII2A+hhY6ptJ9vUGCmP61zirKEqTiBDACA
         fLLw==
X-Gm-Message-State: AOAM531nzE9M7hDTOMYpxnE23DkUOlAGETM6h89KjKkkP7kWms3MfZCb
        UIVavNC9XfPasdK6mKBOdNPEghcMGMlcKencQ5Zman9meQL8em8=
X-Google-Smtp-Source: ABdhPJw8XzX9cjksX5S8vTNDLqyu8hKcCghUt4YgNMp3pThk2jjdfnBnkW7+EIxnzW37uf5Brg5T3xwCtYMuvp9K5fo=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr19192079pgd.381.1633508684037;
 Wed, 06 Oct 2021 01:24:44 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 6 Oct 2021 16:24:33 +0800
Message-ID: <CACkBjsZ42Of+9Y6dJKo_d9U_Y1YA4ByCaxZF2tMuAS00ESAjYA@mail.gmail.com>
Subject: INFO: rcu detected stall in mld_ifc_work
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org, airlied@linux.ie,
        rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
        hamohammed.sa@gmail.com, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 0513e464f900 Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27'
git tree: upstream
console output:
https://drive.google.com/file/d/1xw1nX3KSXOI0GzbKjGw5c0C14We3e0R3/view?usp=sharing
kernel config: https://drive.google.com/file/d/1Jqhc4DpCVE8X7d-XBdQnrMoQzifTG5ho/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 1-....: (1 ticks this GP) idle=e03/1/0x4000000000000000
softirq=19163/19163 fqs=3
(detected by 0, t=10635 jiffies, g=32217, q=314)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 11958 Comm: kworker/1:5 Not tainted 5.15.0-rc3+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: mld mld_ifc_work
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:1874 [inline]
RIP: 0010:vprintk_emit+0x1c3/0x340 kernel/printk/printk.c:2243
Code: 0f 2d 81 31 f6 41 b8 01 00 00 00 48 c7 c7 c0 9d 93 85 e8 30 9e
fe ff 0f b6 05 d1 a1 3a 07 5a 84 c0 74 10 e8 5f 81 0a 00 f3 90 <41> 0f
b6 04 24 84 c0 75 f0 e8 4f 81 0a 00 48 c7 c6 0c 10 2d 81 48
RSP: 0018:ffffc90000708e18 EFLAGS: 00010046
RAX: 0000000000010001 RBX: 000000000000002a RCX: 0000000000000000
RDX: ffff888104d7a280 RSI: ffffffff812d1001 RDI: ffffffff853ccbb6
RBP: ffffc90000708e50 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc90000708ce0 R11: 0000000000000005 R12: ffffffff8867b1c8
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90000708e78
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f404556e4a0 CR3: 000000010f89d000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 vprintk+0x65/0x80 kernel/printk/printk_safe.c:50
 _printk+0x5e/0x7d kernel/printk/printk.c:2265
 vkms_vblank_simulate+0x187/0x190 drivers/gpu/drm/vkms/vkms_crtc.c:26
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0xb8/0x610 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0xfe/0x280 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x9c/0x2c0 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x99/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:ip6mr_get_table net/ipv6/ip6mr.c:126 [inline]
RIP: 0010:ip6mr_rule_action+0x78/0xe0 net/ipv6/ip6mr.c:173
Code: 5e e8 8c ee 7e fd 45 89 66 20 48 8b 6d 40 4d 8b 6e 10 48 8b 9d
88 0b 00 00 48 81 c5 88 0b 00 00 48 39 dd 74 25 e8 68 ee 7e fd <44> 3b
63 28 75 0d eb 38 e8 5b ee 7e fd 44 39 63 28 74 2d e8 50 ee
RSP: 0018:ffffc900036efa50 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888010f38000 RCX: 0000000000000000
RDX: ffff888104d7a280 RSI: ffffffff83b8a2f8 RDI: ffff88800fa94300
RBP: ffff888015ee3e08 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900036ef948 R11: 0000000000000004 R12: 00000000000000fe
R13: ffffc900036efad0 R14: ffffc900036efad8 R15: ffffc900036efad8
 fib_rules_lookup+0x2ba/0x460 net/core/fib_rules.c:318
 ip6mr_fib_lookup+0x77/0xc0 net/ipv6/ip6mr.c:145
 mroute6_is_socket+0x7b/0xc0 net/ipv6/ip6mr.c:1617
 ip6_finish_output2+0x60c/0xcc0 net/ipv6/ip6_output.c:83
 __ip6_finish_output+0x143/0x520 net/ipv6/ip6_output.c:191
 ip6_finish_output+0x30/0x110 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0xa8/0x3a0 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 mld_sendpack+0x231/0x4a0 net/ipv6/mcast.c:1826
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_ifc_work+0x2f9/0x5d0 net/ipv6/mcast.c:2659
 process_one_work+0x359/0x850 kernel/workqueue.c:2297
 worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
NMI backtrace for cpu 3 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 3 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 3 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 0
CPU: 0 PID: 1284 Comm: kworker/u9:4 Not tainted 5.15.0-rc3+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
Code: 7e 31 c0 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 40 70 01 00 48
8b 80 28 15 00 00 c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 <65> 8b
05 99 de c9 7e 89 c1 48 8b 34 24 65 48 8b 14 25 40 70 01 00
RSP: 0018:ffffc90005c67c78 EFLAGS: 00000202
RAX: 0000000000000011 RBX: ffff88813dc2f9c0 RCX: 0000000000000000
RDX: ffff88800d8bc500 RSI: ffffffff8132ec00 RDI: 00000000ffffffff
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: ffffc90005c67c28 R11: 0000000000000005 R12: ffff88807dc2a900
R13: ffff88807dc2a908 R14: ffffffff85a27660 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbc80015228 CR3: 000000000588a000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 rep_nop arch/x86/include/asm/vdso/processor.h:13 [inline]
 cpu_relax arch/x86/include/asm/vdso/processor.h:18 [inline]
 csd_lock_wait kernel/smp.c:440 [inline]
 smp_call_function_many_cond+0x1d0/0x550 kernel/smp.c:969
 on_each_cpu_cond_mask+0x48/0x90 kernel/smp.c:1135
 on_each_cpu include/linux/smp.h:71 [inline]
 text_poke_sync arch/x86/kernel/alternative.c:929 [inline]
 text_poke_bp_batch+0x255/0x2c0 arch/x86/kernel/alternative.c:1183
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0xbc/0x190 kernel/jump_label.c:830
 static_key_enable_cpuslocked+0x77/0xb0 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate+0x71/0x240 mm/kfence/core.c:626
 process_one_work+0x359/0x850 kernel/workqueue.c:2297
 worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
NMI backtrace for cpu 1
CPU: 1 PID: 7811 Comm: kworker/u8:4 Not tainted 5.15.0-rc3+ #21
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:neigh_flush_dev+0xd1/0x360 net/core/neighbour.c:307
Code: 00 85 c0 0f 84 55 01 00 00 e8 db c7 c9 fd 48 8b 5d 00 48 85 db
0f 84 9d 01 00 00 e8 c9 c7 c9 fd 4d 85 f6 74 18 e8 bf c7 c9 fd <4c> 39
b3 f8 02 00 00 74 0a e8 b1 c7 c9 fd 48 89 dd eb b2 e8 a7 c7
RSP: 0018:ffffc90001e07b68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8881000bec00 RCX: 0000000000000000
RDX: ffff88810bd4c500 RSI: ffffffff836dc9a1 RDI: ffffffff853ccbb6
RBP: ffff88811289c2b0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffc90001e07aa8 R11: 0000000000000005 R12: ffff88800e677000
R13: ffffffff85edcbf0 R14: ffff88800e677000 R15: ffffffff85edc960
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcb831b5000 CR3: 000000010738c000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 __neigh_ifdown+0x42/0x180 net/core/neighbour.c:358
 neigh_ifdown+0x1a/0x20 net/core/neighbour.c:375
 ndisc_netdev_event+0x211/0x380 net/ipv6/ndisc.c:1820
 notifier_call_chain+0x3b/0xc0 kernel/notifier.c:83
 call_netdevice_notifiers_info+0x58/0xa0 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 dev_close_many+0x116/0x180 net/core/dev.c:1597
 unregister_netdevice_many+0x1c8/0x8f0 net/core/dev.c:11020
 default_device_exit_batch+0x196/0x1c0 net/core/dev.c:11573
 ops_exit_list.isra.8+0x73/0x80 net/core/net_namespace.c:171
 cleanup_net+0x2e6/0x4e0 net/core/net_namespace.c:591
 process_one_work+0x359/0x850 kernel/workqueue.c:2297
 worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
vkms_vblank_simulate: vblank timer overrun
vkms_vblank_simulate: vblank timer overrun
----------------
Code disassembly (best guess):
   0: 0f 2d 81 31 f6 41 b8 cvtps2pi -0x47be09cf(%rcx),%mm0
   7: 01 00                add    %eax,(%rax)
   9: 00 00                add    %al,(%rax)
   b: 48 c7 c7 c0 9d 93 85 mov    $0xffffffff85939dc0,%rdi
  12: e8 30 9e fe ff        callq  0xfffe9e47
  17: 0f b6 05 d1 a1 3a 07 movzbl 0x73aa1d1(%rip),%eax        # 0x73aa1ef
  1e: 5a                    pop    %rdx
  1f: 84 c0                test   %al,%al
  21: 74 10                je     0x33
  23: e8 5f 81 0a 00        callq  0xa8187
  28: f3 90                pause
* 2a: 41 0f b6 04 24        movzbl (%r12),%eax <-- trapping instruction
  2f: 84 c0                test   %al,%al
  31: 75 f0                jne    0x23
  33: e8 4f 81 0a 00        callq  0xa8187
  38: 48 c7 c6 0c 10 2d 81 mov    $0xffffffff812d100c,%rsi
  3f: 48                    rex.W
