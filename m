Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C691012D6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 06:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKSFNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKSFNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 00:13:53 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B044922317;
        Tue, 19 Nov 2019 05:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140431;
        bh=Si1HDLm51lgYD2+Ufp6wI344h/nytQkGhlV12bTWAkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUy1tf2gSsz6GqPJRfkGWfK+oCVtPRpKwuGYbWdm+/TomBJxPt645fctETBGqKaSI
         qYo+0lP0aS5EUz8YZGmCLSEnSaJiUE5BM4nYYzfOkYnTza9A239HMG78+88Eq9Jpvl
         BdaYh13d37yBemHxZ3ra5h3ZbGG9x2INshKnCgXE=
Date:   Mon, 18 Nov 2019 21:13:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com>
Subject: Re: memory leak in new_inode_pseudo (2)
Message-ID: <20191119051350.GK163020@sol.localdomain>
References: <000000000000111cbe058dc7754d@google.com>
 <000000000000ed664f058dc82773@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ed664f058dc82773@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ursula and Karsten,

On Tue, Jul 16, 2019 at 01:28:06AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    be8454af Merge tag 'drm-next-2019-07-16' of git://anongit...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d5f750600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d23a1a7bf85c5250
> dashboard link: https://syzkaller.appspot.com/bug?extid=e682cca30bc101a4d9d9
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c5800600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1738f800600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e682cca30bc101a4d9d9@syzkaller.appspotmail.com
> 
> executing program
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff888128ea0980 (size 768):
>   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
>   hex dump (first 32 bytes):
>     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000005ba542b8>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
>     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
>     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>     [<000000006532a1e9>] sock_alloc_inode+0x1c/0xa0 net/socket.c:238
>     [<0000000014ddc967>] alloc_inode+0x2c/0xe0 fs/inode.c:227
>     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
>     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
>     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
>     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
>     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
>     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
>     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
>     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
>     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
>     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
>     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
>     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> BUG: memory leak
> unreferenced object 0xffff88811faeeab8 (size 56):
>   comm "syz-executor303", pid 7044, jiffies 4294943526 (age 13.490s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 0a ea 28 81 88 ff ff d0 ea ae 1f 81 88 ff ff  ...(............
>   backtrace:
>     [<000000005ba542b8>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>     [<000000005ba542b8>] slab_post_alloc_hook mm/slab.h:522 [inline]
>     [<000000005ba542b8>] slab_alloc mm/slab.c:3319 [inline]
>     [<000000005ba542b8>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>     [<000000008ca63096>] kmem_cache_zalloc include/linux/slab.h:738 [inline]
>     [<000000008ca63096>] lsm_inode_alloc security/security.c:522 [inline]
>     [<000000008ca63096>] security_inode_alloc+0x33/0xb0
> security/security.c:875
>     [<00000000b335d930>] inode_init_always+0x108/0x200 fs/inode.c:169
>     [<0000000015dcffb3>] alloc_inode+0x49/0xe0 fs/inode.c:234
>     [<0000000056541455>] new_inode_pseudo+0x18/0x70 fs/inode.c:916
>     [<000000003b5b5444>] sock_alloc+0x1c/0x90 net/socket.c:554
>     [<00000000e623b353>] __sock_create+0x8f/0x250 net/socket.c:1378
>     [<000000000e094708>] sock_create_kern+0x3b/0x50 net/socket.c:1483
>     [<000000009fe4f64f>] smc_create+0xae/0x160 net/smc/af_smc.c:1975
>     [<0000000056be84a7>] __sock_create+0x164/0x250 net/socket.c:1414
>     [<000000005915e5fe>] sock_create net/socket.c:1465 [inline]
>     [<000000005915e5fe>] __sys_socket+0x69/0x110 net/socket.c:1507
>     [<00000000afa837b2>] __do_sys_socket net/socket.c:1516 [inline]
>     [<00000000afa837b2>] __se_sys_socket net/socket.c:1514 [inline]
>     [<00000000afa837b2>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
>     [<00000000d0addad1>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:296
>     [<000000004e8e7c22>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

Do you think this was fixed by:

	commit 6d6dd528d5af05dc2d0c773951ed68d630a0c3f1
	Author: Ursula Braun <ubraun@linux.ibm.com>
	Date:   Tue Nov 12 16:03:41 2019 +0100

	    net/smc: fix refcount non-blocking connect() -part 2

?

Thanks!

- Eric
