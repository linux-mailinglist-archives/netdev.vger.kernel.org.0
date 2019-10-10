Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9193ED3018
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfJJSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:18:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44031 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfJJSR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:17:59 -0400
Received: by mail-lf1-f65.google.com with SMTP id u3so5102545lfl.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 11:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nrq6vT8ThDufF9K+7nL9VGNPc9YVjdR7P2owKQ14lDc=;
        b=ZSsu3ZMDge+NQSMNf/iO+b6NBaR8YGme1jtY4y2/SkDlQlnPHAD8tnYpGcEF7b6WNK
         69UKX/SW0Dgov97vyXIeNPto11XLnE1jPGuOZhVo1z34ULNtjvQC2VkwlD7J0ifua6Vm
         o7GY7Lb7vbvrkUcfkxr+wrmCgANXTEiGKZ2yM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nrq6vT8ThDufF9K+7nL9VGNPc9YVjdR7P2owKQ14lDc=;
        b=qAFmwbR6LcN8Gq3rFiEoCYFN0RHI3Wds4hGLsHqK9miit2152Eenl6icU6M2fcJNXG
         66eRpgpGprF/kKZJ85K7mfZ7WK4eKlCLG5Rex0wlHFw4BWzKUrClKRswsVzo4tsgpEE1
         SAPpb3NnT8Rx4KEEaJgX2e0Y6RLFCAm406OoPIqywmxmXYSSGet1aQsC5FOdqv8KW2yI
         cfZULitLix078nmKDkMFdsGTO3s3AuNrJ2zXRl4X0U7ntgBOvjBGtJLSLbK/AUrAgoNE
         +tGYYL/luoRbshq64tTVoTgUM3QikDH+TptuK6DgdBgnxOfnCPWhRAPKV2pstZxjJtB0
         gb8A==
X-Gm-Message-State: APjAAAV7xB01JUmYIV6qfMAV1TH/zaxBx1NXWzZXbbQ6KcDb2gpzenO8
        skUzg6/zbsAzXCmJoJD+Sv/JbJi1HBjcIg==
X-Google-Smtp-Source: APXvYqy4rEitWeumpON4tOgNsGPYfYNanxwQ41r37eaZ7BvBo8EhIm9zIS/eiY1a5a1gSHDZEMiYPw==
X-Received: by 2002:a19:c188:: with SMTP id r130mr6895044lff.41.1570731476764;
        Thu, 10 Oct 2019 11:17:56 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s1sm1446556lfd.14.2019.10.10.11.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 11:17:56 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Check that flow dissector can be re-attached
Date:   Thu, 10 Oct 2019 20:17:50 +0200
Message-Id: <20191010181750.5964-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191010181750.5964-1-jakub@cloudflare.com>
References: <20191010181750.5964-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure a new flow dissector program can be attached to replace the old
one with a single syscall. Also check that attaching the same program twice
is prohibited.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
new file mode 100644
index 000000000000..fa502720825c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -0,1 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test that the flow_dissector program can be updated with a single
+ * syscall by attaching a new program that replaces the existing one.
+ *
+ * Corner case - the same program cannot be attached twice.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <unistd.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+
+#include "test_progs.h"
+
+static bool is_attached(int netns)
+{
+	__u32 cnt;
+	int err;
+
+	err = bpf_prog_query(netns, BPF_FLOW_DISSECTOR, 0, NULL, NULL, &cnt);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_query");
+		return true; /* fail-safe */
+	}
+
+	return cnt > 0;
+}
+
+static int load_prog(void)
+{
+	struct bpf_insn prog[] = {
+		BPF_MOV64_IMM(BPF_REG_0, BPF_OK),
+		BPF_EXIT_INSN(),
+	};
+	int fd;
+
+	fd = bpf_load_program(BPF_PROG_TYPE_FLOW_DISSECTOR, prog,
+			      ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
+	if (CHECK_FAIL(fd < 0))
+		perror("bpf_load_program");
+
+	return fd;
+}
+
+static void do_flow_dissector_reattach(void)
+{
+	int prog_fd[2] = { -1, -1 };
+	int err;
+
+	prog_fd[0] = load_prog();
+	if (prog_fd[0] < 0)
+		return;
+
+	prog_fd[1] = load_prog();
+	if (prog_fd[1] < 0)
+		goto out_close;
+
+	err = bpf_prog_attach(prog_fd[0], 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach-0");
+		goto out_close;
+	}
+
+	/* Expect success when attaching a different program */
+	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach-1");
+		goto out_detach;
+	}
+
+	/* Expect failure when attaching the same program twice */
+	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(!err || errno != EINVAL))
+		perror("bpf_prog_attach-2");
+
+out_detach:
+	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(err))
+		perror("bpf_prog_detach");
+
+out_close:
+	close(prog_fd[1]);
+	close(prog_fd[0]);
+}
+
+void test_flow_dissector_reattach(void)
+{
+	int init_net, err;
+
+	init_net = open("/proc/1/ns/net", O_RDONLY);
+	if (CHECK_FAIL(init_net < 0)) {
+		perror("open(/proc/1/ns/net)");
+		return;
+	}
+
+	err = setns(init_net, CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		perror("setns(/proc/1/ns/net)");
+		goto out_close;
+	}
+
+	if (is_attached(init_net)) {
+		test__skip();
+		printf("Can't test with flow dissector attached to init_net\n");
+		return;
+	}
+
+	/* First run tests in root network namespace */
+	do_flow_dissector_reattach();
+
+	/* Then repeat tests in a non-root namespace */
+	err = unshare(CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		perror("unshare(CLONE_NEWNET)");
+		goto out_close;
+	}
+	do_flow_dissector_reattach();
+
+out_close:
+	close(init_net);
+}
-- 
2.20.1

