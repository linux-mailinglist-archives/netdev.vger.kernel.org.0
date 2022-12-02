Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A6B63FE5A
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiLBCxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLBCxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:53:03 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA51A83261;
        Thu,  1 Dec 2022 18:53:01 -0800 (PST)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNctR1JS9z67RRb;
        Fri,  2 Dec 2022 10:52:31 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 03:52:59 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 02:52:58 +0000
Message-ID: <f52ca883-599c-0731-e710-f1255810650f@huawei.com>
Date:   Fri, 2 Dec 2022 05:52:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 04/12] landlock: Move unmask_layers() and
 init_layer_masks()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-5-konstantin.meskhidze@huawei.com>
 <aed09115-cfd8-1986-a848-bb33d2743def@digikod.net>
 <8542aa54-4d74-8b56-8dc4-ee619d66c7bf@huawei.com>
 <2ba68e9d-445d-78d4-bc3c-a12b29f9d63d@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <2ba68e9d-445d-78d4-bc3c-a12b29f9d63d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/28/2022 11:25 PM, Mickaël Salaün пишет:
> 
> On 28/11/2022 04:25, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:42 PM, Mickaël Salaün пишет:
>>>
>>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>>> This patch moves unmask_layers() and init_layer_masks() helpers
>>>> to ruleset.c to share with landlock network implementation in
>>>
>>> …to share them with the Landlock network implementation in
>>>
>>      Got it.
>>>
>>>> following commits.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
> 
> [...]
> 
>>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>>> index 608ab356bc3e..50baff4fcbb4 100644
>>>> --- a/security/landlock/ruleset.h
>>>> +++ b/security/landlock/ruleset.h
>>>> @@ -34,6 +34,16 @@ typedef u16 layer_mask_t;
>>>>    /* Makes sure all layers can be checked. */
>>>>    static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
>>>>
>>>> +/*
>>>> + * All access rights that are denied by default whether they are handled or not
>>>> + * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
>>>> + * entries when we need to get the absolute handled access masks.
>>>> + */
>>>> +/* clang-format off */
>>>> +#define ACCESS_INITIALLY_DENIED ( \
>>>> +	LANDLOCK_ACCESS_FS_REFER)
>>>> +/* clang-format on */
>>>
>>> This ACCESS_INITIALLY_DENIED definition must be moved, not copied. You
>>> can rename ACCESS_INITIALLY_DENIED to ACCESS_FS_INITIALLY_DENIED and
>>> move this hunk before the access_mask_t definition.
>>>
>>     Yep. Will be fixed.
>>>
>>>> +
>>>>    /**
>>>>     * struct landlock_layer - Access rights for a given layer
>>>>     */
>>>> @@ -246,4 +256,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>>>    		LANDLOCK_SHIFT_ACCESS_FS) &
>>>>    	       LANDLOCK_MASK_ACCESS_FS;
>>>>    }
>>>> +
>>>> +bool unmask_layers(const struct landlock_rule *const rule,
>>>
>>> All public Landlock helpers must be prefixed with "landlock_"
>> 
>>     Do you mean ones which are shared between fs and net parts?
> 
> All helpers that ends up in the exported ELF symbols, so all implemented
> in the .c files with their signature defined in .h files. The static
> inlined .h helpers don't need to have such prefix if there is no conflict.

   Got it. Thanks.
> 
> 
>>>
>>>> +		   const access_mask_t access_request,
>>>> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>>> +
>>>> +access_mask_t
>>>> +init_layer_masks(const struct landlock_ruleset *const domain,
>>>> +		 const access_mask_t access_request,
>>>> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>>
>>> There is a warning generated by checkpatch.pl about this line:
>>>      WARNING: function definition argument 'layer_mask_t' should also have
>>> an identifier name
>>>
>>> I think this is a bug in checkpatch.pl
>>>
>>      I got this warn, but cant get rid of it.
>>      Also think its a bug in checkpatck.pl
> 
> Please ignore it for now. It would be nice to have a checkpatch.pl fix
> though.
> 
   Ok.
>> 
>>> Any though Andy, Joe, Dwaipayan or Lukas?
> .
