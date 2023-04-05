Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1086D7B46
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbjDEL2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjDEL2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:28:31 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51321FFE
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 04:28:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id he13so1064948wmb.2
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 04:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680694108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uee1gdvoA4V9dAJeIQtzWIdD1wD267A9SRpNsyQJqQQ=;
        b=bS4uK7Smzi/cTN5Nqs+wPjIOOo6jeEvdvdNhMy2uB5sI6t3oNxPuiu5BrnLqn5sK2p
         70m46i8eCBRNJR8B8+Ntxma45d456Zm9pNs4K+abMOKQpCA7fD3GyOCHqWnXWxMz2BIw
         SrDF2dwhyzYPIWjj85jhCQ3cDvC4/hPYYfQJ16JUCjuHt+QuztDrVltXAAMwbjkZeVSK
         TizQ7Zbu6rNv09LgSLtLv+UEWnC9YoHp5jh0gadX8O0xWhyrluwzQlG4jsqDoQ+4fAh5
         Z2WNOiX4HYZgWTANKjdv+DkjcbMzlyzfmIaW1RYItllhAdNjfQsZsQaIki58U5mlTLRc
         T6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uee1gdvoA4V9dAJeIQtzWIdD1wD267A9SRpNsyQJqQQ=;
        b=wEvM1B5vKVy7ShN3dIvPzkjQTH5k5YCMkx/aQ0LnEC9Sm1tzL4wVykQYJ5LwGtnqln
         O4xscCom0aEWLBvIbjZS9EnKWKADhGXVWoXWWZAyrO3oMVg6EO3mcXmPzXovc8fWaOXk
         Psz+mLkCgchOZAzm16Tsc6TQHA9664hl0ioPeMgnN1aTjvB0CH1oBX/EZN98jDz/rImw
         bdeBtCuJ6B7pBggj6raxhn1EmPN1fSb1mnGkLy+3yWgEejDAciezo4JPoEeOEoH1pi7z
         +s9U+3YR5pggIx41PxqYRCgnzKRFpOfWw5mpPGhkJ1Lsiimcp07GcdP0IKyJ+JZcFlpg
         Cang==
X-Gm-Message-State: AAQBX9cuDeavmdki/YmdV6zA1g3wDfKMdP/JKYkEAzOy4yaaN1VceLob
        B4/WQP//Uu8tTMAATgkpH3EIvg5miSpjqYZEUUDs0w==
X-Google-Smtp-Source: AKy350aGzCYyFBAKzQcUrj9lLMkRymD9RdypdtylqZNl17iei8CuSE7rRh+QhLJ2cAaao4fpf5k5rnnE16trrenP4OU=
X-Received: by 2002:a05:600c:314a:b0:3f0:5ed8:c30 with SMTP id
 h10-20020a05600c314a00b003f05ed80c30mr935486wmo.3.1680694107937; Wed, 05 Apr
 2023 04:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <ZC1QYuhDz-woPxGH@dragonet>
In-Reply-To: <ZC1QYuhDz-woPxGH@dragonet>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Apr 2023 13:28:16 +0200
Message-ID: <CANn89iKn4rpqj_8fYt0UMMgAq5L_2PNoY0Ev70ck8u4t4FC_=g@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tcp_write_timer_handler
To:     "Dae R. Jeong" <threeearcat@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 12:41=E2=80=AFPM Dae R. Jeong <threeearcat@gmail.com=
> wrote:
>
> Hi,
>
> We observed an issue "KASAN: use-after-free Read in tcp_write_timer_handl=
er" during fuzzing.
>
> Unfortunately, we have not found a reproducer for the crash yet. We
> will inform you if we have any update on this crash.  Detailed crash
> information is attached below.
>

Thanks for the report.

I have dozens of similar syzbot reports, with no repro.

I usually hold them, because otherwise it is just noise to mailing lists.

Normally, all user TCP sockets hold a reference on the netns

In all these cases, we see a netns being dismantled while there is at
least one socket with a live timer.

This is therefore a kernel TCP socket, for which we do not have yet
debugging infra ( REF_TRACKER )

