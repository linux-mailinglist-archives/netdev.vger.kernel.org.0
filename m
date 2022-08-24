Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF50759F25F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiHXEKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiHXEKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:10:03 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7722636B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:09:49 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3321c2a8d4cso430124207b3.5
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Ji02mB3oYHBYxCw/GI4VZDGcmZXeHLVwmQJ5CMeu2Tw=;
        b=G7ly91cIWvviqWZOvuJjW0B80+geDYnCAEkzXwZSdABVTBc8AYbTY9jpdIg3GOBAFK
         vbnr85Exi3hIn6MZQrTkUbL8bVDiYtQk8OK3+1AN6f+DFDKPPN4Jf4JyH3vAc/0wSap8
         KsF0/wuwSvLy+r7q/LBaXB4gId7IToHL9k/WJ38p6R4jCIcZFE0mebljB1ELCcQzazbU
         ihcYIH7f4yYsXrXpHRbKLa1GFI8Ztx1n9z5HlFLxq3ps+1oFykVLBpu/mhtWVj1Rbqlw
         fm1kZ5Oedb5TwocywW5ByHEQgHJUS1WHR7HdvkWmmJ6sW6lWRofEqDZXaxHJlAVGEqZ0
         vEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Ji02mB3oYHBYxCw/GI4VZDGcmZXeHLVwmQJ5CMeu2Tw=;
        b=o3O9dMBzRMfIGN+xwRCMg1vduhan1Z2R0C7teBEm1iz9l5iSsxUGF/BTHuYFlivA4/
         ptR6FAbC0c8rQ5Vg2zGljp4a4xlAVIR5z/vCDkgMG8FdZ3XdStYDjEEDX0J784VJbxXH
         cmYJS1mNsH2+Hif4rUOY+7H1ARxRGy4N4O/mmr23JAzSARpTO/zBJ+LC5sFAEqhYZmGa
         11KPm5cygdqMb/0IMbC+witFhncGe6JpPlB/CW2ED1tOvOk7GH9v/v00fGrIN6ML6bzh
         QiAx3ZL9FkYyToPazwjSL/QsHLHKiNZpm7CrfxBc26KVxoN5jGllxyZ/OVafhU4qsZ1r
         nAMA==
X-Gm-Message-State: ACgBeo3xTjV2FZ9Zh3NFuoX4v7SoMtKrIusG1TVM46qhGaEIYDc/YIzk
        noaO9z4/BIs4Nb36j+9IOZlvleWRmbFji+Kap8TWxA==
X-Google-Smtp-Source: AA6agR5Zldjjord9HunFsZcCUcbFZ9bp+SSKYoSKZ3OaBj5oRz/qWtci1vZIgwK8xrYfBoZuPcbV9wVbYeJRCnq5MDM=
X-Received: by 2002:a25:84cd:0:b0:67a:699e:4e84 with SMTP id
 x13-20020a2584cd000000b0067a699e4e84mr25867180ybm.407.1661314188729; Tue, 23
 Aug 2022 21:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsYp5DEy-dJv=0wxptC8dKcFL98ZgsAAKqiMYQxcVXcwUQ@mail.gmail.com>
In-Reply-To: <CACkBjsYp5DEy-dJv=0wxptC8dKcFL98ZgsAAKqiMYQxcVXcwUQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 23 Aug 2022 21:09:36 -0700
Message-ID: <CANn89i+Lkb6D6R3G-U1=XsHd=toGhk_FKbV7UuhR5DqC5n+Gsw@mail.gmail.com>
Subject: Re: KASAN: use-after-free in tcp_write_timer_handler
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 9:00 PM Hao Sun <sunhao.th@gmail.com> wrote:
>
> Hi,
>
> Following crash can be triggered on:
>
> HEAD commit: 1c23f9e627a7 Linux 6.0-rc2
> git tree: upstream
> console output: https://pastebin.com/raw/56RBVgyg
> kernel config: https://pastebin.com/raw/6VZXpdaB
> Syzlang reproducer: https://pastebin.com/raw/vpGfSssL
>

