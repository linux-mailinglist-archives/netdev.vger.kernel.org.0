Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905AE5FC436
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 13:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJLLOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 07:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJLLNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 07:13:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB62AC1D99;
        Wed, 12 Oct 2022 04:13:45 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MnVM12bWSz688Cb;
        Wed, 12 Oct 2022 19:10:53 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Wed, 12 Oct 2022 13:13:42 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 12:13:42 +0100
Message-ID: <534c5a0b-4c78-0524-a145-200ae3dea368@huawei.com>
Date:   Wed, 12 Oct 2022 14:13:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 02/18] landlock: refactor
 landlock_find_rule/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
 <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
 <1ba8c972-1b81-dd85-c24b-83525511083e@huawei.com>
 <01283d8a-3319-af3c-7139-466fe22ca8e4@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <01283d8a-3319-af3c-7139-466fe22ca8e4@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/12/2022 1:06 PM, Mickaël Salaün пишет:
> 
> On 12/10/2022 10:37, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 9/6/2022 11:07 AM, Mickaël Salaün пишет:
>>> Good to see such clean commit!
>>>
>>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>>> Adds a new landlock_key union and landlock_id structure to support
>>>> a socket port rule type. Refactors landlock_insert_rule() and
>>>> landlock_find_rule() to support coming network modifications.
>>>
>>>> This patch also adds is_object_pointer() and get_root() helpers.
>>>
>>> Please explain a bit what these helpers do.
>>>
>>>
>>>> Now adding or searching a rule in a ruleset depends on a landlock id
>>>> argument provided in refactored functions mentioned above.
>>>
>>> More explanation:
>>> A struct landlock_id identifies a unique entry in a ruleset: either a
>>> kernel object (e.g inode) or a typed data (e.g. TCP port). There is one
>>> red-black tree per key type.
>>>
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>
>>> Because most changes come from
>>> https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f
>>> and
>>> https://git.kernel.org/mic/c/7d6cf40a6f81adf607ad3cc17aaa11e256beeea4
>>> you can append
>>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
>> 
>>     Do I need to add Co-developed-by: Mickaël Salaün <mic@digikod.net>
>>     and Signed-off-by: Mickaël Salaün <mic@digikod.net> or just
>>     Co-developed-by: Mickaël Salaün <mic@digikod.net> ????
>> 
>>     Cause Submiting patches article says:
>>     https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>> 
>>     "...Since Co-developed-by: denotes authorship, every Co-developed-by:
>> must be immediately followed by a Signed-off-by: of the associated
>> co-author...."
>> 
>>     Is this correct signing for this patch:
>> 
>>     Co-developed-by: Mickaël Salaün <mic@digikod.net>
>>     Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>     Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> Because I'll merge your patches in my tree, I'll add my Signed-off-by to
> all patches. You can then just add Co-developed-by after your
> Signed-off-by for this one and I'll add the rest.

   Ok. I got it. Thanks for the explaning.
> .
