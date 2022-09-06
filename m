Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F205AE239
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbiIFINK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238788AbiIFINH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:13:07 -0400
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7300018B23
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:13:06 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ0H0VPFzMqj7F;
        Tue,  6 Sep 2022 10:07:43 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ0G34bbz14N;
        Tue,  6 Sep 2022 10:07:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451663;
        bh=xeEK5HMoF1L0Ly/rMbGWswVtm2ZNbvOfvJi+G4TibCE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kF+Z/ihyc2m09pLpJXh01JWwS5A/PDo9CkYG6XfqxQ/o/k7pLMw6KC1X2MbWuNiof
         P/VH9uxanq5npoKWN62DEhmktzHkrYtK6PsCKyTJUitUBqD9GC76gCGyqUOOjME7Sy
         mt0jrOA8Bbw3ITjF4ZukfCo3fNnyY5dNmlUjKCtY=
Message-ID: <e7f8bc8d-0dc4-ce28-80bc-447b2219c70d@digikod.net>
Date:   Tue, 6 Sep 2022 10:07:41 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 05/18] landlock: refactor helper functions
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-6-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-6-konstantin.meskhidze@huawei.com>
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

You can improve the subject with: "landlock: Refactor unmask_layers() 
and init_layer_masks()"

On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> Adds new key_type argument to init_layer_masks() helper functions.
> This modification supports implementing new rule types in the next
> Landlock versions.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

As for patch 2/18, you can append:
Co-developed-by: Mickaël Salaün <mic@digikod.net>


