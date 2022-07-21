Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6957CEC7
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiGUPVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGUPVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:21:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C49E1FCE3
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:21:31 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lpbq35bFLzGp8V;
        Thu, 21 Jul 2022 23:20:15 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 21 Jul
 2022 23:21:19 +0800
Subject: Re: [RFCv6 PATCH net-next 02/19] net: replace general features
 macroes with global netdev_features variables
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
References: <0cec0cac-dae7-cce7-ccf2-92e5d7086642@huawei.com>
 <20220720150957.3875487-1-alexandr.lobakin@intel.com>
 <eb0625cd-26a4-439a-1aca-fcc773393b8b@huawei.com>
 <20220721145716.745433-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <92df1790-b467-3c87-bb5d-c6b3a8016378@huawei.com>
Date:   Thu, 21 Jul 2022 23:21:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220721145716.745433-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/7/21 22:57, Alexander Lobakin 写道:
> From: shenjian (K) <shenjian15@huawei.com>
> Date: Thu, 21 Jul 2022 09:15:59 +0800
>
>> 在 2022/7/20 23:09, Alexander Lobakin 写道:
>>> From: shenjian (K) <shenjian15@huawei.com>
>>> Date: Wed, 20 Apr 2022 17:54:13 +0800
>>>
>>>> 在 2022/4/19 22:49, Alexander Lobakin 写道:
>>>>> From: Jian Shen <shenjian15@huawei.com>
>>>>> Date: Tue, 19 Apr 2022 10:21:49 +0800
>>>>>
>>>>>> There are many netdev_features bits group used in kernel. The
>>>> definition
>>>>>> will be illegal when using feature bit more than 64. Replace these
>>>> macroes
>>>>>> with global netdev_features variables, initialize them when netdev
>>>> module
>>>>>> init.
>>>>>>
>>>>>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>>>>>> ---
>>>>>>     drivers/net/wireguard/device.c  |  10 +-
>>>>>>     include/linux/netdev_features.h | 102 +++++++++-----
>>>>>>     net/core/Makefile               |   2 +-
>>>>>>     net/core/dev.c                  |  87 ++++++++++++
>>>>>>     net/core/netdev_features.c      | 241
>>>> ++++++++++++++++++++++++++++++++
>>>>>>     5 files changed, 400 insertions(+), 42 deletions(-)
>>>>>>     create mode 100644 net/core/netdev_features.c
>>>>>>
>>>>> --- 8< ---
>>>>>
>>>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>>>> index 4d6b57752eee..85bb418e8ef1 100644
>>>>>> --- a/net/core/dev.c
>>>>>> +++ b/net/core/dev.c
>>>>>> @@ -146,6 +146,7 @@
>>>>>>     #include <linux/sctp.h>
>>>>>>     #include <net/udp_tunnel.h>
>>>>>>     #include <linux/net_namespace.h>
>>>>>> +#include <linux/netdev_features_helper.h>
>>>>>>     #include <linux/indirect_call_wrapper.h>
>>>>>>     #include <net/devlink.h>
>>>>>>     #include <linux/pm_runtime.h>
>>>>>> @@ -11255,6 +11256,90 @@ static struct pernet_operations
>>>> __net_initdata default_device_ops = {
>>>>>>         .exit_batch = default_device_exit_batch,
>>>>>>     };
>>>>>>     >> +static void netdev_features_init(void)
>>>>> It is an initialization function, so it must be marked as __init.
>>>> right, I will add it, thanks!
>>>>
>>>>>> +{
>>>>>> +    netdev_features_t features;
>>>>>> +
>>>>>> + netdev_features_set_array(&netif_f_never_change_feature_set,
>>>>>> +                  &netdev_never_change_features);
>>>>>> +
>>>>>> + netdev_features_set_array(&netif_f_gso_feature_set_mask,
>>>>> I'm not sure it does make sense to have an empty newline between
>>>>> each call. I'd leave newlines only between the "regular" blocks
>>>>> and the "multi-call" blocks, I mean, stuff like VLAN, GSO and
>>>>> @netdev_ethtool_features.
>>>> At first, I added empty newline per call for the it used three lines.
>>>> Now the new call just use two lines, I will remove some unnecessary
>>>> blank lines.
>>>>
>>>> Thanks!
>>> I see no news regarding the conversion since the end of April, maybe
>>> I could pick it and finish if nobody objects? I'll preserve the
>>> original authorship for sure.
>>>
>> Hi， Alexander
>>
>> Sorry for late to finish the whole patchset with treewide changes, but
>> I'm still working on it.
>> And most of the convertsions have been completed. I will send to new
>> patchset in two weeks.
> Oh okay, I was only worried that it could be abandoned for some
> reason. Great to hear it's almost done, 120+ drivers is not
> something quick or exciting :)
Thanks, I will speed up efforts.

> I'll start reviewing the series, at least its "core" part, as soon
> as it hits netdev ML. Thanks!
Yes, It's need sufficient review, I want to get as many as possible 
advices for it.
Thanks!

>> Jian
>>
>>>>>> +                  &netdev_gso_features_mask);
> [...]
>
>>> Thanks,
>>> Olek
>>>
>>> .
>>>
> Olek
>
> .
>

