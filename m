Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2048D4DA18B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350716AbiCORtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350710AbiCORtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:49:11 -0400
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905CCB7CA
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:47:56 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KJ18S40CszMqF1r;
        Tue, 15 Mar 2022 18:47:52 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KJ18R6lG0zlhSMB;
        Tue, 15 Mar 2022 18:47:51 +0100 (CET)
Message-ID: <a28c8bec-3671-2613-9107-2b911305c274@digikod.net>
Date:   Tue, 15 Mar 2022 18:48:24 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 02/15] landlock: filesystem access mask helpers
In-Reply-To: <20220309134459.6448-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch should be squashed with the previous one. They both refactor 
FS access masks in a complementary way.

On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> This patch adds filesystem helper functions
> to set and get filesystem mask. Also the modification
> adds a helper structure landlock_access_mask to
> support managing multiple access mask.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Add get_mask, set_mask helpers for filesystem.
> * Add new struct landlock_access_mask.
> 
> ---
>   security/landlock/fs.c       |  4 ++--
>   security/landlock/ruleset.c  | 20 +++++++++++++++++---
>   security/landlock/ruleset.h  | 19 ++++++++++++++++++-
>   security/landlock/syscalls.c |  9 ++++++---
>   4 files changed, 43 insertions(+), 9 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index d727bdab7840..97f5c455f5a7 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -163,7 +163,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>   		return -EINVAL;
> 
>   	/* Transforms relative access rights to absolute ones. */
> -	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->access_masks[0];
> +	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~landlock_get_fs_access_mask(ruleset, 0);
>   	object = get_inode_object(d_backing_inode(path->dentry));
>   	if (IS_ERR(object))
>   		return PTR_ERR(object);
> @@ -252,7 +252,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
>   	/* Saves all layers handling a subset of requested accesses. */
>   	layer_mask = 0;
>   	for (i = 0; i < domain->num_layers; i++) {
> -		if (domain->access_masks[i] & access_request)
> +		if (landlock_get_fs_access_mask(domain, i) & access_request)
>   			layer_mask |= BIT_ULL(i);
>   	}
>   	/* An access request not handled by the domain is allowed. */
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 78341a0538de..a6212b752549 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -44,16 +44,30 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   	return new_ruleset;
>   }
> 
> -struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask)
> +/* A helper function to set a filesystem mask */
> +void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,

struct landlock_ruleset *const ruleset

Please use const as much as possible even in function arguments: e.g. 
access_masks_set, mask_level…

> +				 const struct landlock_access_mask *access_mask_set,

nit: no need for "_set" suffix.

Why do you need a struct landlock_access_mask and not just u16 (which 
will probably become a subset of access_mask_t, see [1])? 
landlock_create_ruleset() could just take two masks as argument instead.

[1] https://lore.kernel.org/all/20220221212522.320243-2-mic@digikod.net/

> +				 u16 mask_level)
> +{
> +	ruleset->access_masks[mask_level] = access_mask_set->fs;
> +}
> +
> +/* A helper function to get a filesystem mask */
> +u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level)
> +{
> +	return ruleset->access_masks[mask_level];
> +}

You can move these two helpers to ruleset.h and make them static inline.

> +
> +struct landlock_ruleset *landlock_create_ruleset(const struct landlock_access_mask *access_mask_set)
>   {
>   	struct landlock_ruleset *new_ruleset;
> 
>   	/* Informs about useless ruleset. */
> -	if (!access_mask)
> +	if (!access_mask_set->fs)
>   		return ERR_PTR(-ENOMSG);
>   	new_ruleset = create_ruleset(1);
>   	if (!IS_ERR(new_ruleset))
> -		new_ruleset->access_masks[0] = access_mask;
> +		landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
>   	return new_ruleset;
>   }
> 
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 32d90ce72428..bc87e5f787f7 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -16,6 +16,16 @@
> 
>   #include "object.h"
> 
> +/**
> + * struct landlock_access_mask - A helper structure to handle different mask types
> + */
> +struct landlock_access_mask {
> +	/**
> +	 * @fs: Filesystem access mask.
> +	 */
> +	u16 fs;
> +};

Removing this struct would simplify the code.

> +
>   /**
>    * struct landlock_layer - Access rights for a given layer
>    */
> @@ -140,7 +150,8 @@ struct landlock_ruleset {
>   	};
>   };
> 
> -struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask);
> +struct landlock_ruleset *landlock_create_ruleset(const struct landlock_access_mask
> +									*access_mask_set);
> 
>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
> @@ -162,4 +173,10 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>   		refcount_inc(&ruleset->usage);
>   }
> 
> +void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
> +				 const struct landlock_access_mask *access_mask_set,
> +				 u16 mask_level);
> +
> +u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level);
> +
>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index f1d86311df7e..5931b666321d 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -159,6 +159,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>   {
>   	struct landlock_ruleset_attr ruleset_attr;
>   	struct landlock_ruleset *ruleset;
> +	struct landlock_access_mask access_mask_set = {.fs = 0};
>   	int err, ruleset_fd;
> 
>   	/* Build-time checks. */
> @@ -185,9 +186,10 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>   	if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>   			LANDLOCK_MASK_ACCESS_FS)
>   		return -EINVAL;
> +	access_mask_set.fs = ruleset_attr.handled_access_fs;
> 
>   	/* Checks arguments and transforms to kernel struct. */
> -	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
> +	ruleset = landlock_create_ruleset(&access_mask_set);
>   	if (IS_ERR(ruleset))
>   		return PTR_ERR(ruleset);
> 
> @@ -343,8 +345,9 @@ SYSCALL_DEFINE4(landlock_add_rule,
>   	 * Checks that allowed_access matches the @ruleset constraints
>   	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>   	 */
> -	if ((path_beneath_attr.allowed_access | ruleset->access_masks[0]) !=
> -			ruleset->access_masks[0]) {
> +
> +	if ((path_beneath_attr.allowed_access | landlock_get_fs_access_mask(ruleset, 0)) !=
> +						landlock_get_fs_access_mask(ruleset, 0)) {
>   		err = -EINVAL;
>   		goto out_put_ruleset;
>   	}
> --
> 2.25.1
> 
