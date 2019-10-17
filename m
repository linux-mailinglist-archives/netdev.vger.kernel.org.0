Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B51DDB248
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502461AbfJQQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389403AbfJQQZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:25:10 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B5E52089C;
        Thu, 17 Oct 2019 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571329506;
        bh=fPrtoSkKMsDeod5OZwvm0K5duu8oXgEkGwYB4ma7Zss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPOryjVKrcnnHlYQkl3OmzXuLChwXrzfvKBUSKX7ZN5u5CmoJC+8fWEKpYtZI/u3P
         yKC+TmApLupJEimNcc/1m+As4J1jggCCmF1NLUAH26zx5xajf+qLFVaT42dn3cH1tg
         YVxQw7L8u1bxIoicQgVLvR0oIvfDM37Rye3iwSUI=
Date:   Thu, 17 Oct 2019 09:25:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Cc:     syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel panic: stack is corrupted in __lock_acquire (4)
Message-ID: <20191017162505.GB726@sol.localdomain>
Mail-Followup-To: bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <0000000000009b3b80058af452ae@google.com>
 <0000000000000ec274059185a63e@google.com>
 <CACT4Y+aT5z65OZE6_TQieU5zUYWDvDtAogC45f6ifLkshBK2iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+aT5z65OZE6_TQieU5zUYWDvDtAogC45f6ifLkshBK2iw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 01, 2019 at 08:23:42PM -0700, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Sun, Sep 1, 2019 at 3:48 PM syzbot
> <syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    38320f69 Merge branch 'Minor-cleanup-in-devlink'
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13d74356600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=1bbf70b6300045af
> > dashboard link: https://syzkaller.appspot.com/bug?extid=83979935eb6304f8cd46
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1008b232600000
> 
> Stack corruption + bpf maps in repro triggers some bells. +bpf mailing list.
> 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+83979935eb6304f8cd46@syzkaller.appspotmail.com
> >
> > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:
> > __lock_acquire+0x36fa/0x4c30 kernel/locking/lockdep.c:3907
> > CPU: 0 PID: 8662 Comm: syz-executor.4 Not tainted 5.3.0-rc6+ #153
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> >

This is still reproducible on latest net tree, but using a different kconfig I
was able to get a more informative crash output.  Apparently tcp_bpf_unhash() is
being called recursively.  Anyone know why this might happen?

This is using the syzkaller language reproducer linked above -- I ran it with:

	syz-execprog -threaded=1 -collide=1 -cover=0 -repeat=0 -procs=8 -sandbox=none -enable=net_dev,net_reset,tun syz_bpf.txt

Crash report on net/master:

PANIC: double fault, error_code: 0x0
CPU: 3 PID: 8328 Comm: syz-executor Not tainted 5.4.0-rc1-00118-ge497c20e2036 #31
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
RIP: 0010:mark_lock+0x4/0x640 kernel/locking/lockdep.c:3631
Code: a2 7f 27 01 85 c0 0f 84 f3 42 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 <41> 57 41 56 41 55 41 54 53 48 83 ec 18 83 fa 08 76 21 44 8b 25 ab
RSP: 0018:ffffc9000010d000 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffff888071f92dd8 RDI: ffff888071f92600
RBP: ffffc9000010d000 R08: 0000000000000000 R09: 0000000000022023
R10: 00000000000000c8 R11: 0000000000000000 R12: ffff888071f92600
R13: ffff888071f92dd8 R14: 0000000000000023 R15: 0000000000000000
FS:  00007ff9f7765700(0000) GS:ffff88807fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000010cff8 CR3: 000000000221d000 CR4: 00000000003406e0
Call Trace:
 <IRQ>
 mark_usage kernel/locking/lockdep.c:3592 [inline]
 __lock_acquire+0x22f/0xf80 kernel/locking/lockdep.c:3909
 lock_acquire+0x99/0x170 kernel/locking/lockdep.c:4487
 rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
 rcu_read_lock include/linux/rcupdate.h:599 [inline]
 tcp_bpf_unhash+0x33/0x1d0 net/ipv4/tcp_bpf.c:549
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_set_state+0xc1/0x220 net/ipv4/tcp.c:2249
 tcp_done+0x39/0xe0 net/ipv4/tcp.c:3854
 tcp_reset+0x5b/0x130 net/ipv4/tcp_input.c:4125
 tcp_validate_incoming+0x323/0x450 net/ipv4/tcp_input.c:5486
 tcp_rcv_established+0x138/0x6f0 net/ipv4/tcp_input.c:5694
 tcp_v6_do_rcv+0xce/0x3f0 net/ipv6/tcp_ipv6.c:1378
 tcp_v6_rcv+0xb75/0xcc0 net/ipv6/tcp_ipv6.c:1610
 ip6_protocol_deliver_rcu+0xc8/0x540 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x57/0xf0 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x40/0x1f0 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 ip6_rcv_finish+0x2f/0x60 net/ipv6/ip6_input.c:66
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x16a/0x220 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0x4e/0x70 net/core/dev.c:5010
 __netif_receive_skb+0x13/0x60 net/core/dev.c:5124
 process_backlog+0xcd/0x210 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0xf1/0x3a0 net/core/dev.c:6460
 __do_softirq+0xc1/0x40d kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>
 do_softirq.part.0+0x44/0x50 kernel/softirq.c:337
 do_softirq arch/x86/include/asm/preempt.h:26 [inline]
 __local_bh_enable_ip+0xc6/0xd0 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 inet_csk_listen_stop+0x14d/0x300 net/ipv4/inet_connection_sock.c:993
 tcp_close+0x433/0x4e0 net/ipv4/tcp.c:2352
 inet_release+0x30/0x60 net/ipv4/af_inet.c:427
 inet6_release+0x2c/0x40 net/ipv6/af_inet6.c:470
 __sock_release+0x31/0x90 net/socket.c:590
 sock_close+0x13/0x20 net/socket.c:1268
 __fput+0xca/0x250 fs/file_table.c:280
 ____fput+0x9/0x10 fs/file_table.c:313
 task_work_run+0x7b/0xb0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x292/0xb30 kernel/exit.c:817
 do_group_exit+0x4b/0xc0 kernel/exit.c:921
 get_signal+0x132/0xb70 kernel/signal.c:2734
 do_signal+0x2f/0x270 arch/x86/kernel/signal.c:815
 exit_to_usermode_loop+0x5d/0xa0 arch/x86/entry/common.c:159
 prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
 do_syscall_64+0x145/0x1a0 arch/x86/entry/common.c:300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x46165d
