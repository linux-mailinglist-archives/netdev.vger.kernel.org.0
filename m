Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0623A69CC78
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 14:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjBTNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 08:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbjBTNki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 08:40:38 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400551C7E2
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 05:40:36 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id o14so946658vkf.12
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 05:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uci-edu.20210112.gappssmtp.com; s=20210112; t=1676900435;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1Ya9VJkNMLV6sraHQUFCjzra7r4hT2/y6zdPI830Kus=;
        b=dW/WctZ0H+aPaO3yjozxOSOVSzOE48uj4Iq5OeoLhSdTBVXEQZ1Z7GUPrytIhheT3l
         VF1OpYTE9m6BFleSyQEHakEwlVbXDY9q85ARpkhjHAz4OX058iZF8p1geCu6eGzawVFi
         sigWuZIDng52NR8Asupql4frjnC7ibGRSzojRpH6gkL911Nh1QgfwPrHvklJ49+8afJq
         YompZhqJW+i24Om7XXMFMM6jK0YEBWyrfkoeHKvYQW9kULifzycKzNtoKkV1SxLOyyvY
         NKxh3q0u8X83eI7ZY5uKdpuJA6cLnsF3ggVCFr0SBUsEz+V30Zra2rLilPiOjN1U1GEX
         R5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676900435;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Ya9VJkNMLV6sraHQUFCjzra7r4hT2/y6zdPI830Kus=;
        b=3Z5pMrVyQoDOlzHh5YVSPE28qSV6anbvgFYmh/1GAjqDjgJuIpVZ0BzSax0SvqpwM0
         ONmIiCExl1fQXybhZqwUl5IRSfP+PlZ7CcKcH9IuybpSxXN9nbLyVi0FzMSTCxctYcfX
         C398XtU0f70uuQx9vuI7aWqOyybu27Ut3wn/breTSoceOClHASGVux/viQh9zfM3+eKD
         XGUn3lkB7vjVqUhRtMnovMaof7i23SQ6+GjljD1P/p4txoDLefMayIRx58uqT0RgFxU9
         q0XS9sXLS9GuEWB6X39Jk4qQK5xHEI8Pa6txlyTTrYzZJuFK5PidLUzzgCCaJCCRiDVR
         4q2Q==
X-Gm-Message-State: AO0yUKUbDTpBLNi+gG9BN8CGBt8FHBfFHi7JDdGrbEkpKiwLHRn/PRYm
        Y6pUPfZzohEH0A2WzUpkobfBquVrp0jwJoll5/P+hQ==
X-Google-Smtp-Source: AK7set/Up6yyP+BzP5kn23ljy4FYbo/MfdVBFYQExn4eEUIF4j6irdsU+LfhlIho8DmbbrXg5XJysz1zEnY9EO0bDSw=
X-Received: by 2002:a1f:f4cf:0:b0:401:1f9:ca21 with SMTP id
 s198-20020a1ff4cf000000b0040101f9ca21mr446701vkh.31.1676900435110; Mon, 20
 Feb 2023 05:40:35 -0800 (PST)
MIME-Version: 1.0
From:   Hsin-Wei Hung <hsinweih@uci.edu>
Date:   Mon, 20 Feb 2023 07:39:59 -0600
Message-ID: <CABcoxUayum5oOqFMMqAeWuS8+EzojquSOSyDA3J_2omY=2EeAg@mail.gmail.com>
Subject: A potential deadlock in sockhash map
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I think my previous report got blocked since it contained HTML
subparts so I am sending it again. Our bpf runtime fuzzer (a
customized syzkaller) triggered a lockdep warning in the bpf subsystem
indicating a potential deadlock. We are able to trigger this bug on
v5.15.25 and v5.19. The following code is a BPF PoC, and the lockdep
warning is attached at the end.

#include "/usr/local/include/vmlinux.h"
#include "/usr/include/bpf/bpf_helpers.h"

#define __uint(name, val) int (*name)[val]
#define __type(name, val) typeof(val) *name
#define __array(name, val) typeof(val) *name[]

#define SEC(name) \
        _Pragma("GCC diagnostic push")                                  \
        _Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")      \
        __attribute__((section(name), used))                            \
        _Pragma("GCC diagnostic pop")

#define DEFINE_BPF_MAP(the_map, TypeOfMap, MapFlags, TypeOfKey,
TypeOfValue, MaxEntries) \
        struct {                                                        \
            __uint(type, TypeOfMap);                                    \
            __uint(map_flags, (MapFlags));                              \
            __uint(max_entries, (MaxEntries));                          \
            __type(key, TypeOfKey);                                     \
            __type(value, TypeOfValue);                                 \
        } the_map SEC(".maps");

