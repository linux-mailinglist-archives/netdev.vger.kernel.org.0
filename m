Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B531C8DB4
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgEGOI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgEGOIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CEAC05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m138so7083385ybf.12
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=D7KOOGg6DlWXW7nMSsDPxBVh53JMWXM+HIMGKr6WXds=;
        b=gddQNX5skQvK8IPzIX3LvuXftFfhK6k/66grQoAObuU49YF41KgKO89AlvU8DKuT8A
         8dPZp87dqYug80DNzaJrdRRwZ668Qx681zfzDluWLyEoMRcOUqmIo2wCr3H7obEvyUo/
         yD47n94mD5EBpz0FWjvR8NArnXkC2K70vxa43vBuhLbmAW8+o6M3UwYGa6Q2/KbErEzD
         KN2U7wGeuD+X7fepQ4EntZYgR1BwqytWHS0hr8rcQSJ4EwgehxkpxLbCge0is+JmgMPq
         XT9Iwqco1QGH22WuvKvgphDjI83XN/ThTpWF/8Dd4bW32LmSHRgP5PWZr+5N6S2ywVTL
         QshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=D7KOOGg6DlWXW7nMSsDPxBVh53JMWXM+HIMGKr6WXds=;
        b=VGyXRC76MpCBiJqb5gubAr5Ju0jVO3FHkYs/GimZMHKiwFeBfGvNFPq4pwKQxTCbhD
         JzBtPmBKc0SwOvQxrbHsltC4IQAjFB7Sj3mbeIf5WydrMJxcxJ/BYNZ0zEhra/jCX36l
         KLmAZ0nE8dpAJcdMRXwhQJ4d2DQoLv7sTBCDyB3sKu2q734O2N3XLMkOIVx+GCBOBQ7W
         RMBSZdsmTHKIcDrCbDUlwXsCaJxPK2dlhEm77bjXaGvcqylH730RfNs1NH43R5g3fbQp
         zWXFrrzqmQR3mGzcGbLJoHoVtrUZnpL0cOM0H/+35+PZtMjcRGFB2vNEKwiucSeFuxIG
         8ESw==
X-Gm-Message-State: AGi0PuZJuE5/jHykexxPaZZl+p0KF+UZQuXQoR7xaDUJwZQdeTmi/l38
        SSS0+WQCWrA1hFYlFy1MILK+xINrDqsZ
X-Google-Smtp-Source: APiQypKbl5bdeu8rHSldwn7J0SyoYBJpMwOkD7Rmb+vRKdgmu57Ub9MDLbq3L25C3JvonV9L3bYUH/xPr053
X-Received: by 2002:a25:d2d5:: with SMTP id j204mr19534444ybg.269.1588860503768;
 Thu, 07 May 2020 07:08:23 -0700 (PDT)
Date:   Thu,  7 May 2020 07:07:56 -0700
Message-Id: <20200507140819.126960-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 00/23] Share events between metrics
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Metric groups contain metrics. Metrics create groups of events to
ideally be scheduled together. Often metrics refer to the same events,
for example, a cache hit and cache miss rate. Using separate event
groups means these metrics are multiplexed at different times and the
counts don't sum to 100%. More multiplexing also decreases the
accuracy of the measurement.

This change orders metrics from groups or the command line, so that
the ones with the most events are set up first. Later metrics see if
groups already provide their events, and reuse them if
possible. Unnecessary events and groups are eliminated.

RFC because:
 - without this change events within a metric may get scheduled
   together, after they may appear as part of a larger group and be
   multiplexed at different times, lowering accuracy - however, less
   multiplexing may compensate for this.
 - libbpf's hashmap is used, however, libbpf is an optional
   requirement for building perf.
 - other things I'm not thinking of.

Thanks!

v2. is the entire patch set based on acme's perf/core tree and includes a
cherry-picks. Patch 13 was sent for review to the bpf maintainers here:
https://lore.kernel.org/lkml/20200506205257.8964-2-irogers@google.com/
v1. was based on the perf metrics fixes and test sent here:
https://lore.kernel.org/lkml/20200501173333.227162-1-irogers@google.com/

Andrii Nakryiko (1):
  libbpf: Fix memory leak and possible double-free in hashmap__clear

Ian Rogers (22):
  perf expr: unlimited escaped characters in a symbol
  perf metrics: fix parse errors in cascade lake metrics
  perf metrics: fix parse errors in skylake metrics
  perf expr: allow ',' to be an other token
  perf expr: increase max other
  perf expr: parse numbers as doubles
  perf expr: debug lex if debugging yacc
  perf metrics: fix parse errors in power8 metrics
  perf metrics: fix parse errors in power9 metrics
  perf expr: print a debug message for division by zero
  perf parse-events: expand add PMU error/verbose messages
  perf test: improve pmu event metric testing
  lib/bpf hashmap: increase portability
  perf expr: fix memory leaks in bison
  perf evsel: fix 2 memory leaks
  perf expr: migrate expr ids table to libbpf's hashmap
  perf metricgroup: change evlist_used to a bitmap
  perf metricgroup: free metric_events on error
  perf metricgroup: always place duration_time last
  perf metricgroup: delay events string creation
  perf metricgroup: order event groups by size
  perf metricgroup: remove duped metric group events

 tools/lib/bpf/hashmap.c                       |   7 +
 tools/lib/bpf/hashmap.h                       |   3 +-
 tools/perf/arch/x86/util/intel-pt.c           |  32 ++-
 .../arch/powerpc/power8/metrics.json          |   2 +-
 .../arch/powerpc/power9/metrics.json          |   2 +-
 .../arch/x86/cascadelakex/clx-metrics.json    |  10 +-
 .../arch/x86/skylakex/skx-metrics.json        |   4 +-
 tools/perf/tests/builtin-test.c               |   5 +
 tools/perf/tests/expr.c                       |  33 ++-
 tools/perf/tests/pmu-events.c                 | 158 +++++++++++-
 tools/perf/tests/pmu.c                        |   4 +-
 tools/perf/tests/tests.h                      |   2 +
 tools/perf/util/evsel.c                       |   2 +
 tools/perf/util/expr.c                        | 126 ++++-----
 tools/perf/util/expr.h                        |  22 +-
 tools/perf/util/expr.l                        |  16 +-
 tools/perf/util/expr.y                        |  41 ++-
 tools/perf/util/metricgroup.c                 | 242 +++++++++++-------
 tools/perf/util/parse-events.c                |  29 ++-
 tools/perf/util/pmu.c                         |  33 ++-
 tools/perf/util/pmu.h                         |   2 +-
 tools/perf/util/stat-shadow.c                 |  46 ++--
 22 files changed, 545 insertions(+), 276 deletions(-)

-- 
2.26.2.526.g744177e7f7-goog

