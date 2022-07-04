Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48056590E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiGDOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiGDOzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:55:42 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5DBCEE3F;
        Mon,  4 Jul 2022 07:55:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C28BA150C;
        Mon,  4 Jul 2022 07:55:39 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8CF6F3F792;
        Mon,  4 Jul 2022 07:55:35 -0700 (PDT)
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
Subject: [PATCH 4/8] perf tools: arm64: Read ptrauth data from kernel
Date:   Mon,  4 Jul 2022 15:53:28 +0100
Message-Id: <20220704145333.22557-5-andrew.kilroy@arm.com>
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

This patch alters the userspace perf program to request the
pointer authentication code masks using the PERF_SAMPLE_ARCH_1 sample
field and write the data to perf.data file.

A subsequent commit will make use of the masks in the data file to do
the unwinding.

Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/perf/tests/sample-parsing.c |  2 +-
 tools/perf/util/event.h           |  8 ++++++
 tools/perf/util/evsel.c           | 45 +++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 07f2411b0ad4..dd78ca279c01 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -381,7 +381,7 @@ static int test__sample_parsing(struct test_suite *test __maybe_unused, int subt
 	 * were added.  Please actually update the test rather than just change
 	 * the condition below.
 	 */
-	if (PERF_SAMPLE_MAX > PERF_SAMPLE_WEIGHT_STRUCT << 1) {
+	if (PERF_SAMPLE_MAX > PERF_SAMPLE_ARCH_1 << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
 		return -1;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cdd72e05fd28..b99fc81dd37e 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -128,6 +128,13 @@ struct aux_sample {
 	void *data;
 };
 
+
+struct ptrauth_info {
+	u64 enabled_keys;  // arm64 ptrauth is in use if this is non-zero.
+	u64 insn_mask;
+	u64 data_mask;
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -163,6 +170,7 @@ struct perf_sample {
 	struct stack_dump user_stack;
 	struct sample_read read;
 	struct aux_sample aux_sample;
+	struct ptrauth_info ptrauth;
 };
 
 #define PERF_MEM_DATA_SRC_NONE \
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 25d8f804f49a..4627a68a7797 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -887,8 +887,22 @@ static void __evsel__config_callchain(struct evsel *evsel, struct record_opts *o
 				    "Falling back to framepointers.\n");
 	}
 
+#if defined(__aarch64__)
+	/*
+	 * We need to set ARM64_PTRAUTH in FP mode so that b9f6fbb3b2c2 ("perf arm64: Inject missing
+	 * frames when using 'perf record --call-graph=fp'") continues to work in the presence of
+	 * PACs.
+	 */
+	if (param->record_mode == CALLCHAIN_FP)
+		evsel__set_sample_bit(evsel, ARM64_PTRAUTH);
+
+#endif
+
 	if (param->record_mode == CALLCHAIN_DWARF) {
 		if (!function) {
+#if defined(__aarch64__)
+			evsel__set_sample_bit(evsel, ARM64_PTRAUTH);
+#endif
 			evsel__set_sample_bit(evsel, REGS_USER);
 			evsel__set_sample_bit(evsel, STACK_USER);
 			if (opts->sample_user_regs && DWARF_MINIMAL_REGS != PERF_REGS_MASK) {
@@ -2344,6 +2358,17 @@ u64 evsel__bitfield_swap_branch_flags(u64 value)
 	return new_val;
 }
 
+/*
+ * To return the normalised arch that is recorded in a perf.data file
+ */
+static const char *recorded_normalized_arch(struct evsel *evsel)
+{
+	if (evsel && evsel->evlist && evsel->evlist->env)
+		return perf_env__arch(evsel->evlist->env);
+	else
+		return NULL;
+}
+
 int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			struct perf_sample *data)
 {
@@ -2681,6 +2706,26 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 		array = (void *)array + sz;
 	}
 
+	if (type & PERF_SAMPLE_ARCH_1) {
+		const char *normlzd_arch = recorded_normalized_arch(evsel);
+
+		if (normlzd_arch)
+			pr_debug4("PERF_SAMPLE_ARCH_1 is on, detected recorded arch as %s\n", normlzd_arch);
+		else
+			pr_debug4("PERF_SAMPLE_ARCH_1 is on, but arch not detected\n");
+
+		if (normlzd_arch && strcmp(normlzd_arch, "arm64") == 0) {
+			OVERFLOW_CHECK(array, 3 * sizeof(u64), max_size);
+
+			data->ptrauth.enabled_keys = *array;
+			array++;
+			data->ptrauth.insn_mask = *array;
+			array++;
+			data->ptrauth.data_mask = *array;
+			array++;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1

