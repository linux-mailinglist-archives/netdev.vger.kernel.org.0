Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83D31A4EAE
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgDKHqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 03:46:37 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41612 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgDKHqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 03:46:37 -0400
Received: by mail-pg1-f201.google.com with SMTP id m25so3447678pgl.8
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 00:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yOxiCW0isZEaHIJFpWjXqFOzFywpzj8dLyjA3GIE96w=;
        b=aaUnopzdDTRJV+cjRXrIpEEGuXlkFqsEBC8cR23USCiau8Nx9kYoggAXZxwYNXRFZv
         soNcYuf5pbWjQFhoZJWlYIw+1DMfkZ0j9fRM4u8WeU0Khijpo/2c8CPHuL5dPT2ElWqd
         LImnKf6Nlcl+q+lPfxbr2+udjvdOU9Ua4cEz88yLKsm0T7AlE/miI8VWg8K43bHAdezr
         dss5Dh1MuOjAX416k9Dsm8FicOuEJNW/Gx59ON1JwZJ/W+398xm6V4muxU3H1nRUrBVy
         WFmZtOd2r92yhrDM3RGPBCDrDQLKgQKG3kvgS9TAgn7q3jPebA0t444+nanKU/vMKcGX
         6/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yOxiCW0isZEaHIJFpWjXqFOzFywpzj8dLyjA3GIE96w=;
        b=VX7h8/7wehbNYg7Qjz3mz6NEtJS6SGhvRPXTFJ9Pi7IOI20gq131V2eyGXgfKiMngf
         VJo5meLzqalLIMq9sQCdCdWFKCDi8U9sWz3uPDW8rZha5lLiVqFMyBOO3tGvr2HJmB2y
         VFyx1ickw2d7lJIrq80qyiYaiFFy3JTpPkjkwTiMHzVo9IjtMk5nLMuGjurcYS6gx+xs
         69zW4M0YtqhpMtGCKPHuu+dySmqDQDMeaj9BlOi5vYFxUFNV8H2rR/lxrFYbEeTLluQx
         dRxirhKZvh4BpBqj/VAKyyN3x0uMSNfvp/9/xVm9IEj9cXmGTpoLptzaxlPX38kv9BnR
         sAVA==
X-Gm-Message-State: AGi0PuZt1q2FPxDT7srJFf7UrcAXnDNMAd/+agibtrK/uRdlPIMr6Rg0
        TcKT2ZIGcwvrEWlk7ZWCedvm7FxuecA6
X-Google-Smtp-Source: APiQypJol+oijd/s0c00Dcu9CWbs7k7Dh80PRNHTzkcuFOCj9s0+Vqc24YvdVt9By36epwGCnhusOQHLkG3z
X-Received: by 2002:a17:90a:c708:: with SMTP id o8mr8506314pjt.190.1586591195829;
 Sat, 11 Apr 2020 00:46:35 -0700 (PDT)
Date:   Sat, 11 Apr 2020 00:46:27 -0700
Message-Id: <20200411074631.9486-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v8 0/4] perf tools: add support for libpfm4
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
    
v8 addresses review comments from jolsa@redhat.com.
   Breaks the patch into 4, adds a test and moves the libpfm code into its
   own file. perf list encoding tries to be closer to existing:
...
skx pfm-events
  UNHALTED_CORE_CYCLES
    [Count core clock cycles whenever the clock signal on the specific ...
  UNHALTED_REFERENCE_CYCLES
    [Unhalted reference cycles]
  INSTRUCTION_RETIRED
    [Number of instructions at retirement]
  INSTRUCTIONS_RETIRED
    [This is an alias for INSTRUCTION_RETIRED]
  BRANCH_INSTRUCTIONS_RETIRED
    [Count branch instructions at retirement. Specifically, this event ...
  MISPREDICTED_BRANCH_RETIRED
    [Count mispredicted branch instructions at retirement. ...
  BACLEARS
    [Branch re-steered]
      BACLEARS:ANY
        [Number of front-end re-steers due to BPU misprediction]
  BR_INST_RETIRED
    [Branch instructions retired (Precise Event)]
      BR_INST_RETIRED:CONDITIONAL
        [Counts all taken and not taken macro conditional branch ...
...
  and supports --long-desc/-v:
...
  BACLEARS
    [Branch re-steered]
      Code  : 0xe6
      BACLEARS:ANY
        [Number of front-end re-steers due to BPU misprediction]
        Umask : 0x01 : PMU: [default] 
      Modif : PMU: [e] : edge level (may require counter-mask >= 1) ...
      Modif : PMU: [i] : invert (boolean)
      Modif : PMU: [c] : counter-mask in range [0-255] (integer)
      Modif : PMU: [t] : measure any thread (boolean)
      Modif : PMU: [intx] : monitor only inside transactional memory ...
      Modif : PMU: [intxcp] : do not count occurrences inside aborted ...
      Modif : perf_event: [u] : monitor at user level (boolean)
      Modif : perf_event: [k] : monitor at kernel level (boolean)
      Modif : perf_event: [period] : sampling period (integer)
      Modif : perf_event: [freq] : sampling frequency (Hz) (integer)
      Modif : perf_event: [excl] : exclusive access (boolean)
      Modif : perf_event: [mg] : monitor guest execution (boolean)
      Modif : perf_event: [mh] : monitor host execution (boolean)
      Modif : perf_event: [cpu] : CPU to program (integer)
      Modif : perf_event: [pinned] : pin event to counters (boolean)
  BR_INST_RETIRED
    [Branch instructions retired (Precise Event)]
      Code  : 0xc4
      BR_INST_RETIRED:CONDITIONAL
        [Counts all taken and not taken macro conditional branch ...
        Umask : 0x01 : PMU: [precise]

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

 tools/build/Makefile.feature             |   6 +-
 tools/build/feature/Makefile             |   6 +-
 tools/build/feature/test-libpfm4.c       |   9 +
 tools/perf/Documentation/Makefile        |   4 +-
 tools/perf/Documentation/perf-record.txt |  11 +
 tools/perf/Documentation/perf-stat.txt   |  10 +
 tools/perf/Documentation/perf-top.txt    |  11 +
 tools/perf/Makefile.config               |  12 +
 tools/perf/Makefile.perf                 |   6 +-
 tools/perf/builtin-list.c                |  14 +-
 tools/perf/builtin-record.c              |  13 ++
 tools/perf/builtin-stat.c                |  13 ++
 tools/perf/builtin-top.c                 |  13 ++
 tools/perf/tests/Build                   |   1 +
 tools/perf/tests/builtin-test.c          |   9 +
 tools/perf/tests/pfm.c                   | 206 +++++++++++++++++
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/util/Build                    |   2 +
 tools/perf/util/evsel.c                  |   6 +
 tools/perf/util/evsel.h                  |   3 +
 tools/perf/util/parse-events.c           |  37 ++-
 tools/perf/util/parse-events.h           |   5 +
 tools/perf/util/pfm.c                    | 272 +++++++++++++++++++++++
 tools/perf/util/pfm.h                    |  19 ++
 tools/perf/util/pmu.c                    |  11 +
 tools/perf/util/pmu.h                    |   1 +
 26 files changed, 687 insertions(+), 16 deletions(-)
 create mode 100644 tools/build/feature/test-libpfm4.c
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

-- 
2.26.0.110.g2183baf09c-goog

