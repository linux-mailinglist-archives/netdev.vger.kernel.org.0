Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA455528CF3
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbiEPS2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344840AbiEPS2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:28:07 -0400
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE34C3DA7C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:28:04 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L276B4yMlzMqDml;
        Mon, 16 May 2022 20:28:02 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L276B1DPCzlhSMS;
        Mon, 16 May 2022 20:28:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652725682;
        bh=grTh156LoOpwtgT4v+e7d4bjWG5VtqWp85aZTKbF2VE=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=DVYfzuNVafKNI3X0EdaV58AGGu40qBjMnjFEtWWSc2SjqUcLWcIZCoMImdhYFaH2j
         +8nBKVAvxxhFU/GKhkMcdeRbM8b9s7kohVjKcMm8P6+L1dBcri5qsG6oWt8B09g8wz
         IGi0isNl0+3y9IcqM56PNyn91NheqQF3w6nCrmCU=
Message-ID: <1aaaf30d-f727-63c4-e5ee-e88ff51af300@digikod.net>
Date:   Mon, 16 May 2022 20:28:01 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-5-konstantin.meskhidze@huawei.com>
 <ce1201e9-8493-8387-9df4-f0f8b75011c9@digikod.net>
 <8c272564-1033-f100-23b6-db6579085fd0@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 04/15] landlock: helper functions refactoring
In-Reply-To: <8c272564-1033-f100-23b6-db6579085fd0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/05/2022 19:43, Konstantin Meskhidze wrote:
> 
> 
> 5/16/2022 8:14 PM, Mickaël Salaün пишет:
>>
>> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>>> Unmask_layers(), init_layer_masks() and
>>> get_handled_accesses() helper functions move to
>>> ruleset.c and rule_type argument is added.
>>> This modification supports implementing new rule
>>> types into next landlock versions.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[...]

>>> -/*
>>> - * @layer_masks is read and may be updated according to the access 
>>> request and
>>> - * the matching rule.
>>> - *
>>> - * Returns true if the request is allowed (i.e. relevant layer masks 
>>> for the
>>> - * request are empty).
>>> - */
>>> -static inline bool
>>> -unmask_layers(const struct landlock_rule *const rule,
>>> -          const access_mask_t access_request,
>>> -          layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>>
>> Moving these entire blocks of code make the review/diff impossible. 
>> Why moving these helpers?
> 
>    Cause these helpers are going to be used both for filesystem and 
> network. I moved them into ruleset.c/h

Right. Please create a commit which only moves these helpers without 
modifying them, and explain in the commit message that this removes 
inlined code. We'll see later if this adds a visible performance impact.

[...]

>>> @@ -519,17 +413,25 @@ static int check_access_path_dual(
>>>
>>>       if (unlikely(dentry_child1)) {
>>>           unmask_layers(find_rule(domain, dentry_child1),
>>> -                  init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>>> -                           &_layer_masks_child1),
>>> -                  &_layer_masks_child1);
>>> +                init_layer_masks(domain,
>>> +                    LANDLOCK_MASK_ACCESS_FS,
>>> +                    &_layer_masks_child1,
>>> +                    sizeof(_layer_masks_child1),
>>> +                    LANDLOCK_RULE_PATH_BENEATH),
>>> +                &_layer_masks_child1,
>>> +                ARRAY_SIZE(_layer_masks_child1));
>>
>> There is a lot of formatting diff and that makes the review difficult. 
>> Please format everything with clang-format-14.
> 
>    Ok. Do you have some tool that helps you with editing code with clang 
> format?

I just run `clang-format-14 -i` on files before each commit. Some 
editors such as VSCode can handle the clang-format configuration (which 
is in the Linux source tree).


>>
>>>           layer_masks_child1 = &_layer_masks_child1;
>>>           child1_is_directory = d_is_dir(dentry_child1);
>>>       }
>>>       if (unlikely(dentry_child2)) {
>>>           unmask_layers(find_rule(domain, dentry_child2),
>>> -                  init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>>> -                           &_layer_masks_child2),
>>> -                  &_layer_masks_child2);
>>> +                init_layer_masks(domain,
>>> +                    LANDLOCK_MASK_ACCESS_FS,
>>> +                    &_layer_masks_child2,
>>> +                    sizeof(_layer_masks_child2),
>>> +                    LANDLOCK_RULE_PATH_BENEATH),
>>> +                &_layer_masks_child2,
>>> +                ARRAY_SIZE(_layer_masks_child2));
>>>           layer_masks_child2 = &_layer_masks_child2;
>>>           child2_is_directory = d_is_dir(dentry_child2);
>>>       }
>>> @@ -582,14 +484,15 @@ static int check_access_path_dual(
>>>
>>>           rule = find_rule(domain, walker_path.dentry);
>>>           allowed_parent1 = unmask_layers(rule, access_masked_parent1,
>>> -                        layer_masks_parent1);
>>> +                layer_masks_parent1,
>>> +                ARRAY_SIZE(*layer_masks_parent1));
>>>           allowed_parent2 = unmask_layers(rule, access_masked_parent2,
>>> -                        layer_masks_parent2);
>>> +                layer_masks_parent2,
>>> +                ARRAY_SIZE(*layer_masks_parent2));
>>>
>>>           /* Stops when a rule from each layer grants access. */
>>>           if (allowed_parent1 && allowed_parent2)
>>>               break;
>>> -
>>
>> There is no place for such formatting/whitespace patches.
>>
>    I missed that. scripts/checkpatch.pl did not show any problem here.

