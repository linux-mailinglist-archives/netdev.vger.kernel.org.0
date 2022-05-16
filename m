Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A45528BB7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 19:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiEPRPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 13:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245271AbiEPRPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 13:15:02 -0400
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE3C32ECB
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:14:59 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L25Tr2BskzMqGT4;
        Mon, 16 May 2022 19:14:56 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L25Tq5982zlhSMk;
        Mon, 16 May 2022 19:14:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1652721296;
        bh=ckn2vRizr6EM5+UjPKTmBlUvHZbPFsLH9ffNAx/yOGM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=ZwhU0EKLbg62WOnFcj7+dUUVceRg/jdibH5kyeafrzOJolWTZhVKrEzmO16XqtG+A
         VOjnIEndx54DavkNW/C5XuvOSu7z16gS3/1eBA4+xukrpBvEIE/UUCGIbFpyoZdEnr
         iIpa2hNCGuhNelVu3iUP5+qVpIbErOAmaag3r3Sw=
Message-ID: <ce1201e9-8493-8387-9df4-f0f8b75011c9@digikod.net>
Date:   Mon, 16 May 2022 19:14:55 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-5-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 04/15] landlock: helper functions refactoring
In-Reply-To: <20220516152038.39594-5-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> Unmask_layers(), init_layer_masks() and
> get_handled_accesses() helper functions move to
> ruleset.c and rule_type argument is added.
> This modification supports implementing new rule
> types into next landlock versions.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Splits commit.
> * Refactoring landlock_unmask_layers functions.
> 

Please sort changes in antichronological order. It is easier to look at 
the first lines to get the last changes.

