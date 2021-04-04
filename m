Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD143537C3
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhDDKZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 06:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhDDKZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 06:25:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7C5C061756;
        Sun,  4 Apr 2021 03:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WSf1ZcBtiuY+N1FqIxR0B2fClvFN9W6AWwRWELkXbQ0=; b=sCMSYiGXQn4+RRQyQAvrCQ5p5x
        AhkCCk+BQTk0bpflPpg0g1DDfJ9Cq6vrRBvuBwtjI/vduSb6To1fMD8gfGPYwQMK80yWTALv6mkkb
        gEbSAJtamdJ9TU6PZzSBXwQHYBbHoEgGnkNtz88VdqWMb0ZhxMuyF5UtQD6HyFmg2eDM9cKi2Fb/N
        FNtCwj3AD+1KyFS/YXwyn4u/xZM9ZME3Ypy2dm1x3L97fgl2wAUd88IcRpD/NO2/cTnouGP3LT/+m
        EOW5CWR4Dj7n7uS59ofiNOc941oTHju11Z68JVElsfrksKLjxruEBPhP9HO0AyU6qfqrJsQXMbuig
        G0+rRJeg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSzw9-00A0vq-4g; Sun, 04 Apr 2021 10:24:57 +0000
Date:   Sun, 4 Apr 2021 11:24:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+dde0cc33951735441301@syzkaller.appspotmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        frederic@kernel.org, paulmck@kernel.org
Subject: Something is leaking RCU holds from interrupt context
Message-ID: <20210404102457.GS351017@casper.infradead.org>
References: <00000000000025a67605bf1dd4ab@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000025a67605bf1dd4ab@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 09:15:17PM -0700, syzbot wrote:
> HEAD commit:    2bb25b3a Merge tag 'mips-fixes_5.12_3' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1284cc31d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
> dashboard link: https://syzkaller.appspot.com/bug?extid=dde0cc33951735441301
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dde0cc33951735441301@syzkaller.appspotmail.com
> 
> WARNING: suspicious RCU usage
> 5.12.0-rc5-syzkaller #0 Not tainted
> -----------------------------
> kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 0
> no locks held by systemd-udevd/4825.

I think we have something that's taking the RCU read lock in
(soft?) interrupt context and not releasing it properly in all
situations.  This thread doesn't have any locks recorded, but
lock_is_held(&rcu_bh_lock_map) is true.

Is there some debugging code that could find this?  eg should
lockdep_softirq_end() check that rcu_bh_lock_map is not held?
(if it's taken in process context, then BHs can't run, so if it's
held at softirq exit, then there's definitely a problem).

> stack backtrace:
> CPU: 0 PID: 4825 Comm: systemd-udevd Not tainted 5.12.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ___might_sleep+0x229/0x2c0 kernel/sched/core.c:8294
>  __might_fault+0x6e/0x180 mm/memory.c:5018
>  strncpy_from_user+0x2f/0x3e0 lib/strncpy_from_user.c:117
>  getname_flags.part.0+0x95/0x4f0 fs/namei.c:149
>  getname_flags fs/namei.c:2733 [inline]
>  user_path_at_empty+0xa1/0x100 fs/namei.c:2733
>  user_path_at include/linux/namei.h:60 [inline]
>  do_faccessat+0x127/0x850 fs/open.c:425
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Nothing in this path calls rcu_read_lock_bh().  It's almost exclusively
used by the networking code.
