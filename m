Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2B45A4D20
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiH2NLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiH2NLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:11:18 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64B9286D2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:10:41 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MGW516TZ3zMrn0t;
        Mon, 29 Aug 2022 15:10:13 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MGW513Ttjzlh8TN;
        Mon, 29 Aug 2022 15:10:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1661778613;
        bh=+rv4+wg1hZWacpkN0Nxa2pPMiaAyuhGHyTIiCN2k9K0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=BCFyVSWsPNNvp2U41XDQ2BGKkaspbjd8K25+nPLTl8Z8STnnhbIgU4PJDMuubWoXd
         TbHkVxo5oUWrjAmWITCfLU+KwPesuGjaZmvWMen6K3vGPEsFuYE5FLSpJgFgka6YSn
         QVG6EDJ4oaCuExRa1SZEPcf8ip+xC0ojKwM3zV6k=
Message-ID: <f11b7754-b879-20be-0b22-94d94a68de71@digikod.net>
Date:   Mon, 29 Aug 2022 15:10:12 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <4c57a0c2-e207-10d6-c73d-bcda66bf3963@digikod.net>
 <6691d91f-c03b-30fa-2fa0-d062b3b234b9@digikod.net>
 <86db9124-ea11-0fa5-9dff-61744b2f80b4@digikod.net>
 <8eb6509f-8e79-d75c-08f4-80f52c0a26e7@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 00/17] Network support for Landlock
In-Reply-To: <8eb6509f-8e79-d75c-08f4-80f52c0a26e7@huawei.com>
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


On 27/08/2022 15:30, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/28/2022 4:17 PM, Mickaël Salaün пишет:

[...]

