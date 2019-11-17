Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D6FF830
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfKQHI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbfKQHI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:27 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH787bt032275
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=IcatGvRSFQ0Db8PR3m70ZRWD79Xvdw2xGUQSX0WwBTE=;
 b=cTIGbkNnncwBvW6GDOoDmLLV0niF+AVwSZx7zF4Xd4CE+NoQ+I6lat0jZCZZZvwE1AnA
 tcCZsyOg87hoSAx7AFCAtgRrzrXD64pkFj4500SFuzNbUjgnqmd3KuHcBEljfvMXcRXq
 teOZmElfeNfULnVoGpTENOk2njGKPWi1o+U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2waf3k8m8n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:26 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 16 Nov 2019 23:08:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DA1122EC19AE; Sat, 16 Nov 2019 23:08:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/6] selftests/bpf: add tests for libbpf-provided externs
Date:   Sat, 16 Nov 2019 23:08:07 -0800
Message-ID: <20191117070807.251360-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=8
 spamscore=0 malwarescore=0 phishscore=0 priorityscore=1501 mlxlogscore=710
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a set of tests validating libbpf-provided extern variables. One crucial
feature that's tested is dead code elimination together with using invalid BPF
helper. CONFIG_MISSING is not supposed to exist and should always be specified
by libbpf as zero, which allows BPF verifier to correctly do branch pruning
and not fail validation, when invalid BPF helper is called from dead if branch.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_extern.c    | 186 ++++++++++++++++++
 .../selftests/bpf/progs/test_core_extern.c    |  43 ++++
 2 files changed, 229 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_extern.c b/tools/testing/selftests/bpf/prog_tests/core_extern.c
