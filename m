Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288A95818BD
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiGZRnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbiGZRnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:43:43 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483E426FF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:43:39 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Lskm838q4zMqFZd;
        Tue, 26 Jul 2022 19:43:36 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Lskm7643Vzln8Vn;
        Tue, 26 Jul 2022 19:43:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1658857416;
        bh=5BgfKrkNsgmtxDRifEhcJ55RUP7ATyYdjVU0Xde9Ghg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=b0H/wM+ar0REItWZrLY8Qh+T0F7yXOztAWIWLfKfNQDRbE2Lx/OSq423SMizPoZSE
         vHgZKGm/gqtodPDK2HS9f73TNzOCtk9XjXQ3+LrUcUKZUvVfwX0rKwg32vF6aMqDL9
         X1xlkhWXFwwR9wXqzB1qk5ZFmfeFsE/dGRAiEKgY=
Message-ID: <4c57a0c2-e207-10d6-c73d-bcda66bf3963@digikod.net>
Date:   Tue, 26 Jul 2022 19:43:19 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 00/17] Network support for Landlock
In-Reply-To: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/06/2022 10:22, Konstantin Meskhidze wrote:
> Hi,
> This is a new V6 patch related to Landlock LSM network confinement.
> It is based on the latest landlock-wip branch on top of v5.19-rc2:
> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip
> 
> It brings refactoring of previous patch version V5:
>      - Fixes some logic errors and typos.
>      - Adds additional FIXTURE_VARIANT and FIXTURE_VARIANT_ADD helpers
>      to support both ip4 and ip6 families and shorten seltests' code.
>      - Makes TCP sockets confinement support optional in sandboxer demo.
>      - Formats the code with clang-format-14
> 
> All test were run in QEMU evironment and compiled with
>   -static flag.
>   1. network_test: 18/18 tests passed.
>   2. base_test: 7/7 tests passed.
>   3. fs_test: 59/59 tests passed.
>   4. ptrace_test: 8/8 tests passed.
> 
> Still have issue with base_test were compiled without -static flag
> (landlock-wip branch without network support)
> 1. base_test: 6/7 tests passed.
>   Error:
>   #  RUN           global.inconsistent_attr ...
>   # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>   # inconsistent_attr: Test terminated by assertion
>   #          FAIL  global.inconsistent_attr
> not ok 1 global.inconsistent_attr
> 
> LCOV - code coverage report:
>              Hit  Total  Coverage
> Lines:      952  1010    94.3 %
> Functions:  79   82      96.3 %
> 
> Previous versions:
> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
> 
> Konstantin Meskhidze (17):
>    landlock: renames access mask
>    landlock: refactors landlock_find/insert_rule
>    landlock: refactors merge and inherit functions
>    landlock: moves helper functions
>    landlock: refactors helper functions
>    landlock: refactors landlock_add_rule syscall
>    landlock: user space API network support
>    landlock: adds support network rules
>    landlock: implements TCP network hooks
>    seltests/landlock: moves helper function
>    seltests/landlock: adds tests for bind() hooks
>    seltests/landlock: adds tests for connect() hooks
>    seltests/landlock: adds AF_UNSPEC family test
>    seltests/landlock: adds rules overlapping test
>    seltests/landlock: adds ruleset expanding test
>    seltests/landlock: adds invalid input data test
>    samples/landlock: adds network demo
> 
>   include/uapi/linux/landlock.h               |  49 ++
>   samples/landlock/sandboxer.c                | 118 ++-
>   security/landlock/Kconfig                   |   1 +
>   security/landlock/Makefile                  |   2 +
>   security/landlock/fs.c                      | 162 +---
>   security/landlock/limits.h                  |   8 +-
>   security/landlock/net.c                     | 155 ++++
>   security/landlock/net.h                     |  26 +
>   security/landlock/ruleset.c                 | 448 +++++++++--
>   security/landlock/ruleset.h                 |  91 ++-
>   security/landlock/setup.c                   |   2 +
>   security/landlock/syscalls.c                | 168 +++--
>   tools/testing/selftests/landlock/common.h   |  10 +
>   tools/testing/selftests/landlock/config     |   4 +
>   tools/testing/selftests/landlock/fs_test.c  |  10 -
>   tools/testing/selftests/landlock/net_test.c | 774 ++++++++++++++++++++
>   16 files changed, 1737 insertions(+), 291 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> --
> 2.25.1
> 

I did a thorough review of all the code. I found that the main issue 
with this version is that we stick to the layers limit whereas it is 
only relevant for filesystem hierarchies. You'll find in the following 
patch miscellaneous fixes and improvement, with some TODOs to get rid of 
this layer limit. We'll need a test to check that too. You'll need to 
integrate this diff into your patches though.


* Add union landlock_key, enum landlock_key_type, and struct
   landlock_id.  Refactor ruleset functions with them and improve
   switch/cases: create_rule(), get_root(), free_rule(),
   landlock_find_rule() and init_layer_masks().  This avoids key
   object/pointer and data inconsistencies and enables to safely remove
   the related checks in create_rule().
