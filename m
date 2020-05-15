Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139741D5684
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgEOQuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgEOQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:50:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8FBC05BD0A
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z7so2793505ybn.21
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9wE9+uYnPyHYBqhR+xTCODqhwbytCS+WPKk2ROqoQ0g=;
        b=tLqu7zzMrYW+ZkntEU0ajxzoLSG5IfNMsKggx4+Y9NmSkUGT76DEavorSytFpWmXzX
         i+6FjxP6+Tdo4Y/QszAaJXaCXpL9D8XqCk3hqsI0FUyYc+MtMRd8g9QY/RH1AzdsuaLB
         Hf801mUExVuv/efSSwn3UJa6V75a5v5loJmIyWiL4bP36Xp12MHMGw0LM8PGMzbaQrW0
         oHbPzIz56OeRs1BQNfpIXVClkYutWh4P04JDXbkJ9QWjVT7yiV7aB5N2YbCqhDz67y+R
         o6X/skCdWp4wakVVam610PYnwsf4VTj3a7m+VwfXZv0kaMg8q7NbAbAese788sCPoCfd
         pnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9wE9+uYnPyHYBqhR+xTCODqhwbytCS+WPKk2ROqoQ0g=;
        b=WAEdTGJ8AFhte9fnMb/CYurEWy1/sqAgI7wFMQbz73kf29nnfsKKSXlXYwE8ast9xq
         mvsQaG0WpVIaEZtiF39XYWjW2WmmYsfrQkSEgGbFB2VblXnjQOixGUWSrKSTjr2IVVex
         Ut2CO4bLWRIp046EzAUWSaEkO9gNcfxZukHFz+AKUYW7F37kjEI35OZYIG0nX01pXfO4
         guz4wFtbtIMkg9esjMbPZ7ZQhcQ/kXyrLpzA8IvYsJn7e8lWZib5IGPLIIF9Lv7mZxML
         FZKcGlLHCF/LVkKrCacsgSCKuk4AY9RB5e/iWcI7iiLbMS2GzgMoFKw+HVA50+wpxa4h
         XPwA==
X-Gm-Message-State: AOAM5315CrNXo9x03SR2DPTIrfWyhBqYMScdxk6011dpB2M31zhNOy73
        TFKYUT5EtxN8036Dsw3++mwMz4S6+HeR
X-Google-Smtp-Source: ABdhPJwY7yBo/mBm0YamN0eM/SyiF9JnyivPehxA5K95j1vaxfM09wEVfXjbqZWVeDi3JrW6nK9y62RiKT7Q
X-Received: by 2002:a25:71c6:: with SMTP id m189mr3881034ybc.187.1589561412313;
 Fri, 15 May 2020 09:50:12 -0700 (PDT)
Date:   Fri, 15 May 2020 09:50:00 -0700
Message-Id: <20200515165007.217120-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 0/7] Copy hashmap to tools/perf/util, use in perf expr
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
into tools/perf/util, it then adds a check in perf that the two are in
sync.

Andrii's patch to hashmap from bpf-next is brought into this set to
fix issues with hashmap__clear.

Two minor changes to libbpf's hashmap are made that remove an unused
dependency and fix a compiler warning.

Two perf test changes are also brought in as they need refactoring to
account for the expr API change and it is expected they will land
ahead of this.
https://lore.kernel.org/lkml/20200513062236.854-2-irogers@google.com/

Tested with 'perf test' and 'make -C tools/perf build-test'.

The hashmap change was originally part of an RFC:
https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/

v2. moves hashmap into tools/perf/util rather than libapi, to allow
hashmap's libbpf symbols to be visible when built statically for
testing.

Andrii Nakryiko (1):
  libbpf: Fix memory leak and possible double-free in hashmap__clear

Ian Rogers (6):
  libbpf hashmap: Remove unused #include
  libbpf hashmap: Fix signedness warnings
  tools lib/api: Copy libbpf hashmap to tools/perf/util
  perf test: Provide a subtest callback to ask for the reason for
    skipping a subtest
  perf test: Improve pmu event metric testing
  perf expr: Migrate expr ids table to a hashmap

 tools/lib/bpf/hashmap.c         |  10 +-
 tools/lib/bpf/hashmap.h         |   1 -
 tools/perf/check-headers.sh     |   4 +
 tools/perf/tests/builtin-test.c |  18 ++-
 tools/perf/tests/expr.c         |  40 +++---
 tools/perf/tests/pmu-events.c   | 169 ++++++++++++++++++++++-
 tools/perf/tests/tests.h        |   4 +
 tools/perf/util/Build           |   4 +
 tools/perf/util/expr.c          | 129 +++++++++--------
 tools/perf/util/expr.h          |  26 ++--
 tools/perf/util/expr.y          |  22 +--
 tools/perf/util/hashmap.c       | 238 ++++++++++++++++++++++++++++++++
 tools/perf/util/hashmap.h       | 177 ++++++++++++++++++++++++
 tools/perf/util/metricgroup.c   |  87 ++++++------
 tools/perf/util/stat-shadow.c   |  49 ++++---
 15 files changed, 798 insertions(+), 180 deletions(-)
 create mode 100644 tools/perf/util/hashmap.c
 create mode 100644 tools/perf/util/hashmap.h

-- 
2.26.2.761.g0e0b3e54be-goog

