Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9507863B30D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiK1UZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiK1UZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:25:53 -0500
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CEB2A707
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:25:51 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NLcRb6nyrzMqLkN;
        Mon, 28 Nov 2022 21:25:47 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NLcRZ6fYXzx9;
        Mon, 28 Nov 2022 21:25:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669667147;
        bh=D7bLJ0U4Ir+GtOteiL7WJ9iP01jMHEse/a/RWcN3D8g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YhIvj16zQYyZj5BYXUxDqZah2erXBKnpPqcJIytO1dorw3gaPVbE4G79DJ5QIDAIc
         Mf9OaHThmSoibNfi+ji96jjPnJxyHgou+qIc0Z5NeZaruRa1g5FO9OAImnf65z3bDl
         URf5BKActhHUZYHp1WwSF88e/xTnrjn58sE4vZlY=
Message-ID: <2ba68e9d-445d-78d4-bc3c-a12b29f9d63d@digikod.net>
Date:   Mon, 28 Nov 2022 21:25:46 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 04/12] landlock: Move unmask_layers() and
 init_layer_masks()
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-5-konstantin.meskhidze@huawei.com>
 <aed09115-cfd8-1986-a848-bb33d2743def@digikod.net>
 <8542aa54-4d74-8b56-8dc4-ee619d66c7bf@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <8542aa54-4d74-8b56-8dc4-ee619d66c7bf@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/11/2022 04:25, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:42 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> This patch moves unmask_layers() and init_layer_masks() helpers
>>> to ruleset.c to share with landlock network implementation in
>>
>> …to share them with the Landlock network implementation in
>>
>      Got it.
>>
>>> following commits.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---

[...]

>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index 608ab356bc3e..50baff4fcbb4 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -34,6 +34,16 @@ typedef u16 layer_mask_t;
>>>    /* Makes sure all layers can be checked. */
>>>    static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
>>>
>>> +/*
>>> + * All access rights that are denied by default whether they are handled or not
>>> + * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
>>> + * entries when we need to get the absolute handled access masks.
>>> + */
>>> +/* clang-format off */
>>> +#define ACCESS_INITIALLY_DENIED ( \
>>> +	LANDLOCK_ACCESS_FS_REFER)
>>> +/* clang-format on */
>>
>> This ACCESS_INITIALLY_DENIED definition must be moved, not copied. You
>> can rename ACCESS_INITIALLY_DENIED to ACCESS_FS_INITIALLY_DENIED and
>> move this hunk before the access_mask_t definition.
>>
>     Yep. Will be fixed.
>>
>>> +
>>>    /**
>>>     * struct landlock_layer - Access rights for a given layer
>>>     */
>>> @@ -246,4 +256,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>>    		LANDLOCK_SHIFT_ACCESS_FS) &
>>>    	       LANDLOCK_MASK_ACCESS_FS;
>>>    }
>>> +
>>> +bool unmask_layers(const struct landlock_rule *const rule,
>>
>> All public Landlock helpers must be prefixed with "landlock_"
> 
>     Do you mean ones which are shared between fs and net parts?

All helpers that ends up in the exported ELF symbols, so all implemented 
in the .c files with their signature defined in .h files. The static 
inlined .h helpers don't need to have such prefix if there is no conflict.


>>
>>> +		   const access_mask_t access_request,
>>> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>> +
>>> +access_mask_t
>>> +init_layer_masks(const struct landlock_ruleset *const domain,
>>> +		 const access_mask_t access_request,
>>> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>
>> There is a warning generated by checkpatch.pl about this line:
>>      WARNING: function definition argument 'layer_mask_t' should also have
>> an identifier name
>>
>> I think this is a bug in checkpatch.pl
>>
>      I got this warn, but cant get rid of it.
>      Also think its a bug in checkpatck.pl

Please ignore it for now. It would be nice to have a checkpatch.pl fix 
though.

> 
>> Any though Andy, Joe, Dwaipayan or Lukas?