* Remove masks_size attribute from init_layer_masks().
* Rename landlock_rule.object to landlock_rule.key
* Rename tree_merge to merge_tree (and reorder arguments), and tree_copy
   to inherit_tree.  This is more consistent with their caller:
   merge_ruleset and inherit_ruleset.
* Fix landlock_set_fs_access_mask() and constify similar helpers'
   arguments.
* Fix add_rule_path_beneath() and add_rule_net_service() rule_attr
   argument type.
* Update copyright.
* Add TODOs to implement unlimited layers of network policies and
   simplify the code.
---
  security/landlock/fs.c       |  39 ++--
  security/landlock/limits.h   |   2 +
  security/landlock/net.c      |  22 ++-
  security/landlock/net.h      |   2 +-
  security/landlock/ruleset.c  | 358 ++++++++++++++++-------------------
  security/landlock/ruleset.h  |  60 ++++--
  security/landlock/syscalls.c |   4 +-
  7 files changed, 242 insertions(+), 245 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 10f6c67f5c3b..7198bb8a7dac 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -157,7 +157,9 @@ int landlock_append_fs_rule(struct landlock_ruleset 
*const ruleset,
  			    access_mask_t access_rights)
  {
  	int err;
-	struct landlock_object *object;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_INODE,
+	};

  	/* Files only get access rights that make sense. */
  	if (!d_is_dir(path->dentry) &&
@@ -169,18 +171,17 @@ int landlock_append_fs_rule(struct 
landlock_ruleset *const ruleset,
  	/* Transforms relative access rights to absolute ones. */
  	access_rights |= LANDLOCK_MASK_ACCESS_FS &
  			 ~landlock_get_fs_access_mask(ruleset, 0);
-	object = get_inode_object(d_backing_inode(path->dentry));
-	if (IS_ERR(object))
-		return PTR_ERR(object);
+	id.key.object = get_inode_object(d_backing_inode(path->dentry));
+	if (IS_ERR(id.key.object))
+		return PTR_ERR(id.key.object);
  	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, object, 0, access_rights,
-				   LANDLOCK_RULE_PATH_BENEATH);
+	err = landlock_insert_rule(ruleset, id, access_rights);
  	mutex_unlock(&ruleset->lock);
  	/*
  	 * No need to check for an error because landlock_insert_rule()
  	 * increments the refcount for the new object if needed.
  	 */
-	landlock_put_object(object);
+	landlock_put_object(id.key.object);
  	return err;
  }

@@ -197,6 +198,9 @@ find_rule(const struct landlock_ruleset *const domain,
  {
  	const struct landlock_rule *rule;
  	const struct inode *inode;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_INODE,
+	};

  	/* Ignores nonexistent leafs. */
  	if (d_is_negative(dentry))
@@ -204,10 +208,8 @@ find_rule(const struct landlock_ruleset *const domain,

  	inode = d_backing_inode(dentry);
  	rcu_read_lock();
-	rule = landlock_find_rule(
-		domain,
-		(uintptr_t)rcu_dereference(landlock_inode(inode)->object),
-		LANDLOCK_RULE_PATH_BENEATH);
+	id.key.object = rcu_dereference(landlock_inode(inode)->object);
+	rule = landlock_find_rule(domain, id);
  	rcu_read_unlock();
  	return rule;
  }
@@ -416,8 +418,7 @@ static int check_access_path_dual(
  		unmask_layers(find_rule(domain, dentry_child1),
  			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
  					       &_layer_masks_child1,
-					       sizeof(_layer_masks_child1),
-					       LANDLOCK_RULE_PATH_BENEATH),
+					       LANDLOCK_KEY_INODE),
  			      &_layer_masks_child1,
  			      ARRAY_SIZE(_layer_masks_child1));
  		layer_masks_child1 = &_layer_masks_child1;
@@ -427,8 +428,7 @@ static int check_access_path_dual(
  		unmask_layers(find_rule(domain, dentry_child2),
  			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
  					       &_layer_masks_child2,
-					       sizeof(_layer_masks_child2),
-					       LANDLOCK_RULE_PATH_BENEATH),
+					       LANDLOCK_KEY_INODE),
  			      &_layer_masks_child2,
  			      ARRAY_SIZE(_layer_masks_child2));
  		layer_masks_child2 = &_layer_masks_child2;
@@ -548,8 +548,7 @@ static inline int check_access_path(const struct 
landlock_ruleset *const domain,
  	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};

  	access_request = init_layer_masks(domain, access_request, &layer_masks,
-					  sizeof(layer_masks),
-					  LANDLOCK_RULE_PATH_BENEATH);
+					  LANDLOCK_KEY_INODE);
  	return check_access_path_dual(domain, path, access_request,
  				      &layer_masks, NULL, 0, NULL, NULL);
  }
