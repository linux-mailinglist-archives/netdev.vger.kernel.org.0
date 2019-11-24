Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9301084C1
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 20:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfKXTaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 14:30:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51292 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbfKXTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 14:30:46 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYxad-0005Jj-31; Sun, 24 Nov 2019 19:30:35 +0000
Date:   Sun, 24 Nov 2019 19:30:35 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     syzbot <syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com>
Cc:     cmetcalf@ezchip.com, coreteam@netfilter.org, davem@davemloft.net,
        dvyukov@google.com, gang.chen.5i5j@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in blkdev_get
Message-ID: <20191124193035.GA4203@ZenIV.linux.org.uk>
References: <000000000000e59aab056e8873ae@google.com>
 <0000000000000beff305981c5ac6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000beff305981c5ac6@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 11:07:00AM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 77ef8f5177599efd0cedeb52c1950c1bd73fa5e3
> Author: Chris Metcalf <cmetcalf@ezchip.com>
> Date:   Mon Jan 25 20:05:34 2016 +0000
> 
>     tile kgdb: fix bug in copy to gdb regs, and optimize memset
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1131bc0ee00000
> start commit:   f5b7769e Revert "debugfs: inode: debugfs_create_dir uses m..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1331bc0ee00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1531bc0ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=709f8187af941e84
> dashboard link: https://syzkaller.appspot.com/bug?extid=eaeb616d85c9a0afec7d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177f898f800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147eb85f800000
> 
> Reported-by: syzbot+eaeb616d85c9a0afec7d@syzkaller.appspotmail.com
> Fixes: 77ef8f517759 ("tile kgdb: fix bug in copy to gdb regs, and optimize
> memset")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Seriously?  How can the commit in question (limited to arch/tile/kernel/kgdb.c)
possibly affect a bug that manages to produce a crash report with
RSP: 0018:ffffffff82e03eb8  EFLAGS: 00000282                                    
RAX: 0000000000000000 RBX: ffffffff82e00000 RCX: 0000000000000000               
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81088779               
RBP: ffffffff82e03eb8 R08: 0000000000000000 R09: 0000000000000001               
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000               
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff82e00000               
FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000    
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                               
CR2: 000000c420447ff8 CR3: 0000000213184000 CR4: 00000000001406f0               
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000               
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400               
in it?  Unless something very odd has happened to tile, this crash has
been observed on 64bit x86; the names of registers alone are enough
to be certain of that.

And the binaries produced by an x86 build should not be affected by any
changes in arch/tile; not unless something is very wrong with the build
system.  It's not even that this commit has fixed an earlier bug that
used to mask the one manifested here - it really should have had zero
impact on x86 builds, period.

So I'm sorry, but I'm calling bullshit.  Something's quite wrong with
the bot - either its build system or the bisection process.
