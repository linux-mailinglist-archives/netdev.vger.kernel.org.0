Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A1F528873
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245177AbiEPPVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245185AbiEPPUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:20:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133873B550;
        Mon, 16 May 2022 08:20:52 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22tk1nNdz688Zv;
        Mon, 16 May 2022 23:17:50 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:20:49 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 02/15] landlock: landlock_find/insert_rule refactoring
Date:   Mon, 16 May 2022 23:20:25 +0800
Message-ID: <20220516152038.39594-3-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new object union added to support a socket port
rule type. To support it landlock_insert_rule() and
landlock_find_rule() were refactored. Now adding
or searching a rule in a ruleset depends on a
rule_type argument provided in refactored
functions mentioned above.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Refactoring landlock_insert_rule and landlock_find_rule functions.
* Rename new_ruleset->root_inode.

Changes since v4:
* Refactoring insert_rule() and create_rule() functions by deleting
rule_type from their arguments list, it helps to reduce useless code.

---
 security/landlock/fs.c      |   8 ++-
 security/landlock/ruleset.c | 129 +++++++++++++++++++++++++-----------
 security/landlock/ruleset.h |  32 +++++----
 3 files changed, 113 insertions(+), 56 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 8eea52e5a3a4..5de24d4dd74c 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -173,7 +173,8 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 	if (IS_ERR(object))
 		return PTR_ERR(object);
 	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, object, access_rights);
+	err = landlock_insert_rule(ruleset, object, 0, access_rights,
+				   LANDLOCK_RULE_PATH_BENEATH);
 	mutex_unlock(&ruleset->lock);
 	/*
 	 * No need to check for an error because landlock_insert_rule()
@@ -203,8 +204,9 @@ find_rule(const struct landlock_ruleset *const domain,

 	inode = d_backing_inode(dentry);
 	rcu_read_lock();
-	rule = landlock_find_rule(
-		domain, rcu_dereference(landlock_inode(inode)->object));
+	rule = landlock_find_rule(domain,
+			(uintptr_t)rcu_dereference(landlock_inode(inode)->object),
+			LANDLOCK_RULE_PATH_BENEATH);
 	rcu_read_unlock();
 	return rule;
 }
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index b8917f6a8050..f079a2a320f1 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -35,7 +35,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&new_ruleset->usage, 1);
 	mutex_init(&new_ruleset->lock);
-	new_ruleset->root = RB_ROOT;
+	new_ruleset->root_inode = RB_ROOT;
 	new_ruleset->num_layers = num_layers;
 	/*
 	 * hierarchy = NULL
@@ -69,10 +69,12 @@ static void build_check_rule(void)
 	BUILD_BUG_ON(rule.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 }

-static struct landlock_rule *
-create_rule(struct landlock_object *const object,
-	    const struct landlock_layer (*const layers)[], const u32 num_layers,
-	    const struct landlock_layer *const new_layer)
+static struct landlock_rule *create_rule(
+		struct landlock_object *const object_ptr,
+		const uintptr_t object_data,
+		const struct landlock_layer (*const layers)[],
+		const u32 num_layers,
+		const struct landlock_layer *const new_layer)
 {
 	struct landlock_rule *new_rule;
 	u32 new_num_layers;
@@ -91,8 +93,15 @@ create_rule(struct landlock_object *const object,
 	if (!new_rule)
 		return ERR_PTR(-ENOMEM);
 	RB_CLEAR_NODE(&new_rule->node);
-	landlock_get_object(object);
-	new_rule->object = object;
+
+	if (object_ptr) {
+		landlock_get_object(object_ptr);
+		new_rule->object.ptr = object_ptr;
+	} else if (object_ptr && object_data) {
+		WARN_ON_ONCE(1);
+		return ERR_PTR(-EINVAL);
+	}
+
 	new_rule->num_layers = new_num_layers;
 	/* Copies the original layer stack. */
 	memcpy(new_rule->layers, layers,
@@ -108,7 +117,7 @@ static void free_rule(struct landlock_rule *const rule)
 	might_sleep();
 	if (!rule)
 		return;
-	landlock_put_object(rule->object);
+	landlock_put_object(rule->object.ptr);
 	kfree(rule);
 }

