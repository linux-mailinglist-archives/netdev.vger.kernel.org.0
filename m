Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7FB49CF9E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbiAZQYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiAZQYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:24:49 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D552C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:24:49 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v186so458436ybg.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8xRDc/fe+7I02NEyVThAKAmTbuUzadaAF9mUrYsUtwo=;
        b=tTb4vYhOFws7+CtY57vk4GxX7I8fxYqHG7+vePmqGqxF3ln1xAKByHq4JYx6HrSKnZ
         6vzEW11meHHYHI59RuCMmykbZ9qsqupHyqiLcZL+hCNFZBV7yRukdhBVeFV+HAInfyjO
         v8AOqJ6R9SQ9Mq6u5PCgeD1IgrtOgKpkMmvcKHVZ01qetb61rz/VTEtIZlgsRBxmrKvF
         ab3tgERAx64077wA38fVZHpa9e7wrquqtfoFnPV580vImnW9waenCnPVQecxImIA0mTL
         ESSJVmn9vjWXxSaWpIAeAQIdgtMBTyghPPVruugiD+Zmi70Kp3T8ikmm3zcut6NnyOWC
         fRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8xRDc/fe+7I02NEyVThAKAmTbuUzadaAF9mUrYsUtwo=;
        b=tWBJIhQ3lFXN+ISCcK8e4wKYeblbOMMyWAOfGbQSfZ6/DydpOnuX5yWUeoeCZNj0VB
         mzttF5jc7DCRnALAkWDjkGq6FtgJS6nGI6YkHDphl+hbJ6mmgO0ldNh1Oag387oMfaOq
         5F3WaCajPE2V7x2ImLMecjFUsZdHTLXmfZXajOXG7cERyX/ndY4705NOqla7R2yrowk+
         VX/fu8+pxfu2pHzgIc/XTXnqCL6HwkFXZqnEc6QcJhdTlasUUnPhLc9GDhL7FzuDqxqN
         FNU19NUBu1qAs/h1Rd30j18O/xr8ViteuCUHbUPppjVKvAYJZj1Br8kZ8TM3t7+irx/1
         nDbg==
X-Gm-Message-State: AOAM5338/6mQ8BIwn1c3SlDQtQe97zQ3NllrX+0OVMFWrgIXNTS1mLyy
        E0WqYj/RsOTkzmHrg16BzWPsAQ8auZwyXUQYfs2KiA==
X-Google-Smtp-Source: ABdhPJxnan+tv5lv0L8ZC+eCABxhg9r3c6LMKPXtx5DdtdoqpV++8PdokEh2gMN5BmOE1huC3S2btPuSgvuxqDjU0tw=
X-Received: by 2002:a5b:506:: with SMTP id o6mr38185042ybp.156.1643214286822;
 Wed, 26 Jan 2022 08:24:46 -0800 (PST)
MIME-Version: 1.0
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
 <20220124202457.3450198-7-eric.dumazet@gmail.com> <6cccaaa7854c98248d663f60404ab6163250107f.camel@redhat.com>
In-Reply-To: <6cccaaa7854c98248d663f60404ab6163250107f.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Jan 2022 08:24:35 -0800
Message-ID: <CANn89iLCdpgh9vWd_A70mPqkRgLTk9aqNY=zV2ibtVus9YLxeA@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] ipv4/tcp: do not use per netns ctl sockets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 8:14 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
> On Mon, 2022-01-24 at 12:24 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > TCP ipv4 uses per-cpu/per-netns ctl sockets in order to send
> > RST and some ACK packets (on behalf of TIMEWAIT sockets).
> >
> > This adds memory and cpu costs, which do not seem needed.
> > Now typical servers have 256 or more cores, this adds considerable
> > tax to netns users.
> >
> > tcp sockets are used from BH context, are not receiving packets,
> > and do not store any persistent state but the 'struct net' pointer
> > in order to be able to use IPv4 output functions.
> >
> > Note that I attempted a related change in the past, that had
> > to be hot-fixed in commit bdbbb8527b6f ("ipv4: tcp: get rid of ugly unicast_sock")
> >
> > This patch could very well surface old bugs, on layers not
> > taking care of sk->sk_kern_sock properly.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> We are observing UaF in our self-tests on top of this patch:
>
> https://github.com/multipath-tcp/mptcp_net-next/issues/256
>
> While I can't exclude the MPTCP code is misusing sk_net_refcnt and/or
> sk_kern_sock, we can reproduce the issue even with plain TCP sockets[1]
>
> The kasan report points to:
>
>         struct inet_hashinfo *hashinfo = tw->tw_dr->hashinfo;
>
> in inet_twsk_kill(). Apparently tw->tw_dr still refers to:
>
>         &sock_net(sk)->ipv4.tcp_death_row
>
> and the owning netns has been already dismantelled, as expected.
> I could not find any code setting tw->tw_dr to a safe value after netns
> destruction?!? am I missing something relevant?
>
> Thanks!
>
> Paolo
>
> [1] patching the selftest script with the attached patch and running it
> in a loop:
>
> while ./mptcp_connect.sh -t -t; do : ; done

