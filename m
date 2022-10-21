Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C44607A8A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJUP1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiJUP1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:27:21 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391AE24AE22;
        Fri, 21 Oct 2022 08:27:09 -0700 (PDT)
Received: from frapeml100003.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7Xh68KGz67kVR;
        Fri, 21 Oct 2022 23:23:48 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100003.china.huawei.com (7.182.85.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:27:07 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:27:06 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 07/12] landlock: Add network rules support
Date:   Fri, 21 Oct 2022 23:26:39 +0800
Message-ID: <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds network rules support in internal landlock functions
(presented in ruleset.c) and landlock_create_ruleset syscall.
Refactors user space API to support network actions. Adds new network
access flags, network rule and network attributes. Increments Landlock
ABI version.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v7:
* Squashes commits.
* Increments ABI version to 4.
* Refactors commit message.
* Minor fixes.

Changes since v6:
* Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
  because it OR values.
* Makes landlock_add_net_access_mask() more resilient incorrect values.
* Refactors landlock_get_net_access_mask().
* Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
  LANDLOCK_NUM_ACCESS_FS as value.
* Updates access_masks_t to u32 to support network access actions.
* Refactors landlock internal functions to support network actions with
  landlock_key/key_type/id types.

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
 include/uapi/linux/landlock.h                | 49 ++++++++++++++
 security/landlock/limits.h                   |  6 +-
 security/landlock/ruleset.c                  | 55 ++++++++++++++--
 security/landlock/ruleset.h                  | 68 ++++++++++++++++----
 security/landlock/syscalls.c                 | 13 +++-
 tools/testing/selftests/landlock/base_test.c |  2 +-
 6 files changed, 170 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index f3223f964691..096b683c6ff3 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
 	 * this access right.
 	 */
 	__u64 handled_access_fs;
+
+	/**
+	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
+	 * that is handled by this ruleset and should then be forbidden if no
+	 * rule explicitly allow them.
+	 */
+	__u64 handled_access_net;
 };

 /*
@@ -54,6 +61,11 @@ enum landlock_rule_type {
 	 * landlock_path_beneath_attr .
 	 */
 	LANDLOCK_RULE_PATH_BENEATH = 1,
+	/**
+	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
+	 * landlock_net_service_attr .
+	 */
+	LANDLOCK_RULE_NET_SERVICE = 2,
 };

 /**
@@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
 	 */
 } __attribute__((packed));

+/**
+ * struct landlock_net_service_attr - TCP subnet definition
+ *
+ * Argument of sys_landlock_add_rule().
+ */
+struct landlock_net_service_attr {
+	/**
+	 * @allowed_access: Bitmask of allowed access network for services
+	 * (cf. `Network flags`_).
+	 */
+	__u64 allowed_access;
+	/**
+	 * @port: Network port.
+	 */
+	__u16 port;
+
+} __attribute__((packed));
+
 /**
  * DOC: fs_access
  *
@@ -173,4 +203,23 @@ struct landlock_path_beneath_attr {
 #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
 /* clang-format on */

+/**
+ * DOC: net_access
+ *
+ * Network flags
+ * ~~~~~~~~~~~~~~~~
+ *
+ * These flags enable to restrict a sandboxed process to a set of network
+ * actions.
+ *
+ * TCP sockets with allowed actions:
+ *
+ * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
+ * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
+ *   a remote port.
+ */
+/* clang-format off */
+#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
+#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
+/* clang-format on */
 #endif /* _UAPI_LINUX_LANDLOCK_H */
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index bafb3b8dc677..8a1a6463c64e 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -23,6 +23,10 @@
 #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
 #define LANDLOCK_SHIFT_ACCESS_FS	0

-/* clang-format on */
+#define LANDLOCK_LAST_ACCESS_NET	LANDLOCK_ACCESS_NET_CONNECT_TCP
+#define LANDLOCK_MASK_ACCESS_NET	((LANDLOCK_LAST_ACCESS_NET << 1) - 1)
+#define LANDLOCK_NUM_ACCESS_NET		__const_hweight64(LANDLOCK_MASK_ACCESS_NET)
+#define LANDLOCK_SHIFT_ACCESS_NET	LANDLOCK_NUM_ACCESS_FS

+/* clang-format on */
 #endif /* _SECURITY_LANDLOCK_LIMITS_H */
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index c7cf54ba4f6d..9277c1295114 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -36,6 +36,9 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	refcount_set(&new_ruleset->usage, 1);
 	mutex_init(&new_ruleset->lock);
 	new_ruleset->root_inode = RB_ROOT;
