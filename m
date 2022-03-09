Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847404D303D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiCINqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiCINqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:12 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF5917B88E;
        Wed,  9 Mar 2022 05:45:13 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD2g48CVz67bVT;
        Wed,  9 Mar 2022 21:44:43 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:10 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 02/15] landlock: filesystem access mask helpers
Date:   Wed, 9 Mar 2022 21:44:46 +0800
Message-ID: <20220309134459.6448-3-konstantin.meskhidze@huawei.com>
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

This patch adds filesystem helper functions
to set and get filesystem mask. Also the modification
adds a helper structure landlock_access_mask to
support managing multiple access mask.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Add get_mask, set_mask helpers for filesystem.
* Add new struct landlock_access_mask.

---
 security/landlock/fs.c       |  4 ++--
 security/landlock/ruleset.c  | 20 +++++++++++++++++---
 security/landlock/ruleset.h  | 19 ++++++++++++++++++-
 security/landlock/syscalls.c |  9 ++++++---
 4 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index d727bdab7840..97f5c455f5a7 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -163,7 +163,7 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
 		return -EINVAL;

 	/* Transforms relative access rights to absolute ones. */
-	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~ruleset->access_masks[0];
+	access_rights |= LANDLOCK_MASK_ACCESS_FS & ~landlock_get_fs_access_mask(ruleset, 0);
 	object = get_inode_object(d_backing_inode(path->dentry));
 	if (IS_ERR(object))
 		return PTR_ERR(object);
@@ -252,7 +252,7 @@ static int check_access_path(const struct landlock_ruleset *const domain,
 	/* Saves all layers handling a subset of requested accesses. */
 	layer_mask = 0;
 	for (i = 0; i < domain->num_layers; i++) {
-		if (domain->access_masks[i] & access_request)
+		if (landlock_get_fs_access_mask(domain, i) & access_request)
 			layer_mask |= BIT_ULL(i);
 	}
 	/* An access request not handled by the domain is allowed. */
diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index 78341a0538de..a6212b752549 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -44,16 +44,30 @@ static struct landlock_ruleset *create_ruleset(const u32 num_layers)
 	return new_ruleset;
 }

-struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask)
+/* A helper function to set a filesystem mask */
+void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
+				 const struct landlock_access_mask *access_mask_set,
+				 u16 mask_level)
+{
+	ruleset->access_masks[mask_level] = access_mask_set->fs;
+}
+
+/* A helper function to get a filesystem mask */
+u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level)
+{
+	return ruleset->access_masks[mask_level];
+}
+
+struct landlock_ruleset *landlock_create_ruleset(const struct landlock_access_mask *access_mask_set)
 {
 	struct landlock_ruleset *new_ruleset;

 	/* Informs about useless ruleset. */
-	if (!access_mask)
+	if (!access_mask_set->fs)
 		return ERR_PTR(-ENOMSG);
 	new_ruleset = create_ruleset(1);
 	if (!IS_ERR(new_ruleset))
-		new_ruleset->access_masks[0] = access_mask;
+		landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
 	return new_ruleset;
 }

diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
index 32d90ce72428..bc87e5f787f7 100644
--- a/security/landlock/ruleset.h
+++ b/security/landlock/ruleset.h
@@ -16,6 +16,16 @@

 #include "object.h"

+/**
+ * struct landlock_access_mask - A helper structure to handle different mask types
+ */
+struct landlock_access_mask {
+	/**
+	 * @fs: Filesystem access mask.
+	 */
+	u16 fs;
+};
+
 /**
  * struct landlock_layer - Access rights for a given layer
  */
@@ -140,7 +150,8 @@ struct landlock_ruleset {
 	};
 };

-struct landlock_ruleset *landlock_create_ruleset(const u32 access_mask);
+struct landlock_ruleset *landlock_create_ruleset(const struct landlock_access_mask
+									*access_mask_set);

 void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
 void landlock_put_ruleset_deferred(struct landlock_ruleset *const ruleset);
@@ -162,4 +173,10 @@ static inline void landlock_get_ruleset(struct landlock_ruleset *const ruleset)
 		refcount_inc(&ruleset->usage);
 }

+void landlock_set_fs_access_mask(struct landlock_ruleset *ruleset,
+				 const struct landlock_access_mask *access_mask_set,
+				 u16 mask_level);
+
+u32 landlock_get_fs_access_mask(const struct landlock_ruleset *ruleset, u16 mask_level);
+
 #endif /* _SECURITY_LANDLOCK_RULESET_H */
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index f1d86311df7e..5931b666321d 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -159,6 +159,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 {
 	struct landlock_ruleset_attr ruleset_attr;
 	struct landlock_ruleset *ruleset;
+	struct landlock_access_mask access_mask_set = {.fs = 0};
 	int err, ruleset_fd;

 	/* Build-time checks. */
@@ -185,9 +186,10 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 	if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
 			LANDLOCK_MASK_ACCESS_FS)
 		return -EINVAL;
+	access_mask_set.fs = ruleset_attr.handled_access_fs;

 	/* Checks arguments and transforms to kernel struct. */
-	ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
+	ruleset = landlock_create_ruleset(&access_mask_set);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);

@@ -343,8 +345,9 @@ SYSCALL_DEFINE4(landlock_add_rule,
 	 * Checks that allowed_access matches the @ruleset constraints
 	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
 	 */
-	if ((path_beneath_attr.allowed_access | ruleset->access_masks[0]) !=
-			ruleset->access_masks[0]) {
+
+	if ((path_beneath_attr.allowed_access | landlock_get_fs_access_mask(ruleset, 0)) !=
+						landlock_get_fs_access_mask(ruleset, 0)) {
 		err = -EINVAL;
 		goto out_put_ruleset;
 	}
--
2.25.1

