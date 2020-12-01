Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B612C960B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgLADsO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 22:48:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7416 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387417AbgLADsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:48:14 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B13hjdi028559
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:47:32 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355agsh1u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:47:32 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 19:47:31 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D216D2ECA628; Mon, 30 Nov 2020 19:47:22 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH v3 bpf-next 5/7] selftests/bpf: add bpf_testmod kernel module for testing
Date:   Mon, 30 Nov 2020 19:47:06 -0800
Message-ID: <20201201034709.2918694-6-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201034709.2918694-1-andrii@kernel.org>
References: <20201201034709.2918694-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 clxscore=1034 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_testmod module, which is conceptually out-of-tree module and provides
ways for selftests/bpf to test various kernel module-related functionality:
raw tracepoint, fentry/fexit/fmod_ret, etc. This module will be auto-loaded by
test_progs test runner and expected by some of selftests to be present and
loaded.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore        |  1 +
 tools/testing/selftests/bpf/Makefile          | 12 +++-
 .../selftests/bpf/bpf_testmod/.gitignore      |  6 ++
 .../selftests/bpf/bpf_testmod/Makefile        | 20 +++++++
 .../bpf/bpf_testmod/bpf_testmod-events.h      | 36 +++++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 51 ++++++++++++++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.h   | 14 +++++
 tools/testing/selftests/bpf/test_progs.c      | 59 +++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      |  1 +
 9 files changed, 197 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 395ae040ce1f..752d8edddc66 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -35,3 +35,4 @@ test_cpp
 /tools
 /runqslower
 /bench
+*.ko
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 894192c319fb..64cbc6608966 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -80,7 +80,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping test_cpp runqslower bench
+	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko
 
 TEST_CUSTOM_PROGS = urandom_read
 
@@ -104,6 +104,7 @@ OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,CLEAN)
 	$(Q)$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
+	$(Q)$(MAKE) -C bpf_testmod clean
 endef
 
 include ../lib.mk
@@ -136,6 +137,11 @@ $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id=sha1
 
+$(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
+	$(call msg,MOD,,$@)
+	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
+	$(Q)cp bpf_testmod/bpf_testmod.ko $@
+
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
@@ -388,7 +394,7 @@ TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 btf_helpers.c	flow_dissector_load.h
-TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
+TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
 		       ima_setup.sh					\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
@@ -460,4 +466,4 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc bpf_testmod.ko)
diff --git a/tools/testing/selftests/bpf/bpf_testmod/.gitignore b/tools/testing/selftests/bpf/bpf_testmod/.gitignore
new file mode 100644
index 000000000000..ded513777281
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod/.gitignore
@@ -0,0 +1,6 @@
+*.mod
+*.mod.c
+*.o
+.ko
+/Module.symvers
+/modules.order
diff --git a/tools/testing/selftests/bpf/bpf_testmod/Makefile b/tools/testing/selftests/bpf/bpf_testmod/Makefile
new file mode 100644
index 000000000000..15cb36c4483a
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod/Makefile
@@ -0,0 +1,20 @@
+BPF_TESTMOD_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
+KDIR ?= $(abspath $(BPF_TESTMOD_DIR)/../../../../..)
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+endif
+
+MODULES = bpf_testmod.ko
+
+obj-m += bpf_testmod.o
+CFLAGS_bpf_testmod.o = -I$(src)
+
+all:
+	+$(Q)make -C $(KDIR) M=$(BPF_TESTMOD_DIR) modules
+
+clean:
+	+$(Q)make -C $(KDIR) M=$(BPF_TESTMOD_DIR) clean
+
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
new file mode 100644
index 000000000000..b83ea448bc79
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bpf_testmod
+
+#if !defined(_BPF_TESTMOD_EVENTS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BPF_TESTMOD_EVENTS_H
+
+#include <linux/tracepoint.h>
+#include "bpf_testmod.h"
+
+TRACE_EVENT(bpf_testmod_test_read,
+	TP_PROTO(struct task_struct *task, struct bpf_testmod_test_read_ctx *ctx),
+	TP_ARGS(task, ctx),
+	TP_STRUCT__entry(
+		__field(pid_t, pid)
+		__array(char, comm, TASK_COMM_LEN)
+		__field(loff_t, off)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->pid = task->pid;
+		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->off = ctx->off;
+		__entry->len = ctx->len;
+	),
+	TP_printk("pid=%d comm=%s off=%llu len=%zu",
+		  __entry->pid, __entry->comm, __entry->off, __entry->len)
+);
+
+#endif /* _BPF_TESTMOD_EVENTS_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE bpf_testmod-events
+#include <trace/define_trace.h>
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
new file mode 100644
index 000000000000..4ff0cf23607d
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <linux/error-injection.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+#include <linux/tracepoint.h>
+#include "bpf_testmod.h"
+
+#define CREATE_TRACE_POINTS
+#include "bpf_testmod-events.h"
+
+static noinline ssize_t
+bpf_testmod_test_read(struct file *file, struct kobject *kobj,
+		      struct bin_attribute *bin_attr,
+		      char *buf, loff_t off, size_t len)
+{
+	struct bpf_testmod_test_read_ctx ctx = {
+		.buf = buf,
+		.off = off,
+		.len = len,
+	};
+
+	trace_bpf_testmod_test_read(current, &ctx);
+
+	return -EIO; /* always fail */
+}
+ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
+
+static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
+	.attr = { .name = "bpf_testmod", .mode = 0444, },
+	.read = bpf_testmod_test_read,
+};
+
+static int bpf_testmod_init(void)
+{
+	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+}
+
+static void bpf_testmod_exit(void)
+{
+	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+}
+
+module_init(bpf_testmod_init);
+module_exit(bpf_testmod_exit);
+
+MODULE_AUTHOR("Andrii Nakryiko");
+MODULE_DESCRIPTION("BPF selftests module");
+MODULE_LICENSE("Dual BSD/GPL");
+
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
new file mode 100644
index 000000000000..b81adfedb4f6
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#ifndef _BPF_TESTMOD_H
+#define _BPF_TESTMOD_H
+
+#include <linux/types.h>
+
+struct bpf_testmod_test_read_ctx {
+	char *buf;
+	loff_t off;
+	size_t len;
+};
+
+#endif /* _BPF_TESTMOD_H */
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 22943b58d752..17587754b7a7 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -360,6 +360,58 @@ int extract_build_id(char *build_id, size_t size)
 	return -1;
 }
 
