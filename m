Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE8D5AE1F0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiIFIJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiIFIIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:08:51 -0400
X-Greylist: delayed 96 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Sep 2022 01:08:48 PDT
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [185.125.25.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E72A52E7E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:08:48 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ1V7499zMpvC1;
        Tue,  6 Sep 2022 10:08:46 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ1V1jCdzMppMk;
        Tue,  6 Sep 2022 10:08:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451726;
        bh=SV2HdLdmR7X33EKl1Bu74hIg/BGfH+6BscyQdmft/V8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rrdmWGSrdMwgGRTyDjU0BO4dshIxuSS6T/WxzlKFstSOq7OzX4wpnQt3kL/U5uobV
         X83wnaeOoQr9ZcOGBuGrpdHVHIfTFxh3zMc6z+671S1VPHLbxVyLDcLn+O9p+8C7CE
         Nqm7h12bcQ7NUdXQiz9Bj13x/5DAyRh8rCZ84H+g=
Message-ID: <9cf95acb-14a0-0900-c5af-c910de80e289@digikod.net>
Date:   Tue, 6 Sep 2022 10:08:45 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 08/18] landlock: add network rules support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-9-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-9-konstantin.meskhidze@huawei.com>
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


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> This commit adds network rules support in internal landlock functions
> (presented in ruleset.c) and landlock_create_ruleset syscall.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>    because it OR values.
> * Makes landlock_add_net_access_mask() more resilient incorrect values.
> * Refactors landlock_get_net_access_mask().
> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>    LANDLOCK_NUM_ACCESS_FS as value.
> * Updates access_masks_t to u32 to support network access actions.
> * Refactors landlock internal functions to support network actions with
>    landlock_key/key_type/id types.
> 
> Changes since v5:
> * Gets rid of partial revert from landlock_add_rule
> syscall.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors landlock_create_ruleset() - splits ruleset and
> masks checks.
> * Refactors landlock_create_ruleset() and landlock mask
> setters/getters to support two rule types.
> * Refactors landlock_add_rule syscall add_rule_path_beneath
> function by factoring out get_ruleset_from_fd() and
> landlock_put_ruleset().
> 
> Changes since v3:
> * Splits commit.
> * Adds network rule support for internal landlock functions.
> * Adds set_mask and get_mask for network.
> * Adds rb_root root_net_port.
> 
> ---
>   security/landlock/limits.h   |  6 +++++-
>   security/landlock/ruleset.c  | 38 +++++++++++++++++++++++++++++----
>   security/landlock/ruleset.h  | 41 ++++++++++++++++++++++++++++++++++--
>   security/landlock/syscalls.c |  8 ++++++-
>   4 files changed, 85 insertions(+), 8 deletions(-)
> 
> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
> index bafb3b8dc677..8a1a6463c64e 100644
> --- a/security/landlock/limits.h
> +++ b/security/landlock/limits.h
> @@ -23,6 +23,10 @@
>   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>   #define LANDLOCK_SHIFT_ACCESS_FS	0
> 
> -/* clang-format on */
> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
> 
> +/* clang-format on */
>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 84fcd8eb30d4..442f212039df 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -36,6 +36,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   	refcount_set(&new_ruleset->usage, 1);
>   	mutex_init(&new_ruleset->lock);
>   	new_ruleset->root_inode = RB_ROOT;
> +	new_ruleset->root_net_port = RB_ROOT;
>   	new_ruleset->num_layers = num_layers;
>   	/*
>   	 * hierarchy = NULL
> @@ -46,16 +47,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   }
> 
>   struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t fs_access_mask)
> +landlock_create_ruleset(const access_mask_t fs_access_mask,
> +			const access_mask_t net_access_mask)
>   {
>   	struct landlock_ruleset *new_ruleset;
> 
>   	/* Informs about useless ruleset. */
> -	if (!fs_access_mask)
> +	if (!fs_access_mask && !net_access_mask)
>   		return ERR_PTR(-ENOMSG);
>   	new_ruleset = create_ruleset(1);
> -	if (!IS_ERR(new_ruleset))
> +	if (IS_ERR(new_ruleset))
> +		return new_ruleset;
> +	if (fs_access_mask)
>   		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
> +	if (net_access_mask)
> +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>   	return new_ruleset;
>   }
> 
> @@ -73,6 +79,8 @@ static inline bool is_object_pointer(const enum landlock_key_type key_type)
>   	switch (key_type) {
>   	case LANDLOCK_KEY_INODE:
>   		return true;
> +	case LANDLOCK_KEY_NET_PORT:
> +		return false;
>   	}
>   	WARN_ON_ONCE(1);
>   	return false;
> @@ -126,6 +134,9 @@ static inline struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>   	case LANDLOCK_KEY_INODE:
>   		root = &ruleset->root_inode;
>   		break;
> +	case LANDLOCK_KEY_NET_PORT:
> +		root = &ruleset->root_net_port;
> +		break;
>   	}
>   	if (WARN_ON_ONCE(!root))
>   		return ERR_PTR(-EINVAL);
> @@ -154,7 +165,9 @@ static void build_check_ruleset(void)
>   	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>   	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>   	BUILD_BUG_ON(access_masks <
> -		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
> +		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) +
> +			     (LANDLOCK_MASK_ACCESS_NET
> +			      << LANDLOCK_SHIFT_ACCESS_NET));
>   }
> 
>   /**
> @@ -367,6 +380,11 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   	if (err)
>   		goto out_unlock;
> 
> +	/* Merges the @src network port tree. */
> +	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
> +	if (err)
> +		goto out_unlock;
> +
>   out_unlock:
>   	mutex_unlock(&src->lock);
>   	mutex_unlock(&dst->lock);
> @@ -419,6 +437,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>   	if (err)
>   		goto out_unlock;
> 
> +	/* Copies the @parent network port tree. */
> +	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
> +	if (err)
> +		goto out_unlock;
> +
>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>   		err = -EINVAL;
>   		goto out_unlock;
> @@ -451,6 +474,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>   	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
>   					     node)
>   		free_rule(freeme, LANDLOCK_KEY_INODE);
> +	rbtree_postorder_for_each_entry_safe(freeme, next,
> +					     &ruleset->root_net_port, node)
> +		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
>   	put_hierarchy(ruleset->hierarchy);
>   	kfree(ruleset);
>   }
> @@ -640,6 +666,10 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>   		get_access_mask = landlock_get_fs_access_mask;
>   		num_access = LANDLOCK_NUM_ACCESS_FS;
>   		break;
> +	case LANDLOCK_KEY_NET_PORT:
> +		get_access_mask = landlock_get_net_access_mask;
> +		num_access = LANDLOCK_NUM_ACCESS_NET;
> +		break;
>   	default:
>   		WARN_ON_ONCE(1);
>   		return 0;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 2083855bf42d..d456ee90b648 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -26,7 +26,7 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>   static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
> 
>   /* Ruleset access masks. */
> -typedef u16 access_masks_t;
> +typedef u32 access_masks_t;
>   /* Makes sure all ruleset access rights can be stored. */
>   static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);

