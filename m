Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1894F8DC7
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiDHD7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiDHD6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:58:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C09E5E37
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:56:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s141-20020a257793000000b0063db38a60c4so5783197ybc.1
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 20:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xZ10IcINVF8NaTdbFdZL+w7KjQhTRKJQcz6epMPOOOM=;
        b=J4qvkXu5Auw7V3C2S/vvXFegiHFo9mQHd6ao3pTChQVYX52sQr8dniWFYnHQm0j3st
         bEHb9vfsR+oLWFuAcQDlvK2q3VkZl8tQz1YYKUO4LP7/LugavDcnOzpgkv3zYe6dVZWU
         2gila+WXN4yuqAs0Y/8n5CcZVof5ozNa+BQYvOMd9I5gede5kj5HR53kdkNQRgAduvi9
         GK/7tWnOc6YXNAc8OtiGBNX4Dx9baemHfXsWm3UpV3cEKIbPRr1uTbrXOndoU8gLi5HL
         +EQ8BatF2gFnpVHfijt7yca9E1HUzPitJL5yYGKSHLpDVuWJuUNgZs4nUsNKC2CAMt0X
         qV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xZ10IcINVF8NaTdbFdZL+w7KjQhTRKJQcz6epMPOOOM=;
        b=leSNbWPD0I+lhyLU+y7Sg3IUDdqJ5jEhiqHK19JndnYjKjDapeD9fLuwyP4T01x+sk
         JWIYk73iz7g2Uan2dytK0gHxtXhYxRH1gp/oMEkmLp0rJ7kUQR2zhSz2rDya38rtVGiW
         VAttljv/BHZm7PhP8RqvgD6tjXC1hf8prFAO6Rx3+PybLRDU5/k908FTJZstUpGLnjW2
         5l/ALFJxekEUF/qXhSbMZ4nsWyCBi/T5etQB1yFfQKgWtF3rAm+LlxfG8IVjsn9AJ1yg
         /qJnMr+cXcoMYjSecPxKUbYsxA3/jgHWDFyoT+/wPq/wzc4pu2S4Xe8efDTaGcZRm/l1
         NwwQ==
X-Gm-Message-State: AOAM533w6+R8CON8DBMeaA9L763cxsgp24EZcNuB/6nXF7271r+DozU4
        LYK04zjqRLE5aDAOSL2/MirNWrQ8ndDH
X-Google-Smtp-Source: ABdhPJy+FeSzHm3EOgknn5QLY35sfKLCgJaxnhbi0GFsA4RgFhAgYugNlhNtSIbfmK85JSq7ivRl2ioHGYzK
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:560:aa27:649e:a07d])
 (user=irogers job=sendgmr) by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr11434496ybn.259.1649390193853; Thu, 07
 Apr 2022 20:56:33 -0700 (PDT)
Date:   Thu,  7 Apr 2022 20:56:16 -0700
In-Reply-To: <20220408035616.1356953-1-irogers@google.com>
Message-Id: <20220408035616.1356953-6-irogers@google.com>
Mime-Version: 1.0
References: <20220408035616.1356953-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 5/5] perf test: Combine cpu map tests into 1 suite
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Combine related CPU map tests into 1 suite reducing global state.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/tests/builtin-test.c |  5 +----
 tools/perf/tests/cpumap.c       | 16 ++++++++++++----
 tools/perf/tests/tests.h        |  5 +----
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index dffa41e7ee20..1941ae52e8b6 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -79,16 +79,13 @@ static struct test_suite *generic_tests[] = {
 	&suite__bpf,
 	&suite__thread_map_synthesize,
 	&suite__thread_map_remove,
-	&suite__cpu_map_synthesize,
+	&suite__cpu_map,
 	&suite__synthesize_stat_config,
 	&suite__synthesize_stat,
 	&suite__synthesize_stat_round,
 	&suite__event_update,
 	&suite__event_times,
 	&suite__backward_ring_buffer,
-	&suite__cpu_map_print,
-	&suite__cpu_map_merge,
-	&suite__cpu_map_intersect,
 	&suite__sdt_event,
 	&suite__is_printable_array,
 	&suite__bitmap_print,
diff --git a/tools/perf/tests/cpumap.c b/tools/perf/tests/cpumap.c
index 112331829414..fc124757a082 100644
--- a/tools/perf/tests/cpumap.c
+++ b/tools/perf/tests/cpumap.c
@@ -187,7 +187,15 @@ static int test__cpu_map_intersect(struct test_suite *test __maybe_unused, int s
 	return ret;
 }
 
-DEFINE_SUITE("Synthesize cpu map", cpu_map_synthesize);
-DEFINE_SUITE("Print cpu map", cpu_map_print);
-DEFINE_SUITE("Merge cpu map", cpu_map_merge);
-DEFINE_SUITE("Intersect cpu map", cpu_map_intersect);
+static struct test_case cpu_map_tests[] = {
+	TEST_CASE("Synthesize cpu map", cpu_map_synthesize),
+	TEST_CASE("Print cpu map", cpu_map_print),
+	TEST_CASE("Merge cpu map", cpu_map_merge),
+	TEST_CASE("Intersect cpu map", cpu_map_intersect),
+	{ .name = NULL, }
+};
+
+struct test_suite suite__cpu_map = {
+	.desc = "CPU map",
+	.test_cases = cpu_map_tests,
+};
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index f2823c4859b8..895803fdedc4 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -118,16 +118,13 @@ DECLARE_SUITE(bpf);
 DECLARE_SUITE(session_topology);
 DECLARE_SUITE(thread_map_synthesize);
 DECLARE_SUITE(thread_map_remove);
-DECLARE_SUITE(cpu_map_synthesize);
+DECLARE_SUITE(cpu_map);
 DECLARE_SUITE(synthesize_stat_config);
 DECLARE_SUITE(synthesize_stat);
 DECLARE_SUITE(synthesize_stat_round);
 DECLARE_SUITE(event_update);
 DECLARE_SUITE(event_times);
 DECLARE_SUITE(backward_ring_buffer);
-DECLARE_SUITE(cpu_map_print);
-DECLARE_SUITE(cpu_map_merge);
-DECLARE_SUITE(cpu_map_intersect);
 DECLARE_SUITE(sdt_event);
 DECLARE_SUITE(is_printable_array);
 DECLARE_SUITE(bitmap_print);
-- 
2.35.1.1178.g4f1659d476-goog

