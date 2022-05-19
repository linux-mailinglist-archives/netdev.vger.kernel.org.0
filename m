Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884B652D651
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiESOmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiESOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:42:11 -0400
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DABD0295
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:42:10 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L3sy83sd2zMprpm;
        Thu, 19 May 2022 16:42:08 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L3sy76ds4zlhRV4;
        Thu, 19 May 2022 16:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652971328;
        bh=FN4HUykMYqUvIzTAL3TDQuNZ0PsPOKD5ezN1b94768c=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=L6dSOC9G7rxq1YYbjiIu6nmarQWfhA3HQ1/fQwp7Zfe7SiJkq/Vadf3uQcDUg3wGf
         TDp8b8rpPZn9lwCocoFlm5J+kMp8q8QxT+IKrFP40SzKQRc3Aq+oA8StLrG7ukkzvg
         MdDK0I8eOeSmylQsb2g+CmplktShwrac5RfeVjKE=
Message-ID: <2cdd23ed-6184-3264-cf1d-98930f59539d@digikod.net>
Date:   Thu, 19 May 2022 16:42:07 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-8-konstantin.meskhidze@huawei.com>
 <544f0edb-0b5a-17c3-57a1-a373723ef37f@digikod.net>
 <061bc23b-ecb2-1809-98a0-11f8195b3b5d@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 07/15] landlock: add support network rules
In-Reply-To: <061bc23b-ecb2-1809-98a0-11f8195b3b5d@huawei.com>
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


On 19/05/2022 11:27, Konstantin Meskhidze wrote:
> 
> 
> 5/17/2022 11:27 AM, Mickaël Salaün пишет:

[...]


>>>
>>> @@ -275,21 +281,17 @@ static int get_path_from_fd(const s32 fd, 
>>> struct path *const path)
>>>       return err;
>>>   }
>>>
>>> -static int add_rule_path_beneath(const int ruleset_fd, const void 
>>> *const rule_attr)
>>> +static int add_rule_path_beneath(struct landlock_ruleset *const 
>>> ruleset,
>>> +                 const void *const rule_attr)
>>>   {
>>>       struct landlock_path_beneath_attr path_beneath_attr;
>>>       struct path path;
>>> -    struct landlock_ruleset *ruleset;
>>>       int res, err;
>>> -
>>> -    /* Gets and checks the ruleset. */
>>> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>> -    if (IS_ERR(ruleset))
>>> -        return PTR_ERR(ruleset);
>>> +    u32 mask;
>>>
>>>       /* Copies raw user space buffer, only one type for now. */
>>>       res = copy_from_user(&path_beneath_attr, rule_attr,
>>> -                sizeof(path_beneath_attr));
>>> +            sizeof(path_beneath_attr));
>>>       if (res)
>>>           return -EFAULT;
>>>
>>> @@ -298,32 +300,26 @@ static int add_rule_path_beneath(const int 
>>> ruleset_fd, const void *const rule_at
>>>        * are ignored in path walks.
>>>        */
>>>       if (!path_beneath_attr.allowed_access) {
>>> -        err = -ENOMSG;
>>> -        goto out_put_ruleset;
>>> +        return -ENOMSG;
>>>       }
>>>       /*
>>>        * Checks that allowed_access matches the @ruleset constraints
>>>        * (ruleset->access_masks[0] is automatically upgraded to 
>>> 64-bits).
>>>        */
>>> -    if ((path_beneath_attr.allowed_access |
>>> -        landlock_get_fs_access_mask(ruleset, 0)) !=
>>> -                landlock_get_fs_access_mask(ruleset, 0)) {
>>> -        err = -EINVAL;
>>> -        goto out_put_ruleset;
>>> -    }
>>> +    mask = landlock_get_fs_access_mask(ruleset, 0);
>>> +    if ((path_beneath_attr.allowed_access | mask) != mask)
>>> +        return -EINVAL;
>>>
>>>       /* Gets and checks the new rule. */
>>>       err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>>       if (err)
>>> -        goto out_put_ruleset;
>>> +        return err;
>>>
>>>       /* Imports the new rule. */
>>>       err = landlock_append_fs_rule(ruleset, &path,
>>>                         path_beneath_attr.allowed_access);
>>>       path_put(&path);
>>>
>>> -out_put_ruleset:
>>> -    landlock_put_ruleset(ruleset);
>>>       return err;
>>>   }
>>>
>>> @@ -360,6 +356,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>           const int, ruleset_fd, const enum landlock_rule_type, 
>>> rule_type,
>>>           const void __user *const, rule_attr, const __u32, flags)
>>>   {
>>> +    struct landlock_ruleset *ruleset;
>>>       int err;
>>>
>>>       if (!landlock_initialized)
>>> @@ -369,14 +366,20 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>       if (flags)
>>>           return -EINVAL;
>>>
>>> +    /* Gets and checks the ruleset. */
>>> +    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>> +    if (IS_ERR(ruleset))
>>> +        return PTR_ERR(ruleset);
>>
>> This shouldn't be part of this patch.
>>
>    I agree. I will move it into another patch.

To be clear, it is kind of a partial revert of patch 5/15.
