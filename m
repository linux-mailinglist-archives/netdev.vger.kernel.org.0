Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5203614274A
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgATJbE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jan 2020 04:31:04 -0500
Received: from relay-b01.edpnet.be ([212.71.1.221]:51171 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgATJbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:31:04 -0500
X-ASG-Debug-ID: 1579511512-0a7ff5137b3a2cc30001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (77.109.123.72.adsl.dyn.edpnet.net [77.109.123.72]) by relay-b01.edpnet.be with ESMTP id rtg1bnLzyDpKkdEq; Mon, 20 Jan 2020 10:11:52 +0100 (CET)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.123.72.adsl.dyn.edpnet.net[77.109.123.72]
X-Barracuda-Apparent-Source-IP: 77.109.123.72
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id BCE8FC64006;
        Mon, 20 Jan 2020 10:11:51 +0100 (CET)
Date:   Mon, 20 Jan 2020 10:11:46 +0100
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     mkl@pengutronix.de, o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in can_rx_register
Message-ID: <20200120091146.GD11138@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: general protection fault in can_rx_register
Mail-Followup-To: Oliver Hartkopp <socketcan@hartkopp.net>,
        mkl@pengutronix.de, o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000030dddb059c562a3f@google.com>
 <55ad363b-1723-28aa-78b1-8aba5565247e@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <55ad363b-1723-28aa-78b1-8aba5565247e@hartkopp.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.123.72.adsl.dyn.edpnet.net[77.109.123.72]
X-Barracuda-Start-Time: 1579511512
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 6997
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.6949 1.0000 1.3308
X-Barracuda-Spam-Score: 1.33
X-Barracuda-Spam-Status: No, SCORE=1.33 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.79457
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bisect was right with this:

> >The bug was bisected to:
> >
> >commit 9868b5d44f3df9dd75247acd23dddff0a42f79be
> >Author: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
> >Date:   Mon Oct 8 09:48:33 2018 +0000
> >
> >     can: introduce CAN_REQUIRED_SIZE macro

Then I'd start looking in malformed sockaddr_can data instead.

Is this code what triggers the bug?
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f5db9e00000

Kind regards,
Kurt

On vr, 17 jan 2020 21:02:48 +0100, Oliver Hartkopp wrote:
> Hi Marc, Oleksij, Kurt,
> 
> On 17/01/2020 14.46, syzbot wrote:
> >Hello,
> >
> >syzbot found the following crash on:
> >
> >HEAD commit:    f5ae2ea6 Fix built-in early-load Intel microcode alignment
> >git tree:       upstream
> >console output: https://syzkaller.appspot.com/x/log.txt?x=1033df15e00000
> >kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
> >dashboard link:
> >https://syzkaller.appspot.com/bug?extid=c3ea30e1e2485573f953
> >compiler:       clang version 10.0.0
> >(https://github.com/llvm/llvm-project/
> >c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13204f15e00000
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f5db9e00000
> >
> >The bug was bisected to:
> >
> >commit 9868b5d44f3df9dd75247acd23dddff0a42f79be
> >Author: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
> >Date:   Mon Oct 8 09:48:33 2018 +0000
> >
> >     can: introduce CAN_REQUIRED_SIZE macro
> >
> >bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129bfdb9e00000
> >final crash:    https://syzkaller.appspot.com/x/report.txt?x=119bfdb9e00000
> >console output: https://syzkaller.appspot.com/x/log.txt?x=169bfdb9e00000
> >
> >IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
> >Fixes: 9868b5d44f3d ("can: introduce CAN_REQUIRED_SIZE macro")
> >
> >kasan: CONFIG_KASAN_INLINE enabled
> >kasan: GPF could be caused by NULL-ptr deref or user memory access
> >general protection fault: 0000 [#1] PREEMPT SMP KASAN
> >CPU: 0 PID: 9593 Comm: syz-executor302 Not tainted 5.5.0-rc6-syzkaller #0
> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> >Google 01/01/2011
> >RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
> >RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
> 
> include/linux/rculist.h:528 is
> 
> struct hlist_node *first = h->first;
> 
> which would mean that 'h' must be NULL.
> 
> But the h parameter is rcv_list from
> rcv_list = can_rcv_list_find(&can_id, &mask, dev_rcv_lists);
> 
> Which can not return NULL - at least when dev_rcv_lists is a proper pointer
> to the dev_rcv_lists provided by can_dev_rcv_lists_find().
> 
> So either dev->ml_priv is NULL in the case of having a CAN interface (here
> vxcan) or we have not allocated net->can.rx_alldev_list in can_pernet_init()
> properly (which would lead to an -ENOMEM which is reported to whom?).
> 
> Hm. I'm lost. Any ideas?
> 
> Regards,
> Oliver
> 
> 
> >Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c
> >89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00
> >00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
> >RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
> >RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
> >RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
> >RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
> >R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
> >R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
> >FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000)
> >knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
> >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >Call Trace:
> >  raw_enable_filters net/can/raw.c:189 [inline]
> >  raw_enable_allfilters net/can/raw.c:255 [inline]
> >  raw_bind+0x326/0x1230 net/can/raw.c:428
> >  __sys_bind+0x2bd/0x3a0 net/socket.c:1649
> >  __do_sys_bind net/socket.c:1660 [inline]
> >  __se_sys_bind net/socket.c:1658 [inline]
> >  __x64_sys_bind+0x7a/0x90 net/socket.c:1658
> >  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >RIP: 0033:0x446ba9
> >Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
> >48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> >ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> >RSP: 002b:00007fb132f25d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> >RAX: ffffffffffffffda RBX: 00000000006dbc88 RCX: 0000000000446ba9
> >RDX: 0000000000000008 RSI: 0000000020000180 RDI: 0000000000000003
> >RBP: 00000000006dbc80 R08: 00007fb132f26700 R09: 0000000000000000
> >R10: 00007fb132f26700 R11: 0000000000000246 R12: 00000000006dbc8c
> >R13: 0000000000000000 R14: 0000000000000000 R15: 068500100000003c
> >Modules linked in:
> >---[ end trace 0dedabb13ca8e7d7 ]---
> >RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
> >RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
> >Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c
> >89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00
> >00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
> >RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
> >RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
> >RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
> >RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
> >R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
> >R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
> >FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000)
> >knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
> >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> >---
> >This bug is generated by a bot. It may contain errors.
> >See https://goo.gl/tpsmEJ for more information about syzbot.
> >syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> >syzbot will keep track of this bug report. See:
> >https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >For information about bisection process see:
> >https://goo.gl/tpsmEJ#bisection
> >syzbot can test patches for this bug, for details see:
> >https://goo.gl/tpsmEJ#testing-patches
