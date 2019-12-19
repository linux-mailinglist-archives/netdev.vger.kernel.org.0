Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0E9125BDB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 08:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLSHHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 02:07:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726683AbfLSHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 02:07:14 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBJ708jK025397
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 23:07:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=i/nfJ9g/8Oowp0EVqL+rfUTc7myFvKJipbBX8PU5IlY=;
 b=AgIyVRPZfTVseRAhfJqdHxsT5xs1gSA8qNhjevJfMkTdga+jfNhP+inHAa87Sfx34dEu
 vZXu4DVpSyrhh/wdmH0LoYkJQXD7DTFs6xn5DeeArpuYDHnENQrLu1MQ98h7dpnFmRjh
 ALDG52SidSWznfoQBcDsxfxUG4Uf+6MO7Qg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wyhy252vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 23:07:11 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 23:07:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A9F452EC16E6; Wed, 18 Dec 2019 23:07:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] libbpf/tools: add runqslower tool to libbpf
Date:   Wed, 18 Dec 2019 23:06:57 -0800
Message-ID: <20191219070659.424273-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219070659.424273-1-andriin@fb.com>
References: <20191219070659.424273-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=2 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert one of BCC tools (runqslower [0]) to BPF CO-RE + libbpf. It matches
its BCC-based counterpart 1-to-1, supporting all the same parameters and
functionality.

runqslower tool utilizes BPF skeleton, auto-generated from BPF object file,
as well as memory-mapped interface to global (read-only, in this case) data.
Its makefile also ensures auto-generation of "relocatable" vmlinux.h, which is
necessary for BTF-typed raw tracepoints with direct memory access.

  [0] https://github.com/iovisor/bcc/blob/11bf5d02c895df9646c117c713082eb192825293/tools/runqslower.py

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/tools/runqslower/.gitignore     |   2 +
 tools/lib/bpf/tools/runqslower/Makefile       |  60 ++++++
 .../lib/bpf/tools/runqslower/runqslower.bpf.c | 101 ++++++++++
 tools/lib/bpf/tools/runqslower/runqslower.c   | 187 ++++++++++++++++++
 tools/lib/bpf/tools/runqslower/runqslower.h   |  13 ++
 5 files changed, 363 insertions(+)
 create mode 100644 tools/lib/bpf/tools/runqslower/.gitignore
 create mode 100644 tools/lib/bpf/tools/runqslower/Makefile
 create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.bpf.c
 create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.c
 create mode 100644 tools/lib/bpf/tools/runqslower/runqslower.h

