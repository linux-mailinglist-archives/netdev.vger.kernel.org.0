Return-Path: <netdev+bounces-2699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 698D870327B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E06D1C20BE1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48254E575;
	Mon, 15 May 2023 16:14:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381B1FBE2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:14:10 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9BD213A;
	Mon, 15 May 2023 09:14:06 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QKktW1vt0z67N2W;
	Tue, 16 May 2023 00:13:07 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 17:14:03 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
Subject: [PATCH v11 01/12] landlock: Make ruleset's access masks more generic
Date: Tue, 16 May 2023 00:13:28 +0800
Message-ID: <20230515161339.631577-2-konstantin.meskhidze@huawei.com>
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

To support network type rules, this modification renames ruleset's
access masks and modifies it's type to access_masks_t. This patch
adds filesystem helper functions to add and get filesystem mask.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v10:
* Squashes landlock_get_fs_access_mask() part from commit 2.

Changes since v9:
* None.

Changes since v8:
* Minor fixes.

Changes since v7:
* Refactors commit message.

Changes since v6:
* Adds a new access_masks_t for struct ruleset.
* Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
  because it OR values.
* Makes landlock_add_fs_access_mask() more resilient incorrect values.
* Refactors landlock_get_fs_access_mask().

Changes since v6:
* Adds a new access_masks_t for struct ruleset.
* Renames landlock_set_fs_access_mask() to landlock_add_fs_access_mask()
  because it OR values.
* Makes landlock_add_fs_access_mask() more resilient incorrect values.
* Refactors landlock_get_fs_access_mask().

Changes since v5:
* Changes access_mask_t to u32.
* Formats code with clang-format-14.

Changes since v4:
* Deletes struct landlock_access_mask.

Changes since v3:
* Splits commit.
* Adds get_mask, set_mask helpers for filesystem.
* Adds new struct landlock_access_mask.

---
 security/landlock/fs.c       | 10 +++++-----
 security/landlock/limits.h   |  1 +
 security/landlock/ruleset.c  | 17 +++++++++--------
 security/landlock/ruleset.h  | 34 ++++++++++++++++++++++++++++++----
 security/landlock/syscalls.c |  7 ++++---
 5 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index adcea0fe7e68..0d57c6479d29 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -178,9 +178,9 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;

 	/* Transforms relative access rights to absolute ones. */
-	access_rights |=
-		LANDLOCK_MASK_ACCESS_FS &
-		~(ruleset->fs_access_masks[0] | ACCESS_INITIALLY_DENIED);
+	access_rights |= LANDLOCK_MASK_ACCESS_FS &
+			 ~(landlock_get_fs_access_mask(ruleset, 0) |
+			   ACCESS_INITIALLY_DENIED);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -294,7 +294,7 @@ get_handled_accesses(const struct landlock_ruleset *const domain)
 	size_t layer_level;

 	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
-		access_dom |= domain->fs_access_masks[layer_level];
+		access_dom |= landlock_get_fs_access_mask(domain, layer_level);
 	return access_dom & LANDLOCK_MASK_ACCESS_FS;
 }

@@ -336,7 +336,7 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 			 * access rights.
 			 */
 			if (BIT_ULL(access_bit) &
-			    (domain->fs_access_masks[layer_level] |
+			    (landlock_get_fs_access_mask(domain, layer_level) |
 			     ACCESS_INITIALLY_DENIED)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index 82288f0e9e5e..bafb3b8dc677 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -21,6 +21,7 @@
 #define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_TRUNCATE
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
 #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
+#define LANDLOCK_SHIFT_ACCESS_FS	0

 /* clang-format on */

diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 996484f98bfd..1f3188b4e313 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -29,7 +29,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	struct landlock_ruleset *new_ruleset;

 	new_ruleset =
-		kzalloc(struct_size(new_ruleset, fs_access_masks, num_layers),
+		kzalloc(struct_size(new_ruleset, access_masks, num_layers),
 			GFP_KERNEL_ACCOUNT);
 	if (!new_ruleset)
 		return ERR_PTR(-ENOMEM);
@@ -40,7 +40,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	/*
 	 * hierarchy = NULL
 	 * num_rules = 0
-	 * fs_access_masks[] = 0
+	 * access_masks[] = 0
 	 */
 	return new_ruleset;
 }
@@ -55,7 +55,7 @@ landlock_create_ruleset(const access_mask_t fs_access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (!IS_ERR(new_ruleset))
-		new_ruleset->fs_access_masks[0] = fs_access_mask;
+		landlock_add_fs_access_mask(new_ruleset, fs_access_mask, 0);
 	return new_ruleset;
 }

@@ -117,11 +117,12 @@ static void build_check_ruleset(void)
 		.num_rules = ~0,
 		.num_layers = ~0,
 	};
-	typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) access_masks = ~0;

 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
