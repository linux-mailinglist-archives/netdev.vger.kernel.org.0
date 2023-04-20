Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF66E8B66
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbjDTH1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbjDTH1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:27:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154314EE8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:27:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a66b9bd893so7586985ad.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681975646; x=1684567646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY6KaCFZ5vdzzIXTUyV6D8NEGya8RvpCjdxKUFkIlbo=;
        b=JdpK091tQZhcpVQCrGmT53jyzk0tdpPMrMjsOt2nhOO6VvJm4CHj6b3MGcEtFPjrmj
         jRNPw5HUcEZWIJGHvsLxe344JI6DV18Gtby29KPcbI49o3qCSmqB71Eg+4RPCbqs4iPm
         v3YHKLR5mv2ycE2z5Uzvthf87ASaR/OaOaKaMkZbPpGN/o1brGSdxKSc6IochSv6/AbZ
         gDpcAdKFTBC8fGCg660IDSJI/tyA2ywbL5RjXTgpq/uufdxPrCODT/WuDOdKNukitBLv
         z7znofi2TQ82y2kjpWhFiI7HRNVKU1n6s9umJI6PADeGkDWPZdOKeULaonHTZo5nIUD8
         LGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681975646; x=1684567646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KY6KaCFZ5vdzzIXTUyV6D8NEGya8RvpCjdxKUFkIlbo=;
        b=hYouP92PUuorJB1hNExGTePBdl3z3JsOhTUa/srrlltHATYRyVe1Lh2YYDXsk8Y6eQ
         Gf6jJD6LDQnOIN6M7z+bxTQLCPOKrf5QVYpdsEn/YbjVmw7sDso5z8iITgcGuuSq6gFc
         7g6CMtTE9zYzdg07rqi8OEHF0SIIgsnB1AQZGyRXSXyEE1ELnrtBn0806KdTb31R0WzD
         GwArBZKTYL1DR2Q2pQIBnpzszYivb3ft4zB8DbPq8eDXY0Fdxl2GvR4uC8Wbd1tVhKUP
         /kj4F/+jPTsdpesIZ6TbHypGxJb8IzMnKCkDl2jJ6fSGktaH49F9pt6nW6NDAKI0fSxd
         HhHg==
X-Gm-Message-State: AAQBX9cRmEkEjfHZnoQD04ebxdoesDlhrR6bngJFT4XVPV8qWbHWd4Wh
        msVETfytmP8Frz18aEqNa+xmwQ==
X-Google-Smtp-Source: AKy350Zh/YeQnWj7L0LszMWL1n63Iez1x6ZInscmr5n73w2GM1PRAMnrQpIboMm8xj558lZf9TY4Gg==
X-Received: by 2002:a17:90a:d381:b0:249:7958:ea36 with SMTP id q1-20020a17090ad38100b002497958ea36mr847077pju.19.1681975646451;
        Thu, 20 Apr 2023 00:27:26 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id y18-20020a17090ad71200b0023440af7aafsm612160pju.9.2023.04.20.00.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:27:26 -0700 (PDT)
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
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add testcase for bpf_task_under_cgroup
Date:   Thu, 20 Apr 2023 15:26:57 +0800
Message-Id: <20230420072657.80324-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230420072657.80324-1-zhoufeng.zf@bytedance.com>
References: <20230420072657.80324-1-zhoufeng.zf@bytedance.com>
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
Tests new ebpf helpers bpf_task_under_cgroup.

The bpf program saves the pid which call the getuid syscall within a
given cgroup to a map to the remote_pid, which is convenient for the
user-mode program to verify the test correctness.

The user-mode program creates its own mount namespace, and mounts the
cgroupsv2 hierarchy in there, call the getuid syscall, then check if
remote_pid and local_pid are equal.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 .../bpf/prog_tests/task_under_cgroup.c        | 49 +++++++++++++++++++
 .../bpf/progs/test_task_under_cgroup.c        | 31 ++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
new file mode 100644
index 000000000000..4dd704b11a95
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include <test_progs.h>
+#include "test_task_under_cgroup.skel.h"
+
+#define FOO	"/foo"
+
+void test_task_under_cgroup(void)
+{
+	struct test_task_under_cgroup *skel;
+	int ret, foo = -1, idx = 0;
+
+	skel = test_task_under_cgroup__open();
+	if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
+		return;
+
+	skel->rodata->local_pid = getpid();
+
+	ret = test_task_under_cgroup__load(skel);
+	if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
+		goto cleanup;
+
+	ret = test_task_under_cgroup__attach(skel);
+	if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
+		goto cleanup;
+
+	foo = test__join_cgroup(FOO);
+	if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
+		goto cleanup;
+
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.cgroup_map), &idx,
+				  &foo, BPF_ANY);
+	if (!ASSERT_OK(ret < 0, "cgroup_map update"))
+		goto cleanup;
+
+	syscall(__NR_getuid);
+
+	test_task_under_cgroup__detach(skel);
+
+	ASSERT_EQ(skel->bss->remote_pid, skel->rodata->local_pid,
+		  "test task_under_cgroup");
+
+cleanup:
+	if (foo)
+		close(foo);
+
+	test_task_under_cgroup__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
new file mode 100644
index 000000000000..0f3d53f636de
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Bytedance */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+const volatile int local_pid;
+int remote_pid;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} cgroup_map SEC(".maps");
+
+SEC("tp/syscalls/sys_enter_getuid")
+int sysenter_getuid(const void *ctx)
+{
+	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
+
+	if (!bpf_task_under_cgroup(&cgroup_map, bpf_get_current_task_btf(), 0))
+		return 0;
+
+	remote_pid = local_pid;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.20.1