DEFINE_BPF_MAP(map_0, BPF_MAP_TYPE_SOCKHASH, 0, uint32_t, uint32_t, 1005);
SEC("tp/sched/sched_switch")
int func(__u64 *ctx) {
        uint32_t v0 = 0;
        uint64_t v1 = 0;
        v1 = bpf_map_delete_elem(&map_0, &v0);
        return 0;
}
char _license[] SEC("license") = "GPL";

=====================================================
WARNING: CPU: 1 PID: 0 at kernel/softirq.c:376 __local_bh_enable_ip+0xc6/0x110
WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
Modules linked in:
5.19.0+ #2 Not tainted

-----------------------------------------------------
syz-executor.0/1299 [HC0[0]:SC0[2]:HE0:SE0] is trying to acquire:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.19.0+ #2
ffffc90000a173e0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
 (
RIP: 0010:__local_bh_enable_ip+0xc6/0x110
&htab->buckets[i].lock
Code: 00 ff ff 00 74 39 65 ff 0d 17 e8 25 4f e8 62 bb 3c 00 fb 0f 1f
44 00 00 5b 5d c3 cc cc cc cc 65 8b 05 7a ee 25 4f 85 c0 75 9b <0f> 0b
eb 97 e8 41 ba 3c 00 eb a4 48 89 ef e8 b7 6e 16 00 eb ad 65
){+...}-{2:2}
RSP: 0018:ffff888001b1fac8 EFLAGS: 00010046
, at: sock_hash_delete_elem+0xcc/0x290


and this task is already holding:
RAX: 0000000000000000 RBX: 0000000000000201 RCX: 1ffffffff6a5dcf1
ffff888054a42c98
RDX: 0000000000000000 RSI: 0000000000000201 RDI: ffffffffb2c89dfd
 (
RBP: ffffffffb2c89dfd R08: 0000000000000000 R09: ffffc90000a173cb
&rq->__lock
R10: fffff52000142e79 R11: 0000000000000001 R12: 00000000fffffffe
){-.-.}-{2:2}
R13: ffffc90000a173c8 R14: 00000000049396b8 R15: 0000000000000004
, at: __schedule+0x29a/0x28c0
FS:  0000000000000000(0000) GS:ffff888054a80000(0000) knlGS:0000000000000000
which would create a new lock dependency:
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 (&rq->__lock
CR2: 0000001b30b20000 CR3: 0000000006eb2004 CR4: 0000000000370ee0
){-.-.}-{2:2}
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 -> (
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
&htab->buckets[i].lock
Call Trace:
){+...}-{2:2}
 <TASK>


but this new dependency connects a HARDIRQ-irq-safe lock:
 sock_hash_delete_elem+0x20d/0x290
 (&rq->__lock
 bpf_prog_ca95c5394311bbec_func+0x2d/0x31
){-.-.}-{2:2}
 trace_call_bpf+0x274/0x5f0

... which became HARDIRQ-irq-safe at:
 ? tracing_prog_func_proto+0x490/0x490
  lock_acquire+0x1a1/0x500
 perf_trace_run_bpf_submit+0x96/0x1c0
  _raw_spin_lock_nested+0x2a/0x40
 perf_trace_sched_switch+0x452/0x6c0
  scheduler_tick+0x9f/0x770
 ? psi_task_switch+0x3ae/0x4c0
  update_process_times+0x10f/0x150
 ? trace_raw_output_sched_wake_idle_without_ipi+0xb0/0xb0
  tick_periodic+0x72/0x230
 ? do_raw_spin_lock+0x125/0x270
  tick_handle_periodic+0x46/0x120
 ? pick_next_task_fair+0x46a/0xee0
  timer_interrupt+0x4a/0x80
 __schedule+0x134f/0x28c0
  __handle_irq_event_percpu+0x214/0x7b0
 ? io_schedule_timeout+0x150/0x150
  handle_irq_event+0xac/0x1e0
 ? tick_nohz_idle_exit+0x13a/0x3d0
  handle_level_irq+0x245/0x6e0
 ? lockdep_hardirqs_on_prepare+0x27b/0x3f0
  __common_interrupt+0x6c/0x160
 ? trace_hardirqs_on+0x2d/0x100
  common_interrupt+0x78/0xa0
 schedule_idle+0x5c/0xa0
  asm_common_interrupt+0x22/0x40
 do_idle+0x2e0/0x550
  __x86_return_thunk+0x0/0x8
 ? arch_cpu_idle_exit+0x40/0x40
  _raw_spin_unlock_irqrestore+0x33/0x50
 ? lockdep_hardirqs_on_prepare+0x27b/0x3f0
  __setup_irq+0x101a/0x1ca0
 ? trace_hardirqs_on+0x2d/0x100
  request_threaded_irq+0x2b7/0x3e0
 cpu_startup_entry+0x19/0x20
  hpet_time_init+0x2d/0x4b
 start_secondary+0x241/0x2d0
  x86_late_time_init+0x63/0xa6
 ? set_cpu_sibling_map+0x1ed0/0x1ed0
  start_kernel+0x443/0x517
 ? set_bringup_idt_handler.constprop.0+0x98/0xc0
  secondary_startup_64_no_verify+0xd3/0xdb
 ? start_cpu0+0xc/0xc

