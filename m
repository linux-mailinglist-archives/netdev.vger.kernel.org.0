Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA585B358D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiIIKt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIIKtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:49:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7024413882F;
        Fri,  9 Sep 2022 03:48:50 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MPCPs5bM6z686fV;
        Fri,  9 Sep 2022 18:48:01 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Fri, 9 Sep 2022 12:48:48 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 11:48:47 +0100
Message-ID: <282806a0-2168-f171-e801-933e35612d22@huawei.com>
Date:   Fri, 9 Sep 2022 13:48:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 02/18] landlock: refactor
 landlock_find_rule/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
 <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:07 AM, Mickaël Salaün пишет:
> Good to see such clean commit!
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> Adds a new landlock_key union and landlock_id structure to support
>> a socket port rule type. Refactors landlock_insert_rule() and
>> landlock_find_rule() to support coming network modifications.
> 
>> This patch also adds is_object_pointer() and get_root() helpers.
> 
> Please explain a bit what these helpers do.
> 
   Ok. I will fix it.
> 
>> Now adding or searching a rule in a ruleset depends on a landlock id
>> argument provided in refactored functions mentioned above.
> 
> More explanation:
> A struct landlock_id identifies a unique entry in a ruleset: either a
> kernel object (e.g inode) or a typed data (e.g. TCP port). There is one
> red-black tree per key type.
> 
    Got it.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> Because most changes come from
> https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f
> and
> https://git.kernel.org/mic/c/7d6cf40a6f81adf607ad3cc17aaa11e256beeea4
> you can append
> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> 

  Ok. Thank you for help here.

>> ---
>> 
>> Changes since v6:
>> * Adds union landlock_key, enum landlock_key_type, and struct
>>    landlock_id.
>> * Refactors ruleset functions and improves switch/cases: create_rule(),
>>    insert_rule(), get_root(), is_object_pointer(), free_rule(),
>>    landlock_find_rule().
>> * Refactors landlock_append_fs_rule() functions to support new
>>    landlock_id type.
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors insert_rule() and create_rule() functions by deleting
>> rule_type from their arguments list, it helps to reduce useless code.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>> * Rename new_ruleset->root_inode.
>> 
>> ---
>>   security/landlock/fs.c      |  21 ++++--
>>   security/landlock/ruleset.c | 146 +++++++++++++++++++++++++-----------
>>   security/landlock/ruleset.h |  51 ++++++++++---
>>   3 files changed, 156 insertions(+), 62 deletions(-)
> 
> [...]
> 
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 647d44284080..bb1408cc8dd2 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -49,6 +49,33 @@ struct landlock_layer {
>>   	access_mask_t access;
>>   };
>> 
>> +/**
>> + * union landlock_key - Key of a ruleset's red-black tree
>> + */
>> +union landlock_key {
>> +	struct landlock_object *object;
>> +	uintptr_t data;
>> +};
>> +
>> +/**
>> + * enum landlock_key_type - Type of &union landlock_key
>> + */
>> +enum landlock_key_type {
>> +	/**
>> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
>> +	 * keys.
>> +	 */
>> +	LANDLOCK_KEY_INODE = 1,
>> +};
>> +
>> +/**
>> + * struct landlock_id - Unique rule identifier for a ruleset
>> + */
>> +struct landlock_id {
>> +	union landlock_key key;
>> +	const enum landlock_key_type type;
>> +};
> 
> You can add these new types to Documentation/security/landlock.rst (with
> this commit). You need to complete all the new field descriptions though
> (otherwise you'll get Sphinx warnings): object, data, key, type.

   Sorry I did not get this tip. Can you explain more detailed here, 
about Sphinx warnings?
> .
