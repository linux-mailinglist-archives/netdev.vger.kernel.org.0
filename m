Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90D17E5C6
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgCIRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:32:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbgCIRcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:32:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029HPCXB023735
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 10:32:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=scUmtOGY1X805qnYl74Pc/2Y85DpZVyKNzpegnvlB5k=;
 b=cmHROTZhaRSogu3k07rbOww3gHw1JI8lN46K7vVbtFHRD83HlA7/2DdsStyH+ZjiLkN4
 rkjwV3+LnIfyRNz5sDDmyLaUPpQQzMbZTyw8W2Ku4EZ6usRbAoRglvKesNOqplSOupIe
 6dWddlV3A9/Cz5wVBtNhVNgcoZbXAaBUfZU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv2cwrue-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:32:40 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 10:32:26 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id D35A962E27FD; Mon,  9 Mar 2020 10:32:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v6 bpf-next 1/4] bpftool: introduce "prog profile" command
Date:   Mon, 9 Mar 2020 10:32:15 -0700
Message-ID: <20200309173218.2739965-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309173218.2739965-1-songliubraving@fb.com>
References: <20200309173218.2739965-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With fentry/fexit programs, it is possible to profile BPF program with
hardware counters. Introduce bpftool "prog profile", which measures key
metrics of a BPF program.

bpftool prog profile command creates per-cpu perf events. Then it attaches
fentry/fexit programs to the target BPF program. The fentry program saves
perf event value to a map. The fexit program reads the perf event again,
and calculates the difference, which is the instructions/cycles used by
the target program.

Example input and output:

  ./bpftool prog profile id 337 duration 3 cycles instructions llc_misses

        4228 run_cnt
     3403698 cycles                                              (84.08%)
     3525294 instructions   #  1.04 insn per cycle               (84.05%)
          13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)

This command measures cycles and instructions for BPF program with id
337 for 3 seconds. The program has triggered 4228 times. The rest of the
output is similar to perf-stat. In this example, the counters were only
counting ~84% of the time because of time multiplexing of perf counters.

Note that, this approach measures cycles and instructions in very small
increments. So the fentry/fexit programs introduce noticeable errors to
the measurement results.

The fentry/fexit programs are generated with BPF skeletons. Therefore, we
build bpftool twice. The first time _bpftool is built without skeletons.
Then, _bpftool is used to generate the skeletons. The second time, bpftool
is built with skeletons.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/Makefile                |  18 +
 tools/bpf/bpftool/prog.c                  | 424 +++++++++++++++++++++-
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 119 ++++++
 tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
 tools/scripts/Makefile.include            |   1 +
 5 files changed, 608 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c4e810335810..20a90d8450f8 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -59,6 +59,7 @@ LIBS = $(LIBBPF) -lelf -lz
 
 INSTALL ?= install
 RM ?= rm -f
+CLANG ?= clang
 
 FEATURE_USER = .bpftool
 FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
@@ -110,6 +111,22 @@ SRCS += $(BFD_SRCS)
 endif
 
 OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
