Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503454F8EA4
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiDHD62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiDHD6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:58:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAF1DD94B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:56:22 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb58f605aeso66052987b3.0
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 20:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HxFczrqsspWyPdqTCif/D0IhzdUHRDLBzRRwTlKUif4=;
        b=OpAiXGIhVTB/vTq+PHCL6R254gERCairQa9Ci41IeF1qLemf8XiEknJyK9Qj6Xs1GW
         K7WpgXr2EA17KLl/s4ujXAp5fKXj6Xw078lOQwj1Q/BY5uq1kQT3b5ejYkJ5qqHiW0yK
         aDjMN+hXma8v/A4lyggTad1UeC6FgVVVHzWbdfdzsvOb6vgvpXjsWygNGHBdBmop+AaA
         o6CBjt20f1W7sJ77QjxsdVH8SloKdX922qn7sb64nBoukV1FFCcXuLm3tuKG+CljIAAM
         mrt8cwt9D7X4gb1te5BnaS2qFjU3ZU6zqtUtJ3ij0eCLxZzpHO3OZoc+19JMxnnvTBOG
         EHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HxFczrqsspWyPdqTCif/D0IhzdUHRDLBzRRwTlKUif4=;
        b=1TM76JYecFMtNV0Qu2SVolq4sbTIO7nXRGm/cWgx0a7V6vTs4czVIbM1Jc70q4LV3b
         O784T4zxL7uNQPc0apX+G1I/dDY1Hhp54U9w7TnfLZVepO2CVpI3jEh5yZvRn6FocMj6
         DdugoBv7MyEDZf3E0N7uhEbpxm/u39IGWRg1zsobL04e15QiQYn/Eg3B3qO9ta6yTjcg
         Ot95G/+iiXun/339CKLYtffejQF6poVCqeHxrb15cXYkDQXe2BElKu7nIBJ/BYrrXi9b
         qVDd1jfvU9hHGmloVtFvsfz4i5KXU5VA03n+svChgj5Uhv/SFmZx56K2zVb/jGFJRmCH
         u4QQ==
X-Gm-Message-State: AOAM530o8fwK6wFk8bLrYQpr/tKTf0Fd3OzNPU0tj4+EaRR+g2SaBcwM
        pcsOfSu8cnZmevf/LpL3uc4MhzNoQpdT
X-Google-Smtp-Source: ABdhPJxGss2gEVXU1qEfZ8LDHdcCgN0sHB3FaIVikPe2VRhZW0mD6pgY0SGsZRVMI8prYHhp9fSSBvfka1ac
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:560:aa27:649e:a07d])
 (user=irogers job=sendgmr) by 2002:a25:dad1:0:b0:634:63aa:6ec2 with SMTP id
 n200-20020a25dad1000000b0063463aa6ec2mr12250168ybf.159.1649390181920; Thu, 07
 Apr 2022 20:56:21 -0700 (PDT)
Date:   Thu,  7 Apr 2022 20:56:11 -0700
Message-Id: <20220408035616.1356953-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 0/5] Make evlist CPUs more accurate
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

The v1 patches changed cpus to be called user_requested_cpus, to
reflect their potential user specified nature. The user_requested_cpus
are set to be the current value intersected with all_cpus, so that
user_requested_cpus is always a subset of all_cpus. This fixes
printing code for metrics so that unnecessary blank lines aren't
printed.

To make the intersect function perform well, a perf_cpu_map__is_subset
function is added. While adding this function, the v2 patches also
used it in perf_cpu_map__merge to avoid creating a new CPU map for
some currently missed patterns. The reference counts for these
functions is simplified as discussed here:
https://lore.kernel.org/lkml/YkdOpJDnknrOPq2t@kernel.org/ but this
means users of perf_cpu_map__merge must now do a put on the 1st
argument.

v2. Reorders the "Avoid segv" patch and makes other adjustments
    suggested by Arnaldo Carvalho de Melo <acme@kernel.org>.
v3. Modify reference count behaviour for merge and intersect. Add
    intersect tests and tidy thee cpu map tests suite.

Ian Rogers (5):
  perf cpumap: Don't decrement refcnt on args to merge
  perf tests: Additional cpumap merge tests
  perf cpumap: Add intersect function.
  perf evlist: Respect all_cpus when setting user_requested_cpus
  perf test: Combine cpu map tests into 1 suite

 tools/lib/perf/cpumap.c              | 46 ++++++++++++++---
 tools/lib/perf/evlist.c              |  6 ++-
 tools/lib/perf/include/perf/cpumap.h |  2 +
 tools/perf/tests/builtin-test.c      |  4 +-
 tools/perf/tests/cpumap.c            | 74 +++++++++++++++++++++++++---
 tools/perf/tests/tests.h             |  4 +-
 tools/perf/util/evlist.c             |  7 +++
 7 files changed, 120 insertions(+), 23 deletions(-)

-- 
2.35.1.1178.g4f1659d476-goog

