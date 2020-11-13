Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063C32B1425
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMCGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:06:36 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7185 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgKMCGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:06:36 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CXMJt6qHYz15Ty2;
        Fri, 13 Nov 2020 10:06:22 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Nov 2020
 10:06:24 +0800
Subject: Re: [PATCH v6] lib: optimize cpumask_local_spread()
To:     Dave Hansen <dave.hansen@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Yuqi Jin <jinyuqi@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        Michal Hocko <mhocko@suse.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Anshuman Khandual" <anshuman.khandual@arm.com>
References: <1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com>
 <3e2e760d-e4b9-8bd0-a279-b23bd7841ae7@intel.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <eec4c1b6-8dad-9d07-7ef4-f0fbdcff1785@hisilicon.com>
Date:   Fri, 13 Nov 2020 10:06:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <3e2e760d-e4b9-8bd0-a279-b23bd7841ae7@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

在 2020/11/5 0:10, Dave Hansen 写道:
> On 11/3/20 5:39 AM, Shaokun Zhang wrote:
>> Currently, Intel DDIO affects only local sockets, so its performance
>> improvement is due to the relative difference in performance between the
>> local socket I/O and remote socket I/O.To ensure that Intel DDIO’s
>> benefits are available to applications where they are most useful, the
>> irq can be pinned to particular sockets using Intel DDIO.
>> This arrangement is called socket affinityi. So this patch can help
>> Intel DDIO work. The same I/O stash function for most processors
> 
> A great changelog would probably include a bit of context about DDIO.
> Even being from Intel, I'd heard about this, but I didn't immediately
> know what the acronym was.
> 
> The thing that matters here is that DDIO allows devices to use processor
> caches instead of having them always do uncached accesses to main
> memory.  That's a pretty important detail left out of the changelog.
> 
>> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
>> system(0 - 1). The topology of this server is followed:
> 
> This is with a feature enabled that Intel calls sub-NUMA-clustering
> (SNC), right?  Explaining *that* feature would also be great context for

Correct,

> why this gets triggered on your system and not normally on others and
> why nobody noticed this until now.

This is on intel 6248 platform:
[root@localhost ~]# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 5 6 10 11 12 15 16 40 41 42 45 46 50 51 52 55 56
node 0 size: 46893 MB
node 0 free: 45982 MB
node 1 cpus: 3 4 7 8 9 13 14 17 18 19 43 44 47 48 49 53 54 57 58 59
node 1 size: 48379 MB
node 1 free: 48235 MB
node 2 cpus: 20 21 22 25 26 30 31 32 35 36 60 61 62 65 66 70 71 72 75 76
node 2 size: 48353 MB
node 2 free: 48022 MB
node 3 cpus: 23 24 27 28 29 33 34 37 38 39 63 64 67 68 69 73 74 77 78 79
node 3 size: 48378 MB
node 3 free: 48196 MB
node distances:
node   0   1   2   3
  0:  10  11  21  21
  1:  11  10  21  21
  2:  21  21  10  11
  3:  21  21  11  10
[root@localhost ~]#
When the intel client turns on SNC, the mlx5 network card is used and is located
in node2, while the number queues of network card is greater than the number of
cores of node2. When all cores in the node2 has been binded, the core of node0
will be choosed, resulting in cross-chip and DDIO failure. If applying this patch,
node3 will be choosed to avoid this cross-chip operation.

> 
>> The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
>> patch, before the patch:
>>
>> Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
>> 0
>> Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
>> 1
>> ...
>> Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
>> 22
>> Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
>> 23
>> After the patch:
> 
> I _think_ what you are trying to convey here is that IRQs 369 and 370
> are from devices plugged in to one socket, but their IRQs are bound to
> CPUs 0 and 1 which are in the other socket.  Once device traffic leaves
> the socket, it can no longer use DDIO and performance suffers.
> 
> The same situation is true for IRQs 391/392 and CPUs 22/23.
> 
> You don't come out and say it, but I assume that the root of this issue
> is that once we fill up a NUMA node worth of CPUs with an affinitized
> IRQ per CPU, we go looking for CPUs in other NUMA nodes.  In this case,
> we have the processor in this weird mode that chops sockets into two
> NUMA nodes, which makes the device's NUMA node fill up faster.
> 
> The current behavior just "wraps around" to find a new node.  But, this
> wrap around behavior is nasty in this case because it might cross a socket.
> 

