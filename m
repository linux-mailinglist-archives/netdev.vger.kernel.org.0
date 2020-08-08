Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB94823F90B
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHHVSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:18:34 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39583 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgHHVSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 17:18:34 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 078LIBKu007551;
        Sat, 8 Aug 2020 23:18:11 +0200
Date:   Sat, 8 Aug 2020 23:18:11 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Florian Westphal <fw@strlen.de>
Cc:     George Spelvin <lkml@sdf.org>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808211811.GA7543@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
 <20200808191827.GA19310@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808191827.GA19310@breakpoint.cc>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sat, Aug 08, 2020 at 09:18:27PM +0200, Florian Westphal wrote:
> >  struct rnd_state {
> > -	__u32 s1, s2, s3, s4;
> > +	siphash_key_t key;
> > +	uint64_t counter;
> >  };
> 
> Does the siphash_key really need to be percpu?

I don't think so, I was really exploring a quick and easy change, and
given that it was convenient to put that into rnd_state to ease
adaptation to existing code, I left it here.

> The counter is different of course.
> Alternative would be to siphash a few prandom_u32 results
> if the extra u64 is too much storage.

I don't think we need to make it complicated. If we can implement a
partial siphash that's fast enough and that makes everyone happy, it
will also not take too much space so that could become an overall
improvement (and I'd say that reconciling everyone would also be a
huge improvement).

> >  DECLARE_PER_CPU(struct rnd_state, net_rand_state);
> > @@ -161,12 +163,14 @@ static inline u32 __seed(u32 x, u32 m)
> >   */
> >  static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
> >  {
> > +#if 0
> >  	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
> >  
> >  	state->s1 = __seed(i,   2U);
> >  	state->s2 = __seed(i,   8U);
> >  	state->s3 = __seed(i,  16U);
> >  	state->s4 = __seed(i, 128U);
> > +#endif
> >  }
> [..]
> 
> Can't we keep prandom_u32 as-is...?  Most of the usage, esp. in the
> packet schedulers, is fine.
>
> I'd much rather have a prandom_u32_hashed() or whatever for
> those cases where some bits might leak to the outside and then convert
> those prandom_u32 users over to the siphashed version.

In fact I even thought about having a different name, such as "weak_u32"
or something like this for the parts where we need slightly more than a
purely predictable random, and keeping the existing function as-is. But
I discovered there's also another one which is sufficient for stats, it
just doesn't have the same interface. But I totally agree on the benefit
of keeping the fastest version available for packet schedulers. In fact
I've run some of my tests with iptables -m statistics --probability ...
However if it turns out we can end up on a very fast PRNG (Tausworthe
was not *that* fast), it would be 100% benefit to turn to it. That's why
I don't want to rule out the possibility of a simple drop-in replacement.

By the way, if we end up keeping a different function for simpler cases,
we should probably find a better name for them like "predictable random"
or "trivial random" that makes users think twice. Doing that in a packet
scheduler is fine. The problem with the "pseudo random" term is that it
evolved over time from "totally predictable" to "may be strongly secure"
depending on implementations and that various people understand it
differently and have different expectations on it :-/

Cheers,
Willy
