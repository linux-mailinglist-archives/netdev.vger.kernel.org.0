Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A0523D3C8
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgHEWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 18:06:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55809 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725830AbgHEWGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 18:06:36 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 075M5ouk012945
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Aug 2020 18:05:51 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5A870420263; Wed,  5 Aug 2020 18:05:50 -0400 (EDT)
Date:   Wed, 5 Aug 2020 18:05:50 -0400
From:   tytso@mit.edu
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805220550.GA785826@mit.edu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 09:06:40AM -0700, Marc Plumb wrote:
> Isn't get_random_u32 the function you wrote to do that? If this needs to be
> cryptographically secure, that's an existing option that's safe.
> 
> The fundamental question is: Why is this attack on net_rand_state problem?
> It's Working as Designed. Why is it a major enough problem to risk harming
> cryptographically important functions?

I haven't looked at the users of net_rand_state, but historically, the
networking subsystem has a expressed a (perceived?) need for *very* fast
mostly-random-but-if-doens't-have-to-be-perfect-numbers-our-benchmarks-
are-way-more-important numbers.   As in, if there are extra cache line
misses, our benchmarks would suffer and that's not acceptable.

One of the problems here is that it's not sufficient for the average case
to be fast, but once in every N operations, we need to do something that
requires Real Crypto, and so that Nth time, there would be an extra lag
and that would be the end of the world (at least as far as networking
benchmarks are concerned, anyway).   So in other words, it's not enough for
the average time to run get_random_u32() to be fast, they care about the 95th or
99th percentile number of get_random_u32() to be fast as well.

An example of this would be for TCP sequence number generation; it's
not *really* something that needs to be secure, and if we rekey the
RNG every 5 minutes, so long as the best case attack takes at most,
say, an hour, if the worst the attacker can do is to be able to carry
out an man-in-the-middle attack without being physically in between
the source and the destination --- well, if you *really* cared about
security the TCP connection would be protected using TLS anyway.  See
RFC 1948 (later updated by RFC 6528) for an argument along these
lines.

> This whole thing is making the fundamental mistake of all amateur
> cryptographers of trying to create your own cryptographic primitive. You're
> trying to invent a secure stream cipher. Either don't try to make
> net_rand_state secure, or use a known secure primitive.

Well, technically it's not supposed to be a secure cryptographic
primitive.  net_rand_state is used in the call prandom_u32(), so the
only supposed guarantee is PSEUDO random.

That being said, a quick "get grep prandom_u32" shows that there are a
*huge* number of uses of prandom_u32() and whether they are all
appropriate uses of prandom_u32(), or kernel developers are using it
because "I haz a ne3D for spE3d" but in fact it's for a security
critical application is a pretty terrifying question.  If we start
seeing CVE's getting filed caused by inappropriate uses of
prandom_u32, to be honest, it won't surprise me.

						- Ted
