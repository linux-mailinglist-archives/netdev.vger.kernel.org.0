Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF963A012
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiK1DZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 22:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiK1DZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:25:22 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4236411C3C;
        Sun, 27 Nov 2022 19:25:20 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NL9nn3ZJbz67KPY;
        Mon, 28 Nov 2022 11:25:01 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 04:25:17 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 03:25:16 +0000
Message-ID: <8542aa54-4d74-8b56-8dc4-ee619d66c7bf@huawei.com>
Date:   Mon, 28 Nov 2022 06:25:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 04/12] landlock: Move unmask_layers() and
 init_layer_masks()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-5-konstantin.meskhidze@huawei.com>
 <aed09115-cfd8-1986-a848-bb33d2743def@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <aed09115-cfd8-1986-a848-bb33d2743def@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/2022 9:42 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> This patch moves unmask_layers() and init_layer_masks() helpers
>> to ruleset.c to share with landlock network implementation in
> 
> …to share them with the Landlock network implementation in
> 
    Got it.
> 
>> following commits.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Refactors commit message.
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
>>   security/landlock/fs.c      | 103 ------------------------------------
>>   security/landlock/ruleset.c | 102 +++++++++++++++++++++++++++++++++++
>>   security/landlock/ruleset.h |  20 +++++++
>>   3 files changed, 122 insertions(+), 103 deletions(-)
>> 
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index 710cfa1306de..240e42a8f788 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -226,60 +226,6 @@ find_rule(const struct landlock_ruleset *const domain,
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
>> @@ -303,55 +249,6 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
>>   	return access_dom & LANDLOCK_MASK_ACCESS_FS;
>>   }
>> 
>> -/**
>> - * init_layer_masks - Initialize layer masks from an access request
>> - *
>> - * Populates @layer_masks such that for each access right in @access_request,
>> - * the bits for all the layers are set where this access right is handled.
>> - *
>> - * @domain: The domain that defines the current restrictions.
>> - * @access_request: The requested access rights to check.
>> - * @layer_masks: The layer masks to populate.
>> - *
>> - * Returns: An access mask where each access right bit is set which is handled
>> - * in any of the active layers in @domain.
>> - */
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
>> -			/*
>> -			 * Artificially handles all initially denied by default
>> -			 * access rights.
>> -			 */
>> -			if (BIT_ULL(access_bit) &
>> -			    (landlock_get_fs_access_mask(domain, layer_level) |
>> -			     ACCESS_INITIALLY_DENIED)) {
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
>> index 961ffe0c709e..02ab14439c43 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -572,3 +572,105 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
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
>> +/**
>> + * init_layer_masks - Initialize layer masks from an access request
>> + *
>> + * Populates @layer_masks such that for each access right in @access_request,
>> + * the bits for all the layers are set where this access right is handled.
>> + *
>> + * @domain: The domain that defines the current restrictions.
>> + * @access_request: The requested access rights to check.
>> + * @layer_masks: The layer masks to populate.
>> + *
>> + * Returns: An access mask where each access right bit is set which is handled
>> + * in any of the active layers in @domain.
>> + */
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
>> +			/*
>> +			 * Artificially handles all initially denied by default
>> +			 * access rights.
>> +			 */
>> +			if (BIT_ULL(access_bit) &
>> +			    (landlock_get_fs_access_mask(domain, layer_level) |
>> +			     ACCESS_INITIALLY_DENIED)) {
> 
> This is a future bug in the a next commit when
> landlock_get_fs_access_mask() is changed to get the network access mask.
> My patch will fix this part but you'll need to do a new copy of this
> function.

   Ok. Thanks.
> 
> 
> 
>> +				(*layer_masks)[access_bit] |=
>> +					BIT_ULL(layer_level);
>> +				handled_accesses |= BIT_ULL(access_bit);
>> +			}
>> +		}
>> +	}
>> +	return handled_accesses;
>> +}
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 608ab356bc3e..50baff4fcbb4 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -34,6 +34,16 @@ typedef u16 layer_mask_t;
>>   /* Makes sure all layers can be checked. */
>>   static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
>> 
>> +/*
>> + * All access rights that are denied by default whether they are handled or not
>> + * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
>> + * entries when we need to get the absolute handled access masks.
>> + */
>> +/* clang-format off */
>> +#define ACCESS_INITIALLY_DENIED ( \
>> +	LANDLOCK_ACCESS_FS_REFER)
>> +/* clang-format on */
> 
> This ACCESS_INITIALLY_DENIED definition must be moved, not copied. You
> can rename ACCESS_INITIALLY_DENIED to ACCESS_FS_INITIALLY_DENIED and
> move this hunk before the access_mask_t definition.
> 
   Yep. Will be fixed.
> 
>> +
>>   /**
>>    * struct landlock_layer - Access rights for a given layer
>>    */
>> @@ -246,4 +256,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   		LANDLOCK_SHIFT_ACCESS_FS) &
>>   	       LANDLOCK_MASK_ACCESS_FS;
>>   }
>> +
>> +bool unmask_layers(const struct landlock_rule *const rule,
> 
> All public Landlock helpers must be prefixed with "landlock_"

   Do you mean ones which are shared between fs and net parts?
> 
>> +		   const access_mask_t access_request,
>> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +
>> +access_mask_t
>> +init_layer_masks(const struct landlock_ruleset *const domain,
>> +		 const access_mask_t access_request,
>> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> 
> There is a warning generated by checkpatch.pl about this line:
>     WARNING: function definition argument 'layer_mask_t' should also have
> an identifier name
> 
> I think this is a bug in checkpatch.pl
> 
    I got this warn, but cant get rid of it.
    Also think its a bug in checkpatck.pl

> Any though Andy, Joe, Dwaipayan or Lukas?
> 
> 
>> +
>>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
>> --
>> 2.25.1
>> 
> .
