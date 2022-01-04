Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBEE48412B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiADLtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiADLtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:49:04 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C935EC061761;
        Tue,  4 Jan 2022 03:49:03 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p15so56949984ybk.10;
        Tue, 04 Jan 2022 03:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aKx3+tDPcj0JF44p7/MvIZ+G++iiA8Hgo2dF/3xk24k=;
        b=kwAdwg2pdZxRi0A6vSRDtSWR8w8ErXepolc7pgl3HRBrv6RBIvpNIPO08Y8SSxYcrQ
         QWr2KTK9V7K1SvGKdVsk2TbUkWkINo9cpt0LFtseRlqoardlCZuhFFsuciUsTVCRBZ4M
         bYQlgL1k6z0ttq258GKZbfSPO9QVWxklLMb/GirQ74wx9DF7MmjrBpavufd6AQ5bbGeu
         LCZuuYLRimgQU5xQT0VXVjBBD9HFvDSDazYhW+uNK0/OU1R16rZK9fLRaBbDU+hplyYd
         ZfKeLkrnhpvysy5Di6vijDAohR0tBlRJCZkvinl/jkP2fW3A1+E5O/MQ5XcLLx81B5j/
         /X1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aKx3+tDPcj0JF44p7/MvIZ+G++iiA8Hgo2dF/3xk24k=;
        b=jeFc/2i2YlBGsQzH4zxTslhUxXArJmr/RrP23ro5mLXTk3OGmsHDq2NzYTuPlejM3i
         GFmM01PRa8uhHeW/h6tpmIx2IOrUplRe9RfIBorJCCYYGb8tdscHpRt6B37lWDrX9pVP
         kleOhpZvJwqR2B8vLtLKTJYxCfLRlZ7a81nxfxtHDfnJjpZakwGJ+kqyLvzYQ5/WYIv9
         2SxTv06DK5grhxbLoBh+ULH+oAM3VZBKbaGCrL+JP9q3gMcil0KNJIbF9AeJkbKZrGGP
         NINhCCV7m944NMol4GVJQYs2688Prcy6rcBod0yzHStsbiNFF5X9ISzvDx8gj57GP4rk
         pNFQ==
X-Gm-Message-State: AOAM530LqhXcW2dv/XEsSJC4xXH0afUmuGlcsumVCbcQ6iqMLO4rg0k5
        Kl+x7Y1Mk9XstwwtorcmYUYyyf6MFm+C5A8U04E=
X-Google-Smtp-Source: ABdhPJyR7/GLWvw9QFOzCFVQP1WenrmDNVj+rySOayu3zzHV7DbySbQJdeTzC+Q/RY18bDlI2lmm+U1G+1rX3edABI0=
X-Received: by 2002:a25:da0e:: with SMTP id n14mr51428336ybf.35.1641296943059;
 Tue, 04 Jan 2022 03:49:03 -0800 (PST)
MIME-Version: 1.0
From:   kvartet <xyru1999@gmail.com>
Date:   Tue, 4 Jan 2022 19:48:52 +0800
Message-ID: <CAFkrUsi8CXPZZ4=iRn2HsH7a86PfcuHCBuD3hsLW2jWP2PS=aQ@mail.gmail.com>
Subject: INFO: rcu detected stall in batadv_purge_orig
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Syzkaller to fuzz the latest Linux kernel, the following
crash was triggered.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output: https://paste.ubuntu.com/p/V4fvMdr76R/plain/
kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.

If you fix this issue, please add the following tag to the commit:
Reported-by: Yiru Xu <xyru1999@gmail.com>


rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
(detected by 1, t=10502 jiffies, g=150425, q=70254)
rcu: All QSes seen, last rcu_preempt kthread activity 10500
(4295046532-4295036032), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies!
g150425 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
rcu: Possible timer handling issue on cpu=3 timer-softirq=70438
rcu: rcu_preempt kthread starved for 10500 jiffies! g150425 f0x2
RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=3
rcu: Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R stack:28416 pid:   16 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_timeout+0x4ce/0x890 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x4a1/0x860 kernel/rcu/tree.c:1955
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2128
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 3:
NMI backtrace for cpu 3
CPU: 3 PID: 8 Comm: kworker/u8:0 Not tainted 5.16.0-rc6 #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: bat_events batadv_purge_orig
RIP: 0010:kvm_wait+0xb3/0x110 arch/x86/kernel/kvm.c:1001
Code: 40 38 c6 74 1b 48 83 c4 10 c3 c3 e8 f7 f4 49 00 eb 07 0f 00 2d
be 8a 75 08 fb f4 48 83 c4 10 c3 eb 07 0f 00 2d ae 8a 75 08 f4 <48> 83
c4 10 c3 89 74 24 0c 48 89 3c 24 e8 1b f3 49 00 8b 74 24 0c
RSP: 0018:ffffc900008a0b58 EFLAGS: 00000046
RAX: 0000000000000003 RBX: 0000000000000000 RCX: ffffffff815cf9a9
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff888018e80338
RBP: ffff888018e80338 R08: 0000000000000004 R09: ffffed10031d0068
R10: ffff888018e80338 R11: ffffed10031d0067 R12: 0000000000000000
R13: ffffed10031d0067 R14: 0000000000000001 R15: ffff888135d3a880
FS:  0000000000000000(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00062055c CR3: 0000000017e2c000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 pv_wait arch/x86/include/asm/paravirt.h:603 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x923/0xb80 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:591 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x204/0x2d0 kernel/locking/spinlock_debug.c:115
 spin_lock include/linux/spinlock.h:349 [inline]
 drm_handle_vblank+0x126/0xc70 drivers/gpu/drm/drm_vblank.c:1951
 vkms_vblank_simulate+0xd0/0x3c0 drivers/gpu/drm/vkms/vkms_crtc.c:29
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1b8/0xdf0 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__local_bh_enable_ip+0xa8/0x110 kernel/softirq.c:390
Code: 1d 2d 86 bb 7e 65 8b 05 26 86 bb 7e a9 00 ff ff 00 74 45 bf 01
00 00 00 e8 95 54 09 00 e8 e0 96 36 00 fb 65 8b 05 08 86 bb 7e <85> c0
74 4a 5b 5d c3 65 8b 05 56 8d bb 7e 85 c0 75 a2 0f 0b eb 9e
RSP: 0018:ffffc900006b7c00 EFLAGS: 00000206
RAX: 0000000080000000 RBX: 00000000fffffe00 RCX: 1ffffffff1ff8f0e
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff88e0aba3 R08: 0000000000000001 R09: fffffbfff1fee145
R10: 0000000000000001 R11: fffffbfff1fee144 R12: ffff888024e64ac8
R13: ffff8880183d4dd0 R14: 0000000000000159 R15: ffff888010c71800
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 batadv_purge_orig_ref+0xe43/0x1500 net/batman-adv/originator.c:1259
 batadv_purge_orig+0x17/0x60 net/batman-adv/originator.c:1272
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2298
 worker_thread+0x90/0xed0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0: 40 38 c6              cmp    %al,%sil
   3: 74 1b                je     0x20
   5: 48 83 c4 10          add    $0x10,%rsp
   9: c3                    retq
   a: c3                    retq
   b: e8 f7 f4 49 00        callq  0x49f507
  10: eb 07                jmp    0x19
  12: 0f 00 2d be 8a 75 08 verw   0x8758abe(%rip)        # 0x8758ad7
  19: fb                    sti
  1a: f4                    hlt
  1b: 48 83 c4 10          add    $0x10,%rsp
  1f: c3                    retq
  20: eb 07                jmp    0x29
  22: 0f 00 2d ae 8a 75 08 verw   0x8758aae(%rip)        # 0x8758ad7
  29: f4                    hlt
* 2a: 48 83 c4 10          add    $0x10,%rsp <-- trapping instruction
  2e: c3                    retq
  2f: 89 74 24 0c          mov    %esi,0xc(%rsp)
  33: 48 89 3c 24          mov    %rdi,(%rsp)
  37: e8 1b f3 49 00        callq  0x49f357
  3c: 8b 74 24 0c          mov    0xc(%rsp),%esi



Best Regards,
Yiru