> Changes since v4:
> * Refactoring init_layer_masks(), get_handled_accesses()
> and unmask_layers() functions to support multiple rule types.
> * Refactoring landlock_get_fs_access_mask() function with
> LANDLOCK_MASK_ACCESS_FS mask. >
> ---
>   security/landlock/fs.c      | 158 ++++++++----------------------------
>   security/landlock/ruleset.c | 152 +++++++++++++++++++++++++++++++---
>   security/landlock/ruleset.h |  17 +++-
>   3 files changed, 192 insertions(+), 135 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 5de24d4dd74c..3506e182b23e 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -211,60 +211,6 @@ find_rule(const struct landlock_ruleset *const domain,
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

Moving these entire blocks of code make the review/diff impossible. Why 
moving these helpers?

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
> @@ -277,59 +223,6 @@ static inline bool is_nouser_or_private(const struct dentry *dentry)
>   		unlikely(IS_PRIVATE(d_backing_inode(dentry))));
>   }
> 
> -static inline access_mask_t
> -get_handled_accesses(const struct landlock_ruleset *const domain)
> -{
> -	access_mask_t access_dom = 0;
> -	unsigned long access_bit;
> -
> -	for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
> -	     access_bit++) {
> -		size_t layer_level;
> -
> -		for (layer_level = 0; layer_level < domain->num_layers;
> -				layer_level++) {
> -			if (landlock_get_fs_access_mask(domain, layer_level) &
> -					BIT_ULL(access_bit)) {
> -				access_dom |= BIT_ULL(access_bit);
> -				break;
> -			}
> -		}
> -	}
> -	return access_dom;
> -}
> -
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
> -				ARRAY_SIZE(*layer_masks)) {
> -			if (landlock_get_fs_access_mask(domain, layer_level) &
> -					BIT_ULL(access_bit)) {
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
> @@ -506,7 +399,8 @@ static int check_access_path_dual(
>   		 * a superset of the meaningful requested accesses).
>   		 */
>   		access_masked_parent1 = access_masked_parent2 =
> -			get_handled_accesses(domain);
> +			get_handled_accesses(domain, LANDLOCK_RULE_PATH_BENEATH,
> +					     LANDLOCK_NUM_ACCESS_FS);
>   		is_dom_check = true;
>   	} else {
>   		if (WARN_ON_ONCE(dentry_child1 || dentry_child2))
> @@ -519,17 +413,25 @@ static int check_access_path_dual(
> 
>   	if (unlikely(dentry_child1)) {
>   		unmask_layers(find_rule(domain, dentry_child1),
> -			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child1),
> -			      &_layer_masks_child1);
> +				init_layer_masks(domain,
> +					LANDLOCK_MASK_ACCESS_FS,
> +					&_layer_masks_child1,
> +					sizeof(_layer_masks_child1),
> +					LANDLOCK_RULE_PATH_BENEATH),
> +				&_layer_masks_child1,
> +				ARRAY_SIZE(_layer_masks_child1));

There is a lot of formatting diff and that makes the review difficult. 
Please format everything with clang-format-14.

>   		layer_masks_child1 = &_layer_masks_child1;
>   		child1_is_directory = d_is_dir(dentry_child1);
>   	}
>   	if (unlikely(dentry_child2)) {
>   		unmask_layers(find_rule(domain, dentry_child2),
> -			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -					       &_layer_masks_child2),
> -			      &_layer_masks_child2);
> +				init_layer_masks(domain,
> +					LANDLOCK_MASK_ACCESS_FS,
> +					&_layer_masks_child2,
> +					sizeof(_layer_masks_child2),
> +					LANDLOCK_RULE_PATH_BENEATH),
> +				&_layer_masks_child2,
> +				ARRAY_SIZE(_layer_masks_child2));
>   		layer_masks_child2 = &_layer_masks_child2;
>   		child2_is_directory = d_is_dir(dentry_child2);
>   	}
> @@ -582,14 +484,15 @@ static int check_access_path_dual(
> 
>   		rule = find_rule(domain, walker_path.dentry);
>   		allowed_parent1 = unmask_layers(rule, access_masked_parent1,
> -						layer_masks_parent1);
> +				layer_masks_parent1,
> +				ARRAY_SIZE(*layer_masks_parent1));
>   		allowed_parent2 = unmask_layers(rule, access_masked_parent2,
> -						layer_masks_parent2);
> +				layer_masks_parent2,
> +				ARRAY_SIZE(*layer_masks_parent2));
> 
>   		/* Stops when a rule from each layer grants access. */
>   		if (allowed_parent1 && allowed_parent2)
>   			break;
> -

There is no place for such formatting/whitespace patches.


