Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48021500923
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiDNJEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241625AbiDNJCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:02:54 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8F0633B;
        Thu, 14 Apr 2022 02:00:28 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:52594.698421431
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.43 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id 7262B100180;
        Thu, 14 Apr 2022 17:00:26 +0800 (CST)
Received: from  ([123.150.8.43])
        by gateway-153622-dep-749df8664c-nmrf6 with ESMTP id 89fc0cdd849b4fa5b64c6882a9cc62ac for ast@kernel.org;
        Thu, 14 Apr 2022 17:00:27 CST
X-Transaction-ID: 89fc0cdd849b4fa5b64c6882a9cc62ac
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.43
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From:   Song Chen <chensong_2000@189.cn>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Song Chen <chensong_2000@189.cn>
Subject: [RFC PATCH 1/1] sample: bpf: introduce irqlat
Date:   Thu, 14 Apr 2022 17:07:35 +0800
Message-Id: <1649927255-19036-1-git-send-email-chensong_2000@189.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

irqlat presents max, min and avg value of time consumed in
irq handling for each cpu, from irq_handler_entry to
irq_handler_exit.

engineers can run it to evaluate the performance of irq handling,
especially for RT system.

Signed-off-by: Song Chen <chensong_2000@189.cn>
---
 samples/bpf/.gitignore    |   1 +
 samples/bpf/Makefile      |   5 ++
 samples/bpf/irqlat_kern.c |  81 ++++++++++++++++++++++++++++++
 samples/bpf/irqlat_user.c | 100 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 samples/bpf/irqlat_kern.c
 create mode 100644 samples/bpf/irqlat_user.c

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0e7bfdbff80a..2d727f041f51 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -61,3 +61,4 @@ iperf.*
 /vmlinux.h
 /bpftool/
 /libbpf/
+irqlat
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..df2daab128f0 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -60,6 +60,8 @@ tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
+tprogs-y += irqlat
+
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
 LIBBPF_OUTPUT = $(abspath $(BPF_SAMPLES_PATH))/libbpf
@@ -125,6 +127,8 @@ xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
 
+irqlat-objs := irqlat_user.o
+
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
 always-y += sockex1_kern.o
@@ -181,6 +185,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += irqlat_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/irqlat_kern.c b/samples/bpf/irqlat_kern.c
new file mode 100644
index 000000000000..0037dcda67cf
--- /dev/null
+++ b/samples/bpf/irqlat_kern.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Kylin
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/version.h>
+#include <linux/ptrace.h>
+#include <uapi/linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define MAX_CPUS		128
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, u64);
+	__uint(max_entries, MAX_CPUS);
+} irq_ts SEC(".maps");
+
+SEC("tracepoint/irq/irq_handler_entry")
+int on_irq_entry(struct pt_regs *ctx)
+{
+	int cpu = bpf_get_smp_processor_id();
+	u64 *ts = bpf_map_lookup_elem(&irq_ts, &cpu);
+
+	if (ts)
+		*ts = bpf_ktime_get_ns();
+
+	return 0;
+}
+
+struct datares {
+	u64 entries;
+	u64 total;
+	u64 max;
+	u64 min;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, int);
+	__type(value, struct datares);
+	__uint(max_entries, MAX_CPUS);
+} irq_lat SEC(".maps");
+
+SEC("tracepoint/irq/irq_handler_exit")
+int on_irq_exit(struct pt_regs *ctx)
+{
+	u64 *ts, cur_ts, delta, *val;
+	int cpu;
+	struct datares *res;
+
+	cpu = bpf_get_smp_processor_id();
+	ts = bpf_map_lookup_elem(&irq_ts, &cpu);
+	if (!ts)
+		return 0;
+
+	cur_ts = bpf_ktime_get_ns();
+	delta = cur_ts - *ts;
+
+	res = bpf_map_lookup_elem(&irq_lat, &cpu);
+	if (!res)
+		return 0;
+
+	res->entries++;
+	res->total += delta;
+	if (res->max < delta)
+		res->max = delta;
+	if (res->min == 0 || res->min > delta)
+		res->min = delta;
+
+	if (res->total >= U64_MAX)
+		__builtin_memset(res, 0, sizeof(struct datares));
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/irqlat_user.c b/samples/bpf/irqlat_user.c
new file mode 100644
index 000000000000..3a5a43b9fce9
--- /dev/null
+++ b/samples/bpf/irqlat_user.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Kylin
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <linux/perf_event.h>
+#include <linux/bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+#include "trace_helpers.h"
+
+#define MAX_CPUS 128
+static int map_fd[2];
+
+struct datares {
+	__u64 entries;
+	__u64 total;
+	__u64 max;
+	__u64 min;
+};
+
+static void get_data(int fd)
+{
+	int i;
+	struct datares res;
+	__u64 avg;
+
+	/* Clear screen */
+	printf("\033[2J");
+
+	/* Header */
+	printf("\nirq Latency statistics: (ns)\n");
+	for (i = 0; i < MAX_CPUS; i++) {
+		bpf_map_lookup_elem(fd, &i, &res);
+
+		if (res.entries == 0)
+			continue;
+
+		avg = res.total / res.entries;
+		printf("cpu:%d, max:%llu, min:%llu, avg:%llu\n",
+					i, res.max, res.min, avg);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	char filename[256];
+	struct bpf_object *obj = NULL;
+	struct bpf_link *links[2];
+	struct bpf_program *prog;
+	int delay = 1, i = 0;
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		fprintf(stderr, "ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "irq_ts");
+	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "irq_lat");
+	if (map_fd[0] < 0 || map_fd[1] < 0) {
+		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
+		goto cleanup;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		links[i] = bpf_program__attach(prog);
+		if (libbpf_get_error(links[i])) {
+			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
+			links[i] = NULL;
+			goto cleanup;
+		}
+		i++;
+	}
+
+	while (1) {
+		sleep(delay);
+		get_data(map_fd[1]);
+	}
+
+cleanup:
+	for (i--; i >= 0; i--)
+		bpf_link__destroy(links[i]);
+
+	bpf_object__close(obj);
+	return 0;
+}
-- 
2.25.1

