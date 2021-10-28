Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB91743E048
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhJ1L4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:56:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14872 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhJ1L4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 07:56:38 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hg3qs05qFz90VG;
        Thu, 28 Oct 2021 19:54:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 19:54:04 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Thu, 28 Oct
 2021 19:54:03 +0800
Subject: Re: [PATCH net 1/7] net: hns3: fix pause config problem after autoneg
 disabled
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
 <20211027121149.45897-2-huangguangbin2@huawei.com> <YXmLA4AbY83UV00f@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <09eda9fe-196b-006b-6f01-f54e75715961@huawei.com>
Date:   Thu, 28 Oct 2021 19:54:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YXmLA4AbY83UV00f@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/28 1:23, Andrew Lunn wrote:
> On Wed, Oct 27, 2021 at 08:11:43PM +0800, Guangbin Huang wrote:
> 
> The semantics are not too well defined here, the ethtool documentation
> is not too clear. Here is how i interpret it.
> 
>> If a TP port is configured by follow steps:
>> 1.ethtool -s ethx autoneg off speed 100 duplex full
> 
> So you turn general autoneg off
> 
>> 2.ethtool -A ethx rx on tx on
> 
> You did not use autoneg off here. Pause autoneg is separate to general
> autoneg. So pause autoneg is still enabled at this point. That means
> you should not directly configure the MAC with the pause
> configuration, you only do that when pause autoneg is off. You can
> consider this as setting how you want pause to be negotiated once
> general autoneg is re-enabled.
> 
>> 3.ethtool -s ethx autoneg on(rx&tx negotiated pause results are off)
> 
> So you reenable general autoneg. As part of that general autoneg,
> pause will re-renegotiated, and it should you the preferences you set
> in 2, that rx and tx pause can be used. What is actually used depends
> on the link peer. The link_adjust callback from phylib tells you how
> to program the MAC.
> 
>> 4.ethtool -s ethx autoneg off speed 100 duplex full
> 
> So you turn general autoneg off again. It is unclear how you are
> supposed to program the MAC, but i guess most systems keep with the
> result from the last autoneg.
> 
> Looking at your patch, there are suspicious calls to phy_syspend and
> phy_resume. They don't look correct at all, and i'm not aware of any
> other MAC driver doing this. Now, i know the behaviour is not well
> defined here, but i'm not sure your interpretation is valid and how
> others interpret it.
> 
>         Andrew
> .
> 
Hi Andrew, thanks very much for your guidance on how to use pause autoneg,
it confuses me before because PHY registers actually have no separate setting
bit of pause autoneg.

So, summarize what you mean:
1. If pause autoneg is on, driver should always use the autoneg result to program
    the MAC. Eventhough general autoneg is off now and link state is no changed then
    driver just needs to keep the last configuration for the MAC, if link state is
    changed and phy goes down and up then driver needs to program the MAC according
    to the autoneg result in the link_adjust callback.
2. If pause autoneg is off, driver should directly configure the MAC with tx pause
    and rx pause. Eventhough general autoneg is on, driver should ignore the autoneg
    result.

Do I understand right?

Guangbin
.
