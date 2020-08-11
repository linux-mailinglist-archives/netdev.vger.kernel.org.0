Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E612415F1
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 07:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHKF1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 01:27:38 -0400
Received: from mx.sdf.org ([205.166.94.24]:62740 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgHKF1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 01:27:37 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 07B5QpAZ008524
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Tue, 11 Aug 2020 05:26:51 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 07B5Qnrs020655;
        Tue, 11 Aug 2020 05:26:49 GMT
Date:   Tue, 11 Aug 2020 05:26:49 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Willy Tarreau <w@1wt.eu>
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
        Stephen Hemminger <stephen@networkplumber.org>,
        George Spelvin <lkml@SDF.ORG>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200811052649.GG25124@SDF.ORG>
References: <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
 <20200810165859.GD9060@1wt.eu>
 <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
 <20200810210455.GA9194@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810210455.GA9194@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 11:04:55PM +0200, Willy Tarreau wrote:
> What could be improved is the way the input values are mixed (just
> added hence commutative for now). I didn't want to call a siphash
> round on the hot paths, but just shifting the previous noise value
> before adding would work, such as the following for example:
> 
>   void prandom_u32_add_noise(a, b, c, d)
>   {
>   	unsigned long *noise = get_cpu_ptr(&net_rand_noise);
> 
>   #if BITS_PER_LONG == 64
> 	*noise = rol64(*noise, 7) + a + b + c + d;
>   #else
> 	*noise = rol32(*noise, 7) + a + b + c + d;
>   #endif
>   	put_cpu_ptr(&net_rand_noise);
> 
>   }

If you think this is enough seed material, I'm fine with it.

I don't hugely like the fact that you sum all the inputs, since
entropy tends to be concentrated in the low-order words, and summing
risks cancellation.

You can't afford even one SIPROUND as a non-cryptographic hash?  E.g.

DEFINE_PER_CPU(unsigned long[4], net_rand_noise);
EXPORT_SYMBOL(net_rand_noise);

void prandom_u32_add_noise(a, b, c, d)
{
	unsigned long *noise = get_cpu_ptr(&net_rand_noise);

	a ^= noise[0];
	b ^= noise[1];
	c ^= noise[2];
	d ^= noise[3];
	/*
	 * This is not used cryptographically; it's just
	 * a convenient 4-word hash function.
	 */
	SIPROUND(a, b, c, d);
	noise[0] = a;
	noise[1] = b;
	noise[2] = c;
	put_cpu_ptr(&net_rand_noise);
}

(And then you mix in net_rand_noise[0].)

Other options are HASH_MIX() from fs/namei.c, but that's
more sequential.

There's also a simple Xorshift generator.
