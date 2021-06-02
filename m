Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35117398A01
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFBMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:50:46 -0400
Received: from foss.arm.com ([217.140.110.172]:44056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhFBMup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:50:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07AC46D;
        Wed,  2 Jun 2021 05:49:02 -0700 (PDT)
Received: from [10.57.73.64] (unknown [10.57.73.64])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 080E53F719;
        Wed,  2 Jun 2021 05:48:59 -0700 (PDT)
Subject: Re: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>
Cc:     jroedel@suse.de, netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com, hch@lst.de,
        iommu@lists.linux-foundation.org, suravee.suthikulpanit@amd.com,
        gregkh@linuxfoundation.org
References: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
 <cc58c09e-bbb5-354a-2030-bf8ebb2adc86@iogearbox.net>
 <7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com>
 <CAHn8xckNt3smeQPi3dgq5i_3vP7KwU45pnP5OCF8nOV_QEdyMA@mail.gmail.com>
 <7c04eeea-22d3-c265-8e1e-b3f173f2179f@iogearbox.net>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <705f90c3-b933-8863-2124-3fea7fdbd81a@arm.com>
Date:   Wed, 2 Jun 2021 13:48:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7c04eeea-22d3-c265-8e1e-b3f173f2179f@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-02 09:09, Daniel Borkmann wrote:
> On 6/1/21 7:42 PM, Jussi Maki wrote:
>> Hi Robin,
>>
>> On Tue, Jun 1, 2021 at 2:39 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>>>> The regression shows as a significant drop in throughput as measured
>>>>> with "super_netperf" [0],
>>>>> with measured bandwidth of ~95Gbps before and ~35Gbps after:
>>>
>>> I guess that must be the difference between using the flush queue
>>> vs. strict invalidation. On closer inspection, it seems to me that
>>> there's a subtle pre-existing bug in the AMD IOMMU driver, in that
>>> amd_iommu_init_dma_ops() actually runs *after* amd_iommu_init_api()
>>> has called bus_set_iommu(). Does the patch below work?
>>
>> Thanks for the quick response & patch. I tried it out and indeed it
>> does solve the issue:

Cool, thanks Jussi. May I infer a Tested-by tag from that?

>> # uname -a
>> Linux zh-lab-node-3 5.13.0-rc3-amd-iommu+ #31 SMP Tue Jun 1 17:12:57
>> UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
>> root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
>> 95341.2
>>
>> root@zh-lab-node-3:~# uname -a
>> Linux zh-lab-node-3 5.13.0-rc3-amd-iommu-unpatched #32 SMP Tue Jun 1
>> 17:29:34 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
>> root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
>> 33989.5
> 
> Robin, probably goes without saying, but please make sure to include ...
> 
> Fixes: a250c23f15c2 ("iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE")
> 
> ... to your fix in [0], maybe along with another Fixes tag pointing to 
> the original
> commit adding this issue. But certainly a250c23f15c2 would be good given 
> the regression
> was uncovered on that one first, so that Greg et al have a chance to 
> pick this fix up
> for stable kernels.

Given that the race looks to have been pretty theoretical until now, I'm 
not convinced it's worth the bother of digging through the long history 
of default domain and DMA ops movement to figure where it started, much 
less attempt invasive backports. The flush queue change which made it 
apparent only landed in 5.13-rc1, so as long as we can get this in as a 
fix in the current cycle we should be golden - in the meantime, note 
that booting with "iommu.strict=0" should also restore the expected 
behaviour.

FWIW I do still plan to resend the patch "properly" soon (in all honesty 
it wasn't even compile-tested!)

Cheers,
Robin.