@@ -633,8 +632,7 @@ static bool collect_domain_accesses(
  		return true;

  	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
-				      layer_masks_dom, sizeof(*layer_masks_dom),
-				      LANDLOCK_RULE_PATH_BENEATH);
+				      layer_masks_dom, LANDLOCK_KEY_INODE);

  	dget(dir);
  	while (true) {
@@ -759,8 +757,7 @@ static int current_check_refer_path(struct dentry 
*const old_dentry,
  		 */
  		access_request_parent1 = init_layer_masks(
  			dom, access_request_parent1 | access_request_parent2,
-			&layer_masks_parent1, sizeof(layer_masks_parent1),
-			LANDLOCK_RULE_PATH_BENEATH);
+			&layer_masks_parent1, LANDLOCK_KEY_INODE);
  		return check_access_path_dual(dom, new_dir,
  					      access_request_parent1,
  					      &layer_masks_parent1, NULL, 0,
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 23694bf05cb7..660335258466 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -25,6 +25,8 @@
  #define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
  #define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
  #define LANDLOCK_NUM_ACCESS_NET	 
__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
+// TODO: LANDLOCK_MASK_SHIFT_NET will not be useful with the new
+// ruleset->net_access_mask
  #define LANDLOCK_MASK_SHIFT_NET		16

  #define LANDLOCK_RULE_TYPE_NUM		LANDLOCK_RULE_NET_SERVICE
diff --git a/security/landlock/net.c b/security/landlock/net.c
index da63e4f1dca4..0d249ad619bf 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -2,7 +2,8 @@
  /*
   * Landlock LSM - Network management and hooks
   *
- * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ * Copyright © 2022 Huawei Tech. Co., Ltd.
+ * Copyright © 2022 Microsoft Corporation
   */

  #include <linux/in.h>
@@ -18,15 +19,18 @@ int landlock_append_net_rule(struct landlock_ruleset 
*const ruleset, u16 port,
  			     u32 access_rights)
  {
  	int err;
+	const struct landlock_id id = {
+		.key.data = port,
+		.type = LANDLOCK_KEY_NET_PORT,
+	};
+	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));

  	/* Transforms relative access rights to absolute ones. */
  	access_rights |= LANDLOCK_MASK_ACCESS_NET &
  			 ~landlock_get_net_access_mask(ruleset, 0);

-	BUILD_BUG_ON(sizeof(port) > sizeof(uintptr_t));
  	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, NULL, port, access_rights,
-				   LANDLOCK_RULE_NET_SERVICE);
+	err = landlock_insert_rule(ruleset, id, access_rights);
  	mutex_unlock(&ruleset->lock);

  	return err;
@@ -39,17 +43,19 @@ static int check_socket_access(const struct 
landlock_ruleset *const domain,
  	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
  	const struct landlock_rule *rule;
  	access_mask_t handled_access;
+	const struct landlock_id id = {
+		.key.data = port,
+		.type = LANDLOCK_KEY_NET_PORT,
+	};

  	if (WARN_ON_ONCE(!domain))
  		return 0;
  	if (WARN_ON_ONCE(domain->num_layers < 1))
  		return -EACCES;

-	rule = landlock_find_rule(domain, port, LANDLOCK_RULE_NET_SERVICE);
-
+	rule = landlock_find_rule(domain, id);
  	handled_access = init_layer_masks(domain, access_request, &layer_masks,
-					  sizeof(layer_masks),
-					  LANDLOCK_RULE_NET_SERVICE);
+					  LANDLOCK_KEY_NET_PORT);
  	allowed = unmask_layers(rule, handled_access, &layer_masks,
  				ARRAY_SIZE(layer_masks));

diff --git a/security/landlock/net.h b/security/landlock/net.h
index 7a79fb4bf3dd..2c63a8f1b258 100644
--- a/security/landlock/net.h
+++ b/security/landlock/net.h
@@ -2,7 +2,7 @@
  /*
   * Landlock LSM - Network management and hooks
   *
- * Copyright (C) 2022 Huawei Tech. Co., Ltd.
+ * Copyright © 2022 Huawei Tech. Co., Ltd.
   */

  #ifndef _SECURITY_LANDLOCK_NET_H
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 469811a77675..e7555b16069a 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -74,9 +74,20 @@ static void build_check_rule(void)
  	BUILD_BUG_ON(rule.num_layers < LANDLOCK_MAX_NUM_LAYERS);
  }

+static inline bool is_object_pointer(const enum landlock_key_type key_type)
+{
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		return true;
+	case LANDLOCK_KEY_NET_PORT:
+		return false;
+	}
+	WARN_ON_ONCE(1);
+	return false;
+}
+
  static struct landlock_rule *
