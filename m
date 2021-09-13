Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1824082E3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 04:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhIMCki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 22:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbhIMCkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 22:40:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903F9C061574;
        Sun, 12 Sep 2021 19:39:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q22so7470039pfu.0;
        Sun, 12 Sep 2021 19:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GFHCz/WYhWjJ1sEcxMuV5/OqqXBGyppfPAvgnyAN3Eg=;
        b=De58Cm8gXLXTknhGTbNogM96lO5T9tVsvpIF3wMv91mr1m7bArmD1g/Wx1gpzus7bv
         Bix1pb4U4mJg6Nevod6eoCko+oPbZOywVRzVa9x95Hj+gy3XLdhL064TMgbANVx5/fvB
         BFa2ntcTFSDSwy+byBsp2ABB2QqYAAtx9cA9whDhGWxMYL5OBwCzxDYbW2H4gUvGKpKx
         W4x0IgWDDvXHUtxjeYt8Ljwr/CLgzm+HlchaWPe6o8xz/tvvHOIsF7A4VbPszl8yLlko
         VP2KcoajTVCTl0dQ1D8WswfJ8TKv02lQALpw+LK7ZaiQwRo8ZyKx78X9Z0HpVyfn5ufk
         p17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GFHCz/WYhWjJ1sEcxMuV5/OqqXBGyppfPAvgnyAN3Eg=;
        b=mtlDtuFnEIT5gsW3B7CTu4KkQueBPHXQdJHOdccbBBMzdvoWrYQ0T3yvpBtmm4hMd9
         ZgPMfs8lY9SRXY/PLScwZtxiA7VF0rpVT80WP7YIfJj6FSeSwRNdiM9te1lzUUmmzRhj
         dGNjIblVdwTHgSQLoVk09ltSUcz8EtHJgo3OO5wmLV0Q+8aBjKyw+OzJ7ym5FFA7Cf+m
         MRLERMPcU0LOB2fpBojjZwUPcoDjFWupzhmpOQp4D+mMq0GgFVP4/Scic5GClVqoM9M4
         8/2WTN3TijxXEwtpUamQ8n1uKjc2DAiYqayBbKEkB0efL6NsQT5A8G+Lcfrfi4kK3/WT
         yIAQ==
X-Gm-Message-State: AOAM530dXRWp1sYP/6r8NygGsj4rK1wD0e+X+ci8JXvdTruNaEIPPB2N
        UoZxvfPYY7HP8YqIzJRQelhyxjrbN3JO0NLPBg==
X-Google-Smtp-Source: ABdhPJykteJK8BxJ+OcH5Y9mfZMR06f2OuXk/IY8vLVvHPbKzqgpwfkt/zLcRaF1rki2FDIjVTxrpIuSBU5ReZseWL4=
X-Received: by 2002:a65:6389:: with SMTP id h9mr9133374pgv.83.1631500761807;
 Sun, 12 Sep 2021 19:39:21 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Mon, 13 Sep 2021 10:39:10 +0800
Message-ID: <CACkBjsYnr4_uucVqvBpfDAgcnQqA6oneD1mHYe-TcLtDxuUs2A@mail.gmail.com>
Subject: possible deadlock in __perf_event_task_sched_out
To:     acme@kernel.org, linux-perf-users@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org
Cc:     alexander.shishkin@linux.intel.com, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, jolsa@redhat.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, namhyung@kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
git tree: upstream
console output:
https://drive.google.com/file/d/1Gy99NMo9JxZF6dHPdxnnb91n_jPJUQnA/view?usp=sharing
kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 __perf_install_in_context+0x68e/0x9f0 kernel/events/core.c:2817
 remote_function kernel/events/core.c:91 [inline]
 remote_function+0x115/0x1a0 kernel/events/core.c:71
 generic_exec_single kernel/smp.c:518 [inline]
 generic_exec_single+0x1fe/0x300 kernel/smp.c:504
 smp_call_function_single+0x186/0x4b0 kernel/smp.c:755
 task_function_call+0xd9/0x160 kernel/events/core.c:119
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
 __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21c58 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: fbffffffffffffff RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00000000004ebd80 R08: 0000000000000009 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0