-	BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
+	BUILD_BUG_ON(access_masks <
+		     (LANDLOCK_MASK_ACCESS_FS << LANDLOCK_SHIFT_ACCESS_FS));
 }

 /**
@@ -281,7 +282,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
@@ -340,8 +341,8 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 		goto out_unlock;
 	}
 	/* Copies the parent layer stack and leaves a space for the new layer. */
-	memcpy(child->fs_access_masks, parent->fs_access_masks,
-	       flex_array_size(parent, fs_access_masks, parent->num_layers));
+	memcpy(child->access_masks, parent->access_masks,
+	       flex_array_size(parent, access_masks, parent->num_layers));

 	if (WARN_ON_ONCE(!parent->hierarchy)) {
 		err = -EINVAL;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index d43231b783e4..e900b84d915f 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -25,6 +25,11 @@ static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
 /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
 static_assert(sizeof(unsigned long) >= sizeof(access_mask_t));

+/* Ruleset access masks. */
+typedef u16 access_masks_t;
+/* Makes sure all ruleset access rights can be stored. */
+static_assert(BITS_PER_TYPE(access_masks_t) >= LANDLOCK_NUM_ACCESS_FS);
+
 typedef u16 layer_mask_t;
 /* Makes sure all layers can be checked. */
 static_assert(BITS_PER_TYPE(layer_mask_t) >= LANDLOCK_MAX_NUM_LAYERS);
@@ -110,7 +115,7 @@ struct landlock_ruleset {
 		 * section.  This is only used by
 		 * landlock_put_ruleset_deferred() when @usage reaches zero.
 		 * The fields @lock, @usage, @num_rules, @num_layers and
-		 * @fs_access_masks are then unused.
+		 * @access_masks are then unused.
 		 */
 		struct work_struct work_free;
 		struct {
@@ -137,7 +142,7 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @fs_access_masks: Contains the subset of filesystem
+			 * @access_masks: Contains the subset of filesystem
 			 * actions that are restricted by a ruleset.  A domain
 			 * saves all layers of merged rulesets in a stack
 			 * (FAM), starting from the first layer to the last
@@ -148,13 +153,13 @@ struct landlock_ruleset {
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
 			 */
-			access_mask_t fs_access_masks[];
+			access_masks_t access_masks[];
 		};
 	};
 };

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t fs_access_mask);
+landlock_create_ruleset(const access_mask_t access_mask);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -177,4 +182,25 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 		refcount_inc(&ruleset->usage);
 }

+static inline void
+landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
+			    const access_mask_t fs_access_mask,
+			    const u16 layer_level)
+{
+	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
+
+	/* Should already be checked in sys_landlock_create_ruleset(). */
+	WARN_ON_ONCE(fs_access_mask != fs_mask);
+	ruleset->access_masks[layer_level] |=
+		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
+}
+
+static inline access_mask_t
+landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
+			    const u16 layer_level)
+{
+	return (ruleset->access_masks[layer_level] >>
+		LANDLOCK_SHIFT_ACCESS_FS) &
+	       LANDLOCK_MASK_ACCESS_FS;
+}
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 245cc650a4dc..7ec6bbed7117 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -310,6 +310,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	struct path path;
 	struct landlock_ruleset *ruleset;
 	int res, err;
+	access_mask_t mask;

 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
@@ -346,10 +347,10 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	}
 	/*
 	 * Checks that allowed_access matches the @ruleset constraints
-	 * (ruleset->fs_access_masks[0] is automatically upgraded to 64-bits).
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access | ruleset->fs_access_masks[0]) !=
-	    ruleset->fs_access_masks[0]) {
+	mask = landlock_get_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask) {
 		err = -EINVAL;
 		goto out_put_ruleset;
 	}
--
2.25.1


