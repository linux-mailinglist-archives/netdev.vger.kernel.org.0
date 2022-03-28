Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954754E8E14
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiC1G0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiC1G0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:26:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF8751E6F
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e4-20020a056902034400b00633691534d5so10158843ybs.7
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YAhIdIX1NbY8GJ/Fxc7tPQp5MnsWrJ6b1ZKA2cSf7J0=;
        b=BmBfuq5dDJ8FyY++eKZzoNfnofz30yeVLbgg6C06RDaHI+2/on7h2TcF3d5wM4fa4v
         4bk4KMagZlk4nj19qtiaEbo1M4KSqHCCoSG28PmBhOeZ55PNWY+H93zGymXKK5231X2m
         KZtd7Vd97HDsSx/TyGhWx0qCCkgggvpS4Beh5fSGE8tfMMFU8D1fm5/iLShTGjpys2a+
         Ro5/rm+LPdNcLq+0L3HrEDbV5NW1nCqM4h+PDD0jVJ0KBaAHhCIuNar/9RgYSjRjtnLL
         aT1mG0BBsu3ZXQTCANlrv09w07cbBxpDrXfARHxCKPef7Jb7jNIUufL44QKXW6flpj3O
         tNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YAhIdIX1NbY8GJ/Fxc7tPQp5MnsWrJ6b1ZKA2cSf7J0=;
        b=3mMb6CTeetr0PwE/KYahRK06oyf28HbJadu6tFyh8Ll+QclmvLl2FO53U51OGCIjJ1
         egMcgIhlmnguBtFKPChhl6KLsfZso8NKes8rTnglAFRpFC8r25rNfyGRLcut4WBNB8rI
         kJ5EhBKsp+44/kZ2Q+mQ6sNZVVrze97VJMPUKH1b5X0RkTdEh+Mqu8LCJeBNS7eGhcK5
         iIYVd0nYMg+l4aQQIpbHPgFsL5Yi0qQOlYtZJtC55/o5g4vdtuO7WAtA6SYnHnKjhoVq
         y9M0pvZNSFqW5HRYtqmAkybDSXY/5NSWb8KZHea5UUBYkdpCkLHPGzzmQu1SBKS++byW
         kTSw==
X-Gm-Message-State: AOAM530pvtZKXrVRDiBGi5NocFRqlCkZI/aimqMyFGaZ3HmtqI9j6nJM
        bhoDI4Mo/ZJZlM5PktVSvsL7xggjrLZj
X-Google-Smtp-Source: ABdhPJzgJ3tnHPRL/ZoEIaIEfGlgiRAfkH5m8p1TAIooj8UqZqfQygDqtd6JOglW1lVfIhZfwaS+hnJN01ZZ
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:ef08:ed1b:261f:77fa])
 (user=irogers job=sendgmr) by 2002:a05:6902:124e:b0:634:619e:4114 with SMTP
 id t14-20020a056902124e00b00634619e4114mr21938385ybu.181.1648448667764; Sun,
 27 Mar 2022 23:24:27 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:24:12 -0700
In-Reply-To: <20220328062414.1893550-1-irogers@google.com>
Message-Id: <20220328062414.1893550-4-irogers@google.com>
Mime-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 3/5] perf cpumap: Add intersect function.
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
        autolearn=ham autolearn_force=no version=3.4.6
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
index 953bc50b0e41..56b4d213039f 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -393,3 +393,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
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

