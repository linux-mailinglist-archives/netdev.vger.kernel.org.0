Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899665AE1E0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiIFIHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbiIFIHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:07:37 -0400
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc08])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BA4330E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:07:36 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ044HqczMqMsY;
        Tue,  6 Sep 2022 10:07:32 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ035ZT5zMppMh;
        Tue,  6 Sep 2022 10:07:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451652;
        bh=95QP+y/uWwszsqq+9ibBFlDngjyuLLXwGoiOtSfBSZM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aspeTElIE3tY0+/iiSbnQMzhkLMBIC1gOgUv1zjTVz2vhF1nZ9I9uPCXyVmIsU/D+
         RopNhFFcRBc66qX+PMQiM9Rz2XSUCaDJ2X4ufKeeIHoCT0bjmgrgVDfu3x6lbZIZ38
         zViszp/8IzEYfmou3PSivrkfGCvMtxnqtLvAR/Lk=
Message-ID: <2299f034-e6f2-051c-97e3-bf93a0916a50@digikod.net>
Date:   Tue, 6 Sep 2022 10:07:31 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 04/18] landlock: move helper functions
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-5-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-5-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You can make the subject more informative with "landlock: Move 
unmask_layers() and init_layer_masks()".


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> This patch moves unmask_layers() and init_layer_masks() helpers
> to ruleset.c to share with landlock network implementation in
> following commits.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * Moves get_handled_accesses() helper from ruleset.c back to fs.c,
>    cause it's not used in coming network commits.
> 
> Changes since v5:
> * Splits commit.
> * Moves init_layer_masks() and get_handled_accesses() helpers
> to ruleset.c and makes then non-static.
> * Formats code with clang-format-14.
> 
> ---
>   security/landlock/fs.c      | 85 -------------------------------------
>   security/landlock/ruleset.c | 84 ++++++++++++++++++++++++++++++++++++
>   security/landlock/ruleset.h | 10 +++++
>   3 files changed, 94 insertions(+), 85 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index cca87fcd222d..b03d6153f628 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -215,60 +215,6 @@ find_rule(const struct landlock_ruleset *const domain,
>   	return rule;
>   }
> 
> -/*
> - * @layer_masks is read and may be updated according to the access request and
> - * the matching rule.
> - *
> - * Returns true if the request is allowed (i.e. relevant layer masks for the
> - * request are empty).
> - */
> -static inline bool
> -unmask_layers(const struct landlock_rule *const rule,
> -	      const access_mask_t access_request,
> -	      layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> -{
> -	size_t layer_level;
> -
> -	if (!access_request || !layer_masks)
> -		return true;
> -	if (!rule)
> -		return false;
> -
> -	/*
> -	 * An access is granted if, for each policy layer, at least one rule
> -	 * encountered on the pathwalk grants the requested access,
> -	 * regardless of its position in the layer stack.  We must then check
> -	 * the remaining layers for each inode, from the first added layer to
> -	 * the last one.  When there is multiple requested accesses, for each
> -	 * policy layer, the full set of requested accesses may not be granted
> -	 * by only one rule, but by the union (binary OR) of multiple rules.
> -	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
> -	 */
> -	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
> -		const struct landlock_layer *const layer =
> -			&rule->layers[layer_level];
> -		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
> -		const unsigned long access_req = access_request;
> -		unsigned long access_bit;
> -		bool is_empty;
> -
> -		/*
> -		 * Records in @layer_masks which layer grants access to each
> -		 * requested access.
> -		 */
> -		is_empty = true;
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> -			if (layer->access & BIT_ULL(access_bit))
> -				(*layer_masks)[access_bit] &= ~layer_bit;
> -			is_empty = is_empty && !(*layer_masks)[access_bit];
> -		}
> -		if (is_empty)
> -			return true;
> -	}
> -	return false;
> -}
> -
>   /*
>    * Allows access to pseudo filesystems that will never be mountable (e.g.
>    * sockfs, pipefs), but can still be reachable through
> @@ -303,37 +249,6 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
>   	return access_dom;
>   }
> 
> -static inline access_mask_t
> -init_layer_masks(const struct landlock_ruleset *const domain,
> -		 const access_mask_t access_request,
> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> -{
> -	access_mask_t handled_accesses = 0;
> -	size_t layer_level;
> -
> -	memset(layer_masks, 0, sizeof(*layer_masks));
> -	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
> -	if (!access_request)
> -		return 0;
> -
> -	/* Saves all handled accesses per layer. */
> -	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
> -		const unsigned long access_req = access_request;
> -		unsigned long access_bit;
> -
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> -			if (landlock_get_fs_access_mask(domain, layer_level) &
> -			    BIT_ULL(access_bit)) {
> -				(*layer_masks)[access_bit] |=
> -					BIT_ULL(layer_level);
> -				handled_accesses |= BIT_ULL(access_bit);
> -			}
> -		}
> -	}
> -	return handled_accesses;
> -}
> -
>   /*
>    * Check that a destination file hierarchy has more restrictions than a source
>    * file hierarchy.  This is only used for link and rename actions.
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 3a5ef356aaa3..671a95e2a345 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -564,3 +564,87 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>   	}
>   	return NULL;
>   }
> +
> +/*
> + * @layer_masks is read and may be updated according to the access request and
> + * the matching rule.
> + *
> + * Returns true if the request is allowed (i.e. relevant layer masks for the
> + * request are empty).
> + */
> +bool unmask_layers(const struct landlock_rule *const rule,
> +		   const access_mask_t access_request,
> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +{
> +	size_t layer_level;
> +
> +	if (!access_request || !layer_masks)
> +		return true;
> +	if (!rule)
> +		return false;
> +
> +	/*
> +	 * An access is granted if, for each policy layer, at least one rule
> +	 * encountered on the pathwalk grants the requested access,
> +	 * regardless of its position in the layer stack.  We must then check
> +	 * the remaining layers for each inode, from the first added layer to
> +	 * the last one.  When there is multiple requested accesses, for each
> +	 * policy layer, the full set of requested accesses may not be granted
> +	 * by only one rule, but by the union (binary OR) of multiple rules.
> +	 * E.g. /a/b <execute> + /a <read> => /a/b <execute + read>
> +	 */
> +	for (layer_level = 0; layer_level < rule->num_layers; layer_level++) {
> +		const struct landlock_layer *const layer =
> +			&rule->layers[layer_level];
> +		const layer_mask_t layer_bit = BIT_ULL(layer->level - 1);
> +		const unsigned long access_req = access_request;
> +		unsigned long access_bit;
> +		bool is_empty;
> +
> +		/*
> +		 * Records in @layer_masks which layer grants access to each
> +		 * requested access.
> +		 */
> +		is_empty = true;
> +		for_each_set_bit(access_bit, &access_req,
> +				 ARRAY_SIZE(*layer_masks)) {
> +			if (layer->access & BIT_ULL(access_bit))
> +				(*layer_masks)[access_bit] &= ~layer_bit;
> +			is_empty = is_empty && !(*layer_masks)[access_bit];
> +		}
> +		if (is_empty)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +access_mask_t
> +init_layer_masks(const struct landlock_ruleset *const domain,
> +		 const access_mask_t access_request,
> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +{
> +	access_mask_t handled_accesses = 0;
> +	size_t layer_level;
> +
> +	memset(layer_masks, 0, sizeof(*layer_masks));
> +	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
> +	if (!access_request)
> +		return 0;
> +
> +	/* Saves all handled accesses per layer. */
> +	for (layer_level = 0; layer_level < domain->num_layers; layer_level++) {
> +		const unsigned long access_req = access_request;
> +		unsigned long access_bit;
> +
> +		for_each_set_bit(access_bit, &access_req,
> +				 ARRAY_SIZE(*layer_masks)) {
> +			if (landlock_get_fs_access_mask(domain, layer_level) &
> +			    BIT_ULL(access_bit)) {
> +				(*layer_masks)[access_bit] |=
> +					BIT_ULL(layer_level);
> +				handled_accesses |= BIT_ULL(access_bit);
> +			}
> +		}
> +	}
> +	return handled_accesses;
> +}
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index bb1408cc8dd2..d7d9b987829c 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -235,4 +235,14 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   		LANDLOCK_SHIFT_ACCESS_FS) &
>   	       LANDLOCK_MASK_ACCESS_FS;
>   }
> +
> +bool unmask_layers(const struct landlock_rule *const rule,
> +		   const access_mask_t access_request,
> +		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +
> +access_mask_t
> +init_layer_masks(const struct landlock_ruleset *const domain,
> +		 const access_mask_t access_request,
> +		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
> --
> 2.25.1
> 
