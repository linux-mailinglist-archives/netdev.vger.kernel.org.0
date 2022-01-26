Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18D249CF35
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiAZQHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:07:35 -0500
Received: from foss.arm.com ([217.140.110.172]:50036 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236823AbiAZQHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 11:07:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CED85D6E;
        Wed, 26 Jan 2022 08:07:33 -0800 (PST)
Received: from ip-10-252-15-108.eu-west-1.compute.internal (unknown [10.252.15.108])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8151C3F766;
        Wed, 26 Jan 2022 08:07:31 -0800 (PST)
From:   German Gomez <german.gomez@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     German Gomez <german.gomez@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] perf test: Add perf_event_attr tests for the arm_spe event
Date:   Wed, 26 Jan 2022 16:07:09 +0000
Message-Id: <20220126160710.32983-1-german.gomez@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a couple of perf_event_attr tests for the fix introduced in [1].
The tests check that the correct sample_period value is set in the
struct perf_event_attr of the arm_spe events.

[1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/

Signed-off-by: German Gomez <german.gomez@arm.com>
---
 tools/perf/tests/attr/README                  |  2 +
 tools/perf/tests/attr/base-record-spe         | 40 +++++++++++++++++++
 tools/perf/tests/attr/test-record-spe-period  | 12 ++++++
 .../tests/attr/test-record-spe-period-term    | 12 ++++++
 4 files changed, 66 insertions(+)
 create mode 100644 tools/perf/tests/attr/base-record-spe
 create mode 100644 tools/perf/tests/attr/test-record-spe-period
 create mode 100644 tools/perf/tests/attr/test-record-spe-period-term

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index 1116fc6bf2ac..454505d343fa 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -58,6 +58,8 @@ Following tests are defined (with perf commands):
   perf record -c 100 -P kill                    (test-record-period)
   perf record -c 1 --pfm-events=cycles:period=2 (test-record-pfm-period)
   perf record -R kill                           (test-record-raw)
+  perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
+  perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
   perf stat -e cycles kill                      (test-stat-basic)
   perf stat kill                                (test-stat-default)
   perf stat -d kill                             (test-stat-detailed-1)
diff --git a/tools/perf/tests/attr/base-record-spe b/tools/perf/tests/attr/base-record-spe
new file mode 100644
index 000000000000..08fa96b59240
--- /dev/null
+++ b/tools/perf/tests/attr/base-record-spe
@@ -0,0 +1,40 @@
+[event]
+fd=*
+group_fd=-1
+flags=*
+cpu=*
+type=*
+size=*
+config=*
+sample_period=*
+sample_type=*
+read_format=*
+disabled=*
+inherit=*
+pinned=*
+exclusive=*
+exclude_user=*
+exclude_kernel=*
+exclude_hv=*
+exclude_idle=*
+mmap=*
+comm=*
+freq=*
+inherit_stat=*
+enable_on_exec=*
+task=*
+watermark=*
+precise_ip=*
+mmap_data=*
+sample_id_all=*
+exclude_host=*
+exclude_guest=*
+exclude_callchain_kernel=*
+exclude_callchain_user=*
+wakeup_events=*
+bp_type=*
+config1=*
+config2=*
+branch_sample_type=*
+sample_regs_user=*
+sample_stack_user=*
diff --git a/tools/perf/tests/attr/test-record-spe-period b/tools/perf/tests/attr/test-record-spe-period
new file mode 100644
index 000000000000..75f8c9cd8e3f
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-spe-period
@@ -0,0 +1,12 @@
+[config]
+command = record
+args    = --no-bpf-event -c 2 -e arm_spe_0// -- kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event-10:base-record-spe]
+sample_period=2
+freq=0
+
+# dummy event
+[event-1:base-record-spe]
diff --git a/tools/perf/tests/attr/test-record-spe-period-term b/tools/perf/tests/attr/test-record-spe-period-term
new file mode 100644
index 000000000000..8f60a4fec657
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-spe-period-term
@@ -0,0 +1,12 @@
+[config]
+command = record
+args    = --no-bpf-event -e arm_spe_0/period=3/ -- kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event-10:base-record-spe]
+sample_period=3
+freq=0
+
+# dummy event
+[event-1:base-record-spe]
-- 
2.25.1

