Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1EE23F4D1
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGWTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:19:32 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39522 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgHGWTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 18:19:32 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 077MJDvK006853;
        Sat, 8 Aug 2020 00:19:13 +0200
Date:   Sat, 8 Aug 2020 00:19:13 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     tytso@mit.edu, netdev@vger.kernel.org, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200807221913.GA6846@1wt.eu>
References: <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805193824.GA17981@1wt.eu>
 <344f15dd-a324-fe44-54d4-c87719283e35@gmail.com>
 <20200806063035.GC18515@1wt.eu>
 <50b046ee-d449-8e6c-1267-f4060b527c06@gmail.com>
 <20200807070316.GA6357@1wt.eu>
 <a1833e06-1ce5-9a2b-f518-92e7c6b47d4f@gmail.com>
 <20200807174302.GA6740@1wt.eu>
 <9148811b-64f9-a18c-ddeb-b1ff4b34890e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9148811b-64f9-a18c-ddeb-b1ff4b34890e@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 12:59:48PM -0700, Marc Plumb wrote:
> 
> On 2020-08-07 10:43 a.m., Willy Tarreau wrote:
> > 
> > > Which means that it's 2^32 effort to brute force this (which Amit called "no
> > > biggie for modern machines"). If the noise is the raw sample data with only
> > > a few bits of entropy, then it's even easier to brute force.
> > Don't you forget to multiply by another 2^32 for X being folded onto itself ?
> > Because you have 2^32 possible values of X which will give you a single 32-bit
> > output value for a given noise value.
> 
> If I can figure the state out once,

Yes but how do you take that as granted ? This state doesn't appear
without its noise counterpart, so taking as a prerequisite that you may
guess one separately obviously indicates that you then just have to
deduce the other, but the point of mixing precisely is that we do not
expose individual parts.

This way of thinking is often what results in extreme solutions to be
designed, which are far away from the reality of the field of application,
and result in unacceptable costs that make people turn to other solutions.
Do you think it makes me happy to see people waste their time reimplementing
alternate userland TCP stacks that are supposedly "way faster" by getting
rid of all the useless (to them) stuff that was forced on them at the cost
of performance ? And it makes me even less happy when they ask me why I'm
not spending more time trying to adopt them. The reality is that this time
could be better spent optimizing our stack to be sure that costs are added
where they are relevant, and not just to make sure that when we align 7
conditions starting with "imagine that I could guess that", the 8th could
be guessed as well, except that none of these can really be guessed outside
of a lab :-/

> then the only new input is the noise, so
> that's the only part I have to brute force. Throwing the noise in makes it
> more difficult to get that state once, but once I have it then this type of
> reseeding doesn't help.

> I think it might be possible to do a decent CPRNG (that's at
> least had some cryptanalys of it) with ~20 instructions per word, but if
> that's not fast enough then I'll think about other options.

I think that around 20 instructions for a hash would definitely be nice
(but please be aware that we're speaking about RISC-like instructions,
not SIMD instructions). And also please be careful not to count only
with amortized performance that's only good to show nice openssl
benchmarks, because if that's 1280 instructions for 256 bits that
result in 20 instructions per 32-bit word, it's not the same anymore
at all!

Regards,
Willy