@@ -144,26 +153,44 @@ static void build_check_ruleset(void)
  * access rights.
  */
 static int insert_rule(struct landlock_ruleset *const ruleset,
-		       struct landlock_object *const object,
-		       const struct landlock_layer (*const layers)[],
-		       size_t num_layers)
+		struct landlock_object *const object_ptr,
+		uintptr_t object_data, u16 rule_type,
+		const struct landlock_layer (*const layers)[],
+		size_t num_layers)
 {
 	struct rb_node **walker_node;
 	struct rb_node *parent_node = NULL;
 	struct landlock_rule *new_rule;
+	struct rb_root *root;

 	might_sleep();
 	lockdep_assert_held(&ruleset->lock);
-	if (WARN_ON_ONCE(!object || !layers))
+	/* Choose rb_tree structure depending on a rule type */
+
+	if (WARN_ON_ONCE(!layers))
 		return -ENOENT;
-	walker_node = &(ruleset->root.rb_node);
+	if (WARN_ON_ONCE(object_ptr && object_data))
+		return -EINVAL;
+
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		if (WARN_ON_ONCE(!object_ptr))
+			return -ENOENT;
+		object_data = (uintptr_t)object_ptr;
+		root = &ruleset->root_inode;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	walker_node = &root->rb_node;
 	while (*walker_node) {
 		struct landlock_rule *const this =
 			rb_entry(*walker_node, struct landlock_rule, node);

-		if (this->object != object) {
+		if (this->object.data != object_data) {
 			parent_node = *walker_node;
-			if (this->object < object)
+			if (this->object.data < object_data)
 				walker_node = &((*walker_node)->rb_right);
 			else
 				walker_node = &((*walker_node)->rb_left);
@@ -195,11 +222,16 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		 * Intersects access rights when it is a merge between a
 		 * ruleset and a domain.
 		 */
-		new_rule = create_rule(object, &this->layers, this->num_layers,
-				       &(*layers)[0]);
+		switch (rule_type) {
+		case LANDLOCK_RULE_PATH_BENEATH:
+			new_rule = create_rule(object_ptr, 0, &this->layers,
+					       this->num_layers,
+					       &(*layers)[0]);
+			break;
+		}
 		if (IS_ERR(new_rule))
 			return PTR_ERR(new_rule);
-		rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
+		rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
 		free_rule(this);
 		return 0;
 	}
@@ -208,11 +240,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 	build_check_ruleset();
 	if (ruleset->num_rules >= LANDLOCK_MAX_NUM_RULES)
 		return -E2BIG;
-	new_rule = create_rule(object, layers, num_layers, NULL);
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL);
+		break;
+	}
 	if (IS_ERR(new_rule))
 		return PTR_ERR(new_rule);
 	rb_link_node(&new_rule->node, parent_node, walker_node);
-	rb_insert_color(&new_rule->node, &ruleset->root);
+	rb_insert_color(&new_rule->node, &ruleset->root_inode);
 	ruleset->num_rules++;
 	return 0;
 }
@@ -230,8 +266,10 @@ static void build_check_layer(void)

 /* @ruleset must be locked by the caller. */
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
-			 const access_mask_t access)
+			 struct landlock_object *const object_ptr,
+			 const uintptr_t object_data,
+			 const access_mask_t access,
+			 const u16 rule_type)
 {
 	struct landlock_layer layers[] = { {
 		.access = access,
@@ -240,7 +278,8 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 	} };

 	build_check_layer();
-	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
+	return insert_rule(ruleset, object_ptr, object_data, rule_type, &layers,
+			   ARRAY_SIZE(layers));
 }

 static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
