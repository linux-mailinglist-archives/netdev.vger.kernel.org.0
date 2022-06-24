Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A718F559B0A
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiFXOGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiFXOGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DAF4EDE2;
        Fri, 24 Jun 2022 07:06:12 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LTzRL1bJLzDsQb;
        Fri, 24 Jun 2022 22:05:34 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:09 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:08 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <irogers@google.com>,
        <davemarchevsky@fb.com>, <adrian.hunter@intel.com>,
        <alexandre.truong@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [RFC v2 14/17] perf kwork: Implement bpf trace
Date:   Fri, 24 Jun 2022 22:03:46 +0800
Message-ID: <20220624140349.16964-15-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20220624140349.16964-1-yangjihong1@huawei.com>
References: <20220624140349.16964-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perf_record generates perf.data, which generates extra interrupts
for hard disk, amount of data to be collected increases with time.
Use ebpf trace can process the data in kernel, which solves the
preceding two problems.

Add -b/--use-bpf option for latency and report to support
tracing kwork events using ebpf:
1. Create bpf prog and attach to tracepoints,
2. Start tracing after command is entered,
3. After user hit "ctrl+c", stop tracing and report,
4. Support CPU and name filtering.

This commit implements the framework code and
does not add specific event support.

Test cases:

  # perf kwork rep -h

   Usage: perf kwork report [<options>]

      -b, --use-bpf         Use BPF to measure kwork runtime
      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): runtime, max, count
      -S, --with-summary    Show summary with statistics
          --time <str>      Time span for analysis (start,stop)

  # perf kwork lat -h

   Usage: perf kwork latency [<options>]

      -b, --use-bpf         Use BPF to measure kwork latency
      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): avg, max, count
          --time <str>      Time span for analysis (start,stop)

  # perf kwork lat -b
  Unsupported bpf trace class irq

  # perf kwork rep -b
  Unsupported bpf trace class irq

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Documentation/perf-kwork.txt    |  10 +
 tools/perf/Makefile.perf                   |   1 +
 tools/perf/builtin-kwork.c                 |  66 ++++-
 tools/perf/util/Build                      |   1 +
 tools/perf/util/bpf_kwork.c                | 278 +++++++++++++++++++++
 tools/perf/util/bpf_skel/kwork_trace.bpf.c |  74 ++++++
 tools/perf/util/kwork.h                    |  35 +++
 7 files changed, 464 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/bpf_kwork.c
 create mode 100644 tools/perf/util/bpf_skel/kwork_trace.bpf.c

diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
index 51c1625bacae..3c36324712b6 100644
--- a/tools/perf/Documentation/perf-kwork.txt
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -26,7 +26,9 @@ There are several variants of 'perf kwork':
     Example usage:
         perf kwork record -- sleep 1
         perf kwork report
+        perf kwork report -b
         perf kwork latency
+        perf kwork latency -b
         perf kwork timehist
 
    By default it shows the individual work events such as irq, workqeueu,
@@ -73,6 +75,10 @@ OPTIONS
 OPTIONS for 'perf kwork report'
 ----------------------------
 
+-b::
+--use-bpf::
+	Use BPF to measure kwork runtime
+
 -C::
 --cpu::
 	Only show events for the given CPU(s) (comma separated list).
@@ -103,6 +109,10 @@ OPTIONS for 'perf kwork report'
 OPTIONS for 'perf kwork latency'
 ----------------------------
 
+-b::
+--use-bpf::
+	Use BPF to measure kwork latency
+
 -C::
 --cpu::
 	Only show events for the given CPU(s) (comma separated list).
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8f738e11356d..44246d003846 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -1039,6 +1039,7 @@ SKELETONS := $(SKEL_OUT)/bpf_prog_profiler.skel.h
 SKELETONS += $(SKEL_OUT)/bperf_leader.skel.h $(SKEL_OUT)/bperf_follower.skel.h
 SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h $(SKEL_OUT)/func_latency.skel.h
 SKELETONS += $(SKEL_OUT)/off_cpu.skel.h
