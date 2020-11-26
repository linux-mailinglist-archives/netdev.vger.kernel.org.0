Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3384F2C5709
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391088AbgKZOX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:23:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7498 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390803AbgKZOX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:23:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbfba640001>; Thu, 26 Nov 2020 06:23:32 -0800
Received: from [10.26.72.188] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Nov
 2020 14:23:13 +0000
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
Date:   Thu, 26 Nov 2020 16:23:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201125141822.GI2075216@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606400612; bh=WpNUnDTDVrCO7cZthOExAehl0Kt0b9gDTd44Rc4r07M=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=Zj1sGwGBj7ZwnBbRcKi9XRTvPZxbVJX6mF+UBqxmk3KCeWkiCZEadm2rwoKN60tCF
         E696Qf8sbCt3PSIe4a/pfmRcvVMDIGGAcC0KQC8W6puGt12PPFf94gZjVXLx3pzu2X
         XTpVQDWRClznvTdyaCEhLF3nR3LUs/kpULxjiEmXqzH5zZSl3lq9YmIqLCeHCoTLz9
         JheIowZkiqcf6yxZ0u0qTcjts1yhmPJ4kxdGWT/OAFvkuDQP9wOvbnB78TQmNjkdar
         E2EKs+njH2+mIKACmqD4/qijEhJBO/2/EItzGKBQyFdtXOWrR7aRvlNMsQbvpvLRgw
         zhSiW/16ztwNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/25/2020 4:18 PM, Andrew Lunn wrote:
> External email: Use caution opening links or attachments
>
>
>> OK, we will add API options to select bank and page to read any specific
>> page the user selects. So advanced user will use it get the optional pag=
es
>> he needs, but what about non advanced user who wants to use the current =
API
>> with a current script for DSFP EEPROM. Isn't it better that he will get =
the
>> 5 mandatory pages then keep it not supported ?
> Users using ethtool will not see a difference. They get a dump of what
> ethtool knows how to decode. It should try the netlink API first, and
> then fall back to the old ioctl interface.
Yes, it makes sense that whenever command not supported by netlink API=20
it falls back to old ioctl interface. As I see it we want here to add=20
bank and page options to netlink API=C2=A0 to get data from specific page.
>
> If i was implementing the ethtool side of it, i would probably do some
> sort of caching system. We know page 0 should always exist, so
> pre-load that into the cache. Try the netlink API first. If that
> fails, use the ioctl interface. If the ioctl is used, put everything
> returned into the cache.
I am not sure what you mean by cache here. Don't you want to read page 0=20
once you got the ethtool command to read from the module ? If not, then=20
at what stage ?
>   The decoder can then start decoding, see what
> bits are set indicating other pages should be available. Ask for them
> from the cache. The netlink API can go fetch them and load them into
> the cache. If they cannot be loaded return ENODEV, and the decoder has
> to skip what it wanted to decode.

So the decoder should read page 0 and check according to page 0 and=20
specification which pages should be present, right ?

What about the global offset that we currently got when user doesn't=20
specify a page, do you mean that this global offset goes through the=20
optional and non optional pages that exist and skip the ones that are=20
missing according to the specific EEPROM ?

>   If you do it correctly, the decoder
> should not care about ioctl vs netlink.
>
> I can do a follow up patch for the generic SFP code in
> drivers/net/phy, once you have done the first implementation. But i
> only have a limited number of SFPs and most are 1G only. Russell King
> can hopefully test with his collection.
>
>       Andrew
