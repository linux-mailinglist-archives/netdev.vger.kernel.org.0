Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8893614A2
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhDOWME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:12:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234961AbhDOWMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618524698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XzNn74iOjMf0orBEew0wdrHRxZf1IxR+s28/MMfBybI=;
        b=cYVmrpWzip2a2BRfwNbxTOzxjP73gA5u8p21w3l+3oDmbPo74+sY5JsFS4JYk/0hAaMcXo
        H9PYKpnPJRnuvuF9dTQDCj1+ajYZgbn5rtC6WC915VFtOzJMIuz8ar0cpq2JR2YrQqBiAD
        YWHrOUUBq005LeiEZkIThM0Wyffnn88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-MnH5KCAWPgKmKbNvVij1tg-1; Thu, 15 Apr 2021 18:11:35 -0400
X-MC-Unique: MnH5KCAWPgKmKbNvVij1tg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDCE1A40C1;
        Thu, 15 Apr 2021 22:11:30 +0000 (UTC)
Received: from [10.10.117.73] (ovpn-117-73.rdu2.redhat.com [10.10.117.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47FCC5C290;
        Thu, 15 Apr 2021 22:11:21 +0000 (UTC)
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to houskeeping
 CPUs
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "abelits@marvell.com" <abelits@marvell.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com
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
 <20210414091100.000033cf@intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Organization: Red Hat Inc,
Message-ID: <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com>
Date:   Thu, 15 Apr 2021 18:11:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210414091100.000033cf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/14/21 12:11 PM, Jesse Brandeburg wrote:
> Nitesh Narayan Lal wrote:
>
>>> The original issue as seen, was that if you rmmod/insmod a driver
>>> *without* irqbalance running, the default irq mask is -1, which means
>>> any CPU. The older kernels (this issue was patched in 2014) used to use
>>> that affinity mask, but the value programmed into all the interrupt
>>> registers "actual affinity" would end up delivering all interrupts to
>>> CPU0,
>> So does that mean the affinity mask for the IRQs was different wrt where
>> the IRQs were actually delivered?
>> Or, the affinity mask itself for the IRQs after rmmod, insmod was changed
>> to 0 instead of -1?
> The smp_affinity was 0xfff, and the kernel chooses which interrupt to
> place the interrupt on, among any of the bits set.


I think what you are referring to here is the effective affinity mask.
From one of Thomas's commit message that you pointed me to:

"The affinity mask is either the system-wide default or set by userspace,
but the architecture can or even must reduce the mask to the effective set,
which means that checking the affinity mask itself does not really tell
about the actual target CPUs."

I was looking into the code changes around IRQ and there has been major
rework from Thomas in 2017. I recently tried testing the kernel just before
those patches got merged.

Specifically on top of
05161b9cbe5:     x86/irq: Get rid of the 'first_system_vector' indirection
                 bogosity

On the box where I tested this, I was able to see the effective affinity
being set to 0 (not SMP affinity) for several network device IRQs.

and I think the reason for it is the usage of "cpumask_first_and(mask,
cpu_online_mask)" in __assign_irq_vector().

But with the latest kernel, this has been replaced and that's why I didn't
see the effective affinity being set to only 0 for all of the device IRQs.

Having said that I am still not sure if I was able to mimic what you have
seen in the past. But it looked similar to what you were explaining.
What do you think?



>
>  
>> I did a quick test on top of 5.12.0-rc6 by comparing the i40e IRQ affinity
>> mask before removing the kernel module and after doing rmmod+insmod
>> and didn't find any difference.
> with the patch in question removed? Sorry, I'm confused what you tried.

Yeah, but I was only referring to the SMP affinity mask. Please see more
up-to-date testing results above.

>>>  and if the machine was under traffic load incoming when the
>>> driver loaded, CPU0 would start to poll among all the different netdev
>>> queues, all on CPU0.
>>>
>>> The above then leads to the condition that the device is stuck polling
>>> even if the affinity gets updated from user space, and the polling will
>>> continue until traffic stops.
>>>

[...]

>> As we can see in the above trace the initial affinity for the IRQ 1478 was
>> correctly set as per the default_smp_affinity mask which includes CPU 42,
>> however, later on, it is updated with CPU3 which is returned from
>> cpumask_local_spread().
>>
>>> Maybe the right thing is to fix which CPUs are passed in as the valid
>>> mask, or make sure the kernel cross checks that what the driver asks
>>> for is a "valid CPU"?
>>>
>> Sure, if we can still reproduce the problem that your patch was fixing then
>> maybe we can consider adding a new API like cpumask_local_spread_irq in
>> which we should consider deafult_smp_affinity mask as well before returning
>> the CPU.
> I'm sure I don't have a reproducer of the original problem any more, it
> is lost somewhere 8 years ago. I'd like to be able to repro the original
> issue, but I can't.
>
> Your description of the problem makes it obvious there is an issue. It
> appears as if cpumask_local_spread() is the wrong function to use here.
> If you have any suggestions please let me know.
>
> We had one other report of this problem as well (I'm not sure if it's
> the same as your report)
> https://lkml.org/lkml/2021/3/28/206
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210125/023120.html


How about we introduce a new API just for IRQ spreading,
cpumask_local_spread_irq() and then utilize the default_smp_affinity mask
in that before returning the CPU?

Although, I think the right way to deal with this would be to fix this from
the source that is where the CPU mask is assigned to an IRQ for the very
first time.


-- 
Thanks
Nitesh