-create_rule(struct landlock_object *const object_ptr,
-	    const uintptr_t object_data,
+create_rule(const struct landlock_id id,
  	    const struct landlock_layer (*const layers)[], const u32 num_layers,
  	    const struct landlock_layer *const new_layer)
  {
@@ -97,17 +108,13 @@ create_rule(struct landlock_object *const object_ptr,
  	if (!new_rule)
  		return ERR_PTR(-ENOMEM);
  	RB_CLEAR_NODE(&new_rule->node);
-
-	if (object_ptr && !object_data) {
-		landlock_get_object(object_ptr);
-		new_rule->object.ptr = object_ptr;
-	} else if (object_data && !object_ptr) {
-		new_rule->object.data = object_data;
-	} else if (object_ptr && object_data) {
-		WARN_ON_ONCE(1);
-		return ERR_PTR(-EINVAL);
+	if (is_object_pointer(id.type)) {
+		/* This should be catched by insert_rule(). */
+		WARN_ON_ONCE(!id.key.object);
+		landlock_get_object(id.key.object);
  	}

+	new_rule->key = id.key;
  	new_rule->num_layers = new_num_layers;
  	/* Copies the original layer stack. */
  	memcpy(new_rule->layers, layers,
@@ -118,16 +125,32 @@ create_rule(struct landlock_object *const object_ptr,
  	return new_rule;
  }

-static void free_rule(struct landlock_rule *const rule, const u16 
rule_type)
+static inline struct rb_root *get_root(struct landlock_ruleset *const 
ruleset,
+				       const enum landlock_key_type key_type)
+{
+	struct rb_root *root = NULL;
+
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		root = &ruleset->root_inode;
+		break;
+	case LANDLOCK_KEY_NET_PORT:
+		root = &ruleset->root_net_port;
+		break;
+	}
+	if (WARN_ON_ONCE(!root))
+		return ERR_PTR(-EINVAL);
+	return root;
+}
+
+static void free_rule(struct landlock_rule *const rule,
+		      const enum landlock_key_type key_type)
  {
  	might_sleep();
  	if (!rule)
  		return;
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		landlock_put_object(rule->object.ptr);
-		break;
-	}
+	if (is_object_pointer(key_type))
+		landlock_put_object(rule->key.object);
  	kfree(rule);
  }

@@ -150,8 +173,8 @@ static void build_check_ruleset(void)
   * insert_rule - Create and insert a rule in a ruleset
   *
   * @ruleset: The ruleset to be updated.
- * @object: The object to build the new rule with.  The underlying kernel
- *          object must be held by the caller.
+ * @id: The ID to build the new rule with.  The underlying kernel 
object, if
+ *      any, must be held by the caller.
   * @layers: One or multiple layers to be copied into the new rule.
   * @num_layers: The number of @layers entries.
   *
@@ -165,10 +188,9 @@ static void build_check_ruleset(void)
   * access rights.
   */
  static int insert_rule(struct landlock_ruleset *const ruleset,
-		       struct landlock_object *const object_ptr,
-		       uintptr_t object_data, u16 rule_type,
+		       const struct landlock_id id,
  		       const struct landlock_layer (*const layers)[],
-		       size_t num_layers)
+		       const size_t num_layers)
  {
  	struct rb_node **walker_node;
  	struct rb_node *parent_node = NULL;
@@ -179,33 +201,24 @@ static int insert_rule(struct landlock_ruleset 
*const ruleset,
  	lockdep_assert_held(&ruleset->lock);
  	if (WARN_ON_ONCE(!layers))
  		return -ENOENT;
-	if (WARN_ON_ONCE(object_ptr && object_data))
-		return -EINVAL;
-	/* Chooses rb_tree structure depending on a rule type. */
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		if (WARN_ON_ONCE(!object_ptr))
+
+	if (is_object_pointer(id.type)) {
+		if (WARN_ON_ONCE(!id.key.object))
  			return -ENOENT;
-		object_data = (uintptr_t)object_ptr;
-		root = &ruleset->root_inode;
-		break;
-	case LANDLOCK_RULE_NET_SERVICE:
-		if (WARN_ON_ONCE(object_ptr))
-			return -EINVAL;
-		root = &ruleset->root_net_port;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EINVAL;
  	}
+
+	root = get_root(ruleset, id.type);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
  	walker_node = &root->rb_node;
  	while (*walker_node) {
  		struct landlock_rule *const this =
  			rb_entry(*walker_node, struct landlock_rule, node);

-		if (this->object.data != object_data) {
+		if (this->key.data != id.key.data) {
  			parent_node = *walker_node;
-			if (this->object.data < object_data)
+			if (this->key.data < id.key.data)
  				walker_node = &((*walker_node)->rb_right);
  			else
  				walker_node = &((*walker_node)->rb_left);
@@ -237,52 +250,27 @@ static int insert_rule(struct landlock_ruleset 
*const ruleset,
  		 * Intersects access rights when it is a merge between a
  		 * ruleset and a domain.
  		 */
-		switch (rule_type) {
-		case LANDLOCK_RULE_PATH_BENEATH:
-			new_rule = create_rule(object_ptr, 0, &this->layers,
-					       this->num_layers, &(*layers)[0]);
-			if (IS_ERR(new_rule))
-				return PTR_ERR(new_rule);
-			rb_replace_node(&this->node, &new_rule->node,
-					&ruleset->root_inode);
-			free_rule(this, rule_type);
-			break;
-		case LANDLOCK_RULE_NET_SERVICE:
-			new_rule = create_rule(NULL, object_data, &this->layers,
-					       this->num_layers, &(*layers)[0]);
-			if (IS_ERR(new_rule))
-				return PTR_ERR(new_rule);
-			rb_replace_node(&this->node, &new_rule->node,
-					&ruleset->root_net_port);
-			free_rule(this, rule_type);
-			break;
-		}
+		// TODO: Don't create a new rule but AND accesses (of the first
+		// and only layer) if !is_object_pointer(id.type)
+		new_rule = create_rule(id, &this->layers, this->num_layers,
+				       &(*layers)[0]);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_replace_node(&this->node, &new_rule->node, root);
+		free_rule(this, id.type);
  		return 0;
  	}

-	/* There is no match for @object. */
+	/* There is no match for @id. */
  	build_check_ruleset();
  	if (ruleset->num_rules >= LANDLOCK_MAX_NUM_RULES)
  		return -E2BIG;
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL);
-		if (IS_ERR(new_rule))
-			return PTR_ERR(new_rule);
-		rb_link_node(&new_rule->node, parent_node, walker_node);
-		rb_insert_color(&new_rule->node, &ruleset->root_inode);
-		ruleset->num_rules++;
-		break;
-	case LANDLOCK_RULE_NET_SERVICE:
-		new_rule = create_rule(NULL, object_data, layers, num_layers,
-				       NULL);
-		if (IS_ERR(new_rule))
-			return PTR_ERR(new_rule);
-		rb_link_node(&new_rule->node, parent_node, walker_node);
-		rb_insert_color(&new_rule->node, &ruleset->root_net_port);
-		ruleset->num_rules++;
-		break;
-	}
+	new_rule = create_rule(id, layers, num_layers, NULL);
+	if (IS_ERR(new_rule))
+		return PTR_ERR(new_rule);
+	rb_link_node(&new_rule->node, parent_node, walker_node);
+	rb_insert_color(&new_rule->node, root);
+	ruleset->num_rules++;
  	return 0;
  }

@@ -299,9 +287,8 @@ static void build_check_layer(void)

  /* @ruleset must be locked by the caller. */
  int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object_ptr,
-			 const uintptr_t object_data,
-			 const access_mask_t access, const u16 rule_type)
+			 const struct landlock_id id,
+			 const access_mask_t access)
  {
  	struct landlock_layer layers[] = { {
  		.access = access,
@@ -310,8 +297,7 @@ int landlock_insert_rule(struct landlock_ruleset 
*const ruleset,
  	} };

  	build_check_layer();
-	return insert_rule(ruleset, object_ptr, object_data, rule_type, &layers,
-			   ARRAY_SIZE(layers));
+	return insert_rule(ruleset, id, &layers, ARRAY_SIZE(layers));
  }

  static inline void get_hierarchy(struct landlock_hierarchy *const 
hierarchy)
@@ -330,53 +316,37 @@ static void put_hierarchy(struct 
landlock_hierarchy *hierarchy)
  	}
  }

-static int tree_merge(struct landlock_ruleset *const src,
-		      struct landlock_ruleset *const dst, u16 rule_type)
+static int merge_tree(struct landlock_ruleset *const dst,
+		      struct landlock_ruleset *const src,
+		      const enum landlock_key_type key_type)
  {
  	struct landlock_rule *walker_rule, *next_rule;
  	struct rb_root *src_root;
  	int err = 0;

-	/* Chooses rb_tree structure depending on a rule type. */
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		src_root = &src->root_inode;
-		break;
-	case LANDLOCK_RULE_NET_SERVICE:
-		src_root = &src->root_net_port;
-		break;
-	default:
-		return -EINVAL;
-	}
+	src_root = get_root(src, key_type);
+	if (IS_ERR(src_root))
+		return PTR_ERR(src_root);
+
  	/* Merges the @src tree. */
  	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
  					     node) {
  		struct landlock_layer layers[] = { {
+			// TODO: Set level to 1 if !is_object_pointer(key_type).
  			.level = dst->num_layers,
  		} };
+		const struct landlock_id id = {
+			.key = walker_rule->key,
+			.type = key_type,
+		};

-		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
-			err = -EINVAL;
-			return err;
-		}
-		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
-			err = -EINVAL;
-			return err;
-		}
+		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
+			return -EINVAL;
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
+			return -EINVAL;
  		layers[0].access = walker_rule->layers[0].access;

