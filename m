Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5A23F216
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHGRnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:43:17 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39500 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGRnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 13:43:17 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 077Hh2fs006746;
        Fri, 7 Aug 2020 19:43:02 +0200
Date:   Fri, 7 Aug 2020 19:43:02 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200807174302.GA6740@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
 <20200807070316.GA6357@1wt.eu>
 <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 09:52:14AM -0700, Marc Plumb wrote:
> On 2020-08-07 12:03 a.m., Willy Tarreau wrote:
> 
> > Just to give a heads up on this, here's what I'm having pending regarding
> > MSWS:
> > 
> >    struct rnd_state {
> >          uint64_t x, w;
> >          uint64_t seed;
> >          uint64_t noise;
> >    };
> > 
> >    uint32_t msws32(struct rnd_state *state)
> >    {
> >          uint64_t x;
> > 
> >          x  = state->w += state->seed;
> >          x += state->x * state->x;
> >          x  = state->x = (x >> 32) | (x << 32);
> >          x -= state->noise++;
> >          return x ^ (x >> 32);
> >    }
> 
> A few comments:
> 
> This is still another non-cryptographic PRNG.

Absolutely. During some discussions regarding the possibility of using
CSPRNGs, orders around hundreds of CPU cycles were mentioned for them,
which can definitely be a huge waste of precious resources for some
workloads, possibly causing the addition of a few percent extra machines
in certain environments just to keep the average load under a certain
threshold. And the worst there is that such workloads would exactly be
the ones absolutely not affected by the theorical attacks regarding
predictability :-/

> An LFSR can pass PractRand (if
> you do a tweak to get around the specific linear complexity test for LFSRs).

OK.

> On a 64-bit machine it should be fast: 4 adds, 1 multiply, 1 rotate, 1
> shift, 1 xor
> 
> This will be much slower on 32-bit machines, if that's still a concern

Yep, that's something I'm totally aware of and one reason I wanted to
have a public discussion about this. My personal view on this is that
a 64-bit multiply will always be cheaper than a crypto operation and
that the environments where picking a source port or accepting a
connection matters that much are not those running on such low-end
machines, so that's very likely an acceptable tradeoff.

> As long as the noise is the output of a CPRNG, this doesn't hurt the
> security of dev/dandom.
> 
> The noise is more like effective 32-bits since you're xoring the low and
> high half of the noise together (ignoring the minor details of carry bits).

Definitely. The purpose of this noise in fact is more to complicate the
reconstruction of the internal state in case a large number of samples
is used, precisely due to these carry bits that propagate solely depending
on the noise value itself, and the uncertainty about when it changes and
from what to what.

> Which means that it's 2^32 effort to brute force this (which Amit called "no
> biggie for modern machines"). If the noise is the raw sample data with only
> a few bits of entropy, then it's even easier to brute force.

Don't you forget to multiply by another 2^32 for X being folded onto itself ?
Because you have 2^32 possible values of X which will give you a single 32-bit
output value for a given noise value.

> Given the uses of this, I think we really should look into a CPRNG for this
> and then completely reseed it periodically. The problem is finding one
> that's fast enough.

That was precisely the problem that drove me to propose something like
this. And all these cycles wasted everywhere just to protect a 16-bit
source port on a mostly idle machine seem quite overkill to me.

> Is there a hard instruction budget for this, or it is
> just "fast enough to not hurt the network benchmarks" (i.e. if Dave Miller
> screams)?

It's not just Davem. I too am concerned about wasting CPU cycles in fast
path especially in the network code. A few half-percent gains are hardly
won once in a while in this area and in some infrastructures they matter.
Not much but they do.

Willy
