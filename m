Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6682249B251
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344866AbiAYKtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:49:12 -0500
Received: from foss.arm.com ([217.140.110.172]:34102 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355114AbiAYKou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 05:44:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 792DB1FB;
        Tue, 25 Jan 2022 02:44:44 -0800 (PST)
Received: from ip-10-252-15-108.eu-west-1.compute.internal (unknown [10.252.15.108])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9E0813F7D8;
        Tue, 25 Jan 2022 02:44:41 -0800 (PST)
From:   German Gomez <german.gomez@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     irogers@google.com, German Gomez <german.gomez@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] perf test: update arm64 perf_event_attr tests for --call-graph
Date:   Tue, 25 Jan 2022 10:44:34 +0000
Message-Id: <20220125104435.2737-1-german.gomez@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct perf_event_attr is initialised differently in Arm64 when
recording in call-graph fp mode, so update the relevant tests, and add
two extra arm64-only tests.

Fixes: 7248e308a575 ("perf tools: Record ARM64 LR register automatically")
Signed-off-by: German Gomez <german.gomez@arm.com>
---
 tools/perf/tests/attr/README                            | 2 ++
 tools/perf/tests/attr/test-record-graph-default         | 2 ++
 tools/perf/tests/attr/test-record-graph-default-aarch64 | 9 +++++++++
 tools/perf/tests/attr/test-record-graph-fp              | 2 ++
 tools/perf/tests/attr/test-record-graph-fp-aarch64      | 9 +++++++++
 5 files changed, 24 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-graph-default-aarch64
 create mode 100644 tools/perf/tests/attr/test-record-graph-fp-aarch64

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index a36f49fb4dbe..1116fc6bf2ac 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -45,8 +45,10 @@ Following tests are defined (with perf commands):
   perf record -d kill                           (test-record-data)
   perf record -F 100 kill                       (test-record-freq)
   perf record -g kill                           (test-record-graph-default)
+  perf record -g kill                           (test-record-graph-default-aarch64)
   perf record --call-graph dwarf kill		(test-record-graph-dwarf)
   perf record --call-graph fp kill              (test-record-graph-fp)
+  perf record --call-graph fp kill              (test-record-graph-fp-aarch64)
   perf record --group -e cycles,instructions kill (test-record-group)
   perf record -e '{cycles,instructions}' kill   (test-record-group1)
   perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
diff --git a/tools/perf/tests/attr/test-record-graph-default b/tools/perf/tests/attr/test-record-graph-default
index 5d8234d50845..f0a18b4ea4f5 100644
--- a/tools/perf/tests/attr/test-record-graph-default
+++ b/tools/perf/tests/attr/test-record-graph-default
@@ -2,6 +2,8 @@
 command = record
 args    = --no-bpf-event -g kill >/dev/null 2>&1
 ret     = 1
+# arm64 enables registers in the default mode (fp)
+arch    = !aarch64
 
 [event:base-record]
 sample_type=295
diff --git a/tools/perf/tests/attr/test-record-graph-default-aarch64 b/tools/perf/tests/attr/test-record-graph-default-aarch64
new file mode 100644
index 000000000000..e98d62efb6f7
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-default-aarch64
@@ -0,0 +1,9 @@
+[config]
+command = record
+args    = --no-bpf-event -g kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event:base-record]
+sample_type=4391
+sample_regs_user=1073741824
diff --git a/tools/perf/tests/attr/test-record-graph-fp b/tools/perf/tests/attr/test-record-graph-fp
index 5630521c0b0f..a6e60e839205 100644
--- a/tools/perf/tests/attr/test-record-graph-fp
+++ b/tools/perf/tests/attr/test-record-graph-fp
@@ -2,6 +2,8 @@
 command = record
 args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
 ret     = 1
+# arm64 enables registers in fp mode
+arch    = !aarch64
 
 [event:base-record]
 sample_type=295
diff --git a/tools/perf/tests/attr/test-record-graph-fp-aarch64 b/tools/perf/tests/attr/test-record-graph-fp-aarch64
new file mode 100644
index 000000000000..cbeea9971285
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-fp-aarch64
@@ -0,0 +1,9 @@
+[config]
+command = record
+args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event:base-record]
+sample_type=4391
+sample_regs_user=1073741824
-- 
2.25.1

