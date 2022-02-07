Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97D64AC165
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiBGOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383576AbiBGOQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:16:52 -0500
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37A2C0401C3
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:16:50 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Jsp9W3RBFzMqFhp;
        Mon,  7 Feb 2022 15:16:47 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Jsp9W0TVszljsTJ;
        Mon,  7 Feb 2022 15:16:47 +0100 (CET)
Message-ID: <10999c72-93eb-4db2-e536-a92187545bdb@digikod.net>
Date:   Mon, 7 Feb 2022 15:17:27 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <ed2bd420-a22b-2912-1ff5-f48ab352d8e7@digikod.net>
 <5cd5b983-32a5-97ec-0835-f0c96d86e805@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
In-Reply-To: <5cd5b983-32a5-97ec-0835-f0c96d86e805@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/02/2022 14:09, Konstantin Meskhidze wrote:
> 
> 
> 2/1/2022 3:13 PM, Mickaël Salaün пишет:
>>
>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>> Support of socket_bind() and socket_connect() hooks.
>>> Current prototype can restrict binding and connecting of TCP
>>> types of sockets. Its just basic idea how Landlock could support
>>> network confinement.
>>>
>>> Changes:
>>> 1. Access masks array refactored into 1D one and changed
>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>>> masks reside in 16 upper bits.
>>> 2. Refactor API functions in ruleset.c:
>>>      1. Add void *object argument.
>>>      2. Add u16 rule_type argument.
>>> 3. Use two rb_trees in ruleset structure:
>>>      1. root_inode - for filesystem objects
>>>      2. root_net_port - for network port objects
>>
>> It's good to add a changelog, but they must not be in commit messages 
>> that get copied by git am. Please use "---" to separate this 
>> additionnal info (but not the Signed-off-by). Please also include a 
>> version in the email subjects (this one should have been "[RFC PATCH 
>> v3 1/2] landlock: …"), e.g. using git format-patch --reroll-count=X .
>>
>> Please follow these rules: 
>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>> You can take some inspiration from this patch series: 
>> https://lore.kernel.org/lkml/20210422154123.13086-1-mic@digikod.net/
> 
>   Ok. I will add patch vervison in next patch. So it will be "[RFC PATCH
>   v4 ../..] landlock: ..."
>   But the previous patches remain with no version, correct?

Right, you can't change the subject of already sent emails. ;)

[...]

>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>> new file mode 100644
>>> index 000000000000..0b5323d254a7
>>> --- /dev/null
>>> +++ b/security/landlock/net.c
>>> @@ -0,0 +1,175 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Landlock LSM - Filesystem management and hooks
>>> + *
>>> + * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
>>> + * Copyright © 2018-2020 ANSSI
>>> + */
>>> +
>>> +#include <linux/socket.h>
>>> +#include <linux/net.h>
>>> +#include <linux/in.h>
>>
>> Why is linux/in.h required?
>>
>    Struct sockaddr_in is described in this header.
>    A pointer to struct sockaddr_in is used in hook_socket_connect()
>    and hook_socket_bind() to get socket's family and port values.

OK, good point.

[...]

>>> +        return 0;
>>> +
>>> +    socket_type = sock->type;
>>> +    /* Check if it's a TCP socket */
>>> +    if (socket_type != SOCK_STREAM)
>>> +        return 0;
>>> +
>>> +    if (!dom)
>>> +        return 0;
>>
>> This must be at the top of *each* hook to make it clear that they 
>> don't impact non-landlocked processes.
>>
>    They don't impact. It does not matter what to check first socket
>    family/type or landlocked process.

It doesn't change the semantic but it changes the reviewing which is 
easier with common and consistent sequential checks (and could avoid 
future mistakes). This rule is followed by all Landlock hooks.

[...]