diff --git a/tools/lib/bpf/tools/runqslower/.gitignore b/tools/lib/bpf/tools/runqslower/.gitignore
new file mode 100644
index 000000000000..404942cc9371
--- /dev/null
+++ b/tools/lib/bpf/tools/runqslower/.gitignore
@@ -0,0 +1,2 @@
+/.output
+/runqslower
diff --git a/tools/lib/bpf/tools/runqslower/Makefile b/tools/lib/bpf/tools/runqslower/Makefile
new file mode 100644
index 000000000000..b87b1f9fe9da
--- /dev/null
+++ b/tools/lib/bpf/tools/runqslower/Makefile
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+CLANG := clang
+LLC := llc
+LLVM_STRIP := llvm-strip
+BPFTOOL := bpftool
+LIBBPF_SRC := ../..
+CFLAGS := -g -Wall
+
+# Try to detect best kernel BTF source
+KERNEL_REL := $(shell uname -r)
+ifneq ("$(wildcard /sys/kenerl/btf/vmlinux)","")
+VMLINUX_BTF := /sys/kernel/btf/vmlinux
+else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
+VMLINUX_BTF := /boot/vmlinux-$(KERNEL_REL)
+else
+$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explicitly")
+endif
+
+out := .output
+abs_out := $(abspath $(out))
+libbpf_src := $(abspath $(LIBBPF_SRC))
+
+.DELETE_ON_ERROR:
+
+.PHONY: all
+all: runqslower
+
+.PHONY: clean
+clean:
+	rm -rf $(out) runqslower
+
+runqslower: $(out)/runqslower.o $(out)/libbpf.a
+	$(CC) $(CFLAGS) -lelf -lz $^ -o $@
+
+$(out)/vmlinux.h: $(VMLINUX_BTF) | $(out)
+	$(BPFTOOL) btf dump file $(VMLINUX_BTF) format core > $@
+
+$(out)/libbpf.a: | $(out)
+	cd $(out) &&							      \
+	$(MAKE) -C $(libbpf_src) OUTPUT=$(abs_out)/ $(abs_out)/libbpf.a
+
+$(out)/runqslower.o: runqslower.h $(out)/runqslower.skel.h		      \
+		     $(out)/runqslower.bpf.o
+
+$(out)/runqslower.bpf.o: $(out)/vmlinux.h runqslower.h
+
+$(out)/%.skel.h: $(out)/%.bpf.o
+	$(BPFTOOL) gen skeleton $< > $@
+
+$(out)/%.bpf.o: %.bpf.c | $(out)
+	$(CLANG) -g -O2 -target bpf -I$(out) -I$(LIBBPF_SRC)		      \
+		 -c $(filter %.c,$^) -o $@ &&				      \
+	$(LLVM_STRIP) -g $@
+
+$(out)/%.o: %.c | $(out)
+	$(CC) $(CFLAGS) -I$(LIBBPF_SRC) -I$(out) -c $(filter %.c,$^) -o $@
+
+$(out):
+	mkdir -p $(out)
+
diff --git a/tools/lib/bpf/tools/runqslower/runqslower.bpf.c b/tools/lib/bpf/tools/runqslower/runqslower.bpf.c
new file mode 100644
index 000000000000..7f078e8b1365
--- /dev/null
+++ b/tools/lib/bpf/tools/runqslower/runqslower.bpf.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include "vmlinux.h"
+#include "bpf_helpers.h"
+#include "bpf_core_read.h"
+#include "runqslower.h"
+
+#define TASK_RUNNING 0
+
+#define BPF_F_INDEX_MASK		0xffffffffULL
+#define BPF_F_CURRENT_CPU		BPF_F_INDEX_MASK
+
+const volatile __u64 min_us = 0;
+const volatile pid_t targ_pid = 0;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 10240);
+	__type(key, u32);
+	__type(value, u64);
+} start SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
+} events SEC(".maps");
+
+/* record enqueue timestamp */
+__always_inline
+static int trace_enqueue(u32 tgid, u32 pid)
+{
+	u64 ts;
+
+	if (!pid || (targ_pid && targ_pid != pid))
+		return 0;
+
+	ts = bpf_ktime_get_ns();
+	bpf_map_update_elem(&start, &pid, &ts, 0);
+	return 0;
+}
+
+SEC("tp_btf/sched_wakeup")
+int handle__sched_wakeup(u64 *ctx)
+{
+	/* TP_PROTO(struct task_struct *p) */
+	struct task_struct *p = (void *)ctx[0];
+
+	return trace_enqueue(p->tgid, p->pid);
+}
+
+SEC("tp_btf/sched_wakeup_new")
+int handle__sched_wakeup_new(u64 *ctx)
+{
+	/* TP_PROTO(struct task_struct *p) */
+	struct task_struct *p = (void *)ctx[0];
+
+	return trace_enqueue(p->tgid, p->pid);
+}
+
+SEC("tp_btf/sched_switch")
+int handle__sched_switch(u64 *ctx)
+{
+	/* TP_PROTO(bool preempt, struct task_struct *prev,
+	 *	    struct task_struct *next)
+	 */
+	struct task_struct *prev = (struct task_struct *)ctx[1];
+	struct task_struct *next = (struct task_struct *)ctx[2];
+	struct event event = {};
+	u64 *tsp, delta_us;
+	long state;
+	u32 pid;
+
+	/* ivcsw: treat like an enqueue event and store timestamp */
+	if (prev->state == TASK_RUNNING)
+		trace_enqueue(prev->tgid, prev->pid);
+
+	pid = next->pid;
+
+	/* fetch timestamp and calculate delta */
+	tsp = bpf_map_lookup_elem(&start, &pid);
+	if (!tsp)
+		return 0;   /* missed enqueue */
+
+	delta_us = (bpf_ktime_get_ns() - *tsp) / 1000;
+	if (min_us && delta_us <= min_us)
+		return 0;
+
+	event.pid = pid;
+	event.delta_us = delta_us;
+	bpf_get_current_comm(&event.task, sizeof(event.task));
+
+	/* output */
+	bpf_perf_event_output(ctx, &events, BPF_F_CURRENT_CPU,
+			      &event, sizeof(event));
+
+	bpf_map_delete_elem(&start, &pid);
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/lib/bpf/tools/runqslower/runqslower.c b/tools/lib/bpf/tools/runqslower/runqslower.c
new file mode 100644
index 000000000000..996f0e2c560e
--- /dev/null
+++ b/tools/lib/bpf/tools/runqslower/runqslower.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+// Copyright (c) 2019 Facebook
+#include <argp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/resource.h>
+#include <time.h>
+#include <libbpf.h>
+#include <bpf.h>
+#include "runqslower.h"
+#include "runqslower.skel.h"
+
+struct env {
+	pid_t pid;
+	__u64 min_us;
+	bool verbose;
+} env = {
+	.min_us = 10000,
+};
+
+const char *argp_program_version = "runqslower 0.1";
+const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
+const char argp_program_doc[] =
+"runqslower    Trace long process scheduling delays.\n"
+"              For Linux, uses eBPF, BPF CO-RE, libbpf, BTF.\n"
+"\n"
+"This script traces high scheduling delays between tasks being\n"
+"ready to run and them running on CPU after that.\n"
+"\n"
+"USAGE: runqslower [-p PID] [min_us]\n"
+"\n"
+"EXAMPLES:\n"
+"    runqslower         # trace run queue latency higher than 10000 us (default)\n"
+"    runqslower 1000    # trace run queue latency higher than 1000 us\n"
+"    runqslower -p 123  # trace pid 123 only\n";
+
+static const struct argp_option opts[] = {
+	{ "pid", 'p', "PID", 0, "Process PID to trace"},
+	{ "verbose", 'v', NULL, 0, "Verbose debug output" },
+	{},
+};
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
+{
+	static int pos_args;
+	int pid;
+	long long min_us;
+
+	switch (key) {
+	case 'v':
+		env.verbose = true;
+		break;
+	case 'p':
+		errno = 0;
+		pid = strtol(arg, NULL, 10);
+		if (errno || pid <= 0) {
+			fprintf(stderr, "Invalid PID: %s\n", arg);
+			argp_usage(state);
+		}
+		env.pid = pid;
+		break;
+	case ARGP_KEY_ARG:
+		if (pos_args++) {
+			fprintf(stderr,
+				"Unrecognized positional argument: %s\n", arg);
+			argp_usage(state);
+		}
+		errno = 0;
+		min_us = strtoll(arg, NULL, 10);
+		if (errno || min_us <= 0) {
+			fprintf(stderr, "Invalid delay (in us): %s\n", arg);
+			argp_usage(state);
+		}
+		env.min_us = min_us;
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+	return 0;
+}
+
+int libbpf_print_fn(enum libbpf_print_level level,
+		    const char *format, va_list args)
+{
+	if (level == LIBBPF_DEBUG && !env.verbose)
+		return 0;
+	return vfprintf(stderr, format, args);
+}
+
+static int bump_memlock_rlimit(void)
+{
+	struct rlimit rlim_new = {
+		.rlim_cur	= RLIM_INFINITY,
+		.rlim_max	= RLIM_INFINITY,
+	};
+
+	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
+}
+
+void handle_event(void *ctx, int cpu, void *data, __u32 data_sz)
+{
+	const struct event *e = data;
+	struct tm *tm;
+	char ts[32];
+	time_t t;
+
+	time(&t);
+	tm = localtime(&t);
+	strftime(ts, sizeof(ts), "%H:%M:%S", tm);
+	printf("%-8s %-16s %-6d %14llu\n", ts, e->task, e->pid, e->delta_us);
+}
+
+void handle_lost_events(void *ctx, int cpu, __u64 lost_cnt)
+{
+	printf("Lost %llu events on CPU #%d!\n", lost_cnt, cpu);
+}
+
+int main(int argc, char **argv)
+{
+	static const struct argp argp = {
+		.options = opts,
+		.parser = parse_arg,
+		.doc = argp_program_doc,
+	};
+	struct perf_buffer_opts pb_opts;
+	struct perf_buffer *pb = NULL;
+	struct runqslower_bpf *obj;
+	int err;
+
+	err = argp_parse(&argp, argc, argv, 0, NULL, NULL);
+	if (err)
+		return err;
+
+	libbpf_set_print(libbpf_print_fn);
+
+	err = bump_memlock_rlimit();
+	if (err) {
+		fprintf(stderr, "failed to increase rlimit: %d", err);
+		return 1;
+	}
+
+	obj = runqslower_bpf__open();
+	if (!obj) {
+		fprintf(stderr, "failed to open and/or load BPF object\n");
+		return 1;
+	}
+
+	/* initialize global data (filtering options) */
+	obj->rodata->targ_pid = env.pid;
+	obj->rodata->min_us = env.min_us;
+
+	err = runqslower_bpf__load(obj);
+	if (err) {
+		fprintf(stderr, "failed to load BPF object: %d\n", err);
+		goto cleanup;
+	}
+
+	err = runqslower_bpf__attach(obj);
+	if (err) {
+		fprintf(stderr, "failed to attach BPF programs\n");
+		goto cleanup;
+	}
+
+	printf("Tracing run queue latency higher than %llu us\n", env.min_us);
+	printf("%-8s %-16s %-6s %14s\n", "TIME", "COMM", "PID", "LAT(us)");
+
+	pb_opts.sample_cb = handle_event;
+	pb_opts.lost_cb = handle_lost_events;
+	pb = perf_buffer__new(bpf_map__fd(obj->maps.events), 64, &pb_opts);
+	err = libbpf_get_error(pb);
+	if (err) {
+		pb = NULL;
+		fprintf(stderr, "failed to open perf buffer: %d\n", err);
+		goto cleanup;
+	}
+
+	while ((err = perf_buffer__poll(pb, 100)) >= 0)
+		;
+	printf("Error polling perf buffer: %d\n", err);
+
+cleanup:
+	perf_buffer__free(pb);
+	runqslower_bpf__destroy(obj);
+
+	return err != 0;
+}
diff --git a/tools/lib/bpf/tools/runqslower/runqslower.h b/tools/lib/bpf/tools/runqslower/runqslower.h
new file mode 100644
index 000000000000..9db225425e5f
--- /dev/null
+++ b/tools/lib/bpf/tools/runqslower/runqslower.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __RUNQSLOWER_H
+#define __RUNQSLOWER_H
+
+#define TASK_COMM_LEN 16
+
+struct event {
+	char task[TASK_COMM_LEN];
+	__u64 delta_us;
+	pid_t pid;
+};
+
+#endif /* __RUNQSLOWER_H */
-- 
2.17.1

