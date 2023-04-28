Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B906F123E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 09:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345481AbjD1HSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 03:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjD1HS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 03:18:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A83344AB
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:18:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64115e652eeso10497016b3a.0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682666286; x=1685258286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0BVJHOpXJP2O2nDTKA8p24jt3D3+BhxA0VLRakwV7yc=;
        b=TK4l8iwoo83rRIEhzs+Tk9Ibi88EuLo/u5UJ75l3+iPRCigxhrfpstyqVgZDBekxpR
         8kfPMPMikgTGQqxu5wyv+Gv7tqy93I4MPfUtveCZU1vtfXaK+WCRXYJV8UG0xbvtGJDP
         6qGV3xFWMPCM1B5WFB325Dw2SXNaeLSKVVAg32S7ep+fq2taYlU4PlmtwR4IrgBwNgr2
         m6hlyP9PlWz60HX5nNh6tNKHx0dp3v22K+XB8xd5AwFCpXMKj3yB7WWRylRzkYk+rOs1
         qhMTw/YHzlzLmo/t67R10fbsDK2pWdSVq4uGKbELdaBQQBW+kq8AvScGTgnEeiCZpuiY
         nxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682666286; x=1685258286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BVJHOpXJP2O2nDTKA8p24jt3D3+BhxA0VLRakwV7yc=;
        b=Ty5CdAZwYnFgoKE8zVn140WKf/11tDsuiLiDbJ8SQJest0ZgcZ8C675QLug7zxTP2h
         M0gNc7uaCMuTRRwSc79AzwZyWwxgLCkumSLJ5f4NZWtkfwheB/LyGNe4mJ7skWZF1Bp+
         xcaTYa/kvqyw0OEoQ6nW15UsBi414lCOeStGRAY1X1SNkZ03eYiohTg/gQYo0RjlXT+j
         OINqWuJGFp3B2JqoafdNdw5ERO8SZNgXXvpgQqjbxgpbXA8D2eNxqiXQ086pZ+cx261E
         5964PFhx4e7lAnIuRo1/S4ih+rZbm+R+qvIGUMpimDgUF4QgjbOcVfpv13Pfg302oPa3
         3AzA==
X-Gm-Message-State: AC+VfDwBTpqYYoDdP1Ku/adFqPPN3LigUqDuJMovD4bTix2tGhPQZ4Mw
        r4EjM84UG+j85w/lEHN5g1I0dg==
X-Google-Smtp-Source: ACHHUZ4vXSOjLR384i5gDZpzJ1l8RzqQ9wDu5WvlV4VtpjxyTz7BCc0yRhGjzwLjMf1cG42ZCm45Sg==
X-Received: by 2002:a17:90a:cb81:b0:249:7ad3:e843 with SMTP id a1-20020a17090acb8100b002497ad3e843mr5541110pju.16.1682666285777;
        Fri, 28 Apr 2023 00:18:05 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a318200b0024739d29252sm14159939pjb.15.2023.04.28.00.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 00:18:05 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next v4 2/2] selftests/bpf: Add testcase for bpf_task_under_cgroup
Date:   Fri, 28 Apr 2023 15:17:37 +0800
Message-Id: <20230428071737.43849-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230428071737.43849-1-zhoufeng.zf@bytedance.com>
References: <20230428071737.43849-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

test_progs:
Tests new kfunc bpf_task_under_cgroup().

The bpf program saves the new task's pid within a given cgroup to
the remote_pid, which is convenient for the user-mode program to
verify the test correctness.

The user-mode program creates its own mount namespace, and mounts the
cgroupsv2 hierarchy in there, call the fork syscall, then check if
remote_pid and local_pid are unequal.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
 .../bpf/prog_tests/task_under_cgroup.c        | 55 +++++++++++++++++++
 .../bpf/progs/test_task_under_cgroup.c        | 51 +++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index c7463f3ec3c0..5061d9e24c16 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -26,3 +26,4 @@ user_ringbuf                             # failed to find kernel BTF type ID of
 verif_stats                              # trace_vprintk__open_and_load unexpected error: -9                           (?)
 xdp_bonding                              # failed to auto-attach program 'trace_on_entry': -524                        (trampoline)
 xdp_metadata                             # JIT does not support calling kernel function                                (kfunc)
+test_task_under_cgroup                   # JIT does not support calling kernel function                                (kfunc)
diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
new file mode 100644
index 000000000000..5e79dff86dec
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include <sys/syscall.h>
+#include <test_progs.h>
+#include <cgroup_helpers.h>
+#include "test_task_under_cgroup.skel.h"
+
+#define FOO	"/foo"
+
+void test_task_under_cgroup(void)
+{
+	struct test_task_under_cgroup *skel;
+	int ret, foo = -1;
+	pid_t pid;
+
+	foo = test__join_cgroup(FOO);
+	if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
+		return;
+
+	skel = test_task_under_cgroup__open();
+	if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
+		goto cleanup;
+
+	skel->rodata->local_pid = getpid();
+	skel->bss->remote_pid = getpid();
+	skel->rodata->cgid = get_cgroup_id(FOO);
+
+	ret = test_task_under_cgroup__load(skel);
+	if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
+		goto cleanup;
+
+	ret = test_task_under_cgroup__attach(skel);
+	if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
+		goto cleanup;
+
+	pid = fork();
+	if (pid == 0)
+		exit(0);
+	else if (pid == -1)
+		printf("Couldn't fork process!\n");
+
+	wait(NULL);
+
+	test_task_under_cgroup__detach(skel);
+
+	ASSERT_NEQ(skel->bss->remote_pid, skel->rodata->local_pid,
+		   "test task_under_cgroup");
+
+cleanup:
+	if (foo >= 0)
+		close(foo);
+
+	test_task_under_cgroup__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
new file mode 100644
index 000000000000..5bcb726d6d0a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+#include "bpf_misc.h"
+
+struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
+long bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;
+void bpf_cgroup_release(struct cgroup *p) __ksym;
+struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
+void bpf_task_release(struct task_struct *p) __ksym;
+
+const volatile int local_pid;
+const volatile long cgid;
+int remote_pid;
+
+SEC("tp_btf/task_newtask")
+int BPF_PROG(handle__task_newtask, struct task_struct *task, u64 clone_flags)
+{
+	struct cgroup *cgrp = NULL;
+	struct task_struct *acquired = NULL;
+
+	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
+
+	acquired = bpf_task_acquire(task);
+	if (!acquired)
+		return 0;
+
+	if (local_pid == acquired->tgid)
+		goto out;
+
+	cgrp = bpf_cgroup_from_id(cgid);
+	if (!cgrp)
+		goto out;
+
+	if (bpf_task_under_cgroup(acquired, cgrp))
+		remote_pid = acquired->tgid;
+
+out:
+	if (acquired)
+		bpf_task_release(acquired);
+	if (cgrp)
+		bpf_cgroup_release(cgrp);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

