Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C052E66B9B2
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjAPJAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjAPI7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:59:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A273F166D2;
        Mon, 16 Jan 2023 00:58:41 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NwQng3wdJz6H7GS;
        Mon, 16 Jan 2023 16:54:47 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 08:58:39 +0000
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v9 07/12] landlock: Refactor landlock_add_rule() syscall
Date:   Mon, 16 Jan 2023 16:58:13 +0800
Message-ID: <20230116085818.165539-8-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
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

Change the landlock_add_rule() syscall to support new rule types
in future Landlock versions. Add the add_rule_path_beneath() helper
to support current filesystem rules.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v8:
* Refactors commit message.
* Minor fixes.

Changes since v7:
* None

Changes since v6:
* None

Changes since v5:
* Refactors syscall landlock_add_rule() and add_rule_path_beneath() helper
to make argument check ordering consistent and get rid of partial revertings
in following patches.
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
 security/landlock/syscalls.c | 94 +++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 44 deletions(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index d35cd5d304db..73c80cd2cdbe 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -274,6 +274,49 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
 	return err;
 }
 
+static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
+				 const void __user *const rule_attr)
+{
+	struct landlock_path_beneath_attr path_beneath_attr;
+	struct path path;
+	int res, err;
+	access_mask_t mask;
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
+	if (!path_beneath_attr.allowed_access) {
+		return -ENOMSG;
+	}
+	/*
+	 * Checks that allowed_access matches the @ruleset constraints
+	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
+	 */
+	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask) {
+		return -EINVAL;
+	}
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
@@ -306,11 +349,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 		const enum landlock_rule_type, rule_type,
 		const void __user *const, rule_attr, const __u32, flags)
 {
-	struct landlock_path_beneath_attr path_beneath_attr;
-	struct path path;
 	struct landlock_ruleset *ruleset;
-	int res, err;
-	access_mask_t mask;
+	int err;
 
 	if (!landlock_initialized)
 		return -EOPNOTSUPP;
@@ -324,48 +364,14 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
 
-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH) {
-		err = -EINVAL;
-		goto out_put_ruleset;
-	}
-
-	/* Copies raw user space buffer, only one type for now. */
-	res = copy_from_user(&path_beneath_attr, rule_attr,
-			     sizeof(path_beneath_attr));
-	if (res) {
-		err = -EFAULT;
-		goto out_put_ruleset;
-	}
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
-	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
-	if ((path_beneath_attr.allowed_access | mask) != mask) {
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		err = add_rule_path_beneath(ruleset, rule_attr);
+		break;
+	default:
 		err = -EINVAL;
-		goto out_put_ruleset;
+		break;
 	}
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

