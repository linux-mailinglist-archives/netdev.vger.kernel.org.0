Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980344DCD24
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbiCQSEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiCQSEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:04:34 -0400
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [IPv6:2001:1600:4:17::190e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06413EE4CD;
        Thu, 17 Mar 2022 11:03:15 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KKFPF37jZzMpy1c;
        Thu, 17 Mar 2022 19:03:13 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KKFPD5nW5zljsTW;
        Thu, 17 Mar 2022 19:03:12 +0100 (CET)
Message-ID: <88eacf2d-357b-f986-5cb6-88f276432602@digikod.net>
Date:   Thu, 17 Mar 2022 19:03:57 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-3-konstantin.meskhidze@huawei.com>
 <a28c8bec-3671-2613-9107-2b911305c274@digikod.net>
 <fb652db3-6a1f-ca36-cb89-04c8b8daa938@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 02/15] landlock: filesystem access mask helpers
In-Reply-To: <fb652db3-6a1f-ca36-cb89-04c8b8daa938@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/03/2022 14:25, Konstantin Meskhidze wrote:
> 
> 
> 3/15/2022 8:48 PM, Mickaël Salaün пишет:

…

>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index 78341a0538de..a6212b752549 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -44,16 +44,30 @@ static struct landlock_ruleset 
>>> *create_ruleset(const u32 num_layers)
>>>       return new_ruleset;
>>>   }
>>>
>>> -struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask)
>>> +/* A helper function to set a filesystem mask */
>>> +void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
>>
>> struct landlock_ruleset *const ruleset
>>
>> Please use const as much as possible even in function arguments: e.g. 
>> access_masks_set, mask_level…
>>
>>> +                 const struct landlock_access_mask *access_mask_set,
> 
>   Ok. Got it.
>>
>> nit: no need for "_set" suffix.
> 
>   Ok. Thanks
>>
>> Why do you need a struct landlock_access_mask and not just u16 (which 
>> will probably become a subset of access_mask_t, see [1])? 
>> landlock_create_ruleset() could just take two masks as argument instead.
>>
>> [1] https://lore.kernel.org/all/20220221212522.320243-2-mic@digikod.net/
> 
>    This was your suggestion in previous patch V3:
> 
>    " To make it easier and avoid mistakes, you could use a dedicated
>     struct to properly manage masks passing and conversions:
>    struct landlock_access_mask {
>      u16 fs; // TODO: make sure at build-time that all access rights
>                     fit in.
>      u16 net; // TODO: ditto for network access rights.
>    }
> 
>    get_access_masks(const struct landlock_ruleset *, struct
>    landlock_access_mask *);
>    set_access_masks(struct landlock_ruleset *, const struct
>    landlock_access_mask *);
> 
>    This should also be part of a standalone patch."
> 
> 
> https://lore.kernel.org/linux-security-module/ed2bd420-a22b-2912-1ff5-f48ab352d8e7@digikod.net/ 

Indeed! What is nice about struct is that it enables to easily 
differentiate same-type values (e.g. fs mask from net mask). However, 
because this struct is mainly passed once to initialize a ruleset, it 
looks like this was not worth it. Please get back to how you dealt with 
that previously but with a new access_mask_t typedef, which will 
conflict with my latest patchset but that will be trivial to fix. You 
can also merge the landlock_set_*_access_mask() into 
landlock_create_ruleset() because they are not use elsewhere (and then 
it would have been much less useful to have a dedicated struct).


