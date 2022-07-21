Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3C57D28F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiGUR2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiGUR2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:28:38 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A9A8AB0D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:28:20 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-10d9137bd2eso3316923fac.3
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DDUrciOiWPS12pMfDzHR0QWKvrVADVqrg238UND6/6k=;
        b=PVCt8IkXNmzVX/uc6ya8bkYX0e9fl24bayGiIk1x14nKbBagTPU3Ptt2JJXdPMlO85
         12cNDzBYSZCw8OtBNQqKKCEU4r2rcBnVENIXy4RF9NnywMQX5OvKHOols3UKsNfMscdm
         CaxupZgwvLbU5eQrXzoQ+7vBNCWXwhKr3KSVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DDUrciOiWPS12pMfDzHR0QWKvrVADVqrg238UND6/6k=;
        b=QGO4izDaGsuh08APjmAyJp802+0MV5+QSbu69nZ8vA9T5eBNKNCg3ofLgxkgUMQ0vY
         TVy33NH6yB62DZpzPTU0xcYuxZbMetdAyt2PJvRZ5igBAwMDuYvgEMxKTLzYwoZ1QhEA
         dNZh/H6HWaEAYovAn0D1CFF1JJyis/XeS4d93dWfJ4Ey1DRsjmjBEMb5y6gOzzyZYvkD
         JC3NceD2aktB23ESv4owwu3sxTGNJK5nSjr5DnOYxjsP+FMU6SoEXrnuo/maMoClcJFJ
         Se8P53FL4cmQdSDUOP5ocT8e8tp13YBDN4YpR+zrHUYn66JrxfTlLnCyFRLVklrsHt0r
         D0BA==
X-Gm-Message-State: AJIora+FKMeFcWfegVc+gx2O1slNYfcIj8CO1S03L/kA0AKTJDy7sw6v
        G8uzHZ+gWLLazyODkrfo2oJzaQ==
X-Google-Smtp-Source: AGRyM1vxESDsPtIrONW7Ys2w4N7FenuuR8XS0fA2zPxLvr9jts48tPFbchJ6aya0gahguJLwVoCt9Q==
X-Received: by 2002:a05:6870:c889:b0:10c:7f1:c6b8 with SMTP id er9-20020a056870c88900b0010c07f1c6b8mr5644044oab.280.1658424500003;
        Thu, 21 Jul 2022 10:28:20 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id du24-20020a0568703a1800b00101c83352c6sm1106207oab.34.2022.07.21.10.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 10:28:19 -0700 (PDT)
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
        karl@bigbadwolfsecurity.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH v3 3/4] selftests/bpf: Add tests verifying bpf lsm userns_create hook
Date:   Thu, 21 Jul 2022 12:28:07 -0500
Message-Id: <20220721172808.585539-4-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220721172808.585539-1-fred@cloudflare.com>
References: <20220721172808.585539-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LSM hook userns_create was introduced to provide LSM's an
opportunity to block or allow unprivileged user namespace creation. This
test serves two purposes: it provides a test eBPF implementation, and
tests the hook successfully blocks or allows user namespace creation.

This tests 4 cases:

        1. Unattached bpf program does not block unpriv user namespace
           creation.
        2. Attached bpf program allows user namespace creation given
           CAP_SYS_ADMIN privileges.
        3. Attached bpf program denies user namespace creation for a
           user without CAP_SYS_ADMIN.
        4. The sleepable implementation loads

Signed-off-by: Frederick Lawler <fred@cloudflare.com>

---
The generic deny_namespace file name is used for future namespace
expansion. I didn't want to limit these files to just the create_user_ns
hook.
Changes since v2:
- Rename create_user_ns hook to userns_create
Changes since v1:
- Introduce this patch
---
 .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
 .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
 2 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c

diff --git a/tools/testing/selftests/bpf/prog_tests/deny_namespace.c b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
new file mode 100644
index 000000000000..9e4714295008
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include "test_deny_namespace.skel.h"
+#include <sched.h>
+#include "cap_helpers.h"
+
+#define STACK_SIZE (1024 * 1024)
+static char child_stack[STACK_SIZE];
+
+int clone_callback(void *arg)
+{
+	return 0;
+}
+
+static int create_new_user_ns(void)
+{
+	int status;
+	pid_t cpid;
+
+	cpid = clone(clone_callback, child_stack + STACK_SIZE,
+		     CLONE_NEWUSER | SIGCHLD, NULL);
+
+	if (cpid == -1)
+		return errno;
+
+	if (cpid == 0)
+		return 0;
+
+	waitpid(cpid, &status, 0);
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+
+	return -1;
+}
+
+static void test_userns_create_bpf(void)
+{
+	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
+	__u64 old_caps = 0;
+
+	ASSERT_OK(create_new_user_ns(), "priv new user ns");
+
+	cap_disable_effective(cap_mask, &old_caps);
+
+	ASSERT_EQ(create_new_user_ns(), EPERM, "unpriv new user ns");
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
+	ASSERT_OK(create_new_user_ns(), "no-bpf unpriv new user ns");
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
index 000000000000..9ec9dabc8372
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
@@ -0,0 +1,39 @@
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
+SEC("lsm/userns_create")
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
+
+SEC("lsm.s/userns_create")
+int BPF_PROG(test_sleepable_userns_create, const struct cred *cred, int ret)
+{
+	return 0;
+}
-- 
2.30.2