>   jump_up:
>   		if (walker_path.dentry == walker_path.mnt->mnt_root) {
>   			if (follow_up(&walker_path)) {
> @@ -645,7 +548,9 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
>   {
>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
> 
> -	access_request = init_layer_masks(domain, access_request, &layer_masks);
> +	access_request = init_layer_masks(domain, access_request,
> +			&layer_masks, sizeof(layer_masks),
> +			LANDLOCK_RULE_PATH_BENEATH);
>   	return check_access_path_dual(domain, path, access_request,
>   				      &layer_masks, NULL, 0, NULL, NULL);
>   }
> @@ -729,7 +634,8 @@ static bool collect_domain_accesses(
>   		return true;
> 
>   	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
> -				      layer_masks_dom);
> +			layer_masks_dom, sizeof(*layer_masks_dom),
> +			LANDLOCK_RULE_PATH_BENEATH);
> 
>   	dget(dir);
>   	while (true) {
> @@ -737,7 +643,8 @@ static bool collect_domain_accesses(
> 
>   		/* Gets all layers allowing all domain accesses. */
>   		if (unmask_layers(find_rule(domain, dir), access_dom,
> -				  layer_masks_dom)) {
> +					layer_masks_dom,
> +					ARRAY_SIZE(*layer_masks_dom))) {
>   			/*
>   			 * Stops when all handled accesses are allowed by at
>   			 * least one rule in each layer.
> @@ -851,9 +758,10 @@ static int current_check_refer_path(struct dentry *const old_dentry,
>   		 * The LANDLOCK_ACCESS_FS_REFER access right is not required
>   		 * for same-directory referer (i.e. no reparenting).
>   		 */
> -		access_request_parent1 = init_layer_masks(
> -			dom, access_request_parent1 | access_request_parent2,
> -			&layer_masks_parent1);
> +		access_request_parent1 = init_layer_masks(dom,
> +				access_request_parent1 | access_request_parent2,
> +				&layer_masks_parent1, sizeof(layer_masks_parent1),
> +				LANDLOCK_RULE_PATH_BENEATH);
>   		return check_access_path_dual(dom, new_dir,
>   					      access_request_parent1,
>   					      &layer_masks_parent1, NULL, 0,
> @@ -861,7 +769,9 @@ static int current_check_refer_path(struct dentry *const old_dentry,
>   	}
> 
>   	/* Backward compatibility: no reparenting support. */
> -	if (!(get_handled_accesses(dom) & LANDLOCK_ACCESS_FS_REFER))
> +	if (!(get_handled_accesses(dom, LANDLOCK_RULE_PATH_BENEATH,
> +				   LANDLOCK_NUM_ACCESS_FS) &
> +						LANDLOCK_ACCESS_FS_REFER))
>   		return -EXDEV;
> 
>   	access_request_parent1 |= LANDLOCK_ACCESS_FS_REFER;
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 4b4c9953bb32..c4ed783d655b 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -233,7 +233,8 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   					       &(*layers)[0]);
>   			if (IS_ERR(new_rule))
>   				return PTR_ERR(new_rule);
> -			rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
> +			rb_replace_node(&this->node, &new_rule->node,
> +					&ruleset->root_inode);

This is a pure formatting hunk. :/


>   			free_rule(this, rule_type);
>   			break;
>   		}
> @@ -246,7 +247,8 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   		return -E2BIG;
>   	switch (rule_type) {
>   	case LANDLOCK_RULE_PATH_BENEATH:
> -		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL);
> +		new_rule = create_rule(object_ptr, 0, layers,
> +				       num_layers, NULL);
>   		if (IS_ERR(new_rule))
>   			return PTR_ERR(new_rule);
>   		rb_link_node(&new_rule->node, parent_node, walker_node);
> @@ -281,8 +283,8 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
>   	} };
> 
>   	build_check_layer();
> -	return insert_rule(ruleset, object_ptr, object_data, rule_type, &layers,
> -			   ARRAY_SIZE(layers));
> +	return insert_rule(ruleset, object_ptr, object_data, rule_type,
> +			   &layers, ARRAY_SIZE(layers));
>   }
> 
>   static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
> @@ -335,8 +337,9 @@ static int tree_merge(struct landlock_ruleset *const src,
> 
>   		switch (rule_type) {
>   		case LANDLOCK_RULE_PATH_BENEATH:
> -			err = insert_rule(dst, walker_rule->object.ptr, 0, rule_type,
> -					  &layers, ARRAY_SIZE(layers));
> +			err = insert_rule(dst, walker_rule->object.ptr, 0,
> +					  rule_type, &layers,
> +					  ARRAY_SIZE(layers));
>   			break;
>   		}
>   		if (err)
> @@ -433,9 +436,13 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>   		err = -EINVAL;
>   		goto out_unlock;
>   	}
> -	/* Copies the parent layer stack and leaves a space for the new layer. */
> +	/*
> +	 * Copies the parent layer stack and leaves a space
> +	 * for the new layer.
> +	 */
>   	memcpy(child->access_masks, parent->access_masks,
> -			flex_array_size(parent, access_masks, parent->num_layers));
> +			flex_array_size(parent, access_masks,
> +					parent->num_layers));
> 
>   	if (WARN_ON_ONCE(!parent->hierarchy)) {
>   		err = -EINVAL;
> @@ -455,8 +462,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>   	struct landlock_rule *freeme, *next;
> 
>   	might_sleep();
> -	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
> -			node)
> +	rbtree_postorder_for_each_entry_safe(freeme, next,
> +					     &ruleset->root_inode,
> +					     node)
>   		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
>   	put_hierarchy(ruleset->hierarchy);
>   	kfree(ruleset);
> @@ -577,3 +585,127 @@ const struct landlock_rule *landlock_find_rule(
>   	}
>   	return NULL;
>   }
> +
> +access_mask_t get_handled_accesses(
> +		const struct landlock_ruleset *const domain,
> +		u16 rule_type, u16 num_access)
> +{
> +	access_mask_t access_dom = 0;
> +	unsigned long access_bit;
> +
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		for (access_bit = 0; access_bit < LANDLOCK_NUM_ACCESS_FS;
> +			access_bit++) {
> +			size_t layer_level;
> +
> +			for (layer_level = 0; layer_level < domain->num_layers;
> +					layer_level++) {
> +				if (landlock_get_fs_access_mask(domain,
> +								layer_level) &
> +						BIT_ULL(access_bit)) {
> +					access_dom |= BIT_ULL(access_bit);
> +					break;
> +				}
> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +	return access_dom;
> +}
> +
> +/*
> + * @layer_masks is read and may be updated according to the access request and
> + * the matching rule.
> + *
> + * Returns true if the request is allowed (i.e. relevant layer masks for the
> + * request are empty).
> + */
> +bool unmask_layers(const struct landlock_rule *const rule,
> +		const access_mask_t access_request,
> +		layer_mask_t (*const layer_masks)[], size_t masks_array_size)
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
> +		for_each_set_bit(access_bit, &access_req, masks_array_size) {
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
> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
> +			       const access_mask_t access_request,
> +			       layer_mask_t (*const layer_masks)[],
> +			       size_t masks_size,
> +			       u16 rule_type)
> +{
> +	access_mask_t handled_accesses = 0;
> +	size_t layer_level;
> +
> +	memset(layer_masks, 0, masks_size);
> +
> +	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
> +	if (!access_request)
> +		return 0;
> +
> +	/* Saves all handled accesses per layer. */
> +	for (layer_level = 0; layer_level < domain->num_layers;
> +			layer_level++) {
> +		const unsigned long access_req = access_request;
> +		unsigned long access_bit;
> +
> +		switch (rule_type) {
> +		case LANDLOCK_RULE_PATH_BENEATH:
> +			for_each_set_bit(access_bit, &access_req,
> +					LANDLOCK_NUM_ACCESS_FS) {
> +				if (landlock_get_fs_access_mask(domain,
> +								layer_level) &
> +						BIT_ULL(access_bit)) {
> +					(*layer_masks)[access_bit] |=
> +						BIT_ULL(layer_level);
> +					handled_accesses |=
> +							   BIT_ULL(access_bit);
> +				}
> +			}
> +			break;
> +		default:
> +			return 0;
> +		}
> +	}
> +	return handled_accesses;
> +}
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 3066e5d7180c..f3cd890d0348 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -195,7 +195,22 @@ static inline u32 landlock_get_fs_access_mask(
>   					const struct landlock_ruleset *ruleset,
>   					u16 mask_level)
>   {
> -	return ruleset->access_masks[mask_level];
> +	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
>   }
> 
> +access_mask_t get_handled_accesses(
> +		const struct landlock_ruleset *const domain,
> +		u16 rule_type, u16 num_access);
> +
> +bool unmask_layers(const struct landlock_rule *const rule,
> +		   const access_mask_t access_request,
> +		   layer_mask_t (*const layer_masks)[],
> +		   size_t masks_array_size);
> +
> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
> +			       const access_mask_t access_request,
> +			       layer_mask_t (*const layer_masks)[],
> +			       size_t masks_size,
> +			       u16 rule_type);

These declarations are useless.

> +
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
> --
> 2.25.1
> 