> ---
> 
> Changes since v6:
> * Removes masks_size attribute from init_layer_masks().
> * Refactors init_layer_masks() with new landlock_key_type.
> 
> Changes since v5:
> * Splits commit.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors init_layer_masks(), get_handled_accesses()
> and unmask_layers() functions to support multiple rule types.
> * Refactors landlock_get_fs_access_mask() function with
> LANDLOCK_MASK_ACCESS_FS mask.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_unmask_layers functions.
> 
> ---
>   security/landlock/fs.c      | 33 +++++++++++++++++-----------
>   security/landlock/ruleset.c | 44 +++++++++++++++++++++++++++----------
>   security/landlock/ruleset.h | 11 +++++-----
>   3 files changed, 58 insertions(+), 30 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index b03d6153f628..a4d9aea539cd 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -439,16 +439,20 @@ static int check_access_path_dual(
>   	if (unlikely(dentry_child1)) {
>   		unmask_layers(find_rule(domain, dentry_child1),
>   			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child1),
> -			      &_layer_masks_child1);
> +					       &_layer_masks_child1,
> +					       LANDLOCK_KEY_INODE),
> +			      &_layer_masks_child1,
> +			      ARRAY_SIZE(_layer_masks_child1));
>   		layer_masks_child1 = &_layer_masks_child1;
>   		child1_is_directory = d_is_dir(dentry_child1);
>   	}
>   	if (unlikely(dentry_child2)) {
>   		unmask_layers(find_rule(domain, dentry_child2),
>   			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child2),
> -			      &_layer_masks_child2);
> +					       &_layer_masks_child2,
> +					       LANDLOCK_KEY_INODE),
> +			      &_layer_masks_child2,
> +			      ARRAY_SIZE(_layer_masks_child2));
>   		layer_masks_child2 = &_layer_masks_child2;
>   		child2_is_directory = d_is_dir(dentry_child2);
>   	}
> @@ -500,15 +504,16 @@ static int check_access_path_dual(
>   		}
> 
>   		rule = find_rule(domain, walker_path.dentry);
> -		allowed_parent1 = unmask_layers(rule, access_masked_parent1,
> -						layer_masks_parent1);
> -		allowed_parent2 = unmask_layers(rule, access_masked_parent2,
> -						layer_masks_parent2);
> +		allowed_parent1 = unmask_layers(
> +			rule, access_masked_parent1, layer_masks_parent1,
> +			ARRAY_SIZE(*layer_masks_parent1));
> +		allowed_parent2 = unmask_layers(
> +			rule, access_masked_parent2, layer_masks_parent2,
> +			ARRAY_SIZE(*layer_masks_parent2));
> 
>   		/* Stops when a rule from each layer grants access. */
>   		if (allowed_parent1 && allowed_parent2)
>   			break;
> -
>   jump_up:
>   		if (walker_path.dentry == walker_path.mnt->mnt_root) {
>   			if (follow_up(&walker_path)) {
> @@ -564,7 +569,8 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
>   {
>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
> 
> -	access_request = init_layer_masks(domain, access_request, &layer_masks);
> +	access_request = init_layer_masks(domain, access_request, &layer_masks,
> +					  LANDLOCK_KEY_INODE);
>   	return check_access_path_dual(domain, path, access_request,
>   				      &layer_masks, NULL, 0, NULL, NULL);
>   }
> @@ -648,7 +654,7 @@ static bool collect_domain_accesses(
>   		return true;
> 
>   	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -				      layer_masks_dom);
> +				      layer_masks_dom, LANDLOCK_KEY_INODE);
> 
>   	dget(dir);
>   	while (true) {
> @@ -656,7 +662,8 @@ static bool collect_domain_accesses(
> 
>   		/* Gets all layers allowing all domain accesses. */
>   		if (unmask_layers(find_rule(domain, dir), access_dom,
> -				  layer_masks_dom)) {
> +				  layer_masks_dom,
> +				  ARRAY_SIZE(*layer_masks_dom))) {
>   			/*
>   			 * Stops when all handled accesses are allowed by at
>   			 * least one rule in each layer.
> @@ -772,7 +779,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
>   		 */
>   		access_request_parent1 = init_layer_masks(
>   			dom, access_request_parent1 | access_request_parent2,
> -			&layer_masks_parent1);
> +			&layer_masks_parent1, LANDLOCK_KEY_INODE);
>   		return check_access_path_dual(dom, new_dir,
>   					      access_request_parent1,
>   					      &layer_masks_parent1, NULL, 0,
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 671a95e2a345..84fcd8eb30d4 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -574,7 +574,8 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>    */

You missed another hunk from my patch… Please do a diff with it.


>   bool unmask_layers(const struct landlock_rule *const rule,
>   		   const access_mask_t access_request,
> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +		   layer_mask_t (*const layer_masks)[],
> +		   const size_t masks_array_size)
>   {
>   	size_t layer_level;
> 
> @@ -606,8 +607,7 @@ bool unmask_layers(const struct landlock_rule *const rule,
>   		 * requested access.
>   		 */
>   		is_empty = true;
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> +		for_each_set_bit(access_bit, &access_req, masks_array_size) {
>   			if (layer->access & BIT_ULL(access_bit))
>   				(*layer_masks)[access_bit] &= ~layer_bit;
>   			is_empty = is_empty && !(*layer_masks)[access_bit];
> @@ -618,15 +618,36 @@ bool unmask_layers(const struct landlock_rule *const rule,
>   	return false;
>   }
> 
> -access_mask_t
> -init_layer_masks(const struct landlock_ruleset *const domain,
> -		 const access_mask_t access_request,
> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
> +typedef access_mask_t
> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
> +		  const u16 layer_level);
> +
> +/*
> + * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
> + * elements according to @key_type.
> + */
> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
> +			       const access_mask_t access_request,
> +			       layer_mask_t (*const layer_masks)[],
> +			       const enum landlock_key_type key_type)
>   {
>   	access_mask_t handled_accesses = 0;
> -	size_t layer_level;
> +	size_t layer_level, num_access;
> +	get_access_mask_t *get_access_mask;
> +
> +	switch (key_type) {
> +	case LANDLOCK_KEY_INODE:
> +		get_access_mask = landlock_get_fs_access_mask;
> +		num_access = LANDLOCK_NUM_ACCESS_FS;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +
> +	memset(layer_masks, 0,
> +	       array_size(sizeof((*layer_masks)[0]), num_access));
> 
> -	memset(layer_masks, 0, sizeof(*layer_masks));
>   	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>   	if (!access_request)
>   		return 0;
> @@ -636,9 +657,8 @@ init_layer_masks(const struct landlock_ruleset *const domain,
>   		const unsigned long access_req = access_request;
>   		unsigned long access_bit;
> 
> -		for_each_set_bit(access_bit, &access_req,
> -				 ARRAY_SIZE(*layer_masks)) {
> -			if (landlock_get_fs_access_mask(domain, layer_level) &
> +		for_each_set_bit(access_bit, &access_req, num_access) {
> +			if (get_access_mask(domain, layer_level) &
>   			    BIT_ULL(access_bit)) {
>   				(*layer_masks)[access_bit] |=
>   					BIT_ULL(layer_level);
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index d7d9b987829c..2083855bf42d 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -238,11 +238,12 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
> 
>   bool unmask_layers(const struct landlock_rule *const rule,
>   		   const access_mask_t access_request,
> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +		   layer_mask_t (*const layer_masks)[],
> +		   const size_t masks_array_size);
> 
> -access_mask_t
> -init_layer_masks(const struct landlock_ruleset *const domain,
> -		 const access_mask_t access_request,
> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
> +			       const access_mask_t access_request,
> +			       layer_mask_t (*const layer_masks)[],
> +			       const enum landlock_key_type key_type);
> 
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
> --
> 2.25.1
> 
