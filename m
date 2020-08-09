Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB623FF63
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgHIRH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 13:07:27 -0400
Received: from mx.sdf.org ([205.166.94.24]:50443 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHIRH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 13:07:27 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 079H6fGn001050
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 9 Aug 2020 17:06:41 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 079H6dBT001615;
        Sun, 9 Aug 2020 17:06:39 GMT
Date:   Sun, 9 Aug 2020 17:06:39 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de,
        George Spelvin <lkml@SDF.ORG>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809170639.GB25124@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809093805.GA7928@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 11:38:05AM +0200, Willy Tarreau wrote:
> So I gave it a quick test under Qemu and it didn't show any obvious
> performance difference compared to Tausworthe, which is a good thing,
> even though there's a significant amount of measurement noise in each
> case.

Thank you very much!  I'm not quite sure how to benchmark this.
The whole idea is that it's *not* used in a tight cache-hot loop.
Hopefully someone already has a test setup so I don't have to invent
one.

> However it keeps the problem that the whole sequence is entirely
> determined at the moment of reseeding, so if one were to be able to
> access the state, e.g. using l1tf/spectre/meltdown/whatever, then
> this state could be used to predict the whole ongoing sequence for
> the next minute. What some view as a security feature, others will
> see as a backdoor :-/  That's why I really like the noise approach.
> Even just the below would significantly harm that capability because
> that state alone isn't sufficient anymore to pre-compute all future
> values:
> 
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -375,6 +375,7 @@ static u32 siprand_u32(struct siprand_state *s)
>  {
>         unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
>  
> +       v0 += get_cycles();
>         SIPROUND(v0, v1, v2, v3);
>         SIPROUND(v0, v1, v2, v3);
>         s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;

As long as:
1) The periodic catastrophic reseeding remains, and
2) You use fresh measurements, not the exact same bits
   that add_*_randomness feeds into /dev/random
then it doesn't do any real harm, so if it makes you feel better...

But I really want to stress how weak a design drip-reseeding is.

If an attacker has enough local machine access to do a meltdown-style attack,
then they can calibrate the TSC used in get_cycles very accurately, so the
remaining timing uncertainty is very low.  This makes a brute-force attack on
one or two reseedings quite easy.  I.e. if you can see every other output,
It's straightforward to figure out the ones in between.

I wonder if, on general principles, it would be better to use a more
SipHash style mixing in of the sample:
	m = get_cycles();
	v3 ^= m;
	SIPROUND(v0, v1, v2, v3);
	SIPROUND(v0, v1, v2, v3);
	v0 ^= m;

Not sure if it's worth the extra register (and associated spill/fill).
