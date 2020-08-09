Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A62B23FFCE
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgHITR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 15:17:28 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39619 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgHITR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 15:17:28 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 079JGYLv008081;
        Sun, 9 Aug 2020 21:16:34 +0200
Date:   Sun, 9 Aug 2020 21:16:34 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org, fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200809191634.GC8063@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200809183017.GC25124@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 09, 2020 at 06:30:17PM +0000, George Spelvin wrote:
> I'm trying to understand your attack scenario.  I'm assuming that an
> attacker can call prandom_u32() locally.

Well, first, I'm mostly focusing on remote attacks, because if the
attacker has a permanent local access, he can as well just bind()
a source port instead of having to guess the next one that will be
used. Second, I'm not aware of direct access from userland, so the
calls to prandom_u32() are expected to be done only via specific
code parts. The worst case (in my opinion) is when the attacker
runs on the same physical CPU and exploits some memory leakage to
find the internal state and uses the same TSC, but can only trigger
prandom_u32() via the network, hence with much less precision.

(...)
> Even something simple like buffering 8 TSC samples, and adding them
> at 32-bit offsets across the state every 8th call, would make a huge
> difference.
> 
> Even if 7 of the timestamps are from attacker calls (4 bits
> uncertainty), the time of the target call is 8x less known
> (so it goes from 15 to 18 bits), and the total becomes
> 46 bits.  *So* much better.

Maybe. I'm just suggesting to add *some* noise to keep things not
exploitable if the state is stolen once in a while (which would
already be a big problem, admittedly).

> > I can run some tests on this as
> > well. I'd really need to try on a cleaner setup, I have remote machines
> > at the office but I don't feel safe enough to remotely reboot them and
> > risk to lose them :-/
> 
> Yeah, test kernels are nervous-making that way.

In fact I never booted a 5.8 kernel on the machine I'm thinking about
yet and can't remote-control its power supply, so I'm worried about
a dirty hang at boot by missing a config entry. The risk is low but
that's annoying when it happens.

> > I'll also test on arm/arm64 to make sure we don't introduce a significant
> > cost there.
> 
> I don't expect a problem, but SipHash is optimized for 4-issue processors,
> and on narrower machines fewer instructions are "free".

OK.

Willy
