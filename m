Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36341CA2B8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEHFgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgEHFge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:34 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287AAC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:34 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id m20so684485qvy.13
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NVxIVOTpUFm5R6D1Ik0bw3E1/vQaVLUz9mgqWgfmQ4M=;
        b=tvp8IsOM9NJeODYcUfrQdDk+mbK5pXcoU54CyXgGc9nlNplTAcXH2kjFPV4ToT5RVu
         ob/9ZHHnprIfIcW4hvYigRy+mEKhMmY0wH6kMTvsVurPm8bSSw4imsP9w9KWF7SouF/o
         5ipucGk9a4i/rpvKU5sVwzfLj7CyKWNP3SfNtAFWOaNvg/UwzRNOzLbesmH/idhQZukl
         m86Qoyo4NxTfBRTO7t8VrBQxR5TUrK5NsJE/iCeCjzTPp+UIE5dgSgIYPtPdp2cJjJRz
         7xxCRa5LDU/rijB2c3bdYXCva3gcoF9rCn8cfGw/Na17zLgn+oQ/+ntgok1PfkcLzDBX
         J1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NVxIVOTpUFm5R6D1Ik0bw3E1/vQaVLUz9mgqWgfmQ4M=;
        b=bxBb8vaVTsyVgOSkBDIRUvYE4/aEaauNVjFfyXyVQLHX1f4xByHrSncnFOBhRiLsH/
         f7vwGlNBdQhKu9vIBmQUBaRg8XXku5pTw0ZaCMb3yU7NcO9RoLIj77ZBUMzpBKAnlxLx
         XgtYqEMK6jGf2VivnW9tjr5Hq7ies1w22W4k7Ss9axiprHpqhVn3K8jPU8k7XcvQPQJB
         p+Gs8QKkOPJWkE1OSXmNFSExtrzR1brQxzrUE9BdiN7vPBtMJqvUI08RQl6bxlwUnPPs
         pmKFXwygL+mEwC9buq4ks3kjDolhqyb7yTr7NyjRp51uxmkE6OhV0txNGb/AyB6+APPh
         YmnA==
X-Gm-Message-State: AGi0PublMWdTN6VWPpYo5XqrrWz/U1SAspEBT0IP6n1qHBYpgInAR4FX
        S81wlAmayu3DY2WpwR1unj9/LB8x+OxI
X-Google-Smtp-Source: APiQypJ6oQcDstyt4s+HU1dq0c4aqe7RVxAX5TfQEd0U9dQnkRzl3SL1aOuROG0bLAIF56J2nyjgxhgE7Am3
X-Received: by 2002:a0c:ec07:: with SMTP id y7mr1059063qvo.183.1588916193207;
 Thu, 07 May 2020 22:36:33 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:15 -0700
Message-Id: <20200508053629.210324-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 00/14] Share events between metrics
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
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Metric groups contain metrics. Metrics create groups of events to
ideally be scheduled together. Often metrics refer to the same events,
for example, a cache hit and cache miss rate. Using separate event
groups means these metrics are multiplexed at different times and the
counts don't sum to 100%. More multiplexing also decreases the
accuracy of the measurement.

This change orders metrics from groups or the command line, so that
the ones with the most events are set up first. Later metrics see if
groups already provide their events, and reuse them if
possible. Unnecessary events and groups are eliminated.

The option --metric-no-group is added so that metrics aren't placed in
groups. This affects multiplexing and may increase sharing.

The option --metric-mo-merge is added and with this option the
existing grouping behavior is preserved.

RFC because:
 - without this change events within a metric may get scheduled
   together, after they may appear as part of a larger group and be
   multiplexed at different times, lowering accuracy - however, less
   multiplexing may compensate for this.
 - libbpf's hashmap is used, however, libbpf is an optional
   requirement for building perf.
 - other things I'm not thinking of.

Thanks!

Example on Sandybridge:

