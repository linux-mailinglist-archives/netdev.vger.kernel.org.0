Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5DB4F3B3A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKGWOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:40 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45293 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKGWOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:14:39 -0500
Received: by mail-pg1-f201.google.com with SMTP id v10so2980535pge.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 14:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=omy25HIHX5dmo9XLEd3IHF2hKxH2v3SOwm2huLFaCk0=;
        b=Mp83Scxe/sdzwo5wo5Jjh7FQgGP5b908yU23n1+o24ddFtRsO3CfPaTZBnW9isGEAf
         QjZyUketnuzTkeJVyfQK0CnYJFjwtKE3+3zAWQWIZoPGHqt0nzuJOM7Mbtl5z9JkYONB
         g4vXneS0uuWiKhHcZabafO2Lz9+cWZrt7oAq8UsZOc58taqdsgR3TGhQJ/E4U7VZlkHH
         QFNGBctK4vllT/Obpkf6fPmn+Rrs2uhgEDxc6FTbCH/p8ikg5KdRJ9QwIXKyTNSJYcKj
         UbctAIbMu/zH3zoBgsj3uEI+ZyN5IqsTjWHMdYN1Ss0Un4ffQam0qZsDF6mI0soilsEv
         oHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=omy25HIHX5dmo9XLEd3IHF2hKxH2v3SOwm2huLFaCk0=;
        b=hriIKS2z41BX/9CDUC7KGxzTS/rnTg77a8CIociUP5PGxtrwVI/TbZz37N9eXkUXIC
         XinLIaZOVVsTQYggaurEiqE6WYfMw8dHDI/YAkMta51WR/2xH9vV6jUUytO0HluDBPtf
         4VlJn8OQ6Vricv8sb4GsoGkK9DYlgTtfwdSgfdeOr9pxaxALw9X/7fP+dIORfyMoYcPq
         ZGqGTosxLLGFcHMOPzWlx4sFImbqt7iUwDGVIvxFl7Hw90cOnhBA36m9XUptGPops/MN
         Pn8XTlwBCWioqiL/n2SaHmQGLXd9dK0PVSd+oXIAVsXEWYunau/Tx/Za1u04GirRYJDN
         4y0Q==
X-Gm-Message-State: APjAAAUfIydwMlzKrWibHWjYPjoPGgXukdO2Pt3ch/sTI2WwDkiIvvKD
        VBoNfQH7w41Dzg0sBY3nDQqLtWB5IXrM
X-Google-Smtp-Source: APXvYqyrd5Cfjge5xILVt6mmEuqts4fEL98RfVNnYcg0T/W+FZno73A7rz4q/+uwquBUYqzIWPesZctI/53D
X-Received: by 2002:a63:e241:: with SMTP id y1mr7746140pgj.427.1573164878525;
 Thu, 07 Nov 2019 14:14:38 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:14:18 -0800
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191107221428.168286-1-irogers@google.com>
Mime-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v6 00/10] Improvements to memory usage by parse events
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parse events parser leaks memory for certain expressions as well
as allowing a char* to reference stack, heap or .rodata. This series
of patches improves the hygeine and adds free-ing operations to
reclaim memory in the parser in error and non-error situations.

The series of patches was generated with LLVM's address sanitizer and
libFuzzer:
https://llvm.org/docs/LibFuzzer.html
called on the parse_events function with randomly generated input. With
the patches no leaks or memory corruption issues were present.

The v6 patches address a C90 compilation issue.

The v5 patches add initial error print to the set, as requested by
Jiri Olsa. They also fix additional 2 missed frees in the patch
'before yyabort-ing free components' and remove a redundant new_str
variable from the patch 'add parse events handle error' as spotted by
Stephane Eranian.

The v4 patches address review comments from Jiri Olsa, turning a long
error message into a single warning, fixing the data type in a list
iterator and reordering patches.

The v3 patches address review comments from Jiri Olsa improving commit
messages, handling ENOMEM errors from strdup better, and removing a
printed warning if an invalid event is passed.

The v2 patches are preferable to an earlier proposed patch:
   perf tools: avoid reading out of scope array

Ian Rogers (10):
  perf tools: add parse events handle error
  perf tools: move ALLOC_LIST into a function
  perf tools: avoid a malloc for array events
  perf tools: splice events onto evlist even on error
  perf tools: ensure config and str in terms are unique
  perf tools: add destructors for parse event terms
  perf tools: before yyabort-ing free components
  perf tools: if pmu configuration fails free terms
  perf tools: add a deep delete for parse event terms
  perf tools: report initial event parsing error

 tools/perf/arch/powerpc/util/kvm-stat.c |   9 +-
 tools/perf/builtin-stat.c               |   2 +
 tools/perf/builtin-trace.c              |  16 +-
 tools/perf/tests/parse-events.c         |   3 +-
 tools/perf/util/metricgroup.c           |   2 +-
 tools/perf/util/parse-events.c          | 239 +++++++++++----
 tools/perf/util/parse-events.h          |   7 +
 tools/perf/util/parse-events.y          | 390 +++++++++++++++++-------
 tools/perf/util/pmu.c                   |  32 +-
 9 files changed, 511 insertions(+), 189 deletions(-)

-- 
2.24.0.432.g9d3f5f5b63-goog

