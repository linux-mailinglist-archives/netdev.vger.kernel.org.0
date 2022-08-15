Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D75932FA
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiHOQVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiHOQUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:20:44 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB45B1DA70
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:40 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10ee900cce0so8669456fac.5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=nNZ0u0nBC2KeSEEdxzbAi0SK8J2Us1DLDDPRqND6hEc=;
        b=wiyRKMkRQYcjM+XE8VvKwvEwd5ICt1r9/rWYFwD6PoeyS6/CWGyYYqvm1hLPRa7KQo
         CedPLMamRHO3+nPkfBlXB3yE/NlnkeHoDwvX3nbTX9AbdDhSbNYbd1jXw8xURlwSDBoM
         cPfEiQsKYdXRWHhZ7duUb1aXWIAUigxsUdrKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=nNZ0u0nBC2KeSEEdxzbAi0SK8J2Us1DLDDPRqND6hEc=;
        b=Ka/yqyxnMhXhR8zTLebIxu/jWM9KsAVxxkPOdqOPnTvgsZJHj9tmpyVkLk2JiJLWdR
         m7DgPQoNkEKZ3uQ5Ocoff3zsCAdqeDyaqxDbAHFFNeXFUUj2oJauNZMiBevREssEGnMr
         kojeNPcKGt6JcXrRWSGyA2pM0LiNMRjH6Hu1rWJCOcvTi1XxkAvFYqfzkl+9lwOl+Rov
         tU34gehxaRAfQhlhZTzBx9I4AsJGtsgU2L6vWLwMP90KyLDvuOtrh7NUsZbyhABpnQtt
         V27k7oepuKSnOmSfKjvK0TFj4XIQIUQXqudFM73X7H2T8dqEQ3B5Bo0b05qwr0CQpe2r
         heVw==
X-Gm-Message-State: ACgBeo02YTnNa+vgoGORcF+I+R2lWLLCSH09xuy2RDisk5EbwgiSkQ+7
        COt7Sd09MbwCuN1sd3CxPAzhRA==
X-Google-Smtp-Source: AA6agR5z0VLGcfMA+TlVlAJ5FuhbsicrvataQG5IVwelNQavaXDKjyccdLVSkfGXOab7dIekf8LuQQ==
X-Received: by 2002:a05:6870:7099:b0:116:ccda:ac1c with SMTP id v25-20020a056870709900b00116ccdaac1cmr7048070oae.153.1660580440363;
        Mon, 15 Aug 2022 09:20:40 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id x91-20020a9d37e4000000b00636ee04e7aesm2163371otb.67.2022.08.15.09.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 09:20:40 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com,
        Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH v5 3/4] selftests/bpf: Add tests verifying bpf lsm userns_create hook
Date:   Mon, 15 Aug 2022 11:20:27 -0500
Message-Id: <20220815162028.926858-4-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815162028.926858-1-fred@cloudflare.com>
References: <20220815162028.926858-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LSM hook userns_create was introduced to provide LSM's an
opportunity to block or allow unprivileged user namespace creation. This
test serves two purposes: it provides a test eBPF implementation, and
tests the hook successfully blocks or allows user namespace creation.

This tests 3 cases:

        1. Unattached bpf program does not block unpriv user namespace
           creation.
        2. Attached bpf program allows user namespace creation given
           CAP_SYS_ADMIN privileges.
        3. Attached bpf program denies user namespace creation for a
           user without CAP_SYS_ADMIN.

Acked-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Frederick Lawler <fred@cloudflare.com>

---
The generic deny_namespace file name is used for future namespace
expansion. I didn't want to limit these files to just the create_user_ns
hook.
Changes since v4:
- None
Changes since v3:
- Explicitly set CAP_SYS_ADMIN to test namespace is created given
  permission
