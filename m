Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18244262A2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhJHC4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:56:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:28895 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhJHC4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 22:56:04 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HQXj40Sp5zbn9Q;
        Fri,  8 Oct 2021 10:49:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 10:54:07 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 8 Oct 2021
 10:54:07 +0800
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
To:     Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <20211001151710.20451-1-alexandr.lobakin@intel.com>
 <YVsWyO3Fa5RC0hRh@lunn.ch>
 <b335852ecaba3c86d1745b5021bb500798fc843b.camel@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <ca5b086b-4563-7bbe-203f-13d1fd230ec8@huawei.com>
Date:   Fri, 8 Oct 2021 10:54:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <b335852ecaba3c86d1745b5021bb500798fc843b.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Saeed

Sorry to reply late.


在 2021/10/5 6:30, Saeed Mahameed 写道:
> On Mon, 2021-10-04 at 16:59 +0200, Andrew Lunn wrote:
>> On Fri, Oct 01, 2021 at 05:17:10PM +0200, Alexander Lobakin wrote:
>>> From: Jian Shen <shenjian15@huawei.com>
>>> Date: Wed, 29 Sep 2021 23:50:47 +0800
>>>
>>> Hi,
>>>
>>>> For the prototype of netdev_features_t is u64, and the number
>>>> of netdevice feature bits is 64 now. So there is no space to
>>>> introduce new feature bit.
>>>>
>>>> This patchset try to solve it by change the prototype of
>>>> netdev_features_t from u64 to bitmap. With this change,
>>>> it's necessary to introduce a set of bitmap operation helpers
>>>> for netdev features. Meanwhile, the functions which use
>>>> netdev_features_t as return value are also need to be changed,
>>>> return the result as an output parameter.
>>>>
>>>> With above changes, it will affect hundreds of files, and all the
>>>> nic drivers. To make it easy to be reviewed, split the changes
>>>> to 167 patches to 5 parts.
>>> If you leave the current feature field set (features, hw_features
>>> etc.) as is and just add new ones as bitmaps -- I mean, to place
>>> only newly added features there -- you won't have to change this in
>>> hundreds of drivers.
>> That makes things messy for the future. Two different ways to express
>> the same thing. And it is a trap waiting for developers to fall
>> into. Is this a new feature or an old feature bit? Should i add it to
>> the old or new bitmap? Will the compiler error out if i get it wrong,
>> or silently accept it?
>>
>>> Another option is to introduce new fields as bitmaps and mirror all
>>> features there, but also keep the current ones. This implies some
>>> code duplication -- to keep both sets in sync -- but it will also
>>> allow to avoid such diffstats. Developers could switch their
>>> drivers
>>> one-by-one then, and once they finish converting,
>> Which will never happen. Most developers will say, why bother, it
>> works as it is, i'm too lazy. And many drivers don't have an active
>> developer, and so won't get converted.
>>
>> Yes it is a big patchset, but at the end, we get a uniform API which
>> is future proof, and no traps waiting for developers to fall into.
>>
> I agree, i had to visit this topic a year ago or so, and the only
> conclusion was is to solve this the hard way, introduce a totally new
> mechanism, the safest way is to remove old netdev_features_t fields
> from netdev and add new ones (both names and types), so compiler will
> catch you if you missed to convert a place.

Yes, I agree that this way is safest, and it's necessary to ensure the 
compiler can
catch any missed convertion or incorrect convertion.

I'm a bit  confused about  use new names.  If so, all most the changes 
will have
be put into a single patch, which may be too big to be reviewed.


>
> maybe hide the implementation details and abstract it away from drivers
> using getters and manipulation APIs, it is not that bad since drivers
> are already not supposed to modify netdev_features directly.
>

For the getters and manipulation APIs， do you mean the helpers for 
netdev_features,
using bitmap ops ?


>>     Andrew
>
> .
>

