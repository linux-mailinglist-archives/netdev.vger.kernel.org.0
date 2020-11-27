Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D182C6883
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgK0PMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:12:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9448 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgK0PMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 10:12:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc117790000>; Fri, 27 Nov 2020 07:12:57 -0800
Received: from [10.26.72.188] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 27 Nov
 2020 15:12:40 +0000
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
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
Date:   Fri, 27 Nov 2020 17:12:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201126152113.GM2073444@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606489977; bh=nyrag7UI10GlLO62JuhKOK4cE1sh877bV15uRrBZUWY=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=N4Oo/++Z3TSA3N3+rYfX43seMWwZeiY5x8weOILERaTtHws/gCueUhVC3kbgesXVV
         xAIuhcmKLELkJ14NRPcoDfEI2ujObLuAr9W2/MvhYaM4/aDSABiCAvl60e4kWyk0rs
         yfvhaiHgrZV6c5I9UV1paO1OXLWG2qTKNV3hl3wJT6hdB9H2I+uCi43prfaogrEWaO
         A7pHU74rUKroynmFK0N07ibv/RBfk8mPOzIXE8/HA9jsl5+mb5Hc3XOjFAAvc8OauE
         FmgrdfWtzUNbwzlQUsN98AdMflFBELhCmqa3FP1zXzYCyMBcgaooCam66jEccHBYi6
         wH3P1nG8rbFTQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/26/2020 5:21 PM, Andrew Lunn wrote:
>>> If i was implementing the ethtool side of it, i would probably do some
>>> sort of caching system. We know page 0 should always exist, so
>>> pre-load that into the cache. Try the netlink API first. If that
>>> fails, use the ioctl interface. If the ioctl is used, put everything
>>> returned into the cache.
>> I am not sure what you mean by cache here. Don't you want to read page 0
>> once you got the ethtool command to read from the module ? If not, then at
>> what stage ?
> At the beginning, you try the netlink API and ask for pager 0, bytes
> 0-127. If you get a page, put it into the cache. If not, use the ioctl
> interface, which could return one page, or multiple pages. Put them
> all into the cache.


OK, but if the caching system is checking one time netlink and one time 
ioctl, it means this cache should be in user space, or did you mean to 
have this cache in kernel ?

>>>    The decoder can then start decoding, see what
>>> bits are set indicating other pages should be available. Ask for them
>>> from the cache. The netlink API can go fetch them and load them into
>>> the cache. If they cannot be loaded return ENODEV, and the decoder has
>>> to skip what it wanted to decode.
>> So the decoder should read page 0 and check according to page 0 and
>> specification which pages should be present, right ?
> Yes. It ask the cache, give me a pointer to page 0, bytes 0-127. It
> then decodes that, looking at the enumeration data to indicate what
> other pages should be available. Maybe it decides, page 0, bytes
> 128-255 should exist, so it asks the cache for a pointer to that. If
> using netlink, it would ask the kernel for that data, put it into the
> cache, and return a pointer. If using ioctl, it already knows if it
> has that data, so it just returns a pointer, so says sorry, not
> available.
>
>> What about the global offset that we currently got when user doesn't specify
>> a page, do you mean that this global offset goes through the optional and
>> non optional pages that exist and skip the ones that are missing according
>> to the specific EEPROM ?
> ethtool -m|--dump-module-eeprom|--module-info devname [raw on|off] [hex on|off] [offset N] [length N]
>
> So you mean [offset N] [length N].


Yes, that's the current options and we can either try coding new 
implementation for that or just call the current ioctl implementation. 
The new code can be triggered once options [bank N] and [Page N] are used.

>
> That is going to be hard, but the API is broken for complex SFPs with
> optional pages. And it is not well defined exactly what offset means.
> You can keep backwards compatibility by identifying the SFP from page
> 0, and then reading the pages in the order the ioctl would do. Let
> user space handle it, for those SFPs which the kernel already
> supports. For SFPs which the kernel does not support, i would just
> return not supported. You can do the same for raw. However, for new
> SFPs, for raw you can run the decoder but output to /dev/null. That
> loads into the cache all the pages which the decoder knows about. You
> can then dump the cache. You probably need a new format, to give an
> indication of what each page actually is.
OK, if I got it right on current API [offset N] [length N] just call 
ioctl current implementation, while using the option [raw on] will call 
new implementation for new SFPs (CMIS 4). Also using [bank N] and [page 
N] will call new implementation for new SFPs.
> Maybe you want to add new options [page N] [ bank N] to allow
> arbitrary queries to be made?
Exactly what I meant, I actually thought of letting the user ask for the 
page he wants, he should know what he needs.
> Again, you can answer these from the
> cache, so the old ioctl interface could work if asked for pages which
> the old API had.
Yes, for the simple EEPROM types that have 1 or 4 pages, ioctl read 
should be enough to get the data.
>
>      Andrew
