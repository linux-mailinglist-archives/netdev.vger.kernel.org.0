Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0A6D3308
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjDASDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDASDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:03:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACED1D922
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62974B80D42
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 18:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE336C433D2;
        Sat,  1 Apr 2023 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680372223;
        bh=Hz0i/LmonWwb6n6Ber87KE5wR4fui8nXWT786/nzV1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZhNkI/j6aJOiYjEe9IxgMfrYzLP6QlKVogKlOq6tKq+5tzChBiK8NRw6L96ZV3ahe
         Q/or8TX48vcUgFcYnVZ19GRVMRcJ4VQ/4jYEDAXkkNStguyEtzw9RnpSSZUpW20hD7
         4ai1+6OIcV5t/B1Dz3AEk+myLcK5uJgJF/jIjfDKIpKzFAeWNI3nFVjBgjG038EIEd
         svOitSrpFF/GRYVKDCpfCxxHnrTRHhr8Q+PyffMm2b9cAzCVL0ATYThTPsl9DsGAui
         oS++1Wgry+Lgqz6uXMwqXRpyVTxpVMZxH5ZKrrqL1RgWjz1whU7MIghLgLFYQd7yi3
         lGedYgDxBmBYg==
Date:   Sat, 1 Apr 2023 11:03:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230401110341.7213900c@kernel.org>
In-Reply-To: <5b997cab-d5ee-9772-7555-8d7e8eaccb16@gmail.com>
References: <20230401051221.3160913-1-kuba@kernel.org>
        <20230401051221.3160913-2-kuba@kernel.org>
        <5b997cab-d5ee-9772-7555-8d7e8eaccb16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 17:04:17 +0200 Heiner Kallweit wrote:
> > +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		netif_tx_stop_queue(txq);				\
> > +									\
> > +		smp_mb();						\  
> 
> Wouldn't a smp_mb__after_atomic() be sufficient here, because netif_tx_stop_queue()
> includes a set_bit()? At least on X86 this would result in a no-op.

Yup, good point, __after_atomic() should be perfectly fine. I didn't
think too much about the smp_mb() 'cause it's what existing code was
using and it's a slow path. I'll fix in v3.

> > +									\
> > +		/* We need to check again in a case another		\
> > +		 * CPU has just made room available.			\
> > +		 */							\
> > +		_res = 0;						\
> > +		if (unlikely(get_desc >= start_thrs)) {			\
> > +			netif_tx_start_queue(txq);			\
> > +			_res = -1;					\
> > +		}							\
> > +		_res;							\
> > +	})								\
> > +
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
> > +#define netif_tx_queue_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	\
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		_res = 1;						\
> > +		if (unlikely(get_desc < stop_thrs))			\
> > +			_res = netif_tx_queue_try_stop(txq, get_desc,	\
> > +						       start_thrs);	\
> > +		_res;							\
> > +	})								\
> > +
> > +#define __netif_tx_queue_try_wake(txq, get_desc, start_thrs, down_cond) \  
> 
> Maybe I miss something, but: Why the get_desc and start_thrs parameters
> if they aren't used?

Copy'n'paste fail, will fix :(
