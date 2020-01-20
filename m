Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC01414272B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgATJXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:23:11 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35279 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATJXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:23:11 -0500
Received: by mail-qk1-f196.google.com with SMTP id z76so29452654qka.2
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 01:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+drl7LyyZzQ3Le0+6nOIotpvZ8Ybc/8gJ2Qh+5zlDLU=;
        b=jUcNuoDQUieW2IaNkSuxM3KcUhV324LuFUUrQ9zebkohA2XLZUuelDZobz3BlCqPI6
         ucRumVGc0kPCkZhFBCye8PWQoNRgITflmy9cZBnBSz9VmP8eU0aHm/tGnFSOKaAZdVSO
         PxbCzb4piUbvBnXt1YV6yWuNjjEf1VkODTnkGrr2y3cjCCrXqTwYJ3ieEIk84c0Buiqy
         yfxXan44+434anwTrDLOhAncpI+ujcWesyfyV4YVvFncu+JwQGeImApWR8rneHEgt63e
         j93KzSiNVm9sKTYscfVN1yMvL6XI+Fsa6e4C5KJ/o7RpFk30GNJIf6DwsMKkl0PHiFec
         LbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+drl7LyyZzQ3Le0+6nOIotpvZ8Ybc/8gJ2Qh+5zlDLU=;
        b=skise50cNHdKp+gtgIwAeXCHMyq40t8sO/FQNItGnexWuL6SIoVwJRui6cifrh+NCZ
         sbVmDQZyOfwQ1e95uEMeLYf/5QMWjiaGOIE82vrTfP1fwjrNGk0dGjFo98ybani+PMi9
         sEHHurPOgQqf3Th+hgiz1bpg/JFx3lpIjYQlhfUwYC/vtGuy6Fs6mtcn6fkAONr91yKd
         oMn/R4AL8BFa7Dz+vVs1OmxBwf6mz2WgxL4NrrbGP4cN/l5dHgnlti3bcK8V2Bk/hIG3
         xlaOZpAZU6dzYMIwF7mZwTmvqOUGRd4WhPgYOFcDW1JVYKE+dL70MkNUuAQouNVh3qgc
         QFEA==
X-Gm-Message-State: APjAAAUqjEeggB8+s++xWGwHZ/ceTqZqserRps+sfmeLyQ3hRnsbWryj
        fCvozctDMOOSZ/nMPFCGs+2p461E4cSUfWGlmL/DVg==
X-Google-Smtp-Source: APXvYqzyRAeiny/5VvFFvMyO0C2nxWNX7+AyAtmfBHbm2UMLuYEf8laTqYsljsMIakg/kRj73d40W0PPsqs+UFSqv5I=
X-Received: by 2002:a37:5841:: with SMTP id m62mr49294755qkb.256.1579512188826;
 Mon, 20 Jan 2020 01:23:08 -0800 (PST)
MIME-Version: 1.0
References: <00000000000030dddb059c562a3f@google.com> <55ad363b-1723-28aa-78b1-8aba5565247e@hartkopp.net>
 <20200120091146.GD11138@x1.vandijck-laurijssen.be>
In-Reply-To: <20200120091146.GD11138@x1.vandijck-laurijssen.be>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 20 Jan 2020 10:22:57 +0100
Message-ID: <CACT4Y+a+GusEA1Gs+z67uWjtwBRp_s7P4Wd_SMmgpCREnDu3kg@mail.gmail.com>
Subject: Re: general protection fault in can_rx_register
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:11 AM Kurt Van Dijck
<dev.kurt@vandijck-laurijssen.be> wrote:
>
> If bisect was right with this:
>
> > >The bug was bisected to:
> > >
> > >commit 9868b5d44f3df9dd75247acd23dddff0a42f79be
> > >Author: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
> > >Date:   Mon Oct 8 09:48:33 2018 +0000
> > >
> > >     can: introduce CAN_REQUIRED_SIZE macro
>
> Then I'd start looking in malformed sockaddr_can data instead.
>
> Is this code what triggers the bug?
> > >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f5db9e00000

yes

