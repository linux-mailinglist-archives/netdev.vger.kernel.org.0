Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB934F8ECB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiDHD7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiDHD6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:58:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB9DE1252
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:56:30 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb58f605aeso66054557b3.0
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 20:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WQySeKYeF44ltZobAOk7xNxuZcXMSl5HKLY3fUam6qQ=;
        b=hDSKG5yrND2PToJM4rKnqeJ62RcJGj0+ro5piw+CTfoTTw5cN0QF1P7O2M+7Pw/a2k
         L6jGvSd8QXVOEbBvp6N5WG9Qr2H3iF39h92XQRS14ohnfaZbdVAJkkC75h2N+su/IKoM
         fAs5tI8ZTlGVVORECCu57iLTSg7bB7hVyc0eos9SWzxzbfIa9pxVIPJMNcFMi1Kq4NlX
         1xl/v4pATsxUxOkH77mZmhsu7yQpboO/1uk2drOLg2nCdjjUlESDDxlYYYgn0+7Z0Bqf
         34wk3XU7U7sGptA96+apazLcWfA1zaTpmsPavxFg0RjKW6xb36/MyhRG0CGN6ETslOXO
         qIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WQySeKYeF44ltZobAOk7xNxuZcXMSl5HKLY3fUam6qQ=;
        b=muOVT0I4iiOD3X3n2CRALTmtm079BySQNRQXjr+ORKaRa3r0N8fTPq5l03KXfNTJXo
         9KcEuNcQXS4TnFemCswBR3dUsP6Ek4WQXD2+YcnhiR5AjQ8MhIqj+XD26Kl+J/ADUvq3
         89psQ3f1jtQoL+NvUasNE4GhybS9G75gGK5jv465OzJvEEbJGWtAbz+uh+iSnrIz39eB
         w0/WQY0demNCO9NEJMrpdrACzFf3869ugLZKN7wK/yFy53WytRZFuZIxolqrEkJIfdTu
         AxWlalcl9yWB6qIuaNhOSdEg1pxh40sXNamdy+ZkwtosBBWr0j7Spg2xDSoXs4CdkqZV
         SguA==
X-Gm-Message-State: AOAM530TZu1TqOP+oLrnmjJiyeV77wW9g0Zf2M6Nu3bH/2XixQ0xK7Re
        2XAWTzYvdFjyYKIS0Kt2/+tYwGdCtKU6
X-Google-Smtp-Source: ABdhPJxUah9zZN5gVulVQKHMKAB9PrsIvEpYDGhc34fesgAhXN4h148IRiOkJNKasQpmJrMLd6NQV31cTvDt
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:560:aa27:649e:a07d])
 (user=irogers job=sendgmr) by 2002:a25:e811:0:b0:63d:b0e1:c78 with SMTP id
 k17-20020a25e811000000b0063db0e10c78mr12871250ybd.195.1649390189216; Thu, 07
 Apr 2022 20:56:29 -0700 (PDT)
Date:   Thu,  7 Apr 2022 20:56:14 -0700
In-Reply-To: <20220408035616.1356953-1-irogers@google.com>
Message-Id: <20220408035616.1356953-4-irogers@google.com>
Mime-Version: 1.0
References: <20220408035616.1356953-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 3/5] perf cpumap: Add intersect function.
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

The merge function gives the union of two cpu maps. Add an intersect
function which will be used in the next change.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/perf/cpumap.c              | 35 ++++++++++++++++++++++++++++
 tools/lib/perf/include/perf/cpumap.h |  2 ++
 tools/perf/tests/builtin-test.c      |  1 +
 tools/perf/tests/cpumap.c            | 35 ++++++++++++++++++++++++++++
 tools/perf/tests/tests.h             |  1 +
 5 files changed, 74 insertions(+)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index 95c56e17241b..66371135e742 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -385,3 +385,38 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
 	free(tmp_cpus);
 	return merged;
 }
