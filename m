Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB3241569
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 05:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgHKDsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 23:48:08 -0400
Received: from mx.sdf.org ([205.166.94.24]:51391 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgHKDsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 23:48:07 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 07B3lPQq022015
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Tue, 11 Aug 2020 03:47:25 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 07B3lOCD012316;
        Tue, 11 Aug 2020 03:47:24 GMT
Date:   Tue, 11 Aug 2020 03:47:24 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de,
        George Spelvin <lkml@SDF.ORG>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200811034724.GF25124@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810114700.GB8474@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 01:47:00PM +0200, Willy Tarreau wrote:
> except that I retrieve it only on 1/8 calls
> and use the previous noise in this case.

Er... that's quite different.  I was saying you measure them all, and do:

 struct siprand_state {
 	...
+	uint32_t noise[i];
+	unsigned counter;
 }
 	...
+	s->noise[--s->counter] = random_get_entropy();
+
+	if (!s->counter) {
+		for (i = 0; i < 4; i++)
+			s->v[i] += s->noise[2*i] +
+				((unsigned long)s->noise[2*i+1] << BITS_PER_LONG/2);
+		s->counter = 8;
+	}

What you're doing is just decreasing the amount of seeding by a factor
of 8.  (Roughly.  You do gain log2(8)/2 = 1.5 bits because the sum of
8 random values has a standard deviation sqrt(8) times as large as
the inputs.)

> diff --git a/lib/random32.c b/lib/random32.c
> index 2b048e2ea99f..a12d63028106 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -317,6 +317,8 @@ static void __init prandom_state_selftest(void)
>  
>  struct siprand_state {
>  	unsigned long v[4];
> +	unsigned long noise;
> +	unsigned long count;
>  };
>  
>  static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
> @@ -334,7 +336,7 @@ static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
>  #define K0 (0x736f6d6570736575 ^ 0x6c7967656e657261 )
>  #define K1 (0x646f72616e646f6d ^ 0x7465646279746573 )
>  
> -#elif BITS_PER_LONG == 23
> +#elif BITS_PER_LONG == 32
>  /*
>   * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
>   * This is weaker, but 32-bit machines are not used for high-traffic
> @@ -375,6 +377,12 @@ static u32 siprand_u32(struct siprand_state *s)
>  {
>  	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
>  
> +	if (++s->count >= 8) {
> +		v3 ^= s->noise;
> +		s->noise += random_get_entropy();
> +		s->count = 0;
> +	}
> +

- Can you explain why you save the "noise" until next time?  Is this meant to
  make it harder for an attacker to observe the time?
- How about doing away with s->count and making it statistical:

+	if ((v3 & 7) == 0)
+		v3 ^= random_get_entropy();

That still does the seed 1/8 of the time, but in a much less regular pattern.
(Admittedly, it will totally break the branch predictor.  An unlikely()
might help.)