CONFIG_NET_DEV_REFCNT_TRACKER=3Dy is helping to detect too many dev_put(),
we need something tracking the "kernel sockets" as well.

Otherwise bugs in subsystems not properly dismantling their kernel
socket at netns dismantle are next to impossible to track and fix.

If anyone has time to implement this, feel free to submit patches.

Thanks.



> Best regards,
> Dae R. Jeong
>
> -----
> - Kernel version:
> 6.0-rc7
>
> - Crash report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in tcp_probe_timer net/ipv4/tcp_timer.c:378 [i=
nline]
> BUG: KASAN: use-after-free in tcp_write_timer_handler+0x921/0xa60 net/ipv=
4/tcp_timer.c:624
> Read of size 1 at addr ffff888046bc86a5 by task syz-fuzzer/6625
>
> CPU: 0 PID: 6625 Comm: syz-fuzzer Not tainted 6.0.0-rc7-00167-g92162e4a98=
62 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-=
g155821a1990b-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x1cf/0x2b7 lib/dump_stack.c:106
>  print_address_description+0x21/0x470 mm/kasan/report.c:317
>  print_report+0x108/0x1f0 mm/kasan/report.c:433
>  kasan_report+0xe5/0x110 mm/kasan/report.c:495
>  tcp_probe_timer net/ipv4/tcp_timer.c:378 [inline]
>  tcp_write_timer_handler+0x921/0xa60 net/ipv4/tcp_timer.c:624
>  tcp_write_timer+0x1a5/0x2c0 net/ipv4/tcp_timer.c:637
>  call_timer_fn+0xf6/0x220 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1519 [inline]
>  __run_timers+0x76f/0x980 kernel/time/timer.c:1790
>  run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1803
>  __do_softirq+0x372/0x783 kernel/softirq.c:571
>  __irq_exit_rcu+0xcf/0x160 kernel/softirq.c:650
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x43/0xb0 arch/x86/kernel/apic/apic.c:1106
>  asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.=
h:649
> RIP: 0033:0x421fb1
> Code: 90 48 8b 4f 18 90 49 b8 00 00 00 00 00 80 00 00 49 01 c8 49 c1 e8 1=
a 66 90 49 81 f8 00 00 40 00 0f 83 e2 00 00 00 4a 8b 14 c2 <84> 02 49 89 c8=
 48 c1 e9 10 81 e1 ff 03 00 00 44 0f b6 8c 0a 00 04
