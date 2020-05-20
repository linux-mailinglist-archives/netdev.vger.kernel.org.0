Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3841DA796
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgETB4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgETB4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 21:56:15 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA96C061A0E;
        Tue, 19 May 2020 18:56:15 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbDxG-0005nh-7R; Wed, 20 May 2020 03:55:34 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 77588100D00; Wed, 20 May 2020 03:55:33 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a seqcount
In-Reply-To: <20200519170637.56d1a20a@hermes.lan>
References: <20200519214547.352050-1-a.darwish@linutronix.de> <20200519214547.352050-2-a.darwish@linutronix.de> <20200519150159.4d91af93@hermes.lan> <87v9kr5zt7.fsf@nanos.tec.linutronix.de> <20200519161141.5fbab730@hermes.lan> <87lfln5w61.fsf@nanos.tec.linutronix.de> <20200519170637.56d1a20a@hermes.lan>
Date:   Wed, 20 May 2020 03:55:33 +0200
Message-ID: <87d06z5q0a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:
> On Wed, 20 May 2020 01:42:30 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> Stephen Hemminger <stephen@networkplumber.org> writes:
>> > On Wed, 20 May 2020 00:23:48 +0200
>> > Thomas Gleixner <tglx@linutronix.de> wrote:  
>> >> No. We did not. -ENOTESTCASE  
>> >
>> > Please try, it isn't that hard..
>> >
>> > # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
>> >
>> > real	0m17.002s
>> > user	0m1.064s
>> > sys	0m0.375s  
>> 
>> And that solves the incorrectness of the current code in which way?
>
> Agree that the current code is has evolved over time to a state where it is not
> correct in the case of Preempt-RT.

That's not a RT problem as explained in great length in the changelog
and as I pointed out in my previous reply.

 Realtime scheduling classes are available on stock kernels and all
 those attempts to "fix" the livelock problem are ignoring that fact.

Just because you or whoever involved are not using them or do not care
is not making the code more correct.

> The motivation for the changes to seqcount goes back many years when
> there were ISP's that were concerned about scaling of tunnels, vlans
> etc.

I completely understand where this comes from, but that is not a
justification for incorrect code at all.

> Is it too much to ask for a simple before/after test of your patch as part 
> of the submission. You probably measure latency changes to the
> nanosecond.

It's not too much to ask and I'm happy to provide the numbers.

But before I waste my time and produce them, can you please explain how
any numbers provided are going to change the fact that the code is
incorrect?

  A bug, is a bug no matter what the numbers are.

I don't have a insta reproducer at hand for the problem which made that
code go belly up, but the net result is simply:

      Before:			After:
	real	INFINTE         0mxx.yyys

And the 'Before' comes with the extra benefit of stall warnings (if
enabled in the config).

If you insist I surely can go the extra mile and write up the insta
reproducer and stick it into a bugzilla for you.

Thanks,

        tglx
