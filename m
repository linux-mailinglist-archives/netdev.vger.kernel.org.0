Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4572BFC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGXKDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:03:16 -0400
Received: from foss.arm.com ([217.140.110.172]:38126 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfGXKDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 06:03:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EBAD337;
        Wed, 24 Jul 2019 03:03:15 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A29953F71F;
        Wed, 24 Jul 2019 03:03:13 -0700 (PDT)
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
 <3255edfa-4465-204b-4751-8d40c8fb1382@arm.com>
 <ae11deb4-abec-f0f9-312d-b11d72bc74cd@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <bdfe91d0-96a4-91d3-3955-66933c319462@arm.com>
Date:   Wed, 24 Jul 2019 11:03:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ae11deb4-abec-f0f9-312d-b11d72bc74cd@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2019 22:39, Jon Hunter wrote:
> 
> On 23/07/2019 14:19, Robin Murphy wrote:
> 
> ...
> 
>>>> Do you know if the SMMU interrupts are working correctly? If not, it's
>>>> possible that an incorrect address or mapping direction could lead to
>>>> the DMA transaction just being silently terminated without any fault
>>>> indication, which generally presents as inexplicable weirdness (I've
>>>> certainly seen that on another platform with the mix of an unsupported
>>>> interrupt controller and an 'imperfect' ethernet driver).
>>>
>>> If I simply remove the iommu node for the ethernet controller, then I
>>> see lots of ...
>>>
>>> [    6.296121] arm-smmu 12000000.iommu: Unexpected global fault, this
>>> could be serious
>>> [    6.296125] arm-smmu 12000000.iommu:         GFSR 0x00000002,
>>> GFSYNR0 0x00000000, GFSYNR1 0x00000014, GFSYNR2 0x00000000
>>>
>>> So I assume that this is triggering the SMMU interrupt correctly.
>>
>> According to tegra186.dtsi it appears you're using the MMU-500 combined
>> interrupt, so if global faults are being delivered then context faults
>> *should* also, but I'd be inclined to try a quick hack of the relevant
>> stmmac_desc_ops::set_addr callback to write some bogus unmapped address
>> just to make sure arm_smmu_context_fault() then screams as expected, and
>> we're not missing anything else.
> 
> I hacked the driver and forced the address to zero for a test and
> in doing so I see ...
> 
> [   10.440072] arm-smmu 12000000.iommu: Unhandled context fault: fsr=0x402, iova=0x00000000, fsynr=0x1c0011, cbfrsynra=0x14, cb=0
> 
> So looks like the interrupts are working AFAICT.

OK, that's good, thanks for confirming. Unfortunately that now leaves us 
with the challenge of figuring out how things are managing to go wrong 
*without* ever faulting... :)

I wonder if we can provoke the failure on non-IOMMU platforms with 
"swiotlb=force" - I have a few boxes I could potentially test that on, 
but sadly forgot my plan to bring one with me this morning.

Robin.
