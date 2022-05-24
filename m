Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5865A53256A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiEXIgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiEXIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:36:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456E55B6;
        Tue, 24 May 2022 01:36:38 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L6nXP04z6z6H8NV;
        Tue, 24 May 2022 16:33:25 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 24 May 2022 10:36:35 +0200
Message-ID: <3d192ad0-176c-2ec3-454f-972ef8437933@huawei.com>
Date:   Tue, 24 May 2022 11:36:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 07/15] landlock: add support network rules
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-8-konstantin.meskhidze@huawei.com>
 <544f0edb-0b5a-17c3-57a1-a373723ef37f@digikod.net>
 <061bc23b-ecb2-1809-98a0-11f8195b3b5d@huawei.com>
 <2cdd23ed-6184-3264-cf1d-98930f59539d@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <2cdd23ed-6184-3264-cf1d-98930f59539d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/19/2022 5:42 PM, Mickaël Salaün пишет:
> 
> On 19/05/2022 11:27, Konstantin Meskhidze wrote:
>>
>>
>> 5/17/2022 11:27 AM, Mickaël Salaün пишет:
> 
> [...]
> 
> 
>>>>
>>>> @@ -275,21 +281,17 @@ static int get_path_from_fd(const s32 fd, 
>>>> struct path *const path)
>>>>       return err;
>>>>   }
>>>>
>>>> -static int add_rule_path_beneath(const int ruleset_fd, const void 
>>>> *const rule_attr)
>>>> +static int add_rule_path_beneath(struct landlock_ruleset *const 
>>>> ruleset,
>>>> +                 const void *const rule_attr)
>>>>   {
>>>>       struct landlock_path_beneath_attr path_beneath_attr;
>>>>       struct path path;
>>>> -    struct landlock_ruleset *ruleset;
>>>>       int res, err;
>>>> -
>>>> -    /* Gets and checks the ruleset. */
>>>> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>>> -    if (IS_ERR(ruleset))
>>>> -        return PTR_ERR(ruleset);
>>>> +    u32 mask;
>>>>
>>>>       /* Copies raw user space buffer, only one type for now. */
>>>>       res = copy_from_user(&path_beneath_attr, rule_attr,
>>>> -                sizeof(path_beneath_attr));
>>>> +            sizeof(path_beneath_attr));
>>>>       if (res)
>>>>           return -EFAULT;
>>>>
>>>> @@ -298,32 +300,26 @@ static int add_rule_path_beneath(const int 
>>>> ruleset_fd, const void *const rule_at
>>>>        * are ignored in path walks.
>>>>        */
>>>>       if (!path_beneath_attr.allowed_access) {
>>>> -        err = -ENOMSG;
>>>> -        goto out_put_ruleset;
>>>> +        return -ENOMSG;
>>>>       }
>>>>       /*
>>>>        * Checks that allowed_access matches the @ruleset constraints
>>>>        * (ruleset->access_masks[0] is automatically upgraded to 
>>>> 64-bits).
>>>>        */
>>>> -    if ((path_beneath_attr.allowed_access |
>>>> -        landlock_get_fs_access_mask(ruleset, 0)) !=
>>>> -                landlock_get_fs_access_mask(ruleset, 0)) {
>>>> -        err = -EINVAL;
>>>> -        goto out_put_ruleset;
>>>> -    }
>>>> +    mask = landlock_get_fs_access_mask(ruleset, 0);
>>>> +    if ((path_beneath_attr.allowed_access | mask) != mask)
>>>> +        return -EINVAL;
>>>>
>>>>       /* Gets and checks the new rule. */
>>>>       err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>>>>       if (err)
>>>> -        goto out_put_ruleset;
>>>> +        return err;
>>>>
>>>>       /* Imports the new rule. */
>>>>       err = landlock_append_fs_rule(ruleset, &path,
>>>>                         path_beneath_attr.allowed_access);
>>>>       path_put(&path);
>>>>
>>>> -out_put_ruleset:
>>>> -    landlock_put_ruleset(ruleset);
>>>>       return err;
>>>>   }
>>>>
>>>> @@ -360,6 +356,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>>           const int, ruleset_fd, const enum landlock_rule_type, 
>>>> rule_type,
>>>>           const void __user *const, rule_attr, const __u32, flags)
>>>>   {
>>>> +    struct landlock_ruleset *ruleset;
>>>>       int err;
>>>>
>>>>       if (!landlock_initialized)
>>>> @@ -369,14 +366,20 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>>>       if (flags)
>>>>           return -EINVAL;
>>>>
>>>> +    /* Gets and checks the ruleset. */
>>>> +    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>>>> +    if (IS_ERR(ruleset))
>>>> +        return PTR_ERR(ruleset);
>>>
>>> This shouldn't be part of this patch.
>>>
>>    I agree. I will move it into another patch.
> 
> To be clear, it is kind of a partial revert of patch 5/15.

   Yep. Thank you for noticing that.
> .
