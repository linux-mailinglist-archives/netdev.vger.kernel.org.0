Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27342696081
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjBNKQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNKQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:16:39 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD9C1F5E1;
        Tue, 14 Feb 2023 02:16:38 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGHBm70KYz6J9bx;
        Tue, 14 Feb 2023 18:14:56 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 10:16:36 +0000
Message-ID: <5c2fd160-d33d-9a6b-ddb4-d33203caf82b@huawei.com>
Date:   Tue, 14 Feb 2023 13:16:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 06/12] landlock: Refactor _unmask_layers() and
 _init_layer_masks()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-7-konstantin.meskhidze@huawei.com>
 <70b5c38d-117e-0b07-f942-8025a83a3df7@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <70b5c38d-117e-0b07-f942-8025a83a3df7@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
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
>> Add new key_type argument to the landlock_init_layer_masks() helper.
>> Add a masks_array_size argument to the landlock_unmask_layers() helper.
>> These modifications support implementing new rule types in the next
>> Landlock versions.
>> 
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v8:
>> * None.
>> 
>> Changes since v7:
>> * Refactors commit message, adds a co-developer.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Removes masks_size attribute from init_layer_masks().
>> * Refactors init_layer_masks() with new landlock_key_type.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors init_layer_masks(), get_handled_accesses()
>> and unmask_layers() functions to support multiple rule types.
>> * Refactors landlock_get_fs_access_mask() function with
>> LANDLOCK_MASK_ACCESS_FS mask.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_unmask_layers functions.
>> 
>> ---
>>   security/landlock/fs.c      | 43 ++++++++++++++++--------------
>>   security/landlock/ruleset.c | 52 ++++++++++++++++++++++++++-----------
>>   security/landlock/ruleset.h | 17 ++++++------
>>   3 files changed, 70 insertions(+), 42 deletions(-)
>> 
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index 73a7399f93ba..a73dbd3f9ddb 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>>
> 
> [...]
> 
>> @@ -658,10 +677,13 @@ access_mask_t landlock_init_layer_masks(
>>   		const unsigned long access_req = access_request;
>>   		unsigned long access_bit;
>>   
>> -		for_each_set_bit(access_bit, &access_req,
>> -				 ARRAY_SIZE(*layer_masks)) {
>> +		for_each_set_bit(access_bit, &access_req, num_access) {
>> +			/*
>> +			 * Artificially handles all initially denied by default
>> +			 * access rights.
>> +			 */
> 
> No need to re-add this old comment which was removed with patch 2/12.
> 
  Ok. Will be fixed.
> 
>>   			if (BIT_ULL(access_bit) &
>> -			    landlock_get_fs_access_mask(domain, layer_level)) {
>> +			    get_access_mask(domain, layer_level)) {
>>   				(*layer_masks)[access_bit] |=
>>   					BIT_ULL(layer_level);
>>   				handled_accesses |= BIT_ULL(access_bit);
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 60a3c4d4d961..77349764e111 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -266,14 +266,15 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
>>   	       ACCESS_FS_INITIALLY_DENIED;
>>   }
>> -bool landlock_unmask_layers(
>> -	const struct landlock_rule *const rule,
>> -	const access_mask_t access_request,
>> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +bool landlock_unmask_layers(const struct landlock_rule *const rule,
>> +			    const access_mask_t access_request,
>> +			    layer_mask_t (*const layer_masks)[],
>> +			    const size_t masks_array_size);
>>   
>> -access_mask_t landlock_init_layer_masks(
>> -	const struct landlock_ruleset *const domain,
>> -	const access_mask_t access_request,
>> -	layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +access_mask_t
>> +landlock_init_layer_masks(const struct landlock_ruleset *const domain,
>> +			  const access_mask_t access_request,
>> +			  layer_mask_t (*const layer_masks)[],
>> +			  const enum landlock_key_type key_type);
>>   
>>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
> .
