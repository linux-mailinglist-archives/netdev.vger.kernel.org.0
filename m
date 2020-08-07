Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1623F51E
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHGXL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 19:11:56 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39531 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgHGXL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 19:11:56 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 077NBfSc006872;
        Sat, 8 Aug 2020 01:11:41 +0200
Date:   Sat, 8 Aug 2020 01:11:41 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200807231141.GA6867@1wt.eu>
References: <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
 <20200807070316.GA6357@1wt.eu>
 <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
 <20200807174302.GA6740@1wt.eu>
 <9148811b-64f9-a18c-ddeb-b1ff4b34890e@gmail.com>
 <20200807221913.GA6846@1wt.eu>
 <9ae4be33-fdeb-b882-d705-bccfacda1c4e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae4be33-fdeb-b882-d705-bccfacda1c4e@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 03:45:48PM -0700, Marc Plumb wrote:
> Willy,
> 
> 
> On 2020-08-07 3:19 p.m., Willy Tarreau wrote:
> > On Fri, Aug 07, 2020 at 12:59:48PM -0700, Marc Plumb wrote:
> > > 
> > > If I can figure the state out once,
> > Yes but how do you take that as granted ? This state doesn't appear
> > without its noise counterpart,
> 
> Amit has shown attacks that can deduce the full internal state from 4-5
> packets with a weak PRNG. If the noise is added less often than that, an
> attacker can figure out the entire state at which point the partial
> reseeding doesn't help. If the noise is added more often than that, and it's
> raw timing events, then it's only adding a few bits of entropy so its easy
> to guess (and it weakens dev/random). If the noise is added more often, and
> it's from the output of a CPRNG, then we have all the performance/latency
> problems from the CPRNG itself, so we might as well use it directly.

His attacks is based on the fact that internal state bits leak as-is.
So it is possible to collect them and perform the inverse operation to
reconstruct the input.

Here the output is made by mixing two input bits with two noise bits
and produce one single output bit. So for each output bit you see,
you don't have just one possible input bit, but 16 possibilities.
That's 128 bits of internal changing states that once combined result
in 32 bits. For each 32-bit output you still have 2^96 possible
internal (x,noise) states producing it. And that's without counting
on the 64-bit seed that you still don't know but can be deduced from
two guessed 128 bit states (assuming that can be brute-forced at all,
of course).

For sure there are plenty of number theories allowing you to
significantly reduce the space you need to work on to brute-force
this but it will definitely remain above 2^32 attempts for each
iteration, which is the floor you have without the noise part,
while the whole internal state will be reseeded every minute
anyway.

I mean, I'm not trying to sell this thing, I'm just trying to defend
that we use a reasonable tool for a reasonable protection level. And
yes, probably that 15 years from now, someone will say "hey look, I
can brute-force this thing in less than a minute on my 1024-core 39th
gen core i7 machine with 2^60 operations per second, why don't we use
our CPU's native 10 picosecond AES1024 instruction instead ?" and we'll
say "well, it's an old story and it's probably about time to change it
again".

I don't see anything wrong with evolving this way, matching concrete
needs more than pure theory.

Regards,
Willy