+SKELETONS += $(SKEL_OUT)/kwork_trace.skel.h
 
 $(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
 	$(Q)$(MKDIR) -p $@
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 31dcfcfcc5a1..7dcd17ba892a 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -1427,13 +1427,69 @@ static void process_skipped_events(struct perf_kwork *kwork,
 	}
 }
 
+struct kwork_work *perf_kwork_add_work(struct perf_kwork *kwork,
+				       struct kwork_class *class,
+				       struct kwork_work *key)
+{
+	struct kwork_work *work = NULL;
+
+	work = work_new(key);
+	if (work == NULL)
+		return NULL;
+
+	work_insert(&class->work_root, work, &kwork->cmp_id);
+	return work;
+}
+
+static void sig_handler(int sig)
+{
+	/*
+	 * Simply capture termination signal so that
+	 * the program can continue after pause returns
+	 */
+	pr_debug("Captuer signal %d\n", sig);
+}
+
+static int perf_kwork__report_bpf(struct perf_kwork *kwork)
+{
+	int ret;
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	ret = perf_kwork__trace_prepare_bpf(kwork);
+	if (ret)
+		return -1;
+
+	printf("Starting trace, Hit <Ctrl+C> to stop and report\n");
+
+	perf_kwork__trace_start();
+
+	/*
+	 * a simple pause, wait here for stop signal
+	 */
+	pause();
+
+	perf_kwork__trace_finish();
+
+	perf_kwork__report_read_bpf(kwork);
+
+	perf_kwork__report_cleanup_bpf();
+
+	return 0;
+}
+
 static int perf_kwork__report(struct perf_kwork *kwork)
 {
 	int ret;
 	struct rb_node *next;
 	struct kwork_work *work;
 
-	ret = perf_kwork__read_events(kwork);
+	if (kwork->use_bpf)
+		ret = perf_kwork__report_bpf(kwork);
+	else
+		ret = perf_kwork__read_events(kwork);
+
 	if (ret != 0)
 		return -1;
 
@@ -1667,6 +1723,10 @@ int cmd_kwork(int argc, const char **argv)
 		   "input file name"),
 	OPT_BOOLEAN('S', "with-summary", &kwork.summary,
 		    "Show summary with statistics"),
+#ifdef HAVE_BPF_SKEL
+	OPT_BOOLEAN('b', "use-bpf", &kwork.use_bpf,
+		    "Use BPF to measure kwork runtime"),
+#endif
 	OPT_PARENT(kwork_options)
 	};
 	const struct option latency_options[] = {
@@ -1680,6 +1740,10 @@ int cmd_kwork(int argc, const char **argv)
 		   "Time span for analysis (start,stop)"),
 	OPT_STRING('i', "input", &input_name, "file",
 		   "input file name"),
