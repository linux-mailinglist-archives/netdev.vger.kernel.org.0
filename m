Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D80940DB89
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbhIPNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:42:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9887 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbhIPNmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:42:35 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H9J5l40fZz4whn;
        Thu, 16 Sep 2021 21:36:43 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 16 Sep 2021 21:41:11 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 16 Sep
 2021 21:41:10 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH 3/3] bpf/selftests: add test for writable bare tracepoint
Date:   Thu, 16 Sep 2021 21:55:11 +0800
Message-ID: <20210916135511.3787194-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210916135511.3787194-1-houtao1@huawei.com>
References: <20210916135511.3787194-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a writable bare tracepoint in bpf_testmod module, and
trigger its calling when reading /sys/kernel/bpf_testmod
with a specific buffer length.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 +++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
 .../selftests/bpf/prog_tests/module_attach.c  | 40 ++++++++++++++++++-
 .../selftests/bpf/progs/test_module_attach.c  | 14 +++++++
 5 files changed, 82 insertions(+), 2 deletions(-)

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
index 141d8da687d2..3d3fb16eaf8c 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -26,6 +26,16 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 
 	trace_bpf_testmod_test_read(current, &ctx);
 
+	/* Magic number to enable writable tp */
+	if (len == 1024) {
+		struct bpf_testmod_test_writable_ctx writable = {
+			.val = 1024,
+		};
+		trace_bpf_testmod_test_writable_bare(&writable);
+		if (writable.ret)
+			return snprintf(buf, len, "%d\n", writable.val);
+	}
+
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
index b3892dc40111..553d94214aa6 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
@@ -17,4 +17,9 @@ struct bpf_testmod_test_write_ctx {
 	size_t len;
 };
 
+struct bpf_testmod_test_writable_ctx {
+	bool ret;
+	int val;
+};
+
 #endif /* _BPF_TESTMOD_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index d85a69b7ce44..5565bcab1531 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -6,11 +6,39 @@
 
 static int duration;
 
+#define BPF_TESTMOD_PATH "/sys/kernel/bpf_testmod"
+
+static int trigger_module_test_writable(int *val)
+{
+	int fd, err;
+	char buf[1025];
+	ssize_t rd;
+
+	fd = open(BPF_TESTMOD_PATH, O_RDONLY);
+	err = -errno;
+	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
+		return err;
+
+	rd = read(fd, buf, sizeof(buf) - 1);
+	err = rd < 0 ? -errno : -EIO;
+	if (CHECK(rd <= 0, "testmod_file_read", "failed: %d\n", err)) {
+		close(fd);
+		return err;
+	}
+	buf[rd] = '\0';
+
+	*val = strtol(buf, NULL, 0);
+
+	close(fd);
+
+	return 0;
+}
+
 static int trigger_module_test_read(int read_sz)
 {
 	int fd, err;
 
-	fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
+	fd = open(BPF_TESTMOD_PATH, O_RDONLY);
 	err = -errno;
 	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
 		return err;
@@ -32,7 +60,7 @@ static int trigger_module_test_write(int write_sz)
 	memset(buf, 'a', write_sz);
 	buf[write_sz-1] = '\0';
 
-	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
+	fd = open(BPF_TESTMOD_PATH, O_WRONLY);
 	err = -errno;
 	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err)) {
 		free(buf);
@@ -58,6 +86,7 @@ void test_module_attach(void)
 	struct test_module_attach__bss *bss;
 	struct bpf_link *link;
 	int err;
+	int writable_val;
 
 	skel = test_module_attach__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
@@ -90,6 +119,13 @@ void test_module_attach(void)
 	ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
 	ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
 
+	bss->raw_tp_writable_bare_ret = 1;
+	bss->raw_tp_writable_bare_val = 511;
+	writable_val = 0;
+	ASSERT_OK(trigger_module_test_writable(&writable_val), "trigger_writable");
+	ASSERT_EQ(bss->raw_tp_writable_bare_in_val, 1024, "writable_test");
+	ASSERT_EQ(bss->raw_tp_writable_bare_val, writable_val, "writable_test");
+
 	test_module_attach__detach(skel);
 
 	/* attach fentry/fexit and make sure it get's module reference */
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index bd37ceec5587..4f5c780fcd21 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -27,6 +27,20 @@ int BPF_PROG(handle_raw_tp_bare,
 	return 0;
 }
 
+int raw_tp_writable_bare_in_val = 0;
+int raw_tp_writable_bare_ret = 0;
+int raw_tp_writable_bare_val = 0;
+
+SEC("raw_tp_writable/bpf_testmod_test_writable_bare")
+int BPF_PROG(handle_raw_tp_writable_bare,
+	     struct bpf_testmod_test_writable_ctx *writable)
+{
+	raw_tp_writable_bare_in_val = writable->val;
+	writable->ret = raw_tp_writable_bare_ret;
+	writable->val = raw_tp_writable_bare_val;
+	return 0;
+}
+
 __u32 tp_btf_read_sz = 0;
 
 SEC("tp_btf/bpf_testmod_test_read")
-- 
2.29.2

