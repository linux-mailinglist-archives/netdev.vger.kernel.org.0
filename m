Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D756607A7B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiJUP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiJUP1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:27:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E3D254764;
        Fri, 21 Oct 2022 08:26:58 -0700 (PDT)
Received: from frapeml100008.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7Zy08TPz689lY;
        Fri, 21 Oct 2022 23:25:46 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:26:56 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:26:55 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 02/12] landlock: Refactor landlock_find_rule/insert_rule
Date:   Fri, 21 Oct 2022 23:26:34 +0800
Message-ID: <20221021152644.155136-3-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new landlock_key union and landlock_id structure to support
a socket port rule type. A struct landlock_id identifies a unique entry
in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
port). There is one red-black tree per key type.

This patch also adds is_object_pointer() and get_root() helpers.
is_object_pointer() one checks whether key type is LANDLOCK_KEY_INODE.
get_root() helper chooses red_black tree root depending on a key type.

Refactors landlock_insert_rule() and landlock_find_rule() to support coming
network modifications. Now adding or searching a rule in a ruleset depends
on a landlock id argument provided in refactored functions.

Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v7:
* Completes all the new field descriptions landlock_key,
  landlock_key_type, landlock_id.
* Refactors commit message, adds a co-developer.

Changes since v6:
* Adds union landlock_key, enum landlock_key_type, and struct
  landlock_id.
* Refactors ruleset functions and improves switch/cases: create_rule(),
  insert_rule(), get_root(), is_object_pointer(), free_rule(),
  landlock_find_rule().
* Refactors landlock_append_fs_rule() functions to support new
  landlock_id type.

Changes since v5:
* Formats code with clang-format-14.

Changes since v4:
* Refactors insert_rule() and create_rule() functions by deleting
rule_type from their arguments list, it helps to reduce useless code.

Changes since v3:
* Splits commit.
* Refactors landlock_insert_rule and landlock_find_rule functions.
* Rename new_ruleset->root_inode.

