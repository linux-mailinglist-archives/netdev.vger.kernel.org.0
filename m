Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9B1BEC82
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgD2XOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgD2XOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:14:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EFAC035495
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y73so5465930ybe.22
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 16:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CJJxf0pq8zlcf44QOwhYtFTCq73pqyejf08/z19Qj6s=;
        b=nGcTerxxzkNeOTa+QP/PodF+fNjcK6F6fECoxFkjdxwzsmPJbfsP88jkwQ977e5PiY
         SSssk6+yMvt/6WyB1bk3A622xU2OfqnbxOsyeu7/VTChAMe6cKHQJVuo7Rjl0n4JcIaE
         CYqO3rFynBBG5UzJ+Qpkh4TfLEJ0AP2ixk9oNEDLqKlpj7VdwUFT+6zZ3AKYzsRrWOGN
         +SAYKz+Ht3HWdbufcJpPA/JpHDNB0qTAu7dR3z3AEWPekXNAk5xEYskKh0pDXuUlKQxW
         3/3Ti34mkWO8uh/q0gW+p9CzxLC2Mr4Al86X+rmYbvaf50QDj086COwXWO7TH0AlzwOy
         CzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CJJxf0pq8zlcf44QOwhYtFTCq73pqyejf08/z19Qj6s=;
        b=o+nrS2OocFgAACinbqM62/lRGQX4vpixoIU2u7iRONLpHUXFJkVBBQHH7bXgJbGwO0
         Jtyw9d3RtOp0XBXzRSExw/giwHuCBKUAsDZsy9oTpsULK/mLFE7ugpQ7o6lX5PsMfuL+
         ZvZg3gzzf9Ce9cNFejs1YL/H7aZwDjcR87F2q33fSvQON3NdLAK1N5RprILsOdEGQJMS
         YknA5aXWolcPCdm3eOrlv9ZEnteXAOvpVoJnHpo37AThe8Yhq84Xl4AjGOuXzRuvLBZ1
         lvaP66b3VevShhgDde+bmOZP/OCp85WwCuMFIM66BY0PqIrYWJgGyVJd2DHPo32Rqiao
         OZGw==
X-Gm-Message-State: AGi0PuZ+t3lApsOg2FjIK3jdNArGWo0ivxJC3VwrP8mRltKL75409ZMi
        IL6zDQajXqH7MgURzbRXiXxyOTIohodv
X-Google-Smtp-Source: APiQypLYTz2BSjcXe/ll6kzvWKmu019RsTaRmGB2Qd0YbSN5hrXg39C7thEWmm2SdkZbb1gvVACcY5jXWoKo
X-Received: by 2002:a25:b8c9:: with SMTP id g9mr1091568ybm.3.1588202087316;
 Wed, 29 Apr 2020 16:14:47 -0700 (PDT)
Date:   Wed, 29 Apr 2020 16:14:39 -0700
Message-Id: <20200429231443.207201-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v12 0/4] perf tools: add support for libpfm4
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
 tools/perf/util/pfm.c                    | 277 +++++++++++++++++++++++
 tools/perf/util/pfm.h                    |  43 ++++
 tools/perf/util/pmu.c                    |  11 +
 tools/perf/util/pmu.h                    |   1 +
 25 files changed, 676 insertions(+), 13 deletions(-)
 create mode 100644 tools/build/feature/test-libpfm4.c
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

-- 
2.26.2.303.gf8c07b1a785-goog

