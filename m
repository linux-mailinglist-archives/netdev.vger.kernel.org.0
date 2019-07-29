Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004C0789EE
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbfG2KzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:55:24 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14169 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387424AbfG2KzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:55:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3ed0940000>; Mon, 29 Jul 2019 03:55:16 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 29 Jul 2019 03:55:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 29 Jul 2019 03:55:23 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 29 Jul
 2019 10:55:20 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Robin Murphy <robin.murphy@arm.com>,
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b99b1e49-0cbc-2c66-6325-50fa6f263d91@nvidia.com>
Date:   Mon, 29 Jul 2019 11:55:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR12MB327907D4A6FB378AC989571AD3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564397716; bh=omDvOxcL+shZp/+aXr1xB3RKxxO5BazPvZPcci4EFmo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ar0IAPUIBvyLVDB7OfxBEElq9IxI3GlwIo/u0cfRm5nKXcpNqte6llsmeQm/AsVdP
         gnQGwqDf6FNqcNGx4W2M1Y4ce7rAEYBmOGFq2jYx7P7JwRQf4p1ML3QVow9yIumCp7
         gID5AZOb8ub1z/PCB/z1B7BAEer01kfYjKTfjhFLXpPMrrIUAuEHUzHoOVEebIILVs
         I2l1SUVpSY/CfoR7PmAveqXp5fnAfJpvAmjMhADK72H+A5MgxoQEd/6wdVmm1chZQJ
         SxsAyQe9hSmDAdA0Vzp+ImSAf1jhs6pqkVwPVs6MYoUtzbdPBf0TAGwA4oOtTDV44+
         aubzSqRST5vhA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/07/2019 09:16, Jose Abreu wrote:
> From: Jose Abreu <joabreu@synopsys.com>
> Date: Jul/27/2019, 16:56:37 (UTC+00:00)
> 
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Date: Jul/26/2019, 15:11:00 (UTC+00:00)
>>
>>>
>>> On 25/07/2019 16:12, Jose Abreu wrote:
>>>> From: Jon Hunter <jonathanh@nvidia.com>
>>>> Date: Jul/25/2019, 15:25:59 (UTC+00:00)
>>>>
>>>>>
>>>>> On 25/07/2019 14:26, Jose Abreu wrote:
>>>>>
>>>>> ...
>>>>>
>>>>>> Well, I wasn't expecting that :/
>>>>>>
>>>>>> Per documentation of barriers I think we should set descriptor fields 
>>>>>> and then barrier and finally ownership to HW so that remaining fields 
>>>>>> are coherent before owner is set.
>>>>>>
>>>>>> Anyway, can you also add a dma_rmb() after the call to 
>>>>>> stmmac_rx_status() ?
>>>>>
>>>>> Yes. I removed the debug print added the barrier, but that did not help.
>>>>
>>>> So, I was finally able to setup NFS using your replicated setup and I 
>>>> can't see the issue :(
>>>>
>>>> The only difference I have from yours is that I'm using TCP in NFS 
>>>> whilst you (I believe from the logs), use UDP.
>>>
>>> So I tried TCP by setting the kernel boot params to 'nfsvers=3' and
>>> 'proto=tcp' and this does appear to be more stable, but not 100% stable.
>>> It still appears to fail in the same place about 50% of the time.
>>>
>>>> You do have flow control active right ? And your HW FIFO size is >= 4k ?
>>>
>>> How can I verify if flow control is active?
>>
>> You can check it by dumping register MTL_RxQ_Operation_Mode (0xd30).

Where would be the appropriate place to dump this? After probe? Maybe
best if you can share a code snippet of where to dump this.

>> Can you also add IOMMU debug in file "drivers/iommu/iommu.c" ?

You can find a boot log here:

https://paste.ubuntu.com/p/qtRqtYKHGF/

> And, please try attached debug patch.

With this patch it appears to boot fine. So far no issues seen.

Jon

-- 
nvpublic
