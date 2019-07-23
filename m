Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2DF71911
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbfGWNUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:20:00 -0400
Received: from foss.arm.com ([217.140.110.172]:54704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbfGWNUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:20:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDAAF28;
        Tue, 23 Jul 2019 06:19:58 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA0C83F71F;
        Tue, 23 Jul 2019 06:19:56 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
 <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
 <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BYAPR12MB3269A725AFDDA21E92946558D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <ab14f31f-2045-b1be-d31f-2a81b8527dac@nvidia.com>
 <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <3255edfa-4465-204b-4751-8d40c8fb1382@arm.com>
Date:   Tue, 23 Jul 2019 14:19:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2019 13:09, Jon Hunter wrote:
> 
> On 23/07/2019 11:29, Robin Murphy wrote:
>> On 23/07/2019 11:07, Jose Abreu wrote:
>>> From: Jon Hunter <jonathanh@nvidia.com>
>>> Date: Jul/23/2019, 11:01:24 (UTC+00:00)
>>>
>>>> This appears to be a winner and by disabling the SMMU for the ethernet
>>>> controller and reverting commit 954a03be033c7cef80ddc232e7cbdb17df735663
>>>> this worked! So yes appears to be related to the SMMU being enabled. We
>>>> had to enable the SMMU for ethernet recently due to commit
>>>> 954a03be033c7cef80ddc232e7cbdb17df735663.
>>>
>>> Finally :)
>>>
>>> However, from "git show 954a03be033c7cef80ddc232e7cbdb17df735663":
>>>
>>> +         There are few reasons to allow unmatched stream bypass, and
>>> +         even fewer good ones.  If saying YES here breaks your board
>>> +         you should work on fixing your board.
>>>
>>> So, how can we fix this ? Is your ethernet DT node marked as
>>> "dma-coherent;" ?
>>
>> The first thing to try would be booting the failing setup with
>> "iommu.passthrough=1" (or using CONFIG_IOMMU_DEFAULT_PASSTHROUGH) - if
>> that makes things seem OK, then the problem is likely related to address
>> translation; if not, then it's probably time to start looking at nasties
>> like coherency and ordering, although in principle I wouldn't expect the
>> SMMU to have too much impact there.
> 
> Setting "iommu.passthrough=1" works for me. However, I am not sure where
> to go from here, so any ideas you have would be great.

OK, so that really implies it's something to do with the addresses. From 
a quick skim of the patch, I'm wondering if it's possible for buf->addr 
and buf->page->dma_addr to get out-of-sync at any point. The nature of 
the IOVA allocator makes it quite likely that a stale DMA address will 
have been reused for a new mapping, so putting the wrong address in a 
descriptor may well mean the DMA still ends up hitting a valid 
translation, but which is now pointing to a different page.

>> Do you know if the SMMU interrupts are working correctly? If not, it's
>> possible that an incorrect address or mapping direction could lead to
>> the DMA transaction just being silently terminated without any fault
>> indication, which generally presents as inexplicable weirdness (I've
>> certainly seen that on another platform with the mix of an unsupported
>> interrupt controller and an 'imperfect' ethernet driver).
> 
> If I simply remove the iommu node for the ethernet controller, then I
> see lots of ...
> 
> [    6.296121] arm-smmu 12000000.iommu: Unexpected global fault, this could be serious
> [    6.296125] arm-smmu 12000000.iommu:         GFSR 0x00000002, GFSYNR0 0x00000000, GFSYNR1 0x00000014, GFSYNR2 0x00000000
> 
> So I assume that this is triggering the SMMU interrupt correctly.

According to tegra186.dtsi it appears you're using the MMU-500 combined 
interrupt, so if global faults are being delivered then context faults 
*should* also, but I'd be inclined to try a quick hack of the relevant 
stmmac_desc_ops::set_addr callback to write some bogus unmapped address 
just to make sure arm_smmu_context_fault() then screams as expected, and 
we're not missing anything else.

Robin.
