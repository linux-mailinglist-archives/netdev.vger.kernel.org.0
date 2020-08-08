Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9749D23F882
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHHSyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:54:02 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39572 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHHSyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 14:54:01 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 078IrgGu007509;
        Sat, 8 Aug 2020 20:53:42 +0200
Date:   Sat, 8 Aug 2020 20:53:42 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808185342.GA7499@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 11:19:01AM -0700, Linus Torvalds wrote:
> On Sat, Aug 8, 2020 at 10:45 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> >
> >     WIP: random32: use siphash with a counter for prandom_u32
> 
> siphash is good.
> 
> But no:
> 
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1277,7 +1277,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
> >
> >         fast_mix(fast_pool);
> >         add_interrupt_bench(cycles);
> > -       this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
> >
> >         if (unlikely(crng_init == 0)) {
> >                 if ((fast_pool->count >= 64) &&
> > --- a/include/linux/random.h
> > +++ b/include/linux/random.h
> > diff --git a/kernel/time/timer.c b/kernel/time/timer.c
> > index 026ac01af9da..c9d839c2b179 100644
> > --- a/kernel/time/timer.c
> > +++ b/kernel/time/timer.c
> > @@ -1743,13 +1743,6 @@ void update_process_times(int user_tick)
> >         scheduler_tick();
> >         if (IS_ENABLED(CONFIG_POSIX_TIMERS))
> >                 run_posix_cpu_timers();
> > -
> > -       /* The current CPU might make use of net randoms without receiving IRQs
> > -        * to renew them often enough. Let's update the net_rand_state from a
> > -        * non-constant value that's not affine to the number of calls to make
> > -        * sure it's updated when there's some activity (we don't care in idle).
> > -        */
> > -       this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
> >  }
> 
> We're not going back to "don't add noise, just make a stronger
> analyzable function".
> 
> I simply won't take it. See my previous email. I'm 100% fed up with
> security people screwing up real security by trying to make things
> overly analyzable.
> 
> If siphash is a good enough hash to make the pseudo-random state hard
> to guess, then it's also a good enough hash to hide the small part of
> the fast-pool we mix in.

I'm totally fine with that. In fact, my secret goal there was to put
net_rand_state back to random32.c as a static and reinstall the
__latent_entropy that we had to remove :-)

I'll need to re-run more correct tests though. My measurements were
really erratic with some of them showing half an HTTP request rate in
a test, which makes absolutely no sense and thus disqualifies my
measurements.

But if the results are correct enough I'm fine with continuing on this
one and forgetting MSWS.

> And while security researchers may hate it because it's hard to
> analyze, that's the POINT, dammit.

Actually I think there are two approaches which explains the constant
disagreements in this area. Some people want something provably
difficult, and others want something that cannot be proven to be easy. 
Sadly by trying to please everyone we probably got something between
provably easy and not provably difficult :-/

Willy
