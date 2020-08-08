Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8178823F8B8
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 22:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHHUIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 16:08:40 -0400
Received: from mx.sdf.org ([205.166.94.24]:56184 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgHHUIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 16:08:40 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078K8Ipx020513
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 20:08:19 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078K8IG7012745;
        Sat, 8 Aug 2020 20:08:18 GMT
Date:   Sat, 8 Aug 2020 20:08:18 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808200818.GC27941@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200808174451.GA7429@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808174451.GA7429@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 07:44:51PM +0200, Willy Tarreau wrote:
> On Sat, Aug 08, 2020 at 03:26:28PM +0000, George Spelvin wrote:
>> So any discussion of reseeding begins by *assuming* an attacker has
>> captured the PRNG state.  If we weren't worried about this possibility,
>> we wouldn't need to reseed in the first place!
> 
> Sure, but what matters is the time it takes to capture the state.
> In the previous case it used to take Amit a few packets only. If it
> takes longer than the reseeding period, then it's not captured anymore.
> That was exactly the point there: break the certainty of the observations
> so that the state cannot be reliably guessed anymore, hence cancelling
> the concerns about the input bits being guessed. For sure if it is
> assumed that the state is guessed nevertheless, this doesn't work
> anymore, but that wasn't the assumption.

Just checking that you're aware: modern high-end network hardware does 
aggressive interupt coalescing, and NAPI disables interrupts entirely.  So 
you can transfer 10K packets per interrupt in extreme cases.

*Especially* on the transmit side, where the only thing you need to do 
after transmission is recycle the buffer, so latency concerns are minimal.  
In the steady state, all buffer recycling is done by polling while 
queueing new packets. You only need an interrupt to reclaim the last few 
buffers when transmission pauses.

So assuming that once per interrupt equals "often" is completely false.

Not to mention that the generators are per-CPU, and the CPU gnerating the 
random numbers might not be the one getting what few interrupts there are.  
(It's quite common in networking applications to bind network interrupts 
and application logic to separate CPUs.)

This whole bit of logic just seems ridiculously fragile to me.

>> Just like a buffer overflow, a working attack is plausible using a
>> combination of well-understood techniques.  It's ridiculous to go to
>> the effort of developing a full exploit when it's less work to fix the
>> problem in the first place.

> I totally agree with this principle. However, systematically starting
> with assumptions like "the PRNG's state is known to the attacker" while
> it's the purpose of the attack doesn't exactly match something which
> does not warrant a bit more explanation.

I thought I explained it, though.  Reseeding only matters if you're
trying to disrupt an attacker's knowledge of the PRNG state.  Yes,
assuming complete knowledge is a simplified "spherical cow", but the
logic applies to more complex partial-knowledge attacks as well.

The point is that a solution which solves that limiting case automatically 
takes care of all the other attacks, too.

If we have to carefully quantify an attacker's knowledge, using careful 
and delicate analysis to show security, then it's both more work, and 
*brittle*: the analysis must be re-checked each time the code is modified.

It just seems like a really crappy slumlord-quality solution.

> Note, it's beyond predictability, it's reversibility at this point.

I'm not quite sure what the distinction you're making is, but
I don't disagree.  Conventional PRNGs are trivially extrapolatable
forward and backward.  The *real* problem is that the network code
is asking for a property the PRNG explicitly lacks.

Just remember that the property of *not* being extrapolatable is 
specifically and exactly what makes a CPRNG cryptographic.

>> So the request is for a less predictable PRNG which is still extremely
>> fast.
> 
> That was the goal around the MSWS PRNG, as it didn't leak its bits
> and would require a certain amount of brute force.

The techniques for MSWS cryptanalysis aren't as widely documented as
LFSRs and LCGs, but I'm *very* skeptical of this claim.  I'd like to use
the most robust primitive that's not prohibitively slow.

> If it's considered as cryptographically secure, it's OK to feed it with
> just a counter starting from a random value, since the only way to guess
> the current counter state is to brute-force it, right ? I've done this in
> the appended patch. Note that for now I've commented out all the reseeding
> code because I just wanted to test the impact. 
> 
> In my perf measurements I've had some erratic behaviors, one test showing
> almost no loss, and another one showing a lot, which didn't make sense, so
> I'll need to measure again under better condition (i.e. not my laptop with
> a variable frequency CPU).

Actually, I was going to use a somewhat weaker construction that
does 2 rounds per output number.  Standard SipHash does 2n+4
rounds to handle n words of input, so would do 6 rounds in this
standard construction.  The 3x performance gain seems worth it.

The standard construction *would* allow a great code simplification,
since the key could be global and shared, and the per-CPU data would
be limited to a counter.  But I don't think 6 rounds would be fast
enough.

> There seems to be some general thinking among many crypto-savvy people
> that everything in the world needs strong crypto, including PRNGs, and
> that doesn't always help.

No, it's not needed for everything, but it *greatly* simplifies the 
analysis.  I agree that the crypto world suffers from "everything looks 
like a nail" syndrome, but there's value in indestructible building 
blocks: it makes reasoning about the resultant structure ever so much 
easier.
