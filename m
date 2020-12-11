Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86B2D6E21
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbgLKC0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:26:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9157 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732286AbgLKC0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 21:26:21 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsZPW1ZHRz15YbM;
        Fri, 11 Dec 2020 10:25:03 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Dec 2020
 10:25:27 +0800
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
 <a3b8ab12-604b-1efe-f091-de782c3c8ed5@hisilicon.com>
 <b3122c82-e0fc-5bb8-82ec-43ae785f381f@intel.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <2ff20d00-119b-836f-1112-186f45adf6b2@hisilicon.com>
Date:   Fri, 11 Dec 2020 10:25:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <b3122c82-e0fc-5bb8-82ec-43ae785f381f@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Apologies for the late reply.

在 2020/12/1 1:08, Dave Hansen 写道:
>>>>  {
>>>> -	int cpu, hk_flags;
>>>> +	static DEFINE_SPINLOCK(spread_lock);
>>>> +	static bool used[MAX_NUMNODES];
>>>
>>> I thought I mentioned this last time.  How large is this array?  How
>>> large would it be if it were a nodemask_t?  Would this be less code if
>>
>> Apologies that I forgot to do it.
>>
>>> you just dynamically allocated and freed the node mask instead of having
>>> a spinlock and a memset?
>>
>> Ok, but I think the spinlock is also needed, do I miss something?
> 
> There was no spinlock there before your patch.  You just need it to
> protect the structures you declared static.  If you didn't have static
> structures, you wouldn't need a lock.

Got it, I will allocate it dynamically.

> 
>>>> +	unsigned long flags;
>>>> +	int cpu, hk_flags, j, id;
>>>>  	const struct cpumask *mask;
>>>>  
>>>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>>>> @@ -352,20 +379,27 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>>>  				return cpu;
>>>>  		}
>>>>  	} else {
>>>> -		/* NUMA first. */
>>>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>>>> -			if (i-- == 0)
>>>> -				return cpu;
>>>> +		spin_lock_irqsave(&spread_lock, flags);
>>>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>>>> +		/* select node according to the distance from local node */
>>>> +		for (j = 0; j < nr_node_ids; j++) {
>>>> +			id = find_nearest_node(node, used);
>>>> +			if (id < 0)
>>>> +				break;
>>>
>>> There's presumably an outer loop in a driver which is trying to bind a
>>> bunch of interrupts to a bunch of CPUs.  We know there are on the order
>>> of dozens of these interrupts.
>>>
>>> 	for_each_interrupt() // in the driver
>>> 		for (j=0;j<nr_node_ids;j++) // cpumask_local_spread()
>>> 			// find_nearest_node():
>>> 			for (i = 0; i < nr_node_ids; i++) {
>>> 			for (i = 0; i < nr_node_ids; i++) {
>>>
>>> Does this worry anybody else?  It thought our upper limits on the number
>>> of NUMA nodes was 1024.  Doesn't that make our loop O(N^3) where the
>>> worst case is hundreds of millions of loops?
>>
>> If the NUMA nodes is 1024 in real system, it is more worthy to find the
>> earest node, rather than choose a random one, And it is only called in
>> I/O device initialization. Comments also are given to this interface.
> 
> This doesn't really make me feel better.  An end user booting this on a

My bad, I only want to explain the issue.

> big system with a bunch of cards could see a minutes-long delay.  I can

Indeed.

> also see funky stuff happening like if we have a ton of NUMA nodes and
> few CPUs.
> 
>>> I don't want to prematurely optimize this, but that seems like something
>>> that might just fall over on bigger systems.
>>>
>>> This also seems really wasteful if we have a bunch of memory-only nodes.
>>>  Each of those will be found via find_nearest_node(), but then this loop:
>>
>> Got it, all effort is used to choose the nearest node for performance. If
>> we don't it, I think some one will also debug this in future.
> 
> If we're going to kick the can down the road for some poor sod to debug,
> can we at least help them out with a warning?
> 
> Maybe we WARN_ONCE() after we fall back for more than 2 or 3 nodes.
> 

Ok,

> But, I still don't think you've addressed my main concern: This is
> horrifically inefficient searching for CPUs inside nodes that are known
> to have no CPUs.

How about optimizing as follows:
+		for (j = 0; j < nr_node_ids; j++) {
+			id = find_nearest_node(node, nodes);
+			if (id < 0)
+				break;
+			nmask = cpumask_of_node(id);
+			cpumask_and(&node_possible_mask, &mask, & nmask);
+			cpu_of_node = cpumask_weight(node_possible_mask);
+ 			if (cpu_index > cpu_of_node) {
+				cpu_index -= cpu_of_node;
+				node_set(id, nodes);
+				continue;
+			}
+
+			for_each_cpu(cpu, node_possible_mask)
+				if (cpu_index-- == 0)
+					return cpu;
+
+			node_set(id, nodes);
 		}

> 
>>>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>>>> +				if (i-- == 0) {
>>>> +					spin_unlock_irqrestore(&spread_lock,
>>>> +							       flags);
>>>> +					return cpu;
>>>> +				}
>>>> +			used[id] = true;
>>>>  		}
>>>
>>> Will just exit immediately because cpumask_of_node() is empty.
>>
>> Yes, and this node used[id] became true.
>>
>>>
>>> 'used', for instance, should start by setting 'true' for all nodes which
>>> are not in N_CPUS.
>>
>> No, because I used 'nr_node_ids' which is possible node ids to check.
> 
> I'm saying that it's wasteful to loop over and search in all the nodes.

If you are happy the mentioned code, it also will solve the issue.

Thanks,
Shaokun

> .
> 
