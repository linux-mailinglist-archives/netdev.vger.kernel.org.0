Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607361BFDF6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgD3OYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgD3OYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:24:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E00FC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 07:24:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n205so7901609ybf.14
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pPMd8GxOGm3PZwmKjJNhDVTp6BEu4LYZBpof2RciyW4=;
        b=d8Q0nNydiTmsktkI9xbCiukARVhVtmZojz9tyrLg5wwlSscPmZSFjPoJIM1OvHX+l4
         S4N5YWorYvuSsheAvaqlEU1cMU8tMo3BOFyibxo0Idxfzs2aYlw7cVZL/sZBb6ofjSnH
         Br+7uBs+nFj2QHPNbBwFPAcbx4nx98XeEDUyr77ycx5r0PGZFaQLS3j/jQUNhYS8xOir
         VpLiAtoQi9GMvX182A42I2wn2JHa+wrj8rYAhB6j32FL9TZgp9SrVbwZz8p2s90VEgn/
         cZ16PaCJHwp8UeA/pwlfWHdXz8w25KN90se8ul/3oueVGKdj6i92mdN51RIVoIvc5fMI
         MPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pPMd8GxOGm3PZwmKjJNhDVTp6BEu4LYZBpof2RciyW4=;
        b=VfGTI8yX15EpiWaLsLinH6HiEVA++g7hf1GyiiJ70gr7ECyPNSg4cwpyLkACLJNQnr
         3ElbecQB27t8mo7m+tXL6N+df879XllOBYdaXEDFm3dqvsSh6rj4dWzb4UeBkjRinuCS
         BonoGDmMaFxCtG7NcQtK+j+lP6vn1yutU9DOlOoltvvrai1/td8dPLAk/G32L83o8/eo
         1zO2R5jCeOEA0wDflo8RQNRV7aRLQFbCvdBOijodcZPW7kUvB4kz/sF5sqMa1KojVA1v
         xVm6w5kExR2RiwXlciTKMxZ23x++0ZOmpYZLHVKQmfRw0PYKK7ONkFtMINZhcg71ymNw
         zcRA==
X-Gm-Message-State: AGi0PuZxSnkW+99NujewbTof0yxqx8RkV+CORbQ3hw0xYftxPT9e5csL
        MELR6e6aYiY9+rOJh0Ei0Lu6RkroXIy7
X-Google-Smtp-Source: APiQypK3Vpft00hes53MtZEVCGv8AFAIWWwXyGRt84ln9KqoYa7RHrUR62Y+lauNqNBrxPeLot4ZXLxuzIPz
X-Received: by 2002:a25:1a84:: with SMTP id a126mr6320236yba.161.1588256662435;
 Thu, 30 Apr 2020 07:24:22 -0700 (PDT)
Date:   Thu, 30 Apr 2020 07:24:15 -0700
Message-Id: <20200430142419.252180-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 0/4] perf tools: add support for libpfm4
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

This patch links perf with the libpfm4 library if it is available and
LIBPFM4 is passed to the build. The libpfm4 library contains hardware
event tables for all processors supported by perf_events. It is a
helper library that helps convert from a symbolic event name to the
event encoding required by the underlying kernel interface. This
library is open-source and available from: http://perfmon2.sf.net.
    
With this patch, it is possible to specify full hardware events
by name. Hardware filters are also supported. Events must be
specified via the --pfm-events and not -e option. Both options
are active at the same time and it is possible to mix and match:
    
$ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....

v13 moves libpfm_initialize purely into pfm.c as suggested by
    acme@kernel.org.
v12 changes NO_LIBPFM4 as a make option to LIBPFM4, ie opt-in rather
    than opt-out of feature detection and build support. Suggested by
    acme@kernel.org. It also moves passing the ASCIIDOC_EXTRA argument
    into its own commit.
v11 reformats the perf list output.
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
  perf doc: pass ASCIIDOC_EXTRA as an argument

Stephane Eranian (3):
  tools feature: add support for detecting libpfm4
  perf pmu: add perf_pmu__find_by_type helper
  perf tools: add support for libpfm4

 tools/build/Makefile.feature             |   3 +-
 tools/build/feature/Makefile             |   6 +-
 tools/build/feature/test-libpfm4.c       |   9 +
 tools/perf/Documentation/perf-record.txt |  11 +
 tools/perf/Documentation/perf-stat.txt   |  10 +
 tools/perf/Documentation/perf-top.txt    |  11 +
 tools/perf/Makefile.config               |  13 ++
 tools/perf/Makefile.perf                 |   8 +-
 tools/perf/builtin-record.c              |   6 +
 tools/perf/builtin-stat.c                |   6 +
 tools/perf/builtin-top.c                 |   6 +
 tools/perf/tests/Build                   |   1 +
 tools/perf/tests/builtin-test.c          |   9 +
 tools/perf/tests/pfm.c                   | 203 ++++++++++++++++
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/util/Build                    |   2 +
 tools/perf/util/evsel.c                  |   2 +-
 tools/perf/util/evsel.h                  |   1 +
 tools/perf/util/parse-events.c           |  30 ++-
 tools/perf/util/parse-events.h           |   4 +
 tools/perf/util/pfm.c                    | 281 +++++++++++++++++++++++
 tools/perf/util/pfm.h                    |  37 +++
 tools/perf/util/pmu.c                    |  11 +
 tools/perf/util/pmu.h                    |   1 +
 24 files changed, 661 insertions(+), 13 deletions(-)
 create mode 100644 tools/build/feature/test-libpfm4.c
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

-- 
2.26.2.303.gf8c07b1a785-goog

