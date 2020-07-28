Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B12305E5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgG1I5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgG1I5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:57:46 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC6EC0619D5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:57:46 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x190so13477276qke.16
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IVtLohkvByKB7JQB020jNAQ7r9C7DnrPnxkFeMwHiBg=;
        b=ILPx1sD1aeCN5pgPHt6ku/fuzS99/H+/XGMBQBA2hzytqWTNktD8E/6HCP0/yX9i1T
         2TooIupqnMv5VhTLeb96j+zNbNV5AYkDQ75e2iFi2Wxc7e9y61IOzVd+fjq35qqA8flZ
         FynkrlFSxEhFhB6tGUZoAk2ARc6Nb0dBs8F0kKJ8dXqKaDXh6d7Wc/Cuu21gWoDAtZP4
         U/I161H80tGB6kZdUf6csdFJydudxvYVcpYOs+611R+/20uMhTmkFCPPUZ4N/bjsy0BA
         5denHP9eh6G39bv0dA0RcgHQxuoSfvnN/mb3JHb45F2yruZ+GwTBbBXoRbzdgP6snUP9
         FRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IVtLohkvByKB7JQB020jNAQ7r9C7DnrPnxkFeMwHiBg=;
        b=R9XKc+sCmSOG/IhDPsX6UdzlUkbLqsBZZo0Z0STMOsqEHenT6mPjBmO80Mz1HvFOW4
         vtWV5IMl0JP3KIMTmlPIGGKT4pWwzT5Qsv7n0lVXKXr1ytVHFpcznBwD9rwSpnIVUyM4
         C+CtOHlz1uQMWcoNzWFbpTZp9wqTrNL591w4kaWXPo0QEqDuRv2TdNKCvaGIKO9g1WJo
         PBTx3TCdIwBUhMmvMnfg78JcZ0sdwBImFx8E5VLCEcH+0i6WoxHpof15fMSTGqGRoU/L
         IwLHZ3wJwVtzXPckPCMGOwsrAj8FTkL68Ab5xPXTakZMu3uj2e/4ayALj98d+eeKsz86
         lKHg==
X-Gm-Message-State: AOAM531x2ODO2fZP7e2/iNy3WDbxUSVKcd+WQGQoigpl/G5qmSgCRXrn
        KLUZypqtxRdaVwORbtbzz2gcwD6S8lKf
X-Google-Smtp-Source: ABdhPJyIgZfHKin1LciLIxcez8jCJhgJc1/oP9abqQ9PyLso35BvRfcms5FT1PFpPfJJHdGFfVZVBuLsMYOD
X-Received: by 2002:ad4:5912:: with SMTP id ez18mr25041443qvb.24.1595926665680;
 Tue, 28 Jul 2020 01:57:45 -0700 (PDT)
Date:   Tue, 28 Jul 2020 01:57:34 -0700
In-Reply-To: <20200728085734.609930-1-irogers@google.com>
Message-Id: <20200728085734.609930-6-irogers@google.com>
Mime-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH v2 5/5] perf test: Leader sampling shouldn't clear sample period
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

Add test that a sibling with leader sampling doesn't have its period
cleared.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/tests/attr/README             |  1 +
 tools/perf/tests/attr/test-record-group2 | 29 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-group2

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index 6cd408108595..a36f49fb4dbe 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -49,6 +49,7 @@ Following tests are defined (with perf commands):
   perf record --call-graph fp kill              (test-record-graph-fp)
   perf record --group -e cycles,instructions kill (test-record-group)
   perf record -e '{cycles,instructions}' kill   (test-record-group1)
+  perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
   perf record -D kill                           (test-record-no-delay)
   perf record -i kill                           (test-record-no-inherit)
   perf record -n kill                           (test-record-no-samples)
diff --git a/tools/perf/tests/attr/test-record-group2 b/tools/perf/tests/attr/test-record-group2
new file mode 100644
index 000000000000..6b9f8d182ce1
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-group2
@@ -0,0 +1,29 @@
+[config]
+command = record
+args    = --no-bpf-event -e '{cycles/period=1234000/,instructions/period=6789000/}:S' kill >/dev/null 2>&1
+ret     = 1
+
+[event-1:base-record]
+fd=1
+group_fd=-1
+config=0|1
+sample_period=1234000
+sample_type=87
+read_format=12
+inherit=0
+freq=0
+
+[event-2:base-record]
+fd=2
+group_fd=1
+config=0|1
+sample_period=6789000
+sample_type=87
+read_format=12
+disabled=0
+inherit=0
+mmap=0
+comm=0
+freq=0
+enable_on_exec=0
+task=0
-- 
2.28.0.163.g6104cc2f0b6-goog

