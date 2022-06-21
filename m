Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00363552CE0
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348272AbiFUIYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348130AbiFUIYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:24:09 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADE2140F5;
        Tue, 21 Jun 2022 01:23:38 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzxx33C1z6897v;
        Tue, 21 Jun 2022 16:21:41 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:35 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:28 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 08/17] landlock: adds support network rules
Date:   Tue, 21 Jun 2022 16:23:04 +0800
Message-ID: <20220621082313.3330667-9-konstantin.meskhidze@huawei.com>
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

This commit adds network rules support
in internal landlock functions
(presented in ruleset.c) and
landlock_create_ruleset syscall.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v5:
* Gets rid of partial revert from landlock_add_rule
syscall.
* Formats code with clang-format-14.

Changes since v4:
* Refactors landlock_create_ruleset() - splits ruleset and
masks checks.
* Refactors landlock_create_ruleset() and landlock mask
setters/getters to support two rule types.
* Refactors landlock_add_rule syscall add_rule_path_beneath
function by factoring out get_ruleset_from_fd() and
landlock_put_ruleset().

Changes since v3:
* Splits commit.
* Adds network rule support for internal landlock functions.
* Adds set_mask and get_mask for network.
* Adds rb_root root_net_port.

---
 security/landlock/limits.h   |  8 +++-
 security/landlock/ruleset.c  | 78 +++++++++++++++++++++++++++++++-----
 security/landlock/ruleset.h  | 31 ++++++++++++--
 security/landlock/syscalls.c |  8 +++-
 4 files changed, 111 insertions(+), 14 deletions(-)

diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index b54184ab9439..23694bf05cb7 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -22,6 +22,12 @@
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
 #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)

-/* clang-format on */
+#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
+#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
+#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
+#define LANDLOCK_MASK_SHIFT_NET		16
+
+#define LANDLOCK_RULE_TYPE_NUM		LANDLOCK_RULE_NET_SERVICE

+/* clang-format on */
 #endif /* _SECURITY_LANDLOCK_LIMITS_H */
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index cbca85f5cc6d..6ca6373b3950 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -36,6 +36,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	refcount_set(&new_ruleset->usage, 1);
 	mutex_init(&new_ruleset->lock);
 	new_ruleset->root_inode = RB_ROOT;
+	new_ruleset->root_net_port = RB_ROOT;
 	new_ruleset->num_layers = num_layers;
 	/*
 	 * hierarchy = NULL
@@ -46,16 +47,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 }

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t access_mask)
+landlock_create_ruleset(const access_mask_t access_mask_fs,
+			const access_mask_t access_mask_net)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!access_mask)
+	if (!access_mask_fs && !access_mask_net)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
-	if (!IS_ERR(new_ruleset))
-		landlock_set_fs_access_mask(new_ruleset, access_mask, 0);
+	if (IS_ERR(new_ruleset))
+		return new_ruleset;
+	if (access_mask_fs)
+		landlock_set_fs_access_mask(new_ruleset, access_mask_fs, 0);
+	if (access_mask_net)
+		landlock_set_net_access_mask(new_ruleset, access_mask_net, 0);
 	return new_ruleset;
 }

@@ -92,9 +98,11 @@ create_rule(struct landlock_object *const object_ptr,
 		return ERR_PTR(-ENOMEM);
 	RB_CLEAR_NODE(&new_rule->node);

-	if (object_ptr) {
+	if (object_ptr && !object_data) {
 		landlock_get_object(object_ptr);
 		new_rule->object.ptr = object_ptr;
+	} else if (object_data && !object_ptr) {
+		new_rule->object.data = object_data;
 	} else if (object_ptr && object_data) {
 		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
@@ -130,10 +138,12 @@ static void build_check_ruleset(void)
 		.num_layers = ~0,
 	};
 	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) net_access_mask = ~0;

 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
+	BUILD_BUG_ON(net_access_mask < LANDLOCK_MASK_ACCESS_NET);
 }

 /**
@@ -179,6 +189,11 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		object_data = (uintptr_t)object_ptr;
 		root = &ruleset->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		if (WARN_ON_ONCE(object_ptr))
+			return -EINVAL;
+		root = &ruleset->root_net_port;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return -EINVAL;
@@ -232,6 +247,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 					&ruleset->root_inode);
 			free_rule(this, rule_type);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			new_rule = create_rule(NULL, object_data, &this->layers,
+					       this->num_layers, &(*layers)[0]);
+			if (IS_ERR(new_rule))
+				return PTR_ERR(new_rule);
+			rb_replace_node(&this->node, &new_rule->node,
+					&ruleset->root_net_port);
+			free_rule(this, rule_type);
+			break;
 		}
 		return 0;
 	}
@@ -249,6 +273,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		rb_insert_color(&new_rule->node, &ruleset->root_inode);
 		ruleset->num_rules++;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		new_rule = create_rule(NULL, object_data, layers, num_layers,
+				       NULL);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_link_node(&new_rule->node, parent_node, walker_node);
+		rb_insert_color(&new_rule->node, &ruleset->root_net_port);
+		ruleset->num_rules++;
+		break;
 	}
 	return 0;
 }
@@ -309,6 +342,9 @@ static int tree_merge(struct landlock_ruleset *const src,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		src_root = &src->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		src_root = &src->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -335,6 +371,11 @@ static int tree_merge(struct landlock_ruleset *const src,
 					  rule_type, &layers,
 					  ARRAY_SIZE(layers));
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			err = insert_rule(dst, NULL, walker_rule->object.data,
+					  rule_type, &layers,
+					  ARRAY_SIZE(layers));
+			break;
 		}
 		if (err)
 			return err;
@@ -370,6 +411,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
 	if (err)
 		goto out_unlock;
+	/* Merges the @src network tree. */
+	err = tree_merge(src, dst, LANDLOCK_RULE_NET_SERVICE);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -389,10 +434,13 @@ static int tree_copy(struct landlock_ruleset *const parent,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		parent_root = &parent->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		parent_root = &parent->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
-	/* Copies the @parent inode tree. */
+	/* Copies the @parent inode or network tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
 					     parent_root, node) {
 		switch (rule_type) {
@@ -401,6 +449,11 @@ static int tree_copy(struct landlock_ruleset *const parent,
 					  rule_type, &walker_rule->layers,
 					  walker_rule->num_layers);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			err = insert_rule(child, NULL, walker_rule->object.data,
+					  rule_type, &walker_rule->layers,
+					  walker_rule->num_layers);
+			break;
 		}
 		if (err)
 			return err;
@@ -423,6 +476,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,

 	/* Copies the @parent inode tree. */
 	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;
+	/* Copies the @parent network tree. */
+	err = tree_copy(parent, child, LANDLOCK_RULE_NET_SERVICE);
 	if (err)
 		goto out_unlock;

@@ -458,6 +515,9 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
 					     node)
 		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
