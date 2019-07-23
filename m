Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC6717C8
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389539AbfGWMJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:09:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9986 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbfGWMJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 08:09:07 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d36f8e80000>; Tue, 23 Jul 2019 05:09:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 23 Jul 2019 05:09:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 23 Jul 2019 05:09:05 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 12:09:02 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Robin Murphy <robin.murphy@arm.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
Date:   Tue, 23 Jul 2019 13:09:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563883753; bh=f84H2x2d3kzkl+x8HBl8e8hw6iLx/iNKgVfEttHgXug=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qhppD8ki1mZPculS6VOwNH++SDP1WkDQO1EDG0FUpQ5i6XCwnqQLt+t+ApjZhRL7E
         Wm/3vh3YOrX452bxtWTwckZsdioDIOxMCny/kdDsMV/IAp5ypzbflWKmS20Mn5kfHY
         C+NL6+x9QmB+DXwppouCioD3RKH/0pKwrO2JoepqIsd4ThoG9QLm2GWLFCYa7m3xpl
         NdlOMgS3ff0uIEBciueuMvRrxuRMseCyVNSgkf6LEHhai17NEGU8jmq63ofqNtpajG
         PEWLK82s8nUYWsR7FCJ+wHfZ8DW/tjHnRyvUnsUzTZ756ORpLI4Zg/O3gfHU0ku7h7
         VadBFPyDJh7yw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/07/2019 11:29, Robin Murphy wrote:
> On 23/07/2019 11:07, Jose Abreu wrote:
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Date: Jul/23/2019, 11:01:24 (UTC+00:00)
>>
>>> This appears to be a winner and by disabling the SMMU for the ethernet
>>> controller and reverting commit 954a03be033c7cef80ddc232e7cbdb17df73566=
3
>>> this worked! So yes appears to be related to the SMMU being enabled. We
>>> had to enable the SMMU for ethernet recently due to commit
>>> 954a03be033c7cef80ddc232e7cbdb17df735663.
>>
>> Finally :)
>>
>> However, from "git show 954a03be033c7cef80ddc232e7cbdb17df735663":
>>
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 There are few reasons =
to allow unmatched stream bypass, and
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 even fewer good ones.=
=C2=A0 If saying YES here breaks your board
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 you should work on fix=
ing your board.
>>
>> So, how can we fix this ? Is your ethernet DT node marked as
>> "dma-coherent;" ?
>=20
> The first thing to try would be booting the failing setup with
> "iommu.passthrough=3D1" (or using CONFIG_IOMMU_DEFAULT_PASSTHROUGH) - if
> that makes things seem OK, then the problem is likely related to address
> translation; if not, then it's probably time to start looking at nasties
> like coherency and ordering, although in principle I wouldn't expect the
> SMMU to have too much impact there.

Setting "iommu.passthrough=3D1" works for me. However, I am not sure where
to go from here, so any ideas you have would be great.

> Do you know if the SMMU interrupts are working correctly? If not, it's
> possible that an incorrect address or mapping direction could lead to
> the DMA transaction just being silently terminated without any fault
> indication, which generally presents as inexplicable weirdness (I've
> certainly seen that on another platform with the mix of an unsupported
> interrupt controller and an 'imperfect' ethernet driver).

If I simply remove the iommu node for the ethernet controller, then I
see lots of ...

[    6.296121] arm-smmu 12000000.iommu: Unexpected global fault, this could=
 be serious
[    6.296125] arm-smmu 12000000.iommu:         GFSR 0x00000002, GFSYNR0 0x=
00000000, GFSYNR1 0x00000014, GFSYNR2 0x00000000

So I assume that this is triggering the SMMU interrupt correctly.=20

> Just to confirm, has the original patch been tested with
> CONFIG_DMA_API_DEBUG to rule out any high-level mishaps?
Yes one of the first things we tried but did not bare any fruit.

Cheers
Jon

--=20
nvpublic