> Kind regards,
> Kurt
>
> On vr, 17 jan 2020 21:02:48 +0100, Oliver Hartkopp wrote:
> > Hi Marc, Oleksij, Kurt,
> >
> > On 17/01/2020 14.46, syzbot wrote:
> > >Hello,
> > >
> > >syzbot found the following crash on:
> > >
> > >HEAD commit:    f5ae2ea6 Fix built-in early-load Intel microcode alignment
> > >git tree:       upstream
> > >console output: https://syzkaller.appspot.com/x/log.txt?x=1033df15e00000
> > >kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
> > >dashboard link:
> > >https://syzkaller.appspot.com/bug?extid=c3ea30e1e2485573f953
> > >compiler:       clang version 10.0.0
> > >(https://github.com/llvm/llvm-project/
> > >c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13204f15e00000
> > >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f5db9e00000
> > >
> > >The bug was bisected to:
> > >
> > >commit 9868b5d44f3df9dd75247acd23dddff0a42f79be
> > >Author: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
> > >Date:   Mon Oct 8 09:48:33 2018 +0000
> > >
> > >     can: introduce CAN_REQUIRED_SIZE macro
> > >
> > >bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129bfdb9e00000
> > >final crash:    https://syzkaller.appspot.com/x/report.txt?x=119bfdb9e00000
> > >console output: https://syzkaller.appspot.com/x/log.txt?x=169bfdb9e00000
> > >
> > >IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > >Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
> > >Fixes: 9868b5d44f3d ("can: introduce CAN_REQUIRED_SIZE macro")
> > >
> > >kasan: CONFIG_KASAN_INLINE enabled
> > >kasan: GPF could be caused by NULL-ptr deref or user memory access
> > >general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > >CPU: 0 PID: 9593 Comm: syz-executor302 Not tainted 5.5.0-rc6-syzkaller #0
> > >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > >Google 01/01/2011
> > >RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
> > >RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
> >
> > include/linux/rculist.h:528 is
> >
> > struct hlist_node *first = h->first;
> >
> > which would mean that 'h' must be NULL.
> >
> > But the h parameter is rcv_list from
> > rcv_list = can_rcv_list_find(&can_id, &mask, dev_rcv_lists);
> >
> > Which can not return NULL - at least when dev_rcv_lists is a proper pointer
> > to the dev_rcv_lists provided by can_dev_rcv_lists_find().
> >
> > So either dev->ml_priv is NULL in the case of having a CAN interface (here
> > vxcan) or we have not allocated net->can.rx_alldev_list in can_pernet_init()
> > properly (which would lead to an -ENOMEM which is reported to whom?).
> >
> > Hm. I'm lost. Any ideas?
> >
> > Regards,
> > Oliver
> >
> >
> > >Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c
> > >89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00
> > >00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
> > >RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
> > >RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
> > >RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
> > >RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
> > >R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
> > >R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
> > >FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000)
> > >knlGS:0000000000000000
> > >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
> > >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >Call Trace:
> > >  raw_enable_filters net/can/raw.c:189 [inline]
> > >  raw_enable_allfilters net/can/raw.c:255 [inline]
> > >  raw_bind+0x326/0x1230 net/can/raw.c:428
> > >  __sys_bind+0x2bd/0x3a0 net/socket.c:1649
> > >  __do_sys_bind net/socket.c:1660 [inline]
> > >  __se_sys_bind net/socket.c:1658 [inline]
> > >  __x64_sys_bind+0x7a/0x90 net/socket.c:1658
> > >  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >RIP: 0033:0x446ba9
> > >Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> > >48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> > >ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > >RSP: 002b:00007fb132f25d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> > >RAX: ffffffffffffffda RBX: 00000000006dbc88 RCX: 0000000000446ba9
> > >RDX: 0000000000000008 RSI: 0000000020000180 RDI: 0000000000000003
> > >RBP: 00000000006dbc80 R08: 00007fb132f26700 R09: 0000000000000000
> > >R10: 00007fb132f26700 R11: 0000000000000246 R12: 00000000006dbc8c
> > >R13: 0000000000000000 R14: 0000000000000000 R15: 068500100000003c
> > >Modules linked in:
> > >---[ end trace 0dedabb13ca8e7d7 ]---
> > >RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
> > >RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
> > >Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c
> > >89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00
> > >00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
> > >RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
> > >RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
> > >RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
> > >RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
> > >R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
> > >R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
> > >FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000)
> > >knlGS:0000000000000000
> > >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
> > >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >
> > >
> > >---
> > >This bug is generated by a bot. It may contain errors.
> > >See https://goo.gl/tpsmEJ for more information about syzbot.
> > >syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > >syzbot will keep track of this bug report. See:
> > >https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >For information about bisection process see:
> > >https://goo.gl/tpsmEJ#bisection
> > >syzbot can test patches for this bug, for details see:
> > >https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20200120091146.GD11138%40x1.vandijck-laurijssen.be.
