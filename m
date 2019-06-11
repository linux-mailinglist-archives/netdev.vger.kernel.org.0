Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021BD3D73B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406315AbfFKTxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:53:34 -0400
Received: from ja.ssi.bg ([178.16.129.10]:52482 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404282AbfFKTxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 15:53:34 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x5BJqsE6005588;
        Tue, 11 Jun 2019 22:52:54 +0300
Date:   Tue, 11 Jun 2019 22:52:54 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Eric Biggers <ebiggers@kernel.org>
cc:     syzbot <syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        horms@verge.net.au, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        wensong@linux-vs.org
Subject: Re: memory leak in start_sync_thread
In-Reply-To: <20190611010612.GD220379@gmail.com>
Message-ID: <alpine.LFD.2.21.1906112239410.3387@ja.home.ssi.bg>
References: <0000000000006d7e520589f6d3a9@google.com> <20190611010612.GD220379@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 10 Jun 2019, Eric Biggers wrote:

> On Tue, May 28, 2019 at 11:28:05AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    cd6c84d8 Linux 5.2-rc2
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=132bd44aa00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7e2e50c8adfccd2e5041
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114b1354a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7ad26a00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com
> > 
> > d started: state = MASTER, mcast_ifn = syz_tun, syncid = 0, id = 0
> > BUG: memory leak
> > unreferenced object 0xffff8881206bf700 (size 32):
> >   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
> >   hex dump (first 32 bytes):
> >     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<0000000057619e23>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
> >     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
> >     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10
> > net/netfilter/ipvs/ip_vs_sync.c:1862
> >     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780
> > net/netfilter/ipvs/ip_vs_ctl.c:2402
> >     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
> >     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80
> > net/netfilter/nf_sockopt.c:115
> >     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
> >     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
> >     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
> >     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50
> > net/core/sock.c:3130
> >     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
> >     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
> >     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
> >     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
> >     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:301
> >     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> 
> The bug is that ownership of some memory is passed to a kthread started by
> kthread_run(), but the kthread can be stopped before it actually executes the
> threadfn.  See the code in kernel/kthread.c:
> 
>         ret = -EINTR;
>         if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
>                 cgroup_kthread_ready();
>                 __kthread_parkme(self);
>                 ret = threadfn(data);
>         }
> 
> So, apparently the thread parameters must always be owned by the owner of the
> kthread, not by the kthread itself.  It seems like this would be a common
> mistake in kernel code; I'm surprised this doesn't come up more...

	Thanks! It explains the problem. It was not obvious from the
fact that only tinfo was reported as a leak, nothing for tinfo->sock.

	Moving sock_release to owner complicates the locking but
I'll try to fix it in the following days...

Regards

--
Julian Anastasov <ja@ssi.bg>
