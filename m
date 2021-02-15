Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C26F31BE68
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhBOQJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbhBOQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:06:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D427AC0613D6;
        Mon, 15 Feb 2021 08:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ABknkne7Nrn83Z017RdB6TUScjJdC65GnVh/Mnzaro4=; b=OhNLW94ejUS39Nx7GhTuQ7ezdo
        q5Wb7HXw3WDjDr/XnEMyiKNF5Uxs9VTjZBW+3vEUNADCSPX5PvM77kgXHpbL7bgAujmpCQ5cflRMe
        tTgMXTJRBXrL7pptc1mjtI4Jb+Qby+L9ULklOfDMW0Dl/q7eIbus7Trt8VNc+I11PIct7CPbs7t8D
        0PeT8FwhMlogzUvkCLX9hiAhpOezlGe1hVcHmhsWIwL93pymNLCGpOaHgh+7EqwwQL8oYfRkyi1uW
        igN+zxx/JApi6jslEPnSmi77+yruJVv/f3P68A4EU9er5WeSclCa3/+wZCUuIxe0eSgGCmWJOYPTg
        L2U9YsRQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lBgM7-00Fky1-Ex; Mon, 15 Feb 2021 16:04:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 430053007CD;
        Mon, 15 Feb 2021 17:04:10 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2CD1D20431BC4; Mon, 15 Feb 2021 17:04:10 +0100 (CET)
Date:   Mon, 15 Feb 2021 17:04:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, mingo@redhat.com,
        will@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
Message-ID: <YCqbehyyeUoL0pPT@hirez.programming.kicks-ass.net>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
 <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
 <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
 <20210215104402.GC4507@worktop.programming.kicks-ass.net>
 <79aeb83a288051bd3a2a3f15e5ac42e06f154d48.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79aeb83a288051bd3a2a3f15e5ac42e06f154d48.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 02:12:30PM +0100, Johannes Berg wrote:
> On Mon, 2021-02-15 at 11:44 +0100, Peter Zijlstra wrote:
> > 
> > I think something like so will work, but please double check.
> 
> Yeah, that looks better.
> 
> > +++ b/include/linux/lockdep.h
> > @@ -294,11 +294,15 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
> >  
> >  #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
> >  
> > -#define lockdep_assert_held(l)	do {				\
> > -		WARN_ON(debug_locks && !lockdep_is_held(l));	\
> > +#define lockdep_assert_held(l)	do {					\
> > +		WARN_ON(debug_locks && lockdep_is_held(l) == 0));	\
> >  	} while (0)
> 
> That doesn't really need to change? It's the same.

Correct, but I found it more symmetric vs the not implementation below.

> > -#define lockdep_assert_held_write(l)	do {			\
> > +#define lockdep_assert_not_held(l)	do {				\
> > +		WARN_ON(debug_locks && lockdep_is_held(l) == 1));	\
> > +	} while (0)
> > +
> > +#define lockdep_assert_held_write(l)	do {				\
> >  		WARN_ON(debug_locks && !lockdep_is_held_type(l, 0));	\
> >  	} while (0)
> >  
> > diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> > index c1418b47f625..983ba206f7b2 100644
> > --- a/kernel/locking/lockdep.
> > +++ b/kernel/locking/lockdep.c
> > @@ -5467,7 +5467,7 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
> >  	int ret = 0;
> >  
> >  	if (unlikely(!lockdep_enabled()))
> > -		return 1; /* avoid false negative lockdep_assert_held() */
> > +		return -1; /* avoid false negative lockdep_assert_held() */
> 
> Maybe add lockdep_assert_not_held() to the comment, to explain the -1
> (vs non-zero)?

Yeah, or frob a '*' in there.
