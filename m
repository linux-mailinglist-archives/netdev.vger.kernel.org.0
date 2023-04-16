Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F846E3A25
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjDPQJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjDPQJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:09:57 -0400
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542AD2115
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:09:55 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwB766kzzMpqwT;
        Sun, 16 Apr 2023 18:09:51 +0200 (CEST)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwB64lqvzMpnPl;
        Sun, 16 Apr 2023 18:09:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661391;
        bh=Fjt3KwyGUeXYnsyCOyzBSVeFvswxdPFD95xkQS+s5Is=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Uya7BOsK1ZjWiPHtQjkphf9ol923mfDVJC92aQENBgtyRwz7VyPkpZFokBZAViQcE
         vs+Exz4yfRZ+sXs9TDgJLg1cQJEW84Om5ViG3nbD1yopndRX9RG/NYNwwnyJnJWHQf
         rhs/tjytiwyZP78zIlpoIQQBYVdMc3IfL8SpLMuk=
Message-ID: <8b2f2e0f-0a95-ef87-7eb2-286e75a62e2c@digikod.net>
Date:   Sun, 16 Apr 2023 18:09:57 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 05/13] landlock: Refactor merge/inherit_ruleset
 functions
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-6-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-6-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> Refactor merge_ruleset() and inherit_ruleset() functions to support
> new rule types. This patch adds merge_tree() and inherit_tree()
> helpers. They use a specific ruleset's red-black tree according to
> a key type argument.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * None
> 
> Changes since v8:
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v7:
> * Adds missed lockdep_assert_held it inherit_tree() and merge_tree().
> * Fixes comment.
> 
> Changes since v6:
> * Refactors merge_ruleset() and inherit_ruleset() functions to support
>    new rule types.
> * Renames tree_merge() to merge_tree() (and reorder arguments), and
>    tree_copy() to inherit_tree().
> 
> Changes since v5:
> * Refactors some logic errors.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * None
> 
> ---
>   security/landlock/ruleset.c | 110 ++++++++++++++++++++++++------------
>   1 file changed, 73 insertions(+), 37 deletions(-)
> 
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index d3859d5e7306..2579c9bbedbc 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -302,36 +302,22 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
>   	}
>   }
> 
> -static int merge_ruleset(struct landlock_ruleset *const dst,
> -			 struct landlock_ruleset *const src)
> +static int merge_tree(struct landlock_ruleset *const dst,
> +		      struct landlock_ruleset *const src,
> +		      const enum landlock_key_type key_type)
>   {
>   	struct landlock_rule *walker_rule, *next_rule;
>   	struct rb_root *src_root;
>   	int err = 0;
> 
>   	might_sleep();
> -	/* Should already be checked by landlock_merge_ruleset() */
> -	if (WARN_ON_ONCE(!src))
> -		return 0;
> -	/* Only merge into a domain. */
> -	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
> -		return -EINVAL;
> +	lockdep_assert_held(&dst->lock);
> +	lockdep_assert_held(&src->lock);
> 
> -	src_root = get_root(src, LANDLOCK_KEY_INODE);
> +	src_root = get_root(src, key_type);
>   	if (IS_ERR(src_root))
>   		return PTR_ERR(src_root);
> 
> -	/* Locks @dst first because we are its only owner. */
> -	mutex_lock(&dst->lock);
> -	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
> -
> -	/* Stacks the new layer. */
> -	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
> -		err = -EINVAL;
> -		goto out_unlock;
> -	}
> -	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
> -
>   	/* Merges the @src tree. */
>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
>   					     node) {
> @@ -340,23 +326,52 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   		} };
>   		const struct landlock_id id = {
>   			.key = walker_rule->key,
> -			.type = LANDLOCK_KEY_INODE,
> +			.type = key_type,
>   		};
> 
>   		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
>   			err = -EINVAL;
> -			goto out_unlock;

This should be replaced with `return -EINVAL;` and the `{` `}` after the 
if condition are not needed anymore.


>   		}
>   		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
>   			err = -EINVAL;
> -			goto out_unlock;

ditto

>   		}
>   		layers[0].access = walker_rule->layers[0].access;
> 
>   		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
>   		if (err)
> -			goto out_unlock;
> +			return err;
> +	}
> +	return err;
> +}
> +
> +static int merge_ruleset(struct landlock_ruleset *const dst,
> +			 struct landlock_ruleset *const src)
> +{
> +	int err = 0;
> +
> +	might_sleep();
> +	/* Should already be checked by landlock_merge_ruleset() */
> +	if (WARN_ON_ONCE(!src))
> +		return 0;
> +	/* Only merge into a domain. */
> +	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
> +		return -EINVAL;
> +
> +	/* Locks @dst first because we are its only owner. */
> +	mutex_lock(&dst->lock);
> +	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
> +
> +	/* Stacks the new layer. */
> +	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
> +		err = -EINVAL;
> +		goto out_unlock;
>   	}
> +	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
> +
> +	/* Merges the @src inode tree. */
> +	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
> +	if (err)
> +		goto out_unlock;
> 
>   out_unlock:
>   	mutex_unlock(&src->lock);
> @@ -364,43 +379,64 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   	return err;
>   }
> 
> -static int inherit_ruleset(struct landlock_ruleset *const parent,
> -			   struct landlock_ruleset *const child)
> +static int inherit_tree(struct landlock_ruleset *const parent,
> +			struct landlock_ruleset *const child,
> +			const enum landlock_key_type key_type)
>   {
>   	struct landlock_rule *walker_rule, *next_rule;
>   	struct rb_root *parent_root;
>   	int err = 0;
> 
>   	might_sleep();
> -	if (!parent)
> -		return 0;
> +	lockdep_assert_held(&parent->lock);
> +	lockdep_assert_held(&child->lock);
> 
> -	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
> +	parent_root = get_root(parent, key_type);
>   	if (IS_ERR(parent_root))
>   		return PTR_ERR(parent_root);
> 
> -	/* Locks @child first because we are its only owner. */
> -	mutex_lock(&child->lock);
> -	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
> -
> -	/* Copies the @parent tree. */
> +	/* Copies the @parent inode or network tree. */
>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
>   					     parent_root, node) {
>   		const struct landlock_id id = {
>   			.key = walker_rule->key,
> -			.type = LANDLOCK_KEY_INODE,
> +			.type = key_type,
>   		};
> +
>   		err = insert_rule(child, id, &walker_rule->layers,
>   				  walker_rule->num_layers);
>   		if (err)
> -			goto out_unlock;
> +			return err;
>   	}
> +	return err;
> +}
> +
> +static int inherit_ruleset(struct landlock_ruleset *const parent,
> +			   struct landlock_ruleset *const child)
> +{
> +	int err = 0;
> +
> +	might_sleep();
> +	if (!parent)
> +		return 0;
> +
> +	/* Locks @child first because we are its only owner. */
> +	mutex_lock(&child->lock);
> +	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
> +
> +	/* Copies the @parent inode tree. */
> +	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
> +	if (err)
> +		goto out_unlock;
> 
>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>   		err = -EINVAL;
>   		goto out_unlock;
>   	}
> -	/* Copies the parent layer stack and leaves a space for the new layer. */
> +	/*
> +	 * Copies the parent layer stack and leaves a space
> +	 * for the new layer.
> +	 */
>   	memcpy(child->access_masks, parent->access_masks,
>   	       flex_array_size(parent, access_masks, parent->num_layers));
> 
> --
> 2.25.1
> 
