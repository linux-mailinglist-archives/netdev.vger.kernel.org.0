Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301482E7323
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgL2TBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 14:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL2TBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 14:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296AE2074B;
        Tue, 29 Dec 2020 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609268472;
        bh=gbihcHQsXDrC/i8VMlXVaelWOathEKGyHnbkck553gY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rNLvq5kbdSUUuXxBgRSMGv2Fem3rHUpxQCI+Xpq1i5HqSQFMczLDjJt48lYEr9A4F
         IPATKxn0Z1NpJMUMuxiu0FlbuazMIWNp9X1jpBGffDvRksPyqu9w7N1QGMjIUYaTVw
         Duy/iwN14N+D0gpHmnuzXxMSw9OM0sCf3GfZnrY8UbpcBhvCMBakasmJ7RnCF3uUEP
         f6J1o0UqVTxR+pRC6y/3DnOUEyjVpUIXpdXLwZcOGWakURKj72Vm+9POobslJXzjMU
         t33Bg6lz5Bja1Le+IwcUzgOQdELTDBRcfyMyMKuTXtiQsFCwdiJfaABmZENw1FdU3N
         TQhukoNJbEAVQ==
Date:   Tue, 29 Dec 2020 11:01:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+35bc8fe94c9f38db8320@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in tls_init
Message-ID: <20201229110106.430c6859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <00000000000047a6eb05937eaced@google.com>
References: <00000000000047a6eb05937eaced@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Sep 2019 18:19:09 -0700 syzbot wrote:
> 2019/09/26 13:11:21 executed programs: 23
> BUG: memory leak
> unreferenced object 0xffff88810e482a00 (size 512):
>    comm "syz-executor.4", pid 6874, jiffies 4295090041 (age 14.090s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e93f019a>] kmemleak_alloc_recursive  
> include/linux/kmemleak.h:43 [inline]
>      [<00000000e93f019a>] slab_post_alloc_hook mm/slab.h:586 [inline]
>      [<00000000e93f019a>] slab_alloc mm/slab.c:3319 [inline]
>      [<00000000e93f019a>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
>      [<00000000268637bd>] kmalloc include/linux/slab.h:552 [inline]
>      [<00000000268637bd>] kzalloc include/linux/slab.h:686 [inline]
>      [<00000000268637bd>] create_ctx net/tls/tls_main.c:611 [inline]
>      [<00000000268637bd>] tls_init net/tls/tls_main.c:794 [inline]
>      [<00000000268637bd>] tls_init+0xbc/0x200 net/tls/tls_main.c:773
>      [<00000000f52c33c5>] __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
>      [<00000000f52c33c5>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:160
>      [<0000000009cb49a0>] do_tcp_setsockopt.isra.0+0x1c1/0xe10  
> net/ipv4/tcp.c:2825
>      [<00000000b9d96429>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3152
>      [<0000000038a5546c>] sock_common_setsockopt+0x38/0x50  
> net/core/sock.c:3142
>      [<00000000d945b2a0>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
>      [<000000003c3afaa0>] __do_sys_setsockopt net/socket.c:2100 [inline]
>      [<000000003c3afaa0>] __se_sys_setsockopt net/socket.c:2097 [inline]
>      [<000000003c3afaa0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
>      [<00000000f7f21cbd>] do_syscall_64+0x73/0x1f0  
> arch/x86/entry/common.c:290
>      [<00000000d4c003b9>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

#syz invalid

This hasn't happened for over a year, so perhaps the TOE-related
restructuring accidentally fixed it, somehow.
