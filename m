Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94015BF40B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 05:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiIUDEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 23:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIUDEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 23:04:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39846BC2E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:04:39 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXNVP0xkbzpTcP;
        Wed, 21 Sep 2022 11:01:49 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 11:04:37 +0800
Subject: Re: [RFCv8 PATCH net-next 01/55] net: introduce operation helpers for
 netdev features
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
 <20220918094336.28958-2-shenjian15@huawei.com>
 <20220920131059.7626a665@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <1c797f5c-f8db-ebff-42a9-3fb830e1ca34@huawei.com>
Date:   Wed, 21 Sep 2022 11:04:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220920131059.7626a665@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/9/21 4:10, Jakub Kicinski 写道:
> On Sun, 18 Sep 2022 09:42:42 +0000 Jian Shen wrote:
>> Introduce a set of bitmap operation helpers for netdev features,
>> then we can use them to replace the logical operation with them.
>>
>> The implementation of these helpers are based on the old prototype
>> of netdev_features_t is still u64. These helpers will be rewritten
>> on the last patch, follow the prototype changes. For the new type
>> netdev_features_t maybe large than 8 bytes, use netdev_features_t
>> pointer as parameter.
>>
>> To avoid interdependencies between netdev_features_helper.h and
>> netdevice.h, put the helpers for testing feature in the netdevice.h,
>> and move advandced helpers like netdev_get_wanted_features() and
>> netdev_intersect_features() to netdev_features_helper.h.
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> index 8b77582bdfa0..8023a3f0d43b 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> @@ -4,6 +4,7 @@
>>   #include <linux/etherdevice.h>
>>   #include <linux/io-64-nonatomic-hi-lo.h>
>>   #include <linux/lockdep.h>
>> +#include <linux/netdev_feature_helpers.h>
>>   #include <net/dst_metadata.h>
>>   
>>   #include "nfpcore/nfp_cpp.h"
> We need to start breaking upstreamable chunks out of this mega-series
> otherwise we won't make any progress..
>
> Please make a patch which will move netdev_intersect_features() and
> netdev_get_wanted_features() to the new linux/netdev_feature_helpers.h
> header, and add the missing includes. Post it separately as soon as
> possible.
ok， will split it.
>> diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
>> new file mode 100644
>> index 000000000000..4bb5de61e4e9
>> --- /dev/null
>> +++ b/include/linux/netdev_feature_helpers.h
>> @@ -0,0 +1,607 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Network device features helpers.
>> + */
>> +#ifndef _LINUX_NETDEV_FEATURES_HELPER_H
>> +#define _LINUX_NETDEV_FEATURES_HELPER_H
>> +
>> +#include <linux/netdevice.h>
>> +
>> +static inline void __netdev_features_zero(netdev_features_t *dst)
>> +{
>> +	*dst = 0;
>> +}
>> +
>> +#define netdev_features_zero(features) __netdev_features_zero(&(features))
>> +
>> +/* active_feature prefer to netdev->features */
>> +#define netdev_active_features_zero(ndev) \
>> +		netdev_features_zero((ndev)->features)
>> +
> No need for empty lines between the defines of the same category, IMHO.
ok,  will remove the unnecessary empty lines.

>> +#define netdev_hw_features_zero(ndev) \
>> +		netdev_features_zero((ndev)->hw_features)
> .
>

