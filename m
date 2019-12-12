Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126D411C264
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfLLBlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:41:13 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33014 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727297AbfLLBlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 20:41:13 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1BFB97CF2D5011ECE2A0;
        Thu, 12 Dec 2019 09:41:11 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 09:41:04 +0800
Subject: Re: [PATCH v4] lib: optimize cpumask_local_spread()
To:     Michal Hocko <mhocko@kernel.org>
References: <1576051437-23230-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191211090823.GD14655@dhcp22.suse.cz>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        yuqi jin <jinyuqi@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Juergen Gross" <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <9c3b6b23-e352-43b8-ea4a-041baf62845b@hisilicon.com>
Date:   Thu, 12 Dec 2019 09:41:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191211090823.GD14655@dhcp22.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

+Cc: Rusty Russell who optimised this function in commit
f36963c9d3f6 ("cpumask_set_cpu_local_first => cpumask_local_spread, lament")

On 2019/12/11 17:08, Michal Hocko wrote:
> On Wed 11-12-19 16:03:57, Shaokun Zhang wrote:
>> From: yuqi jin <jinyuqi@huawei.com>
>>
>> In multi-processor and NUMA system, I/O driver will find cpu cores that
>> which shall be bound IRQ. When cpu cores in the local numa have been
>> used, it is better to find the node closest to the local numa node for
>> performance, instead of choosing any online cpu immediately.
>>
>> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
>> system(0 - 1). The topology of this server is followed:
>> available: 4 nodes (0-3)
>> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
>> node 0 size: 63379 MB
>> node 0 free: 61899 MB
>> node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
>> node 1 size: 64509 MB
>> node 1 free: 63942 MB
>> node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
>> node 2 size: 64509 MB
>> node 2 free: 63056 MB
>> node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
>> node 3 size: 63997 MB
>> node 3 free: 63420 MB
>> node distances:
>> node   0   1   2   3
>>   0:  10  16  32  33
>>   1:  16  10  25  32
>>   2:  32  25  10  16
>>   3:  33  32  16  10
>>
>> We perform PS (parameter server) business test, the behavior of the 
>> service is that the client initiates a request through the network card,
>> the server responds to the request after calculation. When two PS
>> processes run on node2 and node3 separately and the network card is
>> located on 'node2' which is in cpu1, the performance of node2 (26W QPS)
>> and node3 (22W QPS) is different.
>> It is better that the NIC queues are bound to the cpu1 cores in turn,
>> then XPS will also be properly initialized, while cpumask_local_spread
>> only considers the local node. When the number of NIC queues exceeds the
>> number of cores in the local node, it returns to the online core directly.
>> So when PS runs on node3 sending a calculated request, the performance is
>> not as good as the node2.
>> The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
>> patch, before the patch:
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
>> Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
>> 72
>> Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
>> 73
>> ...
>> Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
>> 94
>> Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
>> 95
>> So the performance of the node3 is the same as node2 that is 26W QPS when
>> the network card is still in 'node2' with the patch.
>>
>> It is considered that the NIC and other I/O devices shall initialize the
>> interrupt binding, if the cores of the local node are used up, it is
>> reasonable to return the node closest to it. Let's optimize it and find
>> the nearest node through NUMA distance for the non-local NUMA nodes.
> 
> As I've said/asked earlier. I am missing some background how this is
> affecting other existing users. Is this just that nobody has noticed the

I appreciate yours question, but I can't answer 'YES' or 'NO' to it. Since
I encountered this issue, I'm glad to discuss this in the community. If we
can solve it, it can give gain for people who maybe spend time to spot it
again.

> suboptimal cpu usage or is your workload very special in that regards.

What I have done is just that choosing cpu core from the nearest non-local
NUMA node, not the random online cpu core when the local cpu core is used
up. It's no matter what the workload is, Why I mention the PS in the patch?
Because this issue is triggered by it.

Thanks,
Shaokun

> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Paul Burton <paul.burton@mips.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Mike Rapoport <rppt@linux.ibm.com>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Signed-off-by: yuqi jin <jinyuqi@huawei.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>> ChangeLog from v3:
>>     1. Make spread_lock local to cpumask_local_spread();
>>     2. Add more descriptions on the affinities change in log;
>>
>> ChangeLog from v2:
>>     1. Change the variables as static and use spinlock to protect;
>>     2. Give more explantation on test and performance;
>>
>>  lib/cpumask.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 90 insertions(+), 12 deletions(-)
>>
>> diff --git a/lib/cpumask.c b/lib/cpumask.c
>> index 0cb672eb107c..f7394ba36116 100644
>> --- a/lib/cpumask.c
>> +++ b/lib/cpumask.c
>> @@ -6,6 +6,7 @@
>>  #include <linux/export.h>
>>  #include <linux/memblock.h>
>>  #include <linux/numa.h>
>> +#include <linux/spinlock.h>
>>  
>>  /**
>>   * cpumask_next - get the next cpu in a cpumask
>> @@ -192,18 +193,39 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
>>  }
>>  #endif
>>  
>> -/**
>> - * cpumask_local_spread - select the i'th cpu with local numa cpu's first
>> - * @i: index number
>> - * @node: local numa_node
>> - *
>> - * This function selects an online CPU according to a numa aware policy;
>> - * local cpus are returned first, followed by non-local ones, then it
>> - * wraps around.
>> - *
>> - * It's not very efficient, but useful for setup.
>> - */
>> -unsigned int cpumask_local_spread(unsigned int i, int node)
>> +static void calc_node_distance(int *node_dist, int node)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < nr_node_ids; i++)
>> +		node_dist[i] = node_distance(node, i);
>> +}
>> +
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
>> +static unsigned int __cpumask_local_spread(unsigned int i, int node)
>>  {
>>  	int cpu;
>>  
>> @@ -231,4 +253,60 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>  	}
>>  	BUG();
>>  }
>> +
>> +/**
>> + * cpumask_local_spread - select the i'th cpu with local numa cpu's first
>> + * @i: index number
>> + * @node: local numa_node
>> + *
>> + * This function selects an online CPU according to a numa aware policy;
>> + * local cpus are returned first, followed by the nearest non-local ones,
>> + * then it wraps around.
>> + *
>> + * It's not very efficient, but useful for setup.
>> + */
>> +unsigned int cpumask_local_spread(unsigned int i, int node)
>> +{
>> +	static DEFINE_SPINLOCK(spread_lock);
>> +	static int node_dist[MAX_NUMNODES];
>> +	static bool used[MAX_NUMNODES];
>> +	unsigned long flags;
>> +	int cpu, j, id;
>> +
>> +	/* Wrap: we always want a cpu. */
>> +	i %= num_online_cpus();
>> +
>> +	if (node == NUMA_NO_NODE) {
>> +		for_each_cpu(cpu, cpu_online_mask)
>> +			if (i-- == 0)
>> +				return cpu;
>> +	} else {
>> +		if (nr_node_ids > MAX_NUMNODES)
>> +			return __cpumask_local_spread(i, node);
>> +
>> +		spin_lock_irqsave(&spread_lock, flags);
>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>> +		calc_node_distance(node_dist, node);
>> +		for (j = 0; j < nr_node_ids; j++) {
>> +			id = find_nearest_node(node_dist, used);
>> +			if (id < 0)
>> +				break;
>> +
>> +			for_each_cpu_and(cpu, cpumask_of_node(id),
>> +					 cpu_online_mask)
>> +				if (i-- == 0) {
>> +					spin_unlock_irqrestore(&spread_lock,
>> +							       flags);
>> +					return cpu;
>> +				}
>> +			used[id] = 1;
>> +		}
>> +		spin_unlock_irqrestore(&spread_lock, flags);
>> +
>> +		for_each_cpu(cpu, cpu_online_mask)
>> +			if (i-- == 0)
>> +				return cpu;
>> +	}
>> +	BUG();
>> +}
>>  EXPORT_SYMBOL(cpumask_local_spread);
>> -- 
>> 2.7.4
> 

