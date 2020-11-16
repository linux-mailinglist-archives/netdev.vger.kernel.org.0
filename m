Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E082B3E35
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgKPH7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:59:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7543 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgKPH7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 02:59:50 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZM112qyDzhbNW;
        Mon, 16 Nov 2020 15:59:33 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Nov 2020
 15:59:37 +0800
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
 <eec4c1b6-8dad-9d07-7ef4-f0fbdcff1785@hisilicon.com>
 <5e8b0304-4de1-4bdc-41d2-79fa5464fbc7@intel.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <1ca0d77f-7cf3-57d8-af23-169975b63b32@hisilicon.com>
Date:   Mon, 16 Nov 2020 15:59:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <5e8b0304-4de1-4bdc-41d2-79fa5464fbc7@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

在 2020/11/14 0:02, Dave Hansen 写道:
> On 11/12/20 6:06 PM, Shaokun Zhang wrote:
>>>> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
>>>> system(0 - 1). The topology of this server is followed:
>>>
>>> This is with a feature enabled that Intel calls sub-NUMA-clustering
>>> (SNC), right?  Explaining *that* feature would also be great context for
>>
>> Correct,
>>
>>> why this gets triggered on your system and not normally on others and
>>> why nobody noticed this until now.
>>
>> This is on intel 6248 platform:
> 
> I have no idea what a "6248 platform" is.
> 

My apologies that it's Cascade Lake, [1]

>>>> +static void calc_node_distance(int *node_dist, int node)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < nr_node_ids; i++)
>>>> +		node_dist[i] = node_distance(node, i);
>>>> +}
>>>
>>> This appears to be the only place node_dist[] is written.  That means it
>>> always contains a one-dimensional slice of the two-dimensional data
>>> represented by node_distance().
>>>
>>> Why is a copy of this data needed?
>>
>> It is used to store the distance with the @node for later, apologies that I
>> can't follow your question correctly.
> 
> Right, the data that you store is useful.  *But*, it's also a verbatim
> copy of the data from node_distance().  Why not just use node_distance()
> directly in your code rather than creating a partial copy of it in the

Ok, I will remove this redundant function in next version.

> local node_dist[] array?
> 
> 
>>>>  unsigned int cpumask_local_spread(unsigned int i, int node)
>>>>  {
>>>> -	int cpu, hk_flags;
>>>> +	static DEFINE_SPINLOCK(spread_lock);
>>>> +	static int node_dist[MAX_NUMNODES];
>>>> +	static bool used[MAX_NUMNODES];
>>>
>>> Not to be *too* picky, but there is a reason we declare nodemask_t as a
>>> bitmap and not an array of bools.  Isn't this just wasteful?
>>>
>>>> +	unsigned long flags;
>>>> +	int cpu, hk_flags, j, id;
>>>>  	const struct cpumask *mask;
>>>>  
>>>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>>>> @@ -220,20 +256,28 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>>>  				return cpu;
>>>>  		}
>>>>  	} else {
>>>> -		/* NUMA first. */
>>>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>>>> -			if (i-- == 0)
>>>> -				return cpu;
>>>> -		}
>>>> +		spin_lock_irqsave(&spread_lock, flags);
>>>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>>>> +		calc_node_distance(node_dist, node);
>>>> +		/* Local node first then the nearest node is used */
>>>
>>> Is this comment really correct?  This makes it sound like there is only
>>
>> I think it is correct, that's what we want to choose the nearest node.
>>
>>> fallback to a single node.  Doesn't the _code_ fall back basically
>>> without limit?
>>
>> If I follow your question correctly, without this patch, if the local
>> node is used up, one random node will be choosed, right? Now we firstly
>> choose the nearest node by the distance, if all nodes has been choosen,
>> it will return the initial solution.
> 
> The comment makes it sound like the code does:
> 	1. Do the local node
> 	2. Do the next nearest node
> 	3. Stop
> 

That's more clear, I will udpate the comments as the new patch.

> In reality, I *think* it's more of a loop where it search
> ever-increasing distances away from the local node.
> 
> I just think the comment needs to be made more precise.

Got it.

> 
>>>> +		for (j = 0; j < nr_node_ids; j++) {
>>>> +			id = find_nearest_node(node_dist, used);
>>>> +			if (id < 0)
>>>> +				break;
>>>>  
>>>> -		for_each_cpu(cpu, mask) {
>>>> -			/* Skip NUMA nodes, done above. */
>>>> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
>>>> -				continue;
>>>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>>>> +				if (i-- == 0) {
>>>> +					spin_unlock_irqrestore(&spread_lock,
>>>> +							       flags);
>>>> +					return cpu;
>>>> +				}
>>>> +			used[id] = 1;
>>>> +		}
>>>> +		spin_unlock_irqrestore(&spread_lock, flags);
>>>
>>> The existing code was pretty sparsely commented.  This looks to me to
>>> make it more complicated and *less* commented.  Not the best combo.
>>
>> Apologies for the bad comments, hopefully I describe it clearly by the above
>> explantion.
> 
> Do you want to take another pass at submitting this patch?

'Another pass'? Sorry for my bad understading, I don't follow it correctly.

Thanks,
Shaokun

[1]https://en.wikichip.org/wiki/intel/xeon_gold/6248

> .
> 