======================================================
WARNING: possible circular locking dependency detected
5.14.0+ #1 Not tainted
------------------------------------------------------
syz-executor/9146 is trying to acquire lock:
ffff88801d635420 (&ctx->lock){....}-{2:2}, at:
perf_event_context_sched_out kernel/events/core.c:3489 [inline]
ffff88801d635420 (&ctx->lock){....}-{2:2}, at:
__perf_event_task_sched_out+0x6e8/0x18d0 kernel/events/core.c:3597

but task is already holding lock:
ffff888063e319d8 (&rq->__lock){-.-.}-{2:2}, at:
raw_spin_rq_lock_nested+0x1e/0x30 kernel/sched/core.c:474

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&rq->__lock){-.-.}-{2:2}:
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
       _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:368
       raw_spin_rq_lock_nested+0x1e/0x30 kernel/sched/core.c:474
       raw_spin_rq_lock kernel/sched/sched.h:1317 [inline]
       rq_lock kernel/sched/sched.h:1620 [inline]
       task_fork_fair+0x76/0x4e0 kernel/sched/fair.c:11091
       sched_fork+0x406/0x990 kernel/sched/core.c:4393
       copy_process+0x2002/0x73d0 kernel/fork.c:2165
       kernel_clone+0xe7/0x10d0 kernel/fork.c:2585
       kernel_thread+0xb5/0xf0 kernel/fork.c:2637
       rest_init+0x23/0x3e0 init/main.c:684
       start_kernel+0x47a/0x49b init/main.c:1125
       secondary_startup_64_no_verify+0xb0/0xbb

-> #2 (&p->pi_lock){-.-.}-{2:2}:
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       try_to_wake_up+0xab/0x1880 kernel/sched/core.c:3981
       up+0x92/0xe0 kernel/locking/semaphore.c:190
       __up_console_sem+0xa4/0xc0 kernel/printk/printk.c:254
       console_unlock+0x567/0xb40 kernel/printk/printk.c:2726
       vga_remove_vgacon drivers/gpu/vga/vgaarb.c:211 [inline]
       vga_remove_vgacon.cold+0x99/0x9e drivers/gpu/vga/vgaarb.c:192
       drm_aperture_remove_conflicting_pci_framebuffers+0x1e8/0x2c0
