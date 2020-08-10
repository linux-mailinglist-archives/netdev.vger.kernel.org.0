Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A9240586
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgHJMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgHJMDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 08:03:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C68C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 05:03:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k56W6-00023S-Jo; Mon, 10 Aug 2020 14:03:02 +0200
Date:   Mon, 10 Aug 2020 14:03:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org,
        fw@strlen.de
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200810120302.GD19310@breakpoint.cc>
References: <20200808152628.GA27941@SDF.ORG>
 <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu>
 <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu>
 <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810114700.GB8474@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willy Tarreau <w@1wt.eu> wrote:
> On Sun, Aug 09, 2020 at 06:30:17PM +0000, George Spelvin wrote:
> > Even something simple like buffering 8 TSC samples, and adding them
> > at 32-bit offsets across the state every 8th call, would make a huge
> > difference.
> 
> Doing testing on real hardware showed that retrieving the TSC on every
> call had a non negligible cost, causing a loss of 2.5% on the accept()
> rate and 4% on packet rate when using iptables -m statistics. However
> I reused your idea of accumulating old TSCs to increase the uncertainty
> about their exact value, except that I retrieve it only on 1/8 calls
> and use the previous noise in this case. With this I observe the same
> performance as plain 5.8. Below are the connection rates accepted on
> a single core :
> 
>         5.8           5.8+patch     5.8+patch+tsc
>    192900-197900   188800->192200   194500-197500  (conn/s)
> 
> This was on a core i7-8700K. I looked at the asm code for the function
> and it remains reasonably light, in the same order of complexity as the
> original one, so I think we could go with that.
> 
> My proposed change is below, in case you have any improvements to suggest.

As this relates to networking, you could also hook perturbation into rx/tx
softirq processing.  E.g. once for each new napi poll round or only once
for each softnet invocation, depending on cost.

IIRC the proposed draft left a unused prandom_seed() stub around, you could
re-use that to place extra data to include in the hash in percpu data.
