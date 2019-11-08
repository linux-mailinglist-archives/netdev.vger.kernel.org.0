Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFE8F447F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfKHKbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:31:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:49712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbfKHKbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 05:31:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D6F3BB178;
        Fri,  8 Nov 2019 10:31:03 +0000 (UTC)
Date:   Fri, 8 Nov 2019 11:31:02 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, yuqi jin <jinyuqi@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paul Burton <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] lib: optimize cpumask_local_spread()
Message-ID: <20191108103102.GF15658@dhcp22.suse.cz>
References: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changelog looks better, thanks! I still have some questions though.
Btw. cpumask_local_spread is used by the networking code but I do not
see net guys involved (Cc netdev)

On Thu 07-11-19 09:44:08, Shaokun Zhang wrote:
> From: yuqi jin <jinyuqi@huawei.com>
> 
> In the multi-processors and NUMA system, I/O driver will find cpu cores
> that which shall be bound IRQ. When cpu cores in the local numa have
> been used, it is better to find the node closest to the local numa node,
> instead of choosing any online cpu immediately.
> 
> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 -3) in the 2-cpu
> system(0 - 1).

Please send a topology of this server (numactl -H).

> We perform PS (parameter server) business test, the
> behavior of the service is that the client initiates a request through
> the network card, the server responds to the request after calculation. 

Is the benchmark any ublicly available?

> When two PS processes run on node2 and node3 separately and the
> network card is located on 'node2' which is in cpu1, the performance
> of node2 (26W QPS) and node3 (22W QPS) was different.
> It is better that the NIC queues are bound to the cpu1 cores in turn,
> then XPS will also be properly initialized, while cpumask_local_spread
> only considers the local node. When the number of NIC queues exceeds
> the number of cores in the local node, it returns to the online core
> directly. So when PS runs on node3 sending a calculated request,
> the performance is not as good as the node2. It is considered that
> the NIC and other I/O devices shall initialize the interrupt binding,
> if the cores of the local node are used up, it is reasonable to return
> the node closest to it.

Can you post cpu affinities before and after this patch?

> Let's optimize it and find the nearest node through NUMA distance for the
> non-local NUMA nodes. The performance will be better if it return the
> nearest node than the random node.
> 
> After this patch, the performance of the node3 is the same as node2
> that is 26W QPS when the network card is still in 'node2'. Since it will
> return the closest non-local NUMA code rather than random node, it is no
> harm to others at least.

It would be also nice to explain why the current implementation hasn't
taken the path your have chosen. Was it a simplicity or is there a more
fundamental reason? Is there any risk that existing users would regress?
Preferring cpus from the local socket which is what you aim for sounds
like a logical thing to do so I am wondering why this hasn't been
considered.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: yuqi jin <jinyuqi@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
> ChangeLog from v2:
>     1. Change the variables as static and use spinlock to protect;
>     2. Give more explantation on test and performance;
>  lib/cpumask.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index 0cb672eb107c..b98a2256bc5a 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -6,6 +6,7 @@
>  #include <linux/export.h>
>  #include <linux/memblock.h>
>  #include <linux/numa.h>
> +#include <linux/spinlock.h>
>  
>  /**
>   * cpumask_next - get the next cpu in a cpumask
> @@ -192,18 +193,39 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
>  }
>  #endif
>  
> -/**
> - * cpumask_local_spread - select the i'th cpu with local numa cpu's first
> - * @i: index number
> - * @node: local numa_node
> - *
> - * This function selects an online CPU according to a numa aware policy;
> - * local cpus are returned first, followed by non-local ones, then it
> - * wraps around.
> - *
> - * It's not very efficient, but useful for setup.
> - */
> -unsigned int cpumask_local_spread(unsigned int i, int node)
> +static void calc_node_distance(int *node_dist, int node)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_node_ids; i++)
> +		node_dist[i] = node_distance(node, i);
> +}
> +
> +static int find_nearest_node(int *node_dist, bool *used)
> +{
> +	int i, min_dist = node_dist[0], node_id = -1;
> +
> +	/* Choose the first unused node to compare */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (used[i] == 0) {
> +			min_dist = node_dist[i];
> +			node_id = i;
> +			break;
> +		}
> +	}
> +
> +	/* Compare and return the nearest node */
> +	for (i = 0; i < nr_node_ids; i++) {
> +		if (node_dist[i] < min_dist && used[i] == 0) {
> +			min_dist = node_dist[i];
> +			node_id = i;
> +		}
> +	}
> +
> +	return node_id;
> +}
> +
> +static unsigned int __cpumask_local_spread(unsigned int i, int node)
>  {
>  	int cpu;
>  
> @@ -231,4 +253,60 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>  	}
>  	BUG();
>  }
> +
> +static DEFINE_SPINLOCK(spread_lock);
> +/**
> + * cpumask_local_spread - select the i'th cpu with local numa cpu's first
> + * @i: index number
> + * @node: local numa_node
> + *
> + * This function selects an online CPU according to a numa aware policy;
> + * local cpus are returned first, followed by the nearest non-local ones,
> + * then it wraps around.
> + *
> + * It's not very efficient, but useful for setup.
> + */
> +unsigned int cpumask_local_spread(unsigned int i, int node)
> +{
> +	static int node_dist[MAX_NUMNODES];
> +	static bool used[MAX_NUMNODES];
> +	unsigned long flags;
> +	int cpu, j, id;
> +
> +	/* Wrap: we always want a cpu. */
> +	i %= num_online_cpus();
> +
> +	if (node == NUMA_NO_NODE) {
> +		for_each_cpu(cpu, cpu_online_mask)
> +			if (i-- == 0)
> +				return cpu;
> +	} else {
> +		if (nr_node_ids > MAX_NUMNODES)
> +			return __cpumask_local_spread(i, node);
> +
> +		spin_lock_irqsave(&spread_lock, flags);
> +		memset(used, 0, nr_node_ids * sizeof(bool));
> +		calc_node_distance(node_dist, node);
> +		for (j = 0; j < nr_node_ids; j++) {
> +			id = find_nearest_node(node_dist, used);
> +			if (id < 0)
> +				break;
> +
> +			for_each_cpu_and(cpu, cpumask_of_node(id),
> +					 cpu_online_mask)
> +				if (i-- == 0) {
> +					spin_unlock_irqrestore(&spread_lock,
> +							       flags);
> +					return cpu;
> +				}
> +			used[id] = 1;
> +		}
> +		spin_unlock_irqrestore(&spread_lock, flags);
> +
> +		for_each_cpu(cpu, cpu_online_mask)
> +			if (i-- == 0)
> +				return cpu;
> +	}
> +	BUG();
> +}
>  EXPORT_SYMBOL(cpumask_local_spread);
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
