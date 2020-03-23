Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B153E18EE27
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCWCzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgCWCzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 22:55:03 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A325C20722;
        Mon, 23 Mar 2020 02:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584932101;
        bh=N0k6o8c8KvYw0g3jcUDhN/MPud7VOyTsnr0yHrUxgUw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=g9VPl4eajjddjNIOPzBfeSyOtL9KQiSn/FZzz7hTPVSKlmvRnqj3azUI4CLLkZJvc
         uYirLjF1H+fdvZlmKyt2AxGT61givxo81nRhOvH91ViOca/11r46Ug+bKaoJ8lwwc0
         hRh7PEZEFJGW9zuLBEKdZoD1kcl6jFPVucBD+M6Y=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 72D1C35226BE; Sun, 22 Mar 2020 19:55:01 -0700 (PDT)
Date:   Sun, 22 Mar 2020 19:55:01 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [patch V3 13/20] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200323025501.GE3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200321112544.878032781@linutronix.de>
 <20200321113242.026561244@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321113242.026561244@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 12:25:57PM +0100, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The kernel provides a variety of locking primitives. The nesting of these
> lock types and the implications of them on RT enabled kernels is nowhere
> documented.
> 
> Add initial documentation.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Paul E . McKenney" <paulmck@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> ---
> V3: Addressed review comments from Paul, Jonathan, Davidlohr
> V2: Addressed review comments from Randy
> ---
>  Documentation/locking/index.rst     |    1 
>  Documentation/locking/locktypes.rst |  299 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 300 insertions(+)
>  create mode 100644 Documentation/locking/locktypes.rst
> 
> --- a/Documentation/locking/index.rst
> +++ b/Documentation/locking/index.rst
> @@ -7,6 +7,7 @@ locking
>  .. toctree::
>      :maxdepth: 1
>  
> +    locktypes
>      lockdep-design
>      lockstat
>      locktorture
> --- /dev/null
> +++ b/Documentation/locking/locktypes.rst
> @@ -0,0 +1,299 @@

[ . . . Adding your example execution sequences . . . ]

> +PREEMPT_RT kernels preserve all other spinlock_t semantics:
> +
> + - Tasks holding a spinlock_t do not migrate.  Non-PREEMPT_RT kernels
> +   avoid migration by disabling preemption.  PREEMPT_RT kernels instead
> +   disable migration, which ensures that pointers to per-CPU variables
> +   remain valid even if the task is preempted.
> +
> + - Task state is preserved across spinlock acquisition, ensuring that the
> +   task-state rules apply to all kernel configurations.  Non-PREEMPT_RT
> +   kernels leave task state untouched.  However, PREEMPT_RT must change
> +   task state if the task blocks during acquisition.  Therefore, it saves
> +   the current task state before blocking and the corresponding lock wakeup
> +   restores it.
> +
> +   Other types of wakeups would normally unconditionally set the task state
> +   to RUNNING, but that does not work here because the task must remain
> +   blocked until the lock becomes available.  Therefore, when a non-lock
> +   wakeup attempts to awaken a task blocked waiting for a spinlock, it
> +   instead sets the saved state to RUNNING.  Then, when the lock
> +   acquisition completes, the lock wakeup sets the task state to the saved
> +   state, in this case setting it to RUNNING.

In the normal case where the task sleeps through the entire lock
acquisition, the sequence of events is as follows:

     state = UNINTERRUPTIBLE
     lock()
       block()
         real_state = state
         state = SLEEPONLOCK

                               lock wakeup
                                 state = real_state == UNINTERRUPTIBLE

This sequence of events can occur when the task acquires spinlocks
on its way to sleeping, for example, in a call to wait_event().

The non-lock wakeup can occur when a wakeup races with this wait_event(),
which can result in the following sequence of events:

     state = UNINTERRUPTIBLE
     lock()
       block()
         real_state = state
         state = SLEEPONLOCK

                             non lock wakeup
                                 real_state = RUNNING

                               lock wakeup
                                 state = real_state == RUNNING

Without this real_state subterfuge, the wakeup might be lost.

[ . . . and continuing where I left off earlier . . . ]

