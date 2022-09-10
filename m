Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28EE5B47EC
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 20:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiIJS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIJS1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 14:27:37 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A796241D27;
        Sat, 10 Sep 2022 11:27:34 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ1Sk3GGjz67p52;
        Sun, 11 Sep 2022 02:23:18 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 20:27:31 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 19:27:30 +0100
Message-ID: <1563a50e-e345-4abb-1c4d-45284102ca6b@huawei.com>
Date:   Sat, 10 Sep 2022 21:27:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 08/18] landlock: add network rules support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-9-konstantin.meskhidze@huawei.com>
 <9cf95acb-14a0-0900-c5af-c910de80e289@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <9cf95acb-14a0-0900-c5af-c910de80e289@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:08 AM, Mickaël Salaün пишет:
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> This commit adds network rules support in internal landlock functions
>> (presented in ruleset.c) and landlock_create_ruleset syscall.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
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
>>   security/landlock/limits.h   |  6 +++++-
>>   security/landlock/ruleset.c  | 38 +++++++++++++++++++++++++++++----
>>   security/landlock/ruleset.h  | 41 ++++++++++++++++++++++++++++++++++--
>>   security/landlock/syscalls.c |  8 ++++++-
>>   4 files changed, 85 insertions(+), 8 deletions(-)
>> 
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
>> index 84fcd8eb30d4..442f212039df 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -36,6 +36,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   	refcount_set(&new_ruleset->usage, 1);
>>   	mutex_init(&new_ruleset->lock);
>>   	new_ruleset->root_inode = RB_ROOT;
>> +	new_ruleset->root_net_port = RB_ROOT;
>>   	new_ruleset->num_layers = num_layers;
>>   	/*
>>   	 * hierarchy = NULL
>> @@ -46,16 +47,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
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
>> @@ -73,6 +79,8 @@ static inline bool is_object_pointer(const enum landlock_key_type key_type)
>>   	switch (key_type) {
>>   	case LANDLOCK_KEY_INODE:
>>   		return true;
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		return false;
>>   	}
>>   	WARN_ON_ONCE(1);
>>   	return false;
>> @@ -126,6 +134,9 @@ static inline struct rb_root *get_root(struct landlock_ruleset *const ruleset,
>>   	case LANDLOCK_KEY_INODE:
>>   		root = &ruleset->root_inode;
>>   		break;
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		root = &ruleset->root_net_port;
>> +		break;
>>   	}
>>   	if (WARN_ON_ONCE(!root))
>>   		return ERR_PTR(-EINVAL);
>> @@ -154,7 +165,9 @@ static void build_check_ruleset(void)
>>   	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>>   	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>   	BUILD_BUG_ON(access_masks <
>> -		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
>> +		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) +
>> +			     (LANDLOCK_MASK_ACCESS_NET
>> +			      << LANDLOCK_SHIFT_ACCESS_NET));
>>   }
>> 
>>   /**
>> @@ -367,6 +380,11 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>   	if (err)
>>   		goto out_unlock;
>> 
>> +	/* Merges the @src network port tree. */
>> +	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
>> +	if (err)
>> +		goto out_unlock;
>> +
>>   out_unlock:
>>   	mutex_unlock(&src->lock);
>>   	mutex_unlock(&dst->lock);
>> @@ -419,6 +437,11 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
>>   	if (err)
>>   		goto out_unlock;
>> 
>> +	/* Copies the @parent network port tree. */
>> +	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
>> +	if (err)
>> +		goto out_unlock;
>> +
>>   	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
>>   		err = -EINVAL;
>>   		goto out_unlock;
>> @@ -451,6 +474,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>>   	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
>>   					     node)
>>   		free_rule(freeme, LANDLOCK_KEY_INODE);
>> +	rbtree_postorder_for_each_entry_safe(freeme, next,
>> +					     &ruleset->root_net_port, node)
>> +		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
>>   	put_hierarchy(ruleset->hierarchy);
>>   	kfree(ruleset);
>>   }
>> @@ -640,6 +666,10 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>>   		get_access_mask = landlock_get_fs_access_mask;
>>   		num_access = LANDLOCK_NUM_ACCESS_FS;
>>   		break;
>> +	case LANDLOCK_KEY_NET_PORT:
>> +		get_access_mask = landlock_get_net_access_mask;
>> +		num_access = LANDLOCK_NUM_ACCESS_NET;
>> +		break;
>>   	default:
>>   		WARN_ON_ONCE(1);
>>   		return 0;
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 2083855bf42d..d456ee90b648 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -26,7 +26,7 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>>   static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>> 
>>   /* Ruleset access masks. */
>> -typedef u16 access_masks_t;
>> +typedef u32 access_masks_t;
>>   /* Makes sure all ruleset access rights can be stored. */
>>   static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
> 
> There is some fixes missing from my patch.
> 
> 
>> 
>> @@ -66,6 +66,11 @@ enum landlock_key_type {
>>   	 * keys.
>>   	 */
>>   	LANDLOCK_KEY_INODE = 1,
> 
> 
> #if IS_ENABLED(CONFIG_INET)
> 
>> +	/**
>> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
>> +	 * node keys.
>> +	 */
>> +	LANDLOCK_KEY_NET_PORT = 2,
> 
> #endif /* IS_ENABLED(CONFIG_INET) */
> 
> And then all use of LANDLOCK_KEY_NET_PORT should be surrounded by the
> same check (but not directly in the net.c file).

  I checked the branch with your patches: tmp-net 
(7d6cf40a6f81adf607ad3cc17aaa11e256beeea4), but I did not find #if 
IS_ENABLED(CONFIG_INET) surrounding LANDLOCK_KEY_NET_PORT.
> 
> 
>>   };
>> 
>>   /**
>> @@ -133,6 +138,12 @@ struct landlock_ruleset {
>>   	 * reaches zero.
>>   	 */
>>   	struct rb_root root_inode;
> 
> #if IS_ENABLED(CONFIG_INET)
> 
>> +	/**
>> +	 * @root_net_port: Root of a red-black tree containing object nodes
>> +	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
>> +	 * this tree is immutable until @usage reaches zero.
>> +	 */
> 
> There is some fixes missing from my patch. Please explain everything
> that you didn't take.

    Sorry. I did merge your patch manually and did not tell the 
