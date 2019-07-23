Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C467171616
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbfGWK3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:29:32 -0400
Received: from foss.arm.com ([217.140.110.172]:52346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388997AbfGWK3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 06:29:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40CC0337;
        Tue, 23 Jul 2019 03:29:31 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B15A3F71A;
        Tue, 23 Jul 2019 03:29:29 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
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
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
Date:   Tue, 23 Jul 2019 11:29:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2019 11:07, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/23/2019, 11:01:24 (UTC+00:00)
> 
>> This appears to be a winner and by disabling the SMMU for the ethernet
>> controller and reverting commit 954a03be033c7cef80ddc232e7cbdb17df735663
>> this worked! So yes appears to be related to the SMMU being enabled. We
>> had to enable the SMMU for ethernet recently due to commit
>> 954a03be033c7cef80ddc232e7cbdb17df735663.
> 
> Finally :)
> 
> However, from "git show 954a03be033c7cef80ddc232e7cbdb17df735663":
> 
> +         There are few reasons to allow unmatched stream bypass, and
> +         even fewer good ones.  If saying YES here breaks your board
> +         you should work on fixing your board.
> 
> So, how can we fix this ? Is your ethernet DT node marked as
> "dma-coherent;" ?

The first thing to try would be booting the failing setup with 
"iommu.passthrough=1" (or using CONFIG_IOMMU_DEFAULT_PASSTHROUGH) - if 
that makes things seem OK, then the problem is likely related to address 
translation; if not, then it's probably time to start looking at nasties 
like coherency and ordering, although in principle I wouldn't expect the 
SMMU to have too much impact there.

Do you know if the SMMU interrupts are working correctly? If not, it's 
possible that an incorrect address or mapping direction could lead to 
the DMA transaction just being silently terminated without any fault 
indication, which generally presents as inexplicable weirdness (I've 
certainly seen that on another platform with the mix of an unsupported 
interrupt controller and an 'imperfect' ethernet driver).

Just to confirm, has the original patch been tested with 
CONFIG_DMA_API_DEBUG to rule out any high-level mishaps?

Robin.
