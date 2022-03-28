Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107064E8E10
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbiC1G0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiC1G0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:26:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA424E3A8
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b16-20020a253410000000b00633b9e71eecso10135646yba.14
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=x0B3czyjsM+UfZLmfIxDKqt01DOoxfjklLpknwf6OIA=;
        b=BKA5tvIg1VJxcH3DbfLPgKEmNl0vjbLvRfkVXAU5KOW6bVmQ2bhanMOPwMHb8ztUmQ
         J5mchyAWm/UvwWoxDViWBVmO8GuuadAnKIkOWzyk5xLtFVBDV9Yb4qOLjl1EJ43ikEIx
         Oc9YwXCZIFhR1xRWdxe3Po1vWtRWfs3+v/HLJDdepOd5ORa/7ZKd95V6aXVjrRuO4yGx
         ikmBGu/ZQn57GynRRE3t5Ntqw2S3tlVptup2j2rRCvF/Ntq609BDHgmPPpys2mfXv15g
         MFbseTvzaVUmkNfqrCI/LJ2CxU9x0kmUVc4/nvoQTg4gP/bBKKL6IQ1HoA43KgvWFefJ
         kw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=x0B3czyjsM+UfZLmfIxDKqt01DOoxfjklLpknwf6OIA=;
        b=L2z7CT8WVg3OBLzTu6ePMxCeHRPoYaXAhIkGQ79uNd+OtnNesASs4R/2DqMPIumncw
         0yRtJr2Jv/yP9AZRiFs9qf1jfkGjq90yhNsGj/akRNfoqGL7qRKvkK0uoX9MH5f+8/hb
         PY7N7VTLzTOZd2x++XsuyBju3V1haNZbghCTQWKDDMeGOv8J9pRMecefiX2MfwBmUvIM
         W0nlQl2JZyXGB++bG37+nqW+UXAMWiq6ljKa5KVo5V6EiRaqnoXoQDVKttNG8DDc1OPY
         NcLSxjpFnJeZ3HN0BS4LU/ipuu0Vr1IiBeMy74PosItVB3mQOoWShRpGrdFF1fzBm8dr
         nG5A==
X-Gm-Message-State: AOAM5310LWyVSe2rTLw53PCIW49IgrjuXbbvT9D1scnS+Dlk7g27vibz
        8k/IWci0PSrlXN5VYUqcs+ecYrLn5R6G
X-Google-Smtp-Source: ABdhPJxWHgdCIIH4SXciDGG4Nax8iqLB+oB99XOa+1GirXx4Tq9c1PYuzpznG8p4LqOmcttKMzoe42FGpUSW
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:ef08:ed1b:261f:77fa])
 (user=irogers job=sendgmr) by 2002:a81:7802:0:b0:2e5:c28d:171b with SMTP id
 t2-20020a817802000000b002e5c28d171bmr23999477ywc.236.1648448661434; Sun, 27
 Mar 2022 23:24:21 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:24:09 -0700
Message-Id: <20220328062414.1893550-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 0/5] Make evlist CPUs more accurate
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

evlist has all_cpus, computed to be the merge of all evsel CPU maps,
and cpus. cpus may contain more CPUs than all_cpus, as by default cpus
holds all online CPUs whilst all_cpus holds the merge/union from
evsels. For an uncore event there may just be 1 CPU per socket, which
will be a far smaller CPU map than all online CPUs.

These patches change cpus to be called user_cpus, to reflect their
potential user specified nature. The user_cpus are set to be the
current value intersected with all_cpus, so that user_cpus is always a
subset of all_cpus. This fixes printing code for metrics so that
unnecessary blank lines aren't printed.

To make the intersect function perform well, a perf_cpu_map__is_subset
function is added. While adding this function, also use it in
perf_cpu_map__merge to avoid creating a new CPU map for some currently
missed patterns.

Ian Rogers (5):
  perf evlist: Rename cpus to user_cpus
  perf cpumap: More cpu map reuse by merge.
  perf cpumap: Add intersect function.
  perf stat: Avoid segv if core.user_cpus isn't set.
  perf evlist: Respect all_cpus when setting user_cpus

 tools/lib/perf/cpumap.c                  | 76 ++++++++++++++++++++----
 tools/lib/perf/evlist.c                  | 28 ++++-----
 tools/lib/perf/include/internal/evlist.h |  4 +-
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
 tools/perf/util/evlist.c                 | 16 ++---
 tools/perf/util/record.c                 |  6 +-
 tools/perf/util/sideband_evlist.c        |  2 +-
 tools/perf/util/stat-display.c           |  2 +-
 tools/perf/util/synthetic-events.c       |  2 +-
 tools/perf/util/top.c                    |  6 +-
 21 files changed, 127 insertions(+), 62 deletions(-)

-- 
2.35.1.1021.g381101b075-goog

