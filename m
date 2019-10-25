Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106D2E5376
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbfJYSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:10:08 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:34252 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732981AbfJYSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:08:36 -0400
Received: by mail-pg1-f202.google.com with SMTP id l11so2365200pgg.1
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kVRScVzVdmvaFoKwm7QtsLTFIeCMqlMKNHJqjiwIzwM=;
        b=AItMRH1UHy5LoenPDuyGkF1OiRvd0m877S2ToMuZivwha+hreqICwLyqyN9Ru2Y3vi
         deNqYrxmehH1S8leYnGzbZ4xYWQLuSEWdSeDdaeAOKcvVmk7a5CSvPsAdouwQJpw3iCT
         n2cLjvCsPvN6FiMbHKWUfiTAwXkiXJRhLpsaN2OXL26vA2wHypi9uFh/7qkxG3lHwCR2
         /IhupQ0bfr/hjyWVoMWXmmkEEkqPngb16yymwoKxhdzQhAapCGT7NOCnVPusDeGPFTLD
         geiDwPXy31fWFC4WLVMn2vnjZK/DSxYngLBmwARl64D+PXeGTcryng5l2NkuDZ5GUQYG
         ymGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kVRScVzVdmvaFoKwm7QtsLTFIeCMqlMKNHJqjiwIzwM=;
        b=cUnsykUoQJLp75paoIhzMG5f3aTOb+8pcyVIJgum5GyPhyHteIfF7i18leR5oHR/qZ
         D2StuVZ/ribXDgAw++HG4ZDM7UEaOzf2AZtE7cYulXFWQHddJ/yG+vQ2wlhzfJ2ylGDS
         TORYMnefRlJdabfkss/Ij0izcVwp3Eh1OZa8vm8upDKF9gZbxt3IpoeV6ffg6kI+zw7Q
         6e3hp8C0qkgOmDPoal0DTNOpVMxMSJ54Bz0vYSPJ0wg7+SGXTFonS5ow3Q3UiBRdDHTX
         ehHJIQ7rXZMTLgR/nOePFDXNFKniQJOA3/DwYSWqCcejH+lmKzmVhvv3LNc3XkNxUdbq
         NyyQ==
X-Gm-Message-State: APjAAAXYjIajbsJcKYO9k+r3hqMLOWVZXIsdhYBBfs/SypmUZSpY6nB/
        501GvgejWdWro7KO1k7g5US2dWxHllxt
X-Google-Smtp-Source: APXvYqynPqIJ4hVRg5XDUe9xe9kDv4LxessSXAhwz9Vr0geBG3zYf3JlIDqhF3KzgC8ZV8hsDgy+TiNc8doq
X-Received: by 2002:a65:6456:: with SMTP id s22mr5837656pgv.287.1572026915558;
 Fri, 25 Oct 2019 11:08:35 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:18 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191025180827.191916-1-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 0/9] Improvements to memory usage by parse events
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

The v4 patches address review comments from Jiri Olsa, turning a long
error message into a single warning, fixing the data type in a list
iterator and reordering patches.

The v3 patches address review comments from Jiri Olsa improving commit
messages, handling ENOMEM errors from strdup better, and removing a
printed warning if an invalid event is passed.

The v2 patches are preferable to an earlier proposed patch:
   perf tools: avoid reading out of scope array

Ian Rogers (9):
  perf tools: add parse events handle error
  perf tools: move ALLOC_LIST into a function
  perf tools: avoid a malloc for array events
  perf tools: splice events onto evlist even on error
  perf tools: ensure config and str in terms are unique
  perf tools: add destructors for parse event terms
  perf tools: before yyabort-ing free components
  perf tools: if pmu configuration fails free terms
  perf tools: add a deep delete for parse event terms

 tools/perf/util/parse-events.c | 177 ++++++++++-----
 tools/perf/util/parse-events.h |   3 +
 tools/perf/util/parse-events.y | 388 ++++++++++++++++++++++++---------
 tools/perf/util/pmu.c          |  32 +--
 4 files changed, 433 insertions(+), 167 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

