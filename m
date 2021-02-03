Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891C030D1D7
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhBCC4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:56:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18793 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbhBCC4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 21:56:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a10980001>; Tue, 02 Feb 2021 18:55:20 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 02:55:13 +0000
Subject: Re: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210201020412.52790-1-cmi@nvidia.com>
 <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2dbcb5f51fd2ad1296c4391d45a854fef3438420.camel@kernel.org>
 <20210202132446.11d3af03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <88f1f8d9-b0fb-2e39-64cd-e380ac675f4d@nvidia.com>
Date:   Wed, 3 Feb 2021 10:55:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202132446.11d3af03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612320920; bh=iKEyd1CdnGO8jZU0OiaRPCAoFlE8Dtg2XfVoJkEL6a0=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=KKV2S6gaQ9hJvej8rUUIvMgrY3As5fEy6DXEZX/MAde3pLyCcCwoUXlw77hlAmR9b
         +fRnvGF7GSLLSRj0eARtD8dX/y848UNlS/mnqMoZyu7IDBJO4XuhVSsj3Mhnvt441j
         6cp7y7n6y9ISCwBNuBUlQwpQ5qpsQ1QX2dudjZ0EWygOpCIi1ZOfBs9vdEaQjhGoy2
         pR00y6nLZ4QpcaoEmU0dFFj6hoZq45E6y6KnoyzcKffYcgGeHgiJ5NhiydepTDoWQs
         XXinLlS11qytSD3mZ6SILmV0CqEdjm21BcF5/ZF8C7fI8NE4tvZf8D62MaaoY+QQmD
         EZQLVLrZ88GtA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 2/3/2021 5:24 AM, Jakub Kicinski wrote:
> On Mon, 01 Feb 2021 23:31:15 -0800 Saeed Mahameed wrote:
>> On Mon, 2021-02-01 at 17:14 -0800, Jakub Kicinski wrote:
>>> On Mon,=C2=A0 1 Feb 2021 10:04:12 +0800 Chris Mi wrote:
>>>> In order to send sampled packets to userspace, NIC driver calls
>>>> psample api directly. But it creates a hard dependency on module
>>>> psample. Introduce psample_ops to remove the hard dependency.
>>>> It is initialized when psample module is loaded and set to NULL
>>>> when the module is unloaded.
>>>>
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>> The necessity of making this change is not obvious (you can fix the
>>> distro scripts instead), you did not include a clarification in the
>>> commit message even though two people asked you why it's needed and
>>> on top of that you keep sending code which doesn't build.
>>>
>>> Please consider this change rejected and do not send a v7.
>> Jakub, it is not only about installation dependencies, the issue is
>> more critical than this,
>>
>> We had some other issues with similar dependency problem where
>> mlx5_core had hard dependency with netfilter, firewalld when disabled,
>> removes netfilter and all its dependencies including mlx5, this is a no
>> go for our users.
>>
>> Again, having a hard dependency between a hardware driver and a
>> peripheral module in the kernel is a bad design.
> That is not the point.
>
> The technical problem is minor, and it's a problem for _your_ driver.
> Yet, it appears to be my responsibility to make sure the patch even
> compiles.
>
> I believe there should be a limit to the ignorance a community
> volunteer is expected to put up with when dealing with patches
> from and for the benefit of a commercial vendor.
>
> This is up for discussion, if you disagree let's talk it out. I'm
> not particularly patient (to put it mildly), but I don't understand
> how v5 could have built, and yet v6 gets posted with the same exact
> problem :/
>
> So from my perspective it seems like the right step to push back.
> If you, Tariq, Jiri, Ido or any other seasoned kernel contributor
> reposts this after making sure it's up to snuff themselves I will
> most certainly take a look / apply.
Just now I tested v5 using sparse. I did hit some errors for psample.=20
The reason I
didn't hit it is because I only build the psample module. But I forget I=20
changed
the kernel. So I should build the whole kernel.

I'm really sorry that I waste you a lot of time for this bad quality=20
patch. You know
usually Saeed submits most of the patches on behalf of us. So I'm not=20
very familiar
with rules here.

So how about I submit v7 based on v4. I know you are very busy, if it is=20
not ok,
I'll wait for Saeed's further information about next step.

Thanks,
Chris
