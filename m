Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246686C6248
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCWIwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCWIwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:52:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC434489;
        Thu, 23 Mar 2023 01:52:36 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PhzXk1fnZz67ZBB;
        Thu, 23 Mar 2023 16:49:10 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 08:52:34 +0000
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v10 02/13] landlock: Allow filesystem layout changes for domains without such rule type
Date:   Thu, 23 Mar 2023 16:52:15 +0800
Message-ID: <20230323085226.1432550-3-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mickaël Salaün <mic@digikod.net>

Allow mount point and root directory changes when there is no filesystem
rule tied to the current Landlock domain.  This doesn't change anything
for now because a domain must have at least a (filesystem) rule, but
this will change when other rule types will come.  For instance, a
domain only restricting the network should have no impact on filesystem
restrictions.

Add a new get_current_fs_domain() helper to quickly check filesystem
rule existence for all filesystem LSM hooks.

Remove unnecessary inlining.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
---

Changes since v9:
* Refactors documentaion landlock.rst.
* Changes ACCESS_FS_INITIALLY_DENIED constant
to LANDLOCK_ACCESS_FS_INITIALLY_DENIED.
* Gets rid of unnecessary masking of access_dom in
get_raw_handled_fs_accesses() function.

Changes since v8:
* Refactors get_handled_fs_accesses().
* Adds landlock_get_raw_fs_access_mask() helper.

---
 Documentation/userspace-api/landlock.rst |  6 +-
 security/landlock/fs.c                   | 78 ++++++++++++------------
 security/landlock/ruleset.h              | 25 +++++++-
 security/landlock/syscalls.c             |  6 +-
 4 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index d8cd8cd9ce25..f6a7da21708a 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -387,9 +387,9 @@ Current limitations
 Filesystem topology modification
 --------------------------------

-As for file renaming and linking, a sandboxed thread cannot modify its
-filesystem topology, whether via :manpage:`mount(2)` or
-:manpage:`pivot_root(2)`.  However, :manpage:`chroot(2)` calls are not denied.
+Threads sandboxed with filesystem restrictions cannot modify filesystem
+topology, whether via :manpage:`mount(2)` or :manpage:`pivot_root(2)`.
+However, :manpage:`chroot(2)` calls are not denied.

 Special filesystems
 -------------------
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 0d57c6479d29..05a339bf2a7c 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -150,16 +150,6 @@ static struct landlock_object *get_inode_object(struct inode *const inode)
 	LANDLOCK_ACCESS_FS_TRUNCATE)
 /* clang-format on */

-/*
- * All access rights that are denied by default whether they are handled or not
- * by a ruleset/layer.  This must be ORed with all ruleset->fs_access_masks[]
- * entries when we need to get the absolute handled access masks.
- */
-/* clang-format off */
-#define ACCESS_INITIALLY_DENIED ( \
-	LANDLOCK_ACCESS_FS_REFER)
-/* clang-format on */
-
 /*
  * @path: Should have been checked by get_path_from_fd().
  */
@@ -179,8 +169,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,

 	/* Transforms relative access rights to absolute ones. */
 	access_rights |= LANDLOCK_MASK_ACCESS_FS &
-			 ~(landlock_get_fs_access_mask(ruleset, 0) |
-			   ACCESS_INITIALLY_DENIED);
+			 ~landlock_get_fs_access_mask(ruleset, 0);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -287,15 +276,16 @@ static inline bool is_nouser_or_private(const struct dentry *dentry)
 		unlikely(IS_PRIVATE(d_backing_inode(dentry))));
 }

-static inline access_mask_t
-get_handled_accesses(const struct landlock_ruleset *const domain)
+static access_mask_t
+get_raw_handled_fs_accesses(const struct landlock_ruleset *const domain)
 {
-	access_mask_t access_dom = ACCESS_INITIALLY_DENIED;
+	access_mask_t access_dom = 0;
 	size_t layer_level;

 	for (layer_level = 0; layer_level < domain->num_layers; layer_level++)
-		access_dom |= landlock_get_fs_access_mask(domain, layer_level);
-	return access_dom & LANDLOCK_MASK_ACCESS_FS;
+		access_dom |=
+			landlock_get_raw_fs_access_mask(domain, layer_level);
+	return access_dom;
 }

 /**
@@ -331,13 +321,8 @@ init_layer_masks(const struct landlock_ruleset *const domain,

 		for_each_set_bit(access_bit, &access_req,
 				 ARRAY_SIZE(*layer_masks)) {
-			/*
-			 * Artificially handles all initially denied by default
-			 * access rights.
-			 */
 			if (BIT_ULL(access_bit) &
-			    (landlock_get_fs_access_mask(domain, layer_level) |
-			     ACCESS_INITIALLY_DENIED)) {
+			    landlock_get_fs_access_mask(domain, layer_level)) {
 				(*layer_masks)[access_bit] |=
 					BIT_ULL(layer_level);
 				handled_accesses |= BIT_ULL(access_bit);
@@ -347,6 +332,25 @@ init_layer_masks(const struct landlock_ruleset *const domain,
 	return handled_accesses;
 }

+static access_mask_t
+get_handled_fs_accesses(const struct landlock_ruleset *const domain)
+{
+	/* Handles all initially denied by default access rights. */
+	return get_raw_handled_fs_accesses(domain) |
+	       LANDLOCK_ACCESS_FS_INITIALLY_DENIED;
+}
+
+static const struct landlock_ruleset *get_current_fs_domain(void)
+{
+	const struct landlock_ruleset *const dom =
+		landlock_get_current_domain();
+
+	if (!dom || !get_raw_handled_fs_accesses(dom))
+		return NULL;
+
+	return dom;
+}
+
 /*
  * Check that a destination file hierarchy has more restrictions than a source
  * file hierarchy.  This is only used for link and rename actions.
@@ -519,7 +523,7 @@ static bool is_access_to_paths_allowed(
 		 * a superset of the meaningful requested accesses).
 		 */
 		access_masked_parent1 = access_masked_parent2 =
-			get_handled_accesses(domain);
+			get_handled_fs_accesses(domain);
 		is_dom_check = true;
 	} else {
 		if (WARN_ON_ONCE(dentry_child1 || dentry_child2))
@@ -648,11 +652,10 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
 	return -EACCES;
 }

