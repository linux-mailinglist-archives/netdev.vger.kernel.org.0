Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E843559AE7
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiFXOGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiFXOGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711E4EDD3;
        Fri, 24 Jun 2022 07:06:09 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LTzPy52JPzkWSh;
        Fri, 24 Jun 2022 22:04:22 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:06 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:06 +0800
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
Subject: [RFC v2 10/17] perf kwork: Implement perf kwork latency
Date:   Fri, 24 Jun 2022 22:03:42 +0800
Message-ID: <20220624140349.16964-11-yangjihong1@huawei.com>
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

Implements framework of perf kwork latency, which is used to report time
properties such as delay time and frequency.

Test cases:

  # perf kwork lat -h

   Usage: perf kwork latency [<options>]

      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): avg, max, count
          --time <str>      Time span for analysis (start,stop)

  # perf kwork lat -C 199
  Requested CPU 199 too large. Consider raising MAX_NR_CPUS
  Invalid cpu bitmap

  # perf kwork lat -i perf_no_exist.data
  failed to open perf_no_exist.data: No such file or directory

  # perf kwork lat -s avg1
    Error: Unknown --sort key: `avg1'

   Usage: perf kwork latency [<options>]

      -C, --cpu <cpu>       list of cpus to profile
      -i, --input <file>    input file name
      -n, --name <name>     event name to profile
      -s, --sort <key[,key2...]>
                            sort by key(s): avg, max, count
          --time <str>      Time span for analysis (start,stop)

  # perf kwork lat --time FFFF,
  Invalid time span

  # perf kwork lat

    Kwork Name                     | Cpu  | Avg delay     | Count    | Max delay     | Max delay start     | Max delay end       |
   --------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------
    INFO: 36.570% skipped events (31537 including 0 raise, 31537 entry, 0 exit)

Since there are no latency-enabled events, the output is empty.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Documentation/perf-kwork.txt |  29 +++++
 tools/perf/builtin-kwork.c              | 166 +++++++++++++++++++++++-
 tools/perf/util/kwork.h                 |  14 ++
 3 files changed, 208 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
index b79b2c0d047e..069981457de1 100644
--- a/tools/perf/Documentation/perf-kwork.txt
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -19,9 +19,12 @@ There are several variants of 'perf kwork':
 
   'perf kwork report' to report the per kwork runtime.
 
+  'perf kwork latency' to report the per kwork latencies.
+
     Example usage:
         perf kwork record -- sleep 1
         perf kwork report
+        perf kwork latency
 
 OPTIONS
 -------
@@ -71,6 +74,32 @@ OPTIONS for 'perf kwork report'
 	stop time is not given (i.e, time string is 'x.y,') then analysis goes
 	to end of file.
 
+OPTIONS for 'perf kwork latency'
+----------------------------
+
+-C::
+--cpu::
+	Only show events for the given CPU(s) (comma separated list).
+
+-i::
+--input::
+	Input file name. (default: perf.data unless stdin is a fifo)
+
+-n::
+--name::
+	Only show events for the given name.
+
+-s::
+--sort::
+	Sort by key(s): avg, max, count
+
+--time::
+	Only analyze samples within given time window: <start>,<stop>. Times
+	have the format seconds.microseconds. If start is not given (i.e., time
+	string is ',x.y') then analysis starts at the beginning of the file. If
+	stop time is not given (i.e, time string is 'x.y,') then analysis goes
+	to end of file.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index f7736b6f0815..cc2c090fc2f0 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -31,12 +31,14 @@
 #define PRINT_CPU_WIDTH 4
 #define PRINT_COUNT_WIDTH 9
 #define PRINT_RUNTIME_WIDTH 10
+#define PRINT_LATENCY_WIDTH 10
 #define PRINT_TIMESTAMP_WIDTH 17
 #define PRINT_KWORK_NAME_WIDTH 30
 #define RPINT_DECIMAL_WIDTH 3
 #define PRINT_TIME_UNIT_SEC_WIDTH 2
 #define PRINT_TIME_UNIT_MESC_WIDTH 3
 #define PRINT_RUNTIME_HEADER_WIDTH (PRINT_RUNTIME_WIDTH + PRINT_TIME_UNIT_MESC_WIDTH)
+#define PRINT_LATENCY_HEADER_WIDTH (PRINT_LATENCY_WIDTH + PRINT_TIME_UNIT_MESC_WIDTH)
 #define PRINT_TIMESTAMP_HEADER_WIDTH (PRINT_TIMESTAMP_WIDTH + PRINT_TIME_UNIT_SEC_WIDTH)
 
 struct sort_dimension {
@@ -90,6 +92,36 @@ static int max_runtime_cmp(struct kwork_work *l, struct kwork_work *r)
 	return 0;
 }
 
+static int avg_latency_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	u64 avgl, avgr;
+
+	if (!r->nr_atoms)
+		return 1;
+	if (!l->nr_atoms)
+		return -1;
+
+	avgl = l->total_latency / l->nr_atoms;
+	avgr = r->total_latency / r->nr_atoms;
+
+	if (avgl > avgr)
+		return 1;
+	if (avgl < avgr)
+		return -1;
+
+	return 0;
+}
+
+static int max_latency_cmp(struct kwork_work *l, struct kwork_work *r)
+{
+	if (l->max_latency > r->max_latency)
+		return 1;
+	if (l->max_latency < r->max_latency)
+		return -1;
+
+	return 0;
+}
+
 static int sort_dimension__add(struct perf_kwork *kwork __maybe_unused,
 			       const char *tok, struct list_head *list)
 {
@@ -110,13 +142,21 @@ static int sort_dimension__add(struct perf_kwork *kwork __maybe_unused,
 		.name = "count",
 		.cmp  = count_cmp,
 	};
+	static struct sort_dimension avg_sort_dimension = {
+		.name = "avg",
+		.cmp  = avg_latency_cmp,
+	};
 	struct sort_dimension *available_sorts[] = {
 		&id_sort_dimension,
 		&max_sort_dimension,
 		&count_sort_dimension,
 		&runtime_sort_dimension,
+		&avg_sort_dimension,
 	};
 
+	if (kwork->report == KWORK_REPORT_LATENCY)
+		max_sort_dimension.cmp = max_latency_cmp;
+
 	for (i = 0; i < ARRAY_SIZE(available_sorts); i++) {
 		if (!strcmp(available_sorts[i]->name, tok)) {
 			list_add_tail(&available_sorts[i]->list, list);
@@ -479,6 +519,61 @@ static int report_exit_event(struct perf_kwork *kwork,
 	return 0;
 }
 
+static void latency_update_entry_event(struct kwork_work *work,
+				       struct kwork_atom *atom,
+				       struct perf_sample *sample)
+{
+	u64 delta;
+	u64 entry_time = sample->time;
+	u64 raise_time = atom->time;
+
+	if ((raise_time != 0) && (entry_time >= raise_time)) {
+		delta = entry_time - raise_time;
+		if ((delta > work->max_latency) ||
+		    (work->max_latency == 0)) {
+			work->max_latency = delta;
+			work->max_latency_start = raise_time;
+			work->max_latency_end = entry_time;
+		}
+		work->total_latency += delta;
+		work->nr_atoms++;
+	}
+}
+
+static int latency_raise_event(struct perf_kwork *kwork,
+			       struct kwork_class *class,
+			       struct evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine)
+{
+	return work_push_atom(kwork, class, KWORK_TRACE_RAISE,
+			      KWORK_TRACE_MAX, evsel, sample,
+			      machine, NULL);
+}
+
+static int latency_entry_event(struct perf_kwork *kwork,
+			       struct kwork_class *class,
+			       struct evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine)
+{
+	struct kwork_atom *atom = NULL;
+	struct kwork_work *work = NULL;
+
+	atom = work_pop_atom(kwork, class, KWORK_TRACE_ENTRY,
+			     KWORK_TRACE_RAISE, evsel, sample,
+			     machine, &work);
+	if (work == NULL)
+		return -1;
+
+	if (atom != NULL) {
+		latency_update_entry_event(work, atom, sample);
+		atom_del(atom);
+	}
+
+	return 0;
+}
+
 static struct kwork_class kwork_irq;
 static int process_irq_handler_entry_event(struct perf_tool *tool,
 					   struct evsel *evsel,
@@ -757,6 +852,7 @@ static void report_print_work(struct perf_kwork *kwork,
 	int ret = 0;
 	char kwork_name[PRINT_KWORK_NAME_WIDTH];
 	char max_runtime_start[32], max_runtime_end[32];
+	char max_latency_start[32], max_latency_end[32];
 
 	printf(" ");
 
@@ -782,6 +878,14 @@ static void report_print_work(struct perf_kwork *kwork,
 		ret += printf(" %*.*f ms |",
 			      PRINT_RUNTIME_WIDTH, RPINT_DECIMAL_WIDTH,
 			      (double)work->total_runtime / NSEC_PER_MSEC);
+	/*
+	 * avg delay
+	 */
+	else if (kwork->report == KWORK_REPORT_LATENCY)
+		ret += printf(" %*.*f ms |",
+			      PRINT_LATENCY_WIDTH, RPINT_DECIMAL_WIDTH,
+			      (double)work->total_latency /
+			      work->nr_atoms / NSEC_PER_MSEC);
 
 	/*
 	 * count
@@ -805,6 +909,22 @@ static void report_print_work(struct perf_kwork *kwork,
 			      PRINT_TIMESTAMP_WIDTH, max_runtime_start,
 			      PRINT_TIMESTAMP_WIDTH, max_runtime_end);
 	}
+	/*
+	 * max delay, max delay start, max delay end
+	 */
+	else if (kwork->report == KWORK_REPORT_LATENCY) {
+		timestamp__scnprintf_usec(work->max_latency_start,
+					  max_latency_start,
+					  sizeof(max_latency_start));
+		timestamp__scnprintf_usec(work->max_latency_end,
+					  max_latency_end,
+					  sizeof(max_latency_end));
+		ret += printf(" %*.*f ms | %*s s | %*s s |",
+			      PRINT_LATENCY_WIDTH, RPINT_DECIMAL_WIDTH,
+			      (double)work->max_latency / NSEC_PER_MSEC,
+			      PRINT_TIMESTAMP_WIDTH, max_latency_start,
+			      PRINT_TIMESTAMP_WIDTH, max_latency_end);
+	}
 
 	printf("\n");
 }
@@ -821,6 +941,9 @@ static int report_print_header(struct perf_kwork *kwork)
 	if (kwork->report == KWORK_REPORT_RUNTIME)
 		ret += printf(" %-*s |",
 			      PRINT_RUNTIME_HEADER_WIDTH, "Total Runtime");
+	else if (kwork->report == KWORK_REPORT_LATENCY)
+		ret += printf(" %-*s |",
+			      PRINT_LATENCY_HEADER_WIDTH, "Avg delay");
 
 	ret += printf(" %-*s |", PRINT_COUNT_WIDTH, "Count");
 
@@ -829,6 +952,11 @@ static int report_print_header(struct perf_kwork *kwork)
 			      PRINT_RUNTIME_HEADER_WIDTH, "Max runtime",
 			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max runtime start",
 			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max runtime end");
+	else if (kwork->report == KWORK_REPORT_LATENCY)
+		ret += printf(" %-*s | %-*s | %-*s |",
+			      PRINT_LATENCY_HEADER_WIDTH, "Max delay",
+			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max delay start",
+			      PRINT_TIMESTAMP_HEADER_WIDTH, "Max delay end");
 
 	printf("\n");
 	print_separator(ret);
@@ -862,6 +990,7 @@ static void print_skipped_events(struct perf_kwork *kwork)
 {
 	int i;
 	const char *const kwork_event_str[] = {
+		[KWORK_TRACE_RAISE] = "raise",
 		[KWORK_TRACE_ENTRY] = "entry",
 		[KWORK_TRACE_EXIT]  = "exit",
 	};
@@ -932,11 +1061,18 @@ static int perf_kwork__check_config(struct perf_kwork *kwork,
 		.entry_event = report_entry_event,
 		.exit_event  = report_exit_event,
 	};
+	static struct trace_kwork_handler latency_ops = {
+		.raise_event = latency_raise_event,
+		.entry_event = latency_entry_event,
+	};
 
 	switch (kwork->report) {
 	case KWORK_REPORT_RUNTIME:
 		kwork->tp_handler = &report_ops;
 		break;
+	case KWORK_REPORT_LATENCY:
+		kwork->tp_handler = &latency_ops;
+		break;
 	default:
 		pr_debug("Invalid report type %d\n", kwork->report);
 		return -1;
@@ -1214,6 +1350,7 @@ int cmd_kwork(int argc, const char **argv)
 		.nr_skipped_events   = { 0 },
 	};
 	static const char default_report_sort_order[] = "runtime, max, count";
+	static const char default_latency_sort_order[] = "avg, max, count";
 
 	const struct option kwork_options[] = {
 	OPT_INCR('v', "verbose", &verbose,
@@ -1240,6 +1377,19 @@ int cmd_kwork(int argc, const char **argv)
 		    "Show summary with statistics"),
 	OPT_PARENT(kwork_options)
 	};
+	const struct option latency_options[] = {
+	OPT_STRING('s', "sort", &kwork.sort_order, "key[,key2...]",
+		   "sort by key(s): avg, max, count"),
+	OPT_STRING('C', "cpu", &kwork.cpu_list, "cpu",
+		   "list of cpus to profile"),
+	OPT_STRING('n', "name", &kwork.profile_name, "name",
+		   "event name to profile"),
+	OPT_STRING(0, "time", &kwork.time_str, "str",
+		   "Time span for analysis (start,stop)"),
+	OPT_STRING('i', "input", &input_name, "file",
+		   "input file name"),
+	OPT_PARENT(kwork_options)
+	};
 
 	const char *kwork_usage[] = {
 		NULL,
@@ -1249,8 +1399,12 @@ int cmd_kwork(int argc, const char **argv)
 		"perf kwork report [<options>]",
 		NULL
 	};
+	const char * const latency_usage[] = {
+		"perf kwork latency [<options>]",
+		NULL
+	};
 	const char *const kwork_subcommands[] = {
-		"record", "report", NULL
+		"record", "report", "latency", NULL
 	};
 
 	argc = parse_options_subcommand(argc, argv, kwork_options,
@@ -1274,6 +1428,16 @@ int cmd_kwork(int argc, const char **argv)
 		kwork.report = KWORK_REPORT_RUNTIME;
 		setup_sorting(&kwork, report_options, report_usage);
 		return perf_kwork__report(&kwork);
+	} else if (strlen(argv[0]) > 2 && strstarts("latency", argv[0])) {
+		kwork.sort_order = default_latency_sort_order;
+		if (argc > 1) {
+			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
+			if (argc)
+				usage_with_options(latency_usage, latency_options);
+		}
+		kwork.report = KWORK_REPORT_LATENCY;
+		setup_sorting(&kwork, latency_options, latency_usage);
+		return perf_kwork__report(&kwork);
 	} else
 		usage_with_options(kwork_usage, kwork_options);
 
diff --git a/tools/perf/util/kwork.h b/tools/perf/util/kwork.h
index 0a86bf47c74d..e540373ab14e 100644
--- a/tools/perf/util/kwork.h
+++ b/tools/perf/util/kwork.h
@@ -21,9 +21,11 @@ enum kwork_class_type {
 
 enum kwork_report_type {
 	KWORK_REPORT_RUNTIME,
+	KWORK_REPORT_LATENCY,
 };
 
 enum kwork_trace_type {
+	KWORK_TRACE_RAISE,
 	KWORK_TRACE_ENTRY,
 	KWORK_TRACE_EXIT,
 	KWORK_TRACE_MAX,
@@ -116,6 +118,14 @@ struct kwork_work {
 	u64 max_runtime_start;
 	u64 max_runtime_end;
 	u64 total_runtime;
+
+	/*
+	 * latency report
+	 */
+	u64 max_latency;
+	u64 max_latency_start;
+	u64 max_latency_end;
+	u64 total_latency;
 };
 
 struct kwork_class {
@@ -143,6 +153,10 @@ struct kwork_class {
 
 struct perf_kwork;
 struct trace_kwork_handler {
+	int (*raise_event)(struct perf_kwork *kwork,
+			   struct kwork_class *class, struct evsel *evsel,
+			   struct perf_sample *sample, struct machine *machine);
+
 	int (*entry_event)(struct perf_kwork *kwork,
 			   struct kwork_class *class, struct evsel *evsel,
 			   struct perf_sample *sample, struct machine *machine);
-- 
2.30.GIT

