Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ECB1ACD84
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406439AbgDPQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 12:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404521AbgDPQVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 12:21:15 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B6CC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 09:21:13 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id h6so3444487pfr.16
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 09:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BXYubNRsw5jktBeAujXOYByGheHeVgk5DyFmoDDF4wc=;
        b=OgKBHBJgrex5IsRBXu8se0+ifgMSxsiXW3rVjL0AIU9Jsrd89ENXx9Z1qScw2QeAKi
         yF3TdFHujgLWodBrsOo67FHzbkLHXc/9Onyt7rjpE/PCVVsFPbzt6DaPMTNo21ruMqyo
         Q8XFfPRLFxPfLxXZOLmzMdMF7WB//SZRuwYvQrjyuaOYRsbxDPS7FyQ0O623iuDTQBzp
         dSknGs0D51QLUf05i/XO+W0bRzcjmHa24UY3bzK/BO8D/+PFx2tXbRF/2K01ju2u61lY
         qO+sZfLay/YrPYO0QB8oCLmhir99rBpmVefd+h8KmL0A9680hSfsFcuRFlLzUWvZHj9H
         4tmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BXYubNRsw5jktBeAujXOYByGheHeVgk5DyFmoDDF4wc=;
        b=WPCBFgpGFpssVHlsznV81uQFF3A5kUjzkBVl4+3yAGBXcx+OjyLd7VxigwgP2XUcSw
         949v+3Ta7aljy1pTGanD5gm4hVLjtNriUHwn1dTjjJDcYCENSYKpz9MPw6kGqWudl+vb
         w75F5n51W8IBgEl9CjbvMkpz4S+F1aySz2qlHH+Ky1gZ8J81O66ZQJtXEYE9NGDWjL7m
         AfKq1FoKAqnu7CPEwKvSFRMyKiR1VuZkvkvYj4ANDTtJbH1OyVSInQjYDMULbTQf5xcE
         YTSH8y/+PJxIwFJaBQrJ6qf/NB7iaxYlKBsHKkRpnSdvYUKIGJWLPs+tS9YfgeSXHFmc
         k6OQ==
X-Gm-Message-State: AGi0Pub7HiqfAoAH6QoYMdjkowEWiDUXB90GKcS2x5qwf4pRpzxYhDvd
        gzCDNBdIXTTXoTiFRHy7cOBgcagsMK1J
X-Google-Smtp-Source: APiQypJXALhvhQ+JkY1CrZuFlK7ujGn5UVHEA5cC0i979/BxIPM81QvJWxL/ka8yk3P3WYMwd/aMQyvdvtRr
X-Received: by 2002:a17:90a:d78e:: with SMTP id z14mr6350609pju.125.1587054072959;
 Thu, 16 Apr 2020 09:21:12 -0700 (PDT)
Date:   Thu, 16 Apr 2020 09:20:58 -0700
In-Reply-To: <20200416162058.201954-1-irogers@google.com>
Message-Id: <20200416162058.201954-5-irogers@google.com>
Mime-Version: 1.0
References: <20200416162058.201954-1-irogers@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v10 4/4] perf tools: add support for libpfm4
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch links perf with the libpfm4 library if it is available
and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
contains hardware event tables for all processors supported by
perf_events. It is a helper library that helps convert from a
symbolic event name to the event encoding required by the
underlying kernel interface. This library is open-source and
available from: http://perfmon2.sf.net.

With this patch, it is possible to specify full hardware events
by name. Hardware filters are also supported. Events must be
specified via the --pfm-events and not -e option. Both options
are active at the same time and it is possible to mix and match:

$ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Documentation/perf-record.txt |  11 +
 tools/perf/Documentation/perf-stat.txt   |  10 +
 tools/perf/Documentation/perf-top.txt    |  11 +
 tools/perf/Makefile.config               |  13 ++
 tools/perf/Makefile.perf                 |   6 +-
 tools/perf/builtin-list.c                |  12 +-
 tools/perf/builtin-record.c              |   8 +
 tools/perf/builtin-stat.c                |   8 +
 tools/perf/builtin-top.c                 |   8 +
 tools/perf/tests/Build                   |   1 +
 tools/perf/tests/builtin-test.c          |   9 +
 tools/perf/tests/pfm.c                   | 207 +++++++++++++++++
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/util/Build                    |   2 +
 tools/perf/util/evsel.c                  |   2 +-
 tools/perf/util/evsel.h                  |   1 +
 tools/perf/util/parse-events.c           |  30 ++-
 tools/perf/util/parse-events.h           |   4 +
 tools/perf/util/pfm.c                    | 277 +++++++++++++++++++++++
 tools/perf/util/pfm.h                    |  43 ++++
 20 files changed, 655 insertions(+), 11 deletions(-)
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b3f3b3f1c161..ad2c41f595c2 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -596,6 +596,17 @@ Make a copy of /proc/kcore and place it into a directory with the perf data file
 Limit the sample data max size, <size> is expected to be a number with
 appended unit character - B/K/M/G
 
