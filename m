Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3942C5EBE
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392238AbgK0C3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 21:29:33 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8597 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgK0C3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 21:29:33 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Chz8T5zB2zLw1f;
        Fri, 27 Nov 2020 10:28:57 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 27 Nov 2020
 10:29:16 +0800
Subject: Re: [PATCH v7] lib: optimize cpumask_local_spread()
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
References: <1605668072-44780-1-git-send-email-zhangshaokun@hisilicon.com>
 <6a6e6d37-a3dc-94ed-bc8c-62c50ea1dff5@intel.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <a3b8ab12-604b-1efe-f091-de782c3c8ed5@hisilicon.com>
Date:   Fri, 27 Nov 2020 10:29:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <6a6e6d37-a3dc-94ed-bc8c-62c50ea1dff5@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Apologies for later reply.

在 2020/11/21 1:48, Dave Hansen 写道:
> On 11/17/20 6:54 PM, Shaokun Zhang wrote:
>> From: Yuqi Jin <jinyuqi@huawei.com>
>>
>> In multi-processor and NUMA system, I/O driver will find cpu cores that
>> which shall be bound IRQ. When cpu cores in the local numa have been
>> used up, it is better to find the node closest to the local numa node
>> for performance, instead of choosing any online cpu immediately.
>>
>> On arm64 or x86 platform that has 2-sockets and 4-NUMA nodes, if the
>> network card is located in node2 of socket1, while the number queues
>> of network card is greater than the number of cores of node2, when all
>> cores of node2 has been bound to the queues, the remaining queues will
>> be bound to the cores of node0 which is further than NUMA node3.
> 
> That's quite the run-on sentence. :)
> 
>> It is
>> not friendly for performance or Intel's DDIO (Data Direct I/O Technology)
> 
> Could you explain *why* it is not friendly to DDIO specifically?  This
> patch affects where the interrupt handler runs.  But, DDIO is based on
> memory locations rather than the location of the interrupt handler.
> 
> It would be ideal to make that connection: How does the location of the
> interrupt handler impact the memory allocation location?
> 

When the interrupt handler is across chips, the BD, packet header, and even
payload are required for the RX packet interrupt handler. However, the DDIO
cannot transmit data to there.

>> when if the user enables SNC (sub-NUMA-clustering).
> 
> Again, the role that SNC plays here isn't spelled out.  I *believe* it's
> because SNC ends up reducing the number of CPUs in each NUMA node.  That
>  makes the existing code run out of CPUs to which to bind to the "local"
> node sooner.

Yes.

> 
>> +static int find_nearest_node(int node, bool *used)
>> +{
>> +	int i, min_dist, node_id = -1;
>> +
>> +	/* Choose the first unused node to compare */
>> +	for (i = 0; i < nr_node_ids; i++) {
>> +		if (used[i] == false) {
>> +			min_dist = node_distance(node, i);
>> +			node_id = i;
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* Compare and return the nearest node */
>> +	for (i = 0; i < nr_node_ids; i++) {
>> +		if (node_distance(node, i) < min_dist && used[i] == false) {
>> +			min_dist = node_distance(node, i);
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
>>   * @node: local numa_node
>>   *
>>   * This function selects an online CPU according to a numa aware policy;
>> - * local cpus are returned first, followed by non-local ones, then it
>> - * wraps around.
>> + * local cpus are returned first, followed by the next one which is the
>> + * nearest unused NUMA node based on NUMA distance, then it wraps around.
>>   *
>>   * It's not very efficient, but useful for setup.
>>   */
>>  unsigned int cpumask_local_spread(unsigned int i, int node)
> 
> FWIW, I think 'i' is criminally bad naming.  It should be called
> nr_cpus_to_skip or something similar.
> 

Ok, I really didn't consider this parameter naming before.

> I also detest the comments that are there today.
> 
> 	Loop through all the online CPUs on the system.  Start with the
> 	CPUs on 'node', then fall back to CPUs on NUMA nodes which are
> 	increasingly far away.
> 
> 	Skip the first 'nr_cpus_to_skip' CPUs which are found.
> 
> 	This function is not very efficient, especially for large
> 	'nr_cpus_to_skip' because it loops over the same CPUs on each
> 	call and does not remember its state from previous calls.
> 

Shame for my bad comment, I will follow it.

>>  {
>> -	int cpu, hk_flags;
>> +	static DEFINE_SPINLOCK(spread_lock);
>> +	static bool used[MAX_NUMNODES];
> 
> I thought I mentioned this last time.  How large is this array?  How
> large would it be if it were a nodemask_t?  Would this be less code if

Apologies that I forgot to do it.

> you just dynamically allocated and freed the node mask instead of having
> a spinlock and a memset?
> 

Ok, but I think the spinlock is also needed, do I miss something?

>> +	unsigned long flags;
>> +	int cpu, hk_flags, j, id;
>>  	const struct cpumask *mask;
>>  
>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>> @@ -352,20 +379,27 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>  				return cpu;
>>  		}
>>  	} else {
>> -		/* NUMA first. */
>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>> -			if (i-- == 0)
>> -				return cpu;
>> +		spin_lock_irqsave(&spread_lock, flags);
>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>> +		/* select node according to the distance from local node */
>> +		for (j = 0; j < nr_node_ids; j++) {
>> +			id = find_nearest_node(node, used);
>> +			if (id < 0)
>> +				break;
> 
> There's presumably an outer loop in a driver which is trying to bind a
> bunch of interrupts to a bunch of CPUs.  We know there are on the order
> of dozens of these interrupts.
> 
> 	for_each_interrupt() // in the driver
> 		for (j=0;j<nr_node_ids;j++) // cpumask_local_spread()
> 			// find_nearest_node():
> 			for (i = 0; i < nr_node_ids; i++) {
> 			for (i = 0; i < nr_node_ids; i++) {
> 
> Does this worry anybody else?  It thought our upper limits on the number
> of NUMA nodes was 1024.  Doesn't that make our loop O(N^3) where the
> worst case is hundreds of millions of loops?
> 

If the NUMA nodes is 1024 in real system, it is more worthy to find the
earest node, rather than choose a random one, And it is only called in
I/O device initialization. Comments also are given to this interface.

> I don't want to prematurely optimize this, but that seems like something
> that might just fall over on bigger systems.
> 
> This also seems really wasteful if we have a bunch of memory-only nodes.
>  Each of those will be found via find_nearest_node(), but then this loop:
> 

Got it, all effort is used to choose the nearest node for performance. If
we don't it, I think some one will also debug this in future.

>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>> +				if (i-- == 0) {
>> +					spin_unlock_irqrestore(&spread_lock,
>> +							       flags);
>> +					return cpu;
>> +				}
>> +			used[id] = true;
>>  		}
> 
> Will just exit immediately because cpumask_of_node() is empty.

Yes, and this node used[id] became true.

> 
> 'used', for instance, should start by setting 'true' for all nodes which
> are not in N_CPUS.

No, because I used 'nr_node_ids' which is possible node ids to check.

Thanks,
Shaokun

> 
>> +		spin_unlock_irqrestore(&spread_lock, flags);
>>  
>> -		for_each_cpu(cpu, mask) {
>> -			/* Skip NUMA nodes, done above. */
>> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
>> -				continue;
>> -
>> +		for_each_cpu(cpu, mask)
>>  			if (i-- == 0)
>>  				return cpu;
>> -		}
>>  	}
>>  	BUG();
>>  }
> .
> 
