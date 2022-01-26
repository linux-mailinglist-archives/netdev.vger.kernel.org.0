Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0649D3CF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiAZUrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:47:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231284AbiAZUrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643230039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opDimxn2lYEuN1EdxyH1ytaEi/luYxD5xKoVc1TXDCI=;
        b=YpjFeRnlbyqdmomEzrKnnMCht+4C4fypAo+nYv2TIVK80rqfDwkQh785qUbrNFP+o0GkiA
        8ho1LFiLxnVY9buphcn63A+EmebpEbC16xZHBhjWDhZ743jPE70NIqjS6PSFoo7f5+QTlJ
        i3KtbjSRJRxJWibapHejimjKQXAB4xk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-eygJLA9kPuCYiPn5H5k4YA-1; Wed, 26 Jan 2022 15:47:18 -0500
X-MC-Unique: eygJLA9kPuCYiPn5H5k4YA-1
Received: by mail-wm1-f70.google.com with SMTP id q71-20020a1ca74a000000b003507f38e330so3024869wme.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=opDimxn2lYEuN1EdxyH1ytaEi/luYxD5xKoVc1TXDCI=;
        b=T+EJz5dbTPS79ZDgzeAE6eanuu6lbyiGpuIeVEPrKadpd0zby3bv847zUrsycspnhT
         gtJmjGFg4oNCYaVomyT2h2UDUwZtnr5jJJkJfbbHlpfcfRCYk5XpjKLJsMkE3k/AF90x
         bKeKyc7SThhhlFuInILK7E8iO9ff7dJgNf4+kZTdmIThsCy5rf5cjpW3gYCVENLfDY84
         8JCBhIqLkYIhIRw94Ym7iUO/hNrHuFMbneaoBW0IuQfv8EVPE9OCobLoif6BSkWkKRrC
         7dnBFLpAlIUpTVpgiKFoi6Z8QrFph9fnFBljtPy4JLFFMMTGeg6GaBw6socUakXbh/gw
         a9Iw==
X-Gm-Message-State: AOAM532ZcbC7ty+eZwtGsMc25zOREjM5zVzItDW2A2gKLPhvVaTMFemP
        Efx8vyirH7gDYjjZvzPOILQyaZrZIEXipdhO5ersSQgzeX2GuDKtJ0woXbaHiT1vaeqbQSCEEVR
        VVSvKi+FZ3SUCo/bO
X-Received: by 2002:a5d:5589:: with SMTP id i9mr318799wrv.246.1643230036690;
        Wed, 26 Jan 2022 12:47:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpIO8/QPY9rda4ij96RlQarDSoPA6k81eWGMx9UbTR5V6JKKtTf++g0sB3RHDa+kgOsffirA==
X-Received: by 2002:a5d:5589:: with SMTP id i9mr318783wrv.246.1643230036448;
        Wed, 26 Jan 2022 12:47:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id f13sm5086543wmq.29.2022.01.26.12.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:47:16 -0800 (PST)
