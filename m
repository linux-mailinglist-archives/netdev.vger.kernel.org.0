Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9B91D4669
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgEOG4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgEOG4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 02:56:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6A7C05BD09
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n7so1549523ybh.13
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 23:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a2lbgY6+l2XCN87y1SfDgu1WwO4AsIVPUD49ghQtedw=;
        b=U/YXznYxlq6k8WbFkCuQ91LVvT4CBcEDGtperbGv2gkTQM/4rdAB2GSl2j9BJN24ya
         5SBh9P9tQIipeTWrM0GDTfMjAeM80RzYbwdYkTyJog2Nu2pRz+xUVxACwxRRKSNMnvMR
         FDXP9M5r9YMA4p/wgavHwun3lKObGCEUR/kKW5xe8XGfUD8l6LAoHXabe3eSZUWJtyZA
         GNNTxVyNOnMMEM5dWDYeuA+1ycDcenqxjkRjmCeM6wHjN8g3nJI/+35ixFh9YUEADX0r
         utSXa/Doim0uvR1wt0fss/zVAimvPEIK2XXWk3L32vptRVgv1GlVFHLFgKzDVXBNVIUI
         8vuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a2lbgY6+l2XCN87y1SfDgu1WwO4AsIVPUD49ghQtedw=;
        b=N0CIgGuggLjI4+wxfGFoH2vVWuN3VE7Yj9HdxsKcOEYLk3e1egO4GwEt6v9NP2Nkc+
         Gb4Hpb6K9k4ad47+z7dOv/X+ROq0/l5jnyFmgzbrz1fhoq2zqDADTsur4DkihWDARNgn
         yb0WA/2iP5BRMU/iTCQPTq0EIlstmzk8u4j8vNFz7fB1TpApL35haRgipurDYJPmZBLb
         5gYgM4gBcD4r5TjuNDshr15wBXDVGBazZrYtpbdcNI5ETXZzXJwtRv8eaLe67u8nwZKV
         z/yIk+g070pYtoxp9//keAno6/bt1MBN3h/dFa/yOaa0w7sq8xm/T0ZC7Gd8RL6/5Jd4
         aG2A==
X-Gm-Message-State: AOAM531kbCvZK02fKdTbUuVd3n5pqY98lxVTVBCdpV+jAqGHQ47ahJpt
        SXAquDqc57U/oxKYr51VThODxJWc+SaQ
X-Google-Smtp-Source: ABdhPJwn2n35tY1jUXo/CJLHCoijbc0JgiLKNPL0+cnzNihTaaRWYL06vxO31zyvBBYptNnibAuGjSyC48QS
X-Received: by 2002:a25:6cd6:: with SMTP id h205mr3211731ybc.404.1589525790276;
 Thu, 14 May 2020 23:56:30 -0700 (PDT)
Date:   Thu, 14 May 2020 23:56:16 -0700
Message-Id: <20200515065624.21658-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 0/8] Copy hashmap to libapi, use in perf expr
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perf's expr code currently builds an array of strings then removes
duplicates. The array is larger than necessary and has recently been
increased in size. When this was done it was commented that a hashmap
would be preferable.

libbpf has a hashmap but libbpf isn't currently required to build
perf. To satisfy various concerns this change copies libbpf's hashmap
into libapi, it then adds a check in perf that the two are in sync.

Andrii's patch to hashmap from bpf-next is brought into this set to
fix issues with hashmap__clear.

Three minor changes to libbpf's hashmap are made that remove an unused
dependency, fix a compiler warning and make sure the hashmap isn't
part of the symbols in a static build of libbpf (dsos are handled by
the existing version script).

Two perf test are also brought in as they need refactoring to account
for the expr API change and it is expected they will land aheadof
this.
https://lore.kernel.org/lkml/20200513062236.854-2-irogers@google.com/

Tested with 'perf test' and make -C tools/perf build-test.

The hashmap change was originally part of an RFC:
https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/

Andrii Nakryiko (1):
  libbpf: Fix memory leak and possible double-free in hashmap__clear

Ian Rogers (7):
  libbpf hashmap: Remove unused #include
  libbpf hashmap: Fix signedness warnings
  libbpf hashmap: Localize static hashmap__* symbols
  tools lib/api: Copy libbpf hashmap to libapi
  perf test: Provide a subtest callback to ask for the reason for
    skipping a subtest
  perf test: Improve pmu event metric testing
  perf expr: Migrate expr ids table to a hashmap

 tools/lib/api/Build             |   1 +
 tools/lib/api/hashmap.c         | 238 ++++++++++++++++++++++++++++++++
 tools/lib/api/hashmap.h         | 177 ++++++++++++++++++++++++
 tools/lib/bpf/Makefile          |   2 +
 tools/lib/bpf/hashmap.c         |  10 +-
 tools/lib/bpf/hashmap.h         |   1 -
 tools/perf/check-headers.sh     |   4 +
 tools/perf/tests/builtin-test.c |  18 ++-
 tools/perf/tests/expr.c         |  40 +++---
 tools/perf/tests/pmu-events.c   | 169 ++++++++++++++++++++++-
 tools/perf/tests/tests.h        |   4 +
 tools/perf/util/expr.c          | 129 +++++++++--------
 tools/perf/util/expr.h          |  22 ++-
 tools/perf/util/expr.y          |  22 +--
 tools/perf/util/metricgroup.c   |  87 ++++++------
 tools/perf/util/stat-shadow.c   |  49 ++++---
 16 files changed, 793 insertions(+), 180 deletions(-)
 create mode 100644 tools/lib/api/hashmap.c
 create mode 100644 tools/lib/api/hashmap.h

-- 
2.26.2.761.g0e0b3e54be-goog

