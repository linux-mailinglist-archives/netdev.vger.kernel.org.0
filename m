Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA03960EDE
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 06:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfGFE2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 00:28:38 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46831 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbfGFE2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 00:28:38 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x664S1kL020748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Jul 2019 00:28:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B345F42002E; Sat,  6 Jul 2019 00:28:01 -0400 (EDT)
Date:   Sat, 6 Jul 2019 00:28:01 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190706042801.GD11665@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
References: <000000000000d3f34b058c3d5a4f@google.com>
 <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu>
 <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190705191055.GT26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 12:10:55PM -0700, Paul E. McKenney wrote:
> 
> Exactly, so although my patch might help for CONFIG_PREEMPT=n, it won't
> help in your scenario.  But looking at the dmesg from your URL above,
> I see the following:

I just tested with CONFIG_PREEMPT=n

% grep CONFIG_PREEMPT /build/ext4-64/.config
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
# CONFIG_PREEMPTIRQ_EVENTS is not set

And with your patch, it's still not helping.

I think that's because SCHED_DEADLINE is a real-time style scheduler:

       In  order  to fulfill the guarantees that are made when a thread is ad‐
       mitted to the SCHED_DEADLINE policy,  SCHED_DEADLINE  threads  are  the
       highest  priority  (user  controllable)  threads  in the system; if any
       SCHED_DEADLINE thread is runnable, it will preempt any thread scheduled
       under one of the other policies.

So a SCHED_DEADLINE process is not going yield control of the CPU,
even if it calls cond_resched() until the thread has run for more than
the sched_runtime parameter --- which for the syzkaller repro, was set
at 26 days.

There are some safety checks when using SCHED_DEADLINE:

       The kernel requires that:

           sched_runtime <= sched_deadline <= sched_period

       In  addition,  under  the  current implementation, all of the parameter
       values must be at least 1024 (i.e., just over one microsecond, which is
       the  resolution  of the implementation), and less than 2^63.  If any of
       these checks fails, sched_setattr(2) fails with the error EINVAL.

       The  CBS  guarantees  non-interference  between  tasks,  by  throttling
       threads that attempt to over-run their specified Runtime.

       To ensure deadline scheduling guarantees, the kernel must prevent situ‐
       ations where the set of SCHED_DEADLINE threads is not feasible (schedu‐
       lable)  within  the given constraints.  The kernel thus performs an ad‐
       mittance test when setting or changing SCHED_DEADLINE  policy  and  at‐
       tributes.   This admission test calculates whether the change is feasi‐
       ble; if it is not, sched_setattr(2) fails with the error EBUSY.

The problem is that SCHED_DEADLINE is designed for sporadic tasks:

       A  sporadic  task is one that has a sequence of jobs, where each job is
       activated at most once per period.  Each job also has a relative  dead‐
       line,  before which it should finish execution, and a computation time,
       which is the CPU time necessary for executing the job.  The moment when
       a  task wakes up because a new job has to be executed is called the ar‐
       rival time (also referred to as the request time or release time).  The
       start time is the time at which a task starts its execution.  The abso‐
       lute deadline is thus obtained by adding the relative deadline  to  the
       arrival time.

It appears that kernel's admission control before allowing
SCHED_DEADLINE to be set on a thread was designed for sane
applications, and not abusive ones.  Given that process started doing
abusive things *after* SCHED_DEADLINE policy was set, in order kernel
to figure out that in fact SCHED_DEADLINE should be denied for any
arbitrary kernel thread would require either (a) solving the halting
problem, or (b) being able to anticipate the future (in which case,
we should be using that kernel algorithm to play the stock market  :-)

    	    	    	      	       - Ted
