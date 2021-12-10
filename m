Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D114546FF7A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhLJLMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:12:51 -0500
Received: from mail.toke.dk ([45.145.95.4]:36419 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232117AbhLJLMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 06:12:51 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2021 06:12:50 EST
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1639134161; bh=aNwfRKDujaKNiEOMPDaoutxe5HHZOTqWkBXuiHq5HJE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HWzVXRm2QeH6MMUeNUm80ZFZUpuW/r7SGQTquial8Ox4/NLPui2JxfxiFPyV6EzFL
         GIuguHEvq5Tb3XknkzgO6sYUbccXhCb+qHtwUiQCIsNjkv3iarM53nVHg3LXWPJrwH
         8KGwpi6ZBc6jgg9QF2tv27SmFBugYdByjC1E0nmuCdMut3Mn+elgd1XDANtrHA3UEO
         gridYaVi8EJ6kacmqUwHLAN6TMaLb7CYiA/WWr1Azf4E+sneRVg47aq4jUI0aM4R5P
         ccEXVOBUK6kU6iAUN4B+5WnZ/CcieWSDK2Z42hGIHY7kBl1MXA24C/j2g3ym7zKvit
         KxhBov+rlBa0A==
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] sch_cake: do not call cake_destroy() from cake_init()
In-Reply-To: <20211210081536.451881-1-eric.dumazet@gmail.com>
References: <20211210081536.451881-1-eric.dumazet@gmail.com>
Date:   Fri, 10 Dec 2021 12:02:41 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ilvwwwmm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> qdiscs are not supposed to call their own destroy() method
> from init(), because core stack already does that.
>
> syzbot was able to trigger use after free:
>
> DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
> WARNING: CPU: 0 PID: 21902 at kernel/locking/mutex.c:586 __mutex_lock_com=
mon kernel/locking/mutex.c:586 [inline]
> WARNING: CPU: 0 PID: 21902 at kernel/locking/mutex.c:586 __mutex_lock+0x9=
ec/0x12f0 kernel/locking/mutex.c:740
> Modules linked in:
> CPU: 0 PID: 21902 Comm: syz-executor189 Not tainted 5.16.0-rc4-syzkaller =
#0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:586 [inline]
> RIP: 0010:__mutex_lock+0x9ec/0x12f0 kernel/locking/mutex.c:740
> Code: 08 84 d2 0f 85 19 08 00 00 8b 05 97 38 4b 04 85 c0 0f 85 27 f7 ff f=
f 48 c7 c6 20 00 ac 89 48 c7 c7 a0 fe ab 89 e8 bf 76 ba ff <0f> 0b e9 0d f7=
 ff ff 48 8b 44 24 40 48 8d b8 c8 08 00 00 48 89 f8
> RSP: 0018:ffffc9000627f290 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88802315d700 RSI: ffffffff815f1db8 RDI: fffff52000c4fe44
> RBP: ffff88818f28e000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815ebb5e R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffffc9000627f458 R15: 0000000093c30000
> FS:  0000555556abc400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fda689c3303 CR3: 000000001cfbb000 CR4: 0000000000350ef0
> Call Trace:
>  <TASK>
>  tcf_chain0_head_change_cb_del+0x2e/0x3d0 net/sched/cls_api.c:810
>  tcf_block_put_ext net/sched/cls_api.c:1381 [inline]
>  tcf_block_put_ext net/sched/cls_api.c:1376 [inline]
>  tcf_block_put+0xbc/0x130 net/sched/cls_api.c:1394
>  cake_destroy+0x3f/0x80 net/sched/sch_cake.c:2695
>  qdisc_create.constprop.0+0x9da/0x10f0 net/sched/sch_api.c:1293
>  tc_modify_qdisc+0x4c5/0x1980 net/sched/sch_api.c:1660
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f1bb06badb9
> Code: Unable to access opcode bytes at RIP 0x7f1bb06bad8f.
> RSP: 002b:00007fff3012a658 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f1bb06badb9
> RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000003
> R10: 0000000000000003 R11: 0000000000000246 R12: 00007fff3012a688
> R13: 00007fff3012a6a0 R14: 00007fff3012a6e0 R15: 00000000000013c2
>  </TASK>
>
> Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake)=
 qdisc")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

Oops, thanks for the fix! I'm a little puzzled with the patch has my
S-o-b, though? It should probably be replaced by:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
