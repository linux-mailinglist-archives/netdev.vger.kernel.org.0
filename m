Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6028F22A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgJOMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:34:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37480 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgJOMei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:34:38 -0400
Date:   Thu, 15 Oct 2020 14:34:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602765276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NFgTAIBVVYhqhIz8iWH/yzFQFjHKOLP1Q64izxAfjeM=;
        b=RncYsLAqAWglGNN8qNmFBXrN6fEBkdyc3bwzs9+e6b2+0N6S+AgGPItht/hT89Z2kDOwuI
        b5BXsFxzJkliQ5Z0tD09Dw3pDYlYXegvgn+Lu8G6cP1p4OioJZF4SEMZG6N2G8IN/OW85E
        IlsedQxZUbMsqqHB7nRD7dji0XJTEpN0iBlBeoCK0xcF4HmT8nHD4wYq/Zvw2xtNVhsIPv
        DxlT3hiQ87J61NICR1I/h1eRp8Se2ht0NibbvVPpOTr8pzbGQlJUBtyaFjoCoe2+v89RE+
        /wXhmuqGvOMQCpMjLAQDAKYq7Mt5e+G2gb+UO7zg7ePas15XDKwMMYfpaIFLCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602765276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NFgTAIBVVYhqhIz8iWH/yzFQFjHKOLP1Q64izxAfjeM=;
        b=K2WMTTaTk7VG5mvUG44yZlfKOIoPNVmMNNARzs1d45uF29CZLuwZ956/C/M91DGWNrUreb
        ItBjTPjcYDPKj0DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [PATCH net v2] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Message-ID: <20201015123434.7tesbva626nczpq5@linutronix.de>
References: <160275519174.566500.6537031776378218151.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160275519174.566500.6537031776378218151.stgit@ebuild>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-15 11:46:53 [+0200], Eelco Chaudron wrote:
> The flow_lookup() function uses per CPU variables, which must not be
> preempted. However, this is fine in the general napi use case where
> the local BH is disabled. But, it's also called in the netlink
> context, which is preemptible. The below patch makes sure that even
> in the netlink path, preemption is disabled.

I would suggest to rephrase it: the term preemption usually means
preempt_disable(). A preempt disabled section can be preempted /
interrupted by hardirq and softirq. The later is mentioned and I think
is confusing.

> In addition, the u64_stats_update_begin() sync point was not protected,
> making the sync point part of the per CPU variable fixed this.

I would rephrase it and mention the key details:
u64_stats_update_begin() requires a lock to ensure one writer which is
not ensured here. Making it per-CPU and disabling NAPI (softirq) ensures
that there is always only one writer.

Regarding the annotation which were mentioned here in the thread.
Basically the this_cpu_ptr() warning worked as expected and got us here.
I don't think it is wise to add annotation distinguished from the actual
problem like assert_the_softirq_is_switched_off() in flow_lookup(). The
assert may become obsolete once the reason is removed and gets overseen
and remains in the code. The commits

	c60c32a577561 ("posix-cpu-timers: Remove lockdep_assert_irqs_disabled()")
	f9dae5554aed4 ("dpaa2-eth: Remove preempt_disable() from seed_pool()")

are just two examples which came to mind while writing this.

Instead I would prefer lockdep annotation in u64_stats_update_begin()
which is around also in 64bit kernels and complains if it is seen
without disabled BH if observed in-serving-softirq.
PeterZ, wasn't this mentioned before?

> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -851,9 +852,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
>  	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
>  	u32 __always_unused n_mask_hit;
>  	u32 __always_unused n_cache_hit;
> +	struct sw_flow *flow;
>  	u32 index = 0;
>  
> -	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
> +	/* This function gets called trough the netlink interface and therefore
> +	 * is preemptible. However, flow_lookup() function needs to be called
> +	 * with preemption disabled due to CPU specific variables.

preemption vs BH.

> +	 */
> +	local_bh_disable();
> +	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
> +	local_bh_enable();
> +	return flow;
>  }
>  
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,

Otherwise it looks good.

Sebastian