+#if IS_ENABLED(CONFIG_INET)
+	new_ruleset->root_net_port = RB_ROOT;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	new_ruleset->num_layers = num_layers;
 	/*
 	 * hierarchy = NULL
@@ -46,16 +49,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 }

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t fs_access_mask)
+landlock_create_ruleset(const access_mask_t fs_access_mask,
+			const access_mask_t net_access_mask)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!fs_access_mask)
+	if (!fs_access_mask && !net_access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
-	if (!IS_ERR(new_ruleset))
+	if (IS_ERR(new_ruleset))
+		return new_ruleset;
+	if (fs_access_mask)
 		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
+	if (net_access_mask)
+		landlock_add_net_access_mask(new_ruleset, net_access_mask, 0);
 	return new_ruleset;
 }

@@ -73,6 +81,10 @@ static inline bool is_object_pointer(const enum landlock_key_type key_type)
 	switch (key_type) {
 	case LANDLOCK_KEY_INODE:
 		return true;
+#if IS_ENABLED(CONFIG_INET)
+	case LANDLOCK_KEY_NET_PORT:
+		return false;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	}
 	WARN_ON_ONCE(1);
 	return false;
@@ -126,6 +138,11 @@ static inline struct rb_root *get_root(struct landlock_ruleset *const ruleset,
 	case LANDLOCK_KEY_INODE:
 		root = &ruleset->root_inode;
 		break;
+#if IS_ENABLED(CONFIG_INET)
+	case LANDLOCK_KEY_NET_PORT:
+		root = &ruleset->root_net_port;
+		break;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	}
 	if (WARN_ON_ONCE(!root))
 		return ERR_PTR(-EINVAL);
@@ -154,7 +171,9 @@ static void build_check_ruleset(void)
 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
 	BUILD_BUG_ON(access_masks <
-		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
+		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS) +
+			     (LANDLOCK_MASK_ACCESS_NET
+			      << LANDLOCK_SHIFT_ACCESS_NET));
 }

 /**
@@ -370,7 +389,12 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
 	if (err)
 		goto out_unlock;
-
+#if IS_ENABLED(CONFIG_INET)
+	/* Merges the @src network port tree. */
+	err = merge_tree(dst, src, LANDLOCK_KEY_NET_PORT);
+	if (err)
+		goto out_unlock;
+#endif /* IS_ENABLED(CONFIG_INET) */
 out_unlock:
 	mutex_unlock(&src->lock);
 	mutex_unlock(&dst->lock);
@@ -426,7 +450,12 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
 	if (err)
 		goto out_unlock;
-
+#if IS_ENABLED(CONFIG_INET)
+	/* Copies the @parent network port tree. */
+	err = inherit_tree(parent, child, LANDLOCK_KEY_NET_PORT);
+	if (err)
+		goto out_unlock;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
 		goto out_unlock;
@@ -459,6 +488,11 @@ static void free_ruleset(struct landlock_ruleset *const ruleset)
 	rbtree_postorder_for_each_entry_safe(freeme, next, &ruleset->root_inode,
 					     node)
 		free_rule(freeme, LANDLOCK_KEY_INODE);
+#if IS_ENABLED(CONFIG_INET)
+	rbtree_postorder_for_each_entry_safe(freeme, next,
+					     &ruleset->root_net_port, node)
+		free_rule(freeme, LANDLOCK_KEY_NET_PORT);
+#endif /* IS_ENABLED(CONFIG_INET) */
 	put_hierarchy(ruleset->hierarchy);
 	kfree(ruleset);
 }
@@ -637,6 +671,9 @@ get_access_mask_t(const struct landlock_ruleset *const ruleset,
  * Populates @layer_masks such that for each access right in @access_request,
  * the bits for all the layers are set where this access right is handled.
  *
+ * @layer_masks must contain LANDLOCK_NUM_ACCESS_FS or LANDLOCK_NUM_ACCESS_NET
+ * elements according to @key_type.
+ *
  * @domain: The domain that defines the current restrictions.
  * @access_request: The requested access rights to check.
  * @layer_masks: The layer masks to populate.
@@ -659,6 +696,12 @@ access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
 		get_access_mask = landlock_get_fs_access_mask;
 		num_access = LANDLOCK_NUM_ACCESS_FS;
 		break;
+#if IS_ENABLED(CONFIG_INET)
+	case LANDLOCK_KEY_NET_PORT:
+		get_access_mask = landlock_get_net_access_mask;
+		num_access = LANDLOCK_NUM_ACCESS_NET;
+		break;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index d9eb79ea9a89..f272d2cd518c 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -19,16 +19,20 @@
 #include "limits.h"
 #include "object.h"

+/* Rule access mask. */
 typedef u16 access_mask_t;
 /* Makes sure all filesystem access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
+/* Makes sure all network access rights can be stored. */
+static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_NET);
 /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
 static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));

 /* Ruleset access masks. */
-typedef u16 access_masks_t;
+typedef u32 access_masks_t;
 /* Makes sure all ruleset access rights can be stored. */
