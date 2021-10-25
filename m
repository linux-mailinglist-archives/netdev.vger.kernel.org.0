Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E7E43A37D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhJYT7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238555AbhJYT5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB05C6117A;
        Mon, 25 Oct 2021 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635191310;
        bh=pjFBSZY6UwFbUcF2u0MrCUQ/DcBKBFRby4HT/sbIwt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ftgnZU3qLArx0CraeAcz+xxVAhsUhRpC00hUD0P53t9KhJm7NHpD3AppF4xxoet3m
         ztPTxuo6S4TCswzyzMmIbLJfvtZUaT9f/VKgQc6FpQubr1UYBV8rx46EAJTgaS8eri
         P5/1mr9EH+/yvs+JrBZO3+UwO7gBrvTu1mqRErEbf6hU+pqL3p8sQJ2nAQhJJYoRRq
         oM/xNedBsckx88SZTQsGeddr5ggxJjrehpqnpzduDdQaUx8mrQp0gGk/RyU0t7tWz1
         dmT2nuSTnwOYn3E2EdCfSs1h3huLITZDC4NDWfetlC1cxCCf8gncpNGbUY/rlc8hSN
         KpG1QhyZ5G/9w==
Date:   Mon, 25 Oct 2021 12:48:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Seth Forshee <seth@forshee.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sch: eliminate unnecessary RCU waits in
 mini_qdisc_pair_swap()
Message-ID: <20211025124828.1e4900e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022161747.81609-1-seth@forshee.me>
References: <20211022161747.81609-1-seth@forshee.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 11:17:46 -0500 Seth Forshee wrote:
> From: Seth Forshee <sforshee@digitalocean.com>
> 
> Currently rcu_barrier() is used to ensure that no readers of the
> inactive mini_Qdisc buffer remain before it is reused. This waits for
> any pending RCU callbacks to complete, when all that is actually
> required is to wait for one RCU grace period to elapse after the buffer
> was made inactive. This means that using rcu_barrier() may result in
> unnecessary waits.
> 
> To improve this, store the current RCU state when a buffer is made
> inactive and use poll_state_synchronize_rcu() to check whether a full
> grace period has elapsed before reusing it. If a full grace period has
> not elapsed, wait for a grace period to elapse, and in the non-RT case
> use synchronize_rcu_expedited() to hasten it.
> 
> Since this approach eliminates the RCU callback it is no longer
> necessary to synchronize_rcu() in the tp_head==NULL case. However, the
> RCU state should still be saved for the previously active buffer.
> 
> Before this change I would typically see mini_qdisc_pair_swap() take
> tens of milliseconds to complete. After this change it typcially
> finishes in less than 1 ms, and often it takes just a few microseconds.
> 
> Thanks to Paul for walking me through the options for improving this.
> 
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>

LGTM, but please rebase and retest on top of latest net-next.

>  void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
>  			  struct tcf_proto *tp_head)
>  {
> @@ -1423,28 +1419,30 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
>  
>  	if (!tp_head) {
>  		RCU_INIT_POINTER(*miniqp->p_miniq, NULL);
> -		/* Wait for flying RCU callback before it is freed. */
> -		rcu_barrier();
> -		return;
> -	}
> +	} else {
> +		miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
> +			&miniqp->miniq1 : &miniqp->miniq2;
>  
> -	miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
> -		&miniqp->miniq1 : &miniqp->miniq2;

nit: any reason this doesn't read:

	miniq = miniq_old != &miniqp->miniq1 ? 
		&miniqp->miniq1 : &miniqp->miniq2;

Surely it's not equal to miniq1 or miniq2 if it's NULL.

> +		/* We need to make sure that readers won't see the miniq
> +		 * we are about to modify. So ensure that at least one RCU
> +		 * grace period has elapsed since the miniq was made
> +		 * inactive.
> +		 */
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +			cond_synchronize_rcu(miniq->rcu_state);
> +		else if (!poll_state_synchronize_rcu(miniq->rcu_state))
> +			synchronize_rcu_expedited();
>  
> -	/* We need to make sure that readers won't see the miniq
> -	 * we are about to modify. So wait until previous call_rcu callback
> -	 * is done.
> -	 */
> -	rcu_barrier();
> -	miniq->filter_list = tp_head;
> -	rcu_assign_pointer(*miniqp->p_miniq, miniq);
> +		miniq->filter_list = tp_head;
> +		rcu_assign_pointer(*miniqp->p_miniq, miniq);
> +	}
>  
>  	if (miniq_old)
> -		/* This is counterpart of the rcu barriers above. We need to
> +		/* This is counterpart of the rcu sync above. We need to
>  		 * block potential new user of miniq_old until all readers
>  		 * are not seeing it.
>  		 */
> -		call_rcu(&miniq_old->rcu, mini_qdisc_rcu_func);
> +		miniq_old->rcu_state = start_poll_synchronize_rcu();
>  }
>  EXPORT_SYMBOL(mini_qdisc_pair_swap);
>  
> @@ -1463,6 +1461,8 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
>  	miniqp->miniq1.cpu_qstats = qdisc->cpu_qstats;
>  	miniqp->miniq2.cpu_bstats = qdisc->cpu_bstats;
>  	miniqp->miniq2.cpu_qstats = qdisc->cpu_qstats;
> +	miniqp->miniq1.rcu_state = get_state_synchronize_rcu();
> +	miniqp->miniq2.rcu_state = miniqp->miniq1.rcu_state;
>  	miniqp->p_miniq = p_miniq;
>  }
>  EXPORT_SYMBOL(mini_qdisc_pair_init);

