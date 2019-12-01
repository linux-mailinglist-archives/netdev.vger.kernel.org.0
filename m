Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A48C10DFE4
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 01:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfLAAEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 19:04:54 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36306 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbfLAAEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 19:04:54 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 964D743FE5E
        for <netdev@vger.kernel.org>; Sun,  1 Dec 2019 11:04:40 +1100 (AEDT)
Received: (qmail 19400 invoked by uid 501); 1 Dec 2019 00:04:39 -0000
Date:   Sun, 1 Dec 2019 11:04:39 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Chris Metcalf <cmetcalf@ezchip.com>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in blkdev_get
Message-ID: <20191201000439.GA15496@dimstar.local.net>
Mail-Followup-To: Dmitry Vyukov <dvyukov@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Chris Metcalf <cmetcalf@ezchip.com>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000e59aab056e8873ae@google.com>
 <0000000000000beff305981c5ac6@google.com>
 <20191124193035.GA4203@ZenIV.linux.org.uk>
 <20191130110645.GA4405@dimstar.local.net>
 <CACT4Y+bg7bZOSg0P9VXq8yG2odAJMg6b6N2fXxbamOmKiz3ohw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bg7bZOSg0P9VXq8yG2odAJMg6b6N2fXxbamOmKiz3ohw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=7QvuB2UPAAAA:8 a=edf1wS77AAAA:8
        a=hSkVLCK3AAAA:8 a=mzoz-TVAAAAA:20 a=VwQbUJbxAAAA:8 a=kGbAZRCgAAAA:20
        a=EI3vZeS8J00HEDANUmYA:9 a=CjuIK1q_8ugA:10 a=vVHabExCe68A:10
        a=PyAPxfarwdVEPLbpdMBu:22 a=DcSpbTIhAlouE1Uv7lRv:22
        a=cQPPKAXgyycSBL8etih5:22 a=AjGcO6oz07-iQ99wixmX:22
        a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 04:53:12PM +0100, Dmitry Vyukov wrote:
> On Sat, Nov 30, 2019 at 12:06 PM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > > > syzbot has bisected this bug to:
> > > >
> > > > commit 77ef8f5177599efd0cedeb52c1950c1bd73fa5e3
> > > > Author: Chris Metcalf <cmetcalf@ezchip.com>
> > > > Date:   Mon Jan 25 20:05:34 2016 +0000
> > > >
> > > >     tile kgdb: fix bug in copy to gdb regs, and optimize memset
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1131bc0ee00000
> > > > start commit:   f5b7769e Revert "debugfs: inode: debugfs_create_dir uses m..
> > > > git tree:       upstream
> > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1331bc0ee00000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1531bc0ee00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=709f8187af941e84
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=eaeb616d85c9a0afec7d
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f898f800000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147eb85f800000
> > > >
> > > > Reported-by: syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com
> > > > Fixes: 77ef8f517759 ("tile kgdb: fix bug in copy to gdb regs, and optimize
> > > > memset")
> > > >
> > > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > >
> > > Seriously?  How can the commit in question (limited to arch/tile/kernel/kgdb.c)
> > > possibly affect a bug that manages to produce a crash report with
> > > RSP: 0018:ffffffff82e03eb8  EFLAGS: 00000282
> > > RAX: 0000000000000000 RBX: ffffffff82e00000 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81088779
> > > RBP: ffffffff82e03eb8 R08: 0000000000000000 R09: 0000000000000001
> > > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff82e00000
> > > FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000c420447ff8 CR3: 0000000213184000 CR4: 00000000001406f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > in it?  Unless something very odd has happened to tile, this crash has
> > > been observed on 64bit x86; the names of registers alone are enough
> > > to be certain of that.
> > >
> > > And the binaries produced by an x86 build should not be affected by any
> > > changes in arch/tile; not unless something is very wrong with the build
> > > system.  It's not even that this commit has fixed an earlier bug that
> > > used to mask the one manifested here - it really should have had zero
> > > impact on x86 builds, period.
> > >
> > > So I'm sorry, but I'm calling bullshit.  Something's quite wrong with
> > > the bot - either its build system or the bisection process.
> >
> > The acid test would be: does reverting that commit make the problem go away?
> >
> > See, for example, https://bugzilla.kernel.org/show_bug.cgi?id=203935
> >
> > Cheers ... Duncan.
>
> This is done as part of any bisection by definition, right? The test
> was done on the previous commit (effectively this one reverted) and no
> crash was observed. Otherwise bisection would have been pointed to a
> different commit.
>
Agree that's what bisecting does. What I had in mind was to make a patch to
remove the identified commit, and apply that to the most recent revision
possible. Then see if that makes the problem go away.

However when I look at my clone of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git and compare
77ef8f5177 with the previous commit a7d1357664, "git diff --stat" shows

> 745 files changed, 8192 insertions(+), 15408 deletions(-)

The last few lines from a grep of "arch" are:

> arch/s390/oprofile/backtrace.c                     |    8 +-
> arch/tile/kernel/kgdb.c                            |    8 +-
> arch/x86/Kconfig                                   |    5 +-
> arch/x86/include/asm/livepatch.h                   |    2 +-
> arch/x86/include/asm/processor.h                   |    2 +-
> arch/x86/kernel/cpu/perf_event_amd_uncore.c        |    2 +
> arch/x86/lib/copy_user_64.S                        |  142 ++-
> arch/x86/mm/fault.c                                |   15 +-
> arch/x86/mm/gup.c                                  |    2 +-
> arch/x86/mm/numa.c                                 |    2 +-

Enough said?

Cheers ... Duncan.
