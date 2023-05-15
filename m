Return-Path: <netdev+bounces-2702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D24E703296
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED9E281115
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3E7FBFD;
	Mon, 15 May 2023 16:14:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B29FBF1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:14:16 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1223C2685;
	Mon, 15 May 2023 09:14:14 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QKktg25Hgz67nTp;
	Tue, 16 May 2023 00:13:15 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 17:14:11 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
Subject: [PATCH v11 04/12] landlock: Refactor merge/inherit_ruleset functions
Date: Tue, 16 May 2023 00:13:31 +0800
Message-ID: <20230515161339.631577-5-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Refactor merge_ruleset() and inherit_ruleset() functions to support
new rule types. This patch adds merge_tree() and inherit_tree()
helpers. They use a specific ruleset's red-black tree according to
a key type argument.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v10:
* Refactors merge_tree() function.

Changes since v9:
* None

Changes since v8:
* Refactors commit message.
* Minor fixes.

Changes since v7:
* Adds missed lockdep_assert_held it inherit_tree() and merge_tree().
* Fixes comment.

Changes since v6:
* Refactors merge_ruleset() and inherit_ruleset() functions to support
  new rule types.
* Renames tree_merge() to merge_tree() (and reorder arguments), and
  tree_copy() to inherit_tree().

Changes since v5:
* Refactors some logic errors.
* Formats code with clang-format-14.

Changes since v4:
* None

---
 security/landlock/ruleset.c | 122 +++++++++++++++++++++++-------------
 1 file changed, 79 insertions(+), 43 deletions(-)

diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index deab37838f5b..e4f449fdd6dd 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -302,36 +302,22 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
 	}
 }

-static int merge_ruleset(struct landlock_ruleset *const dst,
-			 struct landlock_ruleset *const src)
+static int merge_tree(struct landlock_ruleset *const dst,
+		      struct landlock_ruleset *const src,
+		      const enum landlock_key_type key_type)
 {
 	struct landlock_rule *walker_rule, *next_rule;
 	struct rb_root *src_root;
 	int err = 0;

 	might_sleep();
-	/* Should already be checked by landlock_merge_ruleset() */
-	if (WARN_ON_ONCE(!src))
-		return 0;
-	/* Only merge into a domain. */
-	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
-		return -EINVAL;
+	lockdep_assert_held(&dst->lock);
+	lockdep_assert_held(&src->lock);

-	src_root = get_root(src, LANDLOCK_KEY_INODE);
+	src_root = get_root(src, key_type);
 	if (IS_ERR(src_root))
 		return PTR_ERR(src_root);

-	/* Locks @dst first because we are its only owner. */
-	mutex_lock(&dst->lock);
-	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
-
-	/* Stacks the new layer. */
-	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
-
 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
 					     node) {
@@ -340,23 +326,52 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		} };
 		const struct landlock_id id = {
 			.key = walker_rule->key,
-			.type = LANDLOCK_KEY_INODE,
+			.type = key_type,
 		};

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
+
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
+			return -EINVAL;
+
 		layers[0].access = walker_rule->layers[0].access;

 		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
 		if (err)
-			goto out_unlock;
+			return err;
+	}
+	return err;
+}
+
+static int merge_ruleset(struct landlock_ruleset *const dst,
+			 struct landlock_ruleset *const src)
+{
+	int err = 0;
+
+	might_sleep();
+	/* Should already be checked by landlock_merge_ruleset() */
+	if (WARN_ON_ONCE(!src))
+		return 0;
+	/* Only merge into a domain. */
+	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
+		return -EINVAL;
+
+	/* Locks @dst first because we are its only owner. */
+	mutex_lock(&dst->lock);
+	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
+
+	/* Stacks the new layer. */
+	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
+		err = -EINVAL;
+		goto out_unlock;
 	}
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
+
+	/* Merges the @src inode tree. */
+	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -364,43 +379,64 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	return err;
 }

-static int inherit_ruleset(struct landlock_ruleset *const parent,
-			   struct landlock_ruleset *const child)
+static int inherit_tree(struct landlock_ruleset *const parent,
+			struct landlock_ruleset *const child,
+			const enum landlock_key_type key_type)
 {
 	struct landlock_rule *walker_rule, *next_rule;
 	struct rb_root *parent_root;
 	int err = 0;

 	might_sleep();
-	if (!parent)
-		return 0;
+	lockdep_assert_held(&parent->lock);
+	lockdep_assert_held(&child->lock);

-	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
+	parent_root = get_root(parent, key_type);
 	if (IS_ERR(parent_root))
 		return PTR_ERR(parent_root);

-	/* Locks @child first because we are its only owner. */
-	mutex_lock(&child->lock);
-	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
-
-	/* Copies the @parent tree. */
+	/* Copies the @parent inode or network tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
 					     parent_root, node) {
 		const struct landlock_id id = {
 			.key = walker_rule->key,
-			.type = LANDLOCK_KEY_INODE,
+			.type = key_type,
 		};
+
 		err = insert_rule(child, id, &walker_rule->layers,
 				  walker_rule->num_layers);
 		if (err)
-			goto out_unlock;
+			return err;
 	}
+	return err;
+}
+
+static int inherit_ruleset(struct landlock_ruleset *const parent,
+			   struct landlock_ruleset *const child)
+{
+	int err = 0;
+
+	might_sleep();
+	if (!parent)
+		return 0;
+
+	/* Locks @child first because we are its only owner. */
+	mutex_lock(&child->lock);
+	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
+
+	/* Copies the @parent inode tree. */
+	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
+	if (err)
+		goto out_unlock;

 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	/* Copies the parent layer stack and leaves a space for the new layer. */
+	/*
+	 * Copies the parent layer stack and leaves a space
+	 * for the new layer.
+	 */
 	memcpy(child->access_masks, parent->access_masks,
 	       flex_array_size(parent, access_masks, parent->num_layers));

--
2.25.1


