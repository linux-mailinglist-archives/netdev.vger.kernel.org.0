Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB484DE117
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbiCRSeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbiCRSeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:34:12 -0400
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CCA12658D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:32:40 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KKt0k1LKdzMqRfj;
        Fri, 18 Mar 2022 19:32:38 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KKt0j3g4mzlhRV2;
        Fri, 18 Mar 2022 19:32:37 +0100 (CET)
Message-ID: <92d498f0-c598-7413-6b7c-d19c5aec6cab@digikod.net>
Date:   Fri, 18 Mar 2022 19:33:26 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        willemdebruijn.kernel@gmail.com
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
 <bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net>
 <6535183b-5fad-e3a9-1350-d22122205be6@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 03/15] landlock: landlock_find/insert_rule
 refactoring
In-Reply-To: <6535183b-5fad-e3a9-1350-d22122205be6@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/03/2022 15:29, Konstantin Meskhidze wrote:
> 
> 
> 3/16/2022 11:27 AM, Mickaël Salaün пишет:
>>
>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>> A new object union added to support a socket port
>>> rule type. To support it landlock_insert_rule() and
>>> landlock_find_rule() were refactored. Now adding
>>> or searching a rule in a ruleset depends on a
>>> rule_type argument provided in refactored
>>> functions mentioned above.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v3:
>>> * Split commit.
>>> * Refactoring landlock_insert_rule and landlock_find_rule functions.
>>> * Rename new_ruleset->root_inode.
>>>
>>> ---
>>>   security/landlock/fs.c      |   5 +-
>>>   security/landlock/ruleset.c | 108 +++++++++++++++++++++++++-----------
>>>   security/landlock/ruleset.h |  26 +++++----
>>>   3 files changed, 94 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>>> index 97f5c455f5a7..1497948d754f 100644
>>> --- a/security/landlock/fs.c
>>> +++ b/security/landlock/fs.c
>>> @@ -168,7 +168,7 @@ int landlock_append_fs_rule(struct 
>>> landlock_ruleset *const ruleset,
>>>       if (IS_ERR(object))
>>>           return PTR_ERR(object);
>>>       mutex_lock(&ruleset->lock);
>>> -    err = landlock_insert_rule(ruleset, object, access_rights);
>>> +    err = landlock_insert_rule(ruleset, object, 0, access_rights, 
>>> LANDLOCK_RULE_PATH_BENEATH);
>>
>> For consistency, please use 80 columns everywhere.
> 
>    Ok. I got it.
>>
>>>       mutex_unlock(&ruleset->lock);
>>>       /*
>>>        * No need to check for an error because landlock_insert_rule()
>>> @@ -195,7 +195,8 @@ static inline u64 unmask_layers(
>>>       inode = d_backing_inode(path->dentry);
>>>       rcu_read_lock();
>>>       rule = landlock_find_rule(domain,
>>> -            rcu_dereference(landlock_inode(inode)->object));
>>> +            (uintptr_t)rcu_dereference(landlock_inode(inode)->object),
>>> +            LANDLOCK_RULE_PATH_BENEATH);
>>>       rcu_read_unlock();
>>>       if (!rule)
>>>           return layer_mask;
>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index a6212b752549..971685c48641 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -34,7 +34,7 @@ static struct landlock_ruleset 
>>> *create_ruleset(const u32 num_layers)
>>>           return ERR_PTR(-ENOMEM);
>>>       refcount_set(&new_ruleset->usage, 1);
>>>       mutex_init(&new_ruleset->lock);
>>> -    new_ruleset->root = RB_ROOT;
>>> +    new_ruleset->root_inode = RB_ROOT;
>>>       new_ruleset->num_layers = num_layers;
>>>       /*
>>>        * hierarchy = NULL
>>> @@ -81,10 +81,12 @@ static void build_check_rule(void)
>>>   }
>>>
>>>   static struct landlock_rule *create_rule(
>>> -        struct landlock_object *const object,
>>> +        struct landlock_object *const object_ptr,
>>> +        const uintptr_t object_data,
>>>           const struct landlock_layer (*const layers)[],
>>>           const u32 num_layers,
>>> -        const struct landlock_layer *const new_layer)
>>> +        const struct landlock_layer *const new_layer,
>>> +        const u16 rule_type)
>>>   {
>>>       struct landlock_rule *new_rule;
>>>       u32 new_num_layers;
>>> @@ -103,8 +105,16 @@ static struct landlock_rule *create_rule(
>>>       if (!new_rule)
>>>           return ERR_PTR(-ENOMEM);
>>>       RB_CLEAR_NODE(&new_rule->node);
>>> -    landlock_get_object(object);
>>> -    new_rule->object = object;
>>> +
>>> +    switch (rule_type) {
>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>> +        landlock_get_object(object_ptr);
>>> +        new_rule->object.ptr = object_ptr;
>>> +        break;
>>> +    default:
>>> +        return ERR_PTR(-EINVAL);
>>
>> This would lead to memory leak. You should at least add a 
>> WARN_ON_ONCE(1) here, but a proper solution would be to remove the use 
>> of rule_type and only rely on object_ptr and object_data values. You 
>> can also add a WARN_ON_ONCE(object_ptr && object_data).
>>
>>
>    But rule_type is needed here in coming commits to support network
>    rules. For LANDLOCK_RULE_PATH_BENEATH rule type landlock_get_object() 
> is used but for LANDLOCK_RULE_NET_SERVICE is not. Using rule type is 
> convenient for distinguising between fs and network rules.

rule_type is not required to infer if the rule use a pointer or raw 
data, even with the following commits, because you can rely on 
object_ptr being NULL or not. This would make create_rule() generic for 
pointer-based and data-based object, even if not-yet-existing rule 
types. It is less error-prone to only be able to infer something from 
one source (i.e. object_ptr and not rule_type).


>>> +    }
>>> +
>>>       new_rule->num_layers = new_num_layers;
>>>       /* Copies the original layer stack. */
>>>       memcpy(new_rule->layers, layers,
>>> @@ -120,7 +130,7 @@ static void free_rule(struct landlock_rule *const 
>>> rule)
>>>       might_sleep();
>>>       if (!rule)
>>>           return;
>>> -    landlock_put_object(rule->object);
>>> +    landlock_put_object(rule->object.ptr);
>>>       kfree(rule);
>>>   }
>>>
>>> @@ -156,26 +166,38 @@ static void build_check_ruleset(void)
>>>    * access rights.
>>>    */
>>>   static int insert_rule(struct landlock_ruleset *const ruleset,
>>> -        struct landlock_object *const object,
>>> +        struct landlock_object *const object_ptr,
>>> +        const uintptr_t object_data,

Can you move rule_type here for this function and similar ones? It makes 
sense to group object-related arguments.


>>>           const struct landlock_layer (*const layers)[],
>>> -        size_t num_layers)
>>> +        size_t num_layers, u16 rule_type)
>>>   {
>>>       struct rb_node **walker_node;
>>>       struct rb_node *parent_node = NULL;
>>>       struct landlock_rule *new_rule;
>>> +    uintptr_t object;
>>> +    struct rb_root *root;
>>>
>>>       might_sleep();
>>>       lockdep_assert_held(&ruleset->lock);
>>> -    if (WARN_ON_ONCE(!object || !layers))
>>> -        return -ENOENT;
>>
>> You can leave this code here.
> 
>   But anyway in coming commits with network rules this code will be 
> moved into case LANDLOCK_RULE_PATH_BENEATH: ....

Yes, but without rule_type you don't need to duplicate this check, just 
to remove object_ptr from WARN_ON_ONCE() and replace the rule_type 
switch/case with if (object_ptr).

You can change to this:

--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -194,43 +194,49 @@ static void build_check_ruleset(void)
   */
  static int insert_rule(struct landlock_ruleset *const ruleset,
  		struct landlock_object *const object_ptr,
-		const uintptr_t object_data,
+		uintptr_t object_data, /* move @rule_type here */
  		const struct landlock_layer (*const layers)[],
-		size_t num_layers, u16 rule_type)
+		size_t num_layers, const enum landlock_rule_type rule_type)
  {
  	struct rb_node **walker_node;
  	struct rb_node *parent_node = NULL;
  	struct landlock_rule *new_rule;
-	uintptr_t object;
  	struct rb_root *root;

  	might_sleep();
  	lockdep_assert_held(&ruleset->lock);
-	/* Choose rb_tree structure depending on a rule type */
+
+	if (WARN_ON_ONCE(!layers))
+		return -ENOENT;
+	if (WARN_ON_ONCE(object_ptr && object_data))
+		return -EINVAL;
+
+	/* Chooses the rb_tree according to the rule type. */
  	switch (rule_type) {
  	case LANDLOCK_RULE_PATH_BENEATH:
-		if (WARN_ON_ONCE(!object_ptr || !layers))
+		if (WARN_ON_ONCE(!object_ptr))
  			return -ENOENT;
-		object = (uintptr_t)object_ptr;
+		object_data = (uintptr_t)object_ptr;
  		root = &ruleset->root_inode;
  		break;
  	case LANDLOCK_RULE_NET_SERVICE:
-		if (WARN_ON_ONCE(!object_data || !layers))
-			return -ENOENT;
-		object = object_data;
+		if (WARN_ON_ONCE(object_ptr))
+			return -EINVAL;
  		root = &ruleset->root_net_port;
  		break;
  	default:
+		WARN_ON_ONCE(1);
  		return -EINVAL;
  	}
+
  	walker_node = &root->rb_node;
  	while (*walker_node) {
  		struct landlock_rule *const this = rb_entry(*walker_node,
  				struct landlock_rule, node);

-		if (this->object.data != object) {
+		if (this->object.data != object_data) {
  			parent_node = *walker_node;
-			if (this->object.data < object)
+			if (this->object.data < object_data)
  				walker_node = &((*walker_node)->rb_right);
  			else
  				walker_node = &((*walker_node)->rb_left);


This highlight an implicit error handling for a port value of 0. I'm not 
sure if this should be allowed or not though. If not, it should be an 
explicit service_port check in add_rule_net_service(). A data value of 
zero might be legitimate for this use case or not-yet-existing 
data-based rule types. Anyway, this kind of check is specific to the use 
case and should not be part of insert_rule().



>>
>>> -    walker_node = &(ruleset->root.rb_node);
>>> +    /* Choose rb_tree structure depending on a rule type */
>>> +    switch (rule_type) {
>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>> +        if (WARN_ON_ONCE(!object_ptr || !layers))
>>> +            return -ENOENT;
>>> +        object = (uintptr_t)object_ptr;
>>> +        root = &ruleset->root_inode;
>>> +        break;
>>> +    default:
>>> +        return -EINVAL;
>>> +    }
>>> +    walker_node = &root->rb_node;
>>>       while (*walker_node) {
>>>           struct landlock_rule *const this = rb_entry(*walker_node,
>>>                   struct landlock_rule, node);
>>>
>>> -        if (this->object != object) {
>>> +        if (this->object.data != object) {
>>>               parent_node = *walker_node;
>>> -            if (this->object < object)
>>> +            if (this->object.data < object)
>>>                   walker_node = &((*walker_node)->rb_right);
>>>               else
>>>                   walker_node = &((*walker_node)->rb_left);
>>> @@ -207,11 +229,15 @@ static int insert_rule(struct landlock_ruleset 
>>> *const ruleset,
>>>            * Intersects access rights when it is a merge between a
>>>            * ruleset and a domain.
>>>            */
>>> -        new_rule = create_rule(object, &this->layers, this->num_layers,
>>> -                &(*layers)[0]);
>>> +        switch (rule_type) {
>>> +        case LANDLOCK_RULE_PATH_BENEATH:
>>
>> Same here and for the following code, you should replace such 
>> switch/case with an if (object_ptr).
>>    What about coming commits with network rule_type support?

This will still works.


>>
>>> +            new_rule = create_rule(object_ptr, 0, &this->layers, 
>>> this->num_layers,
>>> +                           &(*layers)[0], rule_type);
>>> +            break;
>>> +        }
>>>           if (IS_ERR(new_rule))
>>>               return PTR_ERR(new_rule);
>>> -        rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
>>> +        rb_replace_node(&this->node, &new_rule->node, 
>>> &ruleset->root_inode);
>>
>> Use the root variable here. Same for the following code and patches.
> 
>   What about your suggestion to use 2 rb_tress to support different 
> rule_types:
>       1. root_inode - for filesystem objects
>           2. root_net_port - for network port objects
> ????

I was talking about the root variable you declared a few line before. 
The conversion from ruleset->root to ruleset->root_inode is fine.


[...]

>>> @@ -465,20 +501,28 @@ struct landlock_ruleset *landlock_merge_ruleset(
>>>    */
>>>   const struct landlock_rule *landlock_find_rule(
>>>           const struct landlock_ruleset *const ruleset,
>>> -        const struct landlock_object *const object)
>>> +        const uintptr_t object_data, const u16 rule_type)
>>>   {
>>>       const struct rb_node *node;
>>>
>>> -    if (!object)
>>> +    if (!object_data)
>>
>> object_data can be 0. You need to add a test with such value.
>>
>> We need to be sure that this change cannot affect the current FS code.
> 
>   I got it. I will refactor it.

Well, 0 means a port 0, which might not be correct, but this check 
should not be performed by landlock_merge_ruleset().


>>
>>
>>>           return NULL;
>>> -    node = ruleset->root.rb_node;
>>> +
>>> +    switch (rule_type) {
>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>> +        node = ruleset->root_inode.rb_node;
>>> +        break;
>>> +    default:
>>> +        return ERR_PTR(-EINVAL);
>>
>> This is a bug. There is no check for such value. You need to check and 
>> update all call sites to catch such errors. Same for all new use of 
>> ERR_PTR().
> 
> Sorry, I did not get your point.
> Do you mean I should check the correctness of rule_type in above 
> function which calls landlock_find_rule() ??? Why can't I add such check 
> here?

landlock_find_rule() only returns NULL or a valid pointer, not an error.

[...]