Hi Paolo.

I was working a fix. syzbot found the issue yesterday before I went to bed ;)

(And this is not related to MPTCP)

My plan is to make struct inet_timewait_death_row not a sub-strutcure
of struct netns_ipv4

(the atomic_t tw_count becomes a refcount_t as a bonus)

Thanks.

BUG: KASAN: use-after-free in inet_twsk_kill+0x358/0x3c0
net/ipv4/inet_timewait_sock.c:46
Read of size 8 at addr ffff88807d5f9f40 by task kworker/1:7/3690

CPU: 1 PID: 3690 Comm: kworker/1:7 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: events pwq_unbound_release_workfn
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 inet_twsk_kill+0x358/0x3c0 net/ipv4/inet_timewait_sock.c:46
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lockdep_unregister_key+0x1c9/0x250 kernel/locking/lockdep.c:6328
Code: 00 00 00 48 89 ee e8 46 fd ff ff 4c 89 f7 e8 5e c9 ff ff e8 09
cc ff ff 9c 58 f6 c4 02 75 26 41 f7 c4 00 02 00 00 74 01 fb 5b <5d> 41
5c 41 5d 41 5e 41 5f e9 19 4a 08 00 0f 0b 5b 5d 41 5c 41 5d
RSP: 0018:ffffc90004077cb8 EFLAGS: 00000206
RAX: 0000000000000046 RBX: ffff88807b61b498 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888077027128 R08: 0000000000000001 R09: ffffffff8f1ea4fc
R10: fffffbfff1ff93ee R11: 000000000000af1e R12: 0000000000000246
R13: 0000000000000000 R14: ffffffff8ffc89b8 R15: ffffffff90157fb0
 wq_unregister_lockdep kernel/workqueue.c:3508 [inline]
 pwq_unbound_release_workfn+0x254/0x340 kernel/workqueue.c:3746
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 3635:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:470
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:705 [inline]
 net_alloc net/core/net_namespace.c:407 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3048
 __do_sys_unshare kernel/fork.c:3119 [inline]
 __se_sys_unshare kernel/fork.c:3117 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88807d5f9a80
 which belongs to the cache net_namespace of size 6528
The buggy address is located 1216 bytes inside of
 6528-byte region [ffff88807d5f9a80, ffff88807d5fb400)
The buggy address belongs to the page:
page:ffffea0001f57e00 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff88807d5f9a80 pfn:0x7d5f8
head:ffffea0001f57e00 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888070023001
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888010dd4f48 ffffea0001404e08 ffff8880118fd000
raw: ffff88807d5f9a80 0000000000040002 00000001ffffffff ffff888070023001
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 3634, ts 119694798460, free_ts 119693556950
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab mm/slub.c:1944 [inline]
 new_slab+0x28a/0x3b0 mm/slub.c:2004
 ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x35c/0x3a0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:705 [inline]
 net_alloc net/core/net_namespace.c:407 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3048
 __do_sys_unshare kernel/fork.c:3119 [inline]
 __se_sys_unshare kernel/fork.c:3117 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 skb_free_head net/core/skbuff.c:655 [inline]
 skb_release_data+0x65d/0x790 net/core/skbuff.c:677
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb net/core/skbuff.c:756 [inline]
 consume_skb net/core/skbuff.c:914 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:908
 skb_free_datagram+0x1b/0x1f0 net/core/datagram.c:325
 netlink_recvmsg+0x636/0xea0 net/netlink/af_netlink.c:1998
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807d5f9e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d5f9e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807d5f9f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88807d5f9f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d5fa000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:   00 00                   add    %al,(%rax)
   2:   00 48 89                add    %cl,-0x77(%rax)
   5:   ee                      out    %al,(%dx)
   6:   e8 46 fd ff ff          callq  0xfffffd51
   b:   4c 89 f7                mov    %r14,%rdi
   e:   e8 5e c9 ff ff          callq  0xffffc971
  13:   e8 09 cc ff ff          callq  0xffffcc21
  18:   9c                      pushfq
  19:   58                      pop    %rax
  1a:   f6 c4 02                test   $0x2,%ah
  1d:   75 26                   jne    0x45
  1f:   41 f7 c4 00 02 00 00    test   $0x200,%r12d
  26:   74 01                   je     0x29
  28:   fb                      sti
  29:   5b                      pop    %rbx
* 2a:   5d                      pop    %rbp <-- trapping instruction
  2b:   41 5c                   pop    %r12
  2d:   41 5d                   pop    %r13
  2f:   41 5e                   pop    %r14
  31:   41 5f                   pop    %r15
  33:   e9 19 4a 08 00          jmpq   0x84a51
  38:   0f 0b                   ud2
  3a:   5b                      pop    %rbx
  3b:   5d                      pop    %rbp
  3c:   41 5c                   pop    %r12
  3e:   41 5d                   pop    %r13