We want to improve the siutation that the card is inserted in second socket,
but it is binded with the first socket CPU cores, so we want to calcualte
this distance between different NUMA node and choose the nearesd node, it is
not a simple wraps arouad.

>> +static void calc_node_distance(int *node_dist, int node)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < nr_node_ids; i++)
>> +		node_dist[i] = node_distance(node, i);
>> +}
> 
> This appears to be the only place node_dist[] is written.  That means it
> always contains a one-dimensional slice of the two-dimensional data
> represented by node_distance().
> 
> Why is a copy of this data needed?

It is used to store the distance with the @node for later, apologies that I
can't follow your question correctly.

> 
>> +static int find_nearest_node(int *node_dist, bool *used)
>> +{
>> +	int i, min_dist = node_dist[0], node_id = -1;
>> +
>> +	/* Choose the first unused node to compare */
>> +	for (i = 0; i < nr_node_ids; i++) {
>> +		if (used[i] == 0) {
>> +			min_dist = node_dist[i];
>> +			node_id = i;
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* Compare and return the nearest node */
>> +	for (i = 0; i < nr_node_ids; i++) {
>> +		if (node_dist[i] < min_dist && used[i] == 0) {
>> +			min_dist = node_dist[i];
>> +			node_id = i;
>> +		}
>> +	}
>> +
>> +	return node_id;
>> +}
>> +
>>  /**
>>   * cpumask_local_spread - select the i'th cpu with local numa cpu's first
>>   * @i: index number
>> @@ -206,7 +238,11 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
>>   */
> 
> The diff missed some important context:
> 
>>  * This function selects an online CPU according to a numa aware policy;
>>  * local cpus are returned first, followed by non-local ones, then it
>>  * wraps around.
> 
> This patch changes that behavior but doesn't update the comment.
> 

Good catch, I will update this.

> 
>>  unsigned int cpumask_local_spread(unsigned int i, int node)
>>  {
>> -	int cpu, hk_flags;
>> +	static DEFINE_SPINLOCK(spread_lock);
>> +	static int node_dist[MAX_NUMNODES];
>> +	static bool used[MAX_NUMNODES];
> 
> Not to be *too* picky, but there is a reason we declare nodemask_t as a
> bitmap and not an array of bools.  Isn't this just wasteful?
> 
>> +	unsigned long flags;
>> +	int cpu, hk_flags, j, id;
>>  	const struct cpumask *mask;
>>  
>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>> @@ -220,20 +256,28 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>  				return cpu;
>>  		}
>>  	} else {
>> -		/* NUMA first. */
>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>> -			if (i-- == 0)
>> -				return cpu;
>> -		}
>> +		spin_lock_irqsave(&spread_lock, flags);
>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>> +		calc_node_distance(node_dist, node);
>> +		/* Local node first then the nearest node is used */
> 
> Is this comment really correct?  This makes it sound like there is only

I think it is correct, that's what we want to choose the nearest node.

> fallback to a single node.  Doesn't the _code_ fall back basically
> without limit?

If I follow your question correctly, without this patch, if the local
node is used up, one random node will be choosed, right? Now we firstly
choose the nearest node by the distance, if all nodes has been choosen,
it will return the initial solution.

> 
>> +		for (j = 0; j < nr_node_ids; j++) {
>> +			id = find_nearest_node(node_dist, used);
>> +			if (id < 0)
>> +				break;
>>  
>> -		for_each_cpu(cpu, mask) {
>> -			/* Skip NUMA nodes, done above. */
>> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
>> -				continue;
>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>> +				if (i-- == 0) {
>> +					spin_unlock_irqrestore(&spread_lock,
>> +							       flags);
>> +					return cpu;
>> +				}
>> +			used[id] = 1;
>> +		}
>> +		spin_unlock_irqrestore(&spread_lock, flags);
> 
> The existing code was pretty sparsely commented.  This looks to me to
> make it more complicated and *less* commented.  Not the best combo.

Apologies for the bad comments, hopefully I describe it clearly by the above
explantion.

Thanks,
Shaokun

> 
>> +		for_each_cpu(cpu, mask)
>>  			if (i-- == 0)
>>  				return cpu;
>> -		}
>>  	}
>>  	BUG();
>>  }
>>
> 
> .
> 