+_OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
+
+$(OUTPUT)_prog.o: prog.c
+	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
+
+$(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
+
+skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
+	$(QUIET_CLANG)$(CLANG) -I$(srctree)/tools/lib -g -O2 -target bpf -c $< -o $@
+
+profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
+	$(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton skeleton/profiler.bpf.o > $@
+
+$(OUTPUT)prog.o: prog.c profiler.skel.h
+	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
 
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
@@ -125,6 +142,7 @@ $(OUTPUT)%.o: %.c
 clean: $(LIBBPF)-clean
 	$(call QUIET_CLEAN, bpftool)
 	$(Q)$(RM) -- $(OUTPUT)bpftool $(OUTPUT)*.o $(OUTPUT)*.d
+	$(Q)$(RM) -- $(OUTPUT)_bpftool profiler.skel.h skeleton/profiler.bpf.o
 	$(Q)$(RM) -r -- $(OUTPUT)libbpf/
 	$(call QUIET_CLEAN, core-gen)
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpftool
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 1996e67a2f00..576ddd82bc96 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -4,6 +4,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <signal.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -11,10 +12,13 @@
 #include <time.h>
 #include <unistd.h>
 #include <net/if.h>
+#include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
 
 #include <linux/err.h>
+#include <linux/perf_event.h>
 #include <linux/sizes.h>
 
 #include <bpf/bpf.h>
@@ -1537,6 +1541,421 @@ static int do_loadall(int argc, char **argv)
 	return load_with_options(argc, argv, false);
 }
 
+#ifdef BPFTOOL_WITHOUT_SKELETONS
+
+static int do_profile(int argc, char **argv)
+{
+	return 0;
+}
+
+#else /* BPFTOOL_WITHOUT_SKELETONS */
+
+#include "profiler.skel.h"
+
+struct profile_metric {
+	const char *name;
+	struct bpf_perf_event_value val;
+	struct perf_event_attr attr;
+	bool selected;
+
+	/* calculate ratios like instructions per cycle */
+	const int ratio_metric; /* 0 for N/A, 1 for index 0 (cycles) */
+	const char *ratio_desc;
+	const float ratio_mul;
+} metrics[] = {
+	{
+		.name = "cycles",
+		.attr = {
+			.type = PERF_TYPE_HARDWARE,
+			.config = PERF_COUNT_HW_CPU_CYCLES,
+			.exclude_user = 1,
+		},
+	},
+	{
+		.name = "instructions",
+		.attr = {
+			.type = PERF_TYPE_HARDWARE,
+			.config = PERF_COUNT_HW_INSTRUCTIONS,
+			.exclude_user = 1,
+		},
+		.ratio_metric = 1,
+		.ratio_desc = "insns per cycle",
+		.ratio_mul = 1.0,
+	},
+	{
+		.name = "l1d_loads",
+		.attr = {
+			.type = PERF_TYPE_HW_CACHE,
+			.config =
+				PERF_COUNT_HW_CACHE_L1D |
+				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
+				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
+			.exclude_user = 1,
+		},
+	},
+	{
+		.name = "llc_misses",
+		.attr = {
+			.type = PERF_TYPE_HW_CACHE,
+			.config =
+				PERF_COUNT_HW_CACHE_LL |
+				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
+				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
+			.exclude_user = 1
+		},
+		.ratio_metric = 2,
+		.ratio_desc = "LLC misses per million insns",
+		.ratio_mul = 1e6,
+	},
+};
+
+static __u64 profile_total_count;
+
+#define MAX_NUM_PROFILE_METRICS 4
+
+static int profile_parse_metrics(int argc, char **argv)
+{
+	unsigned int metric_cnt;
+	int selected_cnt = 0;
+	unsigned int i;
+
+	metric_cnt = sizeof(metrics) / sizeof(struct profile_metric);
+
+	while (argc > 0) {
+		for (i = 0; i < metric_cnt; i++) {
+			if (is_prefix(argv[0], metrics[i].name)) {
+				if (!metrics[i].selected)
+					selected_cnt++;
+				metrics[i].selected = true;
+				break;
+			}
+		}
+		if (i == metric_cnt) {
+			p_err("unknown metric %s", argv[0]);
+			return -1;
+		}
+		NEXT_ARG();
+	}
+	if (selected_cnt > MAX_NUM_PROFILE_METRICS) {
+		p_err("too many (%d) metrics, please specify no more than %d metrics at at time",
+		      selected_cnt, MAX_NUM_PROFILE_METRICS);
+		return -1;
+	}
+	return selected_cnt;
+}
+
+static void profile_read_values(struct profiler_bpf *obj)
+{
+	__u32 m, cpu, num_cpu = obj->rodata->num_cpu;
+	int reading_map_fd, count_map_fd;
+	__u64 counts[num_cpu];
+	__u32 key = 0;
+	int err;
+
+	reading_map_fd = bpf_map__fd(obj->maps.accum_readings);
+	count_map_fd = bpf_map__fd(obj->maps.counts);
+	if (reading_map_fd < 0 || count_map_fd < 0) {
+		p_err("failed to get fd for map");
+		return;
+	}
+
+	err = bpf_map_lookup_elem(count_map_fd, &key, counts);
+	if (err) {
+		p_err("failed to read count_map: %s", strerror(errno));
+		return;
+	}
+
+	profile_total_count = 0;
+	for (cpu = 0; cpu < num_cpu; cpu++)
+		profile_total_count += counts[cpu];
+
+	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
+		struct bpf_perf_event_value values[num_cpu];
+
+		if (!metrics[m].selected)
+			continue;
+
+		err = bpf_map_lookup_elem(reading_map_fd, &key, values);
+		if (err) {
+			p_err("failed to read reading_map: %s",
+			      strerror(errno));
+			return;
+		}
+		for (cpu = 0; cpu < num_cpu; cpu++) {
+			metrics[m].val.counter += values[cpu].counter;
+			metrics[m].val.enabled += values[cpu].enabled;
+			metrics[m].val.running += values[cpu].running;
+		}
+		key++;
+	}
+}
+
+static void profile_print_readings_json(void)
+{
+	__u32 m;
+
+	jsonw_start_array(json_wtr);
+	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
+		if (!metrics[m].selected)
+			continue;
+		jsonw_start_object(json_wtr);
+		jsonw_string_field(json_wtr, "metric", metrics[m].name);
+		jsonw_lluint_field(json_wtr, "run_cnt", profile_total_count);
+		jsonw_lluint_field(json_wtr, "value", metrics[m].val.counter);
+		jsonw_lluint_field(json_wtr, "enabled", metrics[m].val.enabled);
+		jsonw_lluint_field(json_wtr, "running", metrics[m].val.running);
+
+		jsonw_end_object(json_wtr);
+	}
+	jsonw_end_array(json_wtr);
+}
+
+static void profile_print_readings_plain(void)
+{
+	__u32 m;
+
+	printf("\n%18llu %-20s\n", profile_total_count, "run_cnt");
+	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
+		struct bpf_perf_event_value *val = &metrics[m].val;
+		int r;
+
+		if (!metrics[m].selected)
+			continue;
+		printf("%18llu %-20s", val->counter, metrics[m].name);
+
+		r = metrics[m].ratio_metric - 1;
+		if (r >= 0 && metrics[r].selected &&
+		    metrics[r].val.counter > 0) {
+			printf("# %8.2f %-30s",
+			       val->counter * metrics[m].ratio_mul /
+			       metrics[r].val.counter,
+			       metrics[m].ratio_desc);
+		} else {
+			printf("%-41s", "");
+		}
+
+		if (val->enabled > val->running)
+			printf("(%4.2f%%)",
+			       val->running * 100.0 / val->enabled);
+		printf("\n");
+	}
+}
+
+static void profile_print_readings(void)
+{
+	if (json_output)
+		profile_print_readings_json();
+	else
+		profile_print_readings_plain();
+}
+
+static char *profile_target_name(int tgt_fd)
+{
+	struct bpf_prog_info_linear *info_linear;
+	struct bpf_func_info *func_info;
+	const struct btf_type *t;
+	char *name = NULL;
+	struct btf *btf;
+
+	info_linear = bpf_program__get_prog_info_linear(
+		tgt_fd, 1UL << BPF_PROG_INFO_FUNC_INFO);
+	if (IS_ERR_OR_NULL(info_linear)) {
+		p_err("failed to get info_linear for prog FD %d", tgt_fd);
+		return NULL;
+	}
+
+	if (info_linear->info.btf_id == 0 ||
+	    btf__get_from_id(info_linear->info.btf_id, &btf)) {
+		p_err("prog FD %d doesn't have valid btf", tgt_fd);
+		goto out;
+	}
+
+	func_info = (struct bpf_func_info *)(info_linear->info.func_info);
+	t = btf__type_by_id(btf, func_info[0].type_id);
+	if (!t) {
+		p_err("btf %d doesn't have type %d",
+		      info_linear->info.btf_id, func_info[0].type_id);
+		goto out;
+	}
+	name = strdup(btf__name_by_offset(btf, t->name_off));
+out:
+	free(info_linear);
+	return name;
+}
+
+static struct profiler_bpf *profile_obj;
+static int profile_tgt_fd = -1;
+static char *profile_tgt_name;
+static int *profile_perf_events;
+static int profile_perf_event_cnt;
+
+static void profile_close_perf_events(struct profiler_bpf *obj)
+{
+	int i;
+
+	for (i = profile_perf_event_cnt - 1; i >= 0; i--)
+		close(profile_perf_events[i]);
+
+	free(profile_perf_events);
+	profile_perf_event_cnt = 0;
+}
+
+static int profile_open_perf_events(struct profiler_bpf *obj)
+{
+	unsigned int cpu, m;
+	int map_fd, pmu_fd;
+
+	profile_perf_events = calloc(
+		sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
+	if (!profile_perf_events) {
+		p_err("failed to allocate memory for perf_event array: %s",
+		      strerror(errno));
+		return -1;
+	}
+	map_fd = bpf_map__fd(obj->maps.events);
+	if (map_fd < 0) {
+		p_err("failed to get fd for events map");
+		return -1;
+	}
+
+	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
+		if (!metrics[m].selected)
+			continue;
+		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
+			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
+					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
+			if (pmu_fd < 0 ||
+			    bpf_map_update_elem(map_fd, &profile_perf_event_cnt,
+						&pmu_fd, BPF_ANY) ||
+			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+				p_err("failed to create event %s on cpu %d",
+				      metrics[m].name, cpu);
+				return -1;
+			}
+			profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
+		}
+	}
+	return 0;
+}
+
+static void profile_print_and_cleanup(void)
+{
+	profile_close_perf_events(profile_obj);
+	profile_read_values(profile_obj);
+	profile_print_readings();
+	profiler_bpf__destroy(profile_obj);
+
+	close(profile_tgt_fd);
+	free(profile_tgt_name);
+}
+
+static void int_exit(int signo)
+{
+	profile_print_and_cleanup();
+	exit(0);
+}
+
+static int do_profile(int argc, char **argv)
+{
+	int num_metric, num_cpu, err = -1;
+	struct bpf_program *prog;
+	unsigned long duration;
+	char *endptr;
+
+	/* we at least need two args for the prog and one metric */
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	/* parse target fd */
+	profile_tgt_fd = prog_parse_fd(&argc, &argv);
+	if (profile_tgt_fd < 0) {
+		p_err("failed to parse fd");
+		return -1;
+	}
+
+	/* parse profiling optional duration */
+	if (argc > 2 && is_prefix(argv[0], "duration")) {
+		NEXT_ARG();
+		duration = strtoul(*argv, &endptr, 0);
+		if (*endptr)
+			usage();
+		NEXT_ARG();
+	} else {
+		duration = UINT_MAX;
+	}
+
+	num_metric = profile_parse_metrics(argc, argv);
+	if (num_metric <= 0)
+		goto out;
+
+	num_cpu = libbpf_num_possible_cpus();
+	if (num_cpu <= 0) {
+		p_err("failed to identify number of CPUs");
+		goto out;
+	}
+
+	profile_obj = profiler_bpf__open();
+	if (!profile_obj) {
+		p_err("failed to open and/or load BPF object");
+		goto out;
+	}
+
+	profile_obj->rodata->num_cpu = num_cpu;
+	profile_obj->rodata->num_metric = num_metric;
+
+	/* adjust map sizes */
+	bpf_map__resize(profile_obj->maps.events, num_metric * num_cpu);
+	bpf_map__resize(profile_obj->maps.fentry_readings, num_metric);
+	bpf_map__resize(profile_obj->maps.accum_readings, num_metric);
+	bpf_map__resize(profile_obj->maps.counts, 1);
+
+	/* change target name */
+	profile_tgt_name = profile_target_name(profile_tgt_fd);
+	if (!profile_tgt_name)
+		goto out;
+
+	bpf_object__for_each_program(prog, profile_obj->obj) {
+		err = bpf_program__set_attach_target(prog, profile_tgt_fd,
+						     profile_tgt_name);
+		if (err) {
+			p_err("failed to set attach target\n");
+			goto out;
+		}
+	}
+
+	set_max_rlimit();
+	err = profiler_bpf__load(profile_obj);
+	if (err) {
+		p_err("failed to load profile_obj");
+		goto out;
+	}
+
+	err = profile_open_perf_events(profile_obj);
+	if (err)
+		goto out;
+
+	err = profiler_bpf__attach(profile_obj);
+	if (err) {
+		p_err("failed to attach profile_obj");
+		goto out;
+	}
+	signal(SIGINT, int_exit);
+
+	sleep(duration);
+	profile_print_and_cleanup();
+	return 0;
+
+out:
+	profile_close_perf_events(profile_obj);
+	if (profile_obj)
+		profiler_bpf__destroy(profile_obj);
+	close(profile_tgt_fd);
+	free(profile_tgt_name);
+	return err;
+}
+
+#endif /* BPFTOOL_WITHOUT_SKELETONS */
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -1560,6 +1979,7 @@ static int do_help(int argc, char **argv)
 		"                         [data_out FILE [data_size_out L]] \\\n"
 		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
 		"                         [repeat N]\n"
