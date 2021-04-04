Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE353538E8
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhDDQsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 12:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDQsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 12:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8878D611EE;
        Sun,  4 Apr 2021 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617554888;
        bh=QUr1gQxf6jJS+ODZ+iLdVkjemdcz//8lKpHHLvAbIWA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=TyLMQXppRprF+0uf++bX6bWBSPvGuVfaojRHGxi5sgmi/CUEZSFZAyGyAX63JOzyr
         Pss7wpFCfQst4uMqXiBIMFWj3PyDmK+SlUUBLfFPsnQJ5bzKA6/TOiG0dlDxSsY5Gq
         XmnGaIgY0FaqD50APy2iIXZ1v2O9637LREOdIezFfNxdtxVWYYN64keFkqw1Py4Fcg
         lj53fxfxhshGLys+UOLdTA9yebyFYhkun9nC8LYGJZA8nJPznjJoKZ1uaUotDSWnJ4
         2RZO/7A8G12YJ3fpjwkSXZvaJmPGb/yAoBzBmuLny5dHjDfk0aZOgT6TOhIF+6p+YD
         xziVp8ASmjujg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5B7F33521AB4; Sun,  4 Apr 2021 09:48:08 -0700 (PDT)
Date:   Sun, 4 Apr 2021 09:48:08 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+dde0cc33951735441301@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        frederic@kernel.org
Subject: Re: Something is leaking RCU holds from interrupt context
Message-ID: <20210404164808.GZ2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <00000000000025a67605bf1dd4ab@google.com>
 <20210404102457.GS351017@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404102457.GS351017@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 11:24:57AM +0100, Matthew Wilcox wrote:
> On Sat, Apr 03, 2021 at 09:15:17PM -0700, syzbot wrote:
> > HEAD commit:    2bb25b3a Merge tag 'mips-fixes_5.12_3' of git://git.kernel..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1284cc31d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dde0cc33951735441301
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+dde0cc33951735441301@syzkaller.appspotmail.com
> > 
> > WARNING: suspicious RCU usage
> > 5.12.0-rc5-syzkaller #0 Not tainted
> > -----------------------------
> > kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!
> > 
> > other info that might help us debug this:
> > 
> > 
> > rcu_scheduler_active = 2, debug_locks = 0
> > no locks held by systemd-udevd/4825.
> 
> I think we have something that's taking the RCU read lock in
> (soft?) interrupt context and not releasing it properly in all
> situations.  This thread doesn't have any locks recorded, but
> lock_is_held(&rcu_bh_lock_map) is true.
> 
> Is there some debugging code that could find this?  eg should
> lockdep_softirq_end() check that rcu_bh_lock_map is not held?
> (if it's taken in process context, then BHs can't run, so if it's
> held at softirq exit, then there's definitely a problem).

Something like the (untested) patch below?

Please note that it does not make sense to also check for
either rcu_lock_map or rcu_sched_lock_map because either of
these might be held by the interrupted code.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 42f3f8c..e4ad0a6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -504,6 +504,7 @@ static inline void lockdep_softirq_end(bool in_hardirq)
 {
 	lockdep_softirq_exit();
 
+	RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map));
 	if (in_hardirq)
 		lockdep_hardirq_enter();
 }
