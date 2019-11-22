Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7E105E16
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 02:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKVBPU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 20:15:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35052 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfKVBPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 20:15:20 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM1FDMv025396
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 17:15:19 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wd91hvc2u-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 17:15:19 -0800
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 17:15:16 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4D8BD760B98; Thu, 21 Nov 2019 17:15:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: Add BPF trampoline performance test
Date:   Thu, 21 Nov 2019 17:15:15 -0800
Message-ID: <20191122011515.255371-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=1 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxlogscore=976 phishscore=0 spamscore=0
 clxscore=1034 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that benchmarks different ways of attaching BPF program to a kernel function.
Here are the results for 2.4Ghz x86 cpu on a kernel without mitigations:
$ ./test_progs -n 49 -v|grep events
task_rename base	2743K events per sec
task_rename kprobe	2419K events per sec
task_rename kretprobe	1876K events per sec
task_rename raw_tp	2578K events per sec
task_rename fentry	2710K events per sec
task_rename fexit	2685K events per sec

On a kernel with retpoline:
$ ./test_progs -n 49 -v|grep events
task_rename base	2401K events per sec
task_rename kprobe	1930K events per sec
task_rename kretprobe	1485K events per sec
task_rename raw_tp	2053K events per sec
task_rename fentry	2351K events per sec
task_rename fexit	2185K events per sec

All 5 approaches:
- kprobe/kretprobe in __set_task_comm()
- raw tracepoint in trace_task_rename()
- fentry/fexit in __set_task_comm()
are roughly equivalent.

__set_task_comm() by itself is quite fast, so any extra instructions add up.
Until BPF trampoline was introduced the fastest mechanism was raw tracepoint.
kprobe via ftrace was second best. kretprobe is slow due to trap. New
fentry/fexit methods via BPF trampoline are clearly the fastest and the
difference is more pronounced with retpoline on, since BPF trampoline doesn't
use indirect jumps.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/test_overhead.c  | 142 ++++++++++++++++++
 .../selftests/bpf/progs/test_overhead.c       |  43 ++++++
 2 files changed, 185 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_overhead.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_overhead.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
new file mode 100644
index 000000000000..c32aa28bd93f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019 Facebook */
+#define _GNU_SOURCE
+#include <sched.h>
+#include <test_progs.h>
+
+#define MAX_CNT 100000
+
+static __u64 time_get_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000000ull + ts.tv_nsec;
+}
+
+static int test_task_rename(const char *prog)
+{
+	int i, fd, duration = 0, err;
+	char buf[] = "test\n";
+	__u64 start_time;
+
+	fd = open("/proc/self/comm", O_WRONLY|O_TRUNC);
+	if (CHECK(fd < 0, "open /proc", "err %d", errno))
+		return -1;
+	start_time = time_get_ns();
+	for (i = 0; i < MAX_CNT; i++) {
+		err = write(fd, buf, sizeof(buf));
+		if (err < 0) {
+			CHECK(err < 0, "task rename", "err %d", errno);
+			close(fd);
+			return -1;
+		}
+	}
+	printf("task_rename %s\t%lluK events per sec\n", prog,
+	       MAX_CNT * 1000000ll / (time_get_ns() - start_time));
+	close(fd);
+	return 0;
+}
+
+static void test_run(const char *prog)
+{
+	test_task_rename(prog);
+}
+
+static void setaffinity(void)
+{
+	cpu_set_t cpuset;
+	int cpu = 0;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+	sched_setaffinity(0, sizeof(cpuset), &cpuset);
+}
+
+void test_test_overhead(void)
+{
+	const char *kprobe_name = "kprobe/__set_task_comm";
+	const char *kretprobe_name = "kretprobe/__set_task_comm";
+	const char *raw_tp_name = "raw_tp/task_rename";
+	const char *fentry_name = "fentry/__set_task_comm";
+	const char *fexit_name = "fexit/__set_task_comm";
+	const char *kprobe_func = "__set_task_comm";
+	struct bpf_program *kprobe_prog, *kretprobe_prog, *raw_tp_prog;
+	struct bpf_program *fentry_prog, *fexit_prog;
+	struct bpf_object *obj;
+	struct bpf_link *link;
+	int err, duration = 0;
+
+	obj = bpf_object__open_file("./test_overhead.o", NULL);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
+	if (CHECK(!kprobe_prog, "find_probe",
+		  "prog '%s' not found\n", kprobe_name))
+		goto cleanup;
+	kretprobe_prog = bpf_object__find_program_by_title(obj, kretprobe_name);
+	if (CHECK(!kretprobe_prog, "find_probe",
+		  "prog '%s' not found\n", kretprobe_name))
+		goto cleanup;
+	raw_tp_prog = bpf_object__find_program_by_title(obj, raw_tp_name);
+	if (CHECK(!raw_tp_prog, "find_probe",
+		  "prog '%s' not found\n", raw_tp_name))
+		goto cleanup;
+	fentry_prog = bpf_object__find_program_by_title(obj, fentry_name);
+	if (CHECK(!fentry_prog, "find_probe",
+		  "prog '%s' not found\n", fentry_name))
+		goto cleanup;
+	fexit_prog = bpf_object__find_program_by_title(obj, fexit_name);
+	if (CHECK(!fexit_prog, "find_probe",
+		  "prog '%s' not found\n", fexit_name))
+		goto cleanup;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
+	setaffinity();
+
+	/* base line run */
+	test_run("base");
+
+	/* attach kprobe */
+	link = bpf_program__attach_kprobe(kprobe_prog, false /* retprobe */,
+					  kprobe_func);
+	if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("kprobe");
+	bpf_link__destroy(link);
+
+	/* attach kretprobe */
+	link = bpf_program__attach_kprobe(kretprobe_prog, true /* retprobe */,
+					  kprobe_func);
+	if (CHECK(IS_ERR(link), "attach kretprobe", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("kretprobe");
+	bpf_link__destroy(link);
+
+	/* attach raw_tp */
+	link = bpf_program__attach_raw_tracepoint(raw_tp_prog, "task_rename");
+	if (CHECK(IS_ERR(link), "attach fentry", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("raw_tp");
+	bpf_link__destroy(link);
+
+	/* attach fentry */
+	link = bpf_program__attach_trace(fentry_prog);
+	if (CHECK(IS_ERR(link), "attach fentry", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("fentry");
+	bpf_link__destroy(link);
+
+	/* attach fexit */
+	link = bpf_program__attach_trace(fexit_prog);
+	if (CHECK(IS_ERR(link), "attach fexit", "err %ld\n", PTR_ERR(link)))
+		goto cleanup;
+	test_run("fexit");
+	bpf_link__destroy(link);
+cleanup:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
new file mode 100644
index 000000000000..ef06b2693f96
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+#include "bpf_tracing.h"
+
+SEC("kprobe/__set_task_comm")
+int prog1(struct pt_regs *ctx)
+{
+	return 0;
+}
+
+SEC("kretprobe/__set_task_comm")
+int prog2(struct pt_regs *ctx)
+{
+	return 0;
+}
+
+SEC("raw_tp/task_rename")
+int prog3(struct bpf_raw_tracepoint_args *ctx)
+{
+	return 0;
+}
+
+struct __set_task_comm_args {
+	struct task_struct *tsk;
+	const char *buf;
+	ku8 exec;
+};
+
+SEC("fentry/__set_task_comm")
+int prog4(struct __set_task_comm_args *ctx)
+{
+	return 0;
+}
+
+SEC("fexit/__set_task_comm")
+int prog5(struct __set_task_comm_args *ctx)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.23.0