+		"       %s %s profile PROG [duration DURATION] METRICs\n"
 		"       %s %s tracelog\n"
 		"       %s %s help\n"
 		"\n"
@@ -1577,12 +1997,13 @@ static int do_help(int argc, char **argv)
 		"                 struct_ops | fentry | fexit | freplace }\n"
 		"       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
 		"                        flow_dissector }\n"
+		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2]);
 
 	return 0;
 }
@@ -1599,6 +2020,7 @@ static const struct cmd cmds[] = {
 	{ "detach",	do_detach },
 	{ "tracelog",	do_tracelog },
 	{ "run",	do_run },
+	{ "profile",	do_profile },
 	{ 0 }
 };
 
diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
new file mode 100644
index 000000000000..20034c12f7c5
--- /dev/null
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+#include "profiler.h"
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* map of perf event fds, num_cpu * num_metric entries */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(int));
+} events SEC(".maps");
+
+/* readings at fentry */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+} fentry_readings SEC(".maps");
+
+/* accumulated readings */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+} accum_readings SEC(".maps");
+
+/* sample counts, one per cpu */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u64));
+} counts SEC(".maps");
+
+const volatile __u32 num_cpu = 1;
+const volatile __u32 num_metric = 1;
+#define MAX_NUM_MATRICS 4
+
+SEC("fentry/XXX")
+int BPF_PROG(fentry_XXX)
+{
+	struct bpf_perf_event_value *ptrs[MAX_NUM_MATRICS];
+	u32 key = bpf_get_smp_processor_id();
+	u32 i;
+
+	/* look up before reading, to reduce error */
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		u32 flag = i;
+
+		ptrs[i] = bpf_map_lookup_elem(&fentry_readings, &flag);
+		if (!ptrs[i])
+			return 0;
+	}
+
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		struct bpf_perf_event_value reading;
+		int err;
+
+		err = bpf_perf_event_read_value(&events, key, &reading,
+						sizeof(reading));
+		if (err)
+			return 0;
+		*(ptrs[i]) = reading;
+		key += num_cpu;
+	}
+
+	return 0;
+}
+
+static inline void
+fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
+{
+	struct bpf_perf_event_value *before, diff, *accum;
+
+	before = bpf_map_lookup_elem(&fentry_readings, &id);
+	/* only account samples with a valid fentry_reading */
+	if (before && before->counter) {
+		struct bpf_perf_event_value *accum;
+
+		diff.counter = after->counter - before->counter;
+		diff.enabled = after->enabled - before->enabled;
+		diff.running = after->running - before->running;
+
+		accum = bpf_map_lookup_elem(&accum_readings, &id);
+		if (accum) {
+			accum->counter += diff.counter;
+			accum->enabled += diff.enabled;
+			accum->running += diff.running;
+		}
+	}
+}
+
+SEC("fexit/XXX")
+int BPF_PROG(fexit_XXX)
+{
+	struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 i, one = 1, zero = 0;
+	int err;
+	u64 *count;
+
+	/* read all events before updating the maps, to reduce error */
+	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
+		err = bpf_perf_event_read_value(&events, cpu + i * num_cpu,
+						readings + i, sizeof(*readings));
+		if (err)
+			return 0;
+	}
+	count = bpf_map_lookup_elem(&counts, &zero);
+	if (count) {
+		*count += 1;
+		for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++)
+			fexit_update_maps(i, &readings[i]);
+	}
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/bpf/bpftool/skeleton/profiler.h b/tools/bpf/bpftool/skeleton/profiler.h
new file mode 100644
index 000000000000..e03b53eae767
--- /dev/null
+++ b/tools/bpf/bpftool/skeleton/profiler.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
+#ifndef __PROFILER_H
+#define __PROFILER_H
+
+/* useful typedefs from vmlinux.h */
+
+typedef signed char __s8;
+typedef unsigned char __u8;
+typedef short int __s16;
+typedef short unsigned int __u16;
+typedef int __s32;
+typedef unsigned int __u32;
+typedef long long int __s64;
+typedef long long unsigned int __u64;
+
+typedef __s8 s8;
+typedef __u8 u8;
+typedef __s16 s16;
+typedef __u16 u16;
+typedef __s32 s32;
+typedef __u32 u32;
+typedef __s64 s64;
+typedef __u64 u64;
+
+enum {
+	false = 0,
+	true = 1,
+};
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#define __bitwise __bitwise__
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+#endif /* __PROFILER_H */
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ded7a950dc40..59f31f01cb93 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -106,6 +106,7 @@ ifneq ($(silent),1)
   ifneq ($(V),1)
 	QUIET_CC       = @echo '  CC       '$@;
 	QUIET_CC_FPIC  = @echo '  CC FPIC  '$@;
+	QUIET_CLANG    = @echo '  CLANG    '$@;
 	QUIET_AR       = @echo '  AR       '$@;
 	QUIET_LINK     = @echo '  LINK     '$@;
 	QUIET_MKDIR    = @echo '  MKDIR    '$@;
-- 
2.17.1

