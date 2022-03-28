Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3F74EA3BE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiC1X26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiC1X2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:28:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2005243ACC
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:27:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h83-20020a25d056000000b0063380d246ceso12043424ybg.3
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wTKe8RpF21rMt2kcDMmTht0LJEvhd7SCLcprAeqvk0k=;
        b=T+4CDrUc5B8KgUxLdGAYIFFTV/O9bYCD2ejWPkf6qr6F1udOCh/a2NQLPEB+f3E/NX
         4TWmJqbMg2E9di4NS0w6fgrYVbAYscM4TtPW15WASNVFdWbW4eNnH2cHi0Ld3Mk1u6l+
         aRkS3ldnET20rnCamLxmrQuXIDBXQDi9UG/NdvJ1h1itQe2WvqFiz/QGC1DXWyZjF8eh
         PZJ43qGpWsndy7U8UxNZkEd4PrX+UBILlb0wU9QU2Qgeh99PvTxAh3LRjkaZxeFHT7GX
         wMFm3Im+nIYQIFbJdUfT4UE0Y7ZyLX7I9IdOPOEvOjJFyVb+ArG5Ui/FgzgqWPqc0er1
         IhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wTKe8RpF21rMt2kcDMmTht0LJEvhd7SCLcprAeqvk0k=;
        b=CImSH5JybDKR0zj2is6T8BXQ/8/KyXn5jwL6MPyVGGLd1Q9osHkwClJNqZNLK63gXr
         Gf5oadVJ8Za0VCdtdgESGkMp0HlM96pLCEMtYaQhA0fRsvOSFWd/04fqtjDWZfMwpYzQ
         oJ0sZUzIaTV0ZJoRKbke8SLCD/Y19vcfLmkvqGzwCUjwJNI/deuTcrbmV/yrZ1Kg5QOU
         QEKJeP9aspJcSD260GL2dtYs7u34aFXnZm+XDbG3PdRGC+jYaJcF3mRvP7jDONdn0dsE
         r11sxfQeYfCoSttPdoVacEIOnril+doExVfbxJ2i2RNe1Ar8aNkGTVrJk0f3zcpq9M3Q
         beqg==
X-Gm-Message-State: AOAM533j26s9MLGKAZBo3/tJsS0B8V+FglUfS6/WJ8RUrOfRYDsPTJEY
        ReX8scx4y4AWJHUfCkGkH9CFDVlRc4xj
X-Google-Smtp-Source: ABdhPJz0C9b/wpARXJ780K4O2sn/803EfldbYME8HRYxuiKm0vuJpVEupKAKTIMkx4gfX2bF+RArPAe9TLyO
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:9d6a:527d:cf46:71e2])
 (user=irogers job=sendgmr) by 2002:a25:5f06:0:b0:633:80e1:6336 with SMTP id
 t6-20020a255f06000000b0063380e16336mr25503992ybb.100.1648510022185; Mon, 28
 Mar 2022 16:27:02 -0700 (PDT)
Date:   Mon, 28 Mar 2022 16:26:46 -0700
In-Reply-To: <20220328232648.2127340-1-irogers@google.com>
Message-Id: <20220328232648.2127340-5-irogers@google.com>
Mime-Version: 1.0
References: <20220328232648.2127340-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 4/6] perf cpumap: More cpu map reuse by merge.
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

perf_cpu_map__merge will reuse one of its arguments if they are equal or
the other argument is NULL. The arguments could be reused if it is known
one set of values is a subset of the other. For example, a map of 0-1
and a map of just 0 when merged yields the map of 0-1. Currently a new
map is created rather than adding a reference count to the original 0-1
map.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/perf/cpumap.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index 23701024e0c0..384d5e076ee4 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -355,17 +355,12 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
 	int i, j, k;
 	struct perf_cpu_map *merged;
 
-	if (!orig && !other)
-		return NULL;
-	if (!orig) {
-		perf_cpu_map__get(other);
-		return other;
-	}
-	if (!other)
-		return orig;
-	if (orig->nr == other->nr &&
-	    !memcmp(orig->map, other->map, orig->nr * sizeof(struct perf_cpu)))
+	if (perf_cpu_map__is_subset(orig, other))
 		return orig;
+	if (perf_cpu_map__is_subset(other, orig)) {
+		perf_cpu_map__put(orig);
+		return perf_cpu_map__get(other);
+	}
 
 	tmp_len = orig->nr + other->nr;
 	tmp_cpus = malloc(tmp_len * sizeof(struct perf_cpu));
-- 
2.35.1.1021.g381101b075-goog

