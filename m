Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12745FA6D0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfKMCqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:46:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727226AbfKMCqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 21:46:20 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6950BC9426FED6CEC6A2;
        Wed, 13 Nov 2019 10:46:13 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 10:46:05 +0800
Subject: Re: [PATCH v3] lib: optimize cpumask_local_spread()
To:     Michal Hocko <mhocko@kernel.org>
References: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191108103102.GF15658@dhcp22.suse.cz>
 <c6f24942-c8d6-e46a-f433-152d29af8c71@hisilicon.com>
 <20191112115630.GD2763@dhcp22.suse.cz>
CC:     <linux-kernel@vger.kernel.org>, yuqi jin <jinyuqi@huawei.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Paul Burton" <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        <netdev@vger.kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <00856999-739f-fd73-eddd-d71e4e94962e@hisilicon.com>
Date:   Wed, 13 Nov 2019 10:46:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191112115630.GD2763@dhcp22.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 2019/11/12 19:56, Michal Hocko wrote:
> On Mon 11-11-19 10:02:37, Shaokun Zhang wrote:
>> Hi Michal,
>>
>> On 2019/11/8 18:31, Michal Hocko wrote:
>>> This changelog looks better, thanks! I still have some questions though.
>>> Btw. cpumask_local_spread is used by the networking code but I do not
>>> see net guys involved (Cc netdev)
>>
>> Oh, I forgot to involve the net guys, sorry.
>>
>>>
>>> On Thu 07-11-19 09:44:08, Shaokun Zhang wrote:
>>>> From: yuqi jin <jinyuqi@huawei.com>
>>>>
>>>> In the multi-processors and NUMA system, I/O driver will find cpu cores
>>>> that which shall be bound IRQ. When cpu cores in the local numa have
>>>> been used, it is better to find the node closest to the local numa node,
>>>> instead of choosing any online cpu immediately.
>>>>
>>>> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 -3) in the 2-cpu
>>>> system(0 - 1).
>>>
>>> Please send a topology of this server (numactl -H).
>>>
>>
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
>>>> We perform PS (parameter server) business test, the
>>>> behavior of the service is that the client initiates a request through
>>>> the network card, the server responds to the request after calculation. 
>>>
>>> Is the benchmark any ublicly available?
>>>
>>
>> Sorry, the PS which we test is not open, but I think redis is the same as PS
>> on the macro level. When there are both 24 redis servers on node2 and node3.
>> if the 24-47 irqs and xps of NIC are not bound to node3, the redis servers
>> on node3 will not performance good.
> 
> Are there any other benchmarks showing improvements?
>

Sorry, I don't have it. The issue is clear and the patch is helpful for the
actual Parameter Server and Redis test.

>>>> When two PS processes run on node2 and node3 separately and the
>>>> network card is located on 'node2' which is in cpu1, the performance
>>>> of node2 (26W QPS) and node3 (22W QPS) was different.
>>>> It is better that the NIC queues are bound to the cpu1 cores in turn,
>>>> then XPS will also be properly initialized, while cpumask_local_spread
>>>> only considers the local node. When the number of NIC queues exceeds
>>>> the number of cores in the local node, it returns to the online core
>>>> directly. So when PS runs on node3 sending a calculated request,
>>>> the performance is not as good as the node2. It is considered that
>>>> the NIC and other I/O devices shall initialize the interrupt binding,
>>>> if the cores of the local node are used up, it is reasonable to return
>>>> the node closest to it.
>>>
>>> Can you post cpu affinities before and after this patch?
>>>
>>
>> Before this patch
>> Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
>> 2
>> Euler:~ # cat /proc/irq/345/smp_affinity    #IRQ0
>> 00000000,00010000,00000000
> 
> This representation is awkward to parse. Could you add smp_affinity_list
> please? It would save quite some head scratching.
> 

before patch
Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
2
Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
48
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
0
Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
24
Euler:/sys/bus/pci #

after patch
Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
2
Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
48
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
72
Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
24
Euler:/sys/bus/pci #

Thanks,
Shaokun


