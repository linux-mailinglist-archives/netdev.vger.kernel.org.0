Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F3263F64
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgIJIKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730184AbgIJIKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:10:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D98C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:10:02 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v54so4187841qtj.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jsxSSyL8qmfNl7zz8ZrmAY+yT5syY9PA5vlsJz041s=;
        b=elIxQ+rRg9uJQro2RaiZO+Wm+Iuf1aZBh2+e7DTrLJJrAXzNtEUvb0xZpG1snvkw1P
         lPyqIcD4WqTwECo2m2rhBkx4RHv6KB4eInoksKGbGPqoMV/9oazyd9MAbkVZu3EibLcd
         f0qBdPR5YF55537SCYe6Mnklo6Vu0vUcgnYaOfZi0UBJAyL7/A7J+yCW/ez0BnFXZdqv
         /9TFA7/gbpdLgRZvqER72g0SOEyeuYnykR6OVKiE+bYXPN/o1fRrzDVnePGMuaRg6aF4
         oI5W/2vo0v2RJ858fKpdk89BmdRYH29TONaDtzRaZtV1S4XvXlpZY5CHgR4lPIsYMIB/
         bIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jsxSSyL8qmfNl7zz8ZrmAY+yT5syY9PA5vlsJz041s=;
        b=qi2TNYcz8Yrvd5x1THN4PYkpUr1RF6gR9eoSYxNDm31D7s/Lg+DjvgTfqMvy0FFvSu
         i549wor0srwvN3DStij72Wn8PbtbJkvXwqAGYmF5VxBnnsr2L7d2xStDGWybl//QZx+u
         lf6Fhcr8v57pF1Bb3gmrH6/FkXyFj4cEJOs/LhKs89mXxILLBlOq0OmbynxwKQDYlB1A
         Hxl8aHh9TXIpuPmnqymYTBjO89xoKHjBfcDFvOSQfx4UIy5Lf/58OdimI+MyP439i7xR
         kFhGwMuuvwcYueLF798rJOdeIQYBVnURTAgVQomV3xXejortwD+PGF5nUyItBcG/iYPv
         ibJA==
X-Gm-Message-State: AOAM532UgdUGhFkWWQueDAP7gsxH2tE631VxOnY5Ltqi0ond0cxCVxUR
        h1Eu2E6NJDeLKIFTbsPfGCtQo910THLcqt2rFoQ3fw==
X-Google-Smtp-Source: ABdhPJzgr+scRjBIqbgk7S4mPfcecaJWa1Zkvz5cHMFYxDm6fXIG7eCaN98U531DcaKJ5I6gAEtkpSXW+hJ0xN8DOx8=
X-Received: by 2002:ac8:bc9:: with SMTP id p9mr7018388qti.50.1599725401201;
 Thu, 10 Sep 2020 01:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000059b7205aa7f906f@google.com> <00000000000026751605aa857914@google.com>
 <CACT4Y+bUK4icp1TMfhWOj=vEXULbiUQ84RXYaKnB=3J_N3wZCQ@mail.gmail.com> <CAAhDqq0qcnMKdaoRnaGM6G8H1U7SAmTvX=hgEoor1=_eJff-Vw@mail.gmail.com>
In-Reply-To: <CAAhDqq0qcnMKdaoRnaGM6G8H1U7SAmTvX=hgEoor1=_eJff-Vw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 10 Sep 2020 10:09:50 +0200
Message-ID: <CACT4Y+ZktT1S1oi5t+s7rrSH_dLEhyzygXdNUs7pkVPuanPXYg@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     B K Karthik <bkkarthik@pesu.pes.edu>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     syzbot <syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:08 AM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
>
> On Thu, Sep 10, 2020 at 1:32 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Thu, Sep 10, 2020 at 9:20 AM Anant Thazhemadam
> > <anant.thazhemadam@gmail.com> wrote:
> > > Looks like this bug is no longer valid. I'm not sure which commit seems to have fixed it. Can this be marked as invalid or closed yet?
> >
> > You can see on the dashboard (or in mailing list archives) that B K
> > Karthik tested a patch for this bug in July:
> > https://syzkaller.appspot.com/bug?extid=72ff2fa98097767b5a27
> >
> > So perhaps that patch fixes it? Karthik, did you send it? Was it
> > merged? Did the commit include the syzbot Reported-by tag?
> >
>
> I did send it. I was taking a u32 spi value and casting it to a
> pointer to an IP address. Steffen Klassert
> <steffen.klassert@secunet.com> pointed out to me that the approach i
> was looking at was completely wrong.
> https://lkml.org/lkml/2020/7/27/361 is the conversation. hope this
> helps.

+Steffen, was there any other fix merged for this?

