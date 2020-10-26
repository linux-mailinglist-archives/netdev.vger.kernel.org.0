Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB02999EA
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394840AbgJZWww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:52:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:11848 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394824AbgJZWwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 18:52:51 -0400
IronPort-SDR: XPbHC5JMJMU2xW6M8l2C9gLy4FHt0WMLfMM3Ftq6Mc0chG9HCj77tODfIAn5QLH39Yvvz00XUL
 QtkokZ2J7vZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="168123846"
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="168123846"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 15:52:50 -0700
IronPort-SDR: aEwpMeqlhYqUHNDZFgDcDWzInPxKt8h0og0IVJlvQeR8o+MACMLgKh45YQL3V9NANMG+TdoSNR
 U/z7oHF4AhOg==
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="524464467"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.215.218]) ([10.212.215.218])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 15:52:49 -0700
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
 <20201023085826.GP2611@hirez.programming.kicks-ass.net>
 <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
 <87ft6464jf.fsf@nanos.tec.linutronix.de>
 <20201026173012.GA377978@fuller.cnet>
 <875z6w4xt4.fsf@nanos.tec.linutronix.de>
 <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com>
 <87v9ew3fzd.fsf@nanos.tec.linutronix.de>
 <85b5f53e-5be2-beea-269a-f70029bea298@intel.com>
 <87lffs3bd6.fsf@nanos.tec.linutronix.de>
 <20201026151306.4af991a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <63c3484d-327e-5f37-7860-3af277c26711@intel.com>
Date:   Mon, 26 Oct 2020 15:52:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201026151306.4af991a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2020 3:13 PM, Jakub Kicinski wrote:
> On Mon, 26 Oct 2020 22:50:45 +0100 Thomas Gleixner wrote:
>> On Mon, Oct 26 2020 at 14:11, Jacob Keller wrote:
>>> On 10/26/2020 1:11 PM, Thomas Gleixner wrote:  
>>>> On Mon, Oct 26 2020 at 12:21, Jacob Keller wrote:  
>>>>> Are there drivers which use more than one interrupt per queue? I know
>>>>> drivers have multiple management interrupts.. and I guess some drivers
>>>>> do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
>>>>> have multiple queues for one interrupt .. I'm not sure how a single
>>>>> queue with multiple interrupts would work though.  
>>>>
>>>> For block there is always one interrupt per queue. Some Network drivers
>>>> seem to have seperate RX and TX interrupts per queue.  
>>> That's true when thinking of Tx and Rx as a single queue. Another way to
>>> think about it is "one rx queue" and "one tx queue" each with their own
>>> interrupt...
>>>
>>> Even if there are devices which force there to be exactly queue pairs,
>>> you could still think of them as separate entities?  
>>
>> Interesting thought.
>>
>> But as Jakub explained networking queues are fundamentally different
>> from block queues on the RX side. For block the request issued on queue
>> X will raise the complete interrupt on queue X.
>>
>> For networking the TX side will raise the TX interrupt on the queue on
>> which the packet was queued obviously or should I say hopefully. :)
>>
>> But incoming packets will be directed to some receive queue based on a
>> hash or whatever crystallball logic the firmware decided to implement.
>>
>> Which makes this not really suitable for the managed interrupt and
>> spreading approach which is used by block-mq. Hrm...
>>
>> But I still think that for curing that isolation stuff we want at least
>> some information from the driver. Alternative solution would be to grant
>> the allocation of interrupts and queues and have some sysfs knob to shut
>> down queues at runtime. If that shutdown results in releasing the queue
>> interrupt (via free_irq()) then the vector exhaustion problem goes away.
>>
>> Needs more thought and information (for network oblivious folks like
>> me).
> 
> One piece of information that may be useful is that even tho the RX
> packets may be spread semi-randomly the user space can still control
> which queues are included in the mechanism. There is an indirection
> table in the HW which allows to weigh queues differently, or exclude
> selected queues from the spreading. Other mechanisms exist to filter
> flows onto specific queues.
> 
> IOW just because a core has an queue/interrupt does not mean that
> interrupt will ever fire, provided its excluded from RSS.
> 
> Another piece is that by default we suggest drivers allocate 8 RX
> queues, and online_cpus TX queues. The number of queues can be
> independently controlled via ethtool -L. Drivers which can't support
> separate queues will default to online_cpus queue pairs, and let
> ethtool -L only set the "combined" parameter.
> 

I know the Intel drivers usually have defaulted to trying to maintain
queue pairs. I do not believe this is technically a HW restriction, but
it is heavily built into the way the drivers work today.

> There are drivers which always allocate online_cpus interrupts, 
> and then some of them will go unused if #qs < #cpus.
> 
> 

Right.

> My unpopular opinion is that for networking devices all the heuristics
> we may come up with are going to be a dead end. We need an explicit API
> to allow users placing queues on cores, and use managed IRQs for data
> queues. (I'm assuming that managed IRQs will let us reliably map a MSI-X
> vector to a core :))
> 

I don't think it is that unpopular... This is the direction I'd like to
see us go as well.
