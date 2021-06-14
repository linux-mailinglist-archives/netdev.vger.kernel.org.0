Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC733A5EFF
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhFNJTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhFNJTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:19:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3160C061574;
        Mon, 14 Jun 2021 02:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wr1eqezgKE+EC2ay7cbljK5Hx/4WVtHnmh+ygNM8Bls=; b=Knvz8m7IgZ/JC0F5PlCV7i4/UP
        TyuPU6/SW1JDuAyTSr6lxW7MjO0ao4bHFbtEZFClXoCA69JCAowVIA9noXNB+b1cj32Q9oL6Ap+Ls
        LUu6xw9XhUOaC/9M8MTAmJFq1YKdbP4YN+374CEOKtDJROk6oPiL4scmOHF8h7PxzAAq1VO2tv7r5
        XVjI/M4YJ3RaWHQHyzPCRw1ddL8VEXqzwPoXIk4DP6/rb4bK2FZHcpAXGmN5hYKD6/Ak/d5Pzgwcj
        RqmE7gLXkw+B3vKaZa1/7eMcGQ+1mg0LS05opHR+YiMHtsQp0juoNwLq7SK1GDLHIHd6DAFbPaPgS
        s+tvt7qQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lsiiJ-006zFk-AO; Mon, 14 Jun 2021 09:17:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D4CA63001E3;
        Mon, 14 Jun 2021 11:17:02 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B09212026A646; Mon, 14 Jun 2021 11:17:02 +0200 (CEST)
Date:   Mon, 14 Jun 2021 11:17:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+df16599805dec43e5fc2@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jirislaby@kernel.org,
        jpoimboe@redhat.com, jthierry@redhat.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] BUG: stack guard page was hit in preempt_count_add
Message-ID: <YMcejm3Df4d668B7@hirez.programming.kicks-ass.net>
References: <0000000000002cf2d905c4b38bee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002cf2d905c4b38bee@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 10:58:16PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2aa8eca6 net: appletalk: fix some mistakes in grammar
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c653afd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a43776cd214e447a
> dashboard link: https://syzkaller.appspot.com/bug?extid=df16599805dec43e5fc2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+df16599805dec43e5fc2@syzkaller.appspotmail.com
> 
> BUG: stack guard page was hit at ffffc90009defff8 (stack is ffffc90009df0000..ffffc90009df7fff)

Something bond/netdev blows the stack, see below..

> kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 17591 Comm: syz-executor.0 Not tainted 5.13.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:get_lock_parent_ip include/linux/ftrace.h:841 [inline]
> RIP: 0010:preempt_latency_start kernel/sched/core.c:4780 [inline]
> RIP: 0010:preempt_latency_start kernel/sched/core.c:4777 [inline]
> RIP: 0010:preempt_count_add+0x6f/0x140 kernel/sched/core.c:4805
> Code: 05 16 f0 b2 7e 0f b6 c0 3d f4 00 00 00 7f 64 65 8b 05 05 f0 b2 7e 25 ff ff ff 7f 39 c3 74 03 5b 5d c3 48 8b 5c 24 10 48 89 df <e8> 8c cd 0b 00 85 c0 75 35 65 48 8b 2c 25 00 f0 01 00 48 8d bd f0
> RSP: 0018:ffffc90009df0000 EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffffffff81331a80 RCX: 1ffffffff20f20e4
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81331a80
> RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc90009df0140
> R10: fffff520013be033 R11: 0000000000000000 R12: ffffc90009df0188
> R13: fffff520013be029 R14: ffffc90009df0140 R15: ffffc90009df0140
> FS:  00007f6395c14700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc90009defff8 CR3: 0000000094018000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  unwind_next_frame+0x120/0x1ce0 arch/x86/kernel/unwind_orc.c:428
>  __unwind_start+0x51b/0x800 arch/x86/kernel/unwind_orc.c:699
>  unwind_start arch/x86/include/asm/unwind.h:60 [inline]
>  arch_stack_walk+0x5c/0xe0 arch/x86/kernel/stacktrace.c:24
>  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:428 [inline]
>  __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
>  kasan_slab_alloc include/linux/kasan.h:236 [inline]
>  slab_post_alloc_hook mm/slab.h:524 [inline]
>  slab_alloc_node mm/slub.c:2913 [inline]
>  kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2949
>  __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
>  alloc_skb include/linux/skbuff.h:1112 [inline]
>  nlmsg_new include/net/netlink.h:953 [inline]

>  rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3791
>  rtmsg_ifinfo_event net/core/rtnetlink.c:3827 [inline]
>  rtmsg_ifinfo_event net/core/rtnetlink.c:3818 [inline]
>  rtnetlink_event+0x123/0x1d0 net/core/rtnetlink.c:5603


>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
>  call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
>  call_netdevice_notifiers net/core/dev.c:2147 [inline]
>  netdev_features_change net/core/dev.c:1493 [inline]
>  netdev_sync_lower_features net/core/dev.c:9814 [inline]
>  __netdev_update_features+0x95d/0x17d0 net/core/dev.c:9961
>  netdev_change_features+0x61/0xb0 net/core/dev.c:10033
>  bond_compute_features+0x56c/0xaa0 drivers/net/bonding/bond_main.c:1329
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3431 [inline]
>  bond_netdev_event+0x5d6/0xa80 drivers/net/bonding/bond_main.c:3471

And this piece repeats at least 9 times... bond_* calls
netdev_change_features, which calls a notifiers chain which includes
bond_netdev_event and around it goes, until the stack gives out.



