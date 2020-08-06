Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68A123D6D8
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgHFGaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:30:55 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39444 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726051AbgHFGaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 02:30:55 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0766UZRu018542;
        Thu, 6 Aug 2020 08:30:35 +0200
Date:   Thu, 6 Aug 2020 08:30:35 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200806063035.GC18515@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 03:21:11PM -0700, Marc Plumb wrote:
> There is nothing wrong with perturbing net_rand_state, the sin is doing it
> with the raw entropy that is also the seed for your CPRNG. Use the output of
> a CPRNG to perturb the pool all you want, but don't do things that bit by
> bit reveal the entropy that is being fed into the CPRNG.

This is interesting because I think some of us considered it exactly the
other way around, i.e. we're not copying exact bits but just taking a
pseudo-random part of such bits at one point in time, to serve as an
increment among other ones. And given that these bits were collected
over time from not very secret sources, they appeared to be of lower
risk than the output.

I mean, if we reimplemented something in parallel just mixing the IRQ
return pointer and TSC, some people could possibly say "is this really
strong enough?" but it wouldn't seem very shocking in terms of disclosure.
But if by doing so we ended up in accident reproducing the same contents
as the fast_pool it could be problematic.

Would you think that using only the input info used to update the
fast_pool would be cleaner ? I mean, instead of :

        fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
        fast_pool->pool[1] ^= now ^ c_high;
        ip = regs ? instruction_pointer(regs) : _RET_IP_;
        fast_pool->pool[2] ^= ip;
        fast_pool->pool[3] ^= (sizeof(ip) > 4) ? ip >> 32 :
                get_reg(fast_pool, regs);

we'd do:

        x0 = cycles ^ j_high ^ irq;
        x1 = now ^ c_high;
        x2 = regs ? instruction_pointer(regs) : _RET_IP_;
        x3 = (sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);

        fast_pool->pool[0] ^= x0;
        fast_pool->pool[1] ^= x1;
        fast_pool->pool[2] ^= x2;
        fast_pool->pool[3] ^= x3;

	this_cpu_add(net_rand_state.s1, x0^x1^x2^x3);

Because that's something easy to do and providing the same level
of perturbation to net_rand_state.

> > Another approach involving the replacement of the algorithm was considered
> > but we were working with -stable in mind, trying to limit the backporting
> > difficulty (and it revealed a circular dependency nightmare that had been
> > sleeping there for years), and making the changes easier to check (which
> > is precisely what you're doing).
> 
> Really? You can replace the LFSR and only change lib/random32.c. That might
> fix the problem without the need to use the raw fast_pool data for seed
> material.

Definitely. I had been working on a variant of MSWS
(https://arxiv.org/pdf/1704.00358.pdf) that I discussed a little bit with
Amit, but I didn't publish it yet since it needs to be cleaned up and to
replace all the test patterns in random32.c. And when starting to rebase
it I figured that updating it from the interrupt handler didn't really
look like it brought anything. I mean that when you're starting to wonder
what to update "to make it better", it likely means that you don't need it.

> As Linus said, speed is a concern but SFC32 is faster than
> existing Tausworthe generator, and it's a drop-in replacement with the same
> state size if that makes your life easier. If you're willing to expand the
> state there are even better options (like SFC64 or some of chaotic
> generators like Jenkins' Frog).

I didn't know about SFC32, it looks like a variation of the large family
of xorshift generators, which is thus probably quite suitable as well
for this task. Having used xoroshiro128** myself in another project, I
found it overkill for this task compared to MSWS but I definitely agree
that any of them is more suited to the task than the current one.

> > We're not trying to invent any stream cipher or whatever, just making
> > use of a few bits that are never exposed alone as-is to internal nor
> > external states, to slightly disturb another state that otherwise only
> > changes once a minute so that there's no more a 100% chance of guessing
> > a 16-bit port after seeing a few packets. I mean, I'm pretty sure that
> > even stealing three or four bits only from there would be quite enough
> > to defeat the attack given that Amit only recovers a few bits per packet.
> 
> If Amit's attack can recover that much per packet (in practice not just in
> theory) and there is even one packet per interrupt, then it's a major
> problem. There are at most 2 bits of entropy added per call to
> add_interrupt_randomness, so it you're leaking "a few bits per packet" then
> that's everything. Over 64 interrupts you've lost the 128 bits of entropy
> that the fast_pool has spilled into the input_pool.

But how do you *figure* the value of these bits and their position in the
fast_pool ? I mean that the attack relies on net_rand_state not being
perturbed. Let's assume you'd be able to brute-force them in linear time
by drawing the list of possible candidates for 32-bit increment on each
packet and you end up with 64 sets of candidates. You'll probably have
quite a number of candidates there since you'll also need to take into
account the CPU the packet ends up on and calls to update_process_times()
on each jiffy. For each of these candidates you don't precisely know what
part of the fast_pool was used so you're at 4^64 combinations, and even
if you can guess which ones they are, they come from different generations
of the fast_pool, which are iterated over on other activities.

Don't get me wrong, I'm not trying to defend the solution or anything,
I find it more like a reasonable short term plaster to at least address
lab-style attacks on almost idle machines. But outside of the lab, when
machines are doing real work, I agree with Linus that both the attack
and the risks mentioned above fly into pieces because there are a lot
more possibilities at each step of the operations that have to be taken
into account. Now if you think that doing some small changes like proposed
above just to better protect the entropy would provide significant help,
feel free to suggest so.

Thanks,
Willy