Code: Bad RIP value.
RSP: 002b:00007ff9f7764c58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: 00000000002774e4 RBX: 000000000052bf00 RCX: 000000000046165d
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000006
RBP: 0000000000000006 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004f3d48 R14: 00000000004b258c R15: 00007ff9f77656bc
Kernel panic - not syncing: Machine halted.
CPU: 3 PID: 8328 Comm: syz-executor Not tainted 5.4.0-rc1-00118-ge497c20e2036 #31
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
Call Trace:
 <#DF>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x70/0x9a lib/dump_stack.c:113
 panic+0xfb/0x2ba kernel/panic.c:220
 df_debug+0x29/0x33 arch/x86/kernel/doublefault.c:81
 do_double_fault+0x99/0x100 arch/x86/kernel/traps.c:420
 double_fault+0x2a/0x30 arch/x86/entry/entry_64.S:1030
RIP: 0010:mark_lock+0x4/0x640 kernel/locking/lockdep.c:3631
Code: a2 7f 27 01 85 c0 0f 84 f3 42 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 <41> 57 41 56 41 55 41 54 53 48 83 ec 18 83 fa 08 76 21 44 8b 25 ab
RSP: 0018:ffffc9000010d000 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffff888071f92dd8 RDI: ffff888071f92600
RBP: ffffc9000010d000 R08: 0000000000000000 R09: 0000000000022023
R10: 00000000000000c8 R11: 0000000000000000 R12: ffff888071f92600
R13: ffff888071f92dd8 R14: 0000000000000023 R15: 0000000000000000
 </#DF>
 <IRQ>
 mark_usage kernel/locking/lockdep.c:3592 [inline]
 __lock_acquire+0x22f/0xf80 kernel/locking/lockdep.c:3909
 lock_acquire+0x99/0x170 kernel/locking/lockdep.c:4487
 rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
 rcu_read_lock include/linux/rcupdate.h:599 [inline]
 tcp_bpf_unhash+0x33/0x1d0 net/ipv4/tcp_bpf.c:549
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_bpf_unhash+0x19b/0x1d0 net/ipv4/tcp_bpf.c:554
 tcp_set_state+0xc1/0x220 net/ipv4/tcp.c:2249
 tcp_done+0x39/0xe0 net/ipv4/tcp.c:3854
 tcp_reset+0x5b/0x130 net/ipv4/tcp_input.c:4125
 tcp_validate_incoming+0x323/0x450 net/ipv4/tcp_input.c:5486
 tcp_rcv_established+0x138/0x6f0 net/ipv4/tcp_input.c:5694
 tcp_v6_do_rcv+0xce/0x3f0 net/ipv6/tcp_ipv6.c:1378
 tcp_v6_rcv+0xb75/0xcc0 net/ipv6/tcp_ipv6.c:1610
 ip6_protocol_deliver_rcu+0xc8/0x540 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x57/0xf0 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x40/0x1f0 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 ip6_rcv_finish+0x2f/0x60 net/ipv6/ip6_input.c:66
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x16a/0x220 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0x4e/0x70 net/core/dev.c:5010
 __netif_receive_skb+0x13/0x60 net/core/dev.c:5124
 process_backlog+0xcd/0x210 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0xf1/0x3a0 net/core/dev.c:6460
 __do_softirq+0xc1/0x40d kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>
 do_softirq.part.0+0x44/0x50 kernel/softirq.c:337
 do_softirq arch/x86/include/asm/preempt.h:26 [inline]
 __local_bh_enable_ip+0xc6/0xd0 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 inet_csk_listen_stop+0x14d/0x300 net/ipv4/inet_connection_sock.c:993
 tcp_close+0x433/0x4e0 net/ipv4/tcp.c:2352
 inet_release+0x30/0x60 net/ipv4/af_inet.c:427
 inet6_release+0x2c/0x40 net/ipv6/af_inet6.c:470
 __sock_release+0x31/0x90 net/socket.c:590
 sock_close+0x13/0x20 net/socket.c:1268
 __fput+0xca/0x250 fs/file_table.c:280
 ____fput+0x9/0x10 fs/file_table.c:313
 task_work_run+0x7b/0xb0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x292/0xb30 kernel/exit.c:817
 do_group_exit+0x4b/0xc0 kernel/exit.c:921
 get_signal+0x132/0xb70 kernel/signal.c:2734
 do_signal+0x2f/0x270 arch/x86/kernel/signal.c:815
 exit_to_usermode_loop+0x5d/0xa0 arch/x86/entry/common.c:159
 prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
 do_syscall_64+0x145/0x1a0 arch/x86/entry/common.c:300
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x46165d
Code: Bad RIP value.
RSP: 002b:00007ff9f7764c58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: 00000000002774e4 RBX: 000000000052bf00 RCX: 000000000046165d
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000006
RBP: 0000000000000006 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000004f3d48 R14: 00000000004b258c R15: 00007ff9f77656bc
Kernel Offset: disabled
Rebooting in 5 seconds..
