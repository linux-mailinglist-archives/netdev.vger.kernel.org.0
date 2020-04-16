Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81F1AD2A4
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgDPWPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729205AbgDPWPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:15:06 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9269C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:15:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id r198so21130pfc.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=inZXCTMba3jhQ/kntq9OhKXPlzo6YURcAjj5vzw18C0=;
        b=pxKMvYQ7DabwUBM1a6onah0dl6Qj90Y4U9Mf9KGSUzGtjyyWHxLj5s4SBqIH5M6oFi
         Emyyrkxwb2Apu0hegTDR740cnn0II5WhoMzpQ8LUKLSotsKxK9eoQ++40JyfihJcOH2+
         mTa+AfqiPk6uNuziHOhZhx4e/4fM+jKhN76ArO3ar+LyFlpwJFLpBgic+gyqZFznTcDM
         7iMIxtRfHvGjqQASvHO0CRIAKlToaeglkHCDQHtQhzlEpVNzQeMWmRFr1FNewoKwVCCS
         MV+zmadcQzM/oO4m5yaqZ2e3DlnCvIkkgpTR1GMCkQBTULFeakp8Vpk7KIdRMBG2YaiA
         ITmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=inZXCTMba3jhQ/kntq9OhKXPlzo6YURcAjj5vzw18C0=;
        b=Xip280QnhEIstjfUJVOCXHN2EKtriMI+VycoVSF2DmWjYFo2BSu4ZP9uGFhefNtlYM
         rGkaS5wrii/dJDUk4J5NClhzo12PhfMWNSiWWx1et6n1rndWaCqP7UgkoaS66yNr5uBu
         IdZ9dEVt+uTEQvL3KF7kLVM9+k5GhDhspfjrTvMRcfh2Itd5lA1KnqgIIw868hgm/scT
         ojB4oy92qaH/xrtAbJvmPLAYnbKh5/kTAsJzfcF6XmhKDiMqz1d8dl1ArNkYK4kTvmVv
         oRHRsj1Hpwl54fgVv4QgaV6Fk+m6KqoSTuoemH8GrGFE36nvFtAwrNTJ88TsATuHKmk1
         p0iQ==
X-Gm-Message-State: AGi0PubX26u2Ub4S5PBiudIbdb/6zRlMNmNWvzMjt6aW2Gcl15X0il29
        KZJUl4QZAgMAzDa2Nt/bNeSy0afG+sOj
X-Google-Smtp-Source: APiQypKdhmZVuK+l63hSvUne2M/aWeY0m/egjfQuMzorZNUkGMgskeil6BFSxzh6F4UD486ve2XtkmxIV82t
X-Received: by 2002:a17:90a:8c96:: with SMTP id b22mr584589pjo.25.1587075304229;
 Thu, 16 Apr 2020 15:15:04 -0700 (PDT)
Date:   Thu, 16 Apr 2020 15:14:53 -0700
Message-Id: <20200416221457.46710-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 0/4] perf tools: add support for libpfm4
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
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch links perf with the libpfm4 library if it is available
and NO_LIBPFM4 isn't passed to the build. The libpfm4 library
contains hardware event tables for all processors supported by
perf_events. It is a helper library that helps convert from a
symbolic event name to the event encoding required by the
underlying kernel interface. This library is open-source and
available from: http://perfmon2.sf.net.
    
With this patch, it is possible to specify full hardware events
by name. Hardware filters are also supported. Events must be
specified via the --pfm-events and not -e option. Both options
are active at the same time and it is possible to mix and match:
    
$ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....

v11 reformats the perf list output to be:
List of pre-defined events (to be used in -e):

  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
...

List of pre-defined events (to be used in --pfm-events):

ix86arch:
  UNHALTED_CORE_CYCLES
    [count core clock cycles whenever the clock signal on the specific core is running (not halted)]
  INSTRUCTION_RETIRED
    [count the number of instructions at retirement. For instructions that consists of multiple mic>
...
skx:
  UNHALTED_CORE_CYCLES
    [Count core clock cycles whenever the clock signal on the specific core is running (not halted)]
...
  BACLEARS
    [Branch re-steered]
      BACLEARS:ANY
        [Number of front-end re-steers due to BPU misprediction]
...
v10 addresses review comments from jolsa@redhat.com.
v9 removes some unnecessary #ifs.
v8 addresses review comments from jolsa@redhat.com.
   Breaks the patch into 4, adds a test and moves the libpfm code into its
   own file. perf list encoding tries to be closer to existing.
v7 rebases and adds fallback code for libpfm4 events.
   The fallback code is to force user only priv level in case the
   perf_event_open() syscall failed for permissions reason.
   the fallback forces a user privilege level restriction on the event
   string, so depending on the syntax either u or :u is needed.
    
   But libpfm4 can use a : or . as the separator, so simply searching
   for ':' vs. '/' is not good enough to determine the syntax needed.
   Therefore, this patch introduces a new evsel boolean field to mark
   events coming from  libpfm4. The field is then used to adjust the
   fallback string.
v6 was a rebase.
v5 was a rebase.
v4 was a rebase on
   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
   branch perf/core and re-adds the tools/build/feature/test-libpfm4.c
   missed in v3.
v3 is against acme/perf/core and removes a diagnostic warning.
v2 of this patch makes the --pfm-events man page documentation
   conditional on libpfm4 behing configured. It tidies some of the
   documentation and adds the feature test missed in the v1 patch.

Ian Rogers (1):
  perf doc: allow ASCIIDOC_EXTRA to be an argument

Stephane Eranian (3):
  tools feature: add support for detecting libpfm4
  perf pmu: add perf_pmu__find_by_type helper
  perf tools: add support for libpfm4

 tools/build/Makefile.feature             |   3 +-
 tools/build/feature/Makefile             |   6 +-
 tools/build/feature/test-libpfm4.c       |   9 +
 tools/perf/Documentation/Makefile        |   4 +-
 tools/perf/Documentation/perf-record.txt |  11 +
 tools/perf/Documentation/perf-stat.txt   |  10 +
 tools/perf/Documentation/perf-top.txt    |  11 +
 tools/perf/Makefile.config               |  13 ++
 tools/perf/Makefile.perf                 |   6 +-
 tools/perf/builtin-list.c                |   3 +
 tools/perf/builtin-record.c              |   8 +
 tools/perf/builtin-stat.c                |   8 +
 tools/perf/builtin-top.c                 |   8 +
 tools/perf/tests/Build                   |   1 +
 tools/perf/tests/builtin-test.c          |   9 +
 tools/perf/tests/pfm.c                   | 207 +++++++++++++++++
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/util/Build                    |   2 +
 tools/perf/util/evsel.c                  |   2 +-
 tools/perf/util/evsel.h                  |   1 +
 tools/perf/util/parse-events.c           |  30 ++-
 tools/perf/util/parse-events.h           |   4 +
 tools/perf/util/pfm.c                    | 278 +++++++++++++++++++++++
 tools/perf/util/pfm.h                    |  43 ++++
 tools/perf/util/pmu.c                    |  11 +
 tools/perf/util/pmu.h                    |   1 +
 26 files changed, 678 insertions(+), 14 deletions(-)
 create mode 100644 tools/build/feature/test-libpfm4.c
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

-- 
2.26.1.301.g55bc3eb7cb9-goog

