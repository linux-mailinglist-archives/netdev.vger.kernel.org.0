Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37EB24DFCE
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHUSjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHUSjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:39:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B153CC061573;
        Fri, 21 Aug 2020 11:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qf7iQOKln7FqCs/F0D07PQ4uJRzWTyA3GUp/BaFL3pY=; b=J2WcNmGW4ZaJnH9WyXYj2IWLGP
        MY9g2ejM9VdCuKeFodacvhJLeWrsYgo8nqefHsNPMU4Vbrin1ug/GspWQXhQ95BueAlwJU5UBVfme
        xsSe8aV5Fz96VamAaqHdQ1icy5tdze1dzRwTGt4cLmLg4Kr+Xg9qQPIAXAtJYiZxRyPlRWynCDE5p
        0qjBdYCKHstNv6qSiYmN1wGDOw4/3X+5ZH2gdOVC3Jp7eb+/miXVMoZwyJWaZJS+e5c/nqkeLwCQi
        8+GoU1CglEyEwpGA5NoHefHqEee/kH9Idjl6mMPjdqz8exouGunuAwCseTLazWHRTVt5k6sBsZvrS
        5WvpJlVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9BwK-0001sV-RA; Fri, 21 Aug 2020 18:39:01 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E5DB6980DF7; Fri, 21 Aug 2020 20:38:59 +0200 (CEST)
Date:   Fri, 21 Aug 2020 20:38:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>, Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200821183859.GS3982@worktop.programming.kicks-ass.net>
References: <20200821063043.1949509-1-elver@google.com>
 <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
 <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
 <20200821113831.340ba051@oasis.local.home>
 <20200821114141.4b564190@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821114141.4b564190@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 11:41:41AM -0400, Steven Rostedt wrote:
> On Fri, 21 Aug 2020 11:38:31 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > > At some point we're going to have to introduce noinstr to idle as well.
> > > > But until that time this should indeed cure things.    
> > > 
> 
> What the above means, is that ideally we will get rid of all
> tracepoints and kasan checks from these RCU not watching locations. But

s/and kasan//

We only need to get rid of explicit tracepoints -- typically just move
them outside of the rcu_idle_enter/exit section.

> to do so, we need to move the RCU not watching as close as possible to
> where it doesn't need to be watching, and that is not as trivial of a
> task as one might think.

My recent patch series got a fair way towards that, but yes, there's
more work to be done still.

> Once we get to a minimal code path for RCU not
> to be watching, it will become "noinstr" and tracing and "debugging"
> will be disabled in these sections.

Right, noinstr is like notrace on steriods, not only does it disallow
tracing, it will also disable all the various *SAN/KCOV instrumentation.
It also has objtool based validation which ensures noinstr code doesn't
call out to regular code.

