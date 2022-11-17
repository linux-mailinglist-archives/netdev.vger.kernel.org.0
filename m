Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B4D62E496
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbiKQSmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240723AbiKQSl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:41:58 -0500
X-Greylist: delayed 101756 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 10:41:57 PST
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [45.157.188.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB32F7DEC7;
        Thu, 17 Nov 2022 10:41:56 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NCpfm5FmmzMqCFG;
        Thu, 17 Nov 2022 19:41:52 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NCpfm0mPczMppDw;
        Thu, 17 Nov 2022 19:41:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1668710512;
        bh=Web/VWyBzSHpdYnBYLcQhi9KkTWaM1XVpldHeLCVm84=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ktn8502sIoMvwMpcc41VhHd+fdrmy7JEADiHPDhk2U71cKQE9S/VFaHQC4/616CfT
         HBFZIeY//B4SCn+fRwft47vDpoUWvXjp4fed0aPeyAykgdHctmQTg2Bh7KGHeSi+Gb
         Mzhq8OCEocWNL/qeucscd26SaGTw+SvDOPh31+jw=
Message-ID: <85898d3b-9ef6-6fb7-6d9b-d6766a58b9ab@digikod.net>
Date:   Thu, 17 Nov 2022 19:41:51 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 03/12] landlock: Refactor merge/inherit_ruleset
 functions
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20221021152644.155136-4-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/10/2022 17:26, Konstantin Meskhidze wrote:
> Refactors merge_ruleset() and inherit_ruleset() functions to support

Refactor…

> new rule types. This patch adds merge_tree() and inherit_tree()
> helpers.

> Each has key_type argument to choose a particular rb_tree

They use a specific ruleset's red-black tree according to a key type 
argument.

> structure in a ruleset.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
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
>   security/landlock/ruleset.c | 108 ++++++++++++++++++++++++------------
>   1 file changed, 73 insertions(+), 35 deletions(-)
> 
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 41de17d1869e..961ffe0c709e 100644
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
> @@ -340,7 +326,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   		} };
>   		const struct landlock_id id = {
>   			.key = walker_rule->key,
> -			.type = LANDLOCK_KEY_INODE,
> +			.type = key_type,
>   		};
> 
>   		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
> @@ -351,8 +337,39 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
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
> @@ -360,43 +377,64 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
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
> +	lockdep_assert_held(&parent->lock);

lockdep_assert_held(&child->lock);
