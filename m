Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF38056D794
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGKIQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKIQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:16:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752B61D32B;
        Mon, 11 Jul 2022 01:16:41 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LhGnv6hPCz67xNM;
        Mon, 11 Jul 2022 16:12:19 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 10:16:39 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 09:16:38 +0100
Message-ID: <88cd33f2-8c6c-bfff-7271-7508b1ebac17@huawei.com>
Date:   Mon, 11 Jul 2022 11:16:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
 <0bbbcf21-1e7d-5585-545f-bf89d8ebd527@digikod.net>
 <9d0c8780-6648-404f-7e51-b62a36617121@huawei.com>
 <72375435-94d4-e3aa-c27b-b44382dde6ad@digikod.net>
 <76c7c92e-3377-0bb8-14d5-e5c286c67dc3@huawei.com>
 <7d72fc3e-bdeb-14b8-1e6c-a99c2d052e3f@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <7d72fc3e-bdeb-14b8-1e6c-a99c2d052e3f@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/8/2022 7:57 PM, Mickaël Salaün пишет:
> 
> On 08/07/2022 16:20, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 7/8/2022 4:56 PM, Mickaël Salaün пишет:
>>>
>>> On 08/07/2022 14:53, Konstantin Meskhidze (A) wrote:
>>>>
>>>>
>>>> 7/7/2022 7:44 PM, Mickaël Salaün пишет:
>>>>>
>>>>> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>>>>>> Adds a new object union to support a socket port
>>>>>> rule type. Refactors landlock_insert_rule() and
>>>>>> landlock_find_rule() to support coming network
>>>>>> modifications. Now adding or searching a rule
>>>>>> in a ruleset depends on a rule_type argument
>>>>>> provided in refactored functions mentioned above.
>>>>>>
>>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>>> ---
>>>>>>
>>>>>> Changes since v5:
>>>>>> * Formats code with clang-format-14.
>>>>>>
>>>>>> Changes since v4:
>>>>>> * Refactors insert_rule() and create_rule() functions by deleting
>>>>>> rule_type from their arguments list, it helps to reduce useless code.
>>>>>>
>>>>>> Changes since v3:
>>>>>> * Splits commit.
>>>>>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>>>>>> * Rename new_ruleset->root_inode.
>>>>>>
>>>>>> ---
>>>>>>   security/landlock/fs.c      |   7 ++-
>>>>>>   security/landlock/ruleset.c | 105 
>>>>>> ++++++++++++++++++++++++++----------
>>>>>>   security/landlock/ruleset.h |  27 +++++-----
>>>>>>   3 files changed, 96 insertions(+), 43 deletions(-)
>>>>>>
>>>>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>>>>> index e6da08ed99d1..46aedc2a05a8 100644
>>>>>> --- a/security/landlock/fs.c
>>>>>> +++ b/security/landlock/fs.c
>>>>>> @@ -173,7 +173,8 @@ int landlock_append_fs_rule(struct 
>>>>>> landlock_ruleset *const ruleset,
>>>>>>       if (IS_ERR(object))
>>>>>>           return PTR_ERR(object);
>>>>>>       mutex_lock(&ruleset->lock);
>>>>>> -    err = landlock_insert_rule(ruleset, object, access_rights);
>>>>>> +    err = landlock_insert_rule(ruleset, object, 0, access_rights,
>>>>>> +                   LANDLOCK_RULE_PATH_BENEATH);
>>>>>>       mutex_unlock(&ruleset->lock);
>>>>>>       /*
>>>>>>        * No need to check for an error because landlock_insert_rule()
>>>>>> @@ -204,7 +205,9 @@ find_rule(const struct landlock_ruleset *const 
>>>>>> domain,
>>>>>>       inode = d_backing_inode(dentry);
>>>>>>       rcu_read_lock();
>>>>>>       rule = landlock_find_rule(
>>>>>> -        domain, rcu_dereference(landlock_inode(inode)->object));
>>>>>> +        domain,
>>>>>> +        (uintptr_t)rcu_dereference(landlock_inode(inode)->object),
>>>>>> +        LANDLOCK_RULE_PATH_BENEATH);
>>>>>>       rcu_read_unlock();
>>>>>>       return rule;
>>>>>>   }
>>>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>>>> index a3fd58d01f09..5f13f8a12aee 100644
>>>>>> --- a/security/landlock/ruleset.c
>>>>>> +++ b/security/landlock/ruleset.c
>>>>>> @@ -35,7 +35,7 @@ static struct landlock_ruleset 
>>>>>> *create_ruleset(const u32 num_layers)
>>>>>>           return ERR_PTR(-ENOMEM);
>>>>>>       refcount_set(&new_ruleset->usage, 1);
>>>>>>       mutex_init(&new_ruleset->lock);
>>>>>> -    new_ruleset->root = RB_ROOT;
>>>>>> +    new_ruleset->root_inode = RB_ROOT;
>>>>>>       new_ruleset->num_layers = num_layers;
>>>>>>       /*
>>>>>>        * hierarchy = NULL
>>>>>> @@ -69,7 +69,8 @@ static void build_check_rule(void)
>>>>>>   }
>>>>>>
>>>>>>   static struct landlock_rule *
>>>>>> -create_rule(struct landlock_object *const object,
>>>>>> +create_rule(struct landlock_object *const object_ptr,
>>>>>> +        const uintptr_t object_data,
>>>>>>           const struct landlock_layer (*const layers)[], const u32 
>>>>>> num_layers,
>>>>>>           const struct landlock_layer *const new_layer)
>>>>>>   {
>>>>>> @@ -90,8 +91,15 @@ create_rule(struct landlock_object *const object,
>>>>>>       if (!new_rule)
>>>>>>           return ERR_PTR(-ENOMEM);
>>>>>>       RB_CLEAR_NODE(&new_rule->node);
>>>>>> -    landlock_get_object(object);
>>>>>> -    new_rule->object = object;
>>>>>> +
>>>>>> +    if (object_ptr) {
>>>>>> +        landlock_get_object(object_ptr);
>>>>>> +        new_rule->object.ptr = object_ptr;
>>>>>> +    } else if (object_ptr && object_data) {
>>>>>
>>>>> Something is wrong with this second check: else + object_ptr?
>>>>
>>>> It was your suggestion to use it like this:
>>>> " ....You can also add a WARN_ON_ONCE(object_ptr && object_data)."
>>>>
>>>> Please check it here:
>>>> https://lore.kernel.org/linux-security-module/bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net/ 
>>>
>>>
>>> Yes, but the error is in the "else", you should write:
>>> if (WARN_ON_ONCE(object_ptr && object_data))
>>>     return ERR_PTR(-EINVAL);
>>>
>>> …and this should be before the `if (object_ptr) {` line (to avoid
>>> erronous landlock_get_object() call), just after the `if (!new_rule)` 
>>> check.

     Ok. I got it.
>> 
>>    Maybe we could delete this check here cause we have it in the upper 
>> insert_rule() function??
>> 
>> ...
>>      if (WARN_ON_ONCE(!layers))
>>          return -ENOENT;
>> ------>    if (WARN_ON_ONCE(object_ptr && object_data))
>>          return -EINVAL;
>>      /* Chooses rb_tree structure depending on a rule type. */
>>      switch (rule_type) {
>>      case LANDLOCK_RULE_PATH_BENEATH:
>>          if (WARN_ON_ONCE(!object_ptr))
>>              return -ENOENT;
>>          object_data = (uintptr_t)object_ptr;
>>          root = &ruleset->root_inode;
>>          break;
>>      default:
>>          WARN_ON_ONCE(1);
>>          return -EINVAL;
>>      }
>> ...
>> 
>> This is double check here. What do you think?
> 
> This check is indeed done twice, and for now create_rule() is only
> called from insert_rule(), but I prefer to keep it in both location to
> not get bitten in the future were it could be called from other
> locations. The compiler may be smart enough to remove the redundant
> checks though.
> 
> I'll send a patch to improve this part.

  Ok. thanks!!!
> .