There is some fixes missing from my patch.


> 
> @@ -66,6 +66,11 @@ enum landlock_key_type {
>   	 * keys.
>   	 */
>   	LANDLOCK_KEY_INODE = 1,


#if IS_ENABLED(CONFIG_INET)

> +	/**
> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
> +	 * node keys.
> +	 */
> +	LANDLOCK_KEY_NET_PORT = 2,

#endif /* IS_ENABLED(CONFIG_INET) */

And then all use of LANDLOCK_KEY_NET_PORT should be surrounded by the 
same check (but not directly in the net.c file).


>   };
> 
>   /**
> @@ -133,6 +138,12 @@ struct landlock_ruleset {
>   	 * reaches zero.
>   	 */
>   	struct rb_root root_inode;

#if IS_ENABLED(CONFIG_INET)

> +	/**
> +	 * @root_net_port: Root of a red-black tree containing object nodes
> +	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
> +	 * this tree is immutable until @usage reaches zero.
> +	 */

There is some fixes missing from my patch. Please explain everything 
that you didn't take.


> +	struct rb_root root_net_port;


#endif /* IS_ENABLED(CONFIG_INET) */

And then all use of root_net_port should be surrounded by the same check.

I think it should be OK to keep all other remaining network references 
though (e.g. access_masks and the ).


>   	/**
>   	 * @hierarchy: Enables hierarchy identification even when a parent
>   	 * domain vanishes.  This is needed for the ptrace protection.
> @@ -188,7 +199,8 @@ struct landlock_ruleset {
>   };
> 
>   struct landlock_ruleset *
> -landlock_create_ruleset(const access_mask_t access_mask);
> +landlock_create_ruleset(const access_mask_t access_mask_fs,
> +			const access_mask_t access_mask_net);
> 
>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
> @@ -226,6 +238,21 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>   		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
>   }
> 
> +/* A helper function to set a network mask. */

I already said that this comment is useless, and I removed it in my 
patch. Please take a closer look at reviews.


> +static inline void
> +landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
> +			     const access_mask_t net_access_mask,
> +			     const u16 layer_level)
> +{
> +	access_mask_t net_mask = net_access_mask & LANDLOCK_MASK_ACCESS_NET;
> +
> +	/* Should already be checked in sys_landlock_create_ruleset(). */
> +	WARN_ON_ONCE(net_access_mask != net_mask);
> +	// TODO: Add tests to check "|=" and not "="
> +	ruleset->access_masks[layer_level] |=
> +		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
> +}
> +
>   /* A helper function to get a filesystem mask. */
>   static inline access_mask_t
>   landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
> @@ -236,6 +263,16 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>   	       LANDLOCK_MASK_ACCESS_FS;
>   }
> 
> +/* A helper function to get a network mask. */
> +static inline access_mask_t
> +landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
> +			     const u16 layer_level)
> +{
> +	return (ruleset->access_masks[layer_level] >>
> +		LANDLOCK_SHIFT_ACCESS_NET) &
> +	       LANDLOCK_MASK_ACCESS_NET;
> +}
> +

This hunk doesn't match my patch.


>   bool unmask_layers(const struct landlock_rule *const rule,
>   		   const access_mask_t access_request,
>   		   layer_mask_t (*const layer_masks)[],
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index ffd5805eddd9..641155f6f6f8 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -189,8 +189,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>   	    LANDLOCK_MASK_ACCESS_FS)
>   		return -EINVAL;
> 
> +	/* Checks network content (and 32-bits cast). */
> +	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
> +	    LANDLOCK_MASK_ACCESS_NET)
> +		return -EINVAL;
> +
>   	/* Checks arguments and transforms to kernel struct. */
> -	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
> +	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
> +					  ruleset_attr.handled_access_net);
>   	if (IS_ERR(ruleset))
>   		return PTR_ERR(ruleset);
> 
> --
> 2.25.1
> 
