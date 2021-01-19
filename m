Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292A02FB8E9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406472AbhASOAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:00:00 -0500
Received: from foss.arm.com ([217.140.110.172]:54712 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390864AbhASMX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 07:23:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF6B611D4;
        Tue, 19 Jan 2021 04:22:50 -0800 (PST)
Received: from e107158-lin.cambridge.arm.com (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A074C3F719;
        Tue, 19 Jan 2021 04:22:49 -0800 (PST)
From:   Qais Yousef <qais.yousef@arm.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v3 bpf-next 2/2] selftests: bpf: Add a new test for bare tracepoints
Date:   Tue, 19 Jan 2021 12:22:37 +0000
Message-Id: <20210119122237.2426878-3-qais.yousef@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119122237.2426878-1-qais.yousef@arm.com>
References: <20210119122237.2426878-1-qais.yousef@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse module_attach infrastructure to add a new bare tracepoint to check
we can attach to it as a raw tracepoint.

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      |  6 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 21 ++++++++++++++-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  6 +++++
 .../selftests/bpf/prog_tests/module_attach.c  | 27 +++++++++++++++++++
 .../selftests/bpf/progs/test_module_attach.c  | 10 +++++++
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
index b83ea448bc79..89c6d58e5dd6 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
 		  __entry->pid, __entry->comm, __entry->off, __entry->len)
 );
 
+/* A bare tracepoint with no event associated with it */
+DECLARE_TRACE(bpf_testmod_test_write_bare,
+	TP_PROTO(struct task_struct *task, struct bpf_testmod_test_write_ctx *ctx),
+	TP_ARGS(task, ctx)
+);
+
 #endif /* _BPF_TESTMOD_EVENTS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 2df19d73ca49..e900adad2276 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -28,9 +28,28 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 EXPORT_SYMBOL(bpf_testmod_test_read);
 ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
 
+noinline ssize_t
+bpf_testmod_test_write(struct file *file, struct kobject *kobj,
+		      struct bin_attribute *bin_attr,
+		      char *buf, loff_t off, size_t len)
+{
+	struct bpf_testmod_test_write_ctx ctx = {
+		.buf = buf,
+		.off = off,
+		.len = len,
+	};
+
+	trace_bpf_testmod_test_write_bare(current, &ctx);
+
+	return -EIO; /* always fail */
+}
+EXPORT_SYMBOL(bpf_testmod_test_write);
+ALLOW_ERROR_INJECTION(bpf_testmod_test_write, ERRNO);
+
 static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
-	.attr = { .name = "bpf_testmod", .mode = 0444, },
+	.attr = { .name = "bpf_testmod", .mode = 0666, },
 	.read = bpf_testmod_test_read,
+	.write = bpf_testmod_test_write,
 };
 
 static int bpf_testmod_init(void)
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
index b81adfedb4f6..b3892dc40111 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
@@ -11,4 +11,10 @@ struct bpf_testmod_test_read_ctx {
 	size_t len;
 };
 
+struct bpf_testmod_test_write_ctx {
+	char *buf;
+	loff_t off;
+	size_t len;
+};
+
 #endif /* _BPF_TESTMOD_H */
diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index 50796b651f72..5bc53d53d86e 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -21,9 +21,34 @@ static int trigger_module_test_read(int read_sz)
 	return 0;
 }
 
+static int trigger_module_test_write(int write_sz)
+{
+	int fd, err;
+	char *buf = malloc(write_sz);
+
+	if (!buf)
+		return -ENOMEM;
+
+	memset(buf, 'a', write_sz);
+	buf[write_sz-1] = '\0';
+
+	fd = open("/sys/kernel/bpf_testmod", O_WRONLY);
+	err = -errno;
+	if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err)) {
+		free(buf);
+		return err;
+	}
+
+	write(fd, buf, write_sz);
+	close(fd);
+	free(buf);
+	return 0;
+}
+
 void test_module_attach(void)
 {
 	const int READ_SZ = 456;
+	const int WRITE_SZ = 457;
 	struct test_module_attach* skel;
 	struct test_module_attach__bss *bss;
 	int err;
@@ -48,8 +73,10 @@ void test_module_attach(void)
 
 	/* trigger tracepoint */
 	ASSERT_OK(trigger_module_test_read(READ_SZ), "trigger_read");
+	ASSERT_OK(trigger_module_test_write(WRITE_SZ), "trigger_write");
 
 	ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
+	ASSERT_EQ(bss->raw_tp_bare_write_sz, WRITE_SZ, "raw_tp_bare");
 	ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
 	ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
 	ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index efd1e287ac17..bd37ceec5587 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -17,6 +17,16 @@ int BPF_PROG(handle_raw_tp,
 	return 0;
 }
 
+__u32 raw_tp_bare_write_sz = 0;
+
+SEC("raw_tp/bpf_testmod_test_write_bare")
+int BPF_PROG(handle_raw_tp_bare,
+	     struct task_struct *task, struct bpf_testmod_test_write_ctx *write_ctx)
+{
+	raw_tp_bare_write_sz = BPF_CORE_READ(write_ctx, len);
+	return 0;
+}
+
 __u32 tp_btf_read_sz = 0;
 
 SEC("tp_btf/bpf_testmod_test_read")
-- 
2.25.1

