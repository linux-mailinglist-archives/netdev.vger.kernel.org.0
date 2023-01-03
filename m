Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9027F65C011
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjACMol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjACMoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:44:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F5EDF64;
        Tue,  3 Jan 2023 04:44:36 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NmXQj0TjLz6J7mG;
        Tue,  3 Jan 2023 20:41:01 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 3 Jan 2023 12:44:34 +0000
Message-ID: <d383ffa5-ddd1-1a3c-e55f-6070158cc77f@huawei.com>
Date:   Tue, 3 Jan 2023 15:44:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>,
        Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/2022 9:43 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> This commit adds network rules support in internal landlock functions
>> (presented in ruleset.c) and landlock_create_ruleset syscall.
> 
> …in the ruleset management helpers and the landlock_create_ruleset syscall.
> 
> 
>> Refactors user space API to support network actions. Adds new network
> 
> Refactor…
> 
>> access flags, network rule and network attributes. Increments Landlock
> 
> Increment…
> 
>> ABI version.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Squashes commits.
>> * Increments ABI version to 4.
>> * Refactors commit message.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>    because it OR values.
>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>> * Refactors landlock_get_net_access_mask().
>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>    LANDLOCK_NUM_ACCESS_FS as value.
>> * Updates access_masks_t to u32 to support network access actions.
>> * Refactors landlock internal functions to support network actions with
>>    landlock_key/key_type/id types.
>> 
>> Changes since v5:
>> * Gets rid of partial revert from landlock_add_rule
>> syscall.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors landlock_create_ruleset() - splits ruleset and
>> masks checks.
>> * Refactors landlock_create_ruleset() and landlock mask
>> setters/getters to support two rule types.
>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>> function by factoring out get_ruleset_from_fd() and
>> landlock_put_ruleset().
>> 
>> Changes since v3:
>> * Splits commit.
>> * Adds network rule support for internal landlock functions.
>> * Adds set_mask and get_mask for network.
>> * Adds rb_root root_net_port.
>> 
>> ---
>>   include/uapi/linux/landlock.h                | 49 ++++++++++++++
>>   security/landlock/limits.h                   |  6 +-
>>   security/landlock/ruleset.c                  | 55 ++++++++++++++--
>>   security/landlock/ruleset.h                  | 68 ++++++++++++++++----
>>   security/landlock/syscalls.c                 | 13 +++-
>>   tools/testing/selftests/landlock/base_test.c |  2 +-
>>   6 files changed, 170 insertions(+), 23 deletions(-)
>> 
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index f3223f964691..096b683c6ff3 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>   	 * this access right.
>>   	 */
>>   	__u64 handled_access_fs;
>> +
>> +	/**
>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>> +	 * that is handled by this ruleset and should then be forbidden if no
>> +	 * rule explicitly allow them.
>> +	 */
>> +	__u64 handled_access_net;
>>   };
>> 
>>   /*
>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>   	 * landlock_path_beneath_attr .
>>   	 */
>>   	LANDLOCK_RULE_PATH_BENEATH = 1,
>> +	/**
>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>> +	 * landlock_net_service_attr .
>> +	 */
>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>   };
>> 
>>   /**
>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>   	 */
>>   } __attribute__((packed));
>> 
>> +/**
>> + * struct landlock_net_service_attr - TCP subnet definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_net_service_attr {
>> +	/**
>> +	 * @allowed_access: Bitmask of allowed access network for services
>> +	 * (cf. `Network flags`_).
>> +	 */
>> +	__u64 allowed_access;
>> +	/**
>> +	 * @port: Network port.
>> +	 */
>> +	__u16 port;
> 
>   From an UAPI point of view, I think the port field should be __be16, as
> for sockaddr_in->port and other network-related APIs. This will require
> some kernel changes to please sparse: make C=2 security/landlock/ must
> not print any warning.
> 
> Using big-endian values as keys (casted to uintptr_t, not strictly
> __be16) in the rb-tree should not be an issue because there is no port
> range ordering (for now).
> 
> A dedicated test should check that endianness is correct, e.g. by using
> different port encoding. This should include passing and failing tests,
> but they should work on all architectures (i.e. big or little endian).
> 
   Hi Mickaёl.
   Could you please give me a piece of advice about these kind of tests?
   I have not entirely understood this point.
