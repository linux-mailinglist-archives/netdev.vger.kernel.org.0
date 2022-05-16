Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B5352889D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245213AbiEPPVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245199AbiEPPVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:21:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE31E3BA74;
        Mon, 16 May 2022 08:20:55 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22yB6mHvz6H6sk;
        Mon, 16 May 2022 23:20:50 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:20:53 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 05/15] landlock: landlock_add_rule syscall refactoring
Date:   Mon, 16 May 2022 23:20:28 +0800
Message-ID: <20220516152038.39594-6-konstantin.meskhidze@huawei.com>
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

Landlock_add_rule syscall was refactored to support new
rule types in future Landlock versions. Add_rule_path_beneath()
helper was added to support current filesystem rules. It is called
by the switch case.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Refactoring landlock_add_rule syscall.

Changes since v4:
* Refactoring add_rule_path_beneath() and landlock_add_rule() functions
to optimize code usage.
* Refactoring base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
rule type in landlock_add_rule() call.

---
 security/landlock/syscalls.c                 | 105 ++++++++++---------
 tools/testing/selftests/landlock/base_test.c |   4 +-
 2 files changed, 59 insertions(+), 50 deletions(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 1db799d1a50b..412ced6c512f 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -274,67 +274,23 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
 	return err;
 }

-/**
- * sys_landlock_add_rule - Add a new rule to a ruleset
- *
- * @ruleset_fd: File descriptor tied to the ruleset that should be extended
- *		with the new rule.
- * @rule_type: Identify the structure type pointed to by @rule_attr (only
- *             LANDLOCK_RULE_PATH_BENEATH for now).
- * @rule_attr: Pointer to a rule (only of type &struct
- *             landlock_path_beneath_attr for now).
- * @flags: Must be 0.
- *
- * This system call enables to define a new rule and add it to an existing
- * ruleset.
- *
- * Possible returned errors are:
- *
- * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
- * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
- *   &landlock_path_beneath_attr.allowed_access is not a subset of the
- *   ruleset handled accesses);
- * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
- * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
- *   member of @rule_attr is not a file descriptor as expected;
- * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
- *   @rule_attr is not the expected file descriptor type;
- * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
- * - EFAULT: @rule_attr inconsistency.
- */
-SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
-		const enum landlock_rule_type, rule_type,
-		const void __user *const, rule_attr, const __u32, flags)
+static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_attr)
 {
 	struct landlock_path_beneath_attr path_beneath_attr;
 	struct path path;
 	struct landlock_ruleset *ruleset;
 	int res, err;

-	if (!landlock_initialized)
-		return -EOPNOTSUPP;
-
-	/* No flag for now. */
-	if (flags)
-		return -EINVAL;
-
 	/* Gets and checks the ruleset. */
 	ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);

-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH) {
-		err = -EINVAL;
-		goto out_put_ruleset;
-	}
-
 	/* Copies raw user space buffer, only one type for now. */
 	res = copy_from_user(&path_beneath_attr, rule_attr,
-			     sizeof(path_beneath_attr));
-	if (res) {
-		err = -EFAULT;
-		goto out_put_ruleset;
-	}
+				sizeof(path_beneath_attr));
+	if (res)
+		return -EFAULT;

 	/*
 	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
@@ -370,6 +326,59 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
 	return err;
 }

+/**
+ * sys_landlock_add_rule - Add a new rule to a ruleset
+ *
+ * @ruleset_fd: File descriptor tied to the ruleset that should be extended
+ *		with the new rule.
+ * @rule_type: Identify the structure type pointed to by @rule_attr (only
+ *             LANDLOCK_RULE_PATH_BENEATH for now).
+ * @rule_attr: Pointer to a rule (only of type &struct
+ *             landlock_path_beneath_attr for now).
+ * @flags: Must be 0.
+ *
+ * This system call enables to define a new rule and add it to an existing
+ * ruleset.
+ *
+ * Possible returned errors are:
+ *
+ * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
+ * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
+ *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
+ *   accesses);
+ * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
+ * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
+ *   member of @rule_attr is not a file descriptor as expected;
+ * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
+ *   @rule_attr is not the expected file descriptor type (e.g. file open
+ *   without O_PATH);
+ * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
+ * - EFAULT: @rule_attr inconsistency.
+ */
+SYSCALL_DEFINE4(landlock_add_rule,
+		const int, ruleset_fd, const enum landlock_rule_type, rule_type,
+		const void __user *const, rule_attr, const __u32, flags)
+{
+	int err;
+
+	if (!landlock_initialized)
+		return -EOPNOTSUPP;
+
+	/* No flag for now. */
+	if (flags)
+		return -EINVAL;
+
+	switch (rule_type) {
+	case LANDLOCK_RULE_PATH_BENEATH:
+		err = add_rule_path_beneath(ruleset_fd, rule_attr);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
 /* Enforcement */

 /**
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index da9290817866..0c4c3a538d54 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -156,11 +156,11 @@ TEST(add_rule_checks_ordering)
 	ASSERT_LE(0, ruleset_fd);

 	/* Checks invalid flags. */
-	ASSERT_EQ(-1, landlock_add_rule(-1, 0, NULL, 1));
+	ASSERT_EQ(-1, landlock_add_rule(-1, LANDLOCK_RULE_PATH_BENEATH, NULL, 1));
 	ASSERT_EQ(EINVAL, errno);

 	/* Checks invalid ruleset FD. */
-	ASSERT_EQ(-1, landlock_add_rule(-1, 0, NULL, 0));
+	ASSERT_EQ(-1, landlock_add_rule(-1, LANDLOCK_RULE_PATH_BENEATH, NULL, 0));
 	ASSERT_EQ(EBADF, errno);

 	/* Checks invalid rule type. */
--
2.25.1

