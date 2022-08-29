Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086135A5287
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiH2REO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiH2REN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B49BB52;
        Mon, 29 Aug 2022 10:04:11 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcGK2R6Nz67x0N;
        Tue, 30 Aug 2022 01:03:37 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:10 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:09 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 01/18] landlock: rename access mask
Date:   Tue, 30 Aug 2022 01:03:44 +0800
Message-ID: <20220829170401.834298-2-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support network type rules, this modification renames ruleset's
access masks and modifies it's type to access_masks_t. This patch
adds filesystem helper functions to add and get filesystem mask.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/fs.c       |  7 ++++---
 security/landlock/limits.h   |  1 +
 security/landlock/ruleset.c  | 17 +++++++++--------
 security/landlock/ruleset.h  | 37 ++++++++++++++++++++++++++++++++----
 security/landlock/syscalls.c |  7 ++++---
 5 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index c57f581a9cd5..e2d1cc28729a 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -168,7 +168,8 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;

 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |= LANDLOCK_MASK_ACCESS_FS &
+			 ~landlock_get_fs_access_mask(ruleset, 0);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -287,7 +288,7 @@ get_handled_accesses(const struct landlock_ruleset *const domain)

 		for (layer_level = 0; layer_level < domain->num_layers;
 		     layer_level++) {
-			if (domain->fs_access_masks[layer_level] &
+			if (landlock_get_fs_access_mask(domain, layer_level) &
 			    BIT_ULL(access_bit)) {
 				access_dom |= BIT_ULL(access_bit);
 				break;
@@ -317,7 +318,7 @@ init_layer_masks(const struct landlock_ruleset *const domain,

 		for_each_set_bit(access_bit, &access_req,
 				 ARRAY_SIZE(*layer_masks)) {
-			if (domain->fs_access_masks[layer_level] &
+			if (landlock_get_fs_access_mask(domain, layer_level) &
 			    BIT_ULL(access_bit)) {
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
index d43231b783e4..647d44284080 100644
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
@@ -177,4 +182,28 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 		refcount_inc(&ruleset->usage);
 }

+/* A helper function to set a filesystem mask. */
+static inline void
+landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
+			    const access_mask_t fs_access_mask,
+			    const u16 layer_level)
+{
+	access_mask_t fs_mask = fs_access_mask & LANDLOCK_MASK_ACCESS_FS;
+
+	/* Should already be checked in sys_landlock_create_ruleset(). */
+	WARN_ON_ONCE(fs_access_mask != fs_mask);
+	// TODO: Add tests to check "|=" and not "="
+	ruleset->access_masks[layer_level] |=
+		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
+}
+
+/* A helper function to get a filesystem mask. */
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
index f4d6fc7ed17f..6593381466e0 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -346,10 +346,11 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	}
 	/*
 	 * Checks that allowed_access matches the @ruleset constraints
-	 * (ruleset->fs_access_masks[0] is automatically upgraded to 64-bits).
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access | ruleset->fs_access_masks[0]) !=
-	    ruleset->fs_access_masks[0]) {
+	if ((path_beneath_attr.allowed_access |
+	     landlock_get_fs_access_mask(ruleset, 0)) !=
+	    landlock_get_fs_access_mask(ruleset, 0)) {
 		err = -EINVAL;
 		goto out_put_ruleset;
 	}
--
2.25.1

