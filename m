Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25421104D9C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUIOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:14:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbfKUIOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 03:14:17 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 703AAC08955488A0329B;
        Thu, 21 Nov 2019 16:14:15 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 21 Nov 2019
 16:14:05 +0800
Subject: Re: [PATCH v3] lib: optimize cpumask_local_spread()
To:     Michal Hocko <mhocko@kernel.org>
References: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191108103102.GF15658@dhcp22.suse.cz>
 <c6f24942-c8d6-e46a-f433-152d29af8c71@hisilicon.com>
 <20191112115630.GD2763@dhcp22.suse.cz>
 <00856999-739f-fd73-eddd-d71e4e94962e@hisilicon.com>
 <20191114144317.GJ20866@dhcp22.suse.cz>
 <9af13fea-95a6-30cb-2c0e-770aa649a549@hisilicon.com>
 <20191115133625.GD29990@dhcp22.suse.cz>
CC:     <linux-kernel@vger.kernel.org>, yuqi jin <jinyuqi@huawei.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Paul Burton" <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        <netdev@vger.kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <5011c668-65f4-c571-e166-dbc29a8adc27@hisilicon.com>
Date:   Thu, 21 Nov 2019 16:14:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191115133625.GD29990@dhcp22.suse.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 2019/11/15 21:36, Michal Hocko wrote:
> On Fri 15-11-19 17:09:13, Shaokun Zhang wrote:
> [...]
>> Oh, my mistake, for the previous instance, I don't list all IRQs and
>> just choose one IRQ from one NUMA node. You can see that the IRQ
>> number is not consistent :-).
>> IRQ from 345 to 368 will be bound to CPU cores which are in NUMA node2
>> and each IRQ is corresponding to one core.
>>
> 
> This is quite confusing then. I would suggest providing all IRQ used for

node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
node 0 size: 63379 MB
node 0 free: 61899 MB
node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 64509 MB
node 1 free: 63942 MB
node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 2 size: 64509 MB
node 2 free: 63056 MB
node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
node 3 size: 63997 MB
node 3 free: 63420 MB
node distances:
node   0   1   2   3
  0:  10  16  32  33
  1:  16  10  25  32
  2:  32  25  10  16
  3:  33  32  16  10

Before the patch:
/* I/O device is located on NUMA node2 */
Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
2
Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
48
Euler:/sys/bus/pci # cat /proc/irq/346/smp_affinity_list
49
.
.
.
Euler:/sys/bus/pci # cat /proc/irq/367/smp_affinity_list
70
Euler:/sys/bus/pci # cat /proc/irq/368/smp_affinity_list
71

/* there we expect irq form 24 to 47 binding to node3 */
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
0
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
1
.
.
.
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
22
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
23

Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
24
Euler:/sys/bus/pci # cat /proc/irq/394/smp_affinity_list
25
.
.
.
/* There are total 64 irqs on eth IO device. */
Euler:/sys/bus/pci # cat /proc/irq/407/smp_affinity_list
38
Euler:/sys/bus/pci # cat /proc/irq/408/smp_affinity_list
39                              	
Euler:/sys/bus/pci #

After the patch:
Euler:/sys/bus/pci/devices/0000:7d:00.2 # cat numa_node
2

Euler:/sys/bus/pci # cat /proc/irq/345/smp_affinity_list
48
Euler:/sys/bus/pci # cat /proc/irq/346/smp_affinity_list
49
.
.
.
Euler:/sys/bus/pci # cat /proc/irq/367/smp_affinity_list
70
Euler:/sys/bus/pci # cat /proc/irq/368/smp_affinity_list
71

Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
72
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
73
.
.
.
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
94
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
95
/* when the cores of socket were used up, we choose the node which is closer to node 2
before this patch choose the same node here is a coincident event*/
Euler:/sys/bus/pci # cat /proc/irq/393/smp_affinity_list
24
Euler:/sys/bus/pci # cat /proc/irq/394/smp_affinity_list
25
.
.
.
/* There are total 64 irqs on eth IO device. */
Euler:/sys/bus/pci # cat /proc/irq/407/smp_affinity_list
38
Euler:/sys/bus/pci # cat /proc/irq/408/smp_affinity_list
39
Euler:/sys/bus/pci #

Thanks,
Shaokun

> the device with the specific node affinity to see the difference in the
> setup.
> 