difference here. Will be fixed
> 
> 
>> +	struct rb_root root_net_port;
> 
> 
> #endif /* IS_ENABLED(CONFIG_INET) */
> 
> And then all use of root_net_port should be surrounded by the same check.

   The same - I did not find #if IS_ENABLED(CONFIG_INET) surrounding 
root_net_port in tmp-net (7d6cf40a6f81adf607ad3cc17aaa11e256beeea4)
> 
> I think it should be OK to keep all other remaining network references
> though (e.g. access_masks and the ).

   Ok. Thanks.
> 
> 
>>   	/**
>>   	 * @hierarchy: Enables hierarchy identification even when a parent
>>   	 * domain vanishes.  This is needed for the ptrace protection.
>> @@ -188,7 +199,8 @@ struct landlock_ruleset {
>>   };
>> 
>>   struct landlock_ruleset *
>> -landlock_create_ruleset(const access_mask_t access_mask);
>> +landlock_create_ruleset(const access_mask_t access_mask_fs,
>> +			const access_mask_t access_mask_net);
>> 
>>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
>> @@ -226,6 +238,21 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>>   		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
>>   }
>> 
>> +/* A helper function to set a network mask. */
> 
> I already said that this comment is useless, and I removed it in my
> patch. Please take a closer look at reviews.

  Sorry. I missed that in your patch. Will be fixed.
> 
> 
>> +static inline void
>> +landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
>> +			     const access_mask_t net_access_mask,
>> +			     const u16 layer_level)
>> +{
>> +	access_mask_t net_mask = net_access_mask & LANDLOCK_MASK_ACCESS_NET;
>> +
>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>> +	WARN_ON_ONCE(net_access_mask != net_mask);
>> +	// TODO: Add tests to check "|=" and not "="
>> +	ruleset->access_masks[layer_level] |=
>> +		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
>> +}
>> +
>>   /* A helper function to get a filesystem mask. */
>>   static inline access_mask_t
>>   landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>> @@ -236,6 +263,16 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>>   	       LANDLOCK_MASK_ACCESS_FS;
>>   }
>> 
>> +/* A helper function to get a network mask. */
>> +static inline access_mask_t
>> +landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
>> +			     const u16 layer_level)
>> +{
>> +	return (ruleset->access_masks[layer_level] >>
>> +		LANDLOCK_SHIFT_ACCESS_NET) &
>> +	       LANDLOCK_MASK_ACCESS_NET;
>> +}
>> +
> 
> This hunk doesn't match my patch.

   Do you mean landlock_get_net_access_mask? If yes, there is no diff 
with your patch here.
> 
> 
>>   bool unmask_layers(const struct landlock_rule *const rule,
>>   		   const access_mask_t access_request,
>>   		   layer_mask_t (*const layer_masks)[],
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index ffd5805eddd9..641155f6f6f8 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -189,8 +189,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>   	    LANDLOCK_MASK_ACCESS_FS)
>>   		return -EINVAL;
>> 
>> +	/* Checks network content (and 32-bits cast). */
>> +	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
>> +	    LANDLOCK_MASK_ACCESS_NET)
>> +		return -EINVAL;
>> +
>>   	/* Checks arguments and transforms to kernel struct. */
>> -	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
>> +	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
>> +					  ruleset_attr.handled_access_net);
>>   	if (IS_ERR(ruleset))
>>   		return PTR_ERR(ruleset);
>> 
>> --
>> 2.25.1
>> 
> .
