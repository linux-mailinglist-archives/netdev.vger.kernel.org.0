Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0EC24A482
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgHSQ5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgHSQ5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:57:36 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0411920882;
        Wed, 19 Aug 2020 16:57:33 +0000 (UTC)
Date:   Wed, 19 Aug 2020 12:57:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lkft-triage@lists.linaro.org,
        LTP List <ltp@lists.linux.it>
Subject: Re: NETDEV WATCHDOG: WARNING: at net/sched/sch_generic.c:442
 dev_watchdog
Message-ID: <20200819125732.1c296ce7@oasis.local.home>
In-Reply-To: <CA+G9fYtS_nAX=sPV8zTTs-nOdpJ4uxk9sqeHOZNuS4WLvBcPGg@mail.gmail.com>
References: <CA+G9fYtS_nAX=sPV8zTTs-nOdpJ4uxk9sqeHOZNuS4WLvBcPGg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 17:01:06 +0530
Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> kernel warning noticed on x86_64 while running LTP tracing ftrace-stress-test
> case. started noticing on the stable-rc linux-5.8.y branch.
> 
> This device booted with KASAN config and DYNAMIC tracing configs and more.
> This reported issue is not easily reproducible.
> 
> metadata:
>   git branch: linux-5.8.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: ad8c735b1497520df959f675718f39dca8cb8019
>   git describe: v5.8.2
>   make_kernelversion: 5.8.2
>   kernel-config:
> https://builds.tuxbuild.com/bOz0eAwkcraRiWALTW9D3Q/kernel.config
> 
> 
> [   88.139387] Scheduler tracepoints stat_sleep, stat_iowait,
> stat_blocked and stat_runtime require the kernel parameter
> schedstats=enable or kernel.sched_schedstats=1
> [   88.139387] Scheduler tracepoints stat_sleep, stat_iowait,
> stat_blocked and stat_runtime require the kernel parameter
> schedstats=enable or kernel.sched_schedstats=1
> [  107.507991] ------------[ cut here ]------------
> [  107.513103] NETDEV WATCHDOG: eth0 (igb): transmit queue 2 timed out
> [  107.519973] WARNING: CPU: 1 PID: 331 at net/sched/sch_generic.c:442
> dev_watchdog+0x4c7/0x4d0
> [  107.528907] Modules linked in: x86_pkg_temp_thermal
> [  107.534541] CPU: 1 PID: 331 Comm: systemd-journal Not tainted 5.8.2 #1
> [  107.541480] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [  107.549314] RIP: 0010:dev_watchdog+0x4c7/0x4d0
> [  107.554226] Code: ff ff 48 8b 5d c8 c6 05 6d f7 94 01 01 48 89 df
> e8 9e b4 f8 ff 44 89 e9 48 89 de 48 c7 c7 20 49 51 9c 48 89 c2 e8 91
> 7e e9 fe <0f> 0b e9 03 ff ff ff 66 90 e8 9b 23 db fe 55 48 89 e5 41 57

I've triggered this myself in my testing, and I assumed that adding the
overhead of tracing and here KASAN too, made some watchdog a bit
unhappy. By commenting out the warning, I've seen no ill effects.

Perhaps this is something we need to dig a bit deeper into.

-- Steve


