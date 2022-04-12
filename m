Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A324FDBA0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348952AbiDLKFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389767AbiDLJYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:24:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2143956227;
        Tue, 12 Apr 2022 01:38:37 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KczYz579yz67Zy6;
        Tue, 12 Apr 2022 16:35:19 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 12 Apr 2022 10:38:34 +0200
Message-ID: <5a229249-fd4a-76ee-ec94-5f29ca3a245c@huawei.com>
Date:   Tue, 12 Apr 2022 11:38:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 08/15] landlock: add support network rules
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-9-konstantin.meskhidze@huawei.com>
 <06f9ca1f-6e92-9d71-4097-e43b2f77b937@digikod.net>
 <8e279be2-5092-ad34-2f8d-ca77ee5a10fd@huawei.com>
 <6f9d82ed-081e-a6e4-5876-6af7db180ba1@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <6f9d82ed-081e-a6e4-5876-6af7db180ba1@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/11/2022 7:20 PM, Mickaël Salaün пишет:
> 
> On 11/04/2022 15:44, Konstantin Meskhidze wrote:
>>
>>
>> 4/8/2022 7:30 PM, Mickaël Salaün пишет:
> 
> [...]
> 
> 
>>>>   struct landlock_ruleset *landlock_create_ruleset(const struct 
>>>> landlock_access_mask *access_mask_set)
>>>>   {
>>>>       struct landlock_ruleset *new_ruleset;
>>>>
>>>>       /* Informs about useless ruleset. */
>>>> -    if (!access_mask_set->fs)
>>>> +    if (!access_mask_set->fs && !access_mask_set->net)
>>>>           return ERR_PTR(-ENOMSG);
>>>>       new_ruleset = create_ruleset(1);
>>>> -    if (!IS_ERR(new_ruleset))
>>>
>>> This is better:
>>>
>>> if (IS_ERR(new_ruleset))
>>>      return new_ruleset;
>>> if (access_mask_set->fs)
>>> ...
>>
>>    I dont get this condition. Do you mean that we return new_ruleset
>> anyway no matter what the masks's values are? So its possible to have 
>> 0 masks values, is't it?
> 
> No, the logic is correct but it would be simpler to exit as soon as 
> there is a ruleset error, you don't need to duplicate 
> "IS_ERR(new_ruleset) &&":
> 
> if (IS_ERR(new_ruleset))
>      return new_ruleset;
> if (access_mask_set->fs)
>      landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
> if (access_mask_set->net)
>      landlock_set_net_access_mask(new_ruleset, access_mask_set, 0);
> return new_ruleset;
> 
   Ok. I got it. Thank you.
> .
