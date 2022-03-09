Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04CC4D303B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiCINqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiCINqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9447417B893;
        Wed,  9 Mar 2022 05:45:10 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1Y53MVz67gYW;
        Wed,  9 Mar 2022 21:43:45 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:08 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 01/15] landlock: access mask renaming
Date:   Wed, 9 Mar 2022 21:44:45 +0800
Message-ID: <20220309134459.6448-2-konstantin.meskhidze@huawei.com>
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

Currently Landlock supports filesystem
restrictions. To support network type rules,
this modification extends and renames
ruleset's access masks.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.

---
 security/landlock/fs.c       |  4 ++--
 security/landlock/ruleset.c  | 18 +++++++++---------
 security/landlock/ruleset.h  |  8 ++++----
 security/landlock/syscalls.c |  6 +++---
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 97b8e421f617..d727bdab7840 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -163,7 +163,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;

 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->fs_access_masks[0];
+	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->access_masks[0];
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -252,7 +252,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	/* Saves all layers handling a subset of requested accesses. */
 	layer_mask = 0;
 	for (i = 0; i < domain->num_layers; i++) {
-		if (domain->fs_access_masks[i] & access_request)
+		if (domain->access_masks[i] & access_request)
 			layer_mask |= BIT_ULL(i);
 	}
 	/* An access request not handled by the domain is allowed. */
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index ec72b9262bf3..78341a0538de 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -28,7 +28,7 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 {
 	struct landlock_ruleset *new_ruleset;

-	new_ruleset = kzalloc(struct_size(new_ruleset, fs_access_masks,
+	new_ruleset = kzalloc(struct_size(new_ruleset, access_masks,
 				num_layers), GFP_KERNEL_ACCOUNT);
 	if (!new_ruleset)
 		return ERR_PTR(-ENOMEM);
@@ -39,21 +39,21 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	/*
 	 * hierarchy = NULL
 	 * num_rules = 0
-	 * fs_access_masks[] = 0
+	 * access_masks[] = 0
 	 */
 	return new_ruleset;
 }

-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask)
+struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!fs_access_mask)
+	if (!access_mask)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (!IS_ERR(new_ruleset))
-		new_ruleset->fs_access_masks[0] = fs_access_mask;
+		new_ruleset->access_masks[0] = access_mask;
 	return new_ruleset;
 }

@@ -116,7 +116,7 @@ static void build_check_ruleset(void)
 		.num_rules = ~0,
 		.num_layers = ~0,
 	};
-	typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
+	typeof(ruleset.access_masks[0]) fs_access_mask = ~0;

 	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
 	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
@@ -279,7 +279,7 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		err = -EINVAL;
 		goto out_unlock;
 	}
-	dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];

 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
@@ -337,8 +337,8 @@ static int inherit_ruleset(struct landlock_ruleset *const parent,
 		goto out_unlock;
 	}
 	/* Copies the parent layer stack and leaves a space for the new layer. */
-	memcpy(child->fs_access_masks, parent->fs_access_masks,
-			flex_array_size(parent, fs_access_masks, parent->num_layers));
+	memcpy(child->access_masks, parent->access_masks,
+			flex_array_size(parent, access_masks, parent->num_layers));

 	if (WARN_ON_ONCE(!parent->hierarchy)) {
 		err = -EINVAL;
diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 2d3ed7ec5a0a..32d90ce72428 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -97,7 +97,7 @@ struct landlock_ruleset {
 		 * section.  This is only used by
 		 * landlock_put_ruleset_deferred() when @usage reaches zero.
 		 * The fields @lock, @usage, @num_rules, @num_layers and
-		 * @fs_access_masks are then unused.
+		 * @access_masks are then unused.
 		 */
 		struct work_struct work_free;
 		struct {
@@ -124,7 +124,7 @@ struct landlock_ruleset {
 			 */
 			u32 num_layers;
 			/**
-			 * @fs_access_masks: Contains the subset of filesystem
+			 * @access_masks: Contains the subset of filesystem
 			 * actions that are restricted by a ruleset.  A domain
 			 * saves all layers of merged rulesets in a stack
 			 * (FAM), starting from the first layer to the last
@@ -135,12 +135,12 @@ struct landlock_ruleset {
 			 * layers are set once and never changed for the
 			 * lifetime of the ruleset.
 			 */
-			u16 fs_access_masks[];
+			u32 access_masks[];
 		};
 	};
 };

-struct landlock_ruleset *landlock_create_ruleset(const u32 fs_access_mask);
+struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 32396962f04d..f1d86311df7e 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -341,10 +341,10 @@ SYSCALL_DEFINE4(landlock_add_rule,
 	}
 	/*
 	 * Checks that allowed_access matches the @ruleset constraints
-	 * (ruleset->fs_access_masks[0] is automatically upgraded to 64-bits).
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access | ruleset->fs_access_masks[0]) !=
-			ruleset->fs_access_masks[0]) {
+	if ((path_beneath_attr.allowed_access | ruleset->access_masks[0]) !=
+			ruleset->access_masks[0]) {
 		err = -EINVAL;
 		goto out_put_ruleset;
 	}
--
2.25.1