- Simplify BPF test to use sleepable hook only
- Prefer unshare() over clone() for tests
Changes since v2:
- Rename create_user_ns hook to userns_create
Changes since v1:
- Introduce this patch
---
 .../selftests/bpf/prog_tests/deny_namespace.c | 102 ++++++++++++++++++
 .../selftests/bpf/progs/test_deny_namespace.c |  33 ++++++
 2 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c

diff --git a/tools/testing/selftests/bpf/prog_tests/deny_namespace.c b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
new file mode 100644
index 000000000000..1bc6241b755b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_deny_namespace.skel.h"
+#include <sched.h>
+#include "cap_helpers.h"
+#include <stdio.h>
+
+static int wait_for_pid(pid_t pid)
+{
+	int status, ret;
+
+again:
+	ret = waitpid(pid, &status, 0);
+	if (ret == -1) {
+		if (errno == EINTR)
+			goto again;
+
+		return -1;
+	}
+
+	if (!WIFEXITED(status))
+		return -1;
+
+	return WEXITSTATUS(status);
+}
+
+/* negative return value -> some internal error
+ * positive return value -> userns creation failed
+ * 0                     -> userns creation succeeded
+ */
+static int create_user_ns(void)
+{
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (pid == 0) {
+		if (unshare(CLONE_NEWUSER))
+			_exit(EXIT_FAILURE);
+		_exit(EXIT_SUCCESS);
+	}
+
+	return wait_for_pid(pid);
+}
+
+static void test_userns_create_bpf(void)
+{
+	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
+	__u64 old_caps = 0;
+
+	cap_enable_effective(cap_mask, &old_caps);
+
+	ASSERT_OK(create_user_ns(), "priv new user ns");
+
+	cap_disable_effective(cap_mask, &old_caps);
+
+	ASSERT_EQ(create_user_ns(), EPERM, "unpriv new user ns");
+
+	if (cap_mask & old_caps)
+		cap_enable_effective(cap_mask, NULL);
+}
+
+static void test_unpriv_userns_create_no_bpf(void)
+{
+	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
+	__u64 old_caps = 0;
+
+	cap_disable_effective(cap_mask, &old_caps);
+
+	ASSERT_OK(create_user_ns(), "no-bpf unpriv new user ns");
+
+	if (cap_mask & old_caps)
+		cap_enable_effective(cap_mask, NULL);
+}
+
+void test_deny_namespace(void)
+{
+	struct test_deny_namespace *skel = NULL;
+	int err;
+
+	if (test__start_subtest("unpriv_userns_create_no_bpf"))
+		test_unpriv_userns_create_no_bpf();
+
+	skel = test_deny_namespace__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel load"))
+		goto close_prog;
+
+	err = test_deny_namespace__attach(skel);
+	if (!ASSERT_OK(err, "attach"))
+		goto close_prog;
+
+	if (test__start_subtest("userns_create_bpf"))
+		test_userns_create_bpf();
+
+	test_deny_namespace__detach(skel);
+
+close_prog:
+	test_deny_namespace__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_deny_namespace.c b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
new file mode 100644
index 000000000000..09ad5a4ebd1f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+#include <linux/capability.h>
+
+struct kernel_cap_struct {
+	__u32 cap[_LINUX_CAPABILITY_U32S_3];
+} __attribute__((preserve_access_index));
+
+struct cred {
+	struct kernel_cap_struct cap_effective;
+} __attribute__((preserve_access_index));
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm.s/userns_create")
+int BPF_PROG(test_userns_create, const struct cred *cred, int ret)
+{
+	struct kernel_cap_struct caps = cred->cap_effective;
+	int cap_index = CAP_TO_INDEX(CAP_SYS_ADMIN);
+	__u32 cap_mask = CAP_TO_MASK(CAP_SYS_ADMIN);
+
+	if (ret)
+		return 0;
+
+	ret = -EPERM;
+	if (caps.cap[cap_index] & cap_mask)
+		return 0;
+
+	return -EPERM;
+}
-- 
2.30.2

