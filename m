Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF076C7628
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 04:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCXDJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 23:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjCXDJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 23:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068228EBC
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 20:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C5DB82273
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 03:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AC9C433D2;
        Fri, 24 Mar 2023 03:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679627373;
        bh=I1Ast4KwFLj5CTFHIGuh0woN9YGiln3SnpBdQ0REHBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p2P/ZQbZdNi4nbYOVCnKJgt4m31Kbpyrtx03XU+THePgPWdMkqbZtyP1cwMq5abJK
         4WHPvh6KVYrAyOkkT9AP4Usws2myfXz3w8NPjC1Pk3cJTshYjHDeLNSMYoq77eg65k
         EgzIbI6daYk1E6JL5bZiEEMq62IZE/XliZDw2ECPBZB3ZuirBPzlfRDKedvAkvxZ9C
         W+0vNZPYeN16Ms15x28MnTFVMXcSuEpt4GgYCuyd8JCXguq0etju4A1EcZi1Hg8g8v
         51Sn7MD0U4h7zIzujYF8acTKCBlcG6pmaJ+KmGBgEq1LtSPneM8fAWYjZaO8do1gO9
         rjZJZgqpZql2Q==
Date:   Thu, 23 Mar 2023 20:09:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230323200932.7cf30af5@kernel.org>
In-Reply-To: <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
References: <20230322233028.269410-1-kuba@kernel.org>
        <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 09:05:35 -0700 Alexander H Duyck wrote:
> > +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		netif_tx_stop_queue(txq);				\
> > +									\
> > +		smp_mb();						\
> > +									\
> > +		/* We need to check again in a case another		\
> > +		 * CPU has just made room available.			\
> > +		 */							\
> > +		if (likely(get_desc < start_thrs)) {			\
> > +			_res = 0;					\
> > +		} else {						\
> > +			netif_tx_start_queue(txq);			\
> > +			_res = -1;					\
> > +		}							\
> > +		_res;							\
> > +	})								\
> > +  
> 
> The issue I see here is that with this being a macro it abstracts away
> the relationship between get_desc and the memory barrier. At a minimum
> I think we should be treating get_desc as a function instead of just
> passing it and its arguments as a single value. Maybe something more
> like how read_poll_timeout passes the "op" and then uses it as a
> function with args passed seperately. What we want to avoid is passing
> a precomuted value to this function as get_desc.

The kdocs hopefully have enough warnings. The issue I see with
read_poll_timeout() is that I always have to have the definition 
open side by side to match up the arguments. I wish there was 
a way the test that something is not an lval, but I couldn't
find it :(

Let's see if anyone gets this wrong, you can tell me "I told you so"?

> In addition I think I would prefer to see _res initialized to the
> likely value so that we can drop this to one case instead of having to
> have two. Same thing for the macros below.

Alright.

> > +/**
> > + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
> > + * @txq:	struct netdev_queue to stop/start
> > + * @get_desc:	get current number of free descriptors (see requirements below!)
> > + * @stop_thrs:	minimal number of available descriptors for queue to be left
> > + *		enabled
> > + * @start_thrs:	minimal number of descriptors to re-enable the queue, can be
> > + *		equal to @stop_thrs or higher to avoid frequent waking
> > + *
> > + * All arguments may be evaluated multiple times, beware of side effects.
> > + * @get_desc must be a formula or a function call, it must always
> > + * return up-to-date information when evaluated!
> > + * Expected to be used from ndo_start_xmit, see the comment on top of the file.
> > + *
> > + * Returns:
> > + *	 0 if the queue was stopped
> > + *	 1 if the queue was left enabled
> > + *	-1 if the queue was re-enabled (raced with waking)
> > + */  
> 
> We may want to change the values here. The most likely case is "left
> enabled" with that being the case we probably want to make that the 0
> case. I would then probably make 1 the re-enabled case and -1 the
> stopped case.

I chose the return values this way because the important information is
whether the queue was in fact stopped (in case the macro is used at the
start of .xmit as a safety check). If stopped is zero caller can check
!ret vs !!ret.

Seems pretty normal for the kernel function called stop() to return 0
if it did stop.

> With that the decision tree becomes more straightforward as we would do
> something like:
> 	if (result) {
> 		if (result < 0)
> 			Increment stopped stat
> 			return
> 		else
> 			Increment restarted stat
> 	}

Do you see a driver where it matters? ixgbe and co. use
netif_tx_queue_try_stop() and again they just test stopped vs not stopped.

> In addition for readability we may want consider adding an enum simliar
> to the netdev_tx enum as then we have the return types locked and
> usable should we want to specifically pick out one.

Hm, I thought people generally dislike the netdev_tx enum.
Maybe it's just me.

> > +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond) \
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		if (likely(get_desc < start_thrs))			\
> > +			_res = -1;					\
> > +		else							\
> > +			_res = __netif_tx_queue_try_wake(txq, get_desc,	\
> > +							 start_thrs,	\
> > +							 down_cond);	\
> > +		_res;							\
> > +	})
> > +  
> 
> The likely here is probably not correct. In most cases the queue will
> likely have enough descriptors to enable waking since Tx cleanup can
> usually run pretty fast compared to the transmit path itself since it
> can run without needing to take locks.

Good catch, must be a copy paste from the other direction without
inverting the likely.
