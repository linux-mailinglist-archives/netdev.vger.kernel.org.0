Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2AA7A9C9
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbfG3Ngq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:36:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6857 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfG3Ngq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:36:46 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d4047ee0000>; Tue, 30 Jul 2019 06:36:46 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 30 Jul 2019 06:36:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 30 Jul 2019 06:36:44 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jul
 2019 13:36:41 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
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
 <fcf648d2-70cc-d734-871a-ca7f745791b7@arm.com>
 <MN2PR12MB3279ABF628C52883021123C5D3DD0@MN2PR12MB3279.namprd12.prod.outlook.com>
 <8a60361f-b914-93ef-0d80-92ae4ad8b808@nvidia.com>
 <BN8PR12MB32664E23137805984F6FB2DAD3DC0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8cb2ac13-3009-2117-d55f-6f1126b690e4@nvidia.com>
Date:   Tue, 30 Jul 2019 14:36:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB32664E23137805984F6FB2DAD3DC0@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564493806; bh=HacDlfvXZhjwdQNemg3f+1KENoSodR+AJ9DMM7MgZXM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=r+lHpSghERB2qPV8QeTvnlJ26APFnGjovZYNgpVjKEfFPW/0QV4n4JbQK3wiefryU
         GLPeczHgcGWttDAQxC2FB822Wq0g+bPt9KH1ZtSVy4nFfe9r9cdDMl7R2vNT+2fUgn
         7Km7IBTaJmkwduPNxTRHA0IPPBV2rtPpgBQT+sqC2mHlyh4ACbqGGhgsidKYr3WnVe
         /N82lv0Ch9DQCOgNLC28RiZBE8kLfq5PNydM0cusjxXUI73fjpZVkFbhlWlBnEPZxR
         bEzDZbTqyJ8j7Ypg9a7H0OFD7U0EqSwJ4Ua+oquA3dRTzT4ZdF/GL07EkOBL/1LLLX
         3FPxTekGsJ8Yg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/07/2019 10:39, Jose Abreu wrote:

...

> I looked at netsec implementation and I noticed that we are syncing the 
> old buffer for device instead of the new one. netsec syncs the buffer 
> for device immediately after the allocation which may be what we have to 
> do. Maybe the attached patch can make things work for you ?

Great! This one works. I have booted this several times and I am no
longer seeing any issues. Thanks for figuring this out!

Feel free to add my ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
