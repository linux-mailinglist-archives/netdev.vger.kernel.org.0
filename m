Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E66652CA47
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiESDVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiESDUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:20:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FE571D87
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g7-20020a5b0707000000b0064f39e75da4so178852ybq.17
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dwmBV4G5Hrx+MlkRr6GaHrCf5HeOC3stEpj1wSJ3O8A=;
        b=o5NjPzUznWE13DNTK0wFIG1NKbT9cGiL1lhWxHLGQ5r4bBD8e+wKWhYW3xk+khrigG
         p3tBuKe6wk9kILLORw3RjNJgw3fqxOvAEaLz5tmFWYrQen1SMb3WKawQMFJShV1sw045
         6iL9u6tHbnB4pXOc9c6ABTFFyfysO6NiVWBmEFBu4urYthwKcLYO0JgBZ2O9zSjB5Ts/
         OdPHakQX8hM2snxYehC8fyLK8FCJQxjZv22U/i+kN81boFVA+QYITEfEXoRMV+OYQVmA
         T/RiO5aoShu5XWQgrx+lb4PJs44plrEyd0wRRsN4CuB5yPzK+oAWfZ7oVifHOgBeNsB+
         EuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dwmBV4G5Hrx+MlkRr6GaHrCf5HeOC3stEpj1wSJ3O8A=;
        b=VpiZGPgdHmoW+DRAktSzviPceIbrO2aoEINrjw3soDTm8WkSbpdH2MVu7+L0WQsqmJ
         QCyL1Xgr/vppAgt2bu4nxZykQG9Ie9PYou+lFGdJMY+thvRSfVKStLiiGDMWq7KZ60kP
         MrkXZZGPX/k5IMZBix7CFnBWXAlQr1t9AA9m3sZI8Mx/4HVElzSmnLcUsDQkEs94/bzE
         zykad3+avBLGj6x1Z5mz9hHiu2kGBbsCJx6f3paAA1FQwJqhEA0VQLeE41KnmJMTqe7A
         YJZ7lzPl6gSWulRza2M4hf/3gGxTz6eKdIX9LEnr8T438GHAJZTihCVmng3cti1xcRMM
         AIpw==
X-Gm-Message-State: AOAM531Ggdv/7Q3AMhyCQeLPW7ezC/+ek3wsM7Afz81pYpLCYowSWQB/
        UtXdb36XDw7R1OaUAz+nRB2RoIjAEu1x
X-Google-Smtp-Source: ABdhPJzSCHP7XeMQopIcnWVduwBBs6JvQNIRox8q0b96Ga/SO581j62Doa4cRRTYzHBanNwOkT+LHDHRV6G3
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:a233:bf3c:6ac:2a98])
 (user=irogers job=sendgmr) by 2002:a25:230f:0:b0:64d:76e2:6aa5 with SMTP id
 j15-20020a25230f000000b0064d76e26aa5mr2481170ybj.116.1652930420577; Wed, 18
 May 2022 20:20:20 -0700 (PDT)
