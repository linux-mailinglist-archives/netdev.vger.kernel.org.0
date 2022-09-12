Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D915B5F16
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiILRSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiILRSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:18:05 -0400
Received: from smtp-1908.mail.infomaniak.ch (smtp-1908.mail.infomaniak.ch [IPv6:2001:1600:4:17::1908])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382ED3ED75
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:18:02 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MRCwT1dh8zMrnQD;
        Mon, 12 Sep 2022 19:18:01 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MRCwS4KR4zMpnPk;
        Mon, 12 Sep 2022 19:18:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1663003081;
        bh=k3p0RGSbsoDOB/2x6tM3UyRW/83nUAj4/SL4xEQeBLQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Z5zG6R3x/2aJsTTIeX6g3uh5RWVhNFLvnhzzVRxnwF8meU+bv7I1BvoSF+P2MWceh
         mQvkmm6PfcxsP8C4xE2ldiPc0ZxhN3xErbCiAsVo/Tfh0jArny5WTQJMLbGIz/Gx7S
         zs31O5F1ZMZFeogiyJzPYykRGpKvFZbvyT0U9SIg=
Message-ID: <9b18b8e2-6b7a-d635-e340-480102030c71@digikod.net>
Date:   Mon, 12 Sep 2022 19:18:00 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 05/18] landlock: refactor helper functions
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-6-konstantin.meskhidze@huawei.com>
 <e7f8bc8d-0dc4-ce28-80bc-447b2219c70d@digikod.net>
 <ea1bfc93-77fc-ce1e-81a9-c69c7ae1f47b@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ea1bfc93-77fc-ce1e-81a9-c69c7ae1f47b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/09/2022 19:20, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:07 AM, Mickaël Salaün пишет:

[...]

>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index 671a95e2a345..84fcd8eb30d4 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -574,7 +574,8 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>>>     */
>>
>> You missed another hunk from my patch… Please do a diff with it.
> 
>     Sorry. What did I miss here?

There is at least missing comments, please do a diff with my (rebased) 
changes, you'll see.

I wrote all the changes in my commit messages, please include them in 
the related patches (at the correct version).


>>
>>
>>>    bool unmask_layers(const struct landlock_rule *const rule,
>>>    		   const access_mask_t access_request,
>>> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>>> +		   layer_mask_t (*const layer_masks)[],
>>> +		   const size_t masks_array_size)
>>>    {
>>>    	size_t layer_level;
>>>
>>> @@ -606,8 +607,7 @@ bool unmask_layers(const struct landlock_rule *const rule,
>>>    		 * requested access.
>>>    		 */
>>>    		is_empty = true;
>>> -		for_each_set_bit(access_bit, &access_req,
>>> -				 ARRAY_SIZE(*layer_masks)) {
>>> +		for_each_set_bit(access_bit, &access_req, masks_array_size) {
>>>    			if (layer->access & BIT_ULL(access_bit))
>>>    				(*layer_masks)[access_bit] &= ~layer_bit;
>>>    			is_empty = is_empty && !(*layer_masks)[access_bit];
>>> @@ -618,15 +618,36 @@ bool unmask_layers(const struct landlock_rule *const rule,
>>>    	return false;
>>>    }
>>>
>>> -access_mask_t
>>> -init_layer_masks(const struct landlock_ruleset *const domain,
>>> -		 const access_mask_t access_request,
>>> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>>> +typedef access_mask_t
>>> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
>>> +		  const u16 layer_level);
>>> +
>>> +/*
>>> + * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
>>> + * elements according to @key_type.
>>> + */
>>> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>>> +			       const access_mask_t access_request,
>>> +			       layer_mask_t (*const layer_masks)[],
>>> +			       const enum landlock_key_type key_type)
>>>    {
>>>    	access_mask_t handled_accesses = 0;
>>> -	size_t layer_level;
>>> +	size_t layer_level, num_access;
>>> +	get_access_mask_t *get_access_mask;
>>> +
>>> +	switch (key_type) {
>>> +	case LANDLOCK_KEY_INODE:
>>> +		get_access_mask = landlock_get_fs_access_mask;
>>> +		num_access = LANDLOCK_NUM_ACCESS_FS;
>>> +		break;
>>> +	default:
>>> +		WARN_ON_ONCE(1);
>>> +		return 0;
>>> +	}
>>> +
>>> +	memset(layer_masks, 0,
>>> +	       array_size(sizeof((*layer_masks)[0]), num_access));
>>>
>>> -	memset(layer_masks, 0, sizeof(*layer_masks));
>>>    	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>>>    	if (!access_request)
>>>    		return 0;
>>> @@ -636,9 +657,8 @@ init_layer_masks(const struct landlock_ruleset *const domain,
>>>    		const unsigned long access_req = access_request;
>>>    		unsigned long access_bit;
>>>
>>> -		for_each_set_bit(access_bit, &access_req,
>>> -				 ARRAY_SIZE(*layer_masks)) {
>>> -			if (landlock_get_fs_access_mask(domain, layer_level) &
>>> +		for_each_set_bit(access_bit, &access_req, num_access) {
>>> +			if (get_access_mask(domain, layer_level) &
>>>    			    BIT_ULL(access_bit)) {
>>>    				(*layer_masks)[access_bit] |=
>>>    					BIT_ULL(layer_level);
>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index d7d9b987829c..2083855bf42d 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -238,11 +238,12 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>>
>>>    bool unmask_layers(const struct landlock_rule *const rule,
>>>    		   const access_mask_t access_request,
>>> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>> +		   layer_mask_t (*const layer_masks)[],
>>> +		   const size_t masks_array_size);
>>>
>>> -access_mask_t
>>> -init_layer_masks(const struct landlock_ruleset *const domain,
>>> -		 const access_mask_t access_request,
>>> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>>> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>>> +			       const access_mask_t access_request,
>>> +			       layer_mask_t (*const layer_masks)[],
>>> +			       const enum landlock_key_type key_type);
>>>
>>>    #endif /* _SECURITY_LANDLOCK_RULESET_H */
>>> --
>>> 2.25.1
>>>
>> .
