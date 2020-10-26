Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B9F299A35
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395445AbgJZXIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:08:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:39672 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394676AbgJZXIN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:08:13 -0400
IronPort-SDR: C0HKN+3xVxuhHup+b8wKNn5CD+V6moJckNtJIXbUN05IuMXEg5AFWXEUu8Z85WuxQatCL/28zj
 bU9dRqa88mTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="164500454"
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="164500454"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 16:08:12 -0700
IronPort-SDR: zy8W979PBVagL8i+Jv+r805cLR1FVBAasdYfpwLnnY5dMEYS9mo977q0BeEUHtu8ZSPkUShL6e
 ejjJSj2+O2cA==
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="524468975"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.215.218]) ([10.212.215.218])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 16:08:10 -0700
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping
 CPUs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
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
 <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com>
 <875z6w38n4.fsf@nanos.tec.linutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <586e249a-1078-9fe9-22d4-b3c1ec0a3a5e@intel.com>
Date:   Mon, 26 Oct 2020 16:08:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <875z6w38n4.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2020 3:49 PM, Thomas Gleixner wrote:
> On Mon, Oct 26 2020 at 18:22, Nitesh Narayan Lal wrote:
>> On 10/26/20 5:50 PM, Thomas Gleixner wrote:
>>> But I still think that for curing that isolation stuff we want at least
>>> some information from the driver. Alternative solution would be to grant
>>> the allocation of interrupts and queues and have some sysfs knob to shut
>>> down queues at runtime. If that shutdown results in releasing the queue
>>> interrupt (via free_irq()) then the vector exhaustion problem goes away.
>>
>> I think this is close to what I and Marcelo were discussing earlier today
>> privately.
>>
>> I don't think there is currently a way to control the enablement/disablement of
>> interrupts from the userspace.
> 
> You cannot just disable the interrupt. You need to make sure that the
> associated queue is shutdown or quiesced _before_ the interrupt is shut
> down.
> 
> Thanks,
> 
>         tglx
> 

Could this be handled with a callback to the driver/hw? I know Intel HW
should support this type of quiesce/shutdown.

Thanks,
Jake