Date:   Wed, 18 May 2022 20:20:04 -0700
In-Reply-To: <20220519032005.1273691-1-irogers@google.com>
Message-Id: <20220519032005.1273691-5-irogers@google.com>
Mime-Version: 1.0
References: <20220519032005.1273691-1-irogers@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 4/5] perf bpf_counter: Tidy use of CPU map index
From:   Ian Rogers <irogers@google.com>
To:     Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF counters are typically running across all CPUs and so the CPU map
index and CPU number are the same. There may be cases with offline CPUs
where this isn't the case and so ensure the cpu map index for
perf_counts is going to be a valid index by explicitly iterating over
the CPU map. This also makes it clearer that users of perf_counts are
using an index. Collapse some multiple uses of perf_counts into single
uses.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/bpf_counter.c | 61 ++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index 3ce8d03cb7ec..d4931f54e1dd 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -224,25 +224,25 @@ static int bpf_program_profiler__disable(struct evsel *evsel)
 
 static int bpf_program_profiler__read(struct evsel *evsel)
 {
-	// perf_cpu_map uses /sys/devices/system/cpu/online
-	int num_cpu = evsel__nr_cpus(evsel);
 	// BPF_MAP_TYPE_PERCPU_ARRAY uses /sys/devices/system/cpu/possible
 	// Sometimes possible > online, like on a Ryzen 3900X that has 24
 	// threads but its possible showed 0-31 -acme
 	int num_cpu_bpf = libbpf_num_possible_cpus();
 	struct bpf_perf_event_value values[num_cpu_bpf];
 	struct bpf_counter *counter;
+	struct perf_counts_values *counts;
 	int reading_map_fd;
 	__u32 key = 0;
-	int err, cpu;
+	int err, idx, bpf_cpu;
 
 	if (list_empty(&evsel->bpf_counter_list))
 		return -EAGAIN;
 
-	for (cpu = 0; cpu < num_cpu; cpu++) {
-		perf_counts(evsel->counts, cpu, 0)->val = 0;
-		perf_counts(evsel->counts, cpu, 0)->ena = 0;
-		perf_counts(evsel->counts, cpu, 0)->run = 0;
+	perf_cpu_map__for_each_idx(idx, evsel__cpus(evsel)) {
+		counts = perf_counts(evsel->counts, idx, 0);
+		counts->val = 0;
+		counts->ena = 0;
+		counts->run = 0;
 	}
 	list_for_each_entry(counter, &evsel->bpf_counter_list, list) {
 		struct bpf_prog_profiler_bpf *skel = counter->skel;
@@ -256,10 +256,15 @@ static int bpf_program_profiler__read(struct evsel *evsel)
 			return err;
 		}
 
-		for (cpu = 0; cpu < num_cpu; cpu++) {
-			perf_counts(evsel->counts, cpu, 0)->val += values[cpu].counter;
-			perf_counts(evsel->counts, cpu, 0)->ena += values[cpu].enabled;
-			perf_counts(evsel->counts, cpu, 0)->run += values[cpu].running;
+		for (bpf_cpu = 0; bpf_cpu < num_cpu_bpf; bpf_cpu++) {
+			idx = perf_cpu_map__idx(evsel__cpus(evsel),
+						(struct perf_cpu){.cpu = bpf_cpu});
+			if (idx == -1)
+				continue;
+			counts = perf_counts(evsel->counts, idx, 0);
+			counts->val += values[bpf_cpu].counter;
+			counts->ena += values[bpf_cpu].enabled;
+			counts->run += values[bpf_cpu].running;
 		}
 	}
 	return 0;
@@ -621,6 +626,7 @@ static int bperf__read(struct evsel *evsel)
 	struct bperf_follower_bpf *skel = evsel->follower_skel;
 	__u32 num_cpu_bpf = cpu__max_cpu().cpu;
 	struct bpf_perf_event_value values[num_cpu_bpf];
+	struct perf_counts_values *counts;
 	int reading_map_fd, err = 0;
 	__u32 i;
 	int j;
@@ -639,29 +645,32 @@ static int bperf__read(struct evsel *evsel)
 		case BPERF_FILTER_GLOBAL:
 			assert(i == 0);
 
-			perf_cpu_map__for_each_cpu(entry, j, all_cpu_map) {
-				cpu = entry.cpu;
-				perf_counts(evsel->counts, cpu, 0)->val = values[cpu].counter;
-				perf_counts(evsel->counts, cpu, 0)->ena = values[cpu].enabled;
-				perf_counts(evsel->counts, cpu, 0)->run = values[cpu].running;
+			perf_cpu_map__for_each_cpu(entry, j, evsel__cpus(evsel)) {
+				counts = perf_counts(evsel->counts, j, 0);
+				counts->val = values[entry.cpu].counter;
+				counts->ena = values[entry.cpu].enabled;
+				counts->run = values[entry.cpu].running;
 			}
 			break;
 		case BPERF_FILTER_CPU:
-			cpu = evsel->core.cpus->map[i].cpu;
-			perf_counts(evsel->counts, i, 0)->val = values[cpu].counter;
-			perf_counts(evsel->counts, i, 0)->ena = values[cpu].enabled;
-			perf_counts(evsel->counts, i, 0)->run = values[cpu].running;
+			cpu = perf_cpu_map__cpu(evsel__cpus(evsel), i).cpu;
+			assert(cpu >= 0);
+			counts = perf_counts(evsel->counts, i, 0);
+			counts->val = values[cpu].counter;
+			counts->ena = values[cpu].enabled;
+			counts->run = values[cpu].running;
 			break;
 		case BPERF_FILTER_PID:
 		case BPERF_FILTER_TGID:
-			perf_counts(evsel->counts, 0, i)->val = 0;
-			perf_counts(evsel->counts, 0, i)->ena = 0;
-			perf_counts(evsel->counts, 0, i)->run = 0;
+			counts = perf_counts(evsel->counts, 0, i);
+			counts->val = 0;
+			counts->ena = 0;
+			counts->run = 0;
 
 			for (cpu = 0; cpu < num_cpu_bpf; cpu++) {
-				perf_counts(evsel->counts, 0, i)->val += values[cpu].counter;
-				perf_counts(evsel->counts, 0, i)->ena += values[cpu].enabled;
-				perf_counts(evsel->counts, 0, i)->run += values[cpu].running;
+				counts->val += values[cpu].counter;
+				counts->ena += values[cpu].enabled;
+				counts->run += values[cpu].running;
 			}
 			break;
 		default:
-- 
2.36.1.124.g0e6072fb45-goog

