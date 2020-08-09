Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1E23FFB1
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHISa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 14:30:59 -0400
Received: from mx.sdf.org ([205.166.94.24]:59936 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgHISa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 14:30:59 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 079IUI83026032
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 9 Aug 2020 18:30:18 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 079IUID2000461;
        Sun, 9 Aug 2020 18:30:18 GMT
Date:   Sun, 9 Aug 2020 18:30:17 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de,
        George Spelvin <lkml@SDF.ORG>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809183017.GC25124@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809173302.GA8027@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 07:33:03PM +0200, Willy Tarreau wrote:
> Not that low in fact because they don't know precisely when the call is
> made. I mean, let's say we're in the worst case, with two VMs running on
> two siblings of the same core, with the same TSC, on a 3 GHz machine. The
> attacker can stress the victim at 100k probes per second. That's still
> 15 bits of uncertainty on the TSC value estimation which is added to each
> call. Even on the first call this is enough to make a source port
> unguessable, and preventing the attacker from staying synchronized with
> its victim. And I'm only speaking about an idle remote machine, not even
> one taking unobservable traffic, which further adds to the difficulty.

I'm trying to understand your attack scenario.  I'm assuming that an
attacker can call prandom_u32() locally.  (I don't have a specific code
path, but given the number of uses in the kernel, I assume *one* of
them will leak the output directly.)  And repeat the call fast
enough that there's at most *one* other user between our calls.

If an attacker knows the initial state, does an rdtsc, prandom_u32(),
and a second rdtsc, then they can guess the TSC value used in than
prandom_u32() quite accurately (4-6 bits fuzz, perhaps).  This is
trivial to brute force.

The fun comes if someone else does a prandom_u32() call in between.

All of a sudden, the 4-6 bit brute force of one get_cycles() value
fails to find a solution.  Someone else has called prandom_u32()!

Now we have 15 bits of uncertainty about that other call, and 5 bits
of uncertainty about our call.  2^20 possibilities only takes a few
milliseconds to test, and the 32-bit output of prandom_u32() can
verify a guess with minimal probability of error.

(Note that, to maintain tracking, we have to keep hammering
prandom_u32() *during* the search, but we can just buffer the results
and process them after the expensive search is complete.)

What you can see here is the incredible power of *multiple* unobserved
seedings.  As long as an attacker can limit things to one unobserved
prandom_u32(), it's a simple brute force.

If there are mroe than one, the additional bits of uncertainty
quickly make things impractical.

This is why I'm so keen on less frequent, more catastrophic,
reseeding.  Yes, the delay means an attacker who has captured
the state retains full knowledge for longer.  But they get
kicked off as soon as the catastophe happens.  Without it, they
can keep tracking the state indefinitely.

Even something simple like buffering 8 TSC samples, and adding them
at 32-bit offsets across the state every 8th call, would make a huge
difference.

Even if 7 of the timestamps are from attacker calls (4 bits
uncertainty), the time of the target call is 8x less known
(so it goes from 15 to 18 bits), and the total becomes
46 bits.  *So* much better.

> I can run some tests on this as
> well. I'd really need to try on a cleaner setup, I have remote machines
> at the office but I don't feel safe enough to remotely reboot them and
> risk to lose them :-/

Yeah, test kernels are nervous-making that way.

> I'll also test on arm/arm64 to make sure we don't introduce a significant
> cost there.

I don't expect a problem, but SipHash is optimized for 4-issue processors,
and on narrower machines fewer instructions are "free".