-static inline int current_check_access_path(const struct path *const path,
-					    const access_mask_t access_request)
+static int current_check_access_path(const struct path *const path,
+				     const access_mask_t access_request)
 {
-	const struct landlock_ruleset *const dom =
-		landlock_get_current_domain();
+	const struct landlock_ruleset *const dom = get_current_fs_domain();

 	if (!dom)
 		return 0;
@@ -815,8 +818,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
 				    struct dentry *const new_dentry,
 				    const bool removable, const bool exchange)
 {
-	const struct landlock_ruleset *const dom =
-		landlock_get_current_domain();
+	const struct landlock_ruleset *const dom = get_current_fs_domain();
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
@@ -1050,7 +1052,7 @@ static int hook_sb_mount(const char *const dev_name,
 			 const struct path *const path, const char *const type,
 			 const unsigned long flags, void *const data)
 {
-	if (!landlock_get_current_domain())
+	if (!get_current_fs_domain())
 		return 0;
 	return -EPERM;
 }
@@ -1058,7 +1060,7 @@ static int hook_sb_mount(const char *const dev_name,
 static int hook_move_mount(const struct path *const from_path,
 			   const struct path *const to_path)
 {
-	if (!landlock_get_current_domain())
+	if (!get_current_fs_domain())
 		return 0;
 	return -EPERM;
 }
@@ -1069,14 +1071,14 @@ static int hook_move_mount(const struct path *const from_path,
  */
 static int hook_sb_umount(struct vfsmount *const mnt, const int flags)
 {
-	if (!landlock_get_current_domain())
+	if (!get_current_fs_domain())
 		return 0;
 	return -EPERM;
 }

 static int hook_sb_remount(struct super_block *const sb, void *const mnt_opts)
 {
-	if (!landlock_get_current_domain())
+	if (!get_current_fs_domain())
 		return 0;
 	return -EPERM;
 }
@@ -1092,7 +1094,7 @@ static int hook_sb_remount(struct super_block *const sb, void *const mnt_opts)
 static int hook_sb_pivotroot(const struct path *const old_path,
 			     const struct path *const new_path)
 {
-	if (!landlock_get_current_domain())
+	if (!get_current_fs_domain())
 		return 0;
 	return -EPERM;
 }
@@ -1128,8 +1130,7 @@ static int hook_path_mknod(const struct path *const dir,
 			   struct dentry *const dentry, const umode_t mode,
 			   const unsigned int dev)
 {
-	const struct landlock_ruleset *const dom =
-		landlock_get_current_domain();
+	const struct landlock_ruleset *const dom = get_current_fs_domain();

 	if (!dom)
 		return 0;
@@ -1208,8 +1209,7 @@ static int hook_file_open(struct file *const file)
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
 	access_mask_t open_access_request, full_access_request, allowed_access;
 	const access_mask_t optional_access = LANDLOCK_ACCESS_FS_TRUNCATE;
-	const struct landlock_ruleset *const dom =
-		landlock_get_current_domain();
+	const struct landlock_ruleset *const dom = get_current_fs_domain();

 	if (!dom)
 		return 0;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index e900b84d915f..baef84071f37 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -15,10 +15,21 @@
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
 #include <linux/workqueue.h>
+#include <uapi/linux/landlock.h>

 #include "limits.h"
 #include "object.h"

+/*
+ * All access rights that are denied by default whether they are handled or not
+ * by a ruleset/layer.  This must be ORed with all ruleset->access_masks[]
+ * entries when we need to get the absolute handled access masks.
+ */
+/* clang-format off */
+#define LANDLOCK_ACCESS_FS_INITIALLY_DENIED ( \
+	LANDLOCK_ACCESS_FS_REFER)
+/* clang-format on */
+
 typedef u16 access_mask_t;
 /* Makes sure all filesystem access rights can be stored. */
 static_assert(BITS_PER_TYPE(access_mask_t) >= LANDLOCK_NUM_ACCESS_FS);
@@ -196,11 +207,21 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
 }

 static inline access_mask_t
-landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
-			    const u16 layer_level)
+landlock_get_raw_fs_access_mask(const struct landlock_ruleset *const ruleset,
+				const u16 layer_level)
 {
 	return (ruleset->access_masks[layer_level] >>
 		LANDLOCK_SHIFT_ACCESS_FS) &
 	       LANDLOCK_MASK_ACCESS_FS;
 }
+
+static inline access_mask_t
+landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
+			    const u16 layer_level)
+{
+	/* Handles all initially denied by default access rights. */
+	return landlock_get_raw_fs_access_mask(ruleset, layer_level) |
+	       LANDLOCK_ACCESS_FS_INITIALLY_DENIED;
+}
+
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 71aca7f990bc..d35cd5d304db 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -310,6 +310,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	struct path path;
 	struct landlock_ruleset *ruleset;
 	int res, err;
+	access_mask_t mask;

 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
@@ -348,9 +349,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	 * Checks that allowed_access matches the @ruleset constraints
 	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access |
-	     landlock_get_fs_access_mask(ruleset, 0)) !=
-	    landlock_get_fs_access_mask(ruleset, 0)) {
+	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask) {
 		err = -EINVAL;
 		goto out_put_ruleset;
 	}
--
2.25.1

