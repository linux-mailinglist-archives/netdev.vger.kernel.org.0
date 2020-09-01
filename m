Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00435258DC3
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgIAL6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 07:58:53 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41211 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIAL6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 07:58:47 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 081Bvts2001080;
        Tue, 1 Sep 2020 13:57:55 +0200
Date:   Tue, 1 Sep 2020 13:57:55 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Subject: Re: [PATCH 2/2] random32: add noise from network and scheduling
 activity
Message-ID: <20200901115755.GA1059@1wt.eu>
References: <20200901064302.849-1-w@1wt.eu>
 <20200901064302.849-3-w@1wt.eu>
 <ed5d4d2a-0f8f-f202-8c4f-9fc3d4307e97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed5d4d2a-0f8f-f202-8c4f-9fc3d4307e97@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Tue, Sep 01, 2020 at 12:24:38PM +0200, Eric Dumazet wrote:
> There is not much entropy here really :
> 
> 1) dev & txq are mostly constant on a typical host (at least the kind of hosts that is targeted by 
> Amit Klein and others in their attacks.
> 
> 2) len is also known by the attacker, attacking an idle host.
> 
> 3) skb are also allocations from slab cache, which tend to recycle always the same pointers (on idle hosts)
> 
> 
> 4) jiffies might be incremented every 4 ms (if HZ=250)

I know. The point is essentially that someone "remote" or with rare access
to the host's memory (i.e. in a VM on the same CPU sharing L1 with some
CPU vulnerabilities) cannot synchronize with the PRNG and easily stay
synchronized forever. Otherwise I totally agree that these are pretty
weak. But in my opinion they are sufficient to turn a 100% success into
way less. I try not to forget that we're just trying to make a ~15-bit
port require ~2^14 attempts on average. Oh and by the way the number of
calls also counts here.

> Maybe we could feed percpu prandom noise with samples of ns resolution timestamps,
> lazily cached from ktime_get() or similar functions.
>
> This would use one instruction on x86 to update the cache, with maybe more generic noise.

Sure! I think the principle here allows to easily extend it to various
places, and the more the better. Maybe actually we'll figure that there
are plenty of sources of randomness that were not considered secure enough
to feed /dev/random while they're perfectly fine for such use cases.

> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 4c47f388a83f17860fdafa3229bba0cc605ec25a..a3e026cbbb6e8c5499ed780e57de5fa09bc010b6 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -751,7 +751,7 @@ ktime_t ktime_get(void)
>  {
>         struct timekeeper *tk = &tk_core.timekeeper;
>         unsigned int seq;
> -       ktime_t base;
> +       ktime_t res, base;
>         u64 nsecs;
>  
>         WARN_ON(timekeeping_suspended);
> @@ -763,7 +763,9 @@ ktime_t ktime_get(void)
>  
>         } while (read_seqcount_retry(&tk_core.seq, seq));
>  
> -       return ktime_add_ns(base, nsecs);
> +       res = ktime_add_ns(base, nsecs);
> +       __this_cpu_add(prandom_noise, (unsigned long)ktime_to_ns(res));
> +       return res;
>  }
>  EXPORT_SYMBOL_GPL(ktime_get);

Actually it could even be nice to combine it with __builtin_return_address(0)
given the large number of callers this one has! But I generally agree with
your proposal.

Thanks,
Willy
