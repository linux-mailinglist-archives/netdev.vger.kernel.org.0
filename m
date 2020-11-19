Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4724D2B9E1D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKSXXI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Nov 2020 18:23:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbgKSXXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:23:07 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNLT5C003432
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:23:05 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wsge3j9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:23:05 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 15:23:04 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9F8FD2EC9B9C; Thu, 19 Nov 2020 15:22:56 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 5/6] selftests/bpf: add bpf_sidecar kernel module for testing
Date:   Thu, 19 Nov 2020 15:22:43 -0800
Message-ID: <20201119232244.2776720-6-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119232244.2776720-1-andrii@kernel.org>
References: <20201119232244.2776720-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 suspectscore=9 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190160
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_sidecar module, which is conceptually out-of-tree module and provides
ways for selftests/bpf to test various kernel module-related functionality:
raw tracepoint, fentry/fexit/fmod_ret, etc. This module will be auto-loaded by
test_progs test runner and expected by some of selftests to be present and
loaded.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore        |  1 +
 tools/testing/selftests/bpf/Makefile          | 12 +++--
 .../selftests/bpf/bpf_sidecar/.gitignore      |  6 +++
 .../selftests/bpf/bpf_sidecar/Makefile        | 20 +++++++
 .../bpf/bpf_sidecar/bpf_sidecar-events.h      | 36 +++++++++++++
 .../selftests/bpf/bpf_sidecar/bpf_sidecar.c   | 51 ++++++++++++++++++
 .../selftests/bpf/bpf_sidecar/bpf_sidecar.h   | 14 +++++
 tools/testing/selftests/bpf/test_progs.c      | 52 +++++++++++++++++++
 8 files changed, 189 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar-events.h
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.c
 create mode 100644 tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.h

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
index 3d5940cd110d..c099f8601604 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -82,7 +82,7 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench
 
-TEST_CUSTOM_PROGS = urandom_read
+TEST_CUSTOM_PROGS = urandom_read bpf_sidecar.ko
 
 # Emit succinct information message describing current building step
 # $1 - generic step name (e.g., CC, LINK, etc);
@@ -104,6 +104,7 @@ OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,CLEAN)
 	$(Q)$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
+	$(Q)$(MAKE) -C bpf_sidecar clean
 endef
 
 include ../lib.mk
@@ -136,6 +137,11 @@ $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id=sha1
 
