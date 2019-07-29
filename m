Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807ED78AED
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbfG2LwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:52:06 -0400
Received: from foss.arm.com ([217.140.110.172]:42708 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387482AbfG2LwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 07:52:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CC9E28;
        Mon, 29 Jul 2019 04:52:05 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1E553F694;
        Mon, 29 Jul 2019 04:52:03 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S . Miller" <davem@davemloft.net>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
 <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
 <BYAPR12MB326922CDCB1D4B3D4A780CFDD3C30@BYAPR12MB3269.namprd12.prod.outlook.com>
 <MN2PR12MB327907D4A6FB378AC989571AD3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
 <b99b1e49-0cbc-2c66-6325-50fa6f263d91@nvidia.com>
 <MN2PR12MB327997BDF2EA5CEE00F45AC3D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <fcf648d2-70cc-d734-871a-ca7f745791b7@arm.com>
Date:   Mon, 29 Jul 2019 12:52:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <MN2PR12MB327997BDF2EA5CEE00F45AC3D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2019 12:29, Jose Abreu wrote:
> ++ Catalin, Will (ARM64 Maintainers)
> 
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/29/2019, 11:55:18 (UTC+00:00)
> 
>>
>> On 29/07/2019 09:16, Jose Abreu wrote:
>>> From: Jose Abreu <joabreu@synopsys.com>
>>> Date: Jul/27/2019, 16:56:37 (UTC+00:00)
>>>
>>>> From: Jon Hunter <jonathanh@nvidia.com>
>>>> Date: Jul/26/2019, 15:11:00 (UTC+00:00)
>>>>
>>>>>
>>>>> On 25/07/2019 16:12, Jose Abreu wrote:
>>>>>> From: Jon Hunter <jonathanh@nvidia.com>
>>>>>> Date: Jul/25/2019, 15:25:59 (UTC+00:00)
>>>>>>
>>>>>>>
>>>>>>> On 25/07/2019 14:26, Jose Abreu wrote:
>>>>>>>
>>>>>>> ...
>>>>>>>
>>>>>>>> Well, I wasn't expecting that :/
>>>>>>>>
>>>>>>>> Per documentation of barriers I think we should set descriptor fields
>>>>>>>> and then barrier and finally ownership to HW so that remaining fields
>>>>>>>> are coherent before owner is set.
>>>>>>>>
>>>>>>>> Anyway, can you also add a dma_rmb() after the call to
>>>>>>>> stmmac_rx_status() ?
>>>>>>>
>>>>>>> Yes. I removed the debug print added the barrier, but that did not help.
>>>>>>
>>>>>> So, I was finally able to setup NFS using your replicated setup and I
>>>>>> can't see the issue :(
>>>>>>
>>>>>> The only difference I have from yours is that I'm using TCP in NFS
>>>>>> whilst you (I believe from the logs), use UDP.
>>>>>
>>>>> So I tried TCP by setting the kernel boot params to 'nfsvers=3' and
>>>>> 'proto=tcp' and this does appear to be more stable, but not 100% stable.
>>>>> It still appears to fail in the same place about 50% of the time.
>>>>>
>>>>>> You do have flow control active right ? And your HW FIFO size is >= 4k ?
>>>>>
>>>>> How can I verify if flow control is active?
>>>>
>>>> You can check it by dumping register MTL_RxQ_Operation_Mode (0xd30).
>>
>> Where would be the appropriate place to dump this? After probe? Maybe
>> best if you can share a code snippet of where to dump this.
>>
>>>> Can you also add IOMMU debug in file "drivers/iommu/iommu.c" ?
>>
>> You can find a boot log here:
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__paste.ubuntu.com_p_qtRqtYKHGF_&d=DwICaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=NrxsR2etpZHGb7HkN4XdgaGmKM1XYyldihNPL6qVSv0&s=CMATEcHVoqZw4sIrNOXc7SFE_kV_5CO5EU21-yJez6c&e=
>>
>>> And, please try attached debug patch.
>>
>> With this patch it appears to boot fine. So far no issues seen.
> 
> Thank you for testing.
> 
> Hi Catalin and Will,
> 
> Sorry to add you in such a long thread but we are seeing a DMA issue
> with stmmac driver in an ARM64 platform with IOMMU enabled.
> 
> The issue seems to be solved when buffers allocation for DMA based
> transfers are *not* mapped with the DMA_ATTR_SKIP_CPU_SYNC flag *OR*
> when IOMMU is disabled.
> 
> Notice that after transfer is done we do use
> dma_sync_single_for_{cpu,device} and then we reuse *the same* page for
> another transfer.
> 
> Can you please comment on whether DMA_ATTR_SKIP_CPU_SYNC can not be used
> in ARM64 platforms with IOMMU ?

In terms of what they do, there should be no difference on arm64 between:

dma_map_page(..., dir);
...
dma_unmap_page(..., dir);

and:

dma_map_page_attrs(..., dir, DMA_ATTR_SKIP_CPU_SYNC);
dma_sync_single_for_device(..., dir);
...
dma_sync_single_for_cpu(..., dir);
dma_unmap_page_attrs(..., dir, DMA_ATTR_SKIP_CPU_SYNC);

provided that the first sync covers the whole buffer and any subsequent 
ones cover at least the parts of the buffer which may have changed. Plus 
for coherent hardware it's entirely moot either way.

Given Jon's previous findings, I would lean towards the idea that 
performing the extra (redundant) cache maintenance plus barrier in 
dma_unmap is mostly just perturbing timing in the same way as the debug 
print which also made things seem OK.

Robin.
