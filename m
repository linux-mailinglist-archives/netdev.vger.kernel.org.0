Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884604EA3B3
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiC1X25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiC1X2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:28:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C2F5A0BB
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:27:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d2d45c0df7so131144687b3.1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HI7lVdFOSrlQd5wT9t/SBLu67RK0OyhqHS+mLTojDoE=;
        b=OOfLyxjdfGI/Zzi87JL87OQfMszCNTUskyTB3iTykwAXRjAEpDXIS+voGrvIAZfDpR
         Epwup6CsDlPPO2kU6QMzOn0Epm3iM+kImr6kf8OxgLNzzbnruKyXgm/LeewSSA3k0yqp
         favmnY4DSQkIBaEiZz6q5NwUzkwJ78hb2Y4huCXqqEqyWjpOuVAB67CcxkD9vdR/hOfJ
         1u2AhCfGi1Mi+uCrQi8MiQH9uaS7hzSH+fiRw0fJ6TwTPMsnj4O6XGGzZLMpkd9BNXO9
         fGG+9nyuNkcRx+Dxg1AF6oDiL2h9rmOclzepyuG1ulyjca+zHJxSTl+seEh1kjNQXI3I
         S4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HI7lVdFOSrlQd5wT9t/SBLu67RK0OyhqHS+mLTojDoE=;
        b=Y2U/e43MRPxNImAScf8WZKYFdWbvjx6vqxY+NIx4DJi54l3jWR3XTjbyvNPoTQVIdF
         7ATbhA7GONW8ki5p40qEmKJ+t9ryMYHMfDveGo/DUPdRcvRlUWuzGvly3hVDxENe5Ej8
         gpQXXZ1KODCnb7najJlunNo8WOMD8rS8ZBWwQ6QG0BezNjzXdL316BLvtKFtNDrPeGD8
         dluevIW0X7Ucgh3imjrshHMBeKQKmqdYNoUCutmCC7/h+fVSWPJxR1ajvP9lUAfLhry6
         zT23lMWta/QW/G47SCEk6bWYDHFDFOTtqzg6wB0TkJw0Y76RZQMVhX7NwgWcBNYfB+Nn
         EHMQ==
X-Gm-Message-State: AOAM531nfTW2/H6qyiDLMX6VIm0R/GUdZ9iOyJn8mdi8WzEoOQ76rUIH
        WzjTYdGcG384bTY8FpZFKnTbhxx+wFcP
X-Google-Smtp-Source: ABdhPJxq3SawZ28lJ97d+m1B27jGZL3+ADhO9V4EPLQfdWt+wZImHtVrn+mTGk9KAcNNkDb7tpvSE9m8TcX9
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:9d6a:527d:cf46:71e2])
 (user=irogers job=sendgmr) by 2002:a05:6902:241:b0:633:d3e1:ff5e with SMTP id
 k1-20020a056902024100b00633d3e1ff5emr25241467ybs.625.1648510024506; Mon, 28
 Mar 2022 16:27:04 -0700 (PDT)
Date:   Mon, 28 Mar 2022 16:26:47 -0700
In-Reply-To: <20220328232648.2127340-1-irogers@google.com>
Message-Id: <20220328232648.2127340-6-irogers@google.com>
Mime-Version: 1.0
References: <20220328232648.2127340-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 5/6] perf cpumap: Add intersect function.
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
 tools/lib/perf/cpumap.c              | 38 ++++++++++++++++++++++++++++
 tools/lib/perf/include/perf/cpumap.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index 384d5e076ee4..60cccd05f243 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -390,3 +390,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
 	perf_cpu_map__put(orig);
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
+		return orig;
+	if (perf_cpu_map__is_subset(orig, other)) {
+		perf_cpu_map__put(orig);
+		return perf_cpu_map__get(other);
+	}
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
+	perf_cpu_map__put(orig);
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
-- 
2.35.1.1021.g381101b075-goog

