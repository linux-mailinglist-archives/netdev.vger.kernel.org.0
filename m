Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063123BDEB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbfFJU7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfFJU7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 16:59:34 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A992089E;
        Mon, 10 Jun 2019 20:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560200373;
        bh=dI/BJlaJPgTAa6Ru+0W+XmCLy9W/37V7lpMtYMPQChQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gO9QfFjHvHrVSOAKsvu9mfDGBaAa1rC79LdbXnkz1abvtb3qBMPyV2lco9lpMDalF
         XolaahQdB7U8De7j4soNdeVxOwHRXga4RaQIgNHyx25cv6uUW8GYXMg7vYUUFTcN9z
         r6dKpDqQxK552Syj0bTXnRNbW8AiNH2xLagcZ2Ck=
Date:   Mon, 10 Jun 2019 13:59:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [net/tls] Re: memory leak in create_ctx
Message-ID: <20190610205929.GL63833@gmail.com>
References: <000000000000a420af058ad4bca2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a420af058ad4bca2@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like a TLS bug.  icsk->icsk_ulp_data isn't always freed.

On Sat, Jun 08, 2019 at 12:13:06PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=170e0bfea00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d5c73825cbdc7326
> dashboard link: https://syzkaller.appspot.com/bug?extid=06537213db7ba2745c4a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10aa806aa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com
> 
> IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
> 2019/06/08 14:55:51 executed programs: 15
> 2019/06/08 14:55:56 executed programs: 31
> 2019/06/08 14:56:02 executed programs: 51
> BUG: memory leak
> unreferenced object 0xffff888117ceae00 (size 512):
>   comm "syz-executor.3", pid 7233, jiffies 4294949016 (age 13.640s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000e6550967>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>     [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>     [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>     [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>     [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>     [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>     [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>     [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>     [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60
> net/ipv4/tcp.c:2784
>     [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>     [<00000000c840962c>] sock_common_setsockopt+0x38/0x50
> net/core/sock.c:3124
>     [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>     [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>     [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>     [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>     [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>     [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff88810965dc00 (size 512):
>   comm "syz-executor.2", pid 7235, jiffies 4294949016 (age 13.640s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000e6550967>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>     [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>     [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>     [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>     [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>     [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>     [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>     [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>     [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60
> net/ipv4/tcp.c:2784
>     [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>     [<00000000c840962c>] sock_common_setsockopt+0x38/0x50
> net/core/sock.c:3124
>     [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>     [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>     [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>     [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>     [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>     [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff8881207d7600 (size 512):
>   comm "syz-executor.5", pid 7244, jiffies 4294949019 (age 13.610s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000e6550967>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<00000000e6550967>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000e6550967>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000e6550967>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>     [<0000000014132182>] kmalloc include/linux/slab.h:547 [inline]
>     [<0000000014132182>] kzalloc include/linux/slab.h:742 [inline]
>     [<0000000014132182>] create_ctx+0x25/0x70 net/tls/tls_main.c:601
>     [<00000000e08e1a44>] tls_init net/tls/tls_main.c:787 [inline]
>     [<00000000e08e1a44>] tls_init+0x97/0x1e0 net/tls/tls_main.c:769
>     [<0000000037b0c43c>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
>     [<0000000037b0c43c>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
>     [<000000007a284277>] do_tcp_setsockopt.isra.0+0x19a/0xd60
> net/ipv4/tcp.c:2784
>     [<00000000f35f3415>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3098
>     [<00000000c840962c>] sock_common_setsockopt+0x38/0x50
> net/core/sock.c:3124
>     [<0000000006b0801f>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>     [<00000000a6309f52>] __do_sys_setsockopt net/socket.c:2083 [inline]
>     [<00000000a6309f52>] __se_sys_setsockopt net/socket.c:2080 [inline]
>     [<00000000a6309f52>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>     [<00000000fa555bbc>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>     [<00000000a06d7d1a>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
