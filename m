Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842D36411CC
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 01:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiLCADg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 19:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLCADf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 19:03:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C661659D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:03:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 301D1CE200A
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 00:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16817C433D6;
        Sat,  3 Dec 2022 00:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670025806;
        bh=KCS5W51ipdkr/1ao/PPqU/NkXpYk59Efj5QOnqXZ68o=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=pbmrbraQMR/6JrR4sOdSC1fqicP9u9MICGv+haNyUDzZVspogk/5nK6mTJxmya+4d
         U2ufhr6BUOg3oM8EPFbIvYsHg+VniDgttZEiXvvvhhIN+L8rfGGVuaDQoaAQD7GQsg
         1VcXO6nDvPIaB9g2W3mI5qmdRAaedDhvB2NTyko3TaPXSVGPBaFy5K2a2Fmc7DVtSe
         GFF1H+AI3AoMHbrUC3vCO1nrQyM21Bxj4OCKi4Arz3J7IzkyZvq0AKkVJD6+Q3m/Rx
         1zngIDnmDsoDBWhLrAmRHTDj0XhnZnCUP/473K5mVXq6GEnughzlCuDXdaP2j6rCgo
         RnH7gVUZNdQzg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A462C5C095D; Fri,  2 Dec 2022 16:03:25 -0800 (PST)
Date:   Fri, 2 Dec 2022 16:03:25 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <20221203000325.GL4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221202052847.2623997-1-edumazet@google.com>
 <Y4qPJ89SBWACbbTr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4qPJ89SBWACbbTr@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:49:59PM +0000, Joel Fernandes wrote:
> On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> > kfree_rcu(1-arg) should be avoided as much as possible,
> > since this is only possible from sleepable contexts,
> > and incurr extra rcu barriers.
> > 
> > I wish the 1-arg variant of kfree_rcu() would
> > get a distinct name, like kfree_rcu_slow()
> > to avoid it being abused.
> 
> Hi Eric,
> Nice to see your patch.
> 
> Paul, all, regarding Eric's concern, would the following work to warn of
> users? Credit to Paul/others for discussing the idea on another thread. One
> thing to note here is, this debugging will only be in effect on preemptible
> kernels, but should still help catch issues hopefully.

Mightn't there be some places where someone needs to invoke
single-argument kfree_rcu() in a preemptible context, for example,
due to the RCU-protected structure being very small and very numerous?

> The other idea Paul mentioned is to introduce a new dedicated API for 1-arg
> sleepable cases. My concern with that was that, that being effective depends
> on the user using the right API in the first place.

Actually, Eric's idea from above.  ;-)

							Thanx, Paul

> I did not test it yet, but wanted to discuss a bit first.
> 
> Cheers,
> 
> - Joel
> 
> ---8<-----------------------
> 
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 9bc025aa79a3..112d230279ea 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -106,6 +106,11 @@ static inline void __kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func)
>  	}
>  
>  	// kvfree_rcu(one_arg) call.
> +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible() && !head) {
> +		WARN_ONCE(1, "%s(): Please provide an rcu_head in preemptible"
> +			  " contexts to avoid long waits!\n", __func__);
> +	}
> +
>  	might_sleep();
>  	synchronize_rcu();
>  	kvfree((void *) func);
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 0ca21ac0f064..b29df1305a2e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3324,6 +3324,11 @@ void kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func)
>  		 * only. For other places please embed an rcu_head to
>  		 * your data.
>  		 */
> +		if (IS_ENABLED(CONFIG_PREEMPT_COUNT) && preemptible() && !head) {
> +			WARN_ONCE(1, "%s(): Please provide an rcu_head in preemptible"
> +				  " contexts to avoid long waits!\n", __func__);
> +		}
> +
>  		might_sleep();
>  		ptr = (unsigned long *) func;
>  	}