$ perf stat -a --metric-no-merge -M TopDownL1_SMT sleep 1

 Performance counter stats for 'system wide':

          14931177      cpu_clk_unhalted.one_thread_active #     0.47 Backend_Bound_SMT        (12.45%)
          32314653      int_misc.recovery_cycles_any                                     (16.23%)
         555020905      uops_issued.any                                               (18.85%)
        1038651176      idq_uops_not_delivered.core                                     (24.95%)
          43003170      cpu_clk_unhalted.ref_xclk                                     (25.20%)
        1154926272      cpu_clk_unhalted.thread                                       (31.50%)
         656873544      uops_retired.retire_slots                                     (31.11%)
          16491988      cpu_clk_unhalted.one_thread_active #     0.06 Bad_Speculation_SMT      (31.10%)
          32064061      int_misc.recovery_cycles_any                                     (31.04%)
         648394934      uops_issued.any                                               (31.14%)
          42107506      cpu_clk_unhalted.ref_xclk                                     (24.94%)
        1124565282      cpu_clk_unhalted.thread                                       (31.14%)
         523430886      uops_retired.retire_slots                                     (31.05%)
          12328380      cpu_clk_unhalted.one_thread_active #     0.35 Frontend_Bound_SMT       (10.08%)
          42651836      cpu_clk_unhalted.ref_xclk                                     (10.08%)
        1006287722      idq_uops_not_delivered.core                                     (10.08%)
        1130593027      cpu_clk_unhalted.thread                                       (10.08%)
          14209258      cpu_clk_unhalted.one_thread_active #     0.18 Retiring_SMT             (6.39%)
          41904474      cpu_clk_unhalted.ref_xclk                                     (6.39%)
         522251584      uops_retired.retire_slots                                     (6.39%)
        1111257754      cpu_clk_unhalted.thread                                       (6.39%)
          12930094      cpu_clk_unhalted.one_thread_active # 2865823806.05 SLOTS_SMT           (11.06%)
          40975376      cpu_clk_unhalted.ref_xclk                                     (11.06%)
        1089204936      cpu_clk_unhalted.thread                                       (11.06%)

       1.002165509 seconds time elapsed

$ perf stat -a -M TopDownL1_SMT sleep 1

 Performance counter stats for 'system wide':

          11893411      cpu_clk_unhalted.one_thread_active # 2715516883.49 SLOTS_SMT         
                                                  #     0.19 Retiring_SMT           
                                                  #     0.33 Frontend_Bound_SMT     
                                                  #     0.04 Bad_Speculation_SMT    
                                                  #     0.44 Backend_Bound_SMT        (71.46%)
          28458253      int_misc.recovery_cycles_any                                     (71.44%)
         562710994      uops_issued.any                                               (71.42%)
         907105260      idq_uops_not_delivered.core                                     (57.12%)
          39797715      cpu_clk_unhalted.ref_xclk                                     (57.12%)
        1045357060      cpu_clk_unhalted.thread                                       (71.41%)
         504809283      uops_retired.retire_slots                                     (71.44%)

       1.001939294 seconds time elapsed

Note that without merging the metrics sum to 1.06, but with merging
the sum is 1.

Example on Cascadelake:

$ perf stat -a --metric-no-merge -M TopDownL1_SMT sleep 1

 Performance counter stats for 'system wide':

          13678949      cpu_clk_unhalted.one_thread_active #     0.59 Backend_Bound_SMT        (13.35%)
         121286613      int_misc.recovery_cycles_any                                     (18.58%)
        4041490966      uops_issued.any                                               (18.81%)
        2665605457      idq_uops_not_delivered.core                                     (24.81%)
         111757608      cpu_clk_unhalted.ref_xclk                                     (25.03%)
        7579026491      cpu_clk_unhalted.thread                                       (31.27%)
        3848429110      uops_retired.retire_slots                                     (31.23%)
          15554046      cpu_clk_unhalted.one_thread_active #     0.02 Bad_Speculation_SMT      (31.19%)
         119582342      int_misc.recovery_cycles_any                                     (31.16%)
        3813943706      uops_issued.any                                               (31.14%)
         113151605      cpu_clk_unhalted.ref_xclk                                     (24.89%)
        7621196102      cpu_clk_unhalted.thread                                       (31.12%)
        3735690253      uops_retired.retire_slots                                     (31.12%)
          13727352      cpu_clk_unhalted.one_thread_active #     0.16 Frontend_Bound_SMT       (12.50%)
         115441454      cpu_clk_unhalted.ref_xclk                                     (12.50%)
        2824946246      idq_uops_not_delivered.core                                     (12.50%)
        7817227775      cpu_clk_unhalted.thread                                       (12.50%)
          13267908      cpu_clk_unhalted.one_thread_active #     0.21 Retiring_SMT             (6.31%)
         114015605      cpu_clk_unhalted.ref_xclk                                     (6.31%)
        3722498773      uops_retired.retire_slots                                     (6.31%)
        7771438396      cpu_clk_unhalted.thread                                       (6.31%)
          14948307      cpu_clk_unhalted.one_thread_active # 18085611559.36 SLOTS_SMT          (6.30%)
         115632797      cpu_clk_unhalted.ref_xclk                                     (6.30%)
        8007628156      cpu_clk_unhalted.thread                                       (6.30%)

       1.006256703 seconds time elapsed

