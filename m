Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816AFCB423
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 07:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfJDFZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 01:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbfJDFZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 01:25:08 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990B720862;
        Fri,  4 Oct 2019 05:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570166706;
        bh=6FUTl2wd4LpbSLZQyMIKxmp2L+pBEdUGKIyHdoMmuAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcaMrWxm5pYNFNB6tEBZh6bqrjnQZwzDT5iWbTJfEZRQjuu1AxYusnOUmtBKxjzrW
         JyfRep6vnV1m8L78X4xrNATaXv7a/xcNNdtu32s3djvm3xrkVsuqT0EDFi8T3hNMbI
         xw73rIG/L65LrP/jHzy2SbxcOO/hYV6wTyOtg9d0=
Date:   Thu, 3 Oct 2019 22:25:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: memory leak in sctp_get_port_local (2)
Message-ID: <20191004052505.GS667@sol.localdomain>
Mail-Followup-To: Xin Long <lucien.xin@gmail.com>,
        syzbot <syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
References: <000000000000f93dd2058f9c4873@google.com>
 <CADvbK_dqTGZKWNmapcbyYVfLjuwzjSaqs0PHv687AjAvtPo3Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_dqTGZKWNmapcbyYVfLjuwzjSaqs0PHv687AjAvtPo3Zw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 04:33:11PM +0800, Xin Long wrote:
> On Thu, Aug 8, 2019 at 11:01 PM syzbot
> <syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    0eb0ce0a Merge tag 'spi-fix-v5.3-rc3' of git://git.kernel...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1234588c600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=39113f5c48aea971
> > dashboard link: https://syzkaller.appspot.com/bug?extid=2d7ecdf99f15689032b3
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160e1906600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140ab906600000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com
> >
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff88810fa4b380 (size 64):
> >    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 16.560s)
> >    hex dump (first 32 bytes):
> >      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
> >      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
> >    backtrace:
> >      [<00000000f1461735>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:43 [inline]
> >      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
> >      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
> >      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> > net/sctp/socket.c:8121
> >      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
> >      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
> >      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
> >      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
> >      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
> >      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
> >      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
> >      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:296
> >      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810fa4b380 (size 64):
> >    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 19.260s)
> >    hex dump (first 32 bytes):
> >      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
> >      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
> >    backtrace:
> >      [<00000000f1461735>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:43 [inline]
> >      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
> >      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
> >      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> > net/sctp/socket.c:8121
> >      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
> >      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
> >      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
> >      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
> >      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
> >      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
> >      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
> >      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:296
> >      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810fa4b380 (size 64):
> >    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 21.990s)
> >    hex dump (first 32 bytes):
> >      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
> >      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
> >    backtrace:
> >      [<00000000f1461735>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:43 [inline]
> >      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
> >      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
> >      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> > net/sctp/socket.c:8121
> >      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
> >      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
> >      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
> >      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
> >      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
> >      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
> >      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
> >      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:296
> >      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810fa4b380 (size 64):
> >    comm "syz-executor900", pid 7117, jiffies 4294946947 (age 22.940s)
> >    hex dump (first 32 bytes):
> >      20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
> >      58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
> >    backtrace:
> >      [<00000000f1461735>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:43 [inline]
> >      [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
> >      [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
> >      [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
> >      [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
> >      [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0
> > net/sctp/socket.c:8121
> >      [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
> >      [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
> >      [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
> >      [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
> >      [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
> >      [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
> >      [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
> >      [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:296
> >      [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > executing program
> > executing program
> > executing program
> > executing program
> should be fixed by:
> commit 9b6c08878e23adb7cc84bdca94d8a944b03f099e
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Wed Jun 26 16:31:39 2019 +0800
> 
>     sctp: not bind the socket in sctp_connect
> 
> was this commit included in the testing kernel?
> 
> >
> >
> > ---

I'm marking this fixed by commit 29b99f54a8e6:

#syz fix: sctp: destroy bucket if failed to bind addr

... as it fixed a memory leak of this same data structure.

However, syzbot is still hitting this in a different way, so it will get
reported again.  If anyone wants to fix it before then, see the C reproducer
here: https://syzkaller.appspot.com/text?tag=ReproC&x=156ab7f3600000
It's from the "2019/10/03 02:51" crash listed at
https://syzkaller.appspot.com/bug?id=2d2cb27d3b4e4db041c252f09c492868885e5607

- Eric