checkpatch.pl doesn't warn about whitespace changes.


>    I will fix it. Thanks.
>>
>>>   jump_up:
>>>           if (walker_path.dentry == walker_path.mnt->mnt_root) {
>>>               if (follow_up(&walker_path)) {
>>> @@ -645,7 +548,9 @@ static inline int check_access_path(const struct 
>>> landlock_ruleset *const domain,
>>>   {
>>>       layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
>>>
>>> -    access_request = init_layer_masks(domain, access_request, 
>>> &layer_masks);
>>> +    access_request = init_layer_masks(domain, access_request,
>>> +            &layer_masks, sizeof(layer_masks),
>>> +            LANDLOCK_RULE_PATH_BENEATH);
>>>       return check_access_path_dual(domain, path, access_request,
>>>                         &layer_masks, NULL, 0, NULL, NULL);
>>>   }
>>> @@ -729,7 +634,8 @@ static bool collect_domain_accesses(
>>>           return true;
>>>
>>>       access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>>> -                      layer_masks_dom);
>>> +            layer_masks_dom, sizeof(*layer_masks_dom),
>>> +            LANDLOCK_RULE_PATH_BENEATH);
>>>
>>>       dget(dir);
>>>       while (true) {
>>> @@ -737,7 +643,8 @@ static bool collect_domain_accesses(
>>>
>>>           /* Gets all layers allowing all domain accesses. */
>>>           if (unmask_layers(find_rule(domain, dir), access_dom,
>>> -                  layer_masks_dom)) {
>>> +                    layer_masks_dom,
>>> +                    ARRAY_SIZE(*layer_masks_dom))) {
>>>               /*
>>>                * Stops when all handled accesses are allowed by at
>>>                * least one rule in each layer.
>>> @@ -851,9 +758,10 @@ static int current_check_refer_path(struct 
>>> dentry *const old_dentry,
>>>            * The LANDLOCK_ACCESS_FS_REFER access right is not required
>>>            * for same-directory referer (i.e. no reparenting).
>>>            */
>>> -        access_request_parent1 = init_layer_masks(
>>> -            dom, access_request_parent1 | access_request_parent2,
>>> -            &layer_masks_parent1);
>>> +        access_request_parent1 = init_layer_masks(dom,
>>> +                access_request_parent1 | access_request_parent2,
>>> +                &layer_masks_parent1, sizeof(layer_masks_parent1),
>>> +                LANDLOCK_RULE_PATH_BENEATH);
>>>           return check_access_path_dual(dom, new_dir,
>>>                             access_request_parent1,
>>>                             &layer_masks_parent1, NULL, 0,
>>> @@ -861,7 +769,9 @@ static int current_check_refer_path(struct dentry 
>>> *const old_dentry,
>>>       }
>>>
>>>       /* Backward compatibility: no reparenting support. */
>>> -    if (!(get_handled_accesses(dom) & LANDLOCK_ACCESS_FS_REFER))
>>> +    if (!(get_handled_accesses(dom, LANDLOCK_RULE_PATH_BENEATH,
>>> +                   LANDLOCK_NUM_ACCESS_FS) &
>>> +                        LANDLOCK_ACCESS_FS_REFER))
>>>           return -EXDEV;
>>>
>>>       access_request_parent1 |= LANDLOCK_ACCESS_FS_REFER;
>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index 4b4c9953bb32..c4ed783d655b 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -233,7 +233,8 @@ static int insert_rule(struct landlock_ruleset 
>>> *const ruleset,
>>>                              &(*layers)[0]);
>>>               if (IS_ERR(new_rule))
>>>                   return PTR_ERR(new_rule);
>>> -            rb_replace_node(&this->node, &new_rule->node, 
>>> &ruleset->root_inode);
>>> +            rb_replace_node(&this->node, &new_rule->node,
>>> +                    &ruleset->root_inode);
>>
>> This is a pure formatting hunk. :/
>>
>    Thats strange, cause in my editor I have normal aligment of arguments.
>    Could please share clang-format-14 tab size and other format     
> parameters?

They are in the .clang-format file. It would be much easier to just run 
clang-format-14 -i on your changed files. I guess you had different 
changes between consecutive commits.
