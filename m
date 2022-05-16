Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D6F528888
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245268AbiEPPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiEPPVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:21:06 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4D3BF94;
        Mon, 16 May 2022 08:20:59 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22t44nJjz67Zm5;
        Mon, 16 May 2022 23:17:16 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:20:56 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 07/15] landlock: add support network rules
Date:   Mon, 16 May 2022 23:20:30 +0800
Message-ID: <20220516152038.39594-8-konstantin.meskhidze@huawei.com>
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

This modification adds network rules support
in internal landlock functions (presented in ruleset.c)
and landlock_create_ruleset syscall.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Add network rule support for internal landlock functions.
* Add set_mask and get_mask for network.
* Add rb_root root_net_port.

Changes since v4:
* Refactoring landlock_create_ruleset() - splits ruleset and
masks checks.
* Refactoring landlock_create_ruleset() and landlock mask
setters/getters to support two rule types.
* Refactoring landlock_add_rule syscall add_rule_path_beneath
function by factoring out get_ruleset_from_fd() and
landlock_put_ruleset().

---
 security/landlock/limits.h   |  8 +++-
 security/landlock/ruleset.c  | 82 +++++++++++++++++++++++++++++++-----
 security/landlock/ruleset.h  | 34 +++++++++++++--
 security/landlock/syscalls.c | 45 +++++++++++---------
 4 files changed, 132 insertions(+), 37 deletions(-)

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
index c4ed783d655b..ea9ecb3f471a 100644
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
@@ -46,17 +47,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 }

 struct landlock_ruleset *landlock_create_ruleset(
-		const access_mask_t access_mask)
+					const access_mask_t access_mask_fs,
+					const access_mask_t access_mask_net)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!access_mask)
+	if (!access_mask_fs && !access_mask_net)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
-	if (!IS_ERR(new_ruleset))
-		landlock_set_fs_access_mask(new_ruleset, access_mask, 0);
-
+	if (IS_ERR(new_ruleset))
+		return new_ruleset;
+	if (access_mask_fs)
+		landlock_set_fs_access_mask(new_ruleset, access_mask_fs, 0);
+	if (access_mask_net)
+		landlock_set_net_access_mask(new_ruleset, access_mask_net, 0);
 	return new_ruleset;
 }

@@ -94,9 +99,11 @@ static struct landlock_rule *create_rule(
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
@@ -132,10 +139,12 @@ static void build_check_ruleset(void)
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
@@ -183,6 +192,11 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
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
@@ -237,6 +251,16 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 					&ruleset->root_inode);
 			free_rule(this, rule_type);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			new_rule = create_rule(NULL, object_data,
+					       &this->layers, this->num_layers,
+					       &(*layers)[0]);
+			if (IS_ERR(new_rule))
+				return PTR_ERR(new_rule);
+			rb_replace_node(&this->node, &new_rule->node,
+					&ruleset->root_net_port);
+			free_rule(this, rule_type);
+			break;
 		}
 		return 0;
 	}
@@ -254,6 +278,15 @@ static int insert_rule(struct landlock_ruleset *const ruleset,
 		rb_link_node(&new_rule->node, parent_node, walker_node);
 		rb_insert_color(&new_rule->node, &ruleset->root_inode);
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		new_rule = create_rule(NULL, object_data, layers,
+				       num_layers, NULL);
+		if (IS_ERR(new_rule))
+			return PTR_ERR(new_rule);
+		rb_link_node(&new_rule->node, parent_node, walker_node);
+		rb_insert_color(&new_rule->node, &ruleset->root_net_port);
+		ruleset->num_rules++;
+		break;
 	}
 	return 0;
 }
@@ -315,6 +348,9 @@ static int tree_merge(struct landlock_ruleset *const src,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		src_root = &src->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		src_root = &src->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -341,6 +377,11 @@ static int tree_merge(struct landlock_ruleset *const src,
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
@@ -376,6 +417,10 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	err = tree_merge(src, dst, LANDLOCK_RULE_PATH_BENEATH);
 	if (err)
 		goto out_unlock;
+	/* Merges the @src network tree. */
+	err = tree_merge(src, dst, LANDLOCK_RULE_NET_SERVICE);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -395,6 +440,9 @@ static int tree_copy(struct landlock_ruleset *const parent,
 	case LANDLOCK_RULE_PATH_BENEATH:
 		parent_root = &parent->root_inode;
 		break;
+	case LANDLOCK_RULE_NET_SERVICE:
+		parent_root = &parent->root_net_port;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -407,6 +455,12 @@ static int tree_copy(struct landlock_ruleset *const parent,
 					  rule_type, &walker_rule->layers,
 					  walker_rule->num_layers);
 			break;
+		case LANDLOCK_RULE_NET_SERVICE:
+			err = insert_rule(child, NULL,
+					  walker_rule->object.data, rule_type,
+					  &walker_rule->layers,
+					  walker_rule->num_layers);
+			break;
 		}
 		if (err)
 			return err;
@@ -429,6 +483,10 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,

 	/* Copies the @parent inode tree. */
 	err = tree_copy(parent, child, LANDLOCK_RULE_PATH_BENEATH);
+	if (err)
+		goto out_unlock;
+	/* Copies the @parent inode tree. */
+	err = tree_copy(parent, child, LANDLOCK_RULE_NET_SERVICE);
 	if (err)
 		goto out_unlock;

@@ -463,9 +521,11 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)

 	might_sleep();
 	rbtree_postorder_for_each_entry_safe(freeme, next,
-					     &ruleset->root_inode,
-					     node)
+					     &ruleset->root_inode, node)
 		free_rule(freeme, LANDLOCK_RULE_PATH_BENEATH);
