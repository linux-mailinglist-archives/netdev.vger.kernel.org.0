Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF352415FE
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 07:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHKFiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 01:38:01 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39767 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgHKFiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 01:38:00 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07B5bcWN009467;
        Tue, 11 Aug 2020 07:37:38 +0200
Date:   Tue, 11 Aug 2020 07:37:38 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     George Spelvin <lkml@sdf.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200811053738.GC9456@1wt.eu>
References: <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
 <20200810165859.GD9060@1wt.eu>
 <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
 <20200810210455.GA9194@1wt.eu>
 <20200811052649.GG25124@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811052649.GG25124@SDF.ORG>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 05:26:49AM +0000, George Spelvin wrote:
> On Mon, Aug 10, 2020 at 11:04:55PM +0200, Willy Tarreau wrote:
> > What could be improved is the way the input values are mixed (just
> > added hence commutative for now). I didn't want to call a siphash
> > round on the hot paths, but just shifting the previous noise value
> > before adding would work, such as the following for example:
> > 
> >   void prandom_u32_add_noise(a, b, c, d)
> >   {
> >   	unsigned long *noise = get_cpu_ptr(&net_rand_noise);
> > 
> >   #if BITS_PER_LONG == 64
> > 	*noise = rol64(*noise, 7) + a + b + c + d;
> >   #else
> > 	*noise = rol32(*noise, 7) + a + b + c + d;
> >   #endif
> >   	put_cpu_ptr(&net_rand_noise);
> > 
> >   }
> 
> If you think this is enough seed material, I'm fine with it.
> 
> I don't hugely like the fact that you sum all the inputs, since
> entropy tends to be concentrated in the low-order words, and summing
> risks cancellation.

Yes I've figured this. But I thought it was still better than
a pure xor which would cancell the high bits from pointers.

> You can't afford even one SIPROUND as a non-cryptographic hash?  E.g.

That's what I mentioned above, I'm still hesitating. I need to test.

> 
> DEFINE_PER_CPU(unsigned long[4], net_rand_noise);
> EXPORT_SYMBOL(net_rand_noise);
> 
> void prandom_u32_add_noise(a, b, c, d)
> {
> 	unsigned long *noise = get_cpu_ptr(&net_rand_noise);
> 
> 	a ^= noise[0];
> 	b ^= noise[1];
> 	c ^= noise[2];
> 	d ^= noise[3];
> 	/*
> 	 * This is not used cryptographically; it's just
> 	 * a convenient 4-word hash function.
> 	 */
> 	SIPROUND(a, b, c, d);
> 	noise[0] = a;
> 	noise[1] = b;
> 	noise[2] = c;
> 	put_cpu_ptr(&net_rand_noise);
> }
> 
> (And then you mix in net_rand_noise[0].)
> 
> Other options are HASH_MIX() from fs/namei.c, but that's
> more sequential.
> 
> There's also a simple Xorshift generator.

I think a xorshift on each value will have roughly the same cost
as a single SIPROUND. But I've not yet completely eliminated these
options until I've tested. If we lose a few cycles per packet, that
might be OK.

Willy