> RSP: 002b:00007f3d50bebd38 EFLAGS: 00000287
> RAX: 000000c001a0d140 RBX: 000000c001bba000 RCX: 000000c001a0c000
> RDX: 00007f3d51bef000 RSI: 000000c000025240 RDI: 00007f3d791daa28
> RBP: 00007f3d50bebd78 R08: 0000000000203000 R09: 00007f3d4c2f6001
> R10: 000000000000008a R11: 0000000000004048 R12: 0000000000000004
> R13: 000000c001a0d140 R14: 000000c000007520 R15: 0000000000000180
>  </TASK>
>
> Allocated by task 6664:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:437 [inline]
>  __kasan_slab_alloc+0xa3/0xd0 mm/kasan/common.c:470
>  kasan_slab_alloc include/linux/kasan.h:224 [inline]
>  slab_post_alloc_hook mm/slab.h:727 [inline]
>  slab_alloc_node mm/slub.c:3248 [inline]
>  slab_alloc mm/slub.c:3256 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3263 [inline]
>  kmem_cache_alloc+0x2e6/0x450 mm/slub.c:3273
>  kmem_cache_zalloc include/linux/slab.h:723 [inline]
>  net_alloc net/core/net_namespace.c:404 [inline]
>  copy_net_ns+0x193/0x6d0 net/core/net_namespace.c:459
>  create_new_namespaces+0x4db/0xa40 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x11e/0x180 kernel/nsproxy.c:226
>  ksys_unshare+0x5a9/0xbc0 kernel/fork.c:3183
>  __do_sys_unshare kernel/fork.c:3254 [inline]
>  __se_sys_unshare kernel/fork.c:3252 [inline]
>  __x64_sys_unshare+0x34/0x40 kernel/fork.c:3252
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Freed by task 6874:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track+0x3d/0x60 mm/kasan/common.c:45
>  kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
>  ____kasan_slab_free+0x134/0x1c0 mm/kasan/common.c:367
>  kasan_slab_free include/linux/kasan.h:200 [inline]
>  slab_free_hook mm/slub.c:1759 [inline]
>  slab_free_freelist_hook+0x278/0x370 mm/slub.c:1785
>  slab_free mm/slub.c:3539 [inline]
>  kmem_cache_free+0x11a/0x310 mm/slub.c:3556
>  net_free net/core/net_namespace.c:433 [inline]
>  cleanup_net+0xd68/0xe20 net/core/net_namespace.c:616
>  process_one_work+0x83f/0x11a0 kernel/workqueue.c:2289
>  worker_thread+0xa6c/0x1290 kernel/workqueue.c:2436
>  kthread+0x28a/0x320 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>
> Last potentially related work creation:
>  kasan_save_stack+0x2b/0x50 mm/kasan/common.c:38
>  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:348
>  insert_work+0x54/0x400 kernel/workqueue.c:1358
>  __queue_work+0xa95/0xe00 kernel/workqueue.c:1517
>  call_timer_fn+0xf6/0x220 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1514 [inline]
>  __run_timers+0x7a2/0x980 kernel/time/timer.c:1790
>  __do_softirq+0x372/0x783 kernel/softirq.c:571
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x2b/0x50 mm/kasan/common.c:38
>  __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:348
>  insert_work+0x54/0x400 kernel/workqueue.c:1358
>  __queue_work+0xa95/0xe00 kernel/workqueue.c:1517
>  call_timer_fn+0xf6/0x220 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1514 [inline]
>  __run_timers+0x7a2/0x980 kernel/time/timer.c:1790
>  __do_softirq+0x372/0x783 kernel/softirq.c:571
>
> The buggy address belongs to the object at ffff888046bc8000
>  which belongs to the cache net_namespace of size 6784
> The buggy address is located 1701 bytes inside of
>  6784-byte region [ffff888046bc8000, ffff888046bc9a80)
>
> The buggy address belongs to the physical page:
> page:ffffea00011af200 refcount:1 mapcount:0 mapping:0000000000000000 inde=
x:0x0 pfn:0x46bc8
> head:ffffea00011af200 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888013618f00
> raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 6664, tgid 6664 (syz-executor.0), ts 88505587135, free_ts 0
>  prep_new_page mm/page_alloc.c:2532 [inline]
>  get_page_from_freelist+0x800/0xc10 mm/page_alloc.c:4283
>  __alloc_pages+0x2f0/0x650 mm/page_alloc.c:5549
>  alloc_slab_page mm/slub.c:1829 [inline]
>  allocate_slab+0x1eb/0xc00 mm/slub.c:1974
>  new_slab mm/slub.c:2034 [inline]
>  ___slab_alloc+0x581/0xff0 mm/slub.c:3036
>  __slab_alloc mm/slub.c:3123 [inline]
>  slab_alloc_node mm/slub.c:3214 [inline]
>  slab_alloc mm/slub.c:3256 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3263 [inline]
>  kmem_cache_alloc+0x386/0x450 mm/slub.c:3273
>  kmem_cache_zalloc include/linux/slab.h:723 [inline]
>  net_alloc net/core/net_namespace.c:404 [inline]
>  copy_net_ns+0x193/0x6d0 net/core/net_namespace.c:459
>  create_new_namespaces+0x4db/0xa40 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x11e/0x180 kernel/nsproxy.c:226
>  ksys_unshare+0x5a9/0xbc0 kernel/fork.c:3183
>  __do_sys_unshare kernel/fork.c:3254 [inline]
>  __se_sys_unshare kernel/fork.c:3252 [inline]
>  __x64_sys_unshare+0x34/0x40 kernel/fork.c:3252
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff888046bc8580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888046bc8600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888046bc8680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                ^
>  ffff888046bc8700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888046bc8780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
