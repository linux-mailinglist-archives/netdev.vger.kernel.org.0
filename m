Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CA52888B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiEPPV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245186AbiEPPUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:20:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF02393D1;
        Mon, 16 May 2022 08:20:53 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22y82WxJz67wkW;
        Mon, 16 May 2022 23:20:48 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:20:51 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 03/15] landlock: merge and inherit function refactoring
Date:   Mon, 16 May 2022 23:20:26 +0800
Message-ID: <20220516152038.39594-4-konstantin.meskhidze@huawei.com>
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

Changes since v4:
* None

---
 security/landlock/ruleset.c | 144 ++++++++++++++++++++++++------------
 1 file changed, 98 insertions(+), 46 deletions(-)

diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index f079a2a320f1..4b4c9953bb32 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -112,12 +112,16 @@ static struct landlock_rule *create_rule(
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

@@ -227,12 +231,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 			new_rule = create_rule(object_ptr, 0, &this->layers,
 					       this->num_layers,
 					       &(*layers)[0]);
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

@@ -243,13 +247,12 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 	switch (rule_type) {
 	case LANDLOCK_RULE_PATH_BENEATH:
 		new_rule = create_rule(object_ptr, 0, layers, num_layers, NULL);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_link_node(&new_rule->node, parent_node, walker_node);
+		rb_insert_color(&new_rule->node, &ruleset->root_inode);
 		break;
 	}
-	if (IS_ERR(new_rule))
-		return PTR_ERR(new_rule);
-	rb_link_node(&new_rule->node, parent_node, walker_node);
-	rb_insert_color(&new_rule->node, &ruleset->root_inode);
-	ruleset->num_rules++;
 	return 0;
 }

@@ -298,10 +301,53 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
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
+			err = insert_rule(dst, walker_rule->object.ptr, 0, rule_type,
+					  &layers, ARRAY_SIZE(layers));
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
@@ -323,29 +369,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	}
 	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

-	/* Merges the @src tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&src->root_inode, node) {
-		struct landlock_layer layers[] = {{
-			.level = dst->num_layers,
-		} };
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
-
-		err = insert_rule(dst, walker_rule->object.ptr, 0,
-				  LANDLOCK_RULE_PATH_BENEATH, &layers,
-				  ARRAY_SIZE(layers));
-		if (err)
-			goto out_unlock;
-	}
+	/* Merges the @src inode tree. */
+	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -353,10 +380,40 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	return err;
 }

+static int tree_copy(struct landlock_ruleset *const parent,
+		struct landlock_ruleset *const child, u16 rule_type)
+{
+	struct landlock_rule *walker_rule, *next_rule;
+	struct rb_root *parent_root;
+	int err = 0;
+
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
+					  rule_type, &walker_rule->layers,
+					  walker_rule->num_layers);
+			break;
+		}
+		if (err)
+			return err;
+	}
+	return err;
+}
+
 static int inherit_ruleset(struct landlock_ruleset *const parent,
 			   struct landlock_ruleset *const child)
 {
-	struct landlock_rule *walker_rule, *next_rule;
 	int err = 0;

 	might_sleep();
@@ -367,15 +424,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 	mutex_lock(&child->lock);
 	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);

-	/* Copies the @parent tree. */
-	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
-			&parent->root_inode, node) {
-		err = insert_rule(child, walker_rule->object.ptr, 0,
-				LANDLOCK_RULE_PATH_BENEATH, &walker_rule->layers,
-				walker_rule->num_layers);
-		if (err)
-			goto out_unlock;
-	}
+	/* Copies the @parent inode tree. */
+	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;

 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
@@ -405,7 +457,7 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
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

