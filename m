Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786374D3047
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiCINqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbiCINqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE4D17B8B8;
        Wed,  9 Mar 2022 05:45:18 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1Z3HVNz6H6mm;
        Wed,  9 Mar 2022 21:43:46 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:16 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 06/15] landlock: landlock_add_rule syscall refactoring
Date:   Wed, 9 Mar 2022 21:44:50 +0800
Message-ID: <20220309134459.6448-7-konstantin.meskhidze@huawei.com>
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

Landlock_add_rule syscall was refactored to support new
rule types in future Landlock versions. Add_rule_path_beneath()
helper was added to support current filesystem rules. It is called
by the switch case.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v3:
* Split commit.
* Refactoring landlock_add_rule syscall.

---
 security/landlock/syscalls.c | 95 ++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 5931b666321d..8c0f6165fe3a 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -274,54 +274,13 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
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
- *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
- *   accesses);
- * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
- * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
- *   member of @rule_attr is not a file descriptor as expected;
- * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
- *   @rule_attr is not the expected file descriptor type (e.g. file open
- *   without O_PATH);
- * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
- * - EFAULT: @rule_attr inconsistency.
- */
-SYSCALL_DEFINE4(landlock_add_rule,
-		const int, ruleset_fd, const enum landlock_rule_type, rule_type,
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
-	if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
-		return -EINVAL;
-
 	/* Copies raw user space buffer, only one type for now. */
 	res = copy_from_user(&path_beneath_attr, rule_attr,
 			sizeof(path_beneath_attr));
@@ -367,6 +326,58 @@ SYSCALL_DEFINE4(landlock_add_rule,
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
+	}
+	return err;
+}
+
 /* Enforcement */

 /**
--
2.25.1

