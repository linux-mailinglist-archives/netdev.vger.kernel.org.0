Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802781C6017
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgEES3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbgEES3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:29:47 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B82C0610D5
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:29:47 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id x26so2818945qvd.20
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3db/2NlEf7ssPLu2YEgcy3TYd3JpsSQjJNmsMwphW5g=;
        b=DbjW1Ea8zPYrc1L9deFWdikACJVir0AOCryUGydU1ZjADBNQKdASlfgODyrBqz2/23
         o5575IWtxLBEhLsi1ia+a4PQ4h+3h+gHDKUsouHQmSC3ED0Nu7c74IaYwGhf/4uxgS26
         qFD0an+Sg5QRsqJ5nW/KW/3/gAf/Wjg9OJm9ZaR/sHPl/8i+UdyFxZpC5D7kb5ditqLr
         PTvM+bl2PCxSD8ydvm96KL01o7ZcK1kcfib0/2nMbg8mWxWWxUFdbGyZCMDmjwiDph0D
         AcJxBl42JbOP5uEV0WDs+LkrKeavTNEyBvzvU3EUa8OLtIOzepbTTFMiSxrBhUEl0A/Z
         sEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3db/2NlEf7ssPLu2YEgcy3TYd3JpsSQjJNmsMwphW5g=;
        b=WDOrfNquFgsZTPT9LbmLyj83G/ibk8oxLGEeZEyZSJP4sWGamYEu4NhPW58tHHfKr8
         tnuY41nZIa/1E51lXPo/sEW52BOpI5C/2f1lqn8c9SFz4/tYzOwer6rJAbOFQ2cMLphm
         9BvCYc0UNgY/UEyImFjFxiRGHfz5+GvpOFoBfyWH4+IbeywIzbfi6jR7B4JOjhjzvRhE
         4OCz+4W5BLu2tQD57pQxW7D9ehwplekxBlatsngnX/maknXQtpbtIC7QrYdr0JfZhZNO
         DaEd02ZyGP/Pkga+OkIzumIIeCG02+NfmvtvaKcadp/hWQbfMc3qLgh8qI48y6c9Z0mu
         gZSg==
X-Gm-Message-State: AGi0PubuhslL5gX7okcMssWRKfssCnWDAEUxAktEXoXsqt5Sioj8aXYJ
        tuWZ9vtT8CnQOfHt3nmSuRyiJWeMDjRk
X-Google-Smtp-Source: APiQypKygteD3gmXsEskCcNV0dsRf4TLuCpfQ+sFmXvghcJdgcV/dq7r2DdQNZ/TXC6KSU9Qng9cRG7ne9lG
X-Received: by 2002:a05:6214:287:: with SMTP id l7mr4144712qvv.38.1588703386406;
 Tue, 05 May 2020 11:29:46 -0700 (PDT)
Date:   Tue,  5 May 2020 11:29:42 -0700
Message-Id: <20200505182943.218248-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH v14 0/1] perf tools: add support for libpfm4
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

v14 rebases now patches 1 to 3 are merged.
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

Stephane Eranian (1):
  perf tools: add support for libpfm4

 tools/perf/Documentation/perf-record.txt |  11 +
 tools/perf/Documentation/perf-stat.txt   |  10 +
 tools/perf/Documentation/perf-top.txt    |  11 +
 tools/perf/Makefile.config               |  13 ++
 tools/perf/Makefile.perf                 |   2 +
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
 19 files changed, 630 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/tests/pfm.c
 create mode 100644 tools/perf/util/pfm.c
 create mode 100644 tools/perf/util/pfm.h

-- 
2.26.2.526.g744177e7f7-goog

