Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57C64DAC6F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353055AbiCPI2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354561AbiCPI14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:27:56 -0400
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DF463BCC
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:26:42 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KJNfQ3CMhzMpy9H;
        Wed, 16 Mar 2022 09:26:38 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KJNfP5bDKzlhSML;
        Wed, 16 Mar 2022 09:26:37 +0100 (CET)
Message-ID: <bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net>
Date:   Wed, 16 Mar 2022 09:27:15 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 03/15] landlock: landlock_find/insert_rule
 refactoring
In-Reply-To: <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
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


On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> A new object union added to support a socket port
> rule type. To support it landlock_insert_rule() and
> landlock_find_rule() were refactored. Now adding
> or searching a rule in a ruleset depends on a
> rule_type argument provided in refactored
> functions mentioned above.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Refactoring landlock_insert_rule and landlock_find_rule functions.
> * Rename new_ruleset->root_inode.
> 
> ---
>   security/landlock/fs.c      |   5 +-
>   security/landlock/ruleset.c | 108 +++++++++++++++++++++++++-----------
>   security/landlock/ruleset.h |  26 +++++----
>   3 files changed, 94 insertions(+), 45 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 97f5c455f5a7..1497948d754f 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c
> @@ -168,7 +168,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>   	if (IS_ERR(object))
>   		return PTR_ERR(object);
>   	mutex_lock(&ruleset->lock);
> -	err = landlock_insert_rule(ruleset, object, access_rights);
> +	err = landlock_insert_rule(ruleset, object, 0, access_rights, LANDLOCK_RULE_PATH_BENEATH);

For consistency, please use 80 columns everywhere.