drivers/gpu/drm/drm_aperture.c:350
       bochs_pci_probe+0x118/0x890 drivers/gpu/drm/tiny/bochs.c:643
       local_pci_probe+0xdb/0x190 drivers/pci/pci-driver.c:323
       pci_call_probe drivers/pci/pci-driver.c:380 [inline]
       __pci_device_probe drivers/pci/pci-driver.c:405 [inline]
       pci_device_probe+0x3e6/0x6f0 drivers/pci/pci-driver.c:448
       call_driver_probe drivers/base/dd.c:517 [inline]
       really_probe drivers/base/dd.c:596 [inline]
       really_probe+0x245/0xbd0 drivers/base/dd.c:541
       __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
       driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
       __driver_attach+0x1d6/0x3b0 drivers/base/dd.c:1140
       bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
       bus_add_driver+0x41d/0x630 drivers/base/bus.c:618
       driver_register+0x1c4/0x330 drivers/base/driver.c:171
       bochs_init+0x78/0x86 drivers/gpu/drm/tiny/bochs.c:720
       do_one_initcall+0x103/0x650 init/main.c:1287
       do_initcall_level init/main.c:1360 [inline]
       do_initcalls init/main.c:1376 [inline]
       do_basic_setup init/main.c:1396 [inline]
       kernel_init_freeable+0x6ca/0x753 init/main.c:1598
       kernel_init+0x1a/0x1d0 init/main.c:1490
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #1 ((console_sem).lock){....}-{2:2}:
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
       down_trylock+0xe/0x60 kernel/locking/semaphore.c:138
       __down_trylock_console_sem+0x40/0x120 kernel/printk/printk.c:237
       console_trylock+0x12/0x90 kernel/printk/printk.c:2541
       console_trylock_spinning kernel/printk/printk.c:1843 [inline]
       vprintk_emit+0x141/0x4a0 kernel/printk/printk.c:2243
       vprintk+0x80/0x90 kernel/printk/printk_safe.c:50
       _printk+0xba/0xed kernel/printk/printk.c:2265
       show_trace_log_lvl+0x57/0x2bb arch/x86/kernel/dumpstack.c:195
       ex_handler_wrmsr_unsafe+0x47/0xc0 arch/x86/mm/extable.c:121
       fixup_exception+0x9a/0xd0 arch/x86/mm/extable.c:183
       __exc_general_protection arch/x86/kernel/traps.c:567 [inline]
       exc_general_protection+0xed/0x2f0 arch/x86/kernel/traps.c:531
       asm_exc_general_protection+0x1e/0x30 arch/x86/include/asm/idtentry.h:562
       wrmsrl arch/x86/include/asm/msr.h:281 [inline]
       __x86_pmu_enable_event arch/x86/events/perf_event.h:1118 [inline]
       x86_pmu_enable_all+0x16d/0x3f0 arch/x86/events/core.c:741
       x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
       perf_pmu_enable kernel/events/core.c:1207 [inline]
       perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
       __perf_install_in_context+0x68e/0x9f0 kernel/events/core.c:2817
       remote_function kernel/events/core.c:91 [inline]
       remote_function+0x115/0x1a0 kernel/events/core.c:71
       generic_exec_single kernel/smp.c:518 [inline]
       generic_exec_single+0x1fe/0x300 kernel/smp.c:504
       smp_call_function_single+0x186/0x4b0 kernel/smp.c:755
       task_function_call+0xd9/0x160 kernel/events/core.c:119
       perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
       __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&ctx->lock){....}-{2:2}:
       check_prev_add+0x165/0x24f0 kernel/locking/lockdep.c:3051
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2e03/0x57e0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
       perf_event_context_sched_out kernel/events/core.c:3489 [inline]
       __perf_event_task_sched_out+0x6e8/0x18d0 kernel/events/core.c:3597
       perf_event_task_sched_out include/linux/perf_event.h:1229 [inline]
       prepare_task_switch kernel/sched/core.c:4744 [inline]
       context_switch kernel/sched/core.c:4892 [inline]
       __schedule+0xf77/0x2530 kernel/sched/core.c:6287
       preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:6459
       preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
       smp_call_function_single+0x41d/0x4b0 kernel/smp.c:760
       task_function_call+0xd9/0x160 kernel/events/core.c:119
       perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
       __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  &ctx->lock --> &p->pi_lock --> &rq->__lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rq->__lock);
                               lock(&p->pi_lock);
                               lock(&rq->__lock);
  lock(&ctx->lock);

 *** DEADLOCK ***

3 locks held by syz-executor/9146:
 #0: ffff888017919fd8 (&sig->exec_update_lock){++++}-{3:3}, at:
__do_sys_perf_event_open+0xf84/0x2de0 kernel/events/core.c:12193
 #1: ffff88801d6354b0 (&ctx->mutex){+.+.}-{3:3}, at:
__do_sys_perf_event_open+0x17de/0x2de0 kernel/events/core.c:12247
 #2: ffff888063e319d8 (&rq->__lock){-.-.}-{2:2}, at:
raw_spin_rq_lock_nested+0x1e/0x30 kernel/sched/core.c:474

