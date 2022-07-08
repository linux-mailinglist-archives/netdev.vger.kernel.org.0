Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8DB56BF5C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbiGHQ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbiGHQ5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:57:38 -0400
X-Greylist: delayed 87160 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Jul 2022 09:57:36 PDT
Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [83.166.143.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746E83BB
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:57:36 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LffbL5D3lzMqD8M;
        Fri,  8 Jul 2022 18:57:34 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4LffbL1vMvzln2G9;
        Fri,  8 Jul 2022 18:57:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1657299454;
        bh=Qw59FDtqD8nojf3FMAqraBM3XJAAKEP12B6NgU6LwV0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=abGlx7afXg/wnMLIZHV5t3pl7hnInDLDh4DdVRWVWDMDYmIuPtyb1vk8H7jTXVEv3
         VYDxCTNkJNjBQ13O97YLbRpKyRI4l0mOj5CxBXc2SghLLNkCx5HLvrLT6VqXG5rrOQ
         No9aHJq0WIln/xd3OPnSrdM47V/vgcdN5Kd0DL6s=
Message-ID: <7d72fc3e-bdeb-14b8-1e6c-a99c2d052e3f@digikod.net>
Date:   Fri, 8 Jul 2022 18:57:33 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
 <0bbbcf21-1e7d-5585-545f-bf89d8ebd527@digikod.net>
 <9d0c8780-6648-404f-7e51-b62a36617121@huawei.com>
 <72375435-94d4-e3aa-c27b-b44382dde6ad@digikod.net>
 <76c7c92e-3377-0bb8-14d5-e5c286c67dc3@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
In-Reply-To: <76c7c92e-3377-0bb8-14d5-e5c286c67dc3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/07/2022 16:20, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/8/2022 4:56 PM, Mickaël Salaün пишет:
>>
>> On 08/07/2022 14:53, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 7/7/2022 7:44 PM, Mickaël Salaün пишет:
>>>>
>>>> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>>>>> Adds a new object union to support a socket port
>>>>> rule type. Refactors landlock_insert_rule() and
>>>>> landlock_find_rule() to support coming network
>>>>> modifications. Now adding or searching a rule
>>>>> in a ruleset depends on a rule_type argument
>>>>> provided in refactored functions mentioned above.
>>>>>
>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>> ---
>>>>>
>>>>> Changes since v5:
>>>>> * Formats code with clang-format-14.
>>>>>
>>>>> Changes since v4:
>>>>> * Refactors insert_rule() and create_rule() functions by deleting
>>>>> rule_type from their arguments list, it helps to reduce useless code.
>>>>>
>>>>> Changes since v3:
>>>>> * Splits commit.
>>>>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>>>>> * Rename new_ruleset->root_inode.
>>>>>
>>>>> ---
>>>>>   security/landlock/fs.c      |   7 ++-
>>>>>   security/landlock/ruleset.c | 105 
>>>>> ++++++++++++++++++++++++++----------
>>>>>   security/landlock/ruleset.h |  27 +++++-----
>>>>>   3 files changed, 96 insertions(+), 43 deletions(-)
>>>>>
>>>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>>>> index e6da08ed99d1..46aedc2a05a8 100644
>>>>> --- a/security/landlock/fs.c
>>>>> +++ b/security/landlock/fs.c
>>>>> @@ -173,7 +173,8 @@ int landlock_append_fs_rule(struct 
>>>>> landlock_ruleset *const ruleset,
>>>>>       if (IS_ERR(object))
>>>>>           return PTR_ERR(object);
>>>>>       mutex_lock(&ruleset->lock);
>>>>> -    err = landlock_insert_rule(ruleset, object, access_rights);
>>>>> +    err = landlock_insert_rule(ruleset, object, 0, access_rights,
>>>>> +                   LANDLOCK_RULE_PATH_BENEATH);
>>>>>       mutex_unlock(&ruleset->lock);
>>>>>       /*
>>>>>        * No need to check for an error because landlock_insert_rule()
>>>>> @@ -204,7 +205,9 @@ find_rule(const struct landlock_ruleset *const 
>>>>> domain,
>>>>>       inode = d_backing_inode(dentry);
>>>>>       rcu_read_lock();
>>>>>       rule = landlock_find_rule(
>>>>> -        domain, rcu_dereference(landlock_inode(inode)->object));
>>>>> +        domain,
>>>>> +        (uintptr_t)rcu_dereference(landlock_inode(inode)->object),
>>>>> +        LANDLOCK_RULE_PATH_BENEATH);
>>>>>       rcu_read_unlock();
>>>>>       return rule;
>>>>>   }
>>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>>> index a3fd58d01f09..5f13f8a12aee 100644
>>>>> --- a/security/landlock/ruleset.c
>>>>> +++ b/security/landlock/ruleset.c
>>>>> @@ -35,7 +35,7 @@ static struct landlock_ruleset 
>>>>> *create_ruleset(const u32 num_layers)
>>>>>           return ERR_PTR(-ENOMEM);
>>>>>       refcount_set(&new_ruleset->usage, 1);
>>>>>       mutex_init(&new_ruleset->lock);
>>>>> -    new_ruleset->root = RB_ROOT;
>>>>> +    new_ruleset->root_inode = RB_ROOT;
>>>>>       new_ruleset->num_layers = num_layers;
>>>>>       /*
>>>>>        * hierarchy = NULL
>>>>> @@ -69,7 +69,8 @@ static void build_check_rule(void)
>>>>>   }
>>>>>
>>>>>   static struct landlock_rule *
>>>>> -create_rule(struct landlock_object *const object,
>>>>> +create_rule(struct landlock_object *const object_ptr,
>>>>> +        const uintptr_t object_data,
>>>>>           const struct landlock_layer (*const layers)[], const u32 
>>>>> num_layers,
>>>>>           const struct landlock_layer *const new_layer)
>>>>>   {
>>>>> @@ -90,8 +91,15 @@ create_rule(struct landlock_object *const object,
>>>>>       if (!new_rule)
>>>>>           return ERR_PTR(-ENOMEM);
>>>>>       RB_CLEAR_NODE(&new_rule->node);
>>>>> -    landlock_get_object(object);
>>>>> -    new_rule->object = object;
>>>>> +
>>>>> +    if (object_ptr) {
>>>>> +        landlock_get_object(object_ptr);
>>>>> +        new_rule->object.ptr = object_ptr;
>>>>> +    } else if (object_ptr && object_data) {
>>>>
>>>> Something is wrong with this second check: else + object_ptr?
>>>
>>> It was your suggestion to use it like this:
>>> " ....You can also add a WARN_ON_ONCE(object_ptr && object_data)."
>>>
>>> Please check it here:
>>> https://lore.kernel.org/linux-security-module/bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net/ 
>>
>>
>> Yes, but the error is in the "else", you should write:
>> if (WARN_ON_ONCE(object_ptr && object_data))
>>     return ERR_PTR(-EINVAL);
>>
>> …and this should be before the `if (object_ptr) {` line (to avoid
>> erronous landlock_get_object() call), just after the `if (!new_rule)` 
>> check.
> 
>    Maybe we could delete this check here cause we have it in the upper 
> insert_rule() function??
> 
> ...
>      if (WARN_ON_ONCE(!layers))
>          return -ENOENT;
> ------>    if (WARN_ON_ONCE(object_ptr && object_data))
>          return -EINVAL;
>      /* Chooses rb_tree structure depending on a rule type. */
>      switch (rule_type) {
>      case LANDLOCK_RULE_PATH_BENEATH:
>          if (WARN_ON_ONCE(!object_ptr))
>              return -ENOENT;
>          object_data = (uintptr_t)object_ptr;
>          root = &ruleset->root_inode;
>          break;
>      default:
>          WARN_ON_ONCE(1);
>          return -EINVAL;
>      }
> ...
> 
> This is double check here. What do you think?

This check is indeed done twice, and for now create_rule() is only 
called from insert_rule(), but I prefer to keep it in both location to 
not get bitten in the future were it could be called from other 
locations. The compiler may be smart enough to remove the redundant 
checks though.

I'll send a patch to improve this part.
