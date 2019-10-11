Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7EFD3B20
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfJKI3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:29:54 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46154 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfJKI3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:29:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so6379249lfc.13
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sozellMjvmgbNPebVlIzszVANoZi+GDHppQugK+TDS0=;
        b=w14h8XL8KniYZtB0+V0rqauj29r8ZaV0TBz4PR7idtaONMPa7ZxzdVQFO7Qnt26ecQ
         ip1i37tYzmVPKvTAv8ZEsDi/Yv7EHbLzTgAJYsr5rYDMMUxDbeR7yNWHaXMQuAz0NqA8
         mINFuN46SqMx25IJSXiUK+hzGs80CWPs/v8s8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sozellMjvmgbNPebVlIzszVANoZi+GDHppQugK+TDS0=;
        b=Lf9Es2O+kq8q1AOf0ywg272OrMmWCyeqOXJo714Iw89Xr+Eu/md4O1D5mRG3BzcKWI
         S+DqmDsvD2FHs08LB8CBjyHtist2H02edUb36mMxH6TOEoSgjUtO5h4QGdbXUsVNg+r2
         RZ/N2KXzxgLgmWHy5FcVMcVvp0GMJgxx+nJPuCBoEapqC2q4iSKo3XnpKTcubDufUDUw
         0X+ngyFEDxbsTkwhrFNSJlxPRXg4FW9PJUjieGy7wm2wi8y7ToU+1bn/OEJ1HURNNRac
         Avm5uK+DuR88qt37jhTGGz9B4CRRYAxhIBQ13Qot43lgMj4n91Iztb4ezm3zvNT1Jfas
         XcxQ==
X-Gm-Message-State: APjAAAX/hCcE4lHElz0F/UkMn3HsWsP5cl5lLYU/PxCXCDVesf+VTSV4
        Rwt29boskLGPzzuhB8HYkhTj/Q==
X-Google-Smtp-Source: APXvYqxsVHJoauSSXMOadchyC3meldt3EVJfMy2GGyNWVWeb24Rj1c6CBlL/CIV6SXbxxranDDpXvQ==
X-Received: by 2002:a19:f610:: with SMTP id x16mr7508356lfe.139.1570782591718;
        Fri, 11 Oct 2019 01:29:51 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h12sm1733535ljg.24.2019.10.11.01.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 01:29:51 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: Check that flow dissector can be re-attached
Date:   Fri, 11 Oct 2019 10:29:46 +0200
Message-Id: <20191011082946.22695-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011082946.22695-1-jakub@cloudflare.com>
References: <20191011082946.22695-1-jakub@cloudflare.com>
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
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
new file mode 100644
index 000000000000..777faffc4639
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -0,0 +1,127 @@
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