>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 59229be378d6..669de66094ed 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -19,8 +19,8 @@
>>     #include "limits.h"
>>     #include "object.h"
>>     
>> -// TODO: get back to u16 thanks to ruleset->net_access_mask
>> -typedef u32 access_mask_t;
>> +/* Rule access mask. */
>> +typedef u16 access_mask_t;
>>     /* Makes sure all filesystem access rights can be stored. */
>>     static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
>>     /* Makes sure all network access rights can be stored. */
>> @@ -28,6 +28,12 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
>>     /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
>>     static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));
>>     
>> +/* Ruleset access masks. */
>> +typedef u16 access_masks_t;
>> +/* Makes sure all ruleset access rights can be stored. */
>> +static_assert(BITS_PER_TYPE(access_masks_t) >=
>> +	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);
>> +
>>     typedef u16 layer_mask_t;
>>     /* Makes sure all layers can be checked. */
>>     static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
>> @@ -47,16 +53,33 @@ struct landlock_layer {
>>     	access_mask_t access;
>>     };
>>     
>> +/**
>> + * union landlock_key - Key of a ruleset's red-black tree
>> + */
>>     union landlock_key {
>>     	struct landlock_object *object;
>>     	uintptr_t data;
>>     };
>>     
>> +/**
>> + * enum landlock_key_type - Type of &union landlock_key
>> + */
>>     enum landlock_key_type {
>> +	/**
>> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
>> +	 * keys.
>> +	 */
>>     	LANDLOCK_KEY_INODE = 1,
>> +	/**
>> +	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
>> +	 * node keys.
>> +	 */
>>     	LANDLOCK_KEY_NET_PORT = 2,
>>     };
>>     
>> +/**
>> + * struct landlock_id - Unique rule identifier for a ruleset
>> + */
>>     struct landlock_id {
>>     	union landlock_key key;
>>     	const enum landlock_key_type type;
>> @@ -113,15 +136,17 @@ struct landlock_hierarchy {
>>      */
>>     struct landlock_ruleset {
>>     	/**
>> -	 * @root: Root of a red-black tree containing &struct landlock_rule
>> -	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
>> -	 * tree is immutable until @usage reaches zero.
>> +	 * @root_inode: Root of a red-black tree containing &struct
>> +	 * landlock_rule nodes with inode object.  Once a ruleset is tied to a
>> +	 * process (i.e. as a domain), this tree is immutable until @usage
>> +	 * reaches zero.
>>     	 */
>>     	struct rb_root root_inode;
>>     	/**
>> -	 * @root_net_port: Root of a red-black tree containing object nodes
>> -	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
>> -	 * this tree is immutable until @usage reaches zero.
>> +	 * @root_net_port: Root of a red-black tree containing &struct
>> +	 * landlock_rule nodes with network port. Once a ruleset is tied to a
>> +	 * process (i.e. as a domain), this tree is immutable until @usage
>> +	 * reaches zero.
>>     	 */
>>     	struct rb_root root_net_port;
>>     	/**
>> @@ -162,32 +187,25 @@ struct landlock_ruleset {
>>     			 */
>>     			u32 num_layers;
>>     			/**
>> -			 * TODO: net_access_mask: Contains the subset of network
>> -			 * actions that are restricted by a ruleset.
>> -			 */
>> -			access_mask_t net_access_mask;
>> -			/**
>> -			 * @access_masks: Contains the subset of filesystem
>> -			 * actions that are restricted by a ruleset.  A domain
>> -			 * saves all layers of merged rulesets in a stack
>> -			 * (FAM), starting from the first layer to the last
>> -			 * one.  These layers are used when merging rulesets,
>> -			 * for user space backward compatibility (i.e.
>> -			 * future-proof), and to properly handle merged
>> +			 * @access_masks: Contains the subset of filesystem and
>> +			 * network actions that are restricted by a ruleset.
>> +			 * A domain saves all layers of merged rulesets in a
>> +			 * stack (FAM), starting from the first layer to the
>> +			 * last one.  These layers are used when merging
>> +			 * rulesets, for user space backward compatibility
>> +			 * (i.e. future-proof), and to properly handle merged
>>     			 * rulesets without overlapping access rights.  These
>>     			 * layers are set once and never changed for the
>>     			 * lifetime of the ruleset.
>>     			 */
>> -			// TODO: rename (back) to fs_access_mask because layers
>> -			// are only useful for file hierarchies.
>> -			access_mask_t access_masks[];
>> +			access_masks_t access_masks[];
>>     		};
>>     	};
>>     };
>>     
>>     struct landlock_ruleset *
>> -landlock_create_ruleset(const access_mask_t access_mask_fs,
>> -			const access_mask_t access_mask_net);
>> +landlock_create_ruleset(const access_mask_t fs_access_mask,
>> +			const access_mask_t net_access_mask);
>>     
>>     void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>     void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
>> @@ -210,41 +228,7 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>>     		refcount_inc(&ruleset->usage);
>>     }
>>     
>> -// TODO: These helpers should not be required thanks to the new ruleset->net_access_mask.
>> -/* A helper function to set a filesystem mask. */
>> -static inline void
>> -landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
>> -			    const access_mask_t access_mask_fs, u16 mask_level)
>> -{
>> -	ruleset->access_masks[mask_level] = access_mask_fs;
>> -}
>> -
>> -/* A helper function to get a filesystem mask. */
>> -static inline u32
>> -landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
>> -			    u16 mask_level)
>> -{
>> -	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
>> -}
>> -
>> -/* A helper function to set a network mask. */
>> -static inline void
>> -landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
>> -			     const access_mask_t access_mask_net,
>> -			     u16 mask_level)
>> -{
>> -	ruleset->access_masks[mask_level] |=
>> -		(access_mask_net << LANDLOCK_MASK_SHIFT_NET);
>> -}
>> -
>> -/* A helper function to get a network mask. */
>> -static inline u32
>> -landlock_get_net_access_mask(const struct landlock_ruleset *ruleset,
>> -			     u16 mask_level)
>> -{
>> -	return (ruleset->access_masks[mask_level] >> LANDLOCK_MASK_SHIFT_NET);
>> -}
>> -
>> +// TODO: Remove if only relevant for fs.c
>>     access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain,
>>     				   const u16 rule_type, const u16 num_access);
>>     
>> @@ -258,4 +242,50 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>>     			       layer_mask_t (*const layer_masks)[],
>>     			       const enum landlock_key_type key_type);
>>     
>> +static inline void
>> +landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
>> +			    const access_mask_t fs_access_mask,
>> +			    const u16 layer_level)
>> +{
>> +	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
>> +
>> +	/* Should already be checked in sys_landlock_create_ruleset(). */
>> +	WARN_ON_ONCE(fs_access_mask != fs_mask);
>> +	// TODO: Add tests to check "|=" and not "=" > Is it kunit test? If so, do you want to add this kind of tests in future
> landlock versions?

In this sixth patch series, landlock_set_fs_access_mask() was replacing 
the content of access_masks[] whereas landlock_set_net_access_mask() was 
ORing it. It didn't lead to a bug because landlock_set_fs_access_mask() 
was called before landlock_set_net_access_mask(), but it was brittle.

Anyway, it was a good reminder to add a test to check that filesystem 
and network restrictions work well together. This can be added as a 
basic filesystem test using a ruleset handling network restrictions but 
no network rule (in fs_test.c), and as a basic network test using a 
ruleset handling filesystem restrictions but no filestem rule (in 
net_test.c).

This could also be part of a kunit test in the future.


>> +	ruleset->access_masks[layer_level] |=
>> +		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
>> +}
>> +
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
> The same above.
> I'm going add invalid network attribute checking into TEST_F(socket,
> inval) test in coming patch.

Good
