Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED3240C93
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgHJSBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:01:53 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39720 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbgHJSBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 14:01:53 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07AI1XLc009132;
        Mon, 10 Aug 2020 20:01:33 +0200
Date:   Mon, 10 Aug 2020 20:01:33 +0200
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
Message-ID: <20200810180133.GB9121@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
 <20200810165859.GD9060@1wt.eu>
 <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 10:45:26AM -0700, Linus Torvalds wrote:
> On Mon, Aug 10, 2020 at 9:59 AM Willy Tarreau <w@1wt.eu> wrote:
> >
> > I took what we were already using in add_interrupt_randomness() since
> > I considered that if it was acceptable there, it probably was elsewhere.
> 
> Once you've taken an interrupt, you're doing IO anyway, and the
> interrupt costs will dominate anything you do.
> 
> But the prandom_u32() interface is potentially done many times per
> interrupt. For all I know it's done inside fairly critical locks etc
> too.
> 
> So I don't think one usage translates to another very well.

Possible, hence the better solution to just feed noise in hot paths.
Using jiffies and skb pointer in xmit is better than nothing anyway.
I'm not seeking anything extremist, I just want to make sure we don't
get yet-another-report on this area next summer just because some
researcher using two VMs discovers that attacking a 100% idle VM from
another one running on the same CPU core is trivial after having stolen
some memory data.  If at least such an attack is boring and rarely
works, the rest of the job is provided by siphash and we should be fine.

Willy
