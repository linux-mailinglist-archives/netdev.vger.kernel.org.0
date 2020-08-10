Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A406240B84
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgHJQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:59:19 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39707 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgHJQ7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 12:59:18 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07AGwxFj009114;
        Mon, 10 Aug 2020 18:58:59 +0200
Date:   Mon, 10 Aug 2020 18:58:59 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
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
        Florian Westphal <fw@strlen.de>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810165859.GD9060@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 09:31:48AM -0700, Linus Torvalds wrote:
> On Mon, Aug 10, 2020 at 4:47 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> > Doing testing on real hardware showed that retrieving the TSC on every
> > call had a non negligible cost, causing a loss of 2.5% on the accept()
> > rate and 4% on packet rate when using iptables -m statistics.
> 
> And by "real hardware" I assume you mean x86, with a fairly fast and
> high-performance TSC for get_random_entropy().

Yep.

> Reading the TSC takes on the order of 20-50 cycles, iirc.
> 
> But it can actually be *much* more expensive. On non-x86, it can be an
> IO cycle to external chips.

I took what we were already using in add_interrupt_randomness() since
I considered that if it was acceptable there, it probably was elsewhere.

> And on older hardware VM's in x86, it can be a vm exit etc, so
> thousands of cycles. I hope nobody uses those VM's any more, but it
> would be a reasonable test-case for some non-x86 implementations, so..

Yes, I remember these ones, they were not fun at all.

> IOW, no. You guys are - once again - ignoring reality.

I'm not ignoring reality, quite the opposite, trying to take all knowledge
into account. If I'm missing some points, fine. But if we were already
calling that in the interrupt handler I expected that this would be OK.

The alternative Florian talked about is quite interesting as well,
which is to collect some cheap noise in the network rx/tx paths since
these are the areas we care about.

Willy