> thanks,
>
> karthik
> >
> >
> > On Thu, Jul 16, 2020 at 4:05 AM syzbot
> > <syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    ca0e494a Add linux-next specific files for 20200715
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=175099bf100000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=72ff2fa98097767b5a27
> > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112e8dbf100000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109429bf100000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com
> > >
> > > netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
> > > netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
> > > netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
> > > ==================================================================
> > > BUG: KASAN: use-after-free in __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
> > > Read of size 8 at addr ffff8880934578a8 by task syz-executor437/6811
> > > CPU: 0 PID: 6811 Comm: syz-executor437 Not tainted 5.8.0-rc5-next-20200715-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x18f/0x20d lib/dump_stack.c:118
> > >  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
> > >  __kasan_report mm/kasan/report.c:513 [inline]
> > >  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
> > >  __xfrm6_tunnel_spi_lookup+0x3a9/0x3b0 net/ipv6/xfrm6_tunnel.c:79
> > >  xfrm6_tunnel_spi_lookup+0x8a/0x1d0 net/ipv6/xfrm6_tunnel.c:95
> > >  xfrmi6_rcv_tunnel+0xb9/0x100 net/xfrm/xfrm_interface.c:824
> > >  tunnel6_rcv+0xef/0x2b0 net/ipv6/tunnel6.c:148
> > >  ip6_protocol_deliver_rcu+0x2e8/0x1670 net/ipv6/ip6_input.c:433
> > >  ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
> > >  NF_HOOK include/linux/netfilter.h:307 [inline]
> > >  NF_HOOK include/linux/netfilter.h:301 [inline]
> > >  ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:483
> > >  dst_input include/net/dst.h:449 [inline]
> > >  ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
> > >  NF_HOOK include/linux/netfilter.h:307 [inline]
> > >  NF_HOOK include/linux/netfilter.h:301 [inline]
> > >  ipv6_rcv+0x28e/0x3c0 net/ipv6/ip6_input.c:307
> > >  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5287
> > >  __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5401
> > >  netif_receive_skb_internal net/core/dev.c:5503 [inline]
> > >  netif_receive_skb+0x159/0x990 net/core/dev.c:5562
> > >  tun_rx_batched.isra.0+0x460/0x720 drivers/net/tun.c:1518
> > >  tun_get_user+0x23b2/0x35b0 drivers/net/tun.c:1972
> > >  tun_chr_write_iter+0xba/0x151 drivers/net/tun.c:2001
> > >  call_write_iter include/linux/fs.h:1879 [inline]
> > >  new_sync_write+0x422/0x650 fs/read_write.c:515
> > >  vfs_write+0x59d/0x6b0 fs/read_write.c:595
> > >  ksys_write+0x12d/0x250 fs/read_write.c:648
> > >  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > RIP: 0033:0x403d50
> > > Code: Bad RIP value.
> > > RSP: 002b:00007ffe8fe93368 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000403d50
> > > RDX: 000000000000005e RSI: 00000000200007c0 RDI: 00000000000000f0
> > > RBP: 00007ffe8fe93390 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe8fe93380
> > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > Allocated by task 6811:
> > >  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
> > >  kasan_set_track mm/kasan/common.c:56 [inline]
> > >  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
> > >  __do_kmalloc mm/slab.c:3655 [inline]
> > >  __kmalloc+0x1a8/0x320 mm/slab.c:3664
> > >  kmalloc include/linux/slab.h:559 [inline]
> > >  kzalloc include/linux/slab.h:666 [inline]
> > >  tomoyo_init_log+0x1335/0x1e50 security/tomoyo/audit.c:275
> > >  tomoyo_supervisor+0x32f/0xeb0 security/tomoyo/common.c:2097
> > >  tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
> > >  tomoyo_path_number_perm+0x3ed/0x4d0 security/tomoyo/file.c:734
> > >  security_file_ioctl+0x50/0xb0 security/security.c:1489
> > >  ksys_ioctl+0x50/0x180 fs/ioctl.c:747
> > >  __do_sys_ioctl fs/ioctl.c:762 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:760 [inline]
> > >  __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
> > >  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > Freed by task 6811:
> > >  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
> > >  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
> > >  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
> > >  __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
> > >  __cache_free mm/slab.c:3418 [inline]
> > >  kfree+0x103/0x2c0 mm/slab.c:3756
> > >  tomoyo_supervisor+0x350/0xeb0 security/tomoyo/common.c:2149
> > >  tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
> > >  tomoyo_path_number_perm+0x3ed/0x4d0 security/tomoyo/file.c:734
> > >  security_file_ioctl+0x50/0xb0 security/security.c:1489
> > >  ksys_ioctl+0x50/0x180 fs/ioctl.c:747
> > >  __do_sys_ioctl fs/ioctl.c:762 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:760 [inline]
> > >  __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
> > >  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > The buggy address belongs to the object at ffff888093457800
> > >  which belongs to the cache kmalloc-512 of size 512
> > > The buggy address is located 168 bytes inside of
> > >  512-byte region [ffff888093457800, ffff888093457a00)
> > > The buggy address belongs to the page:
> > > page:000000005c2b5911 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x93457
> > > flags: 0xfffe0000000200(slab)
> > > raw: 00fffe0000000200 ffffea00028d4308 ffffea0002834c88 ffff8880aa000600
> > > raw: 0000000000000000 ffff888093457000 0000000100000004 0000000000000000
> > > page dumped because: kasan: bad access detected
> > > Memory state around the buggy address:
> > >  ffff888093457780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > >  ffff888093457800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > >ffff888093457880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >                                   ^
> > >  ffff888093457900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >  ffff888093457980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > ==================================================================