-		switch (rule_type) {
-		case LANDLOCK_RULE_PATH_BENEATH:
-			err = insert_rule(dst, walker_rule->object.ptr, 0,
-					  rule_type, &layers,
-					  ARRAY_SIZE(layers));
-			break;
-		case LANDLOCK_RULE_NET_SERVICE:
-			err = insert_rule(dst, NULL, walker_rule->object.data,
-					  rule_type, &layers,
-					  ARRAY_SIZE(layers));
-			break;
-		}
+		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
  		if (err)
  			return err;
  	}
@@ -408,11 +378,12 @@ static int merge_ruleset(struct landlock_ruleset 
*const dst,
  	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

  	/* Merges the @src inode tree. */
-	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
+	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
  	if (err)
  		goto out_unlock;
-	/* Merges the @src network tree. */
-	err = tree_merge(src, dst, LANDLOCK_RULE_NET_SERVICE);
+
+	/* Merges the @src network port tree. */
+	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
  	if (err)
  		goto out_unlock;

@@ -422,39 +393,28 @@ static int merge_ruleset(struct landlock_ruleset 
*const dst,
  	return err;
  }

-static int tree_copy(struct landlock_ruleset *const parent,
-		     struct landlock_ruleset *const child, u16 rule_type)
+static int inherit_tree(struct landlock_ruleset *const parent,
+			struct landlock_ruleset *const child,
+			const enum landlock_key_type key_type)
  {
  	struct landlock_rule *walker_rule, *next_rule;
  	struct rb_root *parent_root;
  	int err = 0;

-	/* Chooses rb_tree structure depending on a rule type. */
-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		parent_root = &parent->root_inode;
-		break;
-	case LANDLOCK_RULE_NET_SERVICE:
-		parent_root = &parent->root_net_port;
-		break;
-	default:
-		return -EINVAL;
-	}
+	parent_root = get_root(parent, key_type);
+	if (IS_ERR(parent_root))
+		return PTR_ERR(parent_root);
+
  	/* Copies the @parent inode or network tree. */
  	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
  					     parent_root, node) {
-		switch (rule_type) {
-		case LANDLOCK_RULE_PATH_BENEATH:
-			err = insert_rule(child, walker_rule->object.ptr, 0,
-					  rule_type, &walker_rule->layers,
-					  walker_rule->num_layers);
-			break;
-		case LANDLOCK_RULE_NET_SERVICE:
-			err = insert_rule(child, NULL, walker_rule->object.data,
-					  rule_type, &walker_rule->layers,
-					  walker_rule->num_layers);
-			break;
-		}
+		const struct landlock_id id = {
+			.key = walker_rule->key,
+			.type = key_type,
+		};
+
+		err = insert_rule(child, id, &walker_rule->layers,
+				  walker_rule->num_layers);
  		if (err)
  			return err;
  	}
