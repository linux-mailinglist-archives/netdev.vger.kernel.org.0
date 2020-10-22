Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6FF29557F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507491AbgJVA1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:27:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:26848 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440647AbgJVA1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 20:27:34 -0400
IronPort-SDR: c8K/DDwrquZrqYATLWcUgQWUIzZi5dL2koLTm+EwZCepV9pc6fzmujwjC/PSG8ItqACe4O3Lph
 2JslZEEpSQug==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="147311327"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="147311327"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 17:27:31 -0700
IronPort-SDR: 1Ma8nA7sjOvVStgOnzIylMyaFuV52Ohtj7fxjd8IkeVlQmA9SrnuaTHQBSN746g9c1VlsDbLrp
 zHd9Be+NoaXQ==
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="359067328"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.13.114]) ([10.209.13.114])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 17:27:24 -0700
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com, jlelli@redhat.com,
        hch@infradead.org, bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com, Dave Miller <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <87v9f57zjf.fsf@nanos.tec.linutronix.de>
 <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
 <87lfg093fo.fsf@nanos.tec.linutronix.de>
 <877drj72cz.fsf@nanos.tec.linutronix.de>
 <20201021170224.55aea948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a1c6cdcd-7f89-5ed3-c869-ffec05929786@intel.com>
Date:   Wed, 21 Oct 2020 17:27:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201021170224.55aea948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/2020 5:02 PM, Jakub Kicinski wrote:
> On Wed, 21 Oct 2020 22:25:48 +0200 Thomas Gleixner wrote:
>> On Tue, Oct 20 2020 at 20:07, Thomas Gleixner wrote:
>>> On Tue, Oct 20 2020 at 12:18, Nitesh Narayan Lal wrote:  
>>>> However, IMHO we would still need a logic to prevent the devices from
>>>> creating excess vectors.  
>>>
>>> Managed interrupts are preventing exactly that by pinning the interrupts
>>> and queues to one or a set of CPUs, which prevents vector exhaustion on
>>> CPU hotplug.
>>>
>>> Non-managed, yes that is and always was a problem. One of the reasons
>>> why managed interrupts exist.  
>>
>> But why is this only a problem for isolation? The very same problem
>> exists vs. CPU hotplug and therefore hibernation.
>>
>> On x86 we have at max. 204 vectors available for device interrupts per
>> CPU. So assumed the only device interrupt in use is networking then any
>> machine which has more than 204 network interrupts (queues, aux ...)
>> active will prevent the machine from hibernation.
>>
>> Aside of that it's silly to have multiple queues targeted at a single
>> CPU in case of hotplug. And that's not a theoretical problem.  Some
>> power management schemes shut down sockets when the utilization of a
>> system is low enough, e.g. outside of working hours.
>>
>> The whole point of multi-queue is to have locality so that traffic from
>> a CPU goes through the CPU local queue. What's the point of having two
>> or more queues on a CPU in case of hotplug?
>>
>> The right answer to this is to utilize managed interrupts and have
>> according logic in your network driver to handle CPU hotplug. When a CPU
>> goes down, then the queue which is associated to that CPU is quiesced
>> and the interrupt core shuts down the relevant interrupt instead of
>> moving it to an online CPU (which causes the whole vector exhaustion
>> problem on x86). When the CPU comes online again, then the interrupt is
>> reenabled in the core and the driver reactivates the queue.
> 
> I think Mellanox folks made some forays into managed irqs, but I don't
> remember/can't find the details now.
> 

I remember looking into this a few years ago, and not getting very far
either.

> For networking the locality / queue per core does not always work,
> since the incoming traffic is usually spread based on a hash. Many
> applications perform better when network processing is done on a small
> subset of CPUs, and application doesn't get interrupted every 100us. 
> So we do need extra user control here.
> 
> We have a bit of a uAPI problem since people had grown to depend on
> IRQ == queue == NAPI to configure their systems. "The right way" out
> would be a proper API which allows associating queues with CPUs rather
> than IRQs, then we can use managed IRQs and solve many other problems.
> 

I think we (Intel) hit some of the same issues you mention.

I know I personally would like to see something that lets a lot of the
current driver-specific policy be moved out. I think it should be
possible to significantly simplify the abstraction used by the drivers.

> Such new API has been in the works / discussions for a while now.
> 
> (Magnus keep me honest here, if you disagree the queue API solves this.)
>