>>> @@ -67,10 +76,11 @@ static void build_check_rule(void)
>>>   }
>>>   static struct landlock_rule *create_rule(
>>> -        struct landlock_object *const object,
>>> +        void *const object,
>>
>> Instead of shoehorning two different types into one (and then loosing 
>> the typing), you should rename object to object_ptr and add a new 
>> object_data argument. Only one of these should be set according to the 
>> rule_type. However, if there is no special action performed on one of 
>> these type (e.g. landlock_get_object), only one uintptr_t argument 
>> should be enough.
>>
>   Do you mean using 2 object arguments in create_rule():
> 
>      1. create_rule( object_ptr = landlock_object , object_data = 0,
>                                 ...,  fs_rule_type);
>          2. create_rule( object_ptr = NULL , object_data = port, .... ,
>                           net_rule_type);

Yes, and you can add a WARN_ON_ONCE() in these function to check that 
only one argument is set (but object_data could be 0 in each case). The 
landlock_get_object() function should only require an object_data though.

[...]

>>> @@ -142,26 +159,36 @@ static void build_check_ruleset(void)
>>>    * access rights.
>>>    */
>>>   static int insert_rule(struct landlock_ruleset *const ruleset,
>>> -        struct landlock_object *const object,
>>> -        const struct landlock_layer (*const layers)[],
>>> -        size_t num_layers)
>>> +        void *const obj, const struct landlock_layer (*const layers)[],
>>
>> same here
>       Do you mean using 2 object arguments in insert_rule():
> 
>      1. insert_rule( object_ptr = landlock_object , object_data = 0,
>                                 ...,  fs_rule_type);
>          2. insert_rule( object_ptr = NULL , object_data = port, .... ,
>                           net_rule_type);

Yes

[...]

>>> @@ -336,9 +399,11 @@ static int inherit_ruleset(struct 
>>> landlock_ruleset *const parent,
>>>           err = -EINVAL;
>>>           goto out_unlock;
>>>       }
>>> -    /* Copies the parent layer stack and leaves a space for the new 
>>> layer. */
>>> -    memcpy(child->fs_access_masks, parent->fs_access_masks,
>>> -            flex_array_size(parent, fs_access_masks, 
>>> parent->num_layers));
>>> +    /* Copies the parent layer stack and leaves a space for the new 
>>> layer.
>>
>> ditto
>        Do you mean comments style here?

Yes

[...]

>>> @@ -317,47 +331,91 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>       if (flags)
>>>           return -EINVAL;
>>> -    if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
>>> +    if ((rule_type != LANDLOCK_RULE_PATH_BENEATH) &&
>>> +        (rule_type != LANDLOCK_RULE_NET_SERVICE))
>>
>> Please replace with a switch/case.
> 
>    Ok. I got it.
>>
>>
>>>           return -EINVAL;
>>> -    /* Copies raw user space buffer, only one type for now. */
>>> -    res = copy_from_user(&path_beneath_attr, rule_attr,
>>> -            sizeof(path_beneath_attr));
>>> -    if (res)
>>> -        return -EFAULT;
>>> -
>>> -    /* Gets and checks the ruleset. */
>>> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>> -    if (IS_ERR(ruleset))
>>> -        return PTR_ERR(ruleset);
>>> -
>>> -    /*
>>> -     * Informs about useless rule: empty allowed_access (i.e. deny 
>>> rules)
>>> -     * are ignored in path walks.
>>> -     */
>>> -    if (!path_beneath_attr.allowed_access) {
>>> -        err = -ENOMSG;
>>> -        goto out_put_ruleset;
>>> -    }
>>> -    /*
>>> -     * Checks that allowed_access matches the @ruleset constraints
>>> -     * (ruleset->fs_access_masks[0] is automatically upgraded to 
>>> 64-bits).
>>> -     */
>>> -    if ((path_beneath_attr.allowed_access | 
>>> ruleset->fs_access_masks[0]) !=
>>> -            ruleset->fs_access_masks[0]) {
>>> -        err = -EINVAL;
>>> -        goto out_put_ruleset;
>>> +    switch (rule_type) {
>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>> +        /* Copies raw user space buffer, for fs rule type. */
>>> +        res = copy_from_user(&path_beneath_attr, rule_attr,
>>> +                    sizeof(path_beneath_attr));
>>> +        if (res)
>>> +            return -EFAULT;
>>> +        break;
>>> +
>>> +    case LANDLOCK_RULE_NET_SERVICE:
>>> +        /* Copies raw user space buffer, for net rule type. */
>>> +        res = copy_from_user(&net_service_attr, rule_attr,
>>> +                sizeof(net_service_attr));
>>> +        if (res)
>>> +            return -EFAULT;
>>> +        break;
>>>       }
>>> -    /* Gets and checks the new rule. */
>>> -    err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>> -    if (err)
>>> -        goto out_put_ruleset;
>>> +    if (rule_type == LANDLOCK_RULE_PATH_BENEATH) {
>>> +        /* Gets and checks the ruleset. */
>>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>> +        if (IS_ERR(ruleset))
>>> +            return PTR_ERR(ruleset);
>>> +
>>> +        /*
>>> +         * Informs about useless rule: empty allowed_access (i.e. 
>>> deny rules)
>>> +         * are ignored in path walks.
>>> +         */
>>> +        if (!path_beneath_attr.allowed_access) {
>>> +            err = -ENOMSG;
>>> +            goto out_put_ruleset;
>>> +        }
>>> +        /*
>>> +         * Checks that allowed_access matches the @ruleset constraints
>>> +         * (ruleset->access_masks[0] is automatically upgraded to 
>>> 64-bits).
>>> +         */
>>> +        if ((path_beneath_attr.allowed_access | 
>>> ruleset->access_masks[0]) !=
>>> +                            ruleset->access_masks[0]) {
>>> +            err = -EINVAL;
>>> +            goto out_put_ruleset;
>>> +        }
>>> +
>>> +        /* Gets and checks the new rule. */
>>> +        err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>> +        if (err)
>>> +            goto out_put_ruleset;
>>> +
>>> +        /* Imports the new rule. */
>>> +        err = landlock_append_fs_rule(ruleset, &path,
>>> +                path_beneath_attr.allowed_access);
>>> +        path_put(&path);
>>> +    }
>>> -    /* Imports the new rule. */
>>> -    err = landlock_append_fs_rule(ruleset, &path,
>>> -            path_beneath_attr.allowed_access);
>>> -    path_put(&path);
>>> +    if (rule_type == LANDLOCK_RULE_NET_SERVICE) {
>>> +        /* Gets and checks the ruleset. */
>>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>
>> You need to factor out more code.
> 
>    Sorry. I did not get you here. Please could you explain more detailed?

Instead of duplicating similar function calls (e.g. get_ruleset_from_fd) 
or operations, try to use one switch statement where you put the checks 
that are different (you can move the 
copy_from_user(&path_beneath_attr...) call). It may be a good idea to 
split this function into 3: one handling each rule_attr, which enables 
to not mix different attr types in the same function. A standalone patch 
should be refactoring the code to add and use a new function 
add_rule_path_beneath(ruleset, rule_attr) (only need the "landlock_" 
prefix for exported functions).