---
 security/landlock/fs.c      |  21 ++++--
 security/landlock/ruleset.c | 146 +++++++++++++++++++++++++-----------
 security/landlock/ruleset.h |  64 +++++++++++++---
 3 files changed, 169 insertions(+), 62 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 0d57c6479d29..710cfa1306de 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -168,7 +168,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 			    access_mask_t access_rights)
 {
 	int err;
-	struct landlock_object *object;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_INODE,
+	};

 	/* Files only get access rights that make sense. */
 	if (!d_is_dir(path->dentry) &&
@@ -181,17 +183,17 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 	access_rights |= LANDLOCK_MASK_ACCESS_FS &
 			 ~(landlock_get_fs_access_mask(ruleset, 0) |
 			   ACCESS_INITIALLY_DENIED);
-	object = get_inode_object(d_backing_inode(path->dentry));
-	if (IS_ERR(object))
-		return PTR_ERR(object);
+	id.key.object = get_inode_object(d_backing_inode(path->dentry));
+	if (IS_ERR(id.key.object))
+		return PTR_ERR(id.key.object);
 	mutex_lock(&ruleset->lock);
-	err = landlock_insert_rule(ruleset, object, access_rights);
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

@@ -208,6 +210,9 @@ find_rule(const struct landlock_ruleset *const domain,
 {
 	const struct landlock_rule *rule;
 	const struct inode *inode;
+	struct landlock_id id = {
+		.type = LANDLOCK_KEY_INODE,
+	};

 	/* Ignores nonexistent leafs. */
 	if (d_is_negative(dentry))
@@ -215,8 +220,8 @@ find_rule(const struct landlock_ruleset *const domain,

 	inode = d_backing_inode(dentry);
 	rcu_read_lock();
-	rule = landlock_find_rule(
-		domain, rcu_dereference(landlock_inode(inode)->object));
+	id.key.object = rcu_dereference(landlock_inode(inode)->object);
+	rule = landlock_find_rule(domain, id);
 	rcu_read_unlock();
 	return rule;
 }
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 1f3188b4e313..41de17d1869e 100644
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
@@ -68,8 +68,18 @@ static void build_check_rule(void)
 	BUILD_BUG_ON(rule.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 }

+static inline bool is_object_pointer(const enum landlock_key_type key_type)
+{
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		return true;
+	}
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static struct landlock_rule *
-create_rule(struct landlock_object *const object,
+create_rule(const struct landlock_id id,
 	    const struct landlock_layer (*const layers)[], const u32 num_layers,
 	    const struct landlock_layer *const new_layer)
 {
@@ -90,8 +100,13 @@ create_rule(struct landlock_object *const object,
 	if (!new_rule)
 		return ERR_PTR(-ENOMEM);
 	RB_CLEAR_NODE(&new_rule->node);
-	landlock_get_object(object);
-	new_rule->object = object;
+	if (is_object_pointer(id.type)) {
+		/* This should be catched by insert_rule(). */
+		WARN_ON_ONCE(!id.key.object);
+		landlock_get_object(id.key.object);
+	}
+
+	new_rule->key = id.key;
 	new_rule->num_layers = new_num_layers;
 	/* Copies the original layer stack. */
 	memcpy(new_rule->layers, layers,
@@ -102,12 +117,29 @@ create_rule(struct landlock_object *const object,
 	return new_rule;
 }

-static void free_rule(struct landlock_rule *const rule)
+static inline struct rb_root *get_root(struct landlock_ruleset *const ruleset,
+				       const enum landlock_key_type key_type)
+{
+	struct rb_root *root = NULL;
+
+	switch (key_type) {
+	case LANDLOCK_KEY_INODE:
+		root = &ruleset->root_inode;
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
-	landlock_put_object(rule->object);
+	if (is_object_pointer(key_type))
+		landlock_put_object(rule->key.object);
 	kfree(rule);
 }

@@ -129,8 +161,8 @@ static void build_check_ruleset(void)
  * insert_rule - Create and insert a rule in a ruleset
  *
  * @ruleset: The ruleset to be updated.
- * @object: The object to build the new rule with.  The underlying kernel
- *          object must be held by the caller.
+ * @id: The ID to build the new rule with.  The underlying kernel object, if
+ *      any, must be held by the caller.
  * @layers: One or multiple layers to be copied into the new rule.
  * @num_layers: The number of @layers entries.
  *
@@ -144,26 +176,37 @@ static void build_check_ruleset(void)
  * access rights.
  */
 static int insert_rule(struct landlock_ruleset *const ruleset,
-		       struct landlock_object *const object,
+		       const struct landlock_id id,
 		       const struct landlock_layer (*const layers)[],
-		       size_t num_layers)
+		       const size_t num_layers)
 {
 	struct rb_node **walker_node;
 	struct rb_node *parent_node = NULL;
 	struct landlock_rule *new_rule;
+	struct rb_root *root;

 	might_sleep();
 	lockdep_assert_held(&ruleset->lock);
-	if (WARN_ON_ONCE(!object || !layers))
+	if (WARN_ON_ONCE(!layers))
 		return -ENOENT;
-	walker_node = &(ruleset->root.rb_node);
+
+	if (is_object_pointer(id.type)) {
+		if (WARN_ON_ONCE(!id.key.object))
+			return -ENOENT;
+	}
+
+	root = get_root(ruleset, id.type);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	walker_node = &root->rb_node;
 	while (*walker_node) {
 		struct landlock_rule *const this =
 			rb_entry(*walker_node, struct landlock_rule, node);

-		if (this->object != object) {
+		if (this->key.data != id.key.data) {
 			parent_node = *walker_node;
-			if (this->object < object)
+			if (this->key.data < id.key.data)
 				walker_node = &((*walker_node)->rb_right);
 			else
 				walker_node = &((*walker_node)->rb_left);
@@ -195,24 +238,24 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		 * Intersects access rights when it is a merge between a
 		 * ruleset and a domain.
 		 */
-		new_rule = create_rule(object, &this->layers, this->num_layers,
+		new_rule = create_rule(id, &this->layers, this->num_layers,
 				       &(*layers)[0]);
 		if (IS_ERR(new_rule))
 			return PTR_ERR(new_rule);
-		rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
-		free_rule(this);
+		rb_replace_node(&this->node, &new_rule->node, root);
+		free_rule(this, id.type);
 		return 0;
 	}

-	/* There is no match for @object. */
+	/* There is no match for @id. */
 	build_check_ruleset();
 	if (ruleset->num_rules >= LANDLOCK_MAX_NUM_RULES)
 		return -E2BIG;
-	new_rule = create_rule(object, layers, num_layers, NULL);
+	new_rule = create_rule(id, layers, num_layers, NULL);
 	if (IS_ERR(new_rule))
 		return PTR_ERR(new_rule);
 	rb_link_node(&new_rule->node, parent_node, walker_node);
-	rb_insert_color(&new_rule->node, &ruleset->root);
+	rb_insert_color(&new_rule->node, root);
 	ruleset->num_rules++;
 	return 0;
 }
@@ -230,7 +273,7 @@ static void build_check_layer(void)

 /* @ruleset must be locked by the caller. */
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
+			 const struct landlock_id id,
 			 const access_mask_t access)
 {
 	struct landlock_layer layers[] = { {
@@ -240,7 +283,7 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 	} };

 	build_check_layer();
-	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
+	return insert_rule(ruleset, id, &layers, ARRAY_SIZE(layers));
 }

 static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
@@ -263,6 +306,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 			 struct landlock_ruleset *const src)
 {
 	struct landlock_rule *walker_rule, *next_rule;
+	struct rb_root *src_root;
 	int err = 0;

 	might_sleep();
@@ -273,6 +317,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
 		return -EINVAL;

+	src_root = get_root(src, LANDLOCK_KEY_INODE);
+	if (IS_ERR(src_root))
+		return PTR_ERR(src_root);
+
 	/* Locks @dst first because we are its only owner. */
 	mutex_lock(&dst->lock);
 	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
@@ -285,23 +333,23 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
 					     node) {
 		struct landlock_layer layers[] = { {
 			.level = dst->num_layers,
 		} };
+		const struct landlock_id id = {
+			.key = walker_rule->key,
+			.type = LANDLOCK_KEY_INODE,
+		};

-		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
-		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
+		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
+			return -EINVAL;
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
+			return -EINVAL;
 		layers[0].access = walker_rule->layers[0].access;
-		err = insert_rule(dst, walker_rule->object, &layers,
-				  ARRAY_SIZE(layers));
+
+		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
 		if (err)
 			goto out_unlock;
 	}
@@ -316,21 +364,29 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 			   struct landlock_ruleset *const child)
 {
 	struct landlock_rule *walker_rule, *next_rule;
+	struct rb_root *parent_root;
 	int err = 0;

 	might_sleep();
 	if (!parent)
 		return 0;

+	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
+	if (IS_ERR(parent_root))
+		return PTR_ERR(parent_root);
+
 	/* Locks @child first because we are its only owner. */
 	mutex_lock(&child->lock);
 	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);

 	/* Copies the @parent tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-					     &parent->root, node) {
-		err = insert_rule(child, walker_rule->object,
-				  &walker_rule->layers,
+					     parent_root, node) {
+		const struct landlock_id id = {
+			.key = walker_rule->key,
+			.type = LANDLOCK_KEY_INODE,
+		};
+		err = insert_rule(child, id, &walker_rule->layers,
 				  walker_rule->num_layers);
 		if (err)
 			goto out_unlock;
@@ -362,8 +418,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	struct landlock_rule *freeme, *next;

 	might_sleep();
-	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root, node)
-		free_rule(freeme);
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
+					     node)
+		free_rule(freeme, LANDLOCK_KEY_INODE);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -454,20 +511,23 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,
  */
 const struct landlock_rule *
 landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object)
+		   const struct landlock_id id)
 {
+	const struct rb_root *root;
 	const struct rb_node *node;

-	if (!object)
+	root = get_root((struct landlock_ruleset *)ruleset, id.type);
+	if (IS_ERR(root))
 		return NULL;
-	node = ruleset->root.rb_node;
+	node = root->rb_node;
+
 	while (node) {
 		struct landlock_rule *this =
 			rb_entry(node, struct landlock_rule, node);

-		if (this->object == object)
+		if (this->key.data == id.key.data)
 			return this;
-		if (this->object < object)
+		if (this->key.data < id.key.data)
 			node = node->rb_right;
 		else
 			node = node->rb_left;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index f2ad932d396c..608ab356bc3e 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -49,6 +49,46 @@ struct landlock_layer {
 	access_mask_t access;
 };

+/**
+ * union landlock_key - Key of a ruleset's red-black tree
+ */
+union landlock_key {
+	/**
+	 * @object: Pointer to identify a kernel object (e.g. an inode).
+	 */
+	struct landlock_object *object;
+	/**
+	 * @data: A raw data value to identify a network socket port.
+	 */
+	uintptr_t data;
+};
+
+/**
+ * enum landlock_key_type - Type of &union landlock_key
+ */
+enum landlock_key_type {
+	/**
+	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
+	 * keys.
+	 */
+	LANDLOCK_KEY_INODE = 1,
+};
+
+/**
+ * struct landlock_id - Unique rule identifier for a ruleset
+ */
+struct landlock_id {
+	/**
+	 * @key: A union to identify either a kernel object (e.g. an inode) or
+	 * a raw data value (e.g. a network socket port).
+	 */
+	union landlock_key key;
+	/**
+	 * @type: A enumerator to identify the type of landlock_ruleset's root tree.
+	 */
+	const enum landlock_key_type type;
+};
+
 /**
  * struct landlock_rule - Access rights tied to an object
  */
@@ -58,12 +98,13 @@ struct landlock_rule {
 	 */
 	struct rb_node node;
 	/**
-	 * @object: Pointer to identify a kernel object (e.g. an inode).  This
-	 * is used as a key for this ruleset element.  This pointer is set once
-	 * and never modified.  It always points to an allocated object because
-	 * each rule increments the refcount of its object.
+	 * @key: A union to identify either a kernel object (e.g. an inode) or
+	 * a raw data value (e.g. a network socket port). This is used as a key
+	 * for this ruleset element.  The pointer is set once and never
+	 * modified.  It always points to an allocated object because each rule
+	 * increments the refcount of its object.
 	 */
-	struct landlock_object *object;
+	union landlock_key key;
 	/**
 	 * @num_layers: Number of entries in @layers.
 	 */
@@ -99,11 +140,12 @@ struct landlock_hierarchy {
  */
 struct landlock_ruleset {
 	/**
-	 * @root: Root of a red-black tree containing &struct landlock_rule
-	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
-	 * tree is immutable until @usage reaches zero.
+	 * @root_inode: Root of a red-black tree containing &struct
+	 * landlock_rule nodes with inode object.  Once a ruleset is tied to a
+	 * process (i.e. as a domain), this tree is immutable until @usage
+	 * reaches zero.
 	 */
-	struct rb_root root;
+	struct rb_root root_inode;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -165,7 +207,7 @@ void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);

 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
+			 const struct landlock_id id,
 			 const access_mask_t access);

 struct landlock_ruleset *
@@ -174,7 +216,7 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,

 const struct landlock_rule *
 landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object);
+		   const struct landlock_id id);

 static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 {
--
2.25.1

