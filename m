Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844865B5F11
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiILRRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiILRRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:17:32 -0400
Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3143F1E6
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:17:30 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MRCvr6MZ4zMqnqY;
        Mon, 12 Sep 2022 19:17:28 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MRCvr2jZPzx4;
        Mon, 12 Sep 2022 19:17:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1663003048;
        bh=QEc+dHBn/6Y0A3ncay+VC5zTY61Pf9Og+qZowAWEGfA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=O+zK/hBGFVPbhgJAHhWH5vR4Tra2+cFDuYRGNL5QkzHwmtUvBzCSsNhUdbxsSn8MB
         kkRWoyIsiD9cf+A1uS45EyQKrxexYrT6Lcl5kKSgw0aEbpi95Icp6YRaj9aq3gpNID
         VjSuaiKG7p2S+UsGwls6WdQe0gKSHQpJMNhH0UOE=
Message-ID: <21bc4d6b-6c06-3bbb-f2f4-7d10d289c3a4@digikod.net>
Date:   Mon, 12 Sep 2022 19:17:27 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 03/18] landlock: refactor merge/inherit_ruleset
 functions
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-4-konstantin.meskhidze@huawei.com>
 <6839cc81-fa34-cda9-91d3-89f63750795c@digikod.net>
 <72db3ee6-06ee-0af8-06c6-ac16200bb83f@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <72db3ee6-06ee-0af8-06c6-ac16200bb83f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/09/2022 16:53, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:07 AM, Mickaël Salaün пишет:
>>
>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>> Refactors merge_ruleset() and inherit_ruleset() functions to support
>>> new rule types. This patch adds merge_tree() and inherit_tree()
>>> helpers. Each has key_type argument to choose a particular rb_tree
>>> structure in a ruleset.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v6:
>>> * Refactors merge_ruleset() and inherit_ruleset() functions to support
>>>     new rule types.
>>> * Renames tree_merge() to merge_tree() (and reorder arguments), and
>>>     tree_copy() to inherit_tree().
>>>
>>> Changes since v5:
>>> * Refactors some logic errors.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * None
>>>
>>> ---
>>>    security/landlock/ruleset.c | 108 +++++++++++++++++++++++-------------
>>>    1 file changed, 69 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index 41de17d1869e..3a5ef356aaa3 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -302,36 +302,18 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
>>>    	}
>>>    }
>>>
>>> -static int merge_ruleset(struct landlock_ruleset *const dst,
>>> -			 struct landlock_ruleset *const src)
>>> +static int merge_tree(struct landlock_ruleset *const dst,
>>> +		      struct landlock_ruleset *const src,
>>> +		      const enum landlock_key_type key_type)
>>>    {
>>>    	struct landlock_rule *walker_rule, *next_rule;
>>>    	struct rb_root *src_root;
>>>    	int err = 0;
>>>
>>> -	might_sleep();
>>> -	/* Should already be checked by landlock_merge_ruleset() */
>>> -	if (WARN_ON_ONCE(!src))
>>> -		return 0;
>>> -	/* Only merge into a domain. */
>>> -	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>>> -		return -EINVAL;
>>> -
>>> -	src_root = get_root(src, LANDLOCK_KEY_INODE);
>>
>> This hunk is a bit misleading, but please add a might_sleep() call here
>> because of the insert_rule() call, and some lock asserts:
>>
>> might_sleep();
>> lockdep_assert_held(&dst->lock);
>> lockdep_assert_held(&src->lock);
> 
>     it was moved into merge_ruleset() function,
>     please check below.

I know but you still need to add these asserts.


> 
>>
>>
>>> +	src_root = get_root(src, key_type);
>>>    	if (IS_ERR(src_root))
>>>    		return PTR_ERR(src_root);
>>>
>>> -	/* Locks @dst first because we are its only owner. */
>>> -	mutex_lock(&dst->lock);
>>> -	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>>> -
>>> -	/* Stacks the new layer. */
>>> -	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>>> -		err = -EINVAL;
>>> -		goto out_unlock;
>>> -	}
>>> -	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>>> -
>>>    	/* Merges the @src tree. */
>>>    	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
>>>    					     node) {
>>> @@ -340,7 +322,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>    		} };
>>>    		const struct landlock_id id = {
>>>    			.key = walker_rule->key,
>>> -			.type = LANDLOCK_KEY_INODE,
>>> +			.type = key_type,
>>>    		};
>>>
>>>    		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
>>> @@ -351,8 +333,39 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>
>>>    		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
>>>    		if (err)
>>> -			goto out_unlock;
>>> +			return err;
>>> +	}
>>> +	return err;
>>> +}
>>> +
>>> +static int merge_ruleset(struct landlock_ruleset *const dst,
>>> +			 struct landlock_ruleset *const src)
>>> +{
>>> +	int err = 0;
>>> +
>>> +	might_sleep();
>>> +	/* Should already be checked by landlock_merge_ruleset() */
>>> +	if (WARN_ON_ONCE(!src))
>>> +		return 0;
>>> +	/* Only merge into a domain. */
>>> +	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
>>> +		return -EINVAL;
>>> +
>>> +	/* Locks @dst first because we are its only owner. */
>>> +	mutex_lock(&dst->lock);
>>> +	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
>>> +
>>> +	/* Stacks the new layer. */
>>> +	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
>>> +		err = -EINVAL;
>>> +		goto out_unlock;
>>>    	}
>>> +	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
>>> +
>>> +	/* Merges the @src inode tree. */
>>> +	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
>>> +	if (err)
>>> +		goto out_unlock;
>>>
>>>    out_unlock:
>>>    	mutex_unlock(&src->lock);
>>> @@ -360,43 +373,60 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>>>    	return err;
>>>    }
>>>
>>> -static int inherit_ruleset(struct landlock_ruleset *const parent,
>>> -			   struct landlock_ruleset *const child)
>>> +static int inherit_tree(struct landlock_ruleset *const parent,
>>> +			struct landlock_ruleset *const child,
>>> +			const enum landlock_key_type key_type)
>>>    {
>>>    	struct landlock_rule *walker_rule, *next_rule;
>>>    	struct rb_root *parent_root;
>>>    	int err = 0;
>>>
>>> -	might_sleep();
>>> -	if (!parent)
>>> -		return 0;
>>> -
>>> -	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
>>
>> This hunk is a bit misleading, but please add a might_sleep() call here
>> because of the insert_rule() call, and some lock asserts:
>>
>> might_sleep();
>> lockdep_assert_held(&parent->lock);
>> lockdep_assert_held(&child->lock);
>>
>     it was moved into inherit_ruleset() function,
>     please check below.

same

