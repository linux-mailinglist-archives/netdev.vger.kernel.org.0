Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D41383A6
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 22:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgAKVNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 16:13:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38178 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731352AbgAKVNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 16:13:55 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iqO4r-0004Pd-J0; Sat, 11 Jan 2020 22:13:49 +0100
Date:   Sat, 11 Jan 2020 22:13:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: general protection fault in xt_rateest_put
Message-ID: <20200111211349.GG795@breakpoint.cc>
References: <000000000000af1c5b059be111e5@google.com>
 <CAM_iQpVHAKqA51tm5LjbOZnUd6Zdb9MsRyAoCsYt0acXDQA=gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVHAKqA51tm5LjbOZnUd6Zdb9MsRyAoCsYt0acXDQA=gw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Sat, Jan 11, 2020 at 10:05 AM syzbot
> <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1239f876e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
> > dashboard link: https://syzkaller.appspot.com/bug?extid=91bdd8eece0f6629ec8b
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13dbd58ee00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15eff9e1e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
> >
> > kasan: CONFIG_KASAN_INLINE enabled
> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 10213 Comm: syz-executor519 Not tainted 5.5.0-rc5-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
> > RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
> > RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
> > Code: 85 87 01 fb 45 84 f6 0f 84 68 02 00 00 e8 37 86 01 fb 49 8d bd 68 13
> > 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> > 85 6c 03 00 00 4d 8b b5 68 13 00 00 e8 29 bf ed fa
> > RSP: 0018:ffffc90001cd7940 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: ffff8880a779f700 RCX: ffffffff8673a332
> > RDX: 000000000000026d RSI: ffffffff8673a0b9 RDI: 0000000000001368
> > RBP: ffffc90001cd7970 R08: ffff8880a96b2240 R09: ffffed1015d0703d
> > R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 000000000000002d
> > R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff8673a470
> > FS:  00000000016ce880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055cd48aff140 CR3: 0000000096982000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
> >   cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
> >   translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
> >   do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
> >   do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461
> 
> This looks odd, the head commit e69ec487 comes after commit
> 1b789577f655060d98d20ed0c6f9fbd469d6ba63 which is supposed
> to fix this...

The fix is incomplete,  net/ipv4/netfilter/arp_tables.c:cleanup_entry()
doesn't init *net either.

Are you working on a fix already?

Otherwise I can handle this.