stack backtrace:
CPU: 0 PID: 9146 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x26b/0x310 kernel/locking/lockdep.c:2131
 check_prev_add+0x165/0x24f0 kernel/locking/lockdep.c:3051
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2e03/0x57e0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 perf_event_context_sched_out kernel/events/core.c:3489 [inline]
 __perf_event_task_sched_out+0x6e8/0x18d0 kernel/events/core.c:3597
 perf_event_task_sched_out include/linux/perf_event.h:1229 [inline]
 prepare_task_switch kernel/sched/core.c:4744 [inline]
 context_switch kernel/sched/core.c:4892 [inline]
 __schedule+0xf77/0x2530 kernel/sched/core.c:6287
 preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:6459
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 smp_call_function_single+0x41d/0x4b0 kernel/smp.c:760
 task_function_call+0xd9/0x160 kernel/events/core.c:119
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
 __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21c58 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: fbffffffffffffff RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00000000004ebd80 R08: 0000000000000009 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:6459
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 smp_call_function_single+0x41d/0x4b0 kernel/smp.c:760
 task_function_call+0xd9/0x160 kernel/events/core.c:119
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
 __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21c58 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: fbffffffffffffff RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00000000004ebd80 R08: 0000000000000009 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:6459
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 smp_call_function_single+0x41d/0x4b0 kernel/smp.c:760
 task_function_call+0xd9/0x160 kernel/events/core.c:119
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
 __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21c58 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: fbffffffffffffff RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00000000004ebd80 R08: 0000000000000009 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 preempt_schedule_common+0x4a/0xc0 kernel/sched/core.c:6459
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 smp_call_function_single+0x41d/0x4b0 kernel/smp.c:760
 task_function_call+0xd9/0x160 kernel/events/core.c:119
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2918
 __do_sys_perf_event_open+0x1c7c/0x2de0 kernel/events/core.c:12353
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21c58 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: fbffffffffffffff RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00000000004ebd80 R08: 0000000000000009 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 freezable_schedule include/linux/freezer.h:172 [inline]
 futex_wait_queue_me+0x25a/0x520 kernel/futex.c:2821
 futex_wait+0x1e3/0x5f0 kernel/futex.c:2922
 do_futex+0x26e/0x18e0 kernel/futex.c:3932
 __do_sys_futex kernel/futex.c:4009 [inline]
 __se_sys_futex kernel/futex.c:3990 [inline]
 __x64_sys_futex+0x1b0/0x4d0 kernel/futex.c:3990
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21cd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 freezable_schedule include/linux/freezer.h:172 [inline]
 futex_wait_queue_me+0x25a/0x520 kernel/futex.c:2821
 futex_wait+0x1e3/0x5f0 kernel/futex.c:2922
 do_futex+0x26e/0x18e0 kernel/futex.c:3932
 __do_sys_futex kernel/futex.c:4009 [inline]
 __se_sys_futex kernel/futex.c:3990 [inline]
 __x64_sys_futex+0x1b0/0x4d0 kernel/futex.c:3990
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21cd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 freezable_schedule include/linux/freezer.h:172 [inline]
 futex_wait_queue_me+0x25a/0x520 kernel/futex.c:2821
 futex_wait+0x1e3/0x5f0 kernel/futex.c:2922
 do_futex+0x26e/0x18e0 kernel/futex.c:3932
 __do_sys_futex kernel/futex.c:4009 [inline]
 __se_sys_futex kernel/futex.c:3990 [inline]
 __x64_sys_futex+0x1b0/0x4d0 kernel/futex.c:3990
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5e3f21cd8 EFLAGS: 00000246
 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffcc97e6abf R14: 00007ffcc97e6c60 R15: 00007fb5e3f21dc0
Call Trace:
 x86_pmu_enable+0x453/0xd50 arch/x86/events/core.c:1346
 perf_pmu_enable kernel/events/core.c:1207 [inline]
 perf_pmu_enable+0xcf/0x120 kernel/events/core.c:1203
 perf_event_context_sched_in kernel/events/core.c:3865 [inline]
 __perf_event_task_sched_in+0x64e/0x900 kernel/events/core.c:3903
 perf_event_task_sched_in include/linux/perf_event.h:1206 [inline]
 finish_task_switch+0x297/0x820 kernel/sched/core.c:4809
 context_switch kernel/sched/core.c:4943 [inline]
 __schedule+0xce1/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 freezable_schedule include/linux/freezer.h:172 [inline]
 futex_wait_queue_me+0x25a/0x520 kernel/futex.c:2821
 futex_wait+0x1e3/0x5f0 kernel/futex.c:2922
 do_futex+0x26e/0x18e0 kernel/futex.c:3932
