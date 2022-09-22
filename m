Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C95E6622
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiIVOri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiIVOrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:47:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B489F2761
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:47:32 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYJ2w1GshzpTls;
        Thu, 22 Sep 2022 22:44:40 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 22:47:30 +0800
Subject: Re: [RFCv8 PATCH net-next 02/55] net: replace general features
 macroes with global netdev_features variables
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
 <20220918094336.28958-3-shenjian15@huawei.com>
 <20220920131233.61a1b28c@kernel.org>
 <35b4b477-14b0-1952-4515-c96933e6f6dd@huawei.com>
 <0f60d53a-bde7-d5c7-f589-99774485f545@huawei.com>
 <20220921055004.10b6881b@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <8b394328-fa9a-a40d-bd92-e952b3e8d859@huawei.com>
Date:   Thu, 22 Sep 2022 22:47:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220921055004.10b6881b@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/9/21 20:50, Jakub Kicinski 写道:
> On Wed, 21 Sep 2022 18:01:16 +0800 shenjian (K) wrote:
>> 在 2022/9/21 14:33, shenjian (K) 写道:
>>>> On Sun, 18 Sep 2022 09:42:43 +0000 Jian Shen wrote:
>>>> We shouldn't be changing all these defines here, because that breaks
>>>> the build AFAIU.
>>> ok, will keep them until remove the __NETIF_F(name) macro.
>>>   
>> But I don't see how it break build. Do you mean the definition of
>>
>> WG_NETDEV_FEATURES in drivers/net/wireguard/device.c ？
> Oops, you're right, looks like this patch just adds a warning:
>
> net/core/netdev_features.c:99:13: warning: no previous prototype for function 'netdev_features_init' yi
> void __init netdev_features_init(void)
thanks, will fix it.

>
> Build is broken by the next one:
>
> drivers/net/ethernet/microsoft/mana/mana_en.c:2084:2: error: implicit declaration of function 'netdev_hw_features_zero' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>          netdev_hw_features_zero(ndev);
>          ^
> drivers/net/ethernet/microsoft/mana/mana_en.c:2085:2: error: implicit declaration of function 'netdev_hw_features_set_set' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>          netdev_hw_features_set_set(ndev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
>          ^
> drivers/net/ethernet/microsoft/mana/mana_en.c:2085:2: note: did you mean 'netdev_hw_features_zero'?
> drivers/net/ethernet/microsoft/mana/mana_en.c:2084:2: note: 'netdev_hw_features_zero' declared here
>          netdev_hw_features_zero(ndev);
>          ^
> .
Sorry, I missed include netdev_feature_helpers.h.  I only did compile 
with allmodconfig on arm64 server, it didn't report build fail.
I should do compile on x86 server too, for mana driver is only supported 
on X86_64. Thanks!


