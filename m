Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7E456591C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiGDO47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiGDO4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:56:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 398EF11A2A;
        Mon,  4 Jul 2022 07:56:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CD2E150C;
        Mon,  4 Jul 2022 07:56:23 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E23E03F792;
        Mon,  4 Jul 2022 07:56:18 -0700 (PDT)
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
Subject: [PATCH 7/8] perf tools: Print ptrauth struct in perf report
Date:   Mon,  4 Jul 2022 15:53:31 +0100
Message-Id: <20220704145333.22557-8-andrew.kilroy@arm.com>
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

This patch prints a perf sample's ptrauth struct so that the PAC masks
can be seen.  To aid debugging.

Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
---
 tools/perf/util/session.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 37f833c3c81b..6b56e638d4dd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1329,6 +1329,13 @@ char *get_page_size_name(u64 size, char *str)
 	return str;
 }
 
+static void ptrauth__printf(struct ptrauth_info *ptrauth)
+{
+	printf(" . ptrauth enabled keys:     0x%016"PRIx64"\n", ptrauth->enabled_keys);
+	printf(" . ptrauth instruction mask: 0x%016"PRIx64"\n", ptrauth->insn_mask);
+	printf(" . ptrauth data mask:        0x%016"PRIx64"\n", ptrauth->data_mask);
+}
+
 static void dump_sample(struct evsel *evsel, union perf_event *event,
 			struct perf_sample *sample, const char *arch)
 {
@@ -1385,6 +1392,14 @@ static void dump_sample(struct evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_READ)
 		sample_read__printf(sample, evsel->core.attr.read_format);
+
+	if (sample_type & PERF_SAMPLE_ARCH_1) {
+		const char *normlzd_arch = perf_env__arch(evsel->evlist->env);
+
+		if (normlzd_arch && strcmp(normlzd_arch, "arm64") == 0)
+			ptrauth__printf(&sample->ptrauth);
+	}
+
 }
 
 static void dump_read(struct evsel *evsel, union perf_event *event)
-- 
2.17.1

