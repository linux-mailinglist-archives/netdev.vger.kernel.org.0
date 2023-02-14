Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A5A6964AD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjBNN2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjBNN2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:28:33 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208AD2449E;
        Tue, 14 Feb 2023 05:28:31 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGMP25DG9z6J6B9;
        Tue, 14 Feb 2023 21:24:06 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 13:28:27 +0000
Message-ID: <27c3a7ac-ceef-c569-0c80-e6f741638927@huawei.com>
Date:   Tue, 14 Feb 2023 16:28:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 03/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-4-konstantin.meskhidze@huawei.com>
 <d014f6db-0073-5461-afcd-5b046f3db096@digikod.net>
 <487bf00c-b5e1-c391-6ae1-7bd8127db739@huawei.com>
 <1d9afc6c-30fc-fc70-5ceb-85110cb57a5f@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <1d9afc6c-30fc-fc70-5ceb-85110cb57a5f@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/14/2023 3:09 PM, Mickaël Salaün пишет:
> 
> On 14/02/2023 11:15, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 2/10/2023 8:36 PM, Mickaël Salaün пишет:
>>>
>>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>>> Add a new landlock_key union and landlock_id structure to support
>>>> a socket port rule type. A struct landlock_id identifies a unique entry
>>>> in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
>>>> port). There is one red-black tree per key type.
>>>>
>>>> This patch also adds is_object_pointer() and get_root() helpers.
>>>> is_object_pointer() returns true if key type is LANDLOCK_KEY_INODE.
>>>> get_root() helper returns a red_black tree root pointer according to
>>>> a key type.
>>>>
>>>> Refactor landlock_insert_rule() and landlock_find_rule() to support coming
>>>> network modifications. Adding or searching a rule in ruleset can now be
>>>> done thanks to a Landlock ID argument passed to these helpers.
>>>>
>>>> Remove unnecessary inlining.
>>>>
>>>
>>> You need to keep the Co-developed-by before the Signed-off-by for my entry.
>> 
>>     Got it.
>>>
>>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v8:
>>>> * Refactors commit message.
>>>> * Removes inlining.
>>>> * Minor fixes.
>>>>
>>>> Changes since v7:
>>>> * Completes all the new field descriptions landlock_key,
>>>>     landlock_key_type, landlock_id.
>>>> * Refactors commit message, adds a co-developer.
>>>>
>>>> Changes since v6:
>>>> * Adds union landlock_key, enum landlock_key_type, and struct
>>>>     landlock_id.
>>>> * Refactors ruleset functions and improves switch/cases: create_rule(),
>>>>     insert_rule(), get_root(), is_object_pointer(), free_rule(),
>>>>     landlock_find_rule().
>>>> * Refactors landlock_append_fs_rule() functions to support new
>>>>     landlock_id type.
>>>>
>>>> Changes since v5:
>>>> * Formats code with clang-format-14.
>>>>
>>>> Changes since v4:
>>>> * Refactors insert_rule() and create_rule() functions by deleting
>>>> rule_type from their arguments list, it helps to reduce useless code.
>>>>
>>>> Changes since v3:
>>>> * Splits commit.
>>>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>>>> * Rename new_ruleset->root_inode.
>>>>
>>>> ---
>>>>    security/landlock/fs.c      |  49 ++++++------
>>>>    security/landlock/ruleset.c | 148 +++++++++++++++++++++++++-----------
>>>>    security/landlock/ruleset.h |  65 +++++++++++++---
>>>>    3 files changed, 185 insertions(+), 77 deletions(-)
>>>>
>>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>>> index 0ae54a639e16..273ed8549da1 100644
>>>> --- a/security/landlock/fs.c
>>>> +++ b/security/landlock/fs.c
>>>
>>> [...]
>>>
>>>> @@ -191,12 +193,15 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>>>>     *
>>>>     * Returns NULL if no rule is found or if @dentry is negative.
>>>>     */
>>>> -static inline const struct landlock_rule *
>>>> +static const struct landlock_rule *
>>>
>>> Can you please create a (previous) dedicated patch for all the inlining
>>> changes?
>>>   
>>     a patch with just inlining changes?
> 
> Yes, a new patch with just the inlining changes extracted from this patch.

   Ok.
> .
