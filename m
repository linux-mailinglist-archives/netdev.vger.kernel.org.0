Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3061244C71
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgHNQGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:06:50 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40119 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgHNQGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 12:06:39 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07EG5p0m011663;
        Fri, 14 Aug 2020 18:05:51 +0200
Date:   Fri, 14 Aug 2020 18:05:51 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200814160551.GA11657@1wt.eu>
References: <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG>
 <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu>
 <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu>
 <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu>
 <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 05:32:32PM +0200, Sedat Dilek wrote:
> commit 94c7eb54c4b8e81618ec79f414fe1ca5767f9720
> "random32: add a tracepoint for prandom_u32()"
> 
> ...I gave Willy's patches a try and used the Linux Test Project (LTP)
> for testing.

Just FWIW today I could run several relevant tests with a 40 Gbps NIC
at high connection rates and under SYN flood to stress SYN cookies.
I couldn't post earlier due to a net outage but will post the results
here. In short, what I'm seeing is very good. The only thing is that
the noise collection as-is with the 4 longs takes a bit too much CPU
(0.2% measured) but if keeping only one word we're back to tausworthe
performance, while using siphash all along.

The noise generation function is so small that we're wasting cycles
calling it and renaming registers. I'll run one more test by inlining
it and exporting the noise.

So provided quite some cleanup now, I really think we're about to
reach a solution which will satisfy everyone. More on this after I
extract the results.

Willy
