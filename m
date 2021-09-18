Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F64102CC
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhIRB5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:57:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9891 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbhIRB5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 21:57:22 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HBDM514Ltz8td8;
        Sat, 18 Sep 2021 09:51:29 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 09:55:57 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 09:55:57 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 3/3] bpf/selftests: add test for writable bare tracepoint
Date:   Sat, 18 Sep 2021 10:09:58 +0800
Message-ID: <20210918020958.1167652-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210918020958.1167652-1-houtao1@huawei.com>
References: <20210918020958.1167652-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a writable bare tracepoint in bpf_testmod module, and
trigger its calling when reading /sys/kernel/bpf_testmod
with a specific buffer length. The reading will return
the value in writable context if the early return flag
is enabled in writable context.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 36 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
 5 files changed, 80 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
index 89c6d58e5dd6..11ee801e75e7 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -34,6 +34,21 @@ DECLARE_TRACE(bpf_testmod_test_write_bare,
 	TP_ARGS(task, ctx)
 );
 
+#undef BPF_TESTMOD_DECLARE_TRACE
+#ifdef DECLARE_TRACE_WRITABLE
+#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
+	DECLARE_TRACE_WRITABLE(call, PARAMS(proto), PARAMS(args), size)
+#else
+#define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
+	DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))
+#endif
+
+BPF_TESTMOD_DECLARE_TRACE(bpf_testmod_test_writable_bare,
+	TP_PROTO(struct bpf_testmod_test_writable_ctx *ctx),
+	TP_ARGS(ctx),
+	sizeof(struct bpf_testmod_test_writable_ctx)
+);
+
 #endif /* _BPF_TESTMOD_EVENTS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 50fc5561110a..1cc1d315ccf5 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -42,6 +42,16 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	if (bpf_testmod_loop_test(101) > 100)
 		trace_bpf_testmod_test_read(current, &ctx);
 
+	/* Magic number to enable writable tp */
+	if (len == 64) {
+		struct bpf_testmod_test_writable_ctx writable = {
+			.val = 1024,
+		};
+		trace_bpf_testmod_test_writable_bare(&writable);
+		if (writable.early_ret)
+			return snprintf(buf, len, "%d\n", writable.val);
+	}
+
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
index b3892dc40111..0d71e2607832 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
@@ -17,4 +17,9 @@ struct bpf_testmod_test_write_ctx {
 	size_t len;
 };
 
+struct bpf_testmod_test_writable_ctx {
+	bool early_ret;
+	int val;
+};
+
 #endif /* _BPF_TESTMOD_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index 1797a6e4d6d8..e9c12d8cb457 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -2,10 +2,37 @@
 /* Copyright (c) 2020 Facebook */
 
 #include <test_progs.h>
+#include <stdbool.h>
 #include "test_module_attach.skel.h"
 
 static int duration;
 
+static int trigger_module_test_writable(int *val)
+{
+	int fd, err;
+	char buf[65];
+	ssize_t rd;
+
+	fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
+	err = -errno;
+	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
+		return err;
+
+	rd = read(fd, buf, sizeof(buf) - 1);
+	err = rd < 0 ? -errno : -ENODATA;
+	if (CHECK(rd <= 0, "testmod_file_rd_val", "failed: rd %zd errno %d\n",
+		  rd, errno)) {
+		close(fd);
+		return err;
+	}
+
+	buf[rd] = '\0';
+	*val = strtol(buf, NULL, 0);
+	close(fd);
+
+	return 0;
+}
+
 static int delete_module(const char *name, int flags)
 {
 	return syscall(__NR_delete_module, name, flags);
@@ -19,6 +46,7 @@ void test_module_attach(void)
 	struct test_module_attach__bss *bss;
 	struct bpf_link *link;
 	int err;
+	int writable_val = 0;
 
 	skel = test_module_attach__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
@@ -51,6 +79,14 @@ void test_module_attach(void)
 	ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
 	ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
 
+	bss->raw_tp_writable_bare_early_ret = true;
+	bss->raw_tp_writable_bare_out_val = 0xf1f2f3f4;
+	ASSERT_OK(trigger_module_test_writable(&writable_val),
+		  "trigger_writable");
+	ASSERT_EQ(bss->raw_tp_writable_bare_in_val, 1024, "writable_test");
+	ASSERT_EQ(bss->raw_tp_writable_bare_out_val, writable_val,
+		  "writable_test");
+
 	test_module_attach__detach(skel);
 
 	/* attach fentry/fexit and make sure it get's module reference */
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index bd37ceec5587..c7a97d268ce3 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -27,6 +27,20 @@ int BPF_PROG(handle_raw_tp_bare,
 	return 0;
 }
 
+int raw_tp_writable_bare_in_val = 0;
+int raw_tp_writable_bare_early_ret = 0;
+int raw_tp_writable_bare_out_val = 0;
+
+SEC("raw_tp_writable/bpf_testmod_test_writable_bare")
+int BPF_PROG(handle_raw_tp_writable_bare,
+	     struct bpf_testmod_test_writable_ctx *writable)
+{
+	raw_tp_writable_bare_in_val = writable->val;
+	writable->early_ret = raw_tp_writable_bare_early_ret;
+	writable->val = raw_tp_writable_bare_out_val;
+	return 0;
+}
+
 __u32 tp_btf_read_sz = 0;
 
 SEC("tp_btf/bpf_testmod_test_read")
-- 
2.29.2

