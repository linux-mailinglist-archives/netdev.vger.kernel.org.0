Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7569631F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjBNMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBNMJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:09:06 -0500
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA80B749
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:09:04 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PGKkR24MzzMs0jZ;
        Tue, 14 Feb 2023 13:09:03 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PGKkQ4T8qz1HZ7;
        Tue, 14 Feb 2023 13:09:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676376543;
        bh=LdXHVTq0mj/9kbBBw2Z8AJx01jcUITH42E3o5M9DjtE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OBLuJr0XPXlvS6JeqxiU34GkTIKJtw+ovNWWdtidjr0uoU2WHi9xrXuUbFz13EXoY
         fqrCQRC/bZhGotxY7P/voWoa4uuits/iZimULm7wcOrXC4sOygQYmEvQvI18tClvhX
         ArW3k+M3OdHCdE+dsjjS5TFlHseScPKiMNbI9WUc=
Message-ID: <1d9afc6c-30fc-fc70-5ceb-85110cb57a5f@digikod.net>
Date:   Tue, 14 Feb 2023 13:09:02 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 03/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-4-konstantin.meskhidze@huawei.com>
 <d014f6db-0073-5461-afcd-5b046f3db096@digikod.net>
 <487bf00c-b5e1-c391-6ae1-7bd8127db739@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <487bf00c-b5e1-c391-6ae1-7bd8127db739@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 11:15, Konstantin Meskhidze (A) wrote:
> 
> 
> 2/10/2023 8:36 PM, Mickaël Salaün пишет:
>>
>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>> Add a new landlock_key union and landlock_id structure to support
>>> a socket port rule type. A struct landlock_id identifies a unique entry
>>> in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
>>> port). There is one red-black tree per key type.
>>>
>>> This patch also adds is_object_pointer() and get_root() helpers.
>>> is_object_pointer() returns true if key type is LANDLOCK_KEY_INODE.
>>> get_root() helper returns a red_black tree root pointer according to
>>> a key type.
>>>
>>> Refactor landlock_insert_rule() and landlock_find_rule() to support coming
>>> network modifications. Adding or searching a rule in ruleset can now be
>>> done thanks to a Landlock ID argument passed to these helpers.
>>>
>>> Remove unnecessary inlining.
>>>
>>
>> You need to keep the Co-developed-by before the Signed-off-by for my entry.
> 
>     Got it.
>>
>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v8:
>>> * Refactors commit message.
>>> * Removes inlining.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Completes all the new field descriptions landlock_key,
>>>     landlock_key_type, landlock_id.
>>> * Refactors commit message, adds a co-developer.
>>>
>>> Changes since v6:
>>> * Adds union landlock_key, enum landlock_key_type, and struct
>>>     landlock_id.
>>> * Refactors ruleset functions and improves switch/cases: create_rule(),
>>>     insert_rule(), get_root(), is_object_pointer(), free_rule(),
>>>     landlock_find_rule().
>>> * Refactors landlock_append_fs_rule() functions to support new
>>>     landlock_id type.
>>>
>>> Changes since v5:
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Refactors insert_rule() and create_rule() functions by deleting
>>> rule_type from their arguments list, it helps to reduce useless code.
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>>> * Rename new_ruleset->root_inode.
>>>
>>> ---
>>>    security/landlock/fs.c      |  49 ++++++------
>>>    security/landlock/ruleset.c | 148 +++++++++++++++++++++++++-----------
>>>    security/landlock/ruleset.h |  65 +++++++++++++---
>>>    3 files changed, 185 insertions(+), 77 deletions(-)
>>>
>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>> index 0ae54a639e16..273ed8549da1 100644
>>> --- a/security/landlock/fs.c
>>> +++ b/security/landlock/fs.c
>>
>> [...]
>>
>>> @@ -191,12 +193,15 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>>>     *
>>>     * Returns NULL if no rule is found or if @dentry is negative.
>>>     */
>>> -static inline const struct landlock_rule *
>>> +static const struct landlock_rule *
>>
>> Can you please create a (previous) dedicated patch for all the inlining
>> changes?
>>   
>     a patch with just inlining changes?

Yes, a new patch with just the inlining changes extracted from this patch.