+$(OUTPUT)/bpf_sidecar.ko: $(wildcard bpf_sidecar/Makefile bpf_sidecar/*.[ch])
+	$(call msg,MOD,,$@)
+	$(Q)$(MAKE) $(submake_extras) -C bpf_sidecar
+	$(Q)cp bpf_sidecar/bpf_sidecar.ko $@
+
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
@@ -388,7 +394,7 @@ TRUNNER_BPF_PROGS_DIR := progs
 TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 btf_helpers.c	flow_dissector_load.h
-TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
+TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_sidecar.ko	\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
@@ -459,4 +465,4 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc bpf_sidecar.ko)
diff --git a/tools/testing/selftests/bpf/bpf_sidecar/.gitignore b/tools/testing/selftests/bpf/bpf_sidecar/.gitignore
new file mode 100644
index 000000000000..ded513777281
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_sidecar/.gitignore
@@ -0,0 +1,6 @@
+*.mod
+*.mod.c
+*.o
+.ko
+/Module.symvers
+/modules.order
diff --git a/tools/testing/selftests/bpf/bpf_sidecar/Makefile b/tools/testing/selftests/bpf/bpf_sidecar/Makefile
new file mode 100644
index 000000000000..41b2339312a1
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_sidecar/Makefile
@@ -0,0 +1,20 @@
+BPF_SIDECAR_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
+KDIR ?= $(abspath $(BPF_SIDECAR_DIR)/../../../../..)
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+endif
+
+MODULES = bpf_sidecar.ko
+
+obj-m += bpf_sidecar.o
+CFLAGS_bpf_sidecar.o = -I$(src)
+
+all:
+	+$(Q)make -C $(KDIR) M=$(BPF_SIDECAR_DIR) modules
+
+clean:
+	+$(Q)make -C $(KDIR) M=$(BPF_SIDECAR_DIR) clean
+
diff --git a/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar-events.h b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar-events.h
new file mode 100644
index 000000000000..433fca06a7b8
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar-events.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bpf_sidecar
+
+#if !defined(_BPF_SIDECAR_EVENTS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _BPF_SIDECAR_EVENTS_H
+
+#include <linux/tracepoint.h>
+#include "bpf_sidecar.h"
+
+TRACE_EVENT(bpf_sidecar_test_read,
+	TP_PROTO(struct task_struct *task, struct bpf_sidecar_test_read_ctx *ctx),
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
+#endif /* _BPF_SIDECAR_EVENTS_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE bpf_sidecar-events
+#include <trace/define_trace.h>
diff --git a/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.c b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.c
new file mode 100644
index 000000000000..46f48c20d99b
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <linux/error-injection.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+#include <linux/tracepoint.h>
+#include "bpf_sidecar.h"
+
+#define CREATE_TRACE_POINTS
+#include "bpf_sidecar-events.h"
+
+static noinline ssize_t
+bpf_sidecar_test_read(struct file *file, struct kobject *kobj,
+		      struct bin_attribute *bin_attr,
+		      char *buf, loff_t off, size_t len)
+{
+	struct bpf_sidecar_test_read_ctx ctx = {
+		.buf = buf,
+		.off = off,
+		.len = len,
+	};
+
+	trace_bpf_sidecar_test_read(current, &ctx);
+
+	return -EIO; /* always fail */
+}
+ALLOW_ERROR_INJECTION(bpf_sidecar_test_read, ERRNO);
+
+static struct bin_attribute bin_attr_bpf_sidecar_file __ro_after_init = {
+	.attr = { .name = "bpf_sidecar", .mode = 0444, },
+	.read = bpf_sidecar_test_read,
+};
+
+static int bpf_sidecar_init(void)
+{
+	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_sidecar_file);
+}
+
+static void bpf_sidecar_exit(void)
+{
+	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_sidecar_file);
+}
+
+module_init(bpf_sidecar_init);
+module_exit(bpf_sidecar_exit);
+
+MODULE_AUTHOR("Andrii Nakryiko");
+MODULE_DESCRIPTION("BPF selftests sidecar module");
+MODULE_LICENSE("Dual BSD/GPL");
+
diff --git a/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.h b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.h
new file mode 100644
index 000000000000..35668d0803ff
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_sidecar/bpf_sidecar.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#ifndef _BPF_SIDECAR_H
+#define _BPF_SIDECAR_H
+
+#include <linux/types.h>
+
+struct bpf_sidecar_test_read_ctx {
+	char *buf;
+	loff_t off;
+	size_t len;
+};
+
+#endif /* _BPF_SIDECAR_H */
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 22943b58d752..544630202247 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -360,6 +360,56 @@ int extract_build_id(char *build_id, size_t size)
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
+void unload_bpf_sidecar_module()
+{
+	if (delete_module("bpf_sidecar", 0)) {
+		if (errno == ENOENT) {
+			if (env.verbosity > VERBOSE_NONE)
+				fprintf(stdout, "bpf_sidecar.ko is already unloaded.\n");
+			return;
+		}
+		fprintf(env.stderr, "Failed to unload bpf_sidecar.ko from kernel: %d\n", -errno);
+		exit(1);
+	}
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Successfully unloaded bpf_sidecar.ko.\n");
+}
+
+void load_bpf_sidecar_module()
+{
+	int fd;
+
+	/* ensure previous instance of the module is unloaded */
+	unload_bpf_sidecar_module();
+
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Loading bpf_sidecar.ko...\n");
+
+	fd = open("bpf_sidecar.ko", O_RDONLY);
+	if (fd < 0) {
+		fprintf(env.stderr, "Can't find bpf_sidecar.ko kernel module: %d\n", -errno);
+		exit(1);
+	}
+	if (finit_module(fd, "", 0)) {
+		fprintf(env.stderr, "Failed to load bpf_sidecar.ko into the kernel: %d\n", -errno);
+		exit(1);
+	}
+	close(fd);
+
+	if (env.verbosity > VERBOSE_NONE)
+		fprintf(stdout, "Successfully loaded bpf_sidecar.ko.\n");
+}
+
 /* extern declarations for test funcs */
 #define DEFINE_TEST(name) extern void test_##name(void);
 #include <prog_tests/tests.h>
@@ -678,6 +728,7 @@ int main(int argc, char **argv)
 
 	save_netns();
 	stdio_hijack();
+	load_bpf_sidecar_module();
 	for (i = 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test = &prog_test_defs[i];
 
@@ -722,6 +773,7 @@ int main(int argc, char **argv)
 		if (test->need_cgroup_cleanup)
 			cleanup_cgroup_environment();
 	}
+	unload_bpf_sidecar_module();
 	stdio_restore();
 
 	if (env.get_test_cnt) {
-- 
2.24.1