$ perf stat -a -M TopDownL1_SMT sleep 1

 Performance counter stats for 'system wide':

          35999534      cpu_clk_unhalted.one_thread_active # 25969550384.66 SLOTS_SMT        
                                                  #     0.40 Retiring_SMT           
                                                  #     0.14 Frontend_Bound_SMT     
                                                  #     0.02 Bad_Speculation_SMT    
                                                  #     0.44 Backend_Bound_SMT        (71.35%)
         133499018      int_misc.recovery_cycles_any                                     (71.36%)
       10736468874      uops_issued.any                                               (71.40%)
        3518076530      idq_uops_not_delivered.core                                     (57.24%)
          78296616      cpu_clk_unhalted.ref_xclk                                     (57.25%)
        8894997400      cpu_clk_unhalted.thread                                       (71.50%)
       10409738753      uops_retired.retire_slots                                     (71.40%)

       1.011611791 seconds time elapsed

Note that without merging the metrics sum to 0.98, but with merging
the sum is 1.

v3. is a rebase with following the merging of patches in v2. It also
adds the metric-no-group and metric-no-merge flags.
v2. is the entire patch set based on acme's perf/core tree and includes a
cherry-picks. Patch 13 was sent for review to the bpf maintainers here:
https://lore.kernel.org/lkml/20200506205257.8964-2-irogers@google.com/
v1. was based on the perf metrics fixes and test sent here:
https://lore.kernel.org/lkml/20200501173333.227162-1-irogers@google.com/

Andrii Nakryiko (1):
  libbpf: Fix memory leak and possible double-free in hashmap__clear

Ian Rogers (13):
  perf parse-events: expand add PMU error/verbose messages
  perf test: improve pmu event metric testing
  lib/bpf hashmap: increase portability
  perf expr: fix memory leaks in bison
  perf evsel: fix 2 memory leaks
  perf expr: migrate expr ids table to libbpf's hashmap
  perf metricgroup: change evlist_used to a bitmap
  perf metricgroup: free metric_events on error
  perf metricgroup: always place duration_time last
  perf metricgroup: delay events string creation
  perf metricgroup: order event groups by size
  perf metricgroup: remove duped metric group events
  perf metricgroup: add options to not group or merge

 tools/lib/bpf/hashmap.c                |   7 +
 tools/lib/bpf/hashmap.h                |   3 +-
 tools/perf/Documentation/perf-stat.txt |  19 ++
 tools/perf/arch/x86/util/intel-pt.c    |  32 +--
 tools/perf/builtin-stat.c              |  11 +-
 tools/perf/tests/builtin-test.c        |   5 +
 tools/perf/tests/expr.c                |  41 ++--
 tools/perf/tests/pmu-events.c          | 159 +++++++++++++-
 tools/perf/tests/pmu.c                 |   4 +-
 tools/perf/tests/tests.h               |   2 +
 tools/perf/util/evsel.c                |   2 +
 tools/perf/util/expr.c                 | 129 +++++++-----
 tools/perf/util/expr.h                 |  22 +-
 tools/perf/util/expr.y                 |  25 +--
 tools/perf/util/metricgroup.c          | 277 ++++++++++++++++---------
 tools/perf/util/metricgroup.h          |   6 +-
 tools/perf/util/parse-events.c         |  29 ++-
 tools/perf/util/pmu.c                  |  33 +--
 tools/perf/util/pmu.h                  |   2 +-
 tools/perf/util/stat-shadow.c          |  49 +++--
 tools/perf/util/stat.h                 |   2 +
 21 files changed, 592 insertions(+), 267 deletions(-)

-- 
2.26.2.645.ge9eca65c58-goog

