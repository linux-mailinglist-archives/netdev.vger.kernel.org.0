Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD795084D4
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377137AbiDTJ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiDTJ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:26:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BCC36332
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:24:09 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KjwGS41fwzhXZV;
        Wed, 20 Apr 2022 17:24:00 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Apr
 2022 17:24:06 +0800
Subject: Re: [RFCv6 PATCH net-next 01/19] net: introduce operation helpers for
 netdev features
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
 <20220419022206.36381-2-shenjian15@huawei.com>
 <20220419144045.1664765-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <0f1a42f9-fe12-2e73-903f-2bf0736e699c@huawei.com>
Date:   Wed, 20 Apr 2022 17:24:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220419144045.1664765-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2022/4/19 22:40, Alexander Lobakin Ð´µÀ:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Tue, 19 Apr 2022 10:21:48 +0800
>
>> Introduce a set of bitmap operation helpers for netdev features,
>> then we can use them to replace the logical operation with them.
>> As the nic driversare not supposed to modify netdev_features
>> directly, it also introduces wrappers helpers to this.
>>
>> The implementation of these helpers are based on the old prototype
>> of netdev_features_t is still u64. I will rewrite them on the last
>> patch, when the prototype changes.
>>
>> To avoid interdependencies between netdev_features_helper.h and
>> netdevice.h, put the helpers for testing feature is set in the
>> netdevice.h, and move advandced helpers like
>> netdev_get_wanted_features() and netdev_intersect_features() to
>> netdev_features_helper.h.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>   .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 +
>>   include/linux/netdev_features.h               |  12 +
>>   include/linux/netdev_features_helper.h        | 604 ++++++++++++++++++
>>   include/linux/netdevice.h                     |  45 +-
>>   net/8021q/vlan_dev.c                          |   1 +
>>   net/core/dev.c                                |   1 +
>>   6 files changed, 646 insertions(+), 18 deletions(-)
>>   create mode 100644 include/linux/netdev_features_helper.h
>>
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> index ba3fa7eac98d..08f2c54e0a11 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/etherdevice.h>
>>   #include <linux/io-64-nonatomic-hi-lo.h>
>>   #include <linux/lockdep.h>
>> +#include <linux/netdev_features_helper.h>
>>   #include <net/dst_metadata.h>
>>   
>>   #include "nfpcore/nfp_cpp.h"
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 2c6b9e416225..e2b66fa3d7d6 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -11,6 +11,18 @@
>>   
>>   typedef u64 netdev_features_t;
>>   
>> +struct netdev_feature_set {
>> +	unsigned int cnt;
>> +	unsigned short feature_bits[];
>> +};
>> +
>> +#define DECLARE_NETDEV_FEATURE_SET(name, features...)		\
>> +	static unsigned short __##name##_s[] = {features};	\
>> +	struct netdev_feature_set name = {			\
> I suggest using `const` here. Those sets are needed only to
> initialize bitmaps, that's it. They are not supposed to be
> modified. This would be one more hardening here to avoid some weird
> usages of sets, and also would place them in .rodata instead of just
> .data.
>
> Function                                     old     new   delta
> main                                          35      33      -2
> Total: Before=78, After=76, chg -2.56%
> add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-14 (-14)
> Data                                         old     new   delta
> arr1                                           6       -      -6
> arr2                                           8       -      -8
> Total: Before=15, After=1, chg -93.33%
> add/remove: 2/0 grow/shrink: 0/0 up/down: 14/0 (14)
> RO Data                                      old     new   delta
> arr1                                           -       8      +8
> arr2                                           -       6      +6
> Total: Before=36, After=50, chg +38.89%
>
> As you can see, there's a 2-byte code optimization. And that was
> just a simpliest oneliner. The gains will be much bigger from the
> real usages.
thanks, will add it.


>> +		.cnt = ARRAY_SIZE(__##name##_s),		\
>> +		.feature_bits = {features},			\
>> +	}
> The problem with the current macro is that it doesn't allow to
> declare feature sets as static. Because the temporary array for
> counting the number of bits goes first, and doing
>
> static DECLARE_NETDEV_FEATURE_SET();
>
> wouldn't change anything.
Yes, it bothered me.

> But we want to have most feature sets static as they will be needed
> only inside one file. Making every of them global would hurt
> optimization.
>
> At the end, I came to
>
> #define DECLARE_NETDEV_FEATURE_SET(name, features...)			\
> 	const struct netdev_feature_set name = {			\
> 		.feature_bits = { features },				\
> 		.cnt = sizeof((u16 []){ features }) / sizeof(u16),	\
> 	}
>
> because ARRAY_SIZE() can be taken only from a variable, not from
> a compound literal.
> But this one is actually OK. We don't need ARRAY_SIZE() in here
> since we define an unnamed array of an explicit type that we know
> for sure inline. So there's no chance to do it wrong as long as
> the @features argument is correct.
>
> The ability to make it static is important. For example, when I
> marked them both static, I got
>
> add/remove: 0/0 grow/shrink: 0/0 up/down: 0/0 (0)
> Function                                     old     new   delta
> Total: Before=76, After=76, chg +0.00%
> add/remove: 0/0 grow/shrink: 0/0 up/down: 0/0 (0)
> Data                                         old     new   delta
> Total: Before=1, After=1, chg +0.00%
> add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-14 (-14)
> RO Data                                      old     new   delta
> arr1                                           6       -      -6
> arr2                                           8       -      -8
> Total: Before=50, After=36, chg -28.00%
>
> i.e. both of the sets were removed, because my main() was:
>
> 	printf("cnt1: %u, cnt2: %u\n", arr1.cnt, arr2.cnt);
>
> The compiler saw that I don't use them, except for printing values
> which are actually compile-time constants, and wiped them.
> Previously, they were global so it didn't have a clue if they're
> used anywhere else.
> This was a simple stupid example, but it will bring a lot more value
> in real use cases. So please consider my variant :D

Make sense. I will fix it.

Thanks a lot!


>> +
>>   enum {
>>   	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
>>   	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
> --- 8< ---
>
>> -- 
>> 2.33.0
> Thanks,
> Al
> .
>

