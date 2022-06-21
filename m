Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91D8552CC7
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiFUIXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiFUIXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:23:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E76BE0E;
        Tue, 21 Jun 2022 01:23:23 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzzR0Pf9z6GCp4;
        Tue, 21 Jun 2022 16:22:59 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:21 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:20 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
Date:   Tue, 21 Jun 2022 16:22:58 +0800
Message-ID: <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new object union to support a socket port
rule type. Refactors landlock_insert_rule() and
landlock_find_rule() to support coming network
modifications. Now adding or searching a rule
in a ruleset depends on a rule_type argument
provided in refactored functions mentioned above.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/fs.c      |   7 ++-
 security/landlock/ruleset.c | 105 ++++++++++++++++++++++++++----------
 security/landlock/ruleset.h |  27 +++++-----
 3 files changed, 96 insertions(+), 43 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index e6da08ed99d1..46aedc2a05a8 100644
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
@@ -204,7 +205,9 @@ find_rule(const struct landlock_ruleset *const domain,
 	inode = d_backing_inode(dentry);
 	rcu_read_lock();
 	rule = landlock_find_rule(
-		domain, rcu_dereference(landlock_inode(inode)->object));
+		domain,
+		(uintptr_t)rcu_dereference(landlock_inode(inode)->object),
+		LANDLOCK_RULE_PATH_BENEATH);
 	rcu_read_unlock();
 	return rule;
 }
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index a3fd58d01f09..5f13f8a12aee 100644
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
@@ -69,7 +69,8 @@ static void build_check_rule(void)
 }

 static struct landlock_rule *
-create_rule(struct landlock_object *const object,
+create_rule(struct landlock_object *const object_ptr,
+	    const uintptr_t object_data,
 	    const struct landlock_layer (*const layers)[], const u32 num_layers,
 	    const struct landlock_layer *const new_layer)
 {
@@ -90,8 +91,15 @@ create_rule(struct landlock_object *const object,
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
@@ -107,7 +115,7 @@ static void free_rule(struct landlock_rule *const rule)
 	might_sleep();
 	if (!rule)
 		return;
-	landlock_put_object(rule->object);
+	landlock_put_object(rule->object.ptr);
 	kfree(rule);
 }

@@ -143,26 +151,42 @@ static void build_check_ruleset(void)
  * access rights.
  */
 static int insert_rule(struct landlock_ruleset *const ruleset,
-		       struct landlock_object *const object,
+		       struct landlock_object *const object_ptr,
+		       uintptr_t object_data, u16 rule_type,
 		       const struct landlock_layer (*const layers)[],
 		       size_t num_layers)
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
+	if (WARN_ON_ONCE(object_ptr && object_data))
+		return -EINVAL;
+	/* Chooses rb_tree structure depending on a rule type. */
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
@@ -194,11 +218,16 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		 * Intersects access rights when it is a merge between a
 		 * ruleset and a domain.
 		 */
-		new_rule = create_rule(object, &this->layers, this->num_layers,
-				       &(*layers)[0]);
+		switch (rule_type) {
+		case LANDLOCK_RULE_PATH_BENEATH:
+			new_rule = create_rule(object_ptr, 0, &this->layers,
+					       this->num_layers, &(*layers)[0]);
+			break;
+		}
 		if (IS_ERR(new_rule))
 			return PTR_ERR(new_rule);
-		rb_replace_node(&this->node, &new_rule->node, &ruleset->root);
+		rb_replace_node(&this->node, &new_rule->node,
+				&ruleset->root_inode);
 		free_rule(this);
 		return 0;
 	}
@@ -207,11 +236,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
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
@@ -229,8 +262,9 @@ static void build_check_layer(void)

 /* @ruleset must be locked by the caller. */
 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
-			 const access_mask_t access)
+			 struct landlock_object *const object_ptr,
+			 const uintptr_t object_data,
+			 const access_mask_t access, const u16 rule_type)
 {
 	struct landlock_layer layers[] = { {
 		.access = access,
@@ -239,7 +273,8 @@ int landlock_insert_rule(struct landlock_ruleset *const ruleset,
 	} };

 	build_check_layer();
-	return insert_rule(ruleset, object, &layers, ARRAY_SIZE(layers));
+	return insert_rule(ruleset, object_ptr, object_data, rule_type, &layers,
+			   ARRAY_SIZE(layers));
 }

 static inline void get_hierarchy(struct landlock_hierarchy *const hierarchy)
@@ -284,8 +319,8 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
-					     node) {
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+					     &src->root_inode, node) {
 		struct landlock_layer layers[] = { {
 			.level = dst->num_layers,
 		} };
@@ -299,7 +334,8 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 			goto out_unlock;
 		}
 		layers[0].access = walker_rule->layers[0].access;
-		err = insert_rule(dst, walker_rule->object, &layers,
+		err = insert_rule(dst, walker_rule->object.ptr, 0,
+				  LANDLOCK_RULE_PATH_BENEATH, &layers,
 				  ARRAY_SIZE(layers));
 		if (err)
 			goto out_unlock;
@@ -327,8 +363,9 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,

 	/* Copies the @parent tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-					     &parent->root, node) {
-		err = insert_rule(child, walker_rule->object,
+					     &parent->root_inode, node) {
+		err = insert_rule(child, walker_rule->object.ptr, 0,
+				  LANDLOCK_RULE_PATH_BENEATH,
 				  &walker_rule->layers,
 				  walker_rule->num_layers);
 		if (err)
@@ -361,7 +398,8 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	struct landlock_rule *freeme, *next;

 	might_sleep();
-	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root, node)
+	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
+					     node)
 		free_rule(freeme);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
@@ -453,20 +491,29 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,
  */
 const struct landlock_rule *
 landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object)
+		   const uintptr_t object_data, const u16 rule_type)
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
index bd7ab39859bf..a22d132c32a7 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -53,15 +53,17 @@ struct landlock_rule {
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
+	 * rule increments the refcount of its object (for inodes).;
 	 */
+	union {
+		struct landlock_object *ptr;
+		uintptr_t data;
+	} object;
+
 	u32 num_layers;
 	/**
 	 * @layers: Stack of layers, from the latest to the newest, implemented
@@ -98,7 +100,7 @@ struct landlock_ruleset {
 	 * nodes.  Once a ruleset is tied to a process (i.e. as a domain), this
 	 * tree is immutable until @usage reaches zero.
 	 */
-	struct rb_root root;
+	struct rb_root root_inode;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -160,8 +162,9 @@ void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);

 int landlock_insert_rule(struct landlock_ruleset *const ruleset,
-			 struct landlock_object *const object,
-			 const access_mask_t access);
+			 struct landlock_object *const object_ptr,
+			 const uintptr_t object_data,
+			 const access_mask_t access, const u16 rule_type);

 struct landlock_ruleset *
 landlock_merge_ruleset(struct landlock_ruleset *const parent,
@@ -169,7 +172,7 @@ landlock_merge_ruleset(struct landlock_ruleset *const parent,

 const struct landlock_rule *
 landlock_find_rule(const struct landlock_ruleset *const ruleset,
-		   const struct landlock_object *const object);
+		   const uintptr_t object_data, const u16 rule_type);

 static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 {
--
2.25.1

