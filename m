Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8380E5A22B8
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiHZIOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343543AbiHZIOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:14:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E45ED4BEC;
        Fri, 26 Aug 2022 01:14:43 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MDXbJ5JcYzkWgh;
        Fri, 26 Aug 2022 16:11:08 +0800 (CST)
Received: from [10.67.102.169] (10.67.102.169) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 16:14:41 +0800
CC:     <yangyicong@hisilicon.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "shenjian (K)" <shenjian15@huawei.com>, <wangjie125@huawei.com>,
        <linux-kernel@vger.kernel.org>, Barry Song <21cnbao@gmail.com>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v3 7/9] sched/topology: Introduce sched_numa_hop_mask()
To:     Valentin Schneider <vschneid@redhat.com>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-8-vschneid@redhat.com>
From:   Yicong Yang <yangyicong@huawei.com>
Message-ID: <9c1d79e4-cdfb-8fe9-60a2-9eea259d6960@huawei.com>
Date:   Fri, 26 Aug 2022 16:14:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20220825181210.284283-8-vschneid@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.169]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/8/26 2:12, Valentin Schneider wrote:
> Tariq has pointed out that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness - cpumask_local_spread() only knows
> about the local node and everything outside is in the same bucket.
> 
> sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
> of CPUs reachable within a given distance budget), introduce
> sched_numa_hop_mask() to export those cpumasks.
> 
> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  include/linux/topology.h |  9 +++++++++
>  kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e1..13b82b83e547 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,14 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>  	return cpumask_of_node(cpu_to_node(cpu));
>  }
>  
> +#ifdef CONFIG_NUMA
> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +#else
> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +#endif	/* CONFIG_NUMA */
> +
>  

I think it should be better to return cpu_online_mask() if CONFIG_NUMA=n and hop is 0. Then we
can keep the behaviour consistent with cpumask_local_spread() which for_each_numa_hop_cpu is
going to replace.

The macro checking maybe unnecessary, check whether node is NUMA_NO_NODE will handle the case
where NUMA is not configured.

Thanks.

>  #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54e..f0236a0ae65c 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  	return found;
>  }
>  
> +/**
> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
> + * @node: The node to count hops from.
> + * @hops: Include CPUs up to that many hops away. 0 means local node.
> + *
> + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> + * read-side section, copy it if required beyond that.
> + *
> + * Note that not all hops are equal in size; see sched_init_numa() for how
> + * distances and masks are handled.
> + *
> + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> + * during the lifetime of the system (offline nodes are taken out of the masks).
> + */
> +const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> +
> +	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (!masks)
> +		return NULL;
> +
> +	return masks[hops][node];
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
> +
>  #endif /* CONFIG_NUMA */
>  
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> 
