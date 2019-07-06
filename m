Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D61611C4
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfGFPDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:03:03 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33313 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727071AbfGFPDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:03:01 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x66F2QVf014555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Jul 2019 11:02:27 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 57CD742002E; Sat,  6 Jul 2019 11:02:26 -0400 (EDT)
Date:   Sat, 6 Jul 2019 11:02:26 -0400
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
Message-ID: <20190706150226.GG11665@mit.edu>
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
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706061631.GV26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 11:16:31PM -0700, Paul E. McKenney wrote:
> I suppose RCU could take the dueling-banjos approach and use increasingly
> aggressive scheduler policies itself, up to and including SCHED_DEADLINE,
> until it started getting decent forward progress.  However, that
> sounds like the something that just might have unintended consequences,
> particularly if other kernel subsystems were to also play similar
> games of dueling banjos.

So long as the RCU threads are well-behaved, using SCHED_DEADLINE
shouldn't have much of an impact on the system --- and the scheduling
parameters that you can specify on SCHED_DEADLINE allows you to
specify the worst-case impact on the system while also guaranteeing
that the SCHED_DEADLINE tasks will urn in the first place.  After all,
that's the whole point of SCHED_DEADLINE.

So I wonder if the right approach is during the the first userspace
system call to shced_setattr to enable a (any) real-time priority
scheduler (SCHED_DEADLINE, SCHED_FIFO or SCHED_RR) on a userspace
thread, before that's allowed to proceed, the RCU kernel threads are
promoted to be SCHED_DEADLINE with appropriately set deadline
parameters.  That way, a root user won't be able to shoot the system
in the foot, and since the vast majority of the time, there shouldn't
be any processes running with real-time priorities, we won't be
changing the behavior of a normal server system.

(I suspect there might be some audio applications that might try to
set real-time priorities, but for desktop systems, it's probably more
important that the system not tie its self into knots since the
average desktop user isn't going to be well equipped to debug the
problem.)

> Alternatively, is it possible to provide stricter admission control?

I think that's an orthogonal issue; better admission control would be
nice, but it looks to me that it's going to be fundamentally an issue
of tweaking hueristics, and a fool-proof solution that will protect
against all malicious userspace applications (including syzkaller) is
going to require solving the halting problem.  So while it would be
nice to improve the admission control, I don't think that's a going to
be a general solution.

					- Ted
