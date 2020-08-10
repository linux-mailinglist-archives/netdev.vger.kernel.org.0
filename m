Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA06C2407D1
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHJOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:48:52 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39681 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbgHJOsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:48:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07AEmT4N009066;
        Mon, 10 Aug 2020 16:48:29 +0200
Date:   Mon, 10 Aug 2020 16:48:29 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@aculab.com>
Cc:     George Spelvin <lkml@sdf.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "aksecurity@gmail.com" <aksecurity@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "lkml.mplumb@gmail.com" <lkml.mplumb@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "fw@strlen.de" <fw@strlen.de>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810144829.GA9060@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <fe180697062643ac9538bf080e2de3d7@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe180697062643ac9538bf080e2de3d7@AcuMS.aculab.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 12:01:11PM +0000, David Laight wrote:
> >  /*
> >   * On 32-bit machines, we use HSipHash, a reduced-width version of SipHash.
> >   * This is weaker, but 32-bit machines are not used for high-traffic
> > @@ -375,6 +377,12 @@ static u32 siprand_u32(struct siprand_state *s)
> >  {
> >  	unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
> > 
> > +	if (++s->count >= 8) {
> > +		v3 ^= s->noise;
> > +		s->noise += random_get_entropy();
> > +		s->count = 0;
> > +	}
> > +
> 
> Using:
> 	if (s->count-- <= 0) {
> 		...
> 		s->count = 8;
> 	}
> probably generates better code.
> Although you may want to use a 'signed int' instead of 'unsigned long'.

Yeah I know, it's just because I only slightly changed the previous code
there. I had an earlier version that kept the rand state fully padded
when storing intermediate values. That's among the final cleanups I'll
bring if we go down that route.

Thanks!

Willy
