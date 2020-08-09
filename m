Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABEF23FD93
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 11:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHIJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 05:38:28 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39595 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHIJi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 05:38:28 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0799c5th007935;
        Sun, 9 Aug 2020 11:38:05 +0200
Date:   Sun, 9 Aug 2020 11:38:05 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809093805.GA7928@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809065744.GA17668@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Sun, Aug 09, 2020 at 06:57:44AM +0000, George Spelvin wrote:
> +/*
> + * This is the core CPRNG function.  As "pseudorandom", this is not used
> + * for truly valuable things, just intended to be a PITA to guess.
> + * For maximum speed, we do just two SipHash rounds per word.  This is
> + * the same rate as 4 rounds per 64 bits that SipHash normally uses,
> + * so hopefully it's reasonably secure.
> + *
> + * There are two changes from the official SipHash finalization:
> + * - We omit some constants XORed with v2 in the SipHash spec as irrelevant;
> + *   they are there only to make the output rounds distinct from the input
> + *   rounds, and this application has no input rounds.
> + * - Rather than returning v0^v1^v2^v3, return v1+v3.
> + *   If you look at the SipHash round, the last operation on v3 is
> + *   "v3 ^= v0", so "v0 ^ v3" just undoes that, a waste of time.
> + *   Likewise "v1 ^= v2".  (The rotate of v2 makes a difference, but
> + *   it still cancels out half of the bits in v2 for no benefit.)
> + *   Second, since the last combining operation was xor, continue the
> + *   pattern of alternating xor/add for a tiny bit of extra non-linearity.
> + */
> +static u32 siprand_u32(struct siprand_state *s)
> +{
> +	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
> +
> +	SIPROUND(v0, v1, v2, v3);
> +	SIPROUND(v0, v1, v2, v3);
> +	s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;
> +	return v1 + v3;
> +}
> +
> +
> +/**
> + *	prandom_u32 - pseudo random number generator
> + *
> + *	A 32 bit pseudo-random number is generated using a fast
> + *	algorithm suitable for simulation. This algorithm is NOT
> + *	considered safe for cryptographic use.
> + */
> +u32 prandom_u32(void)
> +{
> +	struct siprand_state *state = get_cpu_ptr(&net_rand_state);
> +	u32 res = siprand_u32(state);
> +
> +	put_cpu_ptr(&net_rand_state);
> +	return res;
> +}

So I gave it a quick test under Qemu and it didn't show any obvious
performance difference compared to Tausworthe, which is a good thing,
even though there's a significant amount of measurement noise in each
case.

However it keeps the problem that the whole sequence is entirely
determined at the moment of reseeding, so if one were to be able to
access the state, e.g. using l1tf/spectre/meltdown/whatever, then
this state could be used to predict the whole ongoing sequence for
the next minute. What some view as a security feature, others will
see as a backdoor :-/  That's why I really like the noise approach.
Even just the below would significantly harm that capability because
that state alone isn't sufficient anymore to pre-compute all future
values:

--- a/lib/random32.c
+++ b/lib/random32.c
@@ -375,6 +375,7 @@ static u32 siprand_u32(struct siprand_state *s)
 {
        unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
 
+       v0 += get_cycles();
        SIPROUND(v0, v1, v2, v3);
        SIPROUND(v0, v1, v2, v3);
        s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;

Regards,
Willy
