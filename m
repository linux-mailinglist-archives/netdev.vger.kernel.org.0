Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3AB24157F
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 05:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgHKD6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 23:58:32 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39752 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgHKD6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 23:58:32 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07B3wFuI009374;
        Tue, 11 Aug 2020 05:58:15 +0200
Date:   Tue, 11 Aug 2020 05:58:15 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200811035815.GB9327@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <20200811034724.GF25124@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811034724.GF25124@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 03:47:24AM +0000, George Spelvin wrote:
> On Mon, Aug 10, 2020 at 01:47:00PM +0200, Willy Tarreau wrote:
> > except that I retrieve it only on 1/8 calls
> > and use the previous noise in this case.
> 
> Er... that's quite different.  I was saying you measure them all, and do:

That was my first approach and it resulted in a significant performance
loss, hence the change (and the resulting ugly construct with the counter).

> > +	if (++s->count >= 8) {
> > +		v3 ^= s->noise;
> > +		s->noise += random_get_entropy();
> > +		s->count = 0;
> > +	}
> > +
> 
> - Can you explain why you save the "noise" until next time?  Is this meant to
>   make it harder for an attacker to observe the time?

Just to make the observable call not depend on immediately measurable TSC
values. It's weak, but the point was that when mixing attack traffic with
regular one, if you can measure the time variations on TSC to know when
it was used and don't have its resulting effect at the same time, it's
harder to analyse than when you have both at once.

> - How about doing away with s->count and making it statistical:
> 
> +	if ((v3 & 7) == 0)
> +		v3 ^= random_get_entropy();

Absolutely. I just kept the counter from previous attempt. But Linus
prefers that we completely remove TSC calls from direct calls due to
old VMs that were slow at this. We could collect it anywhere else once
in a while instead.

Willy
