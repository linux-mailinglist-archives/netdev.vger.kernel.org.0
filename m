Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAE559AF4
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiFXOGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiFXOGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:06:08 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2788D4EDD2;
        Fri, 24 Jun 2022 07:06:03 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LTzPL6HFtz1KCB5;
        Fri, 24 Jun 2022 22:03:50 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:06:00 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 22:05:59 +0800
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
Subject: [RFC v2 01/17] perf kwork: New tool
Date:   Fri, 24 Jun 2022 22:03:33 +0800
Message-ID: <20220624140349.16964-2-yangjihong1@huawei.com>
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

The perf-kwork tool is used to trace time properties of kernel work
(such as irq, softirq, and workqueue), including runtime, latency,
and timehist, using the infrastructure in the perf tools to allow
tracing extra targets.

This is the first commit to reuse perf_record framework code to
implement a simple record function, kwork is not supported currently.

Test cases:

  # perf

   usage: perf [--version] [--help] [OPTIONS] COMMAND [ARGS]

   The most commonly used perf commands are:
  <SNIP>
     iostat          Show I/O performance metrics
     kallsyms        Searches running kernel for symbols
     kmem            Tool to trace/measure kernel memory properties
     kvm             Tool to trace/measure kvm guest os
     kwork           Tool to trace/measure kernel work properties (latencies)
     list            List all symbolic event types
     lock            Analyze lock events
     mem             Profile memory accesses
     record          Run a command and record its profile into perf.data
  <SNIP>
   See 'perf help COMMAND' for more information on a specific command.

  # perf kwork

   Usage: perf kwork [<options>] {record}

      -D, --dump-raw-trace  dump raw trace in ASCII
      -f, --force           don't complain, do it
      -k, --kwork <kwork>   list of kwork to profile
      -v, --verbose         be more verbose (show symbol address, etc)

  # perf kwork record -- sleep 1
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 1.787 MB perf.data ]

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 tools/perf/Build                        |   1 +
 tools/perf/Documentation/perf-kwork.txt |  43 +++++++
 tools/perf/builtin-kwork.c              | 162 ++++++++++++++++++++++++
 tools/perf/builtin.h                    |   1 +
 tools/perf/command-list.txt             |   1 +
 tools/perf/perf.c                       |   1 +
 tools/perf/util/kwork.h                 |  41 ++++++
 7 files changed, 250 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-kwork.txt
 create mode 100644 tools/perf/builtin-kwork.c
 create mode 100644 tools/perf/util/kwork.h

diff --git a/tools/perf/Build b/tools/perf/Build
index db61dbe2b543..496b096153bb 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -25,6 +25,7 @@ perf-y += builtin-data.o
 perf-y += builtin-version.o
 perf-y += builtin-c2c.o
 perf-y += builtin-daemon.o
+perf-y += builtin-kwork.o
 
 perf-$(CONFIG_TRACE) += builtin-trace.o
 perf-$(CONFIG_LIBELF) += builtin-probe.o
