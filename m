Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EDA4EA3AE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiC1X2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiC1X2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:28:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682E027CD1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:26:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x9-20020a5b0809000000b00631d9edfb96so11922449ybp.22
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YjjZotq4RCxi1HEGt8XYTGKtlbxI8vX9wo23gAEItRk=;
        b=iHXjgH4UzFDWEG0VHQDrhIabSELk0bK1+ReWsLVjckUkLaaZk1/SR1Dm/fmDU/EGQ5
         n6XbhQwEbI5NhrZ3ERc7lqctlyLWj9GiSVc1uMpwLlG/gugGDBG+ZPCRO9tT2ACHtol4
         UtKOlHUM7PAHHtQQJtLe+J/nJDwTlbySOP0rsk1VpKIYBztcZ/KzpzNdYsPVLi0ca936
         TTymvZNYzc5cLvDYHXTP7amxRu8GbWPq/odwhZ/OSWuf10gChn09zIeQwezhicl02gyw
         OM7ZA+J5x0DikEYrxOWl6iyKUuRcWvxFYOBWsR+U9FQNPDa9WjrkdDV6tp00cunKv26W
         CoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YjjZotq4RCxi1HEGt8XYTGKtlbxI8vX9wo23gAEItRk=;
        b=5nT4nOAVloI6qYg6qGd1vG6wIfLdniLF69JF8ilxcPovPHq+pkV4devmUHocnwZZZD
         d5n+5BXo1PRjPjXRana2xIXowRSgvO2DbBDfnWvI0lpino4j/vWXea6IS+D0Jvm7xNS9
         KKR7dLv02ySAQ0Ugyp5qUae68GAHtU/1FcKrYqFq4W9dL4/nOuc4zjQt0XCy3uMHs6Uj
         td2GIHimSuZJq3x5OtVqg/XARIp1WdT+WkhqDft7F847tMuhDbz09rfEvYuyizW1EZQP
         Kjp9qeiDk37YqHHBjZWr2E9N/rL53M6tBi5fEycTFCjuqhr/qFHKgS3o1lqDARD00kTW
         9Jdw==
X-Gm-Message-State: AOAM5319NILc88BuGd3G9QU/DLxpEktAbzU3h1Pb1OANOtTVxy3xmCIW
        PCTEOkXJKAmAhgiEx4SJUKJE2HTy42Yx
X-Google-Smtp-Source: ABdhPJxVFhSI4U7NuLu+ZUaT4BpRjxW9SfXEvu4f1Ek8WdduDSegs7W19jH9xH8Bes9Ma1a3gJwRe2risubi
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:9d6a:527d:cf46:71e2])
 (user=irogers job=sendgmr) by 2002:a25:32cc:0:b0:633:c9ed:9e1a with SMTP id
 y195-20020a2532cc000000b00633c9ed9e1amr25234403yby.179.1648510012493; Mon, 28
 Mar 2022 16:26:52 -0700 (PDT)
Date:   Mon, 28 Mar 2022 16:26:42 -0700
Message-Id: <20220328232648.2127340-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 0/6] Make evlist CPUs more accurate
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

evlist has all_cpus, computed to be the merge of all evsel CPU maps,
and cpus. cpus may contain more CPUs than all_cpus, as by default cpus
holds all online CPUs whilst all_cpus holds the merge/union from
evsels. For an uncore event there may just be 1 CPU per socket, which
will be a far smaller CPU map than all online CPUs.

These patches change cpus to be called user_requested_cpus, to reflect
their potential user specified nature. The user_requested_cpus are set
to be the current value intersected with all_cpus, so that
user_requested_cpus is always a subset of all_cpus. This fixes
printing code for metrics so that unnecessary blank lines aren't
printed.

To make the intersect function perform well, a perf_cpu_map__is_subset
function is added. While adding this function, also use it in
perf_cpu_map__merge to avoid creating a new CPU map for some currently
missed patterns.

v2. Reorders the "Avoid segv" patch and makes other adjustments
    suggested by Arnaldo Carvalho de Melo <acme@kernel.org>.

Ian Rogers (6):
  perf stat: Avoid segv if core.user_cpus isn't set.
  perf evlist: Rename cpus to user_requested_cpus
  perf cpumap: Add is_subset function
  perf cpumap: More cpu map reuse by merge.
  perf cpumap: Add intersect function.
  perf evlist: Respect all_cpus when setting user_requested_cpus

 tools/lib/perf/cpumap.c                  | 73 ++++++++++++++++++++----
 tools/lib/perf/evlist.c                  | 28 ++++-----
 tools/lib/perf/include/internal/cpumap.h |  1 +
 tools/lib/perf/include/internal/evlist.h |  7 ++-
 tools/lib/perf/include/perf/cpumap.h     |  2 +
 tools/perf/arch/arm/util/cs-etm.c        |  8 +--
 tools/perf/arch/arm64/util/arm-spe.c     |  2 +-
 tools/perf/arch/x86/util/intel-bts.c     |  2 +-
 tools/perf/arch/x86/util/intel-pt.c      |  4 +-
 tools/perf/bench/evlist-open-close.c     |  2 +-
 tools/perf/builtin-ftrace.c              |  2 +-
 tools/perf/builtin-record.c              |  6 +-
 tools/perf/builtin-stat.c                | 11 ++--
 tools/perf/builtin-top.c                 |  2 +-
 tools/perf/util/auxtrace.c               |  2 +-
 tools/perf/util/bpf_ftrace.c             |  4 +-
 tools/perf/util/evlist.c                 | 17 +++---
 tools/perf/util/record.c                 |  6 +-
 tools/perf/util/sideband_evlist.c        |  3 +-
 tools/perf/util/stat-display.c           |  2 +-
 tools/perf/util/synthetic-events.c       |  2 +-
 tools/perf/util/top.c                    |  8 ++-
 22 files changed, 132 insertions(+), 62 deletions(-)

-- 
2.35.1.1021.g381101b075-goog