Thanks for the report, but I think it is going to be hard to use.

I have similar syzbot reports, and I usually wait for relevant SMC or
other layers
on top of TCP to be fixed. At least I wait for a bisection to complete.

You could start a bisection, maybe it will give a valuable signal.

> Sorry that I don't have a C reproducer for this crash, I can reproduce
> the crash with the provided syzlang prog in 2 minutes. The prog can be
> executed by `syz-execprog -enable all repro.prog`, and I'm willing to
> provide more information if needed and test the proposed patches if
> any.
>
> ==================================================================
> BUG: KASAN: use-after-free in tcp_probe_timer net/ipv4/tcp_timer.c:378 [inline]
> BUG: KASAN: use-after-free in tcp_write_timer_handler
> net/ipv4/tcp_timer.c:624 [inline]
> BUG: KASAN: use-after-free in tcp_write_timer_handler+0x80e/0x860
> net/ipv4/tcp_timer.c:594
> Read of size 1 at addr ffff888103e786a5 by task swapper/3/0
>
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.0.0-rc2-dirty #18
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x57/0x7d lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:317 [inline]
>  print_report.cold+0xe5/0x66d mm/kasan/report.c:433
>  kasan_report+0x8a/0x1b0 mm/kasan/report.c:495
>  tcp_probe_timer net/ipv4/tcp_timer.c:378 [inline]
>  tcp_write_timer_handler net/ipv4/tcp_timer.c:624 [inline]
>  tcp_write_timer_handler+0x80e/0x860 net/ipv4/tcp_timer.c:594
>  tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:637
>  call_timer_fn+0x163/0x4a0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1519 [inline]
>  __run_timers.part.0+0x562/0x940 kernel/time/timer.c:1790
>  __run_timers kernel/time/timer.c:1768 [inline]
>  run_timer_softirq+0x9f/0x1a0 kernel/time/timer.c:1803
>  __do_softirq+0x1d0/0x908 kernel/softirq.c:571
>  invoke_softirq kernel/softirq.c:445 [inline]
>  __irq_exit_rcu kernel/softirq.c:650 [inline]
>  irq_exit_rcu+0xf2/0x130 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> RIP: 0010:default_idle+0xb/0x10 arch/x86/kernel/process.c:731
> Code: ff e8 f9 d0 f2 f8 e9 5d fe ff ff e8 6f e6 fc ff cc cc cc cc cc
> cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 67 4b 63 00 fb f4 <c3> 0f
> 1f 40 00 41 54 be 08 00 00 00 53 65 48 8b 1c 25 80 6f 02 00
> RSP: 0018:ffffc90000197de8 EFLAGS: 00000202
> RAX: 00000000007404a1 RBX: 0000000000000003 RCX: ffffffff88bff659
> RDX: 0000000000000000 RSI: ffffffff892bfee0 RDI: ffffffff89856740
> RBP: 0000000000000003 R08: 0000000000000001 R09: ffffed1026ba698a
> R10: ffff888135d34c4b R11: ffffed1026ba6989 R12: 0000000000000003
> R13: 0000000000000003 R14: ffffffff8d107c10 R15: 0000000000000000
>  default_idle_call+0xbd/0x420 kernel/sched/idle.c:109
>  cpuidle_idle_call kernel/sched/idle.c:191 [inline]
>  do_idle+0x3f9/0x570 kernel/sched/idle.c:303
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:400
>  start_secondary+0x21d/0x2b0 arch/x86/kernel/smpboot.c:262
>  secondary_startup_64_no_verify+0xce/0xdb
>  </TASK>
>
> Allocated by task 6749:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:437 [inline]
>  __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:470
>  kasan_slab_alloc include/linux/kasan.h:224 [inline]
>  slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:727
>  slab_alloc_node mm/slub.c:3243 [inline]
>  slab_alloc mm/slub.c:3251 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>  kmem_cache_alloc+0x151/0x360 mm/slub.c:3268
>  kmem_cache_zalloc include/linux/slab.h:723 [inline]
>  net_alloc net/core/net_namespace.c:404 [inline]
>  copy_net_ns+0xea/0x660 net/core/net_namespace.c:459
>  create_new_namespaces.isra.0+0x330/0x8e0 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x8d/0x1a0 kernel/nsproxy.c:227
>  ksys_unshare+0x314/0x6b0 kernel/fork.c:3183
>  __do_sys_unshare kernel/fork.c:3254 [inline]
>  __se_sys_unshare kernel/fork.c:3252 [inline]
>  __x64_sys_unshare+0x28/0x40 kernel/fork.c:3252
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Freed by task 10130:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:367 [inline]
>  ____kasan_slab_free mm/kasan/common.c:329 [inline]
>  __kasan_slab_free+0x11d/0x1b0 mm/kasan/common.c:375
>  kasan_slab_free include/linux/kasan.h:200 [inline]
>  slab_free_hook mm/slub.c:1754 [inline]
>  slab_free_freelist_hook mm/slub.c:1780 [inline]
>  slab_free mm/slub.c:3534 [inline]
>  kmem_cache_free+0xf2/0x6b0 mm/slub.c:3551
>  net_free net/core/net_namespace.c:433 [inline]
>  net_free+0x9b/0xd0 net/core/net_namespace.c:429
>  cleanup_net+0x7e8/0xa90 net/core/net_namespace.c:616
>  process_one_work+0x890/0x1400 kernel/workqueue.c:2289
>  worker_thread+0x552/0xe90 kernel/workqueue.c:2436
>  kthread+0x299/0x340 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>
> Last potentially related work creation:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>  insert_work+0x45/0x320 kernel/workqueue.c:1358
>  __queue_work+0x3c3/0xeb0 kernel/workqueue.c:1517
>  call_timer_fn+0x163/0x4a0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1514 [inline]
>  __run_timers.part.0+0x3c3/0x940 kernel/time/timer.c:1790
>  __do_softirq+0x1d0/0x908 kernel/softirq.c:571
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>  insert_work+0x45/0x320 kernel/workqueue.c:1358
>  __queue_work+0x3c3/0xeb0 kernel/workqueue.c:1517
>  call_timer_fn+0x163/0x4a0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1514 [inline]
>  __run_timers.part.0+0x3c3/0x940 kernel/time/timer.c:1790
>  __do_softirq+0x1d0/0x908 kernel/softirq.c:571
>
> The buggy address belongs to the object at ffff888103e78000
>  which belongs to the cache net_namespace of size 6784
> The buggy address is located 1701 bytes inside of
>  6784-byte region [ffff888103e78000, ffff888103e79a80)
>
> The buggy address belongs to the physical page:
> page:ffffea00040f9e00 refcount:1 mapcount:0 mapping:0000000000000000
> index:0xffff888103e7b700 pfn:0x103e78
> head:ffffea00040f9e00 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x57ff00000010200(slab|head|node=1|zone=2|lastcpupid=0x7ff)
> raw: 057ff00000010200 ffffea000447a008 ffffea000444e808 ffff888010e18f00
> raw: ffff888103e7b700 0000000000040001 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask
> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
> pid 6749, tgid 6749 (syz-executor.2), ts 101055637021, free_ts
> 100968720641
>  set_page_owner include/linux/page_owner.h:31 [inline]
>  post_alloc_hook mm/page_alloc.c:2525 [inline]
>  prep_new_page+0x2c6/0x350 mm/page_alloc.c:2532
>  get_page_from_freelist+0xae9/0x3a80 mm/page_alloc.c:4283
>  __alloc_pages+0x321/0x710 mm/page_alloc.c:5515
>  alloc_slab_page mm/slub.c:1824 [inline]
>  allocate_slab mm/slub.c:1969 [inline]
>  new_slab+0x246/0x3a0 mm/slub.c:2029
>  ___slab_alloc+0xa50/0x1060 mm/slub.c:3031
>  __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3118
>  slab_alloc_node mm/slub.c:3209 [inline]
>  slab_alloc mm/slub.c:3251 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>  kmem_cache_alloc+0x338/0x360 mm/slub.c:3268
>  kmem_cache_zalloc include/linux/slab.h:723 [inline]
>  net_alloc net/core/net_namespace.c:404 [inline]
>  copy_net_ns+0xea/0x660 net/core/net_namespace.c:459
>  create_new_namespaces.isra.0+0x330/0x8e0 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x8d/0x1a0 kernel/nsproxy.c:227
>  ksys_unshare+0x314/0x6b0 kernel/fork.c:3183
>  __do_sys_unshare kernel/fork.c:3254 [inline]
>  __se_sys_unshare kernel/fork.c:3252 [inline]
>  __x64_sys_unshare+0x28/0x40 kernel/fork.c:3252
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1449 [inline]
>  free_pcp_prepare+0x5ab/0xd00 mm/page_alloc.c:1499
>  free_unref_page_prepare mm/page_alloc.c:3380 [inline]
>  free_unref_page+0x19/0x410 mm/page_alloc.c:3476
>  __unfreeze_partials+0x3f3/0x410 mm/slub.c:2548
>  qlink_free mm/kasan/quarantine.c:168 [inline]
>  qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>  kasan_quarantine_reduce+0x13d/0x180 mm/kasan/quarantine.c:294
>  __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
>  kasan_slab_alloc include/linux/kasan.h:224 [inline]
>  slab_post_alloc_hook+0x4d/0x4f0 mm/slab.h:727
>  slab_alloc_node mm/slub.c:3243 [inline]
>  slab_alloc mm/slub.c:3251 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>  kmem_cache_alloc+0x151/0x360 mm/slub.c:3268
>  getname_flags fs/namei.c:139 [inline]
>  getname_flags+0xb9/0x4e0 fs/namei.c:129
>  vfs_fstatat+0x35/0x70 fs/stat.c:254
>  vfs_lstat include/linux/fs.h:3282 [inline]
>  __do_sys_newlstat+0x7f/0xd0 fs/stat.c:411
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Memory state around the buggy address:
>  ffff888103e78580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888103e78600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888103e78680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                ^
>  ffff888103e78700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888103e78780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0: e8 f9 d0 f2 f8        callq  0xf8f2d0fe
>    5: e9 5d fe ff ff        jmpq   0xfffffe67
>    a: e8 6f e6 fc ff        callq  0xfffce67e
>    f: cc                    int3
>   10: cc                    int3
>   11: cc                    int3
>   12: cc                    int3
>   13: cc                    int3
>   14: cc                    int3
>   15: cc                    int3
>   16: cc                    int3
>   17: cc                    int3
>   18: cc                    int3
>   19: cc                    int3
>   1a: cc                    int3
>   1b: cc                    int3
>   1c: cc                    int3
>   1d: cc                    int3
>   1e: eb 07                jmp    0x27
>   20: 0f 00 2d 67 4b 63 00 verw   0x634b67(%rip)        # 0x634b8e
>   27: fb                    sti
>   28: f4                    hlt
> * 29: c3                    retq <-- trapping instruction
>   2a: 0f 1f 40 00          nopl   0x0(%rax)
>   2e: 41 54                push   %r12
>   30: be 08 00 00 00        mov    $0x8,%esi
>   35: 53                    push   %rbx
>   36: 65 48 8b 1c 25 80 6f mov    %gs:0x26f80,%rbx
>   3d: 02 00