>   	mutex_unlock(&ruleset->lock);
>   	/*
>   	 * No need to check for an error because landlock_insert_rule()
> @@ -195,7 +195,8 @@ static inline u64 unmask_layers(
>   	inode = d_backing_inode(path->dentry);
>   	rcu_read_lock();
>   	rule = landlock_find_rule(domain,
> -			rcu_dereference(landlock_inode(inode)->object));
> +			(uintptr_t)rcu_dereference(landlock_inode(inode)->object),
> +			LANDLOCK_RULE_PATH_BENEATH);
>   	rcu_read_unlock();
>   	if (!rule)
>   		return layer_mask;
> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index a6212b752549..971685c48641 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c
> @@ -34,7 +34,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>   		return ERR_PTR(-ENOMEM);
>   	refcount_set(&new_ruleset->usage, 1);
>   	mutex_init(&new_ruleset->lock);
> -	new_ruleset->root = RB_ROOT;
> +	new_ruleset->root_inode = RB_ROOT;
>   	new_ruleset->num_layers = num_layers;
>   	/*
>   	 * hierarchy = NULL
> @@ -81,10 +81,12 @@ static void build_check_rule(void)
>   }
> 
>   static struct landlock_rule *create_rule(
> -		struct landlock_object *const object,
> +		struct landlock_object *const object_ptr,
> +		const uintptr_t object_data,
>   		const struct landlock_layer (*const layers)[],
>   		const u32 num_layers,
> -		const struct landlock_layer *const new_layer)
> +		const struct landlock_layer *const new_layer,
> +		const u16 rule_type)
>   {
>   	struct landlock_rule *new_rule;
>   	u32 new_num_layers;
> @@ -103,8 +105,16 @@ static struct landlock_rule *create_rule(
>   	if (!new_rule)
>   		return ERR_PTR(-ENOMEM);
>   	RB_CLEAR_NODE(&new_rule->node);
> -	landlock_get_object(object);
> -	new_rule->object = object;
> +
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		landlock_get_object(object_ptr);
> +		new_rule->object.ptr = object_ptr;
> +		break;
> +	default:
> +		return ERR_PTR(-EINVAL);

This would lead to memory leak. You should at least add a 
WARN_ON_ONCE(1) here, but a proper solution would be to remove the use 
of rule_type and only rely on object_ptr and object_data values. You can 
also add a WARN_ON_ONCE(object_ptr && object_data).


> +	}
> +
>   	new_rule->num_layers = new_num_layers;
>   	/* Copies the original layer stack. */
>   	memcpy(new_rule->layers, layers,
> @@ -120,7 +130,7 @@ static void free_rule(struct landlock_rule *const rule)
>   	might_sleep();
>   	if (!rule)
>   		return;
> -	landlock_put_object(rule->object);
> +	landlock_put_object(rule->object.ptr);
>   	kfree(rule);
>   }
> 
> @@ -156,26 +166,38 @@ static void build_check_ruleset(void)
>    * access rights.
>    */
>   static int insert_rule(struct landlock_ruleset *const ruleset,
> -		struct landlock_object *const object,
> +		struct landlock_object *const object_ptr,
> +		const uintptr_t object_data,
>   		const struct landlock_layer (*const layers)[],
> -		size_t num_layers)
> +		size_t num_layers, u16 rule_type)
>   {
>   	struct rb_node **walker_node;
>   	struct rb_node *parent_node = NULL;
>   	struct landlock_rule *new_rule;
> +	uintptr_t object;
> +	struct rb_root *root;
> 
>   	might_sleep();
>   	lockdep_assert_held(&ruleset->lock);
> -	if (WARN_ON_ONCE(!object || !layers))
> -		return -ENOENT;

You can leave this code here.

> -	walker_node = &(ruleset->root.rb_node);
> +	/* Choose rb_tree structure depending on a rule type */
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		if (WARN_ON_ONCE(!object_ptr || !layers))
> +			return -ENOENT;
> +		object = (uintptr_t)object_ptr;
> +		root = &ruleset->root_inode;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	walker_node = &root->rb_node;
>   	while (*walker_node) {
>   		struct landlock_rule *const this = rb_entry(*walker_node,
>   				struct landlock_rule, node);
> 
> -		if (this->object != object) {
> +		if (this->object.data != object) {
>   			parent_node = *walker_node;
> -			if (this->object < object)
> +			if (this->object.data < object)
>   				walker_node = &((*walker_node)->rb_right);
>   			else
>   				walker_node = &((*walker_node)->rb_left);
> @@ -207,11 +229,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   		 * Intersects access rights when it is a merge between a
>   		 * ruleset and a domain.
>   		 */
> -		new_rule = create_rule(object, &this->layers, this->num_layers,
> -				&(*layers)[0]);
> +		switch (rule_type) {
> +		case LANDLOCK_RULE_PATH_BENEATH:

Same here and for the following code, you should replace such 
switch/case with an if (object_ptr).


> +			new_rule = create_rule(object_ptr, 0, &this->layers, this->num_layers,
> +					       &(*layers)[0], rule_type);
> +			break;
> +		}
>   		if (IS_ERR(new_rule))
>   			return PTR_ERR(new_rule);
> -		rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
> +		rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);

Use the root variable here. Same for the following code and patches.


>   		free_rule(this);
>   		return 0;
>   	}
> @@ -220,11 +246,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
>   	build_check_ruleset();
>   	if (ruleset->num_rules >= LANDLOCK_MAX_NUM_RULES)
>   		return -E2BIG;
> -	new_rule = create_rule(object, layers, num_layers, NULL);
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL, rule_type);
> +		break;
> +	}
>   	if (IS_ERR(new_rule))
>   		return PTR_ERR(new_rule);
>   	rb_link_node(&new_rule->node, parent_node, walker_node);
> -	rb_insert_color(&new_rule->node, &ruleset->root);
> +	rb_insert_color(&new_rule->node, &ruleset->root_inode);
>   	ruleset->num_rules++;
>   	return 0;
>   }
> @@ -242,7 +272,9 @@ static void build_check_layer(void)
> 
>   /* @ruleset must be locked by the caller. */
>   int landlock_insert_rule(struct landlock_ruleset *const ruleset,
> -		struct landlock_object *const object, const u32 access)
> +		struct landlock_object *const object_ptr,
> +		const uintptr_t object_data,
> +		const u32 access, const u16 rule_type)
>   {
>   	struct landlock_layer layers[] = {{
>   		.access = access,
> @@ -251,7 +283,8 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
>   	}};
> 
>   	build_check_layer();
> -	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
> +	return insert_rule(ruleset, object_ptr, object_data, &layers,
> +			   ARRAY_SIZE(layers), rule_type);
>   }
> 
>   static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
> @@ -297,7 +330,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
> 
>   	/* Merges the @src tree. */
>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
> -			&src->root, node) {
> +			&src->root_inode, node) {
>   		struct landlock_layer layers[] = {{
>   			.level = dst->num_layers,
>   		}};
> @@ -311,8 +344,8 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   			goto out_unlock;
>   		}
>   		layers[0].access = walker_rule->layers[0].access;
> -		err = insert_rule(dst, walker_rule->object, &layers,
> -				ARRAY_SIZE(layers));
> +		err = insert_rule(dst, walker_rule->object.ptr, 0, &layers,
> +				ARRAY_SIZE(layers), LANDLOCK_RULE_PATH_BENEATH);
>   		if (err)
>   			goto out_unlock;
>   	}
> @@ -323,6 +356,8 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
>   	return err;
>   }
> 
> +
> +