> 
>> +
>> +} __attribute__((packed));
>> +
>>   /**
>>    * DOC: fs_access
>>    *
>> @@ -173,4 +203,23 @@ struct landlock_path_beneath_attr {
>>   #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>>   /* clang-format on */
>> 
>> +/**
>> + * DOC: net_access
>> + *
>> + * Network flags
>> + * ~~~~~~~~~~~~~~~~
>> + *
>> + * These flags enable to restrict a sandboxed process to a set of network
>> + * actions.
>> + *
>> + * TCP sockets with allowed actions:
>> + *
>> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>> + *   a remote port.
>> + */
>> +/* clang-format off */
>> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>> +/* clang-format on */
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>> index bafb3b8dc677..8a1a6463c64e 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -23,6 +23,10 @@
>>   #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
>>   #define LANDLOCK_SHIFT_ACCESS_FS	0
>> 
>> -/* clang-format on */
>> +#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
>> +#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
>> +#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
>> +#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS
>> 
>> +/* clang-format on */
>>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index c7cf54ba4f6d..9277c1295114 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -36,6 +36,9 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   	refcount_set(&new_ruleset->usage, 1);
>>   	mutex_init(&new_ruleset->lock);
>>   	new_ruleset->root_inode = RB_ROOT;
>> +#if IS_ENABLED(CONFIG_INET)
>> +	new_ruleset->root_net_port = RB_ROOT;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	new_ruleset->num_layers = num_layers;
>>   	/*
>>   	 * hierarchy = NULL
>> @@ -46,16 +49,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   }
>> 
>>   struct landlock_ruleset *
>> -landlock_create_ruleset(const access_mask_t fs_access_mask)
>> +landlock_create_ruleset(const access_mask_t fs_access_mask,
>> +			const access_mask_t net_access_mask)
>>   {
>>   	struct landlock_ruleset *new_ruleset;
>> 
>>   	/* Informs about useless ruleset. */
>> -	if (!fs_access_mask)
>> +	if (!fs_access_mask && !net_access_mask)
>>   		return ERR_PTR(-ENOMSG);
>>   	new_ruleset = create_ruleset(1);
>> -	if (!IS_ERR(new_ruleset))
>> +	if (IS_ERR(new_ruleset))
>> +		return new_ruleset;
>> +	if (fs_access_mask)
>>   		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
>> +	if (net_access_mask)
>> +		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
>>   	return new_ruleset;
>>   }
>> 
>> @@ -73,6 +81,10 @@ static inline bool is_object_pointer(const enum landlock_key_type key_type)
>>   	switch (key_type) {
>>   	case LANDLOCK_KEY_INODE:
>>   		return true;
>> +#if IS_ENABLED(CONFIG_INET)
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		return false;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	}
>>   	WARN_ON_ONCE(1);
>>   	return false;
>> @@ -126,6 +138,11 @@ static inline struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>>   	case LANDLOCK_KEY_INODE:
>>   		root = &ruleset->root_inode;
>>   		break;
>> +#if IS_ENABLED(CONFIG_INET)
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		root = &ruleset->root_net_port;
>> +		break;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	}
>>   	if (WARN_ON_ONCE(!root))
>>   		return ERR_PTR(-EINVAL);
>> @@ -154,7 +171,9 @@ static void build_check_ruleset(void)
>>   	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>>   	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>   	BUILD_BUG_ON(access_masks <
>> -		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
>> +		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) +
> 
> This is correct but because we are dealing with bitmasks I would prefer
> to use "|" instead of "+".
> 
> 
>> +			     (LANDLOCK_MASK_ACCESS_NET
>> +			      << LANDLOCK_SHIFT_ACCESS_NET));
>>   }
>> 
>>   /**
>> @@ -370,7 +389,12 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>   	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
>>   	if (err)
>>   		goto out_unlock;
>> -
> 
> Please keep this newline.
> 
>> +#if IS_ENABLED(CONFIG_INET)
>> +	/* Merges the @src network port tree. */
>> +	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
>> +	if (err)
>> +		goto out_unlock;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   out_unlock:
>>   	mutex_unlock(&src->lock);
>>   	mutex_unlock(&dst->lock);
>> @@ -426,7 +450,12 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>>   	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
>>   	if (err)
>>   		goto out_unlock;
>> -
> 
> newline
> 
>> +#if IS_ENABLED(CONFIG_INET)
>> +	/* Copies the @parent network port tree. */
>> +	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
>> +	if (err)
>> +		goto out_unlock;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>>   		err = -EINVAL;
>>   		goto out_unlock;
>> @@ -459,6 +488,11 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>>   	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
>>   					     node)
>>   		free_rule(freeme, LANDLOCK_KEY_INODE);
>> +#if IS_ENABLED(CONFIG_INET)
>> +	rbtree_postorder_for_each_entry_safe(freeme, next,
>> +					     &ruleset->root_net_port, node)
>> +		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	put_hierarchy(ruleset->hierarchy);
>>   	kfree(ruleset);
>>   }
>> @@ -637,6 +671,9 @@ get_access_mask_t(const struct landlock_ruleset *const ruleset,
>>    * Populates @layer_masks such that for each access right in @access_request,
>>    * the bits for all the layers are set where this access right is handled.
>>    *
>> + * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
>> + * elements according to @key_type.
> 
> Please include this sentence in the @layer_masks description below.
> 
>> + *
>>    * @domain: The domain that defines the current restrictions.
>>    * @access_request: The requested access rights to check.
>>    * @layer_masks: The layer masks to populate.
> 
> "It must contain…"
> 
> 
>> @@ -659,6 +696,12 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>>   		get_access_mask = landlock_get_fs_access_mask;
>>   		num_access = LANDLOCK_NUM_ACCESS_FS;
>>   		break;
>> +#if IS_ENABLED(CONFIG_INET)
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		get_access_mask = landlock_get_net_access_mask;
>> +		num_access = LANDLOCK_NUM_ACCESS_NET;
>> +		break;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		return 0;
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index d9eb79ea9a89..f272d2cd518c 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -19,16 +19,20 @@
>>   #include "limits.h"
>>   #include "object.h"
>> 
>> +/* Rule access mask. */
>>   typedef u16 access_mask_t;
>>   /* Makes sure all filesystem access rights can be stored. */
>>   static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>> +/* Makes sure all network access rights can be stored. */
>> +static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>>   /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>>   static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>> 
>>   /* Ruleset access masks. */
>> -typedef u16 access_masks_t;
>> +typedef u32 access_masks_t;
> 
> This type change need to be explained in the commit message.
> 
> 
>>   /* Makes sure all ruleset access rights can be stored. */
>> -static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
>> +static_assert(BITS_PER_TYPE(access_masks_t) >=
>> +	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);
>> 
>>   typedef u16 layer_mask_t;
>>   /* Makes sure all layers can be checked. */
>> @@ -82,6 +86,13 @@ enum landlock_key_type {
>>   	 * keys.
>>   	 */
>>   	LANDLOCK_KEY_INODE = 1,
>> +#if IS_ENABLED(CONFIG_INET)
>> +	/**
>> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
>> +	 * node keys.
>> +	 */
>> +	LANDLOCK_KEY_NET_PORT = 2,
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   };
>> 
>>   /**
>> @@ -156,6 +167,15 @@ struct landlock_ruleset {
>>   	 * reaches zero.
>>   	 */
>>   	struct rb_root root_inode;
>> +#if IS_ENABLED(CONFIG_INET)
>> +	/**
>> +	 * @root_net_port: Root of a red-black tree containing &struct
>> +	 * landlock_rule nodes with network port. Once a ruleset is tied to a
>> +	 * process (i.e. as a domain), this tree is immutable until @usage
>> +	 * reaches zero.
>> +	 */
>> +	struct rb_root root_net_port;
>> +#endif /* IS_ENABLED(CONFIG_INET) */
>>   	/**
>>   	 * @hierarchy: Enables hierarchy identification even when a parent
>>   	 * domain vanishes.  This is needed for the ptrace protection.
>> @@ -166,8 +186,8 @@ struct landlock_ruleset {
>>   		 * @work_free: Enables to free a ruleset within a lockless
>>   		 * section.  This is only used by
>>   		 * landlock_put_ruleset_deferred() when @usage reaches zero.
>> -		 * The fields @lock, @usage, @num_rules, @num_layers and
>> -		 * @access_masks are then unused.
>> +		 * The fields @lock, @usage, @num_rules, @num_layers,
>> +		 * @net_access_mask and @access_masks are then unused.
> 
> There is no net_access_mask anymore.
> .
