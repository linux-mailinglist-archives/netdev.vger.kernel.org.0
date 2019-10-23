Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6BE124E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbfJWGkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:40:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:60402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728697AbfJWGkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 02:40:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9AD87B3F4;
        Wed, 23 Oct 2019 06:40:13 +0000 (UTC)
Date:   Wed, 23 Oct 2019 08:40:12 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] mm: memcontrol: fix network errors from failing
 __GFP_ATOMIC charges
Message-ID: <20191023064012.GB754@dhcp22.suse.cz>
References: <20191022233708.365764-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022233708.365764-1-hannes@cmpxchg.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 22-10-19 19:37:08, Johannes Weiner wrote:
> While upgrading from 4.16 to 5.2, we noticed these allocation errors
> in the log of the new kernel:
> 
> [ 8642.253395] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
> [ 8642.269170]   cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
> [ 8642.293009]   node 0: slabs: 5, objs: 170, free: 0
> 
>         slab_out_of_memory+1
>         ___slab_alloc+969
>         __slab_alloc+14
>         kmem_cache_alloc+346
>         inet_twsk_alloc+60
>         tcp_time_wait+46
>         tcp_fin+206
>         tcp_data_queue+2034
>         tcp_rcv_state_process+784
>         tcp_v6_do_rcv+405
>         __release_sock+118
>         tcp_close+385
>         inet_release+46
>         __sock_release+55
>         sock_close+17
>         __fput+170
>         task_work_run+127
>         exit_to_usermode_loop+191
>         do_syscall_64+212
>         entry_SYSCALL_64_after_hwframe+68
> 
> accompanied by an increase in machines going completely radio silent
> under memory pressure.

This is really worrying because that suggests that something depends on
GFP_ATOMIC allocation which is fragile and broken. 
 
> One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account
> sock objects to kmemcg"), which made these slab caches subject to
> cgroup memory accounting and control.
> 
> The problem with that is that cgroups, unlike the page allocator, do
> not maintain dedicated atomic reserves. As a cgroup's usage hovers at
> its limit, atomic allocations - such as done during network rx - can
> fail consistently for extended periods of time. The kernel is not able
> to operate under these conditions.
> 
> We don't want to revert the culprit patch, because it indeed tracks a
> potentially substantial amount of memory used by a cgroup.
> 
> We also don't want to implement dedicated atomic reserves for cgroups.
> There is no point in keeping a fixed margin of unused bytes in the
> cgroup's memory budget to accomodate a consumer that is impossible to
> predict - we'd be wasting memory and get into configuration headaches,
> not unlike what we have going with min_free_kbytes. We do this for
> physical mem because we have to, but cgroups are an accounting game.
> 
> Instead, account these privileged allocations to the cgroup, but let
> them bypass the configured limit if they have to. This way, we get the
> benefits of accounting the consumed memory and have it exert pressure
> on the rest of the cgroup, but like with the page allocator, we shift
> the burden of reclaimining on behalf of atomic allocations onto the
> regular allocations that can block.

On the other hand this would allow to break the isolation by an
unpredictable amount. Should we put a simple cap on how much we can go
over the limit. If the memcg limit reclaim is not able to keep up with
those overflows then even __GFP_ATOMIC allocations have to fail. What do
you think?

> Cc: stable@kernel.org # 4.18+
> Fixes: e699e2c6a654 ("net, mm: account sock objects to kmemcg")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8090b4c99ac7..c7e3e758c165 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2528,6 +2528,15 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> +	/*
> +	 * Memcg doesn't have a dedicated reserve for atomic
> +	 * allocations. But like the global atomic pool, we need to
> +	 * put the burden of reclaim on regular allocation requests
> +	 * and let these go through as privileged allocations.
> +	 */
> +	if (gfp_mask & __GFP_ATOMIC)
> +		goto force;
> +
>  	/*
>  	 * Unlike in global OOM situations, memcg is not in a physical
>  	 * memory shortage.  Allow dying and OOM-killed tasks to
> -- 
> 2.23.0
> 

-- 
Michal Hocko
SUSE Labs
