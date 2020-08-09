Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9152923FF86
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 19:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgHIRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 13:33:28 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39606 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHIRd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 13:33:26 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 079HX3YN008045;
        Sun, 9 Aug 2020 19:33:03 +0200
Date:   Sun, 9 Aug 2020 19:33:03 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809173302.GA8027@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809170639.GB25124@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 05:06:39PM +0000, George Spelvin wrote:
> On Sun, Aug 09, 2020 at 11:38:05AM +0200, Willy Tarreau wrote:
> > So I gave it a quick test under Qemu and it didn't show any obvious
> > performance difference compared to Tausworthe, which is a good thing,
> > even though there's a significant amount of measurement noise in each
> > case.
> 
> Thank you very much!  I'm not quite sure how to benchmark this.
> The whole idea is that it's *not* used in a tight cache-hot loop.
> Hopefully someone already has a test setup so I don't have to invent
> one.

Due to limited access to representative hardware, the to main tests
I've been running were on my laptop in qemu, and consisted in :

   - a connect-accept-close test to stress the accept() code and
     verify we don't observe a significant drop. The thing is that
     connect() usually is much slower and running the two on the
     same machine tends to significantly soften the differences
     compared to what a real machine would see when handling a
     DDoS for example.

   - a packet rate test through this rule (which uses prandom_u32()
     for each packet and which matches what can be done in packet
     schedulers or just by users having to deal with random drop) :

     iptables -I INPUT -m statistic --probability 0.5 -j ACCEPT

While these ones are not very relevant, especially in a VM, not
seeing significant variations tends to indicate we should not see
a catastrophic loss.

> > However it keeps the problem that the whole sequence is entirely
> > determined at the moment of reseeding, so if one were to be able to
> > access the state, e.g. using l1tf/spectre/meltdown/whatever, then
> > this state could be used to predict the whole ongoing sequence for
> > the next minute. What some view as a security feature, others will
> > see as a backdoor :-/  That's why I really like the noise approach.
> > Even just the below would significantly harm that capability because
> > that state alone isn't sufficient anymore to pre-compute all future
> > values:
> > 
> > --- a/lib/random32.c
> > +++ b/lib/random32.c
> > @@ -375,6 +375,7 @@ static u32 siprand_u32(struct siprand_state *s)
> >  {
> >         unsigned long v0 = s->v[0], v1 = s->v[1], v2 = s->v[2], v3 = s->v[3];
> >  
> > +       v0 += get_cycles();
> >         SIPROUND(v0, v1, v2, v3);
> >         SIPROUND(v0, v1, v2, v3);
> >         s->v[0] = v0;  s->v[1] = v1;  s->v[2] = v2;  s->v[3] = v3;
> 
> As long as:
> 1) The periodic catastrophic reseeding remains, and
> 2) You use fresh measurements, not the exact same bits
>    that add_*_randomness feeds into /dev/random
> then it doesn't do any real harm, so if it makes you feel better...
> 
> But I really want to stress how weak a design drip-reseeding is.
> 
> If an attacker has enough local machine access to do a meltdown-style attack,
> then they can calibrate the TSC used in get_cycles very accurately,

Absolutely.

> so the
> remaining timing uncertainty is very low.

Not that low in fact because they don't know precisely when the call is
made. I mean, let's say we're in the worst case, with two VMs running on
two siblings of the same core, with the same TSC, on a 3 GHz machine. The
attacker can stress the victim at 100k probes per second. That's still
15 bits of uncertainty on the TSC value estimation which is added to each
call. Even on the first call this is enough to make a source port
unguessable, and preventing the attacker from staying synchronized with
its victim. And I'm only speaking about an idle remote machine, not even
one taking unobservable traffic, which further adds to the difficulty.

> This makes a brute-force attack on
> one or two reseedings quite easy.  I.e. if you can see every other output,
> It's straightforward to figure out the ones in between.

But they already become useless because you're only observing stuff of
the past.

> I wonder if, on general principles, it would be better to use a more
> SipHash style mixing in of the sample:
> 	m = get_cycles();
> 	v3 ^= m;
> 	SIPROUND(v0, v1, v2, v3);
> 	SIPROUND(v0, v1, v2, v3);
> 	v0 ^= m;

Probably, if it's the recommended way to mix in other values, yes.

> Not sure if it's worth the extra register (and associated spill/fill).

If this makes the hash better, maybe. I can run some tests on this as
well. I'd really need to try on a cleaner setup, I have remote machines
at the office but I don't feel safe enough to remotely reboot them and
risk to lose them :-/

I'll also test on arm/arm64 to make sure we don't introduce a significant
cost there.

Willy
