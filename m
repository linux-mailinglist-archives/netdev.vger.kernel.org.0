Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01895437F64
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhJVUip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhJVUip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 16:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 187A861040;
        Fri, 22 Oct 2021 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634934987;
        bh=cUdkA80Ce5JF69nvg9SltuM28KnzdNDHWWYybmZvzm0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Am4hRyyCzfw96qf57RmAVBNMPMJQd2ZyXA3ZYsSWMo+Q7SbYj1okJ7sXeugRoIJOA
         1Pa70v0Oh1Jo5w+EFxY9/NljAc33Rvf4P3CXGNOUcCiACGU+1cJr/H/xCFxvLdEhk0
         Y9mSH5y3Z8cGlxdUD11B7zbIjPS5zFPP6u1V+WyAM+3MADvvuDXzW7YmGnQ3K1gs0u
         SopJhYwpLqmBkYcqXW6JIjV2MqfFud0OrNR+7BGnheVm8CRcc5usAMDIXP2ZCC8Q3M
         RZE3eQ3lRI27upJBTFoyrVKorgUjzYy3q219rNOaXqoRbKMU2szvJ3BNVx4tB6VI5h
         utXISDLW4//fg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id DDBE35C0BF4; Fri, 22 Oct 2021 13:36:26 -0700 (PDT)
Date:   Fri, 22 Oct 2021 13:36:26 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Seth Forshee <seth@forshee.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sch: eliminate unnecessary RCU waits in
 mini_qdisc_pair_swap()
Message-ID: <20211022203626.GD880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211022161747.81609-1-seth@forshee.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022161747.81609-1-seth@forshee.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 11:17:46AM -0500, Seth Forshee wrote:
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

At first glance, this looks plausible to me!

							Thanx, Paul

> ---
>  include/net/sch_generic.h |  2 +-
>  net/sched/sch_generic.c   | 38 +++++++++++++++++++-------------------
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index f8631ad3c868..c725464be814 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -1299,7 +1299,7 @@ struct mini_Qdisc {
>  	struct tcf_block *block;
>  	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
>  	struct gnet_stats_queue	__percpu *cpu_qstats;
> -	struct rcu_head rcu;
> +	unsigned long rcu_state;
>  };
>  
>  static inline void mini_qdisc_bstats_cpu_update(struct mini_Qdisc *miniq,
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 854d2b38db85..8540c12c9a62 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1407,10 +1407,6 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
>  }
>  EXPORT_SYMBOL(psched_ratecfg_precompute);
>  
> -static void mini_qdisc_rcu_func(struct rcu_head *head)
> -{
> -}
> -
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
> -- 
> 2.30.2
> 