@@ -285,9 +324,9 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
-					     node) {
-		struct landlock_layer layers[] = { {
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+			&src->root_inode, node) {
+		struct landlock_layer layers[] = {{
 			.level = dst->num_layers,
 		} };

@@ -300,7 +339,9 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 			goto out_unlock;
 		}
 		layers[0].access = walker_rule->layers[0].access;
-		err = insert_rule(dst, walker_rule->object, &layers,
+
+		err = insert_rule(dst, walker_rule->object.ptr, 0,
+				  LANDLOCK_RULE_PATH_BENEATH, &layers,
 				  ARRAY_SIZE(layers));
 		if (err)
 			goto out_unlock;
@@ -328,10 +369,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,

 	/* Copies the @parent tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-					     &parent->root, node) {
-		err = insert_rule(child, walker_rule->object,
-				  &walker_rule->layers,
-				  walker_rule->num_layers);
+			&parent->root_inode, node) {
+		err = insert_rule(child, walker_rule->object.ptr, 0,
+				LANDLOCK_RULE_PATH_BENEATH, &walker_rule->layers,
+				walker_rule->num_layers);
 		if (err)
 			goto out_unlock;
 	}
@@ -362,7 +403,8 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	struct landlock_rule *freeme, *next;

 	might_sleep();
-	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root, node)
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
+			node)
 		free_rule(freeme);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
@@ -452,22 +494,31 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,
 /*
  * The returned access has the same lifetime as @ruleset.
  */
-const struct landlock_rule *
-landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object)
+const struct landlock_rule *landlock_find_rule(
+		const struct landlock_ruleset *const ruleset,
+		const uintptr_t object_data, const u16 rule_type)
 {
 	const struct rb_node *node;

-	if (!object)
+	if (!object_data)
 		return NULL;
-	node = ruleset->root.rb_node;
+
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		node = ruleset->root_inode.rb_node;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
 	while (node) {
 		struct landlock_rule *this =
 			rb_entry(node, struct landlock_rule, node);

-		if (this->object == object)
+		if (this->object.data == object_data)
 			return this;
-		if (this->object < object)
+		if (this->object.data < object_data)
 			node = node->rb_right;
 		else
 			node = node->rb_left;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index f27a79624962..3066e5d7180c 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -54,15 +54,17 @@ struct landlock_rule {
 	 */
 	struct rb_node node;
 	/**
-	 * @object: Pointer to identify a kernel object (e.g. an inode).  This
-	 * is used as a key for this ruleset element.  This pointer is set once
-	 * and never modified.  It always points to an allocated object because
-	 * each rule increments the refcount of its object.
-	 */
-	struct landlock_object *object;
-	/**
-	 * @num_layers: Number of entries in @layers.
+	 * @object: A union to identify either a kernel object (e.g. an inode) or
+	 * a raw data value (e.g. a network socket port). This is used as a key
+	 * for this ruleset element. This pointer/@object.ptr/ is set once and
+	 * never modified. It always points to an allocated object because each
+	 * rule increments the refcount of its object (for inodes);
 	 */
+	 union {
+		struct landlock_object *ptr;
+		uintptr_t data;
+	 } object;
+
 	u32 num_layers;
 	/**
 	 * @layers: Stack of layers, from the latest to the newest, implemented
@@ -99,7 +101,7 @@ struct landlock_ruleset {
 	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
 	 * tree is immutable until @usage reaches zero.
 	 */
-	struct rb_root root;
+	struct rb_root root_inode;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -161,16 +163,18 @@ void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);

 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
-			 const access_mask_t access);
+			 struct landlock_object *const object_ptr,
+			 const uintptr_t object_data,
+			 const access_mask_t access,
+			 const u16 rule_type);

 struct landlock_ruleset *
 landlock_merge_ruleset(struct landlock_ruleset *const parent,
 		       struct landlock_ruleset *const ruleset);

-const struct landlock_rule *
-landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object);
+const struct landlock_rule *landlock_find_rule(
+		const struct landlock_ruleset *const ruleset,
+		const uintptr_t object_data, const u16 rule_type);

 static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 {
--
2.25.1

