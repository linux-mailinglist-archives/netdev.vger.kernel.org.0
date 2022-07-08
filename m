Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8262356BBD2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiGHOfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237949AbiGHOfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:35:18 -0400
Received: from smtp-190a.mail.infomaniak.ch (smtp-190a.mail.infomaniak.ch [IPv6:2001:1600:4:17::190a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A806C23BC9
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 07:35:16 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LfbR64W5vzMqGl5;
        Fri,  8 Jul 2022 16:35:14 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LfbR60rHQzlqQHp;
        Fri,  8 Jul 2022 16:35:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1657290914;
        bh=14Y01chD+nYI5x3F7IgyBm80hM86Uq1a4e496lKp1xg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=NZqCZiSY6JTk9RUHjIk9mjBsldOyl+u0R60qcDipVX4+1xGdqUjn0Ff+Xat6ZX+GP
         siDNpPMPlQUK8RNDI8loVnGB2/L8u1IiTodcP4njrIhelAU9JsffKQUlDvYZqoUlEt
         ZJbJ6yWqHT9u/5T7IwH8XChjvQ/CjAEXKKY1dZao=
Message-ID: <582f8ace-1f95-16a6-fa9e-4014ddd8b7f2@digikod.net>
Date:   Fri, 8 Jul 2022 16:35:12 +0200
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
 <7735ae47-9088-be29-2696-c5170031d7c2@huawei.com>
 <b08fe5cc-3be0-390b-3575-4f27f795f609@digikod.net>
 <6ee7e769-ce91-a6cc-378b-f206e04d112a@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
In-Reply-To: <6ee7e769-ce91-a6cc-378b-f206e04d112a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/07/2022 16:14, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/8/2022 4:59 PM, Mickaël Salaün пишет:
>>
>> On 08/07/2022 15:10, Konstantin Meskhidze (A) wrote:
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
>>>   Sorry. Do you mean logical error here? I got your point.
>>>   You are right!
>>>
>>>   I think it must be refactored like this:
>>>
>>>      if (object_ptr && !object_data) {
>>>          landlock_get_object(object_ptr);
>>>          new_rule->object.ptr = object_ptr;
>>>      } else if (object_ptr && object_data) {
>>>          ...
>>>      }
>>
>> There is indeed a logical error but this doesn't fix everything. Please
>> include my previous suggestion instead.
>>
>     By the way, in the next commits I have fixed this logic error.
> Anyway I will refactor this one also. Thanks.
>>
>>> Plus, I will add a test for this case.
>>
>> That would be great but I don't think this code is reachable from user
>> space. I think that would require kunit but I may be missing something.
>> How would you test this?
> 
> You are correct. I checked it. It's impossible to reach this line from 
> userpace (insert both object_ptr and object_data). But create_rule() 
> must be used carefuly by other developers (if any in future). Do you 
> think if its possible to have some internal kernel tests that could 
> handle this issue?

We can use kunit tests for such kernel functions, but in this case I'm 
not sure what could be tested. I started working on bringing kunit tests 
to Landlock but it's not ready yet. Please list all non-userspace tests 
you can think about.
