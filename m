Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23904552CBD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiFUIX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiFUIXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:23:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E204CA444;
        Tue, 21 Jun 2022 01:23:21 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzvP0xZsz6H7Dt;
        Tue, 21 Jun 2022 16:19:29 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:19 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:19 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 01/17] landlock: renames access mask
Date:   Tue, 21 Jun 2022 16:22:57 +0800
Message-ID: <20220621082313.3330667-2-konstantin.meskhidze@huawei.com>
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

To support network type rules,
this modification extends and renames
ruleset's access masks.
This patch adds filesystem helper functions
to set and get filesystem mask. Also the
modification adds a helper structure
landlock_access_mask to support managing
multiple access mask.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

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
 security/landlock/ruleset.c  | 18 +++++++++---------
 security/landlock/ruleset.h  | 25 ++++++++++++++++++++-----
 security/landlock/syscalls.c |  7 ++++---
 4 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index ec5a6247cd3e..e6da08ed99d1 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -167,7 +167,8 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;

 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |= LANDLOCK_MASK_ACCESS_FS &
+			 ~landlock_get_fs_access_mask(ruleset, 0);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -286,7 +287,7 @@ get_handled_accesses(const struct landlock_ruleset *const domain)

 		for (layer_level = 0; layer_level < domain->num_layers;
 		     layer_level++) {
-			if (domain->fs_access_masks[layer_level] &
+			if (landlock_get_fs_access_mask(domain, layer_level) &
 			    BIT_ULL(access_bit)) {
 				access_dom |= BIT_ULL(access_bit);
 				break;
@@ -316,7 +317,7 @@ init_layer_masks(const struct landlock_ruleset *const domain,

 		for_each_set_bit(access_bit, &access_req,
 				 ARRAY_SIZE(*layer_masks)) {
-			if (domain->fs_access_masks[layer_level] &
+			if (landlock_get_fs_access_mask(domain, layer_level) &
 			    BIT_ULL(access_bit)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 996484f98bfd..a3fd58d01f09 100644
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
@@ -40,22 +40,22 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	/*
 	 * hierarchy = NULL
 	 * num_rules = 0
-	 * fs_access_masks[] = 0
+	 * access_masks[] = 0
 	 */
 	return new_ruleset;
 }

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t fs_access_mask)
+landlock_create_ruleset(const access_mask_t access_mask)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!fs_access_mask)
+	if (!access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (!IS_ERR(new_ruleset))
-		new_ruleset->fs_access_masks[0] = fs_access_mask;
+		landlock_set_fs_access_mask(new_ruleset, access_mask, 0);
 	return new_ruleset;
 }

@@ -117,7 +117,7 @@ static void build_check_ruleset(void)
 		.num_rules = ~0,
 		.num_layers = ~0,
 	};
-	typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;

 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
@@ -281,7 +281,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, &src->root,
@@ -340,8 +340,8 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
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
index d43231b783e4..bd7ab39859bf 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -19,7 +19,7 @@
 #include "limits.h"
 #include "object.h"

-typedef u16 access_mask_t;
+typedef u32 access_mask_t;
 /* Makes sure all filesystem access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
 /* Makes sure for_each_set_bit() and for_each_clear_bit() calls are OK. */
@@ -110,7 +110,7 @@ struct landlock_ruleset {
 		 * section.  This is only used by
 		 * landlock_put_ruleset_deferred() when @usage reaches zero.
 		 * The fields @lock, @usage, @num_rules, @num_layers and
-		 * @fs_access_masks are then unused.
+		 * @access_masks are then unused.
 		 */
 		struct work_struct work_free;
 		struct {
@@ -137,7 +137,7 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @fs_access_masks: Contains the subset of filesystem
+			 * @access_masks: Contains the subset of filesystem
 			 * actions that are restricted by a ruleset.  A domain
 			 * saves all layers of merged rulesets in a stack
 			 * (FAM), starting from the first layer to the last
@@ -148,13 +148,13 @@ struct landlock_ruleset {
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
 			 */
-			access_mask_t fs_access_masks[];
+			access_mask_t access_masks[];
 		};
 	};
 };

 struct landlock_ruleset *
-landlock_create_ruleset(const access_mask_t fs_access_mask);
+landlock_create_ruleset(const access_mask_t access_mask);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -177,4 +177,19 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 		refcount_inc(&ruleset->usage);
 }

+/* A helper function to set a filesystem mask. */
+static inline void
+landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
+			    const access_mask_t access_maskset, u16 mask_level)
+{
+	ruleset->access_masks[mask_level] = access_maskset;
+}
+
+/* A helper function to get a filesystem mask. */
+static inline u32
+landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset,
+			    u16 mask_level)
+{
+	return ruleset->access_masks[mask_level];
+}
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 735a0865ea11..5836736ce9d7 100644
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

