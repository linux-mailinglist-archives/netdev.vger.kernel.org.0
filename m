Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77143DB25E
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392634AbfJQQaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730640AbfJQQaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:30:10 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E66FB2089C;
        Thu, 17 Oct 2019 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571329809;
        bh=LSn0Us39YQvpgHpBtDuP+bFAOJpzc9IBTOH2uPj6gn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=baztz8B1d3q8sTc8jXA1FQd061EDD0qfMar9TInei1bhpAWcztw/XO5ka5YUo0t+Z
         ONBYyr8f0yQINsfp3XcaLWZh958ZAg4Kwgzjlytr9jhJlsu8S3Njk0WWckQYOLujjy
         VIe5SyRXzf8hSOpO7bfb4YftuqOxMmfht8Hv0C+E=
Date:   Thu, 17 Oct 2019 09:30:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel panic: stack is corrupted in __lock_acquire (4)
Message-ID: <20191017163007.GC726@sol.localdomain>
Mail-Followup-To: bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <0000000000009b3b80058af452ae@google.com>
 <0000000000000ec274059185a63e@google.com>
 <CACT4Y+aT5z65OZE6_TQieU5zUYWDvDtAogC45f6ifLkshBK2iw@mail.gmail.com>
 <20191017162505.GB726@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017162505.GB726@sol.localdomain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 09:25:05AM -0700, Eric Biggers wrote:
> On Sun, Sep 01, 2019 at 08:23:42PM -0700, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> > On Sun, Sep 1, 2019 at 3:48 PM syzbot
> > <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following crash on:
> > >
> > > HEAD commit:    38320f69 Merge branch 'Minor-cleanup-in-devlink'
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d74356600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=1bbf70b6300045af
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=83979935eb6304f8cd46
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1008b232600000
> > 
> > Stack corruption + bpf maps in repro triggers some bells. +bpf mailing list.
> > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com
> > >
> > > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
> > > __lock_acquire+0x36fa/0x4c30 kernel/locking/lockdep.c:3907
> > > CPU: 0 PID: 8662 Comm: syz-executor.4 Not tainted 5.3.0-rc6+ #153
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Call Trace:
> > > Kernel Offset: disabled
> > > Rebooting in 86400 seconds..
> > >
> 
> This is still reproducible on latest net tree, but using a different kconfig I
> was able to get a more informative crash output.  Apparently tcp_bpf_unhash() is
> being called recursively.  Anyone know why this might happen?
> 
> This is using the syzkaller language reproducer linked above -- I ran it with:
> 
> 	syz-execprog -threaded=1 -collide=1 -cover=0 -repeat=0 -procs=8 -sandbox=none -enable=net_dev,net_reset,tun syz_bpf.txt
> 
> Crash report on net/master:
> 
> PANIC: double fault, error_code: 0x0
> CPU: 3 PID: 8328 Comm: syz-executor Not tainted 5.4.0-rc1-00118-ge497c20e2036 #31
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
> RIP: 0010:mark_lock+0x4/0x640 kernel/locking/lockdep.c:3631
> Code: a2 7f 27 01 85 c0 0f 84 f3 42 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 <41> 57 41 56 41 55 41 54 53 48 83 ec 18 83 fa 08 76 21 44 8b 25 ab
> RSP: 0018:ffffc9000010d000 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: 0000000000000008 RSI: ffff888071f92dd8 RDI: ffff888071f92600
> RBP: ffffc9000010d000 R08: 0000000000000000 R09: 0000000000022023
> R10: 00000000000000c8 R11: 0000000000000000 R12: ffff888071f92600
> R13: ffff888071f92dd8 R14: 0000000000000023 R15: 0000000000000000
> FS:  00007ff9f7765700(0000) GS:ffff88807fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc9000010cff8 CR3: 000000000221d000 CR4: 00000000003406e0
> Call Trace:
>  <IRQ>
>  mark_usage kernel/locking/lockdep.c:3592 [inline]
>  __lock_acquire+0x22f/0xf80 kernel/locking/lockdep.c:3909
>  lock_acquire+0x99/0x170 kernel/locking/lockdep.c:4487
>  rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
>  rcu_read_lock include/linux/rcupdate.h:599 [inline]
>  tcp_bpf_unhash+0x33/0x1d0 net/ipv4/tcp_bpf.c:549
>  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
>  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
>  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
>  tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
[...]

Recursive tcp_bpf_unhash() also showed up in
"BUG: unable to handle kernel paging request in tls_prots"
(https://lkml.kernel.org/lkml/000000000000d7bcbb058c3758a1@google.com/T/)
which was claimed to be fixed by
"bpf: sockmap/tls, close can race with map free".
But that fix was months ago; this crash is on latest net tree.

- Eric