-static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
+static_assert(BITS_PER_TYPE(access_masks_t) >=
+	      LANDLOCK_NUM_ACCESS_FS + LANDLOCK_NUM_ACCESS_NET);

 typedef u16 layer_mask_t;
 /* Makes sure all layers can be checked. */
@@ -82,6 +86,13 @@ enum landlock_key_type {
 	 * keys.
 	 */
 	LANDLOCK_KEY_INODE = 1,
+#if IS_ENABLED(CONFIG_INET)
+	/**
+	 * @LANDLOCK_KEY_NET_PORT: Type of &landlock_ruleset.root_net_port's
+	 * node keys.
+	 */
+	LANDLOCK_KEY_NET_PORT = 2,
+#endif /* IS_ENABLED(CONFIG_INET) */
 };

 /**
@@ -156,6 +167,15 @@ struct landlock_ruleset {
 	 * reaches zero.
 	 */
 	struct rb_root root_inode;
+#if IS_ENABLED(CONFIG_INET)
+	/**
+	 * @root_net_port: Root of a red-black tree containing &struct
+	 * landlock_rule nodes with network port. Once a ruleset is tied to a
+	 * process (i.e. as a domain), this tree is immutable until @usage
+	 * reaches zero.
+	 */
+	struct rb_root root_net_port;
+#endif /* IS_ENABLED(CONFIG_INET) */
 	/**
 	 * @hierarchy: Enables hierarchy identification even when a parent
 	 * domain vanishes.  This is needed for the ptrace protection.
@@ -166,8 +186,8 @@ struct landlock_ruleset {
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
@@ -194,13 +214,13 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @access_masks: Contains the subset of filesystem
-			 * actions that are restricted by a ruleset.  A domain
-			 * saves all layers of merged rulesets in a stack
-			 * (FAM), starting from the first layer to the last
-			 * one.  These layers are used when merging rulesets,
-			 * for user space backward compatibility (i.e.
-			 * future-proof), and to properly handle merged
+			 * @access_masks: Contains the subset of filesystem and
+			 * network actions that are restricted by a ruleset.
+			 * A domain saves all layers of merged rulesets in a
+			 * stack (FAM), starting from the first layer to the
+			 * last one.  These layers are used when merging
+			 * rulesets, for user space backward compatibility
+			 * (i.e. future-proof), and to properly handle merged
 			 * rulesets without overlapping access rights.  These
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
@@ -211,7 +231,8 @@ struct landlock_ruleset {
 };

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t access_mask);
+landlock_create_ruleset(const access_mask_t access_mask_fs,
+			const access_mask_t access_mask_net);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -248,6 +269,20 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
 		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
 }

+static inline void
+landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
+			     const access_mask_t net_access_mask,
+			     const u16 layer_level)
+{
+	access_mask_t net_mask = net_access_mask & LANDLOCK_MASK_ACCESS_NET;
+
+	/* Should already be checked in sys_landlock_create_ruleset(). */
+	WARN_ON_ONCE(net_access_mask != net_mask);
+	// TODO: Add tests to check "|=" and not "="
+	ruleset->access_masks[layer_level] |=
+		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
+}
+
 static inline access_mask_t
 landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
 			    const u16 layer_level)
@@ -257,6 +292,15 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
 	       LANDLOCK_MASK_ACCESS_FS;
 }

+static inline access_mask_t
+landlock_get_net_access_mask(const struct landlock_ruleset *const ruleset,
+			     const u16 layer_level)
+{
+	return (ruleset->access_masks[layer_level] >>
+		LANDLOCK_SHIFT_ACCESS_NET) &
+	       LANDLOCK_MASK_ACCESS_NET;
+}
+
 bool unmask_layers(const struct landlock_rule *const rule,
 		   const access_mask_t access_request,
 		   layer_mask_t (*const layer_masks)[],
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 87389d7bfbf2..c5a6ad4e2fca 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -82,8 +82,9 @@ static void build_check_abi(void)
 	 * struct size.
 	 */
 	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
+	ruleset_size += sizeof(ruleset_attr.handled_access_net);
 	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
-	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
+	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);

 	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
 	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
@@ -129,7 +130,7 @@ static const struct file_operations ruleset_fops = {
 	.write = fop_dummy_write,
 };

-#define LANDLOCK_ABI_VERSION 3
+#define LANDLOCK_ABI_VERSION 4

 /**
  * sys_landlock_create_ruleset - Create a new ruleset
@@ -188,8 +189,14 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
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

diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 792c3f0a59b4..646f778dfb1e 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -75,7 +75,7 @@ TEST(abi_version)
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
-	ASSERT_EQ(3, landlock_create_ruleset(NULL, 0,
+	ASSERT_EQ(4, landlock_create_ruleset(NULL, 0,
 					     LANDLOCK_CREATE_RULESET_VERSION));

 	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
--
2.25.1

