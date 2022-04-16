Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B380650358E
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiDPJMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiDPJM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:12:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134F413D70
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 02:09:44 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KgS7m1PN2zRTwJ;
        Sat, 16 Apr 2022 17:09:40 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 16 Apr
 2022 17:09:42 +0800
Subject: Re: [RFCv5 PATCH net-next 02/20] net: introduce operation helpers for
 netdev features
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
 <20220324154932.17557-3-shenjian15@huawei.com>
 <20220324180931.7e6e5188@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <752c07fc-2417-1685-5950-8d8770b9f048@huawei.com>
 <20220416094246.43b34dd6@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <0830b624-fd63-8095-da81-ee0951421aa2@huawei.com>
Date:   Sat, 16 Apr 2022 17:09:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220416094246.43b34dd6@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/4/16 15:42, Jakub Kicinski 写道:
> On Sat, 16 Apr 2022 11:33:58 +0800 shenjian (K) wrote:
>> 在 2022/3/25 9:09, Jakub Kicinski 写道:
>>> On Thu, 24 Mar 2022 23:49:14 +0800 Jian Shen wrote:
>>>> Introduce a set of bitmap operation helpers for netdev features,
>>>> then we can use them to replace the logical operation with them.
>>>> As the nic driversare not supposed to modify netdev_features
>>>> directly, it also introduces wrappers helpers to this.
>>>>
>>>> The implementation of these helpers are based on the old prototype
>>>> of netdev_features_t is still u64. I will rewrite them on the last
>>>> patch, when the prototype changes.
>>>>
>>>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>>>> ---
>>>>    include/linux/netdevice.h | 597 ++++++++++++++++++++++++++++++++++++++
>>> Please move these helpers to a new header file which won't be included
>>> by netdevice.h and include it at users appropriately.
>> I introduced a new header file "netdev_features_helper",  and moved
>> thses helpers
>> to it.  Some helpers need to include struct  net_device which defined in
>> netdevice.h,
>> but there are also some inline functions in netdevice.h need to use
>> these netdev_features
>> helpers. It's conflicted.
>>
>> So far I thought 3 ways to solved it, but all of them are not satisfactory.
>> 1) Split netdevice.h, move the definition of struct net_device and its
>> relative definitions to
>> a new header file A( haven't got a reasonable name).  Both the
>> netdev_features_helper.h
>> and the netdevice include A.
>>
>> 2) Split netdevice.h, move the inline functions to a new header file B.
>> The netdev_features_helper.h
>> inlucde netdevice.h， and B include netdev_features_helper.h and
>> netdevice.h. All the source files
>> which using these ininline functions should include B.
>>
>> 3) Split netdevice.h, move the inline functions to to
>> netdev_featurer_helper.h. The netdev_features_helper.h
>> inlucde netdevice.h, All the source files which using these ininline
>> functions should include netde_features_helper.h.
>>
>> I'd like to get more advice to this.
> Larger surgery is probably too much. What does netdevice.h need? Looks
> like it mostly needs the type and the helper for testing if feature is
> set. So maybe we can put those in netdevice.h and the rest in a new
> header?
> More advanced helpers like netdev_get_wanted_features() can move to the
> new header as well.
> .
ok, got it, thanks