+#ifdef HAVE_BPF_SKEL
+	OPT_BOOLEAN('b', "use-bpf", &kwork.use_bpf,
+		    "Use BPF to measure kwork latency"),
+#endif
 	OPT_PARENT(kwork_options)
 	};
 	const struct option timehist_options[] = {
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index a51267d88ca9..66ad30cf65ec 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -148,6 +148,7 @@ perf-$(CONFIG_PERF_BPF_SKEL) += bpf_counter.o
 perf-$(CONFIG_PERF_BPF_SKEL) += bpf_counter_cgroup.o
 perf-$(CONFIG_PERF_BPF_SKEL) += bpf_ftrace.o
 perf-$(CONFIG_PERF_BPF_SKEL) += bpf_off_cpu.o
+perf-$(CONFIG_PERF_BPF_SKEL) += bpf_kwork.o
 perf-$(CONFIG_BPF_PROLOGUE) += bpf-prologue.o
 perf-$(CONFIG_LIBELF) += symbol-elf.o
 perf-$(CONFIG_LIBELF) += probe-file.o
diff --git a/tools/perf/util/bpf_kwork.c b/tools/perf/util/bpf_kwork.c
new file mode 100644
index 000000000000..433bfadd3af1
--- /dev/null
+++ b/tools/perf/util/bpf_kwork.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * bpf_kwork.c
+ *
+ * Copyright (c) 2022  Huawei Inc,  Yang Jihong <yangjihong1@huawei.com>
+ */
+
+#include <time.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <linux/time64.h>
+
+#include "util/debug.h"
+#include "util/kwork.h"
+
+#include <bpf/bpf.h>
+
+#include "util/bpf_skel/kwork_trace.skel.h"
+
+/*
+ * This should be in sync with "util/kwork_trace.bpf.c"
+ */
+#define MAX_KWORKNAME 128
+
+struct work_key {
+	u32 type;
+	u32 cpu;
+	u64 id;
+};
+
+struct report_data {
+	u64 nr;
+	u64 total_time;
+	u64 max_time;
+	u64 max_time_start;
+	u64 max_time_end;
+};
+
+struct kwork_class_bpf {
+	struct kwork_class *class;
+
+	void (*load_prepare)(struct perf_kwork *kwork);
+	int  (*get_work_name)(struct work_key *key, char **ret_name);
+};
+
+static struct kwork_trace_bpf *skel;
+
+static struct timespec ts_start;
+static struct timespec ts_end;
+
+void perf_kwork__trace_start(void)
+{
+	clock_gettime(CLOCK_MONOTONIC, &ts_start);
+	skel->bss->enabled = 1;
+}
+
+void perf_kwork__trace_finish(void)
+{
+	clock_gettime(CLOCK_MONOTONIC, &ts_end);
+	skel->bss->enabled = 0;
+}
+
+static struct kwork_class_bpf *
+kwork_class_bpf_supported_list[KWORK_CLASS_MAX] = {
+	[KWORK_CLASS_IRQ]       = NULL,
+	[KWORK_CLASS_SOFTIRQ]   = NULL,
+	[KWORK_CLASS_WORKQUEUE] = NULL,
+};
+
+static bool valid_kwork_class_type(enum kwork_class_type type)
+{
+	return type >= 0 && type < KWORK_CLASS_MAX ? true : false;
+}
+
+static int setup_filters(struct perf_kwork *kwork)
+{
+	u8 val = 1;
+	int i, nr_cpus, key, fd;
+	struct perf_cpu_map *map;
+
+	if (kwork->cpu_list != NULL) {
+		fd = bpf_map__fd(skel->maps.perf_kwork_cpu_filter);
+		if (fd < 0) {
+			pr_debug("Invalid cpu filter fd\n");
+			return -1;
+		}
+
+		map = perf_cpu_map__new(kwork->cpu_list);
+		if (map == NULL) {
+			pr_debug("Invalid cpu_list\n");
+			return -1;
+		}
+
+		nr_cpus = libbpf_num_possible_cpus();
+		for (i = 0; i < perf_cpu_map__nr(map); i++) {
+			struct perf_cpu cpu = perf_cpu_map__cpu(map, i);
+
+			if (cpu.cpu >= nr_cpus) {
+				perf_cpu_map__put(map);
+				pr_err("Requested cpu %d too large\n", cpu.cpu);
+				return -1;
+			}
+			bpf_map_update_elem(fd, &cpu.cpu, &val, BPF_ANY);
+		}
+		perf_cpu_map__put(map);
+
+		skel->bss->has_cpu_filter = 1;
+	}
+
+	if (kwork->profile_name != NULL) {
+		if (strlen(kwork->profile_name) >= MAX_KWORKNAME) {
+			pr_err("Requested name filter %s too large, limit to %d\n",
+			       kwork->profile_name, MAX_KWORKNAME - 1);
+			return -1;
+		}
+
+		fd = bpf_map__fd(skel->maps.perf_kwork_name_filter);
+		if (fd < 0) {
+			pr_debug("Invalid name filter fd\n");
+			return -1;
+		}
+
+		key = 0;
+		bpf_map_update_elem(fd, &key, kwork->profile_name, BPF_ANY);
+
+		skel->bss->has_name_filter = 1;
+	}
+
+	return 0;
+}
+
+int perf_kwork__trace_prepare_bpf(struct perf_kwork *kwork)
+{
+	struct bpf_program *prog;
+	struct kwork_class *class;
+	struct kwork_class_bpf *class_bpf;
+	enum kwork_class_type type;
+
+	skel = kwork_trace_bpf__open();
+	if (!skel) {
+		pr_debug("Failed to open kwork trace skeleton\n");
+		return -1;
+	}
+
+	/*
+	 * set all progs to non-autoload,
+	 * then set corresponding progs according to config
+	 */
+	bpf_object__for_each_program(prog, skel->obj)
+		bpf_program__set_autoload(prog, false);
+
+	list_for_each_entry(class, &kwork->class_list, list) {
+		type = class->type;
+		if (!valid_kwork_class_type(type) ||
+		    (kwork_class_bpf_supported_list[type] == NULL)) {
+			pr_err("Unsupported bpf trace class %s\n", class->name);
+			goto out;
+		}
+
+		class_bpf = kwork_class_bpf_supported_list[type];
+		class_bpf->class = class;
+
+		if (class_bpf->load_prepare != NULL)
+			class_bpf->load_prepare(kwork);
+	}
+
+	if (kwork_trace_bpf__load(skel)) {
+		pr_debug("Failed to load kwork trace skeleton\n");
+		goto out;
+	}
+
+	if (setup_filters(kwork))
+		goto out;
+
+	if (kwork_trace_bpf__attach(skel)) {
+		pr_debug("Failed to attach kwork trace skeleton\n");
+		goto out;
+	}
+
+	return 0;
+
+out:
+	kwork_trace_bpf__destroy(skel);
+	return -1;
+}
+
+static int add_work(struct perf_kwork *kwork,
+		    struct work_key *key,
+		    struct report_data *data)
+{
+	struct kwork_work *work;
+	struct kwork_class_bpf *bpf_trace;
+	struct kwork_work tmp = {
+		.id = key->id,
+		.name = NULL,
+		.cpu = key->cpu,
+	};
+	enum kwork_class_type type = key->type;
+
+	if (!valid_kwork_class_type(type)) {
+		pr_debug("Invalid class type %d to add work\n", type);
+		return -1;
+	}
+
+	bpf_trace = kwork_class_bpf_supported_list[type];
+	tmp.class = bpf_trace->class;
+
+	if ((bpf_trace->get_work_name != NULL) &&
+	    (bpf_trace->get_work_name(key, &tmp.name)))
+		return -1;
+
+	work = perf_kwork_add_work(kwork, tmp.class, &tmp);
+	if (work == NULL)
+		return -1;
+
+	if (kwork->report == KWORK_REPORT_RUNTIME) {
+		work->nr_atoms = data->nr;
+		work->total_runtime = data->total_time;
+		work->max_runtime = data->max_time;
+		work->max_runtime_start = data->max_time_start;
+		work->max_runtime_end = data->max_time_end;
+	} else if (kwork->report == KWORK_REPORT_LATENCY) {
+		work->nr_atoms = data->nr;
+		work->total_latency = data->total_time;
+		work->max_latency = data->max_time;
+		work->max_latency_start = data->max_time_start;
+		work->max_latency_end = data->max_time_end;
+	} else {
+		pr_debug("Invalid bpf report type %d\n", kwork->report);
+		return -1;
+	}
+
+	kwork->timestart = (u64)ts_start.tv_sec * NSEC_PER_SEC + ts_start.tv_nsec;
+	kwork->timeend = (u64)ts_end.tv_sec * NSEC_PER_SEC + ts_end.tv_nsec;
+
+	return 0;
+}
+
+int perf_kwork__report_read_bpf(struct perf_kwork *kwork)
+{
+	struct report_data data;
+	struct work_key key = {
+		.type = 0,
+		.cpu  = 0,
+		.id   = 0,
+	};
+	struct work_key prev = {
+		.type = 0,
+		.cpu  = 0,
+		.id   = 0,
+	};
+	int fd = bpf_map__fd(skel->maps.perf_kwork_report);
+
+	if (fd < 0) {
+		pr_debug("Invalid report fd\n");
+		return -1;
+	}
+
+	while (!bpf_map_get_next_key(fd, &prev, &key)) {
+		if ((bpf_map_lookup_elem(fd, &key, &data)) != 0) {
+			pr_debug("Failed to lookup report elem\n");
+			return -1;
+		}
+
+		if ((data.nr != 0) && (add_work(kwork, &key, &data) != 0))
+			return -1;
+
+		prev = key;
+	}
+	return 0;
+}
+
+void perf_kwork__report_cleanup_bpf(void)
+{
+	kwork_trace_bpf__destroy(skel);
+}
diff --git a/tools/perf/util/bpf_skel/kwork_trace.bpf.c b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
new file mode 100644
index 000000000000..36112be831e3
--- /dev/null
+++ b/tools/perf/util/bpf_skel/kwork_trace.bpf.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+// Copyright (c) 2022, Huawei
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define KWORK_COUNT 100
+#define MAX_KWORKNAME 128
+
+/*
+ * This should be in sync with "util/kwork.h"
+ */
+enum kwork_class_type {
+	KWORK_CLASS_IRQ,
+	KWORK_CLASS_SOFTIRQ,
+	KWORK_CLASS_WORKQUEUE,
+	KWORK_CLASS_MAX,
+};
+
+struct work_key {
+	__u32 type;
+	__u32 cpu;
+	__u64 id;
+};
+
+struct report_data {
+	__u64 nr;
+	__u64 total_time;
+	__u64 max_time;
+	__u64 max_time_start;
+	__u64 max_time_end;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(key_size, sizeof(struct work_key));
+	__uint(value_size, MAX_KWORKNAME);
+	__uint(max_entries, KWORK_COUNT);
+} perf_kwork_names SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(key_size, sizeof(struct work_key));
+	__uint(value_size, sizeof(__u64));
+	__uint(max_entries, KWORK_COUNT);
+} perf_kwork_time SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(key_size, sizeof(struct work_key));
+	__uint(value_size, sizeof(struct report_data));
+	__uint(max_entries, KWORK_COUNT);
+} perf_kwork_report SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u8));
+	__uint(max_entries, 1);
+} perf_kwork_cpu_filter SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, MAX_KWORKNAME);
+	__uint(max_entries, 1);
+} perf_kwork_name_filter SEC(".maps");
+
+int enabled = 0;
+int has_cpu_filter = 0;
+int has_name_filter = 0;
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
diff --git a/tools/perf/util/kwork.h b/tools/perf/util/kwork.h
index 6a06194304b8..320c0a6d2e08 100644
--- a/tools/perf/util/kwork.h
+++ b/tools/perf/util/kwork.h
@@ -203,6 +203,7 @@ struct perf_kwork {
 	const char *sort_order;
 	bool show_callchain;
 	unsigned int max_stack;
+	bool use_bpf;
 
 	/*
 	 * statistics
@@ -219,4 +220,38 @@ struct perf_kwork {
 	u64 nr_skipped_events[KWORK_TRACE_MAX + 1];
 };
 
+struct kwork_work *perf_kwork_add_work(struct perf_kwork *kwork,
+				       struct kwork_class *class,
+				       struct kwork_work *key);
+
+#ifdef HAVE_BPF_SKEL
+
+int perf_kwork__trace_prepare_bpf(struct perf_kwork *kwork);
+int perf_kwork__report_read_bpf(struct perf_kwork *kwork);
+void perf_kwork__report_cleanup_bpf(void);
+
+void perf_kwork__trace_start(void);
+void perf_kwork__trace_finish(void);
+
+#else  /* !HAVE_BPF_SKEL */
+
+static inline int
+perf_kwork__trace_prepare_bpf(struct perf_kwork *kwork __maybe_unused)
+{
+	return -1;
+}
+
+static inline int
+perf_kwork__report_read_bpf(struct perf_kwork *kwork __maybe_unused)
+{
+	return -1;
+}
+
+static inline void perf_kwork__report_cleanup_bpf(void) {}
+
+static inline void perf_kwork__trace_start(void) {}
+static inline void perf_kwork__trace_finish(void) {}
+
+#endif  /* HAVE_BPF_SKEL */
+
 #endif  /* PERF_UTIL_KWORK_H */
-- 
2.30.GIT