to a HARDIRQ-irq-unsafe lock:
 secondary_startup_64_no_verify+0xd3/0xdb
 (
 </TASK>
&htab->buckets[i].lock
irq event stamp: 304481
){+...}-{2:2}
hardirqs last  enabled at (304479): [<ffffffffb1043fca>]
tick_nohz_idle_exit+0x13a/0x3d0

... which became HARDIRQ-irq-unsafe at:
hardirqs last disabled at (304480): [<ffffffffb33a2e07>]
__schedule+0x14d7/0x28c0
...
  lock_acquire+0x1a1/0x500
softirqs last  enabled at (304354): [<ffffffffb0dd1079>]
__irq_exit_rcu+0x189/0x1f0
  _raw_spin_lock_bh+0x34/0x40
softirqs last disabled at (304481): [<ffffffffb2c89cbc>]
sock_hash_delete_elem+0xcc/0x290
  sock_hash_free+0x124/0x970
---[ end trace 0000000000000000 ]---
  __sys_bpf+0x39c4/0x6070
  __x64_sys_bpf+0x7a/0xc0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&htab->buckets[i].lock);
                               local_irq_disable();
                               lock(&rq->__lock);
                               lock(&htab->buckets[i].lock);
  <Interrupt>
    lock(&rq->__lock);

 *** DEADLOCK ***

2 locks held by syz-executor.0/1299:
 #0: ffff888054a42c98 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x29a/0x28c0
 #1: ffffffffb4bc25c0 (rcu_read_lock){....}-{1:2}, at: trace_call_bpf+0xa0/0x5f0

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&rq->__lock){-.-.}-{2:2} {
   IN-HARDIRQ-W at:
                    lock_acquire+0x1a1/0x500
                    _raw_spin_lock_nested+0x2a/0x40
                    scheduler_tick+0x9f/0x770
                    update_process_times+0x10f/0x150
                    tick_periodic+0x72/0x230
                    tick_handle_periodic+0x46/0x120
                    timer_interrupt+0x4a/0x80
                    __handle_irq_event_percpu+0x214/0x7b0
                    handle_irq_event+0xac/0x1e0
                    handle_level_irq+0x245/0x6e0
                    __common_interrupt+0x6c/0x160
                    common_interrupt+0x78/0xa0
                    asm_common_interrupt+0x22/0x40
                    __x86_return_thunk+0x0/0x8
                    _raw_spin_unlock_irqrestore+0x33/0x50
                    __setup_irq+0x101a/0x1ca0
                    request_threaded_irq+0x2b7/0x3e0
                    hpet_time_init+0x2d/0x4b
                    x86_late_time_init+0x63/0xa6
                    start_kernel+0x443/0x517
                    secondary_startup_64_no_verify+0xd3/0xdb
   IN-SOFTIRQ-W at:
                    lock_acquire+0x1a1/0x500
                    _raw_spin_lock_nested+0x2a/0x40
                    try_to_wake_up+0x4b6/0x1650
                    call_timer_fn+0x187/0x590
                    __run_timers.part.0+0x66b/0xa20
                    run_timer_softirq+0x85/0x130
                    __do_softirq+0x1c2/0x845
                    __irq_exit_rcu+0x189/0x1f0
                    irq_exit_rcu+0xa/0x20
                    sysvec_apic_timer_interrupt+0x6f/0x90
                    asm_sysvec_apic_timer_interrupt+0x16/0x20
                    kmemleak_alloc+0x11/0x80
                    kmem_cache_alloc_trace+0x2ae/0x4a0
                    kprobe_add_ksym_blacklist+0xf4/0x300
                    kprobe_add_area_blacklist+0x6f/0xb0
                    init_kprobes+0x129/0x310
                    do_one_initcall+0xf0/0x550
                    kernel_init_freeable+0x50b/0x7c4
                    kernel_init+0x1f/0x1f0
                    ret_from_fork+0x22/0x30
   INITIAL USE at:
                   lock_acquire+0x1a1/0x500
                   _raw_spin_lock_nested+0x2a/0x40
                   raw_spin_rq_lock_nested+0x11/0x20
                   _raw_spin_rq_lock_irqsave+0x25/0x50
                   rq_attach_root+0x25/0x340
                   sched_init+0x938/0xe26
                   start_kernel+0x1a8/0x517
                   secondary_startup_64_no_verify+0xd3/0xdb
 }
 ... key      at: [<ffffffffb5ddd400>] __key.265+0x0/0x40