> 
> 
>>
>>> +                 u16 mask_level)
>>> +{
>>> +    ruleset->access_masks[mask_level] = access_mask_set->fs;
>>> +}
>>> +
>>> +/* A helper function to get a filesystem mask */
>>> +u32 landlock_get_fs_access_mask(const struct landlock_ruleset 
>>> *ruleset, u16 mask_level)
>>> +{
>>> +    return ruleset->access_masks[mask_level];
>>> +}
>>
>> You can move these two helpers to ruleset.h and make them static inline.
> 
>    Ok. I got it.
>>
>>> +
>>> +struct landlock_ruleset *landlock_create_ruleset(const struct 
>>> landlock_access_mask *access_mask_set)
>>>   {
>>>       struct landlock_ruleset *new_ruleset;
>>>
>>>       /* Informs about useless ruleset. */
>>> -    if (!access_mask)
>>> +    if (!access_mask_set->fs)
>>>           return ERR_PTR(-ENOMSG);
>>>       new_ruleset = create_ruleset(1);
>>>       if (!IS_ERR(new_ruleset))
>>> -        new_ruleset->access_masks[0] = access_mask;
>>> +        landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
>>>       return new_ruleset;
>>>   }
>>>
>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index 32d90ce72428..bc87e5f787f7 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -16,6 +16,16 @@
>>>
>>>   #include "object.h"
>>>
>>> +/**
>>> + * struct landlock_access_mask - A helper structure to handle 
>>> different mask types
>>> + */
>>> +struct landlock_access_mask {
>>> +    /**
>>> +     * @fs: Filesystem access mask.
>>> +     */
>>> +    u16 fs;
>>> +};
>>
>> Removing this struct would simplify the code.
> 
>    I followed your recommendation to use such kind of structure.
>    Please check previous patch V3 review:
> 
> 
> https://lore.kernel.org/linux-security-module/ed2bd420-a22b-2912-1ff5-f48ab352d8e7@digikod.net/ 
> 
> 
>>
>>> +
>>>   /**
>>>    * struct landlock_layer - Access rights for a given layer
>>>    */
>>> @@ -140,7 +150,8 @@ struct landlock_ruleset {
>>>       };
>>>   };
>>>
>>> -struct landlock_ruleset *landlock_create_ruleset(const u32 
>>> access_mask);
>>> +struct landlock_ruleset *landlock_create_ruleset(const struct 
>>> landlock_access_mask
>>> +                                    *access_mask_set);
>>>
>>>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const 
>>> ruleset);
>>> @@ -162,4 +173,10 @@ static inline void landlock_get_ruleset(struct 
>>> landlock_ruleset *const ruleset)
>>>           refcount_inc(&ruleset->usage);
>>>   }
>>>
>>> +void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
>>> +                 const struct landlock_access_mask *access_mask_set,
>>> +                 u16 mask_level);
>>> +
>>> +u32 landlock_get_fs_access_mask(const struct landlock_ruleset 
>>> *ruleset, u16 mask_level);
>>> +
>>>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
>>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>>> index f1d86311df7e..5931b666321d 100644
>>> --- a/security/landlock/syscalls.c
>>> +++ b/security/landlock/syscalls.c
>>> @@ -159,6 +159,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>>   {
>>>       struct landlock_ruleset_attr ruleset_attr;
>>>       struct landlock_ruleset *ruleset;
>>> +    struct landlock_access_mask access_mask_set = {.fs = 0};
>>>       int err, ruleset_fd;
>>>
>>>       /* Build-time checks. */
>>> @@ -185,9 +186,10 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>>       if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>>>               LANDLOCK_MASK_ACCESS_FS)
>>>           return -EINVAL;
>>> +    access_mask_set.fs = ruleset_attr.handled_access_fs;
>>>
>>>       /* Checks arguments and transforms to kernel struct. */
>>> -    ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
>>> +    ruleset = landlock_create_ruleset(&access_mask_set);
>>>       if (IS_ERR(ruleset))
>>>           return PTR_ERR(ruleset);
>>>
>>> @@ -343,8 +345,9 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>        * Checks that allowed_access matches the @ruleset constraints
>>>        * (ruleset->access_masks[0] is automatically upgraded to 
>>> 64-bits).
>>>        */
>>> -    if ((path_beneath_attr.allowed_access | 
>>> ruleset->access_masks[0]) !=
>>> -            ruleset->access_masks[0]) {
>>> +
>>> +    if ((path_beneath_attr.allowed_access | 
>>> landlock_get_fs_access_mask(ruleset, 0)) !=
>>> +                        landlock_get_fs_access_mask(ruleset, 0)) {
>>>           err = -EINVAL;
>>>           goto out_put_ruleset;
>>>       }
>>> -- 
>>> 2.25.1
>>>
>> .