> +bit spinlocks
> +-------------
> +
> +Bit spinlocks are problematic for PREEMPT_RT as they cannot be easily
> +substituted by an RT-mutex based implementation for obvious reasons.
> +
> +The semantics of bit spinlocks are preserved on PREEMPT_RT kernels and the
> +caveats vs. raw_spinlock_t apply.
> +
> +Some bit spinlocks are substituted by regular spinlock_t for PREEMPT_RT but
> +this requires conditional (#ifdef'ed) code changes at the usage site while
> +the spinlock_t substitution is simply done by the compiler and the
> +conditionals are restricted to header files and core implementation of the
> +locking primitives and the usage sites do not require any changes.

PREEMPT_RT cannot substitute bit spinlocks because a single bit is
too small to accommodate an RT-mutex.  Therefore, the semantics of bit
spinlocks are preserved on PREEMPT_RT kernels, so that the raw_spinlock_t
caveats also apply to bit spinlocks.

Some bit spinlocks are replaced with regular spinlock_t for PREEMPT_RT
using conditional (#ifdef'ed) code changes at the usage site.
In contrast, usage-site changes are not needed for the spinlock_t
substitution.  Instead, conditionals in header files and the core locking
implemementation enable the compiler to do the substitution transparently.


> +Lock type nesting rules
> +=======================
> +
> +The most basic rules are:
> +
> +  - Lock types of the same lock category (sleeping, spinning) can nest
> +    arbitrarily as long as they respect the general lock ordering rules to
> +    prevent deadlocks.

  - Lock types in the same category (sleeping, spinning) can nest
     arbitrarily as long as they respect the general deadlock-avoidance
     ordering rules.

[ Give or take lockdep eventually complaining about too-deep nesting,
  but that is probably not worth mentioning here.  Leave that caveat
  to the lockdep documentation. ]

> +  - Sleeping lock types cannot nest inside spinning lock types.
> +
> +  - Spinning lock types can nest inside sleeping lock types.
> +
> +These rules apply in general independent of CONFIG_PREEMPT_RT.

These constraints apply both in CONFIG_PREEMPT_RT and otherwise.

> +As PREEMPT_RT changes the lock category of spinlock_t and rwlock_t from
> +spinning to sleeping this has obviously restrictions how they can nest with
> +raw_spinlock_t.
> +
> +This results in the following nest ordering:

The fact that PREEMPT_RT changes the lock category of spinlock_t and
rwlock_t from spinning to sleeping means that they cannot be acquired
while holding a raw spinlock.  This results in the following nesting
ordering:

> +  1) Sleeping locks
> +  2) spinlock_t and rwlock_t
> +  3) raw_spinlock_t and bit spinlocks
> +
> +Lockdep is aware of these constraints to ensure that they are respected.

Lockdep will complain if these constraints are violated, both in
CONFIG_PREEMPT_RT and otherwise.


> +Owner semantics
> +===============
> +
> +Most lock types in the Linux kernel have strict owner semantics, i.e. the
> +context (task) which acquires a lock has to release it.

The aforementioned lock types have strict owner semantics: The context
(task) that acquired the lock must release it.

> +There are two exceptions:
> +
> +  - semaphores
> +  - rwsems
> +
> +semaphores have no owner semantics for historical reason, and as such
> +trylock and release operations can be called from any context. They are
> +often used for both serialization and waiting purposes. That's generally
> +discouraged and should be replaced by separate serialization and wait
> +mechanisms, such as mutexes and completions.

semaphores lack owner semantics for historical reasons, so their trylock
and release operations may be called from any context. They are often
used for both serialization and waiting, but new use cases should
instead use separate serialization and wait mechanisms, such as mutexes
and completions.

> +rwsems have grown interfaces which allow non owner release for special
> +purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
> +substitutes all locking primitives except semaphores with RT-mutex based
> +implementations to provide priority inheritance for all lock types except
> +the truly spinning ones. Priority inheritance on ownerless locks is
> +obviously impossible.
> +
> +For now the rwsem non-owner release excludes code which utilizes it from
> +being used on PREEMPT_RT enabled kernels. In same cases this can be
> +mitigated by disabling portions of the code, in other cases the complete
> +functionality has to be disabled until a workable solution has been found.

rwsems have grown special-purpose interfaces that allow non-owner release.
This non-owner release prevents PREEMPT_RT from substituting RT-mutex
implementations, for example, by defeating priority inheritance.
After all, if the lock has no owner, whose priority should be boosted?
As a result, PREEMPT_RT does not currently support rwsem, which in turn
means that code using it must therefore be disabled until a workable
solution presents itself.

[ Note: Not as confident as I would like to be in the above. ]

							Thanx, Paul