Useless lines.


>   static int inherit_ruleset(struct landlock_ruleset *const parent,
>   		struct landlock_ruleset *const child)
>   {
> @@ -339,9 +374,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
> 
>   	/* Copies the @parent tree. */
>   	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
> -			&parent->root, node) {
> -		err = insert_rule(child, walker_rule->object,
> -				&walker_rule->layers, walker_rule->num_layers);
> +			&parent->root_inode, node) {
> +		err = insert_rule(child, walker_rule->object.ptr, 0,
> +				&walker_rule->layers, walker_rule->num_layers,
> +				LANDLOCK_RULE_PATH_BENEATH);
>   		if (err)
>   			goto out_unlock;
>   	}
> @@ -372,7 +408,7 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
>   	struct landlock_rule *freeme, *next;
> 
>   	might_sleep();
> -	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root,
> +	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
>   			node)
>   		free_rule(freeme);
>   	put_hierarchy(ruleset->hierarchy);
> @@ -465,20 +501,28 @@ struct landlock_ruleset *landlock_merge_ruleset(
>    */
>   const struct landlock_rule *landlock_find_rule(
>   		const struct landlock_ruleset *const ruleset,
> -		const struct landlock_object *const object)
> +		const uintptr_t object_data, const u16 rule_type)
>   {
>   	const struct rb_node *node;
> 
> -	if (!object)
> +	if (!object_data)

object_data can be 0. You need to add a test with such value.

We need to be sure that this change cannot affect the current FS code.


>   		return NULL;
> -	node = ruleset->root.rb_node;
> +
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		node = ruleset->root_inode.rb_node;
> +		break;
> +	default:
> +		return ERR_PTR(-EINVAL);

This is a bug. There is no check for such value. You need to check and 
update all call sites to catch such errors. Same for all new use of 
ERR_PTR().


> +	}
> +
>   	while (node) {
>   		struct landlock_rule *this = rb_entry(node,
>   				struct landlock_rule, node);
> 
> -		if (this->object == object)
> +		if (this->object.data == object_data)
>   			return this;
> -		if (this->object < object)
> +		if (this->object.data < object_data)
>   			node = node->rb_right;
>   		else
>   			node = node->rb_left;
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index bc87e5f787f7..088b8d95f653 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -50,15 +50,17 @@ struct landlock_rule {
>   	 */
>   	struct rb_node node;
>   	/**
> -	 * @object: Pointer to identify a kernel object (e.g. an inode).  This
> -	 * is used as a key for this ruleset element.  This pointer is set once
> -	 * and never modified.  It always points to an allocated object because
> -	 * each rule increments the refcount of its object.
> -	 */
> -	struct landlock_object *object;
> -	/**
> -	 * @num_layers: Number of entries in @layers.
> +	 * @object: A union to identify either a kernel object (e.g. an inode) or
> +	 * a socket port object.

…or a raw data value (e.g. a network socket port).


> This is used as a key for this ruleset element.
> +	 * This pointer is set once and never modified. It always points to an

s/This pointer/@object.ptr/


> +	 * allocated object because each rule increments the refcount of its
> +	 * object (for inodes);
>   	 */
> +	 union {
> +		struct landlock_object *ptr;
> +		uintptr_t data;
> +	 } object;
> +
>   	u32 num_layers;
>   	/**
>   	 * @layers: Stack of layers, from the latest to the newest, implemented
> @@ -95,7 +97,7 @@ struct landlock_ruleset {
>   	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
>   	 * tree is immutable until @usage reaches zero.
>   	 */
> -	struct rb_root root;
> +	struct rb_root root_inode;
>   	/**
>   	 * @hierarchy: Enables hierarchy identification even when a parent
>   	 * domain vanishes.  This is needed for the ptrace protection.
> @@ -157,7 +159,9 @@ void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
> 
>   int landlock_insert_rule(struct landlock_ruleset *const ruleset,
> -		struct landlock_object *const object, const u32 access);
> +			 struct landlock_object *const object_ptr,
> +			 const uintptr_t object_data,
> +			 const u32 access, const u16 rule_type);
> 
>   struct landlock_ruleset *landlock_merge_ruleset(
>   		struct landlock_ruleset *const parent,
> @@ -165,7 +169,7 @@ struct landlock_ruleset *landlock_merge_ruleset(
> 
>   const struct landlock_rule *landlock_find_rule(
>   		const struct landlock_ruleset *const ruleset,
> -		const struct landlock_object *const object);
> +		const uintptr_t object_data, const u16 rule_type);
> 
>   static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
>   {
> --
> 2.25.1
> 
