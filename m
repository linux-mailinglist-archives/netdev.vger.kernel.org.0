Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21C858701B
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiHASCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiHASCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:02:32 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F78E248D5
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:02:23 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id j70so13895850oih.10
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 11:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DFM28j1evovVIesF7892uqGHd1qTcmZDuJXeotitcvA=;
        b=tdpMqQ74ueJhZLF3PIkmfBOR4X5EIhlmdyEmHxx+mu54Z6yJXe905lrBIGf829wdcd
         tYpmmTMjMmz7GxFo+CRUNBPdt4bBxoSbOmputKkrcxGKaZI4C9Uy1WXSZSgUgiWoIa+d
         NX+fsqqialFm/ytOY0K3SyPgKSeuyk+nIGJ5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DFM28j1evovVIesF7892uqGHd1qTcmZDuJXeotitcvA=;
        b=qTahrdIL1FJGQ3NiKmtPjdd+duIz4gD1Y+01WNAaR8Lvtr0hHvUxHl3xUgQVNS/2bS
         aNMG3FZU6oubjOlqxzX0eKJur4QQiDOuLhQq815sQ0GmNy0QyQdVtaZSXrQAfBRaBkd2
         /wbSsMLZSSSD45Muw5R6Sxa5QAwwQQUOxTQJqk4xSLNmpkg5oJAoi24y36VpK21wLFci
         HxH0x/Ib2sqXLX+LqLXN92+/da+YT3IYADhfWUQddTMbu2smUFTdsqS/oCTGz2K444Zr
         zNZnAP2i3LYhS64UAMp2cucb3pCCQNEuZnAVJ6lWYqgrBr8daT/toEx/vJQmWq3BC83K
         pKCQ==
X-Gm-Message-State: AJIora/mKfqDdfoB2r9GYLYPOuSXdy3QXUW2CzCcTb/38qPuJBfg9fIc
        GngsA6akCxDaWXUq6Tg9vl051Q==
X-Google-Smtp-Source: AGRyM1vjtPI/ODQpeiZyl8o+45Ndqv7M6XyWUy/E58LADXIUQntSE06XmvHEQbKpW8EldE0lx9iJCA==
X-Received: by 2002:a05:6808:171c:b0:334:9342:63ef with SMTP id bc28-20020a056808171c00b00334934263efmr6997799oib.63.1659376940639;
        Mon, 01 Aug 2022 11:02:20 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id n14-20020a9d64ce000000b00618fa37308csm2881348otl.35.2022.08.01.11.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 11:02:20 -0700 (PDT)
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
Subject: [PATCH v4 3/4] selftests/bpf: Add tests verifying bpf lsm userns_create hook
Date:   Mon,  1 Aug 2022 13:01:45 -0500
Message-Id: <20220801180146.1157914-4-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220801180146.1157914-1-fred@cloudflare.com>
References: <20220801180146.1157914-1-fred@cloudflare.com>
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

This tests 3 cases:

        1. Unattached bpf program does not block unpriv user namespace
           creation.
        2. Attached bpf program allows user namespace creation given
           CAP_SYS_ADMIN privileges.
        3. Attached bpf program denies user namespace creation for a
           user without CAP_SYS_ADMIN.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>

---
The generic deny_namespace file name is used for future namespace
expansion. I didn't want to limit these files to just the create_user_ns
hook.
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