diff --git a/tools/perf/Documentation/perf-kwork.txt b/tools/perf/Documentation/perf-kwork.txt
new file mode 100644
index 000000000000..dc1e36da57bb
--- /dev/null
+++ b/tools/perf/Documentation/perf-kwork.txt
@@ -0,0 +1,43 @@
+perf-kowrk(1)
+=============
+
+NAME
+----
+perf-kwork - Tool to trace/measure kernel work properties (latencies)
+
+SYNOPSIS
+--------
+[verse]
+'perf kwork' {record}
+
+DESCRIPTION
+-----------
+There are several variants of 'perf kwork':
+
+  'perf kwork record <command>' to record the kernel work
+  of an arbitrary workload.
+
+    Example usage:
+        perf kwork record -- sleep 1
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+	Display verbose dump of the sched data.
+
+-f::
+--force::
+	Don't complain, do it.
+
+-k::
+--kwork::
+	List of kwork to profile
+
+-v::
+--verbose::
+	Be more verbose. (show symbol address, etc)
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
new file mode 100644
index 000000000000..f3552c56ede3
--- /dev/null
+++ b/tools/perf/builtin-kwork.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * builtin-kwork.c
+ *
+ * Copyright (c) 2022  Huawei Inc,  Yang Jihong <yangjihong1@huawei.com>
+ */
+
+#include "builtin.h"
+
+#include "util/data.h"
+#include "util/kwork.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/string2.h"
+#include "util/callchain.h"
+#include "util/evsel_fprintf.h"
+
+#include <subcmd/pager.h>
+#include <subcmd/parse-options.h>
+
+#include <errno.h>
+#include <inttypes.h>
+#include <linux/err.h>
+#include <linux/time64.h>
+#include <linux/zalloc.h>
+
+static struct kwork_class *kwork_class_supported_list[KWORK_CLASS_MAX] = {
+};
+
+static void setup_event_list(struct perf_kwork *kwork,
+			     const struct option *options,
+			     const char * const usage_msg[])
+{
+	int i;
+	struct kwork_class *class;
+	char *tmp, *tok, *str;
+
+	if (kwork->event_list_str == NULL)
+		goto null_event_list_str;
+
+	str = strdup(kwork->event_list_str);
+	for (tok = strtok_r(str, ", ", &tmp);
+	     tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		for (i = 0; i < KWORK_CLASS_MAX; i++) {
+			class = kwork_class_supported_list[i];
+			if (strcmp(tok, class->name) == 0) {
+				list_add_tail(&class->list, &kwork->class_list);
+				break;
+			}
+		}
+		if (i == KWORK_CLASS_MAX)
+			usage_with_options_msg(usage_msg, options,
+					       "Unknown --event key: `%s'", tok);
+	}
+	free(str);
+
+null_event_list_str:
+	/*
+	 * config all kwork events if not specified
+	 */
+	if (list_empty(&kwork->class_list))
+		for (i = 0; i < KWORK_CLASS_MAX; i++)
+			list_add_tail(&kwork_class_supported_list[i]->list,
+				      &kwork->class_list);
+
+	pr_debug("Config event list:");
+	list_for_each_entry(class, &kwork->class_list, list)
+		pr_debug(" %s", class->name);
+	pr_debug("\n");
+}
+
+static int perf_kwork__record(struct perf_kwork *kwork,
+			      int argc, const char **argv)
+{
+	const char **rec_argv;
+	unsigned int rec_argc, i, j;
+	struct kwork_class *class;
+
+	const char *const record_args[] = {
+		"record",
+		"-a",
+		"-R",
+		"-m", "1024",
+		"-c", "1",
+	};
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+
+	list_for_each_entry(class, &kwork->class_list, list)
+		rec_argc += 2 * class->nr_tracepoints;
+
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	list_for_each_entry(class, &kwork->class_list, list) {
+		for (j = 0; j < class->nr_tracepoints; j++) {
+			rec_argv[i++] = strdup("-e");
+			rec_argv[i++] = strdup(class->tp_handlers[j].name);
+		}
+	}
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	pr_debug("record comm: ");
+	for (j = 0; j < rec_argc; j++)
+		pr_debug("%s ", rec_argv[j]);
+	pr_debug("\n");
+
+	return cmd_record(i, rec_argv);
+}
+
+int cmd_kwork(int argc, const char **argv)
+{
+	static struct perf_kwork kwork = {
+		.class_list          = LIST_HEAD_INIT(kwork.class_list),
+
+		.force               = false,
+		.event_list_str      = NULL,
+	};
+
+	const struct option kwork_options[] = {
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_STRING('k', "kwork", &kwork.event_list_str, "kwork",
+		   "list of kwork to profile"),
+	OPT_BOOLEAN('f', "force", &kwork.force, "don't complain, do it"),
+	OPT_END()
+	};
+
+	const char *kwork_usage[] = {
+		NULL,
+		NULL
+	};
+	const char *const kwork_subcommands[] = {
+		"record", NULL
+	};
+
+	argc = parse_options_subcommand(argc, argv, kwork_options,
+					kwork_subcommands, kwork_usage,
+					PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(kwork_usage, kwork_options);
+
+	setup_event_list(&kwork, kwork_options, kwork_usage);
+
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0]))
+		return perf_kwork__record(&kwork, argc, argv);
+	else
+		usage_with_options(kwork_usage, kwork_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 7303e80a639c..d03afea86217 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -38,6 +38,7 @@ int cmd_mem(int argc, const char **argv);
 int cmd_data(int argc, const char **argv);
 int cmd_ftrace(int argc, const char **argv);
 int cmd_daemon(int argc, const char **argv);
+int cmd_kwork(int argc, const char **argv);
 
 int find_scripts(char **scripts_array, char **scripts_path_array, int num,
 		 int pathlen);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 4aa034aefa33..8fcab5ad00c5 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -18,6 +18,7 @@ perf-iostat			mainporcelain common
 perf-kallsyms			mainporcelain common
 perf-kmem			mainporcelain common
 perf-kvm			mainporcelain common
+perf-kwork			mainporcelain common
 perf-list			mainporcelain common
 perf-lock			mainporcelain common
 perf-mem			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 0170cb0819d6..c21b3973641a 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -91,6 +91,7 @@ static struct cmd_struct commands[] = {
 	{ "data",	cmd_data,	0 },
 	{ "ftrace",	cmd_ftrace,	0 },
 	{ "daemon",	cmd_daemon,	0 },
+	{ "kwork",	cmd_kwork,	0 },
 };
 
 struct pager_config {
diff --git a/tools/perf/util/kwork.h b/tools/perf/util/kwork.h
new file mode 100644
index 000000000000..6950636aab2a
--- /dev/null
+++ b/tools/perf/util/kwork.h
@@ -0,0 +1,41 @@
+#ifndef PERF_UTIL_KWORK_H
+#define PERF_UTIL_KWORK_H
+
+#include "perf.h"
+
+#include "util/tool.h"
+#include "util/event.h"
+#include "util/evlist.h"
+#include "util/session.h"
+#include "util/time-utils.h"
+
+#include <linux/list.h>
+#include <linux/bitmap.h>
+
+enum kwork_class_type {
+	KWORK_CLASS_MAX,
+};
+
+struct kwork_class {
+	struct list_head list;
+	const char *name;
+	enum kwork_class_type type;
+
+	unsigned int nr_tracepoints;
+	const struct evsel_str_handler *tp_handlers;
+};
+
+struct perf_kwork {
+	/*
+	 * metadata
+	 */
+	struct list_head class_list;
+
+	/*
+	 * options for command
+	 */
+	bool force;
+	const char *event_list_str;
+};
+
+#endif  /* PERF_UTIL_KWORK_H */
-- 
2.30.GIT

