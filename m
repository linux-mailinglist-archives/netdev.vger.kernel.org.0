Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64228358CEC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbhDHSty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:49:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232860AbhDHStx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617907781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9DnI6U1S+o39D28LsHu5djv7mtfJjdAM5tnhpqhEqeY=;
        b=Z2WDWm8fwlbC8EZq8seRT/87cZz/m7qnIC+ypdhMFD1O29FfU6PUOxv4d42TWdNcH6CX/m
        vAfOmYEsa6Aco+lVII5D8nhT+9gxuIZ4YZiezCJNVJLOlWEOs4JFU95/S9O1TbDojgZHRB
        TlguB3EwP9oezqQfD8U45jxXF049Eas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-JEAljJzqPj6fDRFe46hlyA-1; Thu, 08 Apr 2021 14:49:39 -0400
X-MC-Unique: JEAljJzqPj6fDRFe46hlyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27101800D53;
        Thu,  8 Apr 2021 18:49:37 +0000 (UTC)
Received: from [10.10.116.109] (ovpn-116-109.rdu2.redhat.com [10.10.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B8B860636;
        Thu,  8 Apr 2021 18:49:23 +0000 (UTC)
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to houskeeping
 CPUs
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>
Cc:     Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rostedt@goodmis.org, mingo@kernel.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        jinyuqi@huawei.com, zhangshaokun@hisilicon.com,
        Network Development <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Yang, Lihong" <lihong.yang@intel.com>
References: <20200625223443.2684-1-nitesh@redhat.com>
 <20200625223443.2684-2-nitesh@redhat.com>
 <3e9ce666-c9cd-391b-52b6-3471fe2be2e6@arm.com>
 <20210127121939.GA54725@fuller.cnet> <87r1m5can2.fsf@nanos.tec.linutronix.de>
 <20210128165903.GB38339@fuller.cnet> <87h7n0de5a.fsf@nanos.tec.linutronix.de>
 <20210204181546.GA30113@fuller.cnet>
 <cfa138e9-38e3-e566-8903-1d64024c917b@redhat.com>
 <20210204190647.GA32868@fuller.cnet>
 <d8884413-84b4-b204-85c5-810342807d21@redhat.com>
 <87y2g26tnt.fsf@nanos.tec.linutronix.de>
 <d0aed683-87ae-91a2-d093-de3f5d8a8251@redhat.com>
 <7780ae60-efbd-2902-caaa-0249a1f277d9@redhat.com>
 <07c04bc7-27f0-9c07-9f9e-2d1a450714ef@redhat.com>
 <20210406102207.0000485c@intel.com>
 <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com>
Organization: Red Hat Inc,
Message-ID: <b21853ab-e3b4-889a-07bd-742db8aa2e4b@redhat.com>
Date:   Thu, 8 Apr 2021 14:49:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/21 11:18 AM, Nitesh Narayan Lal wrote:
> On 4/6/21 1:22 PM, Jesse Brandeburg wrote:
>> Continuing a thread from a bit ago...
>>
>> Nitesh Narayan Lal wrote:
>>
>>>> After a little more digging, I found out why cpumask_local_spread change
>>>> affects the general/initial smp_affinity for certain device IRQs.
>>>>
>>>> After the introduction of the commit:
>>>>
>>>>     e2e64a932 genirq: Set initial affinity in irq_set_affinity_hint()
>>>>
>>> Continuing the conversation about the above commit and adding Jesse.
>>> I was trying to understand the problem that the commit message explains
>>> "The default behavior of the kernel is somewhat undesirable as all
>>> requested interrupts end up on CPU0 after registration.", I have also been
>>> trying to reproduce this behavior without the patch but I failed in doing
>>> so, maybe because I am missing something here.
>>>
>>> @Jesse Can you please explain? FWIU IRQ affinity should be decided based on
>>> the default affinity mask.
> Thanks, Jesse for responding.
>
>> The original issue as seen, was that if you rmmod/insmod a driver
>> *without* irqbalance running, the default irq mask is -1, which means
>> any CPU. The older kernels (this issue was patched in 2014) used to use
>> that affinity mask, but the value programmed into all the interrupt
>> registers "actual affinity" would end up delivering all interrupts to
>> CPU0,
> So does that mean the affinity mask for the IRQs was different wrt where
> the IRQs were actually delivered?
> Or, the affinity mask itself for the IRQs after rmmod, insmod was changed
> to 0 instead of -1?
>
> I did a quick test on top of 5.12.0-rc6 by comparing the i40e IRQ affinity
> mask before removing the kernel module and after doing rmmod+insmod
> and didn't find any difference.
>
>>  and if the machine was under traffic load incoming when the
>> driver loaded, CPU0 would start to poll among all the different netdev
>> queues, all on CPU0.
>>
>> The above then leads to the condition that the device is stuck polling
>> even if the affinity gets updated from user space, and the polling will
>> continue until traffic stops.
>>
>>> The problem with the commit is that when we overwrite the affinity mask
>>> based on the hinting mask we completely ignore the default SMP affinity
>>> mask. If we do want to overwrite the affinity based on the hint mask we
>>> should atleast consider the default SMP affinity.
> For the issue where the IRQs don't follow the default_smp_affinity mask
> because of this patch, the following are the steps by which it can be easily
> reproduced with the latest linux kernel:
>
> # Kernel
> 5.12.0-rc6+
>
> # Other pramaeters in the cmdline
> isolcpus=2-39,44-79 nohz=on nohz_full=2-39,44-79
> rcu_nocbs=2-39,44-79
>
> # cat /proc/irq/default_smp_affinity
> 0000,00000f00,00000003 [Corresponds to HK CPUs - 0, 1, 40, 41, 42 and 43]
>
> # Create VFs and check IRQ affinity mask
>
> /proc/irq/1423/iavf-ens1f1v3-TxRx-3
> 3
> /proc/irq/1424/iavf-0000:3b:0b.0:mbx
> 0
> 40
> 42
> /proc/irq/1425/iavf-ens1f1v8-TxRx-0
> 0
> /proc/irq/1426/iavf-ens1f1v8-TxRx-1
> 1
> /proc/irq/1427/iavf-ens1f1v8-TxRx-2
> 2
> /proc/irq/1428/iavf-ens1f1v8-TxRx-3
> 3
> ...
> /proc/irq/1475/iavf-ens1f1v15-TxRx-0
> 0
> /proc/irq/1476/iavf-ens1f1v15-TxRx-1
> 1
> /proc/irq/1477/iavf-ens1f1v15-TxRx-2
> 2
> /proc/irq/1478/iavf-ens1f1v15-TxRx-3
> 3
> /proc/irq/1479/iavf-0000:3b:0a.0:mbx
> 0
> 40
> 42
> ...
> /proc/irq/240/iavf-ens1f1v3-TxRx-0
> 0
> /proc/irq/248/iavf-ens1f1v3-TxRx-1
> 1
> /proc/irq/249/iavf-ens1f1v3-TxRx-2
> 2
>
>
> Trace dump:
> ----------
> ..
> 11551082:  NetworkManager-1734  [040]  8167.465719: vector_activate:    
>             irq=1478 is_managed=0 can_reserve=1 reserve=0
> 11551090:  NetworkManager-1734  [040]  8167.465720: vector_alloc:
>             irq=1478 vector=65 reserved=1 ret=0
> 11551093:  NetworkManager-1734  [040]  8167.465721: vector_update:      
>             irq=1478 vector=65 cpu=42 prev_vector=0 prev_cpu=0
> 11551097:  NetworkManager-1734  [040]  8167.465721: vector_config:      
>             irq=1478 vector=65 cpu=42 apicdest=0x00000200
> 11551357:  NetworkManager-1734  [040]  8167.465768: vector_alloc:        
>             irq=1478 vector=46 reserved=0 ret=0
>
> 11551360:  NetworkManager-1734  [040]  8167.465769: vector_update:      
>             irq=1478 vector=46 cpu=3 prev_vector=65 prev_cpu=42
>
> 11551364:  NetworkManager-1734  [040]  8167.465770: vector_config:      
>             irq=1478 vector=46 cpu=3 apicdest=0x00040100
> ..
>
> As we can see in the above trace the initial affinity for the IRQ 1478 was
> correctly set as per the default_smp_affinity mask which includes CPU 42,
> however, later on, it is updated with CPU3 which is returned from
> cpumask_local_spread().
>
>> Maybe the right thing is to fix which CPUs are passed in as the valid
>> mask, or make sure the kernel cross checks that what the driver asks
>> for is a "valid CPU"?
>>
> Sure, if we can still reproduce the problem that your patch was fixing then
> maybe we can consider adding a new API like cpumask_local_spread_irq in
> which we should consider deafult_smp_affinity mask as well before returning
> the CPU.
>

Didn't realize that netdev ml was not included, so adding that.

-- 
Nitesh

