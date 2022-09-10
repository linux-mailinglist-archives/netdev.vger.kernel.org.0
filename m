Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C95B478C
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 18:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIJQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIJQuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 12:50:32 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A34D303FD;
        Sat, 10 Sep 2022 09:50:25 -0700 (PDT)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MPzJd36Ctz67DfB;
        Sun, 11 Sep 2022 00:46:09 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 18:50:22 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 17:50:22 +0100
Message-ID: <71a51eaa-7c6b-edfa-b397-2597c06b32db@huawei.com>
Date:   Sat, 10 Sep 2022 19:50:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 04/18] landlock: move helper functions
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-5-konstantin.meskhidze@huawei.com>
 <2299f034-e6f2-051c-97e3-bf93a0916a50@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <2299f034-e6f2-051c-97e3-bf93a0916a50@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:07 AM, Mickaël Salaün пишет:
> You can make the subject more informative with "landlock: Move
> unmask_layers() and init_layer_masks()".
> 
  Ok. Thanks.
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> This patch moves unmask_layers() and init_layer_masks() helpers
>> to ruleset.c to share with landlock network implementation in
>> following commits.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * Moves get_handled_accesses() helper from ruleset.c back to fs.c,
>>    cause it's not used in coming network commits.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Moves init_layer_masks() and get_handled_accesses() helpers
>> to ruleset.c and makes then non-static.
>> * Formats code with clang-format-14.
>> 
>> ---
>>   security/landlock/fs.c      | 85 -------------------------------------
>>   security/landlock/ruleset.c | 84 ++++++++++++++++++++++++++++++++++++
>>   security/landlock/ruleset.h | 10 +++++
>>   3 files changed, 94 insertions(+), 85 deletions(-)
>> 
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index cca87fcd222d..b03d6153f628 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -215,60 +215,6 @@ find_rule(const struct landlock_ruleset *const domain,
>>   	return rule;
>>   }
>> 
>> -/*
>> - * @layer_masks is read and may be updated according to the access request and
>> - * the matching rule.
>> - *
>> - * Returns true if the request is allowed (i.e. relevant layer masks for the
>> - * request are empty).
>> - */
>> -static inline bool
>> -unmask_layers(const struct landlock_rule *const rule,
>> -	      const access_mask_t access_request,
>> -	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> -{
>> -	size_t layer_level;
>> -
>> -	if (!access_request || !layer_masks)
>> -		return true;
>> -	if (!rule)
>> -		return false;
>> -
>> -	/*
>> -	 * An access is granted if, for each policy layer, at least one rule
>> -	 * encountered on the pathwalk grants the requested access,
>> -	 * regardless of its position in the layer stack.  We must then check
>> -	 * the remaining layers for each inode, from the first added layer to
>> -	 * the last one.  When there is multiple requested accesses, for each
>> -	 * policy layer, the full set of requested accesses may not be granted
>> -	 * by only one rule, but by the union (binary OR) of multiple rules.
>> -	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
>> -	 */
>> -	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
>> -		const struct landlock_layer *const layer =
>> -			&rule->layers[layer_level];
>> -		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
>> -		const unsigned long access_req = access_request;
>> -		unsigned long access_bit;
>> -		bool is_empty;
>> -
>> -		/*
>> -		 * Records in @layer_masks which layer grants access to each
>> -		 * requested access.
>> -		 */
>> -		is_empty = true;
>> -		for_each_set_bit(access_bit, &access_req,
>> -				 ARRAY_SIZE(*layer_masks)) {
>> -			if (layer->access & BIT_ULL(access_bit))
>> -				(*layer_masks)[access_bit] &= ~layer_bit;
>> -			is_empty = is_empty && !(*layer_masks)[access_bit];
>> -		}
>> -		if (is_empty)
>> -			return true;
>> -	}
>> -	return false;
>> -}
>> -
>>   /*
>>    * Allows access to pseudo filesystems that will never be mountable (e.g.
>>    * sockfs, pipefs), but can still be reachable through
>> @@ -303,37 +249,6 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
>>   	return access_dom;
>>   }
>> 
>> -static inline access_mask_t
>> -init_layer_masks(const struct landlock_ruleset *const domain,
>> -		 const access_mask_t access_request,
>> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> -{
>> -	access_mask_t handled_accesses = 0;
>> -	size_t layer_level;
>> -
>> -	memset(layer_masks, 0, sizeof(*layer_masks));
>> -	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>> -	if (!access_request)
>> -		return 0;
>> -
>> -	/* Saves all handled accesses per layer. */
>> -	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
>> -		const unsigned long access_req = access_request;
>> -		unsigned long access_bit;
>> -
>> -		for_each_set_bit(access_bit, &access_req,
>> -				 ARRAY_SIZE(*layer_masks)) {
>> -			if (landlock_get_fs_access_mask(domain, layer_level) &
>> -			    BIT_ULL(access_bit)) {
>> -				(*layer_masks)[access_bit] |=
>> -					BIT_ULL(layer_level);
>> -				handled_accesses |= BIT_ULL(access_bit);
>> -			}
>> -		}
>> -	}
>> -	return handled_accesses;
>> -}
>> -
>>   /*
>>    * Check that a destination file hierarchy has more restrictions than a source
>>    * file hierarchy.  This is only used for link and rename actions.
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 3a5ef356aaa3..671a95e2a345 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -564,3 +564,87 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>>   	}
>>   	return NULL;
>>   }
>> +
>> +/*
>> + * @layer_masks is read and may be updated according to the access request and
>> + * the matching rule.
>> + *
>> + * Returns true if the request is allowed (i.e. relevant layer masks for the
>> + * request are empty).
>> + */
>> +bool unmask_layers(const struct landlock_rule *const rule,
>> +		   const access_mask_t access_request,
>> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> +{
>> +	size_t layer_level;
>> +
>> +	if (!access_request || !layer_masks)
>> +		return true;
>> +	if (!rule)
>> +		return false;
>> +
>> +	/*
>> +	 * An access is granted if, for each policy layer, at least one rule
>> +	 * encountered on the pathwalk grants the requested access,
>> +	 * regardless of its position in the layer stack.  We must then check
>> +	 * the remaining layers for each inode, from the first added layer to
>> +	 * the last one.  When there is multiple requested accesses, for each
>> +	 * policy layer, the full set of requested accesses may not be granted
>> +	 * by only one rule, but by the union (binary OR) of multiple rules.
>> +	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
>> +	 */
>> +	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
>> +		const struct landlock_layer *const layer =
>> +			&rule->layers[layer_level];
>> +		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
>> +		const unsigned long access_req = access_request;
>> +		unsigned long access_bit;
>> +		bool is_empty;
>> +
>> +		/*
>> +		 * Records in @layer_masks which layer grants access to each
>> +		 * requested access.
>> +		 */
>> +		is_empty = true;
>> +		for_each_set_bit(access_bit, &access_req,
>> +				 ARRAY_SIZE(*layer_masks)) {
>> +			if (layer->access & BIT_ULL(access_bit))
>> +				(*layer_masks)[access_bit] &= ~layer_bit;
>> +			is_empty = is_empty && !(*layer_masks)[access_bit];
>> +		}
>> +		if (is_empty)
>> +			return true;
>> +	}
>> +	return false;
>> +}
>> +
>> +access_mask_t
>> +init_layer_masks(const struct landlock_ruleset *const domain,
>> +		 const access_mask_t access_request,
>> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> +{
>> +	access_mask_t handled_accesses = 0;
>> +	size_t layer_level;
>> +
>> +	memset(layer_masks, 0, sizeof(*layer_masks));
>> +	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>> +	if (!access_request)
>> +		return 0;
>> +
>> +	/* Saves all handled accesses per layer. */
>> +	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
>> +		const unsigned long access_req = access_request;
>> +		unsigned long access_bit;
>> +
>> +		for_each_set_bit(access_bit, &access_req,
>> +				 ARRAY_SIZE(*layer_masks)) {
>> +			if (landlock_get_fs_access_mask(domain, layer_level) &
>> +			    BIT_ULL(access_bit)) {
>> +				(*layer_masks)[access_bit] |=
>> +					BIT_ULL(layer_level);
>> +				handled_accesses |= BIT_ULL(access_bit);
>> +			}
>> +		}
>> +	}
>> +	return handled_accesses;
>> +}
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index bb1408cc8dd2..d7d9b987829c 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -235,4 +235,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   		LANDLOCK_SHIFT_ACCESS_FS) &
>>   	       LANDLOCK_MASK_ACCESS_FS;
>>   }
>> +
>> +bool unmask_layers(const struct landlock_rule *const rule,
>> +		   const access_mask_t access_request,
>> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +
>> +access_mask_t
>> +init_layer_masks(const struct landlock_ruleset *const domain,
>> +		 const access_mask_t access_request,
>> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +
>>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
>> --
>> 2.25.1
>> 
> .
