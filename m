Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0A23D13A
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgHET6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:58:09 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39428 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbgHET6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 15:58:07 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 075JcO2H017992;
        Wed, 5 Aug 2020 21:38:24 +0200
Date:   Wed, 5 Aug 2020 21:38:24 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200805193824.GA17981@1wt.eu>
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu>
 <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Wed, Aug 05, 2020 at 09:06:40AM -0700, Marc Plumb wrote:
> Just because you or I don't have a working exploit doesn't mean that someone
> else isn't more clever.

I agree on the principle, but it can be said from many things, including
our respective inability to factor large numbers for example. But for
sure we do need to be careful, and actually picking only some limited
parts of the fast pool (which are only used to update the input pool
and are only made of low-difficulty stuff like instruction pointers,
jiffies and TSC values) is probably not going to disclose an extremely
well guarded secret.

> The fundamental question is: Why is this attack on net_rand_state problem?
> It's Working as Designed. Why is it a major enough problem to risk harming
> cryptographically important functions?

It's not *that* major an issue (in my personal opinion) but the current
net_rand_state is easy enough to guess so that an observer may reduce
the difficulty to build certain attacks (using known source ports for
example). The goal of this change (and the one in update_process_times())
is to disturb the net_rand_state a little bit so that external observations
turn from "this must be that" to "this may be this or maybe that", which
is sufficient to limit the ability to reliably guess a state and reduce
the cost of an attack.

Another approach involving the replacement of the algorithm was considered
but we were working with -stable in mind, trying to limit the backporting
difficulty (and it revealed a circular dependency nightmare that had been
sleeping there for years), and making the changes easier to check (which
is precisely what you're doing).

> Do you remember how you resisted making dev/urandom fast for large reads for
> a long time to punish stupid uses of the interface? In this case anyone who
> is using net_rand_state assuming it is a CPRNG should stop doing that. Don't
> enable stupidity in the kernel.
> 
> This whole thing is making the fundamental mistake of all amateur
> cryptographers of trying to create your own cryptographic primitive. You're
> trying to invent a secure stream cipher. Either don't try to make
> net_rand_state secure, or use a known secure primitive.

We're not trying to invent any stream cipher or whatever, just making
use of a few bits that are never exposed alone as-is to internal nor
external states, to slightly disturb another state that otherwise only
changes once a minute so that there's no more a 100% chance of guessing
a 16-bit port after seeing a few packets. I mean, I'm pretty sure that
even stealing three or four bits only from there would be quite enough
to defeat the attack given that Amit only recovers a few bits per packet.

For me the right longterm solution will be to replace the easily guessable
LFSR. But given the build breakage we got by just adding one include, I
can only guess what we'll see when trying to do more in this area :-/

Regards,
Willy
