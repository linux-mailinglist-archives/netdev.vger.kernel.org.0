Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5100CFD870
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKOJJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:09:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfKOJJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 04:09:23 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 090D03BEE30B7D809372;
        Fri, 15 Nov 2019 17:09:21 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 15 Nov 2019
 17:09:14 +0800
Subject: Re: [PATCH v3] lib: optimize cpumask_local_spread()
To:     Michal Hocko <mhocko@kernel.org>
References: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191108103102.GF15658@dhcp22.suse.cz>
 <c6f24942-c8d6-e46a-f433-152d29af8c71@hisilicon.com>
 <20191112115630.GD2763@dhcp22.suse.cz>
 <00856999-739f-fd73-eddd-d71e4e94962e@hisilicon.com>
 <20191114144317.GJ20866@dhcp22.suse.cz>
CC:     <linux-kernel@vger.kernel.org>, yuqi jin <jinyuqi@huawei.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Paul Burton" <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        <netdev@vger.kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <9af13fea-95a6-30cb-2c0e-770aa649a549@hisilicon.com>
Date:   Fri, 15 Nov 2019 17:09:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191114144317.GJ20866@dhcp22.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 2019/11/14 22:43, Michal Hocko wrote:
> On Wed 13-11-19 10:46:05, Shaokun Zhang wrote:
> [...]
>>>> available: 4 nodes (0-3)
>>>> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
>>>> node 0 size: 63379 MB
>>>> node 0 free: 61899 MB
>>>> node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
>>>> node 1 size: 64509 MB
>>>> node 1 free: 63942 MB
>>>> node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
>>>> node 2 size: 64509 MB
>>>> node 2 free: 63056 MB
>>>> node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
>>>> node 3 size: 63997 MB
>>>> node 3 free: 63420 MB
>>>> node distances:
>>>> node   0   1   2   3
>>>>   0:  10  16  32  33
>>>>   1:  16  10  25  32
>>>>   2:  32  25  10  16
>>>>   3:  33  32  16  10
> [...]
>> before patch
>> Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
>> 2
>> Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
>> 48
> 
> node 2
> 
>> Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
>> 0
> 
> node 0
> 
>> Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
>> 24
> 
> node 1
> 
>> Euler:/sys/bus/pci #
>>
>> after patch
>> Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
>> 2
>> Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
>> 48
> 
> node 2
> 
>> Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
>> 72
> 
> node 3
> 
>> Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
>> 24
> 
> node 1
> 
> So few more questions. The only difference seems to be IRQ369
> moving from 0 to 3 and having the device affinity to node 2
> makes some sense because node 3 is closer. So far so good.

Right, it is what we want.

> I still have a large gap to get the whole picture. Namely why those
> other IRQs are not using any of the existing CPUs on the node 2.
> Could you explain that please?
> 

Oh, my mistake, for the previous instance, I don't list all IRQs and
just choose one IRQ from one NUMA node. You can see that the IRQ
number is not consistent :-).
IRQ from 345 to 368 will be bound to CPU cores which are in NUMA node2
and each IRQ is corresponding to one core.

Euler:/sys/bus/pci # cat /proc/irq/346/smp_affinity_list
49

Others are the similar.

> Btw. this all should be in the changelog.

Ok, I will follow it in future.

Thanks,
Shaokun

> 

