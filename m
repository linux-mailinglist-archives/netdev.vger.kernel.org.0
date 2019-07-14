Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89542680EA
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfGNTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:05:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52524 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728297AbfGNTF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:05:57 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x6EJ5MVD000308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 15:05:23 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 804A3420036; Sun, 14 Jul 2019 15:05:22 -0400 (EDT)
Date:   Sun, 14 Jul 2019 15:05:22 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
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
Message-ID: <20190714190522.GA24049@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
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
References: <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> But short term I don't see any other solution than stop testing
> sched_setattr because it does not check arguments enough to prevent
> system misbehavior. Which is a pity because syzkaller has found some
> bad misconfigurations that were oversight on checking side.
> Any other suggestions?

Or maybe syzkaller can put its own limitations on what parameters are
sent to sched_setattr?  In practice, there are any number of ways a
root user can shoot themselves in the foot when using sched_setattr or
sched_setaffinity, for that matter.  I imagine there must be some such
constraints already --- or else syzkaller might have set a kernel
thread to run with priority SCHED_BATCH, with similar catastrophic
effects --- or do similar configurations to make system threads
completely unschedulable.

Real time administrators who know what they are doing --- and who know
that their real-time threads are well behaved --- will always want to
be able to do things that will be catastrophic if the real-time thread
is *not* well behaved.  I don't it is possible to add safety checks
which would allow the kernel to automatically detect and reject unsafe
configurations.

An apt analogy might be civilian versus military aircraft.  Most
airplanes are designed to be "inherently stable"; that way, modulo
buggy/insane control systems like on the 737 Max, the airplane will
automatically return to straight and level flight.  On the other hand,
some military planes (for example, the F-16, F-22, F-36, the
Eurofighter, etc.) are sometimes designed to be unstable, since that
way they can be more maneuverable.

There are use cases for real-time Linux where this flexibility/power
vs. stability tradeoff is going to argue for giving root the
flexibility to crash the system.  Some of these systems might
literally involve using real-time Linux in military applications,
something for which Paul and I have had some experience.  :-)

Speaking of sched_setaffinity, one thing which we can do is have
syzkaller move all of the system threads to they run on the "system
CPU's", and then move the syzkaller processes which are testing the
kernel to be on the "system under test CPU's".  Then regardless of
what priority the syzkaller test programs try to run themselves at,
they can't crash the system.

Some real-time systems do actually run this way, and it's a
recommended configuration which is much safer than letting the
real-time threads take over the whole system:

http://linuxrealtime.org/index.php/Improving_the_Real-Time_Properties#Isolating_the_Application

					- Ted

