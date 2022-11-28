Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ECC639FF6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiK1DHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 22:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK1DHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:07:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F846147;
        Sun, 27 Nov 2022 19:07:45 -0800 (PST)
Received: from frapeml100003.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NL9LQ2vs4z67KQL;
        Mon, 28 Nov 2022 11:04:46 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100003.china.huawei.com (7.182.85.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 04:07:42 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 03:07:42 +0000
Message-ID: <72e8356b-e316-0289-2316-059e4fc58bef@huawei.com>
Date:   Mon, 28 Nov 2022 06:07:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 03/12] landlock: Refactor merge/inherit_ruleset
 functions
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-4-konstantin.meskhidze@huawei.com>
 <85898d3b-9ef6-6fb7-6d9b-d6766a58b9ab@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <85898d3b-9ef6-6fb7-6d9b-d6766a58b9ab@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/2022 9:41 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> Refactors merge_ruleset() and inherit_ruleset() functions to support
> 
> Refactor…

   Ok. Thanks.
> 
>> new rule types. This patch adds merge_tree() and inherit_tree()
>> helpers.
> 
>> Each has key_type argument to choose a particular rb_tree
> 
> They use a specific ruleset's red-black tree according to a key type
> argument.

   Got it.
> 
>> structure in a ruleset.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Adds missed lockdep_assert_held it inherit_tree() and merge_tree().
>> * Fixes comment.
>> 
>> Changes since v6:
>> * Refactors merge_ruleset() and inherit_ruleset() functions to support
>>    new rule types.
>> * Renames tree_merge() to merge_tree() (and reorder arguments), and
>>    tree_copy() to inherit_tree().
>> 
>> Changes since v5:
>> * Refactors some logic errors.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * None
>> 
>> ---
>>   security/landlock/ruleset.c | 108 ++++++++++++++++++++++++------------
>>   1 file changed, 73 insertions(+), 35 deletions(-)
>> 
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 41de17d1869e..961ffe0c709e 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -302,36 +302,22 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
>>   	}
>>   }
>> 
>> -static int merge_ruleset(struct landlock_ruleset *const dst,
>> -			 struct landlock_ruleset *const src)
>> +static int merge_tree(struct landlock_ruleset *const dst,
>> +		      struct landlock_ruleset *const src,
>> +		      const enum landlock_key_type key_type)
>>   {
>>   	struct landlock_rule *walker_rule, *next_rule;
>>   	struct rb_root *src_root;
>>   	int err = 0;
>> 
>>   	might_sleep();
>> -	/* Should already be checked by landlock_merge_ruleset() */
>> -	if (WARN_ON_ONCE(!src))
>> -		return 0;
>> -	/* Only merge into a domain. */
>> -	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>> -		return -EINVAL;
>> +	lockdep_assert_held(&dst->lock);
>> +	lockdep_assert_held(&src->lock);
>> 
>> -	src_root = get_root(src, LANDLOCK_KEY_INODE);
>> +	src_root = get_root(src, key_type);
>>   	if (IS_ERR(src_root))
>>   		return PTR_ERR(src_root);
>> 
>> -	/* Locks @dst first because we are its only owner. */
>> -	mutex_lock(&dst->lock);
>> -	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>> -
>> -	/* Stacks the new layer. */
>> -	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>> -		err = -EINVAL;
>> -		goto out_unlock;
>> -	}
>> -	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>> -
>>   	/* Merges the @src tree. */
>>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
>>   					     node) {
>> @@ -340,7 +326,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>   		} };
>>   		const struct landlock_id id = {
>>   			.key = walker_rule->key,
>> -			.type = LANDLOCK_KEY_INODE,
>> +			.type = key_type,
>>   		};
>> 
>>   		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
>> @@ -351,8 +337,39 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>> 
>>   		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
>>   		if (err)
>> -			goto out_unlock;
>> +			return err;
>> +	}
>> +	return err;
>> +}
>> +
>> +static int merge_ruleset(struct landlock_ruleset *const dst,
>> +			 struct landlock_ruleset *const src)
>> +{
>> +	int err = 0;
>> +
>> +	might_sleep();
>> +	/* Should already be checked by landlock_merge_ruleset() */
>> +	if (WARN_ON_ONCE(!src))
>> +		return 0;
>> +	/* Only merge into a domain. */
>> +	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>> +		return -EINVAL;
>> +
>> +	/* Locks @dst first because we are its only owner. */
>> +	mutex_lock(&dst->lock);
>> +	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>> +
>> +	/* Stacks the new layer. */
>> +	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>> +		err = -EINVAL;
>> +		goto out_unlock;
>>   	}
>> +	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>> +
>> +	/* Merges the @src inode tree. */
>> +	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
>> +	if (err)
>> +		goto out_unlock;
>> 
>>   out_unlock:
>>   	mutex_unlock(&src->lock);
>> @@ -360,43 +377,64 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>   	return err;
>>   }
>> 
>> -static int inherit_ruleset(struct landlock_ruleset *const parent,
>> -			   struct landlock_ruleset *const child)
>> +static int inherit_tree(struct landlock_ruleset *const parent,
>> +			struct landlock_ruleset *const child,
>> +			const enum landlock_key_type key_type)
>>   {
>>   	struct landlock_rule *walker_rule, *next_rule;
>>   	struct rb_root *parent_root;
>>   	int err = 0;
>> 
>>   	might_sleep();
>> -	if (!parent)
>> -		return 0;
>> +	lockdep_assert_held(&parent->lock);
>> +	lockdep_assert_held(&parent->lock);
> 
> lockdep_assert_held(&child->lock);

   My mistake. Thanks.
> .
