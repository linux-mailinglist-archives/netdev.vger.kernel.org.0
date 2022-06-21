Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01017552CD5
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiFUIXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiFUIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:23:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D00BE27;
        Tue, 21 Jun 2022 01:23:29 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRzxm45TCz67ZvX;
        Tue, 21 Jun 2022 16:21:32 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 10:23:27 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 09:23:26 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v6 06/17] landlock: refactors landlock_add_rule syscall
Date:   Tue, 21 Jun 2022 16:23:02 +0800
Message-ID: <20220621082313.3330667-7-konstantin.meskhidze@huawei.com>
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

Modifies landlock_add_rule syscall to support
new rule types in future Landlock versions.
Adds add_rule_path_beneath() helper to support
current filesystem rules.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v5:
* Refactors syscall landlock_add_rule() and
add_rule_path_beneath() helper to make argument
check ordering consistent and get rid of partial
revertings in following patches.
* Rolls back refactoring base_test.c seltest.
* Formats code with clang-format-14.

Changes since v4:
* Refactors add_rule_path_beneath() and landlock_add_rule() functions
to optimize code usage.
* Refactors base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
rule type in landlock_add_rule() call.

Changes since v3:
* Split commit.
* Refactors landlock_add_rule syscall.

---
 security/landlock/syscalls.c | 99 +++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 47 deletions(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 5836736ce9d7..a209fd7d10c6 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -274,6 +274,47 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
 	return err;
 }

+static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
+				 const void *const rule_attr)
+{
+	struct landlock_path_beneath_attr path_beneath_attr;
+	struct path path;
+	int res, err;
+	u32 mask;
+
+	/* Copies raw user space buffer, only one type for now. */
+	res = copy_from_user(&path_beneath_attr, rule_attr,
+			     sizeof(path_beneath_attr));
+	if (res)
+		return -EFAULT;
+
+	/*
+	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
+	 * are ignored in path walks.
+	 */
+	if (!path_beneath_attr.allowed_access)
+		return -ENOMSG;
+	/*
+	 * Checks that allowed_access matches the @ruleset constraints
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
+	 */
+	mask = landlock_get_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask)
+		return -EINVAL;
+
+	/* Gets and checks the new rule. */
+	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
+	if (err)
+		return err;
+
+	/* Imports the new rule. */
+	err = landlock_append_fs_rule(ruleset, &path,
+				      path_beneath_attr.allowed_access);
+	path_put(&path);
+
+	return err;
+}
+
 /**
  * sys_landlock_add_rule - Add a new rule to a ruleset
  *
@@ -292,13 +333,14 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
  *
  * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
  * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
- *   &landlock_path_beneath_attr.allowed_access is not a subset of the
- *   ruleset handled accesses);
+ *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
+ *   accesses);
  * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
  * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
  *   member of @rule_attr is not a file descriptor as expected;
  * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
- *   @rule_attr is not the expected file descriptor type;
+ *   @rule_attr is not the expected file descriptor type (e.g. file open
+ *   without O_PATH);
  * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
  * - EFAULT: @rule_attr inconsistency.
  */
@@ -306,10 +348,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 		const enum landlock_rule_type, rule_type,
 		const void __user *const, rule_attr, const __u32, flags)
 {
-	struct landlock_path_beneath_attr path_beneath_attr;
-	struct path path;
 	struct landlock_ruleset *ruleset;
-	int res, err;
+	int err;

 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
@@ -323,49 +363,14 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);

-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH) {
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		err = add_rule_path_beneath(ruleset, rule_attr);
+		break;
+	default:
 		err = -EINVAL;
-		goto out_put_ruleset;
-	}
-
-	/* Copies raw user space buffer, only one type for now. */
-	res = copy_from_user(&path_beneath_attr, rule_attr,
-			     sizeof(path_beneath_attr));
-	if (res) {
-		err = -EFAULT;
-		goto out_put_ruleset;
+		break;
 	}
-
-	/*
-	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
-	 * are ignored in path walks.
-	 */
-	if (!path_beneath_attr.allowed_access) {
-		err = -ENOMSG;
-		goto out_put_ruleset;
-	}
-	/*
-	 * Checks that allowed_access matches the @ruleset constraints
-	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
-	 */
-	if ((path_beneath_attr.allowed_access |
-	     landlock_get_fs_access_mask(ruleset, 0)) !=
-	    landlock_get_fs_access_mask(ruleset, 0)) {
-		err = -EINVAL;
-		goto out_put_ruleset;
-	}
-
-	/* Gets and checks the new rule. */
-	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
-	if (err)
-		goto out_put_ruleset;
-
-	/* Imports the new rule. */
-	err = landlock_append_fs_rule(ruleset, &path,
-				      path_beneath_attr.allowed_access);
-	path_put(&path);
-
-out_put_ruleset:
 	landlock_put_ruleset(ruleset);
 	return err;
 }
--
2.25.1