+	rbtree_postorder_for_each_entry_safe(freeme, next,
+					     &ruleset->root_net_port, node)
+		free_rule(freeme, LANDLOCK_RULE_NET_SERVICE);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -552,13 +612,13 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
 {
 	const struct rb_node *node;

-	if (!object_data)
-		return NULL;
-
 	switch (rule_type) {
 	case LANDLOCK_RULE_PATH_BENEATH:
 		node = ruleset->root_inode.rb_node;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		node = ruleset->root_net_port.rb_node;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index c1cf7cce2cb5..0cedfe65e326 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -101,6 +101,12 @@ struct landlock_ruleset {
 	 * tree is immutable until @usage reaches zero.
 	 */
 	struct rb_root root_inode;
+	/**
+	 * @root_net_port: Root of a red-black tree containing object nodes
+	 * for network port. Once a ruleset is tied to a process (i.e. as a domain),
+	 * this tree is immutable until @usage reaches zero.
+	 */
+	struct rb_root root_net_port;
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -156,7 +162,8 @@ struct landlock_ruleset {
 };

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t access_mask);
+landlock_create_ruleset(const access_mask_t access_mask_fs,
+			const access_mask_t access_mask_net);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -183,9 +190,9 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 /* A helper function to set a filesystem mask. */
 static inline void
 landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
-			    const access_mask_t access_maskset, u16 mask_level)
+			    const access_mask_t access_mask_fs, u16 mask_level)
 {
-	ruleset->access_masks[mask_level] = access_maskset;
+	ruleset->access_masks[mask_level] = access_mask_fs;
 }

 /* A helper function to get a filesystem mask. */
@@ -196,6 +203,24 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
 	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
 }

+/* A helper function to set a network mask. */
+static inline void
+landlock_set_net_access_mask(struct landlock_ruleset *ruleset,
+			     const access_mask_t access_mask_net,
+			     u16 mask_level)
+{
+	ruleset->access_masks[mask_level] |=
+		(access_mask_net << LANDLOCK_MASK_SHIFT_NET);
+}
+
+/* A helper function to get a network mask. */
+static inline u32
+landlock_get_net_access_mask(const struct landlock_ruleset *ruleset,
+			     u16 mask_level)
+{
+	return (ruleset->access_masks[mask_level] >> LANDLOCK_MASK_SHIFT_NET);
+}
+
 access_mask_t get_handled_accesses(const struct landlock_ruleset *const domain,
 				   u16 rule_type, u16 num_access);

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 246bc48deba3..72fa01ba9de7 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -189,8 +189,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	    LANDLOCK_MASK_ACCESS_FS)
 		return -EINVAL;

+	/* Checks network content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
+	    LANDLOCK_MASK_ACCESS_NET)
+		return -EINVAL;
+
 	/* Checks arguments and transforms to kernel struct. */
-	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
+	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
+					  ruleset_attr.handled_access_net);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);

--
2.25.1

