Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBEB590FD3
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiHLK6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiHLK6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:58:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD558AB42B
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 03:58:31 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M40v70dm6zkWN5;
        Fri, 12 Aug 2022 18:55:15 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 12 Aug
 2022 18:58:29 +0800
Subject: Re: [RFCv7 PATCH net-next 02/36] net: replace general features
 macroes with global netdev_features variables
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-3-shenjian15@huawei.com>
 <20220810095800.1304489-1-alexandr.lobakin@intel.com>
 <7eb9ad01-cf1f-afea-0c16-4b269462236f@huawei.com>
 <20220811110529.4866-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <4f37548d-c0df-ecd0-62ed-975e4d52f26c@huawei.com>
Date:   Fri, 12 Aug 2022 18:58:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220811110529.4866-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/8/11 19:05, Alexander Lobakin 写道:
> From: "shenjian (K)" <shenjian15@huawei.com>
> Date: Wed, 10 Aug 2022 20:01:15 +0800
>
>> 在 2022/8/10 17:58, Alexander Lobakin 写道:
>> > From: Jian Shen <shenjian15@huawei.com>
>> > Date: Wed, 10 Aug 2022 11:05:50 +0800
>> >
>> >> There are many netdev_features bits group used in kernel. The 
>> definition
>> >> will be illegal when using feature bit more than 64. Replace these 
>> macroes
>> >> with global netdev_features variables, initialize them when netdev 
>> module
>> >> init.
>> >>
>> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> >> ---
>
> [...]
>
>> >> @@ -11362,6 +11363,86 @@ static struct pernet_operations 
>> __net_initdata default_device_ops = {
>> >>       .exit_batch = default_device_exit_batch,
>> >>   };
>> >>   >> +static void __init netdev_features_init(void)
>> > Given that you're creating a new file dedicated to netdev features,
>> > I'd place that initializer there. You can then declare its proto in
>> > net/core/dev.h.
>> I want to make sure it cann't be called outside net/core/dev.c, for some
>> drivers include net/core/dev.h, then they can see it.
>
> net/core/dev.h is internal, nobody outside net/core/ uses it and
> this was its purpose.
>
All right, will move it netdev_features.c
>>
>> >> +{
>> >> +    netdev_features_t features;
>> >> +
>> >> + netdev_features_set_array(&netif_f_ip_csum_feature_set,
>> >> +                  &netdev_ip_csum_features);
>> >> + netdev_features_set_array(&netif_f_csum_feature_set_mask,
>> >> +                  &netdev_csum_features_mask);
>> >> +
>> >> + netdev_features_set_array(&netif_f_gso_feature_set_mask,
>> >> +                  &netdev_gso_features_mask);
>> >> + netdev_features_set_array(&netif_f_general_tso_feature_set,
>> >> +                  &netdev_general_tso_features);
>> >> + netdev_features_set_array(&netif_f_all_tso_feature_set,
>> >> +                  &netdev_all_tso_features);
>> >> + netdev_features_set_array(&netif_f_tso_ecn_feature_set,
>> >> +                  &netdev_tso_ecn_features);
>> >> + netdev_features_set_array(&netif_f_all_fcoe_feature_set,
>> >> +                  &netdev_all_fcoe_features);
>> >> + netdev_features_set_array(&netif_f_gso_soft_feature_set,
>> >> +                  &netdev_gso_software_features);
>> >> + netdev_features_set_array(&netif_f_gso_encap_feature_set,
>> >> +                  &netdev_gso_encap_all_features);
>> >> +
>> >> +    netdev_csum_gso_features_mask =
>> >> +        netdev_features_or(netdev_gso_features_mask,
>> >> +                   netdev_csum_features_mask);
>> > (I forgot to mention this in 01/36 ._.)
>> >
>> > As you're converting to bitmaps, you should probably avoid direct
>> > assignments. All the bitmap_*() modification functions take a pointer
>> > to the destination as a first argument. So it should be
>> >
>> > netdev_features_or(netdev_features_t *dst, const netdev_features_t 
>> *src1,
>> >            const netdev_features_t *src1);
>> The netdev_features_t will be convert to a structure which only 
>> contained
>> a feature bitmap. So assginement is ok.
>
> Yeah I realized it later, probably a good idea.
>
>>
>>
>> >> +
>> >> + netdev_features_set_array(&netif_f_one_for_all_feature_set,
>> >> +                  &netdev_one_for_all_features);
>> > Does it make sense to prefix features and the corresponding sets
>> > differently? Why not just 'netdev_' for both of them?
>> For all the feature bits are named "NETFI_F_XXX_BIT",
>
> Right, but then why are netdev_*_features prefixed with 'netdev',
> not 'netif_f'? :D Those sets are tied tightly with the feature
> structures, so I think they should have the same prefix. I'd go
> with 'netdev' for both.
>
ok, will prefix with 'netdev'

>>
>>
>> >> + netdev_features_set_array(&netif_f_all_for_all_feature_set,
>> >> +                  &netdev_all_for_all_features);
>
> [...]
>
>> >> -- >> 2.33.0
>> > Thanks,
>> > Olek
>> >
>> > .
>>
>> Thank,
>> Jian
>
> Thanks,
> Olek
>
> .
>
Thanks,
Jian
