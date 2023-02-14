Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305B0696092
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjBNKSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjBNKSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:18:49 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9117A61B4;
        Tue, 14 Feb 2023 02:18:48 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGH9w3SxRz6J7PZ;
        Tue, 14 Feb 2023 18:14:12 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 10:18:46 +0000
Message-ID: <c5a25001-9737-7b95-1438-acbbc3a0e139@huawei.com>
Date:   Tue, 14 Feb 2023 13:18:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 07/12] landlock: Refactor landlock_add_rule() syscall
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-8-konstantin.meskhidze@huawei.com>
 <633f6f0e-4380-4a2b-3e1a-ea4691092c08@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <633f6f0e-4380-4a2b-3e1a-ea4691092c08@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
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



2/10/2023 8:38 PM, Mickaël Salaün пишет:
> 
> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>> Change the landlock_add_rule() syscall to support new rule types
>> in future Landlock versions. Add the add_rule_path_beneath() helper
>> to support current filesystem rules.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v8:
>> * Refactors commit message.
>> * Minor fixes.
>> 
>> Changes since v7:
>> * None
>> 
>> Changes since v6:
>> * None
>> 
>> Changes since v5:
>> * Refactors syscall landlock_add_rule() and add_rule_path_beneath() helper
>> to make argument check ordering consistent and get rid of partial revertings
>> in following patches.
>> * Rolls back refactoring base_test.c seltest.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors add_rule_path_beneath() and landlock_add_rule() functions
>> to optimize code usage.
>> * Refactors base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
>> rule type in landlock_add_rule() call.
>> 
>> Changes since v3:
>> * Split commit.
>> * Refactors landlock_add_rule syscall.
>> 
>> ---
>>   security/landlock/syscalls.c | 94 +++++++++++++++++++-----------------
>>   1 file changed, 50 insertions(+), 44 deletions(-)
>> 
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index d35cd5d304db..73c80cd2cdbe 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -274,6 +274,49 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>>   	return err;
>>   }
>>   
>> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
>> +				 const void __user *const rule_attr)
>> +{
>> +	struct landlock_path_beneath_attr path_beneath_attr;
>> +	struct path path;
>> +	int res, err;
>> +	access_mask_t mask;
>> +
>> +	/* Copies raw user space buffer, only one type for now. */
>> +	res = copy_from_user(&path_beneath_attr, rule_attr,
>> +			     sizeof(path_beneath_attr));
>> +	if (res)
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
>> +	 * are ignored in path walks.
>> +	 */
>> +	if (!path_beneath_attr.allowed_access) {
>> +		return -ENOMSG;
>> +	}
> 
> Please follows the ./scripts/checkpatch.pl conventions (i.e. no curly
> braces). You should add an empty line after this return though.
> 
  Ok. I will fix it.
> 
> 
>> +	/*
>> +	 * Checks that allowed_access matches the @ruleset constraints
>> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>> +	 */
>> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
>> +	if ((path_beneath_attr.allowed_access | mask) != mask) {
>> +		return -EINVAL;
>> +	}
> 
> Same here.

   Got it.
> 
>> +
>> +	/* Gets and checks the new rule. */
>> +	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>> +	if (err)
>> +		return err;
>> +
>> +	/* Imports the new rule. */
>> +	err = landlock_append_fs_rule(ruleset, &path,
>> +				      path_beneath_attr.allowed_access);
>> +	path_put(&path);
>> +
> 
> No need for this empty line.

   Ok. Thanks for noticing.
> 
>> +	return err;
>> +}
>> +
> .