+static int finit_module(int fd, const char *param_values, int flags)
+{
+	return syscall(__NR_finit_module, fd, param_values, flags);
+}
+
+static int delete_module(const char *name, int flags)
+{
+	return syscall(__NR_delete_module, name, flags);
+}
+
+static void unload_bpf_testmod(void)
+{
+	if (delete_module("bpf_testmod", 0)) {
+		if (errno == ENOENT) {
+			if (env.verbosity > VERBOSE_NONE)
+				fprintf(stdout, "bpf_testmod.ko is already unloaded.\n");
+			return;
+		}
+		fprintf(env.stderr, "Failed to unload bpf_testmod.ko from kernel: %d\n", -errno);
+		exit(1);
+	}
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Successfully unloaded bpf_testmod.ko.\n");
+}
+
+static int load_bpf_testmod(void)
+{
+	int fd;
+
+	/* ensure previous instance of the module is unloaded */
+	unload_bpf_testmod();
+
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Loading bpf_testmod.ko...\n");
+
+	fd = open("bpf_testmod.ko", O_RDONLY);
+	if (fd < 0) {
+		fprintf(env.stderr, "Can't find bpf_testmod.ko kernel module: %d\n", -errno);
+		return -ENOENT;
+	}
+	if (finit_module(fd, "", 0)) {
+		fprintf(env.stderr, "Failed to load bpf_testmod.ko into the kernel: %d\n", -errno);
+		close(fd);
+		return -EINVAL;
+	}
+	close(fd);
+
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Successfully loaded bpf_testmod.ko.\n");
+	return 0;
+}
+
 /* extern declarations for test funcs */
 #define DEFINE_TEST(name) extern void test_##name(void);
 #include <prog_tests/tests.h>
@@ -678,6 +730,11 @@ int main(int argc, char **argv)
 
 	save_netns();
 	stdio_hijack();
+	env.has_testmod = true;
+	if (load_bpf_testmod()) {
+		fprintf(env.stderr, "WARNING! Selftests relying on bpf_testmod.ko will be skipped.\n");
+		env.has_testmod = false;
+	}
 	for (i = 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test = &prog_test_defs[i];
 
@@ -722,6 +779,8 @@ int main(int argc, char **argv)
 		if (test->need_cgroup_cleanup)
 			cleanup_cgroup_environment();
 	}
+	if (env.has_testmod)
+		unload_bpf_testmod();
 	stdio_restore();
 
 	if (env.get_test_cnt) {
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index d6b14853f3bc..115953243f62 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -66,6 +66,7 @@ struct test_env {
 	enum verbosity verbosity;
 
 	bool jit_enabled;
+	bool has_testmod;
 	bool get_test_cnt;
 	bool list_test_names;
 
-- 
2.24.1