+ifdef::HAVE_LIBPFM[]
+--pfm-events events::
+Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
+including support for event filters. For example '--pfm-events
+inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
+option using the comma separator. Hardware events and generic hardware
+events cannot be mixed together. The latter must be used with the -e
+option. The -e option and this one can be mixed and matched.  Events
+can be grouped using the {} notation.
+endif::HAVE_LIBPFM[]
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1], linkperf:perf-intel-pt[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4d56586b2fb9..536952ad592c 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -71,6 +71,16 @@ report::
 --tid=<tid>::
         stat events on existing thread id (comma separated list)
 
+ifdef::HAVE_LIBPFM[]
+--pfm-events events::
+Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
+including support for event filters. For example '--pfm-events
+inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
+option using the comma separator. Hardware events and generic hardware
+events cannot be mixed together. The latter must be used with the -e
+option. The -e option and this one can be mixed and matched.  Events
+can be grouped using the {} notation.
+endif::HAVE_LIBPFM[]
 
 -a::
 --all-cpus::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 487737a725e9..9858e3640b0c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -319,6 +319,17 @@ Default is to monitor all CPUS.
 	go straight to the histogram browser, just like 'perf top' with no events
 	explicitely specified does.
 
+ifdef::HAVE_LIBPFM[]
+--pfm-events events::
+Select a PMU event using libpfm4 syntax (see http://perfmon2.sf.net)
+including support for event filters. For example '--pfm-events
+inst_retired:any_p:u:c=1:i'. More than one event can be passed to the
+option using the comma separator. Hardware events and generic hardware
+events cannot be mixed together. The latter must be used with the -e
+option. The -e option and this one can be mixed and matched.  Events
+can be grouped using the {} notation.
+endif::HAVE_LIBPFM[]
+
 
 INTERACTIVE PROMPTING KEYS
 --------------------------
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 12a8204d63c6..b45c5d370b42 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1012,6 +1012,19 @@ ifdef LIBCLANGLLVM
   endif
 endif
 
+ifndef NO_LIBPFM4
+  $(call feature_check,libpfm4)
+  ifeq ($(feature-libpfm4), 1)
+    CFLAGS += -DHAVE_LIBPFM
+    EXTLIBS += -lpfm
+    ASCIIDOC_EXTRA = -aHAVE_LIBPFM=1
+    $(call detected,CONFIG_LIBPFM4)
+  else
+    msg := $(warning libpfm4 not found, disables libpfm4 support. Please install libpfm4-dev);
+    NO_LIBPFM4 := 1
+  endif
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   perf_include_dir
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index d15a311408f1..9787eb3ca0a9 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -118,6 +118,8 @@ include ../scripts/utilities.mak
 #
 # Define LIBBPF_DYNAMIC to enable libbpf dynamic linking.
 #
+# Define NO_LIBPFM4 to disable libpfm4 extension.
+#
 
 # As per kernel Makefile, avoid funny character set dependencies
 unexport LC_ALL
@@ -188,7 +190,7 @@ AWK     = awk
 # non-config cases
 config := 1
 
-NON_CONFIG_TARGETS := clean python-clean TAGS tags cscope help install-doc install-man install-html install-info install-pdf doc man html info pdf
+NON_CONFIG_TARGETS := clean python-clean TAGS tags cscope help
 
 ifdef MAKECMDGOALS
 ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
@@ -832,7 +834,7 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
 # 'make doc' should call 'make -C Documentation all'
 $(DOC_TARGETS):
-	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:doc=all)
+	$(Q)$(MAKE) -C $(DOC_DIR) O=$(OUTPUT) $(@:doc=all) ASCIIDOC_EXTRA=$(ASCIIDOC_EXTRA)
 
 TAG_FOLDERS= . ../lib ../include
 TAG_FILES= ../../include/uapi/linux/perf_event.h
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 965ef017496f..7e47dfc42b4e 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -14,6 +14,7 @@
 #include "util/pmu.h"
 #include "util/debug.h"
 #include "util/metricgroup.h"
+#include "util/pfm.h"
 #include <subcmd/pager.h>
 #include <subcmd/parse-options.h>
 #include <stdio.h>
@@ -45,6 +46,13 @@ int cmd_list(int argc, const char **argv)
 		"perf list [<options>] [hw|sw|cache|tracepoint|pmu|sdt|event_glob]",
 		NULL
 	};