Message-ID: <f5281a0b42cbe0093e7bd7b91684f1b25419c8e0.camel@redhat.com>
Subject: Re: [PATCH net-next] tcp: allocate tcp_death_row outside of struct
 netns_ipv4
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Date:   Wed, 26 Jan 2022 21:47:14 +0100
In-Reply-To: <20220126180714.845362-1-eric.dumazet@gmail.com>
References: <20220126180714.845362-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-01-26 at 10:07 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I forgot tcp had per netns tracking of timewait sockets,
> and their sysctl to change the limit.
> 
> After 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()"),
> whole struct net can be freed before last tw socket is freed.
> 
> We need to allocate a separate struct inet_timewait_death_row
> object per netns.
> 
> tw_count becomes a refcount and gains associated debugging infrastructure.
> 
> BUG: KASAN: use-after-free in inet_twsk_kill+0x358/0x3c0 net/ipv4/inet_timewait_sock.c:46
> Read of size 8 at addr ffff88807d5f9f40 by task kworker/1:7/3690
> 
> CPU: 1 PID: 3690 Comm: kworker/1:7 Not tainted 5.16.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events pwq_unbound_release_workfn
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  inet_twsk_kill+0x358/0x3c0 net/ipv4/inet_timewait_sock.c:46
>  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
>  expire_timers kernel/time/timer.c:1466 [inline]
>  __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
>  __run_timers kernel/time/timer.c:1715 [inline]
>  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>  invoke_softirq kernel/softirq.c:432 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> RIP: 0010:lockdep_unregister_key+0x1c9/0x250 kernel/locking/lockdep.c:6328
> Code: 00 00 00 48 89 ee e8 46 fd ff ff 4c 89 f7 e8 5e c9 ff ff e8 09 cc ff ff 9c 58 f6 c4 02 75 26 41 f7 c4 00 02 00 00 74 01 fb 5b <5d> 41 5c 41 5d 41 5e 41 5f e9 19 4a 08 00 0f 0b 5b 5d 41 5c 41 5d
> RSP: 0018:ffffc90004077cb8 EFLAGS: 00000206
> RAX: 0000000000000046 RBX: ffff88807b61b498 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888077027128 R08: 0000000000000001 R09: ffffffff8f1ea4fc
> R10: fffffbfff1ff93ee R11: 000000000000af1e R12: 0000000000000246
> R13: 0000000000000000 R14: ffffffff8ffc89b8 R15: ffffffff90157fb0
>  wq_unregister_lockdep kernel/workqueue.c:3508 [inline]
>  pwq_unbound_release_workfn+0x254/0x340 kernel/workqueue.c:3746
>  process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
>  worker_thread+0x657/0x1110 kernel/workqueue.c:2454
>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> 
> Allocated by task 3635:
>  kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:437 [inline]
>  __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:470
>  kasan_slab_alloc include/linux/kasan.h:260 [inline]
>  slab_post_alloc_hook mm/slab.h:732 [inline]
>  slab_alloc_node mm/slub.c:3230 [inline]
>  slab_alloc mm/slub.c:3238 [inline]
>  kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3243
>  kmem_cache_zalloc include/linux/slab.h:705 [inline]
>  net_alloc net/core/net_namespace.c:407 [inline]
>  copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
>  create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
>  ksys_unshare+0x445/0x920 kernel/fork.c:3048
>  __do_sys_unshare kernel/fork.c:3119 [inline]
>  __se_sys_unshare kernel/fork.c:3117 [inline]
>  __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The buggy address belongs to the object at ffff88807d5f9a80
>  which belongs to the cache net_namespace of size 6528
> The buggy address is located 1216 bytes inside of
>  6528-byte region [ffff88807d5f9a80, ffff88807d5fb400)
> The buggy address belongs to the page:
> page:ffffea0001f57e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807d5f9a80 pfn:0x7d5f8
> head:ffffea0001f57e00 order:3 compound_mapcount:0 compound_pincount:0
> memcg:ffff888070023001
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888010dd4f48 ffffea0001404e08 ffff8880118fd000
> raw: ffff88807d5f9a80 0000000000040002 00000001ffffffff ffff888070023001
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3634, ts 119694798460, free_ts 119693556950
>  prep_new_page mm/page_alloc.c:2434 [inline]
>  get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
>  alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
>  alloc_slab_page mm/slub.c:1799 [inline]
>  allocate_slab mm/slub.c:1944 [inline]
>  new_slab+0x28a/0x3b0 mm/slub.c:2004
>  ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
>  slab_alloc_node mm/slub.c:3196 [inline]
>  slab_alloc mm/slub.c:3238 [inline]
>  kmem_cache_alloc+0x35c/0x3a0 mm/slub.c:3243
>  kmem_cache_zalloc include/linux/slab.h:705 [inline]
>  net_alloc net/core/net_namespace.c:407 [inline]
>  copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
>  create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
>  ksys_unshare+0x445/0x920 kernel/fork.c:3048
>  __do_sys_unshare kernel/fork.c:3119 [inline]
>  __se_sys_unshare kernel/fork.c:3117 [inline]
>  __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1352 [inline]
>  free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
>  free_unref_page_prepare mm/page_alloc.c:3325 [inline]
>  free_unref_page+0x19/0x690 mm/page_alloc.c:3404
>  skb_free_head net/core/skbuff.c:655 [inline]
>  skb_release_data+0x65d/0x790 net/core/skbuff.c:677
>  skb_release_all net/core/skbuff.c:742 [inline]
>  __kfree_skb net/core/skbuff.c:756 [inline]
>  consume_skb net/core/skbuff.c:914 [inline]
>  consume_skb+0xc2/0x160 net/core/skbuff.c:908
>  skb_free_datagram+0x1b/0x1f0 net/core/datagram.c:325
>  netlink_recvmsg+0x636/0xea0 net/netlink/af_netlink.c:1998
>  sock_recvmsg_nosec net/socket.c:948 [inline]
>  sock_recvmsg net/socket.c:966 [inline]
>  sock_recvmsg net/socket.c:962 [inline]
>  ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
>  ___sys_recvmsg+0x127/0x200 net/socket.c:2674
>  __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Memory state around the buggy address:
>  ffff88807d5f9e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88807d5f9e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff88807d5f9f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff88807d5f9f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88807d5fa000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> Fixes: 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Paolo Abeni <pabeni@redhat.com>

This makes MPTCP self-tests happy again! Thanks Eric!

Tested-by: Paolo Abeni <pabeni@redhat.com>


