Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD64D3046
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiCINqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiCINqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C61417B8A8;
        Wed,  9 Mar 2022 05:45:16 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD2k2p0gz67bVT;
        Wed,  9 Mar 2022 21:44:46 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:13 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 04/15] landlock: merge and inherit function refactoring
Date:   Wed, 9 Mar 2022 21:44:48 +0800
Message-ID: <20220309134459.6448-5-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge_ruleset() and inherit_ruleset() functions were
refactored to support new rule types. This patch adds
tree_merge() and tree_copy() helpers. Each has
rule_type argument to choose a particular rb_tree
structure in a ruleset.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Refactoring functions:
	-insert_rule.
	-merge_ruleset.
	-tree_merge.
	-inherit_ruleset.
	-tree_copy.
	-free_rule.

---
 security/landlock/ruleset.c | 141 +++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 44 deletions(-)

diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 971685c48641..f2baa1c96b16 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -125,12 +125,16 @@ static struct landlock_rule *create_rule(
 	return new_rule;
 }

-static void free_rule(struct landlock_rule *const rule)
+static void free_rule(struct landlock_rule *const rule, const u16 rule_type)
 {
 	might_sleep();
 	if (!rule)
 		return;
-	landlock_put_object(rule->object.ptr);
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		landlock_put_object(rule->object.ptr);
+		break;
+	}
 	kfree(rule);
 }

@@ -233,12 +237,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		case LANDLOCK_RULE_PATH_BENEATH:
 			new_rule = create_rule(object_ptr, 0, &this->layers, this->num_layers,
 					       &(*layers)[0], rule_type);
+			if (IS_ERR(new_rule))
+				return PTR_ERR(new_rule);
+			rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
+			free_rule(this, rule_type);
 			break;
 		}
-		if (IS_ERR(new_rule))
-			return PTR_ERR(new_rule);
-		rb_replace_node(&this->node, &new_rule->node, &ruleset->root_inode);
-		free_rule(this);
 		return 0;
 	}

@@ -249,13 +253,13 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 	switch (rule_type) {
 	case LANDLOCK_RULE_PATH_BENEATH:
 		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL, rule_type);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_link_node(&new_rule->node, parent_node, walker_node);
+		rb_insert_color(&new_rule->node, &ruleset->root_inode);
+		ruleset->num_rules++;
 		break;
 	}
-	if (IS_ERR(new_rule))
-		return PTR_ERR(new_rule);
-	rb_link_node(&new_rule->node, parent_node, walker_node);
-	rb_insert_color(&new_rule->node, &ruleset->root_inode);
-	ruleset->num_rules++;
 	return 0;
 }

@@ -303,10 +307,53 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
 	}
 }

+static int tree_merge(struct landlock_ruleset *const src,
+		struct landlock_ruleset *const dst, u16 rule_type)
+{
+	struct landlock_rule *walker_rule, *next_rule;
+	struct rb_root *src_root;
+	int err = 0;
+
+	/* Choose rb_tree structure depending on a rule type */
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		src_root = &src->root_inode;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* Merges the @src tree. */
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+					     src_root, node) {
+		struct landlock_layer layers[] = {{
+			.level = dst->num_layers,
+		}};
+
+		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
+			err = -EINVAL;
+			return err;
+		}
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
+			err = -EINVAL;
+			return err;
+		}
+		layers[0].access = walker_rule->layers[0].access;
+
+		switch (rule_type) {
+		case LANDLOCK_RULE_PATH_BENEATH:
+			err = insert_rule(dst, walker_rule->object.ptr, 0, &layers,
+				ARRAY_SIZE(layers), rule_type);
+			break;
+		}
+		if (err)
+			return err;
+	}
+	return err;
+}
+
 static int merge_ruleset(struct landlock_ruleset *const dst,
 		struct landlock_ruleset *const src)
 {
-	struct landlock_rule *walker_rule, *next_rule;
 	int err = 0;

 	might_sleep();
@@ -328,27 +375,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	}
 	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

-	/* Merges the @src tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&src->root_inode, node) {
-		struct landlock_layer layers[] = {{
-			.level = dst->num_layers,
-		}};
-
-		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
-		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
-		layers[0].access = walker_rule->layers[0].access;
-		err = insert_rule(dst, walker_rule->object.ptr, 0, &layers,
-				ARRAY_SIZE(layers), LANDLOCK_RULE_PATH_BENEATH);
-		if (err)
-			goto out_unlock;
-	}
+	/* Merges the @src inode tree. */
+	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -356,12 +386,40 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	return err;
 }

+static int tree_copy(struct landlock_ruleset *const parent,
+		struct landlock_ruleset *const child, u16 rule_type)
+{
+	struct landlock_rule *walker_rule, *next_rule;
+	struct rb_root *parent_root;
+	int err = 0;

+	/* Choose rb_tree structure depending on a rule type */
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		parent_root = &parent->root_inode;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* Copies the @parent inode tree. */
+	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
+					     parent_root, node) {
+		switch (rule_type) {
+		case LANDLOCK_RULE_PATH_BENEATH:
+			err = insert_rule(child, walker_rule->object.ptr, 0,
+				  &walker_rule->layers, walker_rule->num_layers,
+				  rule_type);
+			break;
+		}
+		if (err)
+			return err;
+	}
+	return err;
+}

 static int inherit_ruleset(struct landlock_ruleset *const parent,
 		struct landlock_ruleset *const child)
 {
-	struct landlock_rule *walker_rule, *next_rule;
 	int err = 0;

 	might_sleep();
@@ -372,15 +430,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 	mutex_lock(&child->lock);
 	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);

-	/* Copies the @parent tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&parent->root_inode, node) {
-		err = insert_rule(child, walker_rule->object.ptr, 0,
-				&walker_rule->layers, walker_rule->num_layers,
-				LANDLOCK_RULE_PATH_BENEATH);
-		if (err)
-			goto out_unlock;
-	}
+	/* Copies the @parent inode tree. */
+	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;

 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
@@ -410,7 +463,7 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	might_sleep();
 	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
 			node)
-		free_rule(freeme);
+		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
--
2.25.1

