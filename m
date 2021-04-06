Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50D354EB9
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbhDFIdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbhDFIdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:33:53 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84996C06174A;
        Tue,  6 Apr 2021 01:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wOOvbvczBiqDUD1z9pJzeLiPhATvYrqx3RE9Hb+eT8I=; b=SjVFPWxveC/8e8EIbcjSMdBpLP
        VkEzTkJad1jAtUK+M4B4jStCCl7tHk3qH/zi0s32A/0NFHArNrfl/oDm+PXQlfQ6uT2/2MbTcEnw7
        64aaIxw6rQ5SKFeA6HDQWd6+9yo9qWTX0JrpqbwCKsvM8EInotd+Ug3ztl3ezeb+KNq8MbdnVqGde
        LdHPFL+r0DoIDmPIQGvbmSt18HteM9uUIgqVwG4tdTLUOarUvhQbFc2Ye0LtUyebDAT128fcaAW+7
        iP7R8QQXM26jTfrTzdyHfbVzyqnPytYGP570R/bsclofCma5ZgI/OdpKKYmd3izqPjsKtvsadjRcT
        5ECNB2yA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lTh9K-001t7Z-Tk; Tue, 06 Apr 2021 08:33:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7D650301179;
        Tue,  6 Apr 2021 10:33:25 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6B80D2BAE8C22; Tue,  6 Apr 2021 10:33:25 +0200 (CEST)
Date:   Tue, 6 Apr 2021 10:33:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+dde0cc33951735441301@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        netdev@vger.kernel.org, tglx@linutronix.de, frederic@kernel.org,
        paulmck@kernel.org
Subject: Re: Something is leaking RCU holds from interrupt context
Message-ID: <YGwc1d8049ySxfPE@hirez.programming.kicks-ass.net>
References: <00000000000025a67605bf1dd4ab@google.com>
 <20210404102457.GS351017@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404102457.GS351017@casper.infradead.org>
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

Hmm, I'm sure i've written something like that at least once, but I
can't seem to find it :/

Does something like the completely untested below work for you?

---

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 600c10da321a..d8aa1dc481b6 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -54,6 +54,8 @@ extern void trace_hardirqs_off_finish(void);
 extern void trace_hardirqs_on(void);
 extern void trace_hardirqs_off(void);
 
+extern void lockdep_validate_context_empty(void);
+
 # define lockdep_hardirq_context()	(raw_cpu_read(hardirq_context))
 # define lockdep_softirq_context(p)	((p)->softirq_context)
 # define lockdep_hardirqs_enabled()	(this_cpu_read(hardirqs_enabled))
@@ -69,6 +71,7 @@ do {						\
 } while (0)
 # define lockdep_hardirq_exit()			\
 do {						\
+	lockdep_validate_context_empty();	\
 	__this_cpu_dec(hardirq_context);	\
 } while (0)
 # define lockdep_softirq_enter()		\
@@ -77,6 +80,7 @@ do {						\
 } while (0)
 # define lockdep_softirq_exit()			\
 do {						\
+	lockdep_validate_context_empty();	\
 	current->softirq_context--;		\
 } while (0)
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 82db977eada8..09ac70d1b3a6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2697,6 +2697,37 @@ static int check_irq_usage(struct task_struct *curr, struct held_lock *prev,
 	return 0;
 }
 
+void lockdep_validate_context_empty(void)
+{
+	struct task_struct *curr = current;
+	int depth, ctx = task_irq_context(curr);
+
+	if (debug_locks_silent)
+		return;
+
+	depth = curr->lockdep_depth;
+	if (!depth)
+		return;
+
+	if (curr->held_locks[depth-1].irq_context != ctx)
+		return;
+
+
+	pr_warn("\n");
+	pr_warn("====================================\n");
+	pr_warn("WARNING: Asymmetric locking detected\n");
+	print_kernel_ident();
+	pr_warn("------------------------------------\n");
+
+	pr_warn("%s/%d is leaving an IRQ context with extra locks on\n",
+		curr->comm, task_pid_nr(curr));
+
+	lockdep_printk_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+}
+
 #else
 
 static inline int check_irq_usage(struct task_struct *curr,

