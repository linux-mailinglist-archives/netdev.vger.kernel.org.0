Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10326774F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 04:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgILC5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 22:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgILC47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 22:56:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D42C0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:56:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r193so13238ybc.2
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 19:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=m07aqYCBr3BugQcnNhbXBunb8rguqcPxK+1uBceisy4=;
        b=o8gd8L6cwO7USS+zSeJvNGNPvSjkj3df9QrcXoii7Dj+MjLEgMkReLgRPFgPNejXYo
         g8ctX6BQLS0y8MwnOS362iGE3i9SUp5J8rdAlKvTa185XVXDVpcz4oY0k1uzXGqfyOfW
         AZzBINXmWkoh1485ZYyiWuYBI/48wE9i3tZEzW0MhwhDv1rTj+qkIxDXS5A1WnKz+Dxt
         s6vvazXjmoUb+Usq+xx++LL4WgmbkH6qytSUPmIKE/nmRuLZE2CNbUMo10l/uQ+meKOD
         m6W770lNlKtciQ6ta5gSZnzO5pMnznEX2vzg5toDhjVhUdVaAUk5OAlmA7QJBwfs7B+z
         4Esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=m07aqYCBr3BugQcnNhbXBunb8rguqcPxK+1uBceisy4=;
        b=jTOaYx6n4pfHAThDmDdcSnXVCi3B8LvcIE5Nw1k3cjitLz+JwnNbu7O6VWnoUDpy+L
         xmFd5RPerphrgi6I0Iwmt7x35E5lLXPsXhyari1nAgZ9oXJt4310Z6EYmEFvilL8lIW1
         gDDcuv4nJLhMiYM6DUuYf8d5bNSWMGmUe2pRBHoOfqCBzQRyQYHr4O3j/cdojBBYyYa1
         XgiVWBrWXvORMuAROS3Pgc5LuKtKjhEu/FsXpzmLiEVAUCJI0BzVBkhZzaMvJxaf2nba
         tcrVHuFpD5AnO000yC5rzUx6MCJ2V1kb66GjvCLqvXW9LPrOZ+Wd4m55AkGH5ujggMx2
         uP1Q==
X-Gm-Message-State: AOAM531H3ANB8Joh2NNhDXgESCwsse1NF2GNLHwgDLjzxcA776bKUFjF
        ZYX2AWR7wsdqb2FyVlnQ6XP61Zl+6+Rw
X-Google-Smtp-Source: ABdhPJykicvlDlpk6vddU+n3i8ZICnShO591arsdtiL3sRk9G5NjJiJWw/dwGWCtCVTJAvwbSYst8tq9iAnr
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a25:d010:: with SMTP id
 h16mr6745698ybg.439.1599879416979; Fri, 11 Sep 2020 19:56:56 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:56:51 -0700
Message-Id: <20200912025655.1337192-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v3 0/4] Fixes for setting event freq/periods
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fixes that address issues for regular and pfm4 events with 2
additional perf_event_attr tests. Various authors, David Sharp isn't
currently at Google.

v3. moved a loop into a helper following Adrian Hunter's suggestion. 
v2. corrects the commit message following Athira Rajeev's suggestion.

David Sharp (1):
  perf record: Set PERF_RECORD_PERIOD if attr->freq is set.

Ian Rogers (2):
  perf record: Don't clear event's period if set by a term
  perf test: Leader sampling shouldn't clear sample period

Stephane Eranian (1):
  perf record: Prevent override of attr->sample_period for libpfm4
    events

 tools/perf/tests/attr/README             |  1 +
 tools/perf/tests/attr/test-record-group2 | 29 ++++++++++++++++++++
 tools/perf/util/evsel.c                  | 10 ++++---
 tools/perf/util/record.c                 | 34 ++++++++++++++++++------
 4 files changed, 63 insertions(+), 11 deletions(-)
 create mode 100644 tools/perf/tests/attr/test-record-group2

-- 
2.28.0.618.gf4bc123cb7-goog

