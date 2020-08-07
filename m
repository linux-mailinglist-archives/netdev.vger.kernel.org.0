Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984B323E786
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHGHEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:04:08 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39482 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGHEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 03:04:06 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07773GxM006383;
        Fri, 7 Aug 2020 09:03:16 +0200
Date:   Fri, 7 Aug 2020 09:03:16 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200807070316.GA6357@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 10:18:55AM -0700, Marc Plumb wrote:
> Willy,
> 
> 
> On 2020-08-05 11:30 p.m., Willy Tarreau wrote:
> > On Wed, Aug 05, 2020 at 03:21:11PM -0700, Marc Plumb wrote:
> > > There is nothing wrong with perturbing net_rand_state, the sin is doing it
> > > with the raw entropy that is also the seed for your CPRNG. Use the output of
> > > a CPRNG to perturb the pool all you want, but don't do things that bit by
> > > bit reveal the entropy that is being fed into the CPRNG.
> > This is interesting because I think some of us considered it exactly the
> > other way around, i.e. we're not copying exact bits but just taking a
> > pseudo-random part of such bits at one point in time, to serve as an
> > increment among other ones. And given that these bits were collected
> > over time from not very secret sources, they appeared to be of lower
> > risk than the output.
> 
> No. The output of a CPRNG can't be used to determine the internal state. The
> input can. The input entropy is the one thing that cannot be produced by a
> deterministic computer, so they are the crown jewels of this. It's much much
> safer to use the output.

OK, noted.

> > I didn't know about SFC32, it looks like a variation of the large family
> > of xorshift generators, which is thus probably quite suitable as well
> > for this task. Having used xoroshiro128** myself in another project, I
> > found it overkill for this task compared to MSWS but I definitely agree
> > that any of them is more suited to the task than the current one.
> > 
> It's actually a chaotic generator (not a linear one like an xorshift
> generator), which gives it weaker period guarantees which makes it more
> difficult to reverse. With a counter added to help the period length.
> 
> I'll trust Amit that SFC32 isn't strong enough and look at other options --
> I just thought of it as better, and faster than the existing one with the
> same state size. Maybe a larger state is needed.

Just to give a heads up on this, here's what I'm having pending regarding
MSWS:

  struct rnd_state {
        uint64_t x, w;
        uint64_t seed;
        uint64_t noise;
  };

  uint32_t msws32(struct rnd_state *state)
  {
        uint64_t x;

        x  = state->w += state->seed;
        x += state->x * state->x;
        x  = state->x = (x >> 32) | (x << 32);
        x -= state->noise++;
        return x ^ (x >> 32);
  }

It passes PractRand without any warning after 1 TB of data:

  rng=RNG_stdin, seed=unknown
  length= 512 megabytes (2^29 bytes), time= 2.0 seconds
    no anomalies in 229 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 1 gigabyte (2^30 bytes), time= 4.3 seconds
    no anomalies in 248 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 2 gigabytes (2^31 bytes), time= 8.3 seconds
    no anomalies in 266 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 4 gigabytes (2^32 bytes), time= 15.8 seconds
    no anomalies in 282 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 8 gigabytes (2^33 bytes), time= 31.3 seconds
    no anomalies in 299 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 16 gigabytes (2^34 bytes), time= 61.9 seconds
    no anomalies in 315 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 32 gigabytes (2^35 bytes), time= 119 seconds
    no anomalies in 328 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 64 gigabytes (2^36 bytes), time= 242 seconds
    no anomalies in 344 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 128 gigabytes (2^37 bytes), time= 483 seconds
    no anomalies in 359 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 256 gigabytes (2^38 bytes), time= 940 seconds
    no anomalies in 372 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 512 gigabytes (2^39 bytes), time= 1906 seconds
    no anomalies in 387 test result(s)
  
  rng=RNG_stdin, seed=unknown
  length= 1 terabyte (2^40 bytes), time= 3826 seconds
    no anomalies in 401 test result(s)

The two modifications compared to the original msws are:

  - mix bits on output so that we don't reveal the internal
    state upon each call ;

  - combination of the output with an independent noise
    variable whose purpose was to be updated upon IRQ
    and/or CPU usage and/or invocations. But on this point,
    while implementing it I figured that updating it on each
    invocation did already provide the frequent updates we
    were missing in Tausworthe that required the interrupt
    updates. I'd definitely update in update_process_times()
    so that it's not reduced to a pure counter, but the
    results, speed and simplicity look encouraging.

I'll try to work on finishing the patch proposal this week-end.

Regards,
Willy