+	rbtree_postorder_for_each_entry_safe(freeme, next,
+					     &ruleset->root_net_port, node)
+		free_rule(freeme, LANDLOCK_RULE_NET_SERVICE);
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -560,13 +620,13 @@ const struct landlock_rule *landlock_find_rule(
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
index f3cd890d0348..916b30b31c06 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -102,6 +102,12 @@ struct landlock_ruleset {
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
@@ -157,7 +163,8 @@ struct landlock_ruleset {
 };

 struct landlock_ruleset *landlock_create_ruleset(
-		const access_mask_t access_mask);
+					const access_mask_t access_mask_fs,
+					const access_mask_t access_mask_net);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -183,11 +190,12 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 }

 /* A helper function to set a filesystem mask */
-static inline void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
-				 const access_mask_t access_maskset,
+static inline void landlock_set_fs_access_mask(
+				 struct landlock_ruleset *ruleset,
+				 const access_mask_t access_mask_fs,
 				 u16 mask_level)
 {
-	ruleset->access_masks[mask_level] = access_maskset;
+	ruleset->access_masks[mask_level] = access_mask_fs;
 }

 /* A helper function to get a filesystem mask */
@@ -198,6 +206,24 @@ static inline u32 landlock_get_fs_access_mask(
 	return (ruleset->access_masks[mask_level] & LANDLOCK_MASK_ACCESS_FS);
 }

+/* A helper function to set a network mask */
+static inline void landlock_set_net_access_mask(
+				  struct landlock_ruleset *ruleset,
+				  const access_mask_t access_mask_net,
+				  u16 mask_level)
+{
+	ruleset->access_masks[mask_level] |= (access_mask_net <<
+					      LANDLOCK_MASK_SHIFT_NET);
+}
+
+/* A helper function to get a network mask */
+static inline u32 landlock_get_net_access_mask(
+				const struct landlock_ruleset *ruleset,
+				u16 mask_level)
+{
+	return (ruleset->access_masks[mask_level] >> LANDLOCK_MASK_SHIFT_NET);
+}
+
 access_mask_t get_handled_accesses(
 		const struct landlock_ruleset *const domain,
 		u16 rule_type, u16 num_access);
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 31f9facec123..812541f4e155 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -189,8 +189,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	    LANDLOCK_MASK_ACCESS_FS)
 		return -EINVAL;

+	/* Checks network content (and 32-bits cast). */
+	if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
+			LANDLOCK_MASK_ACCESS_NET)
+		return -EINVAL;
+
 	/* Checks arguments and transforms to kernel struct. */
-	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
+	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
+					  ruleset_attr.handled_access_net);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);

@@ -275,21 +281,17 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
 	return err;
 }

-static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_attr)
+static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
+				 const void *const rule_attr)
 {
 	struct landlock_path_beneath_attr path_beneath_attr;
 	struct path path;
-	struct landlock_ruleset *ruleset;
 	int res, err;
-
-	/* Gets and checks the ruleset. */
-	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
-	if (IS_ERR(ruleset))
-		return PTR_ERR(ruleset);
+	u32 mask;

 	/* Copies raw user space buffer, only one type for now. */
 	res = copy_from_user(&path_beneath_attr, rule_attr,
-				sizeof(path_beneath_attr));
+			sizeof(path_beneath_attr));
 	if (res)
 		return -EFAULT;

@@ -298,32 +300,26 @@ static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_at
 	 * are ignored in path walks.
 	 */
 	if (!path_beneath_attr.allowed_access) {
-		err = -ENOMSG;
-		goto out_put_ruleset;
+		return -ENOMSG;
 	}
 	/*
 	 * Checks that allowed_access matches the @ruleset constraints
 	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access |
-		landlock_get_fs_access_mask(ruleset, 0)) !=
-				landlock_get_fs_access_mask(ruleset, 0)) {
-		err = -EINVAL;
-		goto out_put_ruleset;
-	}
+	mask = landlock_get_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask)
+		return -EINVAL;

 	/* Gets and checks the new rule. */
 	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
 	if (err)
-		goto out_put_ruleset;
+		return err;

 	/* Imports the new rule. */
 	err = landlock_append_fs_rule(ruleset, &path,
 				      path_beneath_attr.allowed_access);
 	path_put(&path);

-out_put_ruleset:
-	landlock_put_ruleset(ruleset);
 	return err;
 }

@@ -360,6 +356,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
 		const int, ruleset_fd, const enum landlock_rule_type, rule_type,
 		const void __user *const, rule_attr, const __u32, flags)
 {
+	struct landlock_ruleset *ruleset;
 	int err;

 	if (!landlock_initialized)
@@ -369,14 +366,20 @@ SYSCALL_DEFINE4(landlock_add_rule,
 	if (flags)
 		return -EINVAL;

+	/* Gets and checks the ruleset. */
+	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
 	switch (rule_type) {
 	case LANDLOCK_RULE_PATH_BENEATH:
-		err = add_rule_path_beneath(ruleset_fd, rule_attr);
+		err = add_rule_path_beneath(ruleset, rule_attr);
 		break;
 	default:
 		err = -EINVAL;
 		break;
 	}
+	landlock_put_ruleset(ruleset);
 	return err;
 }

--
2.25.1