> 41 56
> [  107.573476] RSP: 0018:ffff888230889d88 EFLAGS: 00010286
> [  107.579264] RAX: 0000000000000000 RBX: ffff88822bbb0000 RCX: dffffc0000000000
> [  107.586928] RDX: 1ffff11046114c99 RSI: ffffffff9a7e4dbe RDI: ffffffff9b7a6da7
> [  107.594473] RBP: ffff888230889de0 R08: ffffffff9a7e4dd3 R09: ffffed1044de2529
> [  107.602101] R10: ffff888226f12943 R11: ffffed1044de2528 R12: ffff88822bbb0440
> [  107.609648] R13: 0000000000000002 R14: ffff88822bbb0388 R15: ffff88822bbb0380
> [  107.617197] FS:  00007f8b471bb480(0000) GS:ffff888230880000(0000)
> knlGS:0000000000000000
> [  107.625698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  107.631944] CR2: 0000000000000008 CR3: 0000000226a64001 CR4: 00000000003606e0
> [  107.639496] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  107.647092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  107.654661] Call Trace:
> [  107.657735]  <IRQ>
> [  107.663155]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.667929]  call_timer_fn+0x3b/0x1b0
> [  107.672238]  ? netif_carrier_off+0x70/0x70
> [  107.677771]  ? netif_carrier_off+0x70/0x70
> [  107.682656]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.687379]  run_timer_softirq+0x3e8/0xa10
> [  107.694653]  ? call_timer_fn+0x1b0/0x1b0
> [  107.699382]  ? trace_event_raw_event_softirq+0xdd/0x150
> [  107.706768]  ? ring_buffer_unlock_commit+0xf5/0x210
> [  107.712213]  ? call_timer_fn+0x1b0/0x1b0
> [  107.716625]  ? __do_softirq+0x155/0x467
> Aug 22 04:21:44 intel-corei7-64 [  107.721972]  ? run_timer_softirq+0x5/0xa10
> user.warn kernel[  107.727997]  ? asm_call_on_stack+0x12/0x20
> : [  107.507991] ------------[ c[  107.735546]  ? ftrace_graph_caller+0xc0/0xc0
> ut here ]-------[  107.740453]  __do_softirq+0x160/0x467
> -----
> [  107.745737]  ? hrtimer_interrupt+0x5/0x340
> [  107.753961]  asm_call_on_stack+0x12/0x20
> [  107.758672]  </IRQ>
> [  107.761555]  do_softirq_own_stack+0x3f/0x50
> [  107.766521]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.771246]  irq_exit_rcu+0xff/0x110
> [  107.776116]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.780808]  sysvec_apic_timer_interrupt+0x38/0x90
> [  107.786971]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  107.792598] RIP: 0010:profile_graph_return+0x111/0x1d0
> [  107.798204] Code: 75 e1 48 8b 45 d0 f6 c4 02 75 16 50 9d e8 f7 ff
> 02 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 c3 fb 02 00 ff
> 75 d0 9d <48> 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8d 7b 20 e8
> 77 78
> [  107.817416] RSP: 0018:ffff8882269b73a0 EFLAGS: 00000286
> [  107.823201] RAX: ffff8882269b73d8 RBX: ffff8882269b7428 RCX: dffffc0000000000
> [  107.830785] RDX: dffffc0000000000 RSI: ffffffff9a7e4dbe RDI: ffffffff9a7a955d
> [  107.838411] RBP: ffff8882269b73d8 R08: ffffffff9a7e4dd3 R09: ffffed1044de2529
> [  107.846072] R10: ffff888226f12943 R11: ffffed1044de2528 R12: ffff8882308a67c0
> [  107.853621] R13: ffff888226f12930 R14: ffff8882308a67c8 R15: ffff88822c7e4000
> [  107.863449]  ? ftrace_return_to_handler+0x1a3/0x230
> Aug 22 04:21:44 [  107.869545]  ? ftrace_return_to_handler+0x18e/0x230
> intel-corei7-64 [  107.875178]  ? profile_graph_return+0x10d/0x1d0
> user.info kernel: [  107.513103][  107.882521]  ? unwind_dump+0x100/0x100
>  NETDEV WATCHDOG: eth0 (igb): tr[  107.889054]  ?
> unwind_next_frame.part.0+0xe0/0x360
> ansmit queue 2 t[  107.895638]  ftrace_return_to_handler+0x18e/0x230
> imed out
> [  107.902594]  ? function_graph_enter+0x2d0/0x2d0
> [  107.907616]  ? unwind_next_frame+0x23/0x30
> [  107.912633]  ? unwind_dump+0x100/0x100
> [  107.919304]  ? update_stack_state+0x1d4/0x290
> [  107.926042]  return_to_handler+0x15/0x30
> [  107.931071]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.935763]  ? unwind_next_frame.part.0+0xe0/0x360
> [  107.941175]  ? unwind_next_frame.part.0+0x5/0x360
> [  107.947344]  ? profile_setup.cold+0x9b/0x9b
> [  107.953253]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.958020]  unwind_next_frame+0x23/0x30
> [  107.963015]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.967701]  arch_stack_walk+0x8c/0xf0
> [  107.974194]  ? vfs_open+0x58/0x60
> [  107.979965]  ? ftrace_graph_caller+0xc0/0xc0
> [  107.984652]  stack_trace_save+0x94/0xc0
> [  107.989565]  ? stack_trace_consume_entry+0x90/0x90
> [  107.995792]  ? stack_trace_save+0x5/0xc0
> [  108.000536]  ? trace_hardirqs_on+0x3a/0x120
> [  108.005959]  ? stack_trace_save+0x5/0xc0
> [  108.007220]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.007464]  save_stack+0x23/0x50
> [  108.007909]  ? save_stack+0x23/0x50
> [  108.008225]  ? __kasan_kmalloc.constprop.0+0xcf/0xe0
> [  108.008517]  ? kasan_kmalloc+0x9/0x10
> Aug 22 04:21:44 [  108.008809]  ? kmem_cache_alloc_trace+0xf6/0x270
> intel-corei7-64 [  108.009207]  ? single_open+0x3b/0xf0
> user.warn kernel[  108.044913]  ? proc_single_open+0x1b/0x20
> : [  107.519973][  108.050304]  ? do_dentry_open+0x2a6/0x6f0
>  WARNING: CPU: 1 PID: 331 at net[  108.057406]  ? __kasan_check_read+0x11/0x20
> /sched/sch_gener[  108.063044]  ? rb_commit+0xef/0x630
> ic.c:442 dev_watchdog+0x4c7/0x4d0
> [  108.070497]  ? __kasan_check_read+0x11/0x20
> [  108.075391]  ? ring_buffer_unlock_commit+0x102/0x210
> [  108.082301]  ? trace_buffer_unlock_commit_regs+0x171/0x1d0
> [  108.090197]  ? trace_event_buffer_commit+0xfb/0x3d0
> [  108.097668]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.102681]  ? trace_event_raw_event_kmem_alloc+0x7c/0xe0
> [  108.109083]  ? kasan_unpoison_shadow+0x38/0x50
> [  108.114780]  __kasan_kmalloc.constprop.0+0xcf/0xe0
> [  108.121927]  kasan_kmalloc+0x9/0x10
> [  108.126280]  kmem_cache_alloc_trace+0xf6/0x270
> [  108.131499]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.136690]  ? proc_cwd_link+0x140/0x140
> [  108.141797]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.146568]  single_open+0x3b/0xf0
> [  108.151695]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.156386]  proc_single_open+0x1b/0x20
> [  108.161083]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.165772]  do_dentry_open+0x2a6/0x6f0
> [  108.170282]  ? vfs_open+0x4a/0x60
> [  108.175328]  ? sched_open+0x20/0x20
> [  108.181406]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.186131]  vfs_open+0x58/0x60
> [  108.190568]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.195258]  path_openat+0x153b/0x1ab0
> [  108.202219]  ? __srcu_read_lock+0x50/0x50
> [  108.209143]  ? vfs_mkobj+0x270/0x270
> [  108.210188]  ? ftrace_graph_caller+0x81/0xc0
> [  108.210721]  ? ftrace_return_to_handler+0x1a3/0x230
> [  108.212065]  ? function_graph_enter+0x2d0/0x2d0
> [  108.212812]  ? do_filp_open+0x91/0x1b0
> [  108.213426]  ? do_filp_open+0x107/0x1b0
> [  108.214662]  ? path_openat+0x5/0x1ab0
> [  108.217377]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.217621]  do_filp_open+0x124/0x1b0
> [  108.219009]  ? may_open_dev+0x50/0x50
> [  108.222371]  ? prepare_ftrace_return+0x7b/0xa0
> [  108.224144]  ? ftrace_graph_caller+0x81/0xc0
> [  108.224461]  ? function_graph_enter+0x2d0/0x2d0
> [  108.226641]  ? ftrace_return_to_handler+0x1a3/0x230
> [  108.228414]  ? do_filp_open+0x5/0x1b0
> [  108.231132]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.231376]  do_sys_openat2+0x31d/0x410
> [  108.233412]  ? file_open_root+0x210/0x210
> [  108.235616]  ? do_sys_openat2+0x5/0x410
> [  108.236230]  ? ftrace_graph_caller+0x81/0xc0
> [  108.238435]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.238678]  do_sys_open+0x99/0xf0
> [  108.239555]  ? filp_open+0x60/0x60
> [  108.240816]  ? do_sys_open+0x5/0xf0
> [  108.242372]  ? do_sys_open+0x5/0xf0
> [  108.243632]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.243959]  __x64_sys_openat+0x59/0x70
> [  108.245508]  ? ftrace_graph_caller+0xc0/0xc0
> [  108.245752]  do_syscall_64+0x51/0x90
> [  108.246951]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  108.247244] RIP: 0033:0x7f8b46680d20
> [  108.247512] Code: 25 00 00 41 00 3d 00 00 41 00 74 36 48 8d 05 ef
> eb 2c 00 8b 00 85 c0 75 5a 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff
> ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 84 00 00 00 48 83 c4 68 5b 5d c3 0f
> 1f 44
> [  108.247777] RSP: 002b:00007ffd2d0f21d0 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000101
> [  108.248248] RAX: ffffffffffffffda RBX: 00005635a1dcc260 RCX: 00007f8b46680d20
> [  108.248466] RDX: 0000000000080000 RSI: 00007ffd2d0f2380 RDI: 00000000ffffff9c
> [  108.248684] RBP: 0000000000000008 R08: 0000000000000008 R09: 0000000000000001
> [  108.248984] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8b46cb2977
> [  108.249226] R13: 00007f8b46cb2977 R14: 0000000000000001 R15: 0000000000000000
> [  108.254504] ---[ end trace 743b6da37b9f0ee8 ]---
> 
> full test log link,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8.2/testrun/3085886/suite/linux-log-parser/test/check-kernel-warning-1683943/log
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 