+#ifndef HAVE_LIBPFM
+	const char *header =
+		"\nList of pre-defined events (to be used in -e):\n\n";
+#else
+	const char *header =
+	 "\nList of pre-defined events (to be used in -e or --pfm-events):\n\n";
+#endif
 
 	set_option_flag(list_options, 0, "raw-dump", PARSE_OPT_HIDDEN);
 
@@ -53,8 +61,10 @@ int cmd_list(int argc, const char **argv)
 
 	setup_pager();
 
+	libpfm_initialize();
+
 	if (!raw_dump && pager_in_use())
-		printf("\nList of pre-defined events (to be used in -e):\n\n");
+		puts(header);
 
 	if (argc == 0) {
 		print_events(NULL, raw_dump, !desc_flag, long_desc_flag,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1ab349abe904..fc55b641849f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -43,6 +43,7 @@
 #include "util/time-utils.h"
 #include "util/units.h"
 #include "util/bpf-event.h"
+#include "util/pfm.h"
 #include "asm/bug.h"
 #include "perf.h"
 
@@ -2421,6 +2422,11 @@ static struct option __record_options[] = {
 #endif
 	OPT_CALLBACK(0, "max-size", &record.output_max_size,
 		     "size", "Limit the maximum size of the output file", parse_output_max_size),
+#ifdef HAVE_LIBPFM
+	OPT_CALLBACK(0, "pfm-events", &record.evlist, "event",
+		"libpfm4 event selector. use 'perf list' to list available events",
+		parse_libpfm_events_option),
+#endif
 	OPT_END()
 };
 
@@ -2461,6 +2467,8 @@ int cmd_record(int argc, const char **argv)
 	if (rec->evlist == NULL)
 		return -ENOMEM;
 
+	libpfm_initialize();
+
 	err = perf_config(perf_record_config, rec);
 	if (err)
 		return err;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ec053dc1e35c..facd3a69d0fa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -66,6 +66,7 @@
 #include "util/time-utils.h"
 #include "util/top.h"
 #include "util/affinity.h"
+#include "util/pfm.h"
 #include "asm/bug.h"
 
 #include <linux/time64.h>
@@ -933,6 +934,11 @@ static struct option stat_options[] = {
 		    "Use with 'percore' event qualifier to show the event "
 		    "counts of one hardware thread by sum up total hardware "
 		    "threads of same physical core"),
+#ifdef HAVE_LIBPFM
+	OPT_CALLBACK(0, "pfm-events", &evsel_list, "event",
+		"libpfm4 event selector. use 'perf list' to list available events",
+		parse_libpfm_events_option),
+#endif
 	OPT_END()
 };
 
@@ -1871,6 +1877,8 @@ int cmd_stat(int argc, const char **argv)
 	unsigned int interval, timeout;
 	const char * const stat_subcommands[] = { "record", "report" };
 
+	libpfm_initialize();
+
 	setlocale(LC_ALL, "");
 
 	evsel_list = evlist__new();
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 289cf83e658a..f04e2e639894 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -52,6 +52,7 @@
 
 #include "util/debug.h"
 #include "util/ordered-events.h"
+#include "util/pfm.h"
 
 #include <assert.h>
 #include <elf.h>
@@ -1571,6 +1572,11 @@ int cmd_top(int argc, const char **argv)
 		    "Sort the output by the event at the index n in group. "
 		    "If n is invalid, sort by the first event. "
 		    "WARNING: should be used on grouped events."),
+#ifdef HAVE_LIBPFM
+	OPT_CALLBACK(0, "pfm-events", &top.evlist, "event",
+		"libpfm4 event selector. use 'perf list' to list available events",
+		parse_libpfm_events_option),
+#endif
 	OPTS_EVSWITCH(&top.evswitch),
 	OPT_END()
 	};
@@ -1584,6 +1590,8 @@ int cmd_top(int argc, const char **argv)
 	if (status < 0)
 		return status;
 
+	libpfm_initialize();
+
 	top.annotation_opts.min_pcnt = 5;
 	top.annotation_opts.context  = 4;
 
diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
index b3d1bf13ca07..7d2ccec9fd75 100644
--- a/tools/perf/tests/Build
+++ b/tools/perf/tests/Build
@@ -56,6 +56,7 @@ perf-y += mem2node.o
 perf-y += maps.o
 perf-y += time-utils-test.o
 perf-y += genelf.o
+perf-y += pfm.o
 
 $(OUTPUT)tests/llvm-src-base.c: tests/bpf-script-example.c tests/Build
 	$(call rule_mkdir)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b6322eb0f423..8b323151f22c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -313,6 +313,15 @@ static struct test generic_tests[] = {
 		.desc = "maps__merge_in",
 		.func = test__maps__merge_in,
 	},
+	{
+		.desc = "Test libpfm4 support",
+		.func = test__pfm,
+		.subtest = {
+			.skip_if_fail	= true,
+			.get_nr		= test__pfm_subtest_get_nr,
+			.get_desc	= test__pfm_subtest_get_desc,
+		}
+	},
 	{
 		.func = NULL,
 	},
diff --git a/tools/perf/tests/pfm.c b/tools/perf/tests/pfm.c
new file mode 100644
index 000000000000..1d594fd3d9c1
--- /dev/null
+++ b/tools/perf/tests/pfm.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test support for libpfm4 event encodings.
+ *
+ * Copyright 2020 Google LLC.
+ */
+#include "tests.h"
+#include "util/debug.h"
+#include "util/evlist.h"
+#include "util/pfm.h"
+
+#include <linux/kernel.h>
+
+#ifdef HAVE_LIBPFM
+static int test__pfm_events(void);
+static int test__pfm_group(void);
+#endif
+
+static const struct {
+	int (*func)(void);
+	const char *desc;
+} pfm_testcase_table[] = {
+#ifdef HAVE_LIBPFM
+	{
+		.func = test__pfm_events,
+		.desc = "test of individual --pfm-events",
+	},
+	{
+		.func = test__pfm_group,
+		.desc = "test groups of --pfm-events",
+	},
+#endif
+};
+
+#ifdef HAVE_LIBPFM
+static int count_pfm_events(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int count = 0;
+
+	perf_evlist__for_each_entry(evlist, evsel) {
+		count++;
+	}
+	return count;
+}
+
+static int test__pfm_events(void)
+{
+	struct evlist *evlist;
+	struct option opt;
+	size_t i;
+	const struct {
+		const char *events;
+		int nr_events;
+	} table[] = {
+		{
+			.events = "",
+			.nr_events = 0,
+		},
+		{
+			.events = "instructions",
+			.nr_events = 1,
+		},
+		{
+			.events = "instructions,cycles",
+			.nr_events = 2,
+		},
+		{
+			.events = "stereolab",
+			.nr_events = 0,
+		},
+		{
+			.events = "instructions,instructions",
+			.nr_events = 2,
+		},
+		{
+			.events = "stereolab,instructions",
+			.nr_events = 0,
+		},
+		{
+			.events = "instructions,stereolab",
+			.nr_events = 1,
+		},
+	};
+
+	libpfm_initialize();
+
+	for (i = 0; i < ARRAY_SIZE(table); i++) {
+		evlist = evlist__new();
+		if (evlist == NULL)
+			return -ENOMEM;
+
+		opt.value = evlist;
+		parse_libpfm_events_option(&opt,
+					table[i].events,
+					0);
+		TEST_ASSERT_EQUAL(table[i].events,
+				count_pfm_events(&evlist->core),
+				table[i].nr_events);
+		TEST_ASSERT_EQUAL(table[i].events,
+				evlist->nr_groups,
+				0);
+
+		evlist__delete(evlist);
+	}
+	return 0;
+}
+
+static int test__pfm_group(void)
+{
+	struct evlist *evlist;
+	struct option opt;
+	size_t i;
+	const struct {
+		const char *events;
+		int nr_events;
+		int nr_groups;
+	} table[] = {
+		{
+			.events = "{},",
+			.nr_events = 0,
+			.nr_groups = 0,
+		},
+		{
+			.events = "{instructions}",
+			.nr_events = 1,
+			.nr_groups = 1,
+		},
+		{
+			.events = "{instructions},{}",
+			.nr_events = 1,
+			.nr_groups = 1,
+		},
+		{
+			.events = "{},{instructions}",
+			.nr_events = 0,
+			.nr_groups = 0,
+		},
+		{
+			.events = "{instructions},{instructions}",
+			.nr_events = 2,
+			.nr_groups = 2,
+		},
+		{
+			.events = "{instructions,cycles},{instructions,cycles}",
+			.nr_events = 4,
+			.nr_groups = 2,
+		},
+		{
+			.events = "{stereolab}",
+			.nr_events = 0,
+			.nr_groups = 0,
+		},
+		{
+			.events =
+			"{instructions,cycles},{instructions,stereolab}",
+			.nr_events = 3,
+			.nr_groups = 1,
+		},
+	};
+
+	libpfm_initialize();
+
+	for (i = 0; i < ARRAY_SIZE(table); i++) {
+		evlist = evlist__new();
+		if (evlist == NULL)
+			return -ENOMEM;
+
+		opt.value = evlist;
+		parse_libpfm_events_option(&opt,
+					table[i].events,
+					0);
+		TEST_ASSERT_EQUAL(table[i].events,
+				count_pfm_events(&evlist->core),
+				table[i].nr_events);
+		TEST_ASSERT_EQUAL(table[i].events,
+				evlist->nr_groups,
+				table[i].nr_groups);
+
+		evlist__delete(evlist);
+	}
+	return 0;
+}
+#endif
+
+const char *test__pfm_subtest_get_desc(int i)
+{
+	if (i < 0 || i >= (int)ARRAY_SIZE(pfm_testcase_table))
+		return NULL;
+	return pfm_testcase_table[i].desc;
+}
+
+int test__pfm_subtest_get_nr(void)
+{
+	return (int)ARRAY_SIZE(pfm_testcase_table);
+}
+
+int test__pfm(struct test *test __maybe_unused, int i __maybe_unused)
+{
+#ifdef HAVE_LIBPFM
+	if (i < 0 || i >= (int)ARRAY_SIZE(pfm_testcase_table))
+		return TEST_FAIL;
+	return pfm_testcase_table[i].func();
+#else
+	return TEST_SKIP;
+#endif
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 61a1ab032080..47cbae753b42 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -112,6 +112,9 @@ int test__mem2node(struct test *t, int subtest);
 int test__maps__merge_in(struct test *t, int subtest);
 int test__time_utils(struct test *t, int subtest);
 int test__jit_write_elf(struct test *test, int subtest);
+int test__pfm(struct test *test, int subtest);
+const char *test__pfm_subtest_get_desc(int subtest);
+int test__pfm_subtest_get_nr(void);
 
 bool test__bp_signal_is_supported(void);
 bool test__bp_account_is_supported(void);
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index c0cf8dff694e..afd3d2221c83 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -177,6 +177,8 @@ perf-$(CONFIG_LIBBPF) += bpf-event.o
 
 perf-$(CONFIG_CXX) += c++/
 
+perf-$(CONFIG_LIBPFM4) += pfm.o
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_llvm-utils.o += -DPERF_INCLUDE_DIR="BUILD_STR($(perf_include_dir_SQ))"
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d23db6755f51..6ab04b58d2c8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2448,7 +2448,7 @@ bool perf_evsel__fallback(struct evsel *evsel, int err,
 
 		/* Is there already the separator in the name. */
 		if (strchr(name, '/') ||
-		    strchr(name, ':'))
+		    (strchr(name, ':') && !evsel->is_libpfm_event))
 			sep = "";
 
 		if (asprintf(&new_name, "%s%su", name, sep) < 0)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 53187c501ee8..0b6eec714e6f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -76,6 +76,7 @@ struct evsel {
 	bool			ignore_missing_thread;
 	bool			forced_leader;
 	bool			use_uncore_alias;
+	bool			is_libpfm_event;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			sample_read;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 10107747b361..e7e0faf36e3c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -36,6 +36,7 @@
 #include "metricgroup.h"
 #include "util/evsel_config.h"
 #include "util/event.h"
+#include "util/pfm.h"
 
 #define MAX_NAME_LEN 100
 
@@ -344,6 +345,7 @@ static char *get_config_name(struct list_head *head_terms)
 static struct evsel *
 __add_event(struct list_head *list, int *idx,
 	    struct perf_event_attr *attr,
+	    bool init_attr,
 	    char *name, struct perf_pmu *pmu,
 	    struct list_head *config_terms, bool auto_merge_stats,
 	    const char *cpu_list)
@@ -352,7 +354,8 @@ __add_event(struct list_head *list, int *idx,
 	struct perf_cpu_map *cpus = pmu ? pmu->cpus :
 			       cpu_list ? perf_cpu_map__new(cpu_list) : NULL;
 
-	event_attr_init(attr);
+	if (init_attr)
+		event_attr_init(attr);
 
 	evsel = perf_evsel__new_idx(attr, *idx);
 	if (!evsel)
@@ -370,15 +373,25 @@ __add_event(struct list_head *list, int *idx,
 	if (config_terms)
 		list_splice(config_terms, &evsel->config_terms);
 
-	list_add_tail(&evsel->core.node, list);
+	if (list)
+		list_add_tail(&evsel->core.node, list);
+
 	return evsel;
 }
 
+struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
+					char *name, struct perf_pmu *pmu)
+{
+	return __add_event(NULL, &idx, attr, false, name, pmu, NULL, false,
+			   NULL);
+}
+
 static int add_event(struct list_head *list, int *idx,
 		     struct perf_event_attr *attr, char *name,
 		     struct list_head *config_terms)
 {
-	return __add_event(list, idx, attr, name, NULL, config_terms, false, NULL) ? 0 : -ENOMEM;
+	return __add_event(list, idx, attr, true, name, NULL, config_terms,
+			   false, NULL) ? 0 : -ENOMEM;
 }
 
 static int add_event_tool(struct list_head *list, int *idx,
@@ -390,7 +403,8 @@ static int add_event_tool(struct list_head *list, int *idx,
 		.config = PERF_COUNT_SW_DUMMY,
 	};
 
-	evsel = __add_event(list, idx, &attr, NULL, NULL, NULL, false, "0");
+	evsel = __add_event(list, idx, &attr, true, NULL, NULL, NULL, false,
+			    "0");
 	if (!evsel)
 		return -ENOMEM;
 	evsel->tool_event = tool_event;
@@ -1446,8 +1460,8 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 
 	if (!head_config) {
 		attr.type = pmu->type;
-		evsel = __add_event(list, &parse_state->idx, &attr, NULL, pmu, NULL,
-				    auto_merge_stats, NULL);
+		evsel = __add_event(list, &parse_state->idx, &attr, true, NULL,
+				    pmu, NULL, auto_merge_stats, NULL);
 		if (evsel) {
 			evsel->pmu_name = name ? strdup(name) : NULL;
 			evsel->use_uncore_alias = use_uncore_alias;
@@ -1487,7 +1501,7 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 		return -EINVAL;
 	}
 
-	evsel = __add_event(list, &parse_state->idx, &attr,
+	evsel = __add_event(list, &parse_state->idx, &attr, true,
 			    get_config_name(head_config), pmu,
 			    &config_terms, auto_merge_stats, NULL);
 	if (evsel) {
@@ -2794,6 +2808,8 @@ void print_events(const char *event_glob, bool name_only, bool quiet_flag,
 	print_sdt_events(NULL, NULL, name_only);
 
 	metricgroup__print(true, true, NULL, name_only, details_flag);
+
+	print_libpfm_events(name_only, long_desc);
 }
 
 int parse_events__is_hardcoded_term(struct parse_events_term *term)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 27596cbd0ba0..f7f555b1ca35 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,6 +17,7 @@ struct evlist;
 struct parse_events_error;
 
 struct option;
+struct perf_pmu;
 
 struct tracepoint_path {
 	char *system;
@@ -186,6 +187,9 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 			 bool auto_merge_stats,
 			 bool use_alias);
 
+struct evsel *parse_events__add_event(int idx, struct perf_event_attr *attr,
+					char *name, struct perf_pmu *pmu);
+
 int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 			       char *str,
 			       struct list_head **listp);
diff --git a/tools/perf/util/pfm.c b/tools/perf/util/pfm.c
new file mode 100644
index 000000000000..be02683766eb
--- /dev/null
+++ b/tools/perf/util/pfm.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Support for libpfm4 event encoding.
+ *
+ * Copyright 2020 Google LLC.
+ */
+#include "util/cpumap.h"
+#include "util/debug.h"
+#include "util/event.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include "util/parse-events.h"
+#include "util/pmu.h"
+#include "util/pfm.h"
+
+#include <string.h>
+#include <linux/kernel.h>
+#include <perfmon/pfmlib_perf_event.h>
+
+void libpfm_initialize(void)
+{
+	int ret;
+
+	ret = pfm_initialize();
+	if (ret != PFM_SUCCESS) {
+		ui__warning("libpfm failed to initialize: %s\n",
+			pfm_strerror(ret));
+	}
+}
+
+int parse_libpfm_events_option(const struct option *opt, const char *str,
+			int unset __maybe_unused)
+{
+	struct evlist *evlist = *(struct evlist **)opt->value;
+	struct perf_event_attr attr;
+	struct perf_pmu *pmu;
+	struct evsel *evsel, *grp_leader = NULL;
+	char *p, *q, *p_orig;
+	const char *sep;
+	int grp_evt = -1;
+	int ret;
+
+	p_orig = p = strdup(str);
+	if (!p)
+		return -1;
+	/*
+	 * force loading of the PMU list
+	 */
+	perf_pmu__scan(NULL);
+
+	for (q = p; strsep(&p, ",{}"); q = p) {
+		sep = p ? str + (p - p_orig - 1) : "";
+		if (*sep == '{') {
+			if (grp_evt > -1) {
+				ui__error(
+					"nested event groups not supported\n");
+				goto error;
+			}
+			grp_evt++;
+		}
+
+		/* no event */
+		if (*q == '\0')
+			continue;
+
+		memset(&attr, 0, sizeof(attr));
+		event_attr_init(&attr);
+
+		ret = pfm_get_perf_event_encoding(q, PFM_PLM0|PFM_PLM3,
+						&attr, NULL, NULL);
+
+		if (ret != PFM_SUCCESS) {
+			ui__error("failed to parse event %s : %s\n", str,
+				  pfm_strerror(ret));
+			goto error;
+		}
+
+		pmu = perf_pmu__find_by_type((unsigned int)attr.type);
+		evsel = parse_events__add_event(evlist->core.nr_entries,
+						&attr, q, pmu);
+		if (evsel == NULL)
+			goto error;
+
+		evsel->is_libpfm_event = true;
+
+		evlist__add(evlist, evsel);
+
+		if (grp_evt == 0)
+			grp_leader = evsel;
+
+		if (grp_evt > -1) {
+			evsel->leader = grp_leader;
+			grp_leader->core.nr_members++;
+			grp_evt++;
+		}
+
+		if (*sep == '}') {
+			if (grp_evt < 0) {
+				ui__error(
+				   "cannot close a non-existing event group\n");
+				goto error;
+			}
+			evlist->nr_groups++;
+			grp_leader = NULL;
+			grp_evt = -1;
+		}
+	}
+	return 0;
+error:
+	free(p_orig);
+	return -1;
+}
+
+static const char *srcs[PFM_ATTR_CTRL_MAX] = {
+	[PFM_ATTR_CTRL_UNKNOWN] = "???",
+	[PFM_ATTR_CTRL_PMU] = "PMU",
+	[PFM_ATTR_CTRL_PERF_EVENT] = "perf_event",
+};
+
+static void
+print_attr_flags(pfm_event_attr_info_t *info)
+{
+	int n = 0;
+
+	if (info->is_dfl) {
+		printf("[default] ");
+		n++;
+	}
+
+	if (info->is_precise) {
+		printf("[precise] ");
+		n++;
+	}
+
+	if (!n)
+		printf("- ");
+}
+
+static void
+print_libpfm_events_detailed(pfm_event_info_t *info, bool long_desc)
+{
+	pfm_event_attr_info_t ainfo;
+	const char *src;
+	int j, ret;
+
+	ainfo.size = sizeof(ainfo);
+
+	printf("  %s\n", info->name);
+	printf("    [%s]\n", info->desc);
+	if (long_desc) {
+		if (info->equiv)
+			printf("      Equiv: %s\n", info->equiv);
+
+		printf("      Code  : 0x%"PRIx64"\n", info->code);
+	}
+	pfm_for_each_event_attr(j, info) {
+		ret = pfm_get_event_attr_info(info->idx, j,
+					      PFM_OS_PERF_EVENT_EXT, &ainfo);
+		if (ret != PFM_SUCCESS)
+			continue;
+
+		if (ainfo.type == PFM_ATTR_UMASK) {
+			printf("      %s:%s\n", info->name, ainfo.name);
+			printf("        [%s]\n", ainfo.desc);
+		}
+
+		if (!long_desc)
+			continue;
+
+		if (ainfo.ctrl >= PFM_ATTR_CTRL_MAX)
+			ainfo.ctrl = PFM_ATTR_CTRL_UNKNOWN;
+
+		src = srcs[ainfo.ctrl];
+		switch (ainfo.type) {
+		case PFM_ATTR_UMASK:
+			printf("        Umask : 0x%02"PRIx64" : %s: ",
+				ainfo.code, src);
+			print_attr_flags(&ainfo);
+			putchar('\n');
+			break;
+		case PFM_ATTR_MOD_BOOL:
+			printf("      Modif : %s: [%s] : %s (boolean)\n", src,
+				ainfo.name, ainfo.desc);
+			break;
+		case PFM_ATTR_MOD_INTEGER:
+			printf("      Modif : %s: [%s] : %s (integer)\n", src,
+				ainfo.name, ainfo.desc);
+			break;
+		case PFM_ATTR_NONE:
+		case PFM_ATTR_RAW_UMASK:
+		case PFM_ATTR_MAX:
+		default:
+			printf("      Attr  : %s: [%s] : %s\n", src,
+				ainfo.name, ainfo.desc);
+		}
+	}
+}
+
+/*
+ * list all pmu::event:umask, pmu::event
+ * printed events may not be all valid combinations of umask for an event
+ */
+static void
+print_libpfm_events_raw(pfm_pmu_info_t *pinfo, pfm_event_info_t *info)
+{
+	pfm_event_attr_info_t ainfo;
+	int j, ret;
+	bool has_umask = false;
+
+	ainfo.size = sizeof(ainfo);
+
+	pfm_for_each_event_attr(j, info) {
+		ret = pfm_get_event_attr_info(info->idx, j,
+					      PFM_OS_PERF_EVENT_EXT, &ainfo);
+		if (ret != PFM_SUCCESS)
+			continue;
+
+		if (ainfo.type != PFM_ATTR_UMASK)
+			continue;
+
+		printf("%s::%s:%s\n", pinfo->name, info->name, ainfo.name);
+		has_umask = true;
+	}
+	if (!has_umask)
+		printf("%s::%s\n", pinfo->name, info->name);
+}
+
+void print_libpfm_events(bool name_only, bool long_desc)
+{
+	pfm_event_info_t info;
+	pfm_pmu_info_t pinfo;
+	int i, p, ret;
+
+	/* initialize to zero to indicate ABI version */
+	info.size  = sizeof(info);
+	pinfo.size = sizeof(pinfo);
+
+	if (!name_only)
+		putchar('\n');
+
+	pfm_for_all_pmus(p) {
+		bool printed_pmu = false;
+
+		ret = pfm_get_pmu_info(p, &pinfo);
+		if (ret != PFM_SUCCESS)
+			continue;
+
+		/* only print events that are supported by host HW */
+		if (!pinfo.is_present)
+			continue;
+
+		/* handled by perf directly */
+		if (pinfo.pmu == PFM_PMU_PERF_EVENT)
+			continue;
+
+		for (i = pinfo.first_event; i != -1;
+		     i = pfm_get_event_next(i)) {
+
+			ret = pfm_get_event_info(i, PFM_OS_PERF_EVENT_EXT,
+						&info);
+			if (ret != PFM_SUCCESS)
+				continue;
+
+			if (!name_only && !printed_pmu) {
+				printf("%s pfm-events:\n", pinfo.name);
+				printed_pmu = true;
+			}
+
+			if (!name_only)
+				print_libpfm_events_detailed(&info, long_desc);
+			else
+				print_libpfm_events_raw(&pinfo, &info);
+		}
+		if (!name_only && printed_pmu)
+			putchar('\n');
+	}
+}
diff --git a/tools/perf/util/pfm.h b/tools/perf/util/pfm.h
new file mode 100644
index 000000000000..532dafe88bc0
--- /dev/null
+++ b/tools/perf/util/pfm.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Support for libpfm4 event encoding.
+ *
+ * Copyright 2020 Google LLC.
+ */
+#ifndef __PERF_PFM_H
+#define __PERF_PFM_H
+
+#include <subcmd/parse-options.h>
+
+#ifdef HAVE_LIBPFM
+void libpfm_initialize(void);
+
+int parse_libpfm_events_option(const struct option *opt, const char *str,
+			int unset);
+
+void print_libpfm_events(bool name_only, bool long_desc);
+
+#else
+#include <linux/compiler.h>
+
+static inline void libpfm_initialize(void)
+{
+}
+
+static inline int parse_libpfm_events_option(
+	const struct option *opt __maybe_unused,
+	const char *str __maybe_unused,
+	int unset __maybe_unused)
+{
+	return 0;
+}
+
+static inline void print_libpfm_events(bool name_only __maybe_unused,
+				       bool long_desc __maybe_unused)
+{
+}
+
+#endif
+
+
+#endif /* __PERF_PFM_H */
-- 
2.26.1.301.g55bc3eb7cb9-goog

