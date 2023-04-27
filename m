Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC436EFF55
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242894AbjD0Cav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242557AbjD0Cat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:30:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1B44208
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:30:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso5652294b3a.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682562648; x=1685154648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogtFxEiScrp6cRdGGCqsrApRdhckxLBPnpR1IoKzkew=;
        b=bA5p0z775AmOrdR5ZLb7QB8Jocp+rEvoXZ3vgtDvsV6J7sepKpQynzsvLir06js/Z4
         Lh4771+ctSLfT7o0ruXzUgyf1d+NpJAmSidEbbyk2DU8JAsEFxMd5h2H5dej55aj+IR8
         K05zV0vLWWaKuQT2IO5/nDHmIiAPs4aKz2twYdImIZXvi9na1Vz2eO/r6n++Ljv30SQj
         r5B6bpbWDGyeJM1MY26Rzmx5vzrfsTkYmr0dvQ94cxYgHw/f6ReviMo8UxCzsqgGjOUN
         B6VAm3rx/CWa26Q4Y9yVifr3IiBJ8/l71Ls8Iiyv0RWHK/IjqNkUMpz6NXXVjFhQJYp+
         Hjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682562648; x=1685154648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogtFxEiScrp6cRdGGCqsrApRdhckxLBPnpR1IoKzkew=;
        b=dfw1qVdvWSqW0TrwIKDTfgto91lPmHjq2JSEGcv+o4eBrxYYli4SMZ1ADj54pv+m8x
         19NcMw6WPJFukohm/G+c5qNOWfMLRCCvVMfsnCnN6BeTYW4DargYAdimcSI4ke/rkAJv
         usgasGE5JO6dc3FA95gOZ3oeuMizqlnNVfi5eWSjliu3tlNmwCkNGpRHzYEc2XBE8Soe
         fu/px+MwAXo5fgD1yYM4i0COKoaQT2aXPj49AE2Bs+v4M3/2LHcxteHIyDouPvXTn635
         US62D1YEPanEz6/LKxp2xya741mci0BLsVPeU061LUnN4FAWH0DcQAGf+wr367wfZc3h
         Q2+A==
X-Gm-Message-State: AAQBX9dBk0vAr7FUZpCGRu6gghWKoRGfkyohi4eC98fu+OUthze+0Qd2
        ZVHTrDOjkuXSerLW5AI5dVs3JA==
X-Google-Smtp-Source: AKy350bV9f47UAvF0xLg01FVlmb66jGMB6i4YP2z1RRhhPuCDgFPCnP7laevSdmx/RYbDJHCWlaQMw==
X-Received: by 2002:a05:6a20:3c9e:b0:f2:abda:412a with SMTP id b30-20020a056a203c9e00b000f2abda412amr24422440pzj.25.1682562647814;
        Wed, 26 Apr 2023 19:30:47 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id m8-20020a654388000000b0051303d3e3c5sm10291852pgp.42.2023.04.26.19.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 19:30:47 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: Add testcase for bpf_task_under_cgroup
Date:   Thu, 27 Apr 2023 10:30:19 +0800
Message-Id: <20230427023019.73576-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230427023019.73576-1-zhoufeng.zf@bytedance.com>
References: <20230427023019.73576-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

test_progs:
Tests new kfunc bpf_task_under_cgroup().

The bpf program saves the pid which call the getpgid syscall within a
given cgroup to the remote_pid, which is convenient for the user-mode
program to verify the test correctness.

The user-mode program creates its own mount namespace, and mounts the
cgroupsv2 hierarchy in there, call the getpgid syscall, then check if
remote_pid and local_pid are equal.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
 .../bpf/prog_tests/task_under_cgroup.c        | 47 +++++++++++++++++++
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |  1 +
 .../bpf/progs/test_task_under_cgroup.c        | 37 +++++++++++++++
 4 files changed, 86 insertions(+)
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
index 000000000000..6d5709a8203d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
@@ -0,0 +1,47 @@
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
+	syscall(SYS_getpgid);
+
+	test_task_under_cgroup__detach(skel);
+
+	ASSERT_EQ(skel->bss->remote_pid, skel->rodata->local_pid,
+		  "test task_under_cgroup");
+
+cleanup:
+	if (foo >= 0)
+		close(foo);
+
+	test_task_under_cgroup__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
index 22914a70db54..001c416b42bc 100644
--- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
+++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
@@ -26,6 +26,7 @@ struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level) __ksym;
 struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
 void bpf_rcu_read_lock(void) __ksym;
 void bpf_rcu_read_unlock(void) __ksym;
+int bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;
 
 static inline struct __cgrps_kfunc_map_value *cgrps_kfunc_map_value_lookup(struct cgroup *cgrp)
 {
diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
new file mode 100644
index 000000000000..8f23a2933fde
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+#include "bpf_misc.h"
+#include "cgrp_kfunc_common.h"
+
+const volatile int local_pid;
+const volatile long cgid;
+int remote_pid;
+
+SEC("fentry/" SYS_PREFIX "sys_getpgid")
+int sys_getpgid(void *ctx)
+{
+	struct cgroup *cgrp;
+
+	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
+
+	cgrp = bpf_cgroup_from_id(cgid);
+	if (!cgrp)
+		return 0;
+
+	if (!bpf_task_under_cgroup(bpf_get_current_task_btf(), cgrp))
+		goto out;
+
+	remote_pid = local_pid;
+
+out:
+	bpf_cgroup_release(cgrp);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

