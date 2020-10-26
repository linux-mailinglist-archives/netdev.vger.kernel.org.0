Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F1C2996BC
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792958AbgJZTWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:22:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:57938 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1792950AbgJZTWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 15:22:01 -0400
IronPort-SDR: tIUcMgvP9ru4BL/jqCsX3aYygbzY/vKAX+82XqZUd+Gz6Y/ngkw4nBFy1ujQOnGp8GQ9uvLjyk
 y85078KGIRxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="154942543"
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="154942543"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 12:21:59 -0700
IronPort-SDR: KP+zyN+pYWUHbv0ikkIrw3/C2WzNNgBx9rO1UOu5LO0PYHwHroIgJAPxnc1rIULGeCHLmKnuUm
 idHHtaWLyVYw==
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="524397909"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.215.218]) ([10.212.215.218])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 12:21:51 -0700
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
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com>
Date:   Mon, 26 Oct 2020 12:21:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <875z6w4xt4.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2020 12:00 PM, Thomas Gleixner wrote:
> On Mon, Oct 26 2020 at 14:30, Marcelo Tosatti wrote:
>> On Fri, Oct 23, 2020 at 11:00:52PM +0200, Thomas Gleixner wrote:
>>> So without information from the driver which tells what the best number
>>> of interrupts is with a reduced number of CPUs, this cutoff will cause
>>> more problems than it solves. Regressions guaranteed.
>>
>> One might want to move from one interrupt per isolated app core
>> to zero, or vice versa. It seems that "best number of interrupts 
>> is with reduced number of CPUs" information, is therefore in userspace, 
>> not in driver...
> 
> How does userspace know about the driver internals? Number of management
> interrupts, optimal number of interrupts per queue?
> 

I guess this is the problem solved in part by the queue management work
that would make queues a thing that userspace is aware of.

Are there drivers which use more than one interrupt per queue? I know
drivers have multiple management interrupts.. and I guess some drivers
do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
have multiple queues for one interrupt .. I'm not sure how a single
queue with multiple interrupts would work though.

>>> Managed interrupts base their interrupt allocation and spreading on
>>> information which is handed in by the individual driver and not on crude
>>> assumptions. They are not imposing restrictions on the use case.
>>>
>>> It's perfectly fine for isolated work to save a data set to disk after
>>> computation has finished and that just works with the per-cpu I/O queue
>>> which is otherwise completely silent. 
>>
>> Userspace could only change the mask of interrupts which are not 
>> triggered by requests from the local CPU (admin, error, mgmt, etc),
>> to avoid the vector exhaustion problem.
>>
>> However, there is no explicit way for userspace to know that, as far as
>> i know.
>>
>>  130:      34845          0          0          0          0          0          0          0  IR-PCI-MSI 33554433-edge      nvme0q1
>>  131:          0      27062          0          0          0          0          0          0  IR-PCI-MSI 33554434-edge      nvme0q2
>>  132:          0          0      24393          0          0          0          0          0  IR-PCI-MSI 33554435-edge      nvme0q3
>>  133:          0          0          0      24313          0          0          0          0  IR-PCI-MSI 33554436-edge      nvme0q4
>>  134:          0          0          0          0      20608          0          0          0  IR-PCI-MSI 33554437-edge      nvme0q5
>>  135:          0          0          0          0          0      22163          0          0  IR-PCI-MSI 33554438-edge      nvme0q6
>>  136:          0          0          0          0          0          0      23020          0  IR-PCI-MSI 33554439-edge      nvme0q7
>>  137:          0          0          0          0          0          0          0      24285  IR-PCI-MSI 33554440-edge      nvme0q8
>>
>> Can that be retrieved from PCI-MSI information, or drivers
>> have to inform this?
> 
> The driver should use a different name for the admin queues.
> 
> Thanks,
> 
>         tglx
> 
