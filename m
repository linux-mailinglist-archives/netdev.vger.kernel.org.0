Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFBB23F86B
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHHSI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:08:58 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39562 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgHHSI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 14:08:58 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 078I8ZHE007493;
        Sat, 8 Aug 2020 20:08:35 +0200
Date:   Sat, 8 Aug 2020 20:08:35 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     George Spelvin <lkml@sdf.org>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808180835.GA7480@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 10:07:51AM -0700, Andy Lutomirski wrote:
> 
> > On Aug 8, 2020, at 8:29 AM, George Spelvin <lkml@sdf.org> wrote:
> > 
> 
> > And apparently switching to the fastest secure PRNG currently
> > in the kernel (get_random_u32() using ChaCha + per-CPU buffers)
> > would cause too much performance penalty.
> 
> Can someone explain *why* the slow path latency is particularly relevant
> here?  What workload has the net code generating random numbers in a place
> where even a whole microsecond is a problem as long as the amortized cost is
> low?  (I'm not saying I won't believe this matters, but it's not obvious to
> me that it matters.)

It really depends on what is being done and how we want that code to
continue to be used. Often it will be a matter of queue sizes or
concurrency in certain contexts under a lock. For illustration let's
say you want to use randoms to choose a sequence number for a SYN
cookie (it's not what is done today), a 40G NIC can deliver 60Mpps
or one packet every 16 ns. If you periodically add 1us you end up
queuing 60 extra packets in a queue when this happens. This might
or might not be acceptable. Regarding concurrency, you could imagine
some code picking a random in a small function running under a
spinlock. Frequently adding 1us there can be expensive.

To be clear, I'm not *that* much worried about *some* extra latency,
however I'm extremely worried about the risks of increase once
some security researcher considers the PRNG not secure enough again
(especially once it starts to be used for security purposes after
having being claimed secure) and we replace it with another one
showing a higher cost and longer tail to amortize the cost. And given
that we're speaking about replacing a non-secure PRNG with *something*,
it doesn't seem really wise to start to introduce new constraints on
the data path when there are probably a large enough number of
possibilities which do not require these constraints.

Last point, we must not rule out the possibility than some clever
researcher will later come up with new time-based attacks consisting
in observing latencies of packet processing, explaining how they can
count the number of connections reaching a given host and reveal
certain useful information, and that we're then forced to slow down
all of them to proceed in constant time.

Just my two cents,
Willy
