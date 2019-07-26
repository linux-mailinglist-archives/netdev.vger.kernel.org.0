Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94B76B2C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfGZOLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:11:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10309 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfGZOLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 10:11:06 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3b09f60000>; Fri, 26 Jul 2019 07:11:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 26 Jul 2019 07:11:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 26 Jul 2019 07:11:04 -0700
Received: from [10.26.11.58] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 26 Jul
 2019 14:11:01 +0000
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
Date:   Fri, 26 Jul 2019 15:11:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564150262; bh=7V/0vUwcrIsIcIy2xWgyyeEieWEZr2FRYFdBVkYbeyQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mJDWo1CPsTJea2C7XpERAf9KXg8RisOceJD+uSLFeI1yyUzkGurA7BChg+6xKS9wa
         yLkxSzCVyt6hC2yWO1w5HZUPPkPCFd/KbaZtV1vWd5NCVt+3LH+09luniQCev/R06V
         ClVqhzPr+ebBRMamcTph3XbpD1oJSLEHC+tQQq8zN5FTrYrLk2FbwMVCPLYelEhzGv
         1Ba0uS43gyhxp68YWyqG7GN1bJasAEjqijE1paEjN/rJe5I8or0GrIRwvZNrPQboZy
         vb6yMlFe8nldtK2ANvrJp/Zj9fVC6e7JkvK3TBe7+O8Hu1OXs7SP6j8/nZfoB5pQN2
         04nm16vaN1x0g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/07/2019 16:12, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/25/2019, 15:25:59 (UTC+00:00)
> 
>>
>> On 25/07/2019 14:26, Jose Abreu wrote:
>>
>> ...
>>
>>> Well, I wasn't expecting that :/
>>>
>>> Per documentation of barriers I think we should set descriptor fields 
>>> and then barrier and finally ownership to HW so that remaining fields 
>>> are coherent before owner is set.
>>>
>>> Anyway, can you also add a dma_rmb() after the call to 
>>> stmmac_rx_status() ?
>>
>> Yes. I removed the debug print added the barrier, but that did not help.
> 
> So, I was finally able to setup NFS using your replicated setup and I 
> can't see the issue :(
> 
> The only difference I have from yours is that I'm using TCP in NFS 
> whilst you (I believe from the logs), use UDP.

So I tried TCP by setting the kernel boot params to 'nfsvers=3' and
'proto=tcp' and this does appear to be more stable, but not 100% stable.
It still appears to fail in the same place about 50% of the time.

> You do have flow control active right ? And your HW FIFO size is >= 4k ?

How can I verify if flow control is active?

The documentation for this device indicates a max transfer size of 16kB
for TX and RX.

Cheers
Jon

-- 
nvpublic