@@ -475,11 +435,12 @@ static int inherit_ruleset(struct landlock_ruleset 
*const parent,
  	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);

  	/* Copies the @parent inode tree. */
-	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
  	if (err)
  		goto out_unlock;
-	/* Copies the @parent network tree. */
-	err = tree_copy(parent, child, LANDLOCK_RULE_NET_SERVICE);
+
+	/* Copies the @parent network port tree. */
+	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
  	if (err)
  		goto out_unlock;

@@ -514,10 +475,10 @@ static void free_ruleset(struct landlock_ruleset 
*const ruleset)
  	might_sleep();
  	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
  					     node)
-		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
+		free_rule(freeme, LANDLOCK_KEY_INODE);
  	rbtree_postorder_for_each_entry_safe(freeme, next,
  					     &ruleset->root_net_port, node)
-		free_rule(freeme, LANDLOCK_RULE_NET_SERVICE);
+		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
  	put_hierarchy(ruleset->hierarchy);
  	kfree(ruleset);
  }
@@ -570,6 +531,7 @@ landlock_merge_ruleset(struct landlock_ruleset 
*const parent,
  		if (parent->num_layers >= LANDLOCK_MAX_NUM_LAYERS)
  			return ERR_PTR(-E2BIG);
  		num_layers = parent->num_layers + 1;
+		// TODO: Don't increment num_layers if 
RB_EMPTY_ROOT(&ruleset->root_inode).
  	} else {
  		num_layers = 1;
  	}
@@ -608,29 +570,23 @@ landlock_merge_ruleset(struct landlock_ruleset 
*const parent,
   */
  const struct landlock_rule *
  landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const uintptr_t object_data, const u16 rule_type)
