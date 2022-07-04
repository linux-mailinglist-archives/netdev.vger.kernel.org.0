Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1256590B
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiGDOzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiGDOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:55:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30579D98;
        Mon,  4 Jul 2022 07:55:09 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 447C31480;
        Mon,  4 Jul 2022 07:55:09 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 281413F792;
        Mon,  4 Jul 2022 07:55:04 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Andrew Kilroy <andrew.kilroy@arm.com>,
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
Subject: [PATCH 2/8] perf evsel: Do not request ptrauth sample field if not supported
Date:   Mon,  4 Jul 2022 15:53:26 +0100
Message-Id: <20220704145333.22557-3-andrew.kilroy@arm.com>
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

A subsequent patch alters perf to perf_event_open with the
PERF_SAMPLE_ARCH_1 bit on.

This patch deals with the case where the kernel does not know about the
PERF_SAMPLE_ARCH_1 bit, and does not know to send the pointer
authentication masks.  In this case the perf_event_open system call
returns -EINVAL (-22) and perf exits with an error.

This patch causes userspace process to re-attempt the perf_event_open
system call but without asking for the PERF_SAMPLE_ARCH_1 sample
field, allowing the perf_event_open system call to succeed.

The check is placed to disable PERF_SAMPLE_ARCH_1 as the first thing
to do in the try_fallback section of evsel__open_cpu() because it's the
most recent sample field added, so should probably be the first thing to
attempt to turn off.

Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/include/uapi/linux/perf_event.h     |  5 ++++-
 tools/perf/util/evsel.c                   | 19 +++++++++++++++++++
 tools/perf/util/evsel.h                   |  1 +
 tools/perf/util/perf_event_attr_fprintf.c |  2 +-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index d37629dbad72..821bf5ff6a19 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -162,12 +162,15 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_PAGE_SIZE		= 1U << 22,
 	PERF_SAMPLE_CODE_PAGE_SIZE		= 1U << 23,
 	PERF_SAMPLE_WEIGHT_STRUCT		= 1U << 24,
+	PERF_SAMPLE_ARCH_1			= 1U << 25,
 
-	PERF_SAMPLE_MAX = 1U << 25,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 26,		/* non-ABI */
 
 	__PERF_SAMPLE_CALLCHAIN_EARLY		= 1ULL << 63, /* non-ABI; internal use */
 };
 
+#define PERF_SAMPLE_ARM64_PTRAUTH PERF_SAMPLE_ARCH_1
+
 #define PERF_SAMPLE_WEIGHT_TYPE	(PERF_SAMPLE_WEIGHT | PERF_SAMPLE_WEIGHT_STRUCT)
 /*
  * values to program into branch_sample_type when PERF_SAMPLE_BRANCH is set
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ce499c5da8d7..25d8f804f49a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1830,6 +1830,8 @@ static int __evsel__prepare_open(struct evsel *evsel, struct perf_cpu_map *cpus,
 
 static void evsel__disable_missing_features(struct evsel *evsel)
 {
+	if (perf_missing_features.ptrauth)
+		evsel__reset_sample_bit(evsel, ARM64_PTRAUTH);
 	if (perf_missing_features.weight_struct) {
 		evsel__set_sample_bit(evsel, WEIGHT);
 		evsel__reset_sample_bit(evsel, WEIGHT_STRUCT);
@@ -1875,6 +1877,20 @@ int evsel__prepare_open(struct evsel *evsel, struct perf_cpu_map *cpus,
 	return err;
 }
 
+static bool evsel__detect_ptrauth_masks_missing(struct evsel *evsel __maybe_unused)
+{
+#if defined(__aarch64__)
+	if (!perf_missing_features.ptrauth &&
+	    (evsel->core.attr.sample_type & PERF_SAMPLE_ARM64_PTRAUTH)) {
+		perf_missing_features.ptrauth = true;
+		pr_debug2_peo("switching off request for pointer authentication masks\n");
+		return true;
+	}
+#endif
+
+	return false;
+}
+
 bool evsel__detect_missing_features(struct evsel *evsel)
 {
 	/*
@@ -2114,6 +2130,9 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 	return 0;
 
 try_fallback:
+	if (evsel__detect_ptrauth_masks_missing(evsel))
+		goto fallback_missing_features;
+
 	if (evsel__precise_ip_fallback(evsel))
 		goto retry_open;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 73ea48e94079..9690c35088bf 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -188,6 +188,7 @@ struct perf_missing_features {
 	bool data_page_size;
 	bool code_page_size;
 	bool weight_struct;
+	bool ptrauth;
 };
 
 extern struct perf_missing_features perf_missing_features;
diff --git a/tools/perf/util/perf_event_attr_fprintf.c b/tools/perf/util/perf_event_attr_fprintf.c
index 98af3fa4ea35..d18d5f2c6891 100644
--- a/tools/perf/util/perf_event_attr_fprintf.c
+++ b/tools/perf/util/perf_event_attr_fprintf.c
@@ -36,7 +36,7 @@ static void __p_sample_type(char *buf, size_t size, u64 value)
 		bit_name(IDENTIFIER), bit_name(REGS_INTR), bit_name(DATA_SRC),
 		bit_name(WEIGHT), bit_name(PHYS_ADDR), bit_name(AUX),
 		bit_name(CGROUP), bit_name(DATA_PAGE_SIZE), bit_name(CODE_PAGE_SIZE),
-		bit_name(WEIGHT_STRUCT),
+		bit_name(WEIGHT_STRUCT), bit_name(ARCH_1),
 		{ .name = NULL, }
 	};
 #undef bit_name
-- 
2.17.1

