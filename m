Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48CE299896
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgJZVL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:11:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:30562 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730313AbgJZVL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:11:29 -0400
IronPort-SDR: OBHfSZJkRgtTQlDFowXcjp+EnOVX1b6l776nQzQEAD4lglZNwCnwtm7mRYJEH4SDZzfZKDfbz9
 VYjHBLs3i1pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="229624396"
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="229624396"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 14:11:28 -0700
IronPort-SDR: Ubn4S/P+VpD/ORx74RsTV5F4jduNtxi7OAPIPg67McVnBCBtoTpZ3ZvNLS8g/fQBzTRu1ElV6b
 7qQpVQB2BfsQ==
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="524430113"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.215.218]) ([10.212.215.218])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 14:11:27 -0700
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
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
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <85b5f53e-5be2-beea-269a-f70029bea298@intel.com>
Date:   Mon, 26 Oct 2020 14:11:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <87v9ew3fzd.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2020 1:11 PM, Thomas Gleixner wrote:
> On Mon, Oct 26 2020 at 12:21, Jacob Keller wrote:
>> On 10/26/2020 12:00 PM, Thomas Gleixner wrote:
>>> How does userspace know about the driver internals? Number of management
>>> interrupts, optimal number of interrupts per queue?
>>
>> I guess this is the problem solved in part by the queue management work
>> that would make queues a thing that userspace is aware of.
>>
>> Are there drivers which use more than one interrupt per queue? I know
>> drivers have multiple management interrupts.. and I guess some drivers
>> do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
>> have multiple queues for one interrupt .. I'm not sure how a single
>> queue with multiple interrupts would work though.
> 
> For block there is always one interrupt per queue. Some Network drivers
> seem to have seperate RX and TX interrupts per queue.
> 
> Thanks,
> 
>         tglx
> 

That's true when thinking of Tx and Rx as a single queue. Another way to
think about it is "one rx queue" and "one tx queue" each with their own
interrupt...

Even if there are devices which force there to be exactly queue pairs,
you could still think of them as separate entities?

Hmm.
