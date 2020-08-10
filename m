Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2756F2407E3
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHJOxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:53:41 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:39692 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgHJOxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 10:53:40 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07AErImr009069;
        Mon, 10 Aug 2020 16:53:18 +0200
Date:   Mon, 10 Aug 2020 16:53:18 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Florian Westphal <fw@strlen.de>
Cc:     George Spelvin <lkml@sdf.org>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810145318.GB9060@1wt.eu>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
 <20200810120302.GD19310@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810120302.GD19310@breakpoint.cc>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 02:03:02PM +0200, Florian Westphal wrote:
> As this relates to networking, you could also hook perturbation into rx/tx
> softirq processing.  E.g. once for each new napi poll round or only once
> for each softnet invocation, depending on cost.

I was wondering what/where to add some processing. I was thinking about
having a per_cpu "noise" variable that would get mixed with the randoms
when generated. This "noise" would need to be global so that we can easily
append to it. For example on the network path it would be nice to use
checksums but nowadays they're not calculated anymore.

> IIRC the proposed draft left a unused prandom_seed() stub around, you could
> re-use that to place extra data to include in the hash in percpu data.

Probably. What I saw was that prandom_seed() expected to perform a full
(hence slow) reseed. Instead I'd like to do something cheap. I like the
principle of "noise" in that it doesn't promise to bring any security,
only to perturb a little bit.

Willy
