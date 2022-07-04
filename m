Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6239565913
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbiGDOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiGDOzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:55:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8024C03;
        Mon,  4 Jul 2022 07:55:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843B114BF;
        Mon,  4 Jul 2022 07:55:23 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BFBCA3F792;
        Mon,  4 Jul 2022 07:55:18 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     German Gomez <german.gomez@arm.com>,
        Andrew Kilroy <andrew.kilroy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH 3/8] perf test: Update arm64 tests to expect ptrauth masks
Date:   Mon,  4 Jul 2022 15:53:27 +0100
Message-Id: <20220704145333.22557-4-andrew.kilroy@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704145333.22557-1-andrew.kilroy@arm.com>
References: <20220704145333.22557-1-andrew.kilroy@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: German Gomez <german.gomez@arm.com>

We will request the pointer auth masks in a followup commit, so take the
opportunity to update the relevant tests.

Signed-off-by: German Gomez <german.gomez@arm.com>
Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/perf/tests/attr/README                        |  1 +
 .../tests/attr/test-record-graph-default-aarch64    |  3 ++-
 tools/perf/tests/attr/test-record-graph-dwarf       |  1 +
 .../perf/tests/attr/test-record-graph-dwarf-aarch64 | 13 +++++++++++++
 tools/perf/tests/attr/test-record-graph-fp-aarch64  |  3 ++-
 5 files changed, 19 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/tests/attr/test-record-graph-dwarf-aarch64

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index eb3f7d4bb324..9d7f4646920f 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -47,6 +47,7 @@ Following tests are defined (with perf commands):
   perf record -g kill                           (test-record-graph-default)
   perf record -g kill                           (test-record-graph-default-aarch64)
   perf record --call-graph dwarf kill		(test-record-graph-dwarf)
+  perf record --call-graph dwarf kill		(test-record-graph-dwarf-aarch64)
   perf record --call-graph fp kill              (test-record-graph-fp)
   perf record --call-graph fp kill              (test-record-graph-fp-aarch64)
   perf record --group -e cycles,instructions kill (test-record-group)
diff --git a/tools/perf/tests/attr/test-record-graph-default-aarch64 b/tools/perf/tests/attr/test-record-graph-default-aarch64
index e98d62efb6f7..948d41c162aa 100644
--- a/tools/perf/tests/attr/test-record-graph-default-aarch64
+++ b/tools/perf/tests/attr/test-record-graph-default-aarch64
@@ -5,5 +5,6 @@ ret     = 1
 arch    = aarch64
 
 [event:base-record]
-sample_type=4391
+# handle both with and without ARM64_PTRAUTH
+sample_type=4391|33558823
 sample_regs_user=1073741824
diff --git a/tools/perf/tests/attr/test-record-graph-dwarf b/tools/perf/tests/attr/test-record-graph-dwarf
index ae92061d611d..619bccd886c4 100644
--- a/tools/perf/tests/attr/test-record-graph-dwarf
+++ b/tools/perf/tests/attr/test-record-graph-dwarf
@@ -2,6 +2,7 @@
 command = record
 args    = --no-bpf-event --call-graph dwarf -- kill >/dev/null 2>&1
 ret     = 1
+arch    = !aarch64
 
 [event:base-record]
 sample_type=45359
diff --git a/tools/perf/tests/attr/test-record-graph-dwarf-aarch64 b/tools/perf/tests/attr/test-record-graph-dwarf-aarch64
new file mode 100644
index 000000000000..daec43b39e2e
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-graph-dwarf-aarch64
@@ -0,0 +1,13 @@
+[config]
+command = record
+args    = --no-bpf-event --call-graph dwarf -- kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event:base-record]
+# handle both with and without ARM64_PTRAUTH
+sample_type=45359|33599791
+exclude_callchain_user=1
+sample_stack_user=8192
+sample_regs_user=*
+mmap_data=1
diff --git a/tools/perf/tests/attr/test-record-graph-fp-aarch64 b/tools/perf/tests/attr/test-record-graph-fp-aarch64
index cbeea9971285..bc0880f71e8e 100644
--- a/tools/perf/tests/attr/test-record-graph-fp-aarch64
+++ b/tools/perf/tests/attr/test-record-graph-fp-aarch64
@@ -5,5 +5,6 @@ ret     = 1
 arch    = aarch64
 
 [event:base-record]
-sample_type=4391
+# handle both with and without ARM64_PTRAUTH
+sample_type=4391|33558823
 sample_regs_user=1073741824
-- 
2.17.1

