Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060E73C0C4
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390088AbfFKBGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388845AbfFKBGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 21:06:17 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3ED120652;
        Tue, 11 Jun 2019 01:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560215175;
        bh=H0wYscaX4spAKhGwci+faRMeUtvVux/Cx2QS70lGKnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rEyFSdOSUyrnB/z7NmdFYurOWXuJ7MHD7xEX757FtCUPczPNs+aDBKovF9B3zz15z
         e19Evp6mG8ida9dvAJ97iPzj206qBUt7s3S0nFJbzq112/aUhMubeTZk92l6Wxh0+I
         fyT18NKDuKkZS5mTQVTw65KE7HYmk3GV4pkFuRcQ=
Date:   Mon, 10 Jun 2019 18:06:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        horms@verge.net.au, ja@ssi.bg, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        wensong@linux-vs.org
Subject: Re: memory leak in start_sync_thread
Message-ID: <20190611010612.GD220379@gmail.com>
References: <0000000000006d7e520589f6d3a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000006d7e520589f6d3a9@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:28:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    cd6c84d8 Linux 5.2-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=132bd44aa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
> dashboard link: https://syzkaller.appspot.com/bug?extid=7e2e50c8adfccd2e5041
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114b1354a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7ad26a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com
> 
> d started: state = MASTER, mcast_ifn = syz_tun, syncid = 0, id = 0
> BUG: memory leak
> unreferenced object 0xffff8881206bf700 (size 32):
>   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
>   hex dump (first 32 bytes):
>     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<0000000057619e23>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
>     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
>     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10
> net/netfilter/ipvs/ip_vs_sync.c:1862
>     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780
> net/netfilter/ipvs/ip_vs_ctl.c:2402
>     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80
> net/netfilter/nf_sockopt.c:115
>     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
>     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
>     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
>     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50
> net/core/sock.c:3130
>     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
>     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
>     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
>     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
>     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

The bug is that ownership of some memory is passed to a kthread started by
kthread_run(), but the kthread can be stopped before it actually executes the
threadfn.  See the code in kernel/kthread.c:

        ret = -EINTR;
        if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
                cgroup_kthread_ready();
                __kthread_parkme(self);
                ret = threadfn(data);
        }

So, apparently the thread parameters must always be owned by the owner of the
kthread, not by the kthread itself.  It seems like this would be a common
mistake in kernel code; I'm surprised this doesn't come up more...

- Eric