+
+struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
+					     struct perf_cpu_map *other)
+{
+	struct perf_cpu *tmp_cpus;
+	int tmp_len;
+	int i, j, k;
+	struct perf_cpu_map *merged = NULL;
+
+	if (perf_cpu_map__is_subset(other, orig))
+		return perf_cpu_map__get(orig);
+	if (perf_cpu_map__is_subset(orig, other))
+		return perf_cpu_map__get(other);
+
+	tmp_len = max(orig->nr, other->nr);
+	tmp_cpus = malloc(tmp_len * sizeof(struct perf_cpu));
+	if (!tmp_cpus)
+		return NULL;
+
+	i = j = k = 0;
+	while (i < orig->nr && j < other->nr) {
+		if (orig->map[i].cpu < other->map[j].cpu)
+			i++;
+		else if (orig->map[i].cpu > other->map[j].cpu)
+			j++;
+		else {
+			j++;
+			tmp_cpus[k++] = orig->map[i++];
+		}
+	}
+	if (k)
+		merged = cpu_map__trim_new(k, tmp_cpus);
+	free(tmp_cpus);
+	return merged;
+}
diff --git a/tools/lib/perf/include/perf/cpumap.h b/tools/lib/perf/include/perf/cpumap.h
index 4a2edbdb5e2b..a2a7216c0b78 100644
--- a/tools/lib/perf/include/perf/cpumap.h
+++ b/tools/lib/perf/include/perf/cpumap.h
@@ -19,6 +19,8 @@ LIBPERF_API struct perf_cpu_map *perf_cpu_map__read(FILE *file);
 LIBPERF_API struct perf_cpu_map *perf_cpu_map__get(struct perf_cpu_map *map);
 LIBPERF_API struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
 						     struct perf_cpu_map *other);
+LIBPERF_API struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
+							 struct perf_cpu_map *other);
 LIBPERF_API void perf_cpu_map__put(struct perf_cpu_map *map);
 LIBPERF_API struct perf_cpu perf_cpu_map__cpu(const struct perf_cpu_map *cpus, int idx);
 LIBPERF_API int perf_cpu_map__nr(const struct perf_cpu_map *cpus);
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index fac3717d9ba1..dffa41e7ee20 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -88,6 +88,7 @@ static struct test_suite *generic_tests[] = {
 	&suite__backward_ring_buffer,
 	&suite__cpu_map_print,
 	&suite__cpu_map_merge,
+	&suite__cpu_map_intersect,
 	&suite__sdt_event,
 	&suite__is_printable_array,
 	&suite__bitmap_print,
diff --git a/tools/perf/tests/cpumap.c b/tools/perf/tests/cpumap.c
index 3b9fc549d30b..112331829414 100644
--- a/tools/perf/tests/cpumap.c
+++ b/tools/perf/tests/cpumap.c
@@ -153,6 +153,41 @@ static int test__cpu_map_merge(struct test_suite *test __maybe_unused, int subte
 	return ret;
 }
 
+static int __test__cpu_map_intersect(const char *lhs, const char *rhs, int nr, const char *expected)
+{
+	struct perf_cpu_map *a = perf_cpu_map__new(lhs);
+	struct perf_cpu_map *b = perf_cpu_map__new(rhs);
+	struct perf_cpu_map *c = perf_cpu_map__intersect(a, b);
+	char buf[100];
+
+	TEST_ASSERT_EQUAL("failed to intersect map: bad nr", perf_cpu_map__nr(c), nr);
+	cpu_map__snprint(c, buf, sizeof(buf));
+	TEST_ASSERT_VAL("failed to intersect map: bad result", !strcmp(buf, expected));
+	perf_cpu_map__put(a);
+	perf_cpu_map__put(b);
+	perf_cpu_map__put(c);
+	return 0;
+}
+
+static int test__cpu_map_intersect(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+{
+	int ret;
+
+	ret = __test__cpu_map_intersect("4,2,1", "4,5,7", 1, "4");
+	if (ret) return ret;
+	ret = __test__cpu_map_intersect("1-8", "6-9", 3, "6-8");
+	if (ret) return ret;
+	ret = __test__cpu_map_intersect("1-8,12-20", "6-9,15", 4, "6-8,15");
+	if (ret) return ret;
+	ret = __test__cpu_map_intersect("4,2,1", "1", 1, "1");
+	if (ret) return ret;
+	ret = __test__cpu_map_intersect("1", "4,2,1", 1, "1");
+	if (ret) return ret;
+	ret = __test__cpu_map_intersect("1", "1", 1, "1");
+	return ret;
+}
+
 DEFINE_SUITE("Synthesize cpu map", cpu_map_synthesize);
 DEFINE_SUITE("Print cpu map", cpu_map_print);
 DEFINE_SUITE("Merge cpu map", cpu_map_merge);
+DEFINE_SUITE("Intersect cpu map", cpu_map_intersect);
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5bbb8f6a48fc..f2823c4859b8 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -127,6 +127,7 @@ DECLARE_SUITE(event_times);
 DECLARE_SUITE(backward_ring_buffer);
 DECLARE_SUITE(cpu_map_print);
 DECLARE_SUITE(cpu_map_merge);
+DECLARE_SUITE(cpu_map_intersect);
 DECLARE_SUITE(sdt_event);
 DECLARE_SUITE(is_printable_array);
 DECLARE_SUITE(bitmap_print);
-- 
2.35.1.1178.g4f1659d476-goog