+		   const struct landlock_id id)
  {
+	const struct rb_root *root;
  	const struct rb_node *node;

-	switch (rule_type) {
-	case LANDLOCK_RULE_PATH_BENEATH:
-		node = ruleset->root_inode.rb_node;
-		break;
-	case LANDLOCK_RULE_NET_SERVICE:
-		node = ruleset->root_net_port.rb_node;
-		break;
-	default:
-		WARN_ON_ONCE(1);
+	root = get_root((struct landlock_ruleset *)ruleset, id.type);
+	if (IS_ERR(root))
  		return NULL;
-	}
+	node = root->rb_node;

  	while (node) {
  		struct landlock_rule *this =
  			rb_entry(node, struct landlock_rule, node);

-		if (this->object.data == object_data)
+		if (this->key.data == id.key.data)
  			return this;
-		if (this->object.data < object_data)
+		if (this->key.data < id.key.data)
  			node = node->rb_right;
  		else
  			node = node->rb_left;
@@ -638,6 +594,8 @@ landlock_find_rule(const struct landlock_ruleset 
*const ruleset,
  	return NULL;
  }

+// XXX: If there is no use of this helper for net, then it should 
remains in fs.c
+// BTW, num_access is unused
  access_mask_t get_handled_accesses(const struct landlock_ruleset 
*const domain,
  				   u16 rule_type, u16 num_access)
  {
@@ -670,13 +628,15 @@ access_mask_t get_handled_accesses(const struct 
landlock_ruleset *const domain,
  /*
   * @layer_masks is read and may be updated according to the access 
request and
   * the matching rule.
+ * @masks_array_size must be equal to ARRAY_SIZE(*layer_masks).
   *
   * Returns true if the request is allowed (i.e. relevant layer masks 
for the
   * request are empty).
   */
  bool unmask_layers(const struct landlock_rule *const rule,
  		   const access_mask_t access_request,
-		   layer_mask_t (*const layer_masks)[], size_t masks_array_size)
+		   layer_mask_t (*const layer_masks)[],
+		   const size_t masks_array_size)
  {
  	size_t layer_level;

@@ -719,15 +679,43 @@ bool unmask_layers(const struct landlock_rule 
*const rule,
  	return false;
  }

+typedef access_mask_t
+get_access_mask_t(const struct landlock_ruleset *const ruleset,
+		  const u16 layer_level);
+
+/*
+ * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or 
LANDLOCK_NUM_ACCESS_NET
+ * elements according to @key_type.
+ */
  access_mask_t init_layer_masks(const struct landlock_ruleset *const 
domain,
  			       const access_mask_t access_request,
  			       layer_mask_t (*const layer_masks)[],
-			       size_t masks_size, u16 rule_type)
+			       const enum landlock_key_type key_type)
  {
  	access_mask_t handled_accesses = 0;
-	size_t layer_level;
+	size_t layer_level, num_access;
+	get_access_mask_t *get_access_mask;
+
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		// XXX: landlock_get_fs_access_mask() should not be removed
+		// once we use ruleset->net_access_mask, and we can then
+		// replace the @key_type argument with num_access to make the
+		// code simpler.
+		get_access_mask = landlock_get_fs_access_mask;
+		num_access = LANDLOCK_NUM_ACCESS_FS;
+		break;
+	case LANDLOCK_KEY_NET_PORT:
+		get_access_mask = landlock_get_net_access_mask;
+		num_access = LANDLOCK_NUM_ACCESS_NET;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}

-	memset(layer_masks, 0, masks_size);
+	memset(layer_masks, 0,
+	       array_size(sizeof((*layer_masks)[0]), num_access));

  	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
  	if (!access_request)
@@ -738,33 +726,13 @@ access_mask_t init_layer_masks(const struct 
landlock_ruleset *const domain,
  		const unsigned long access_req = access_request;
  		unsigned long access_bit;

-		switch (rule_type) {
-		case LANDLOCK_RULE_PATH_BENEATH:
-			for_each_set_bit(access_bit, &access_req,
-					 LANDLOCK_NUM_ACCESS_FS) {
-				if (landlock_get_fs_access_mask(domain,
-								layer_level) &
-				    BIT_ULL(access_bit)) {
-					(*layer_masks)[access_bit] |=
-						BIT_ULL(layer_level);
-					handled_accesses |= BIT_ULL(access_bit);
-				}
-			}
-			break;
-		case LANDLOCK_RULE_NET_SERVICE:
-			for_each_set_bit(access_bit, &access_req,
-					 LANDLOCK_NUM_ACCESS_NET) {
-				if (landlock_get_net_access_mask(domain,
-								 layer_level) &
-				    BIT_ULL(access_bit)) {
-					(*layer_masks)[access_bit] |=
-						BIT_ULL(layer_level);
-					handled_accesses |= BIT_ULL(access_bit);
-				}
+		for_each_set_bit(access_bit, &access_req, num_access) {
+			if (get_access_mask(domain, layer_level) &
+			    BIT_ULL(access_bit)) {
+				(*layer_masks)[access_bit] |=
+					BIT_ULL(layer_level);
+				handled_accesses |= BIT_ULL(access_bit);
  			}
-			break;
-		default:
-			return 0;
  		}
  	}
  	return handled_accesses;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 0cedfe65e326..59229be378d6 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -19,9 +19,12 @@
  #include "limits.h"
  #include "object.h"

+// TODO: get back to u16 thanks to ruleset->net_access_mask
  typedef u32 access_mask_t;
  /* Makes sure all filesystem access rights can be stored. */
  static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
+/* Makes sure all network access rights can be stored. */
+static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
  /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
  static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));

@@ -44,6 +47,21 @@ struct landlock_layer {
  	access_mask_t access;
  };

+union landlock_key {
+	struct landlock_object *object;
+	uintptr_t data;
+};
+
+enum landlock_key_type {
+	LANDLOCK_KEY_INODE = 1,
+	LANDLOCK_KEY_NET_PORT = 2,
+};
+
+struct landlock_id {
+	union landlock_key key;
+	const enum landlock_key_type type;
+};
+
  /**
   * struct landlock_rule - Access rights tied to an object
   */
@@ -53,17 +71,16 @@ struct landlock_rule {
  	 */
  	struct rb_node node;
  	/**
-	 * @object: A union to identify either a kernel object (e.g. an inode) or
+	 * @key: A union to identify either a kernel object (e.g. an inode) or
  	 * a raw data value (e.g. a network socket port). This is used as a key
-	 * for this ruleset element. This pointer/@object.ptr/ is set once and
-	 * never modified. It always points to an allocated object because each
-	 * rule increments the refcount of its object (for inodes).;
+	 * for this ruleset element.  The pointer is set once and never
+	 * modified.  It always points to an allocated object because each rule
+	 * increments the refcount of its object.
+	 */
+	union landlock_key key;
+	/**
+	 * @num_layers: Number of entries in @layers.
  	 */
-	union {
-		struct landlock_object *ptr;
-		uintptr_t data;
-	} object;
-
  	u32 num_layers;
  	/**
  	 * @layers: Stack of layers, from the latest to the newest, implemented
@@ -117,8 +134,8 @@ struct landlock_ruleset {
  		 * @work_free: Enables to free a ruleset within a lockless
  		 * section.  This is only used by
  		 * landlock_put_ruleset_deferred() when @usage reaches zero.
-		 * The fields @lock, @usage, @num_rules, @num_layers and
-		 * @access_masks are then unused.
+		 * The fields @lock, @usage, @num_rules, @num_layers,
+		 * @net_access_mask and @access_masks are then unused.
  		 */
  		struct work_struct work_free;
  		struct {
@@ -144,6 +161,11 @@ struct landlock_ruleset {
  			 * non-merged ruleset (i.e. not a domain).
  			 */
  			u32 num_layers;
+			/**
+			 * TODO: net_access_mask: Contains the subset of network
+			 * actions that are restricted by a ruleset.
+			 */
+			access_mask_t net_access_mask;
  			/**
  			 * @access_masks: Contains the subset of filesystem
  			 * actions that are restricted by a ruleset.  A domain
@@ -156,6 +178,8 @@ struct landlock_ruleset {
  			 * layers are set once and never changed for the
  			 * lifetime of the ruleset.
  			 */
+			// TODO: rename (back) to fs_access_mask because layers
+			// are only useful for file hierarchies.
  			access_mask_t access_masks[];
  		};
  	};
@@ -169,9 +193,8 @@ void landlock_put_ruleset(struct landlock_ruleset 
*const ruleset);
  void landlock_put_ruleset_deferred(struct landlock_ruleset *const 
ruleset);

  int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object_ptr,
-			 const uintptr_t object_data,
-			 const access_mask_t access, const u16 rule_type);
+			 const struct landlock_id id,
+			 const access_mask_t access);

  struct landlock_ruleset *
  landlock_merge_ruleset(struct landlock_ruleset *const parent,
@@ -179,7 +202,7 @@ landlock_merge_ruleset(struct landlock_ruleset 
*const parent,

  const struct landlock_rule *
  landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const uintptr_t object_data, const u16 rule_type);
+		   const struct landlock_id id);

  static inline void landlock_get_ruleset(struct landlock_ruleset *const 
ruleset)
  {
@@ -187,6 +210,7 @@ static inline void landlock_get_ruleset(struct 
landlock_ruleset *const ruleset)
  		refcount_inc(&ruleset->usage);
  }

+// TODO: These helpers should not be required thanks to the new 
ruleset->net_access_mask.
  /* A helper function to set a filesystem mask. */
  static inline void
  landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
@@ -222,16 +246,16 @@ landlock_get_net_access_mask(const struct 
landlock_ruleset *ruleset,
  }

  access_mask_t get_handled_accesses(const struct landlock_ruleset 
*const domain,
-				   u16 rule_type, u16 num_access);
+				   const u16 rule_type, const u16 num_access);

  bool unmask_layers(const struct landlock_rule *const rule,
  		   const access_mask_t access_request,
  		   layer_mask_t (*const layer_masks)[],
-		   size_t masks_array_size);
+		   const size_t masks_array_size);

  access_mask_t init_layer_masks(const struct landlock_ruleset *const 
domain,
  			       const access_mask_t access_request,
  			       layer_mask_t (*const layer_masks)[],
-			       size_t masks_size, u16 rule_type);
+			       const enum landlock_key_type key_type);

  #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 5069fac2ecf6..880c2adec788 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -289,7 +289,7 @@ static int get_path_from_fd(const s32 fd, struct 
path *const path)
  }

  static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
-				 const void *const rule_attr)
+				 const void __user *const rule_attr)
  {
  	struct landlock_path_beneath_attr path_beneath_attr;
  	struct path path;
@@ -330,7 +330,7 @@ static int add_rule_path_beneath(struct 
landlock_ruleset *const ruleset,
  }

  static int add_rule_net_service(struct landlock_ruleset *ruleset,
-				const void *const rule_attr)
+				const void __user *const rule_attr)
  {
  #if IS_ENABLED(CONFIG_INET)
  	struct landlock_net_service_attr net_service_attr;