the dependencies between the lock to be acquired
 and HARDIRQ-irq-unsafe lock:
-> (&htab->buckets[i].lock){+...}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x1a1/0x500
                    _raw_spin_lock_bh+0x34/0x40
                    sock_hash_free+0x124/0x970
                    __sys_bpf+0x39c4/0x6070
                    __x64_sys_bpf+0x7a/0xc0
                    do_syscall_64+0x3b/0x90
                    entry_SYSCALL_64_after_hwframe+0x63/0xcd
   INITIAL USE at:
                   lock_acquire+0x1a1/0x500
                   _raw_spin_lock_bh+0x34/0x40
                   sock_hash_free+0x124/0x970
                   __sys_bpf+0x39c4/0x6070
                   __x64_sys_bpf+0x7a/0xc0
                   do_syscall_64+0x3b/0x90
                   entry_SYSCALL_64_after_hwframe+0x63/0xcd
 }
 ... key      at: [<ffffffffb70688e0>] __key.0+0x0/0x40
 ... acquired at:
   lock_acquire+0x1a1/0x500
   _raw_spin_lock_bh+0x34/0x40
   sock_hash_delete_elem+0xcc/0x290
   bpf_prog_ca95c5394311bbec_func+0x2d/0x31
   trace_call_bpf+0x274/0x5f0
   perf_trace_run_bpf_submit+0x96/0x1c0
   perf_trace_sched_switch+0x452/0x6c0
   __schedule+0x134f/0x28c0
   schedule+0xd4/0x1f0
   exit_to_user_mode_prepare+0x124/0x230
   syscall_exit_to_user_mode+0x16/0x50
   do_syscall_64+0x48/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd


stack backtrace:
CPU: 0 PID: 1299 Comm: syz-executor.0 Tainted: G        W         5.19.0+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x9c/0xc9
 check_irq_usage.cold+0x4ab/0x666
 ? print_shortest_lock_dependencies_backwards+0x80/0x80
 ? check_path.constprop.0+0x24/0x50
 ? register_lock_class+0xb8/0x1120
 ? lock_is_held_type+0xa6/0x120
 ? lockdep_lock+0xbe/0x1c0
 ? call_rcu_zapped+0xc0/0xc0
 __lock_acquire+0x293f/0x5320
 ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
 ? __lock_acquire+0x15c3/0x5320
 lock_acquire+0x1a1/0x500
 ? sock_hash_delete_elem+0xcc/0x290
 ? lock_release+0x720/0x720
 ? lock_acquire+0x1a1/0x500
 ? trace_call_bpf+0xa0/0x5f0
 ? lock_release+0x720/0x720
 ? __sanitizer_cov_trace_switch+0x50/0x90
 _raw_spin_lock_bh+0x34/0x40
 ? sock_hash_delete_elem+0xcc/0x290
 sock_hash_delete_elem+0xcc/0x290
 bpf_prog_ca95c5394311bbec_func+0x2d/0x31
 trace_call_bpf+0x274/0x5f0
 ? tracing_prog_func_proto+0x490/0x490
 perf_trace_run_bpf_submit+0x96/0x1c0
 perf_trace_sched_switch+0x452/0x6c0
 ? psi_task_switch+0x186/0x4c0
 ? trace_raw_output_sched_wake_idle_without_ipi+0xb0/0xb0
 ? do_raw_spin_lock+0x125/0x270
 ? pick_next_task_fair+0x46a/0xee0
 __schedule+0x134f/0x28c0
 ? io_schedule_timeout+0x150/0x150
 ? fput+0x30/0x1a0
 ? ksys_write+0x1a8/0x260
 schedule+0xd4/0x1f0
 exit_to_user_mode_prepare+0x124/0x230
 syscall_exit_to_user_mode+0x16/0x50
 do_syscall_64+0x48/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f79ef08636f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54
24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d
00 f0 ff ff 77 2d 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
RSP: 002b:00007f79f0337300 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: 0000000000000011 RBX: 0000000000000011 RCX: 00007f79ef08636f
RDX: 0000000000000011 RSI: 00007f79f03374d0 RDI: 0000000000000002
RBP: 00007f79f03374d0 R08: 0000000000000000 R09: 0000000000000011
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000011
R13: 00007f79ef202080 R14: 0000000000000011 R15: 00007f79ef203ba0
 </TASK>

Thank you,
Hsin-Wei Hung

--
Computer Science Department
University of California, Irvine