new file mode 100644
index 000000000000..2a87a5f1de4d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_extern.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/utsname.h>
+#include <linux/version.h>
+
+static size_t roundup_page(size_t sz)
+{
+	long page_size = sysconf(_SC_PAGE_SIZE);
+	return (sz + page_size - 1) / page_size * page_size;
+}
+
+static uint32_t get_kernel_version(void)
+{
+	uint32_t major, minor, patch;
+	struct utsname info;
+
+	uname(&info);
+	if (sscanf(info.release, "%u.%u.%u", &major, &minor, &patch) != 3)
+		return 0;
+	return KERNEL_VERSION(major, minor, patch);
+}
+
+struct data {
+	uint64_t kern_ver;
+	uint64_t tristate_val;
+	uint64_t bool_val;
+	uint64_t int_val;
+	uint64_t missing_val;
+};
+
+static struct test_case {
+	const char *name;
+	const char *cfg;
+	const char *cfg_path;
+	bool fails;
+	struct data data;
+} test_cases[] = {
+	{ .name = "default search path", .cfg_path = NULL },
+	{ .name = "/proc/config.gz", .cfg_path = "/proc/config.gz" },
+	{ .name = "missing config", .fails = true,
+	  .cfg_path = "/proc/invalid-config.gz" },
+	{
+		.name = "custom values",
+		.cfg = "CONFIG_TRISTATE=m\n"
+		       "CONFIG_BOOL=y\n"
+		       "CONFIG_INT=123456\n",
+		.data = {
+			.tristate_val = 2,
+			.bool_val = 1,
+			.int_val = 123456,
+		},
+	},
+	{
+		/* there is no real typing, so any valid value is accepted */
+		.name = "mixed up types",
+		.cfg = "CONFIG_TRISTATE=123\n"
+		       "CONFIG_BOOL=m\n"
+		       "CONFIG_INT=y\n",
+		.data = {
+			.tristate_val = 123,
+			.bool_val = 2,
+			.int_val = 1,
+		},
+	},
+	{
+		/* somewhat weird behavior of strtoull */
+		.name = "negative int",
+		.cfg = "CONFIG_INT=-12\n",
+		.data = { .int_val = (uint64_t)-12 },
+	},
+	{ .name = "bad tristate", .fails = true, .cfg = "CONFIG_TRISTATE=M" },
+	{ .name = "bad bool", .fails = true, .cfg = "CONFIG_BOOL=X" },
+	{ .name = "int (not int)", .fails = true, .cfg = "CONFIG_INT=abc" },
+	{ .name = "int (string)", .fails = true, .cfg = "CONFIG_INT=\"abc\"" },
+	{ .name = "int (empty)", .fails = true, .cfg = "CONFIG_INT=" },
+	{ .name = "int (mixed up 1)", .fails = true, .cfg = "CONFIG_INT=123abc",
+	  .fails = true, },
+	{ .name = "int (mixed up 2)", .fails = true, .cfg = "CONFIG_INT=123abc\n",
+	  .fails = true, },
+	{ .name = "int (too big)", .fails = true,
+	  .cfg = "CONFIG_INT=123456789123456789123\n" },
+};
+
+void test_core_extern(void)
+{
+	const char *file = "test_core_extern.o";
+	const char *probe_name = "raw_tp/sys_enter";
+	const char *tp_name = "sys_enter";
+	const size_t bss_sz = roundup_page(sizeof(struct data));
+	const uint32_t kern_ver = get_kernel_version();
+	int err, duration = 0, i;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_link *link = NULL;
+	struct bpf_map *bss_map;
+	void *bss_mmaped = NULL;
+	volatile struct data *data;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		char tmp_cfg_path[] = "/tmp/test_core_extern_cfg.XXXXXX";
+		const struct test_case *t = &test_cases[i];
+		DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			.kernel_config_path = t->cfg_path,
+		);
+
+		if (!test__start_subtest(t->name))
+			continue;
+
+		if (t->cfg) {
+			size_t n = strlen(t->cfg) + 1;
+			int fd = mkstemp(tmp_cfg_path);
+
+			if (CHECK(fd < 0, "mkstemp", "errno: %d\n", errno))
+				continue;
+			printf("using '%s' as config file\n", tmp_cfg_path);
+			if (CHECK_FAIL(write(fd, t->cfg, n) != n))
+				continue;
+			close(fd);
+			opts.kernel_config_path = tmp_cfg_path;
+		}
+
+		obj = bpf_object__open_file("test_core_extern.o", &opts);
+		if (t->fails) {
+			CHECK(!IS_ERR(obj), "obj_open",
+			      "shouldn't succeed opening '%s'!\n", file);
+			goto cleanup;
+		} else {
+			if (CHECK(IS_ERR(obj), "obj_open",
+				  "failed to open '%s': %ld\n",
+				  file, PTR_ERR(obj)))
+				goto cleanup;
+		}
+		prog = bpf_object__find_program_by_title(obj, probe_name);
+		if (CHECK(!prog, "find_prog", "prog %s missing\n", probe_name))
+			goto cleanup;
+		err = bpf_object__load(obj);
+		if (CHECK(err, "obj_load", "failed to load prog '%s': %d\n",
+			  probe_name, err))
+			goto cleanup;
+		bss_map = bpf_object__find_map_by_name(obj, "test_cor.bss");
+		if (CHECK(!bss_map, "find_bss_map", ".bss map not found\n"))
+			goto cleanup;
+		bss_mmaped = mmap(NULL, bss_sz, PROT_READ | PROT_WRITE,
+				  MAP_SHARED, bpf_map__fd(bss_map), 0);
+		if (CHECK(bss_mmaped == MAP_FAILED, "bss_mmap",
+			  ".bss mmap failed: %d\n", errno)) {
+			bss_mmaped = NULL;
+			goto cleanup;
+		}
+		data = bss_mmaped;
+
+		link = bpf_program__attach_raw_tracepoint(prog, tp_name);
+		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+			goto cleanup;
+
+		usleep(1);
+
+		CHECK(data->kern_ver != kern_ver, "kern_ver",
+		      "exp %x, got %lx\n", kern_ver, data->kern_ver);
+		CHECK(data->missing_val != 0xDEADC0DE, "missing_val",
+		      "exp %x, got %lx\n", 0xDEADC0DE, data->missing_val);
+		CHECK(data->bool_val != t->data.bool_val, "bool_val",
+		      "exp %lx, got %lx\n", t->data.bool_val, data->bool_val);
+		CHECK(data->tristate_val != t->data.tristate_val,
+		      "tristate_val", "exp %lx, got %lx\n",
+		      t->data.tristate_val, data->tristate_val);
+		CHECK(data->int_val != t->data.int_val, "int_val",
+		      "exp %lx, got %lx\n", t->data.int_val, data->int_val);
+
+cleanup:
+		if (t->cfg)
+			unlink(tmp_cfg_path);
+		if (bss_mmaped) {
+			CHECK_FAIL(munmap(bss_mmaped, bss_sz));
+			bss_mmaped = NULL;
+			data = NULL;
+		}
+		if (!IS_ERR_OR_NULL(link)) {
+			bpf_link__destroy(link);
+			link = NULL;
+		}
+		if (!IS_ERR_OR_NULL(obj))
+			bpf_object__close(obj);
+	}
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_extern.c b/tools/testing/selftests/bpf/progs/test_core_extern.c
new file mode 100644
index 000000000000..adbc74113265
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_extern.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2017 Facebook
+
+#include <stdint.h>
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+/* non-existing BPF helper, to test dead code elimination */
+static int (*bpf_missing_helper)(const void *arg1, int arg2) = (void *) 999;
+
+extern uint64_t LINUX_KERNEL_VERSION;
+extern uint64_t CONFIG_TRISTATE;
+extern uint64_t CONFIG_BOOL;
+extern uint64_t CONFIG_INT;
+extern uint64_t CONFIG_MISSING;
+
+volatile struct {
+	uint64_t kern_ver;
+	uint64_t tristate_val;
+	uint64_t bool_val;
+	uint64_t int_val;
+	uint64_t missing_val;
+} out = {};
+
+SEC("raw_tp/sys_enter")
+int handle_sys_enter(struct pt_regs *ctx)
+{
+	out.kern_ver = LINUX_KERNEL_VERSION;
+	out.tristate_val = CONFIG_TRISTATE;
+	out.bool_val = CONFIG_BOOL;
+	out.int_val = CONFIG_INT;
+
+	if (CONFIG_MISSING)
+		/* invalid, but dead code - never executed */
+		out.missing_val = bpf_missing_helper(ctx, 123);
+	else
+		out.missing_val = 0xDEADC0DE;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

