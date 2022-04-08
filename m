Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135184F8D94
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiDHD7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiDHD6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:58:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0CEAC82
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:56:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eba0a01619so66248817b3.3
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 20:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=px/VRI5+tmvW8TY4DxlEQefxFci8hBygfH+hQRwc2I4=;
        b=jK13o5ns/33SqXgzujtB4Nxs9SV3lbqEfNf0l7f4cKbJ8BtJXG8JhtTrv6Ai2BRlEl
         PsTUd0J0QaEWpCUXE+VCR8nDFk7Y6nV1Yozfvut3l7m5nSaov6CKzDY54e8a2V3QbhO+
         LFfiDSRRVUMROTV6cf8OqnIOftobtohgynSdX4r4iSQUrnsmZZl1SH6t0hxAYIKDKO5v
         g8tF7sOTmSSf+Q3/Zs/Dlh6E9bgEp8Qu1QXketKA5vffysyL+KE+GTd4DGu2+PbSYgNU
         MEiZWs6eRTb8zr+IO4XY9VLyrGD7E9kQRKtsiynXDuYkijgu8kbuQZdhEXiequ5HjFFn
         mTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=px/VRI5+tmvW8TY4DxlEQefxFci8hBygfH+hQRwc2I4=;
        b=cQ94NcgmF8IUw4ODgTfc8fF2s2F1ULY9yDz4690N5608Y/7BFKAWrS/je4bvk/u4CB
         MZBHCo1Uu4N5YdU9liJuoctpx7Wz+l14zh0bfMEO0MkMX85a1ZNoFhwYBWYYfhEZWc/I
         KyEsyu3Id5xuXinzID+R//dsqFqyEFHXdBll8YCTwRMLO6nIVnP+cmKXpIQYbFpJ4fyd
         fXzKS88FvdPD/r0k3nlrtlHeDRXjY2RTkLpvsg6ITgM+hmSXGY9iSzsAgG1f87GGQnHQ
         qGIGHDeW3spLd3dd3ho6S8FKw2k0dwTU1xS4iR11Lc4xzzjdRN9oBi0QxUGQcsVXFVlJ
         t6uA==
X-Gm-Message-State: AOAM532+oVXtCUSvHGrSyl97Pbr0KX32PLTm2j88R+9z83ySxx2nyYIJ
        vogTF8x0pu0gOAKUKIbeNgxLEZollKxd
X-Google-Smtp-Source: ABdhPJyW3JGV3PPDdlOL7zs8MeFlVd0fGndXJiqQfDxHalseZrrLAuX3NNP+EbZB2svyS4mWYSkhL5+D0oPL
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:560:aa27:649e:a07d])
 (user=irogers job=sendgmr) by 2002:a5b:7cf:0:b0:623:df1c:b83d with SMTP id
 t15-20020a5b07cf000000b00623df1cb83dmr12538139ybq.75.1649390191633; Thu, 07
 Apr 2022 20:56:31 -0700 (PDT)
Date:   Thu,  7 Apr 2022 20:56:15 -0700
In-Reply-To: <20220408035616.1356953-1-irogers@google.com>
Message-Id: <20220408035616.1356953-5-irogers@google.com>
Mime-Version: 1.0
References: <20220408035616.1356953-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 4/5] perf evlist: Respect all_cpus when setting user_requested_cpus
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

If all_cpus is calculated it represents the merge/union of all
evsel cpu maps. By default user_requested_cpus is computed to be
the online CPUs. For uncore events, it is often the case currently
that all_cpus is a subset of user_requested_cpus. Metrics printed
without aggregation and with metric-only, in print_no_aggr_metric,
iterate over user_requested_cpus assuming every CPU has a metric to
print. For each CPU the prefix is printed, but then if the
evsel's cpus doesn't contain anything you get an empty line like
the following on a 2 socket 36 core SkylakeX:

```
$ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
     1.000453137 CPU0                       0.00
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137 CPU18                      0.00
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     1.000453137
     2.003717143 CPU0                       0.00
...
```

While it is possible to be lazier in printing the prefix and
trailing newline, having user_requested_cpus not be a subset of
all_cpus is preferential so that wasted work isn't done elsewhere
user_requested_cpus is used. The change modifies user_requested_cpus
to be the intersection of user specified CPUs, or default all online
CPUs, with the CPUs computed through the merge of all evsel cpu maps.

New behavior:
```
$ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
     1.001086325 CPU0                       0.00
     1.001086325 CPU18                      0.00
     2.003671291 CPU0                       0.00
     2.003671291 CPU18                      0.00
...
```

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/evlist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 52ea004ba01e..196d57b905a0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1036,6 +1036,13 @@ int evlist__create_maps(struct evlist *evlist, struct target *target)
 	if (!cpus)
 		goto out_delete_threads;
 
+	if (evlist->core.all_cpus) {
+		struct perf_cpu_map *tmp;
+
+		tmp = perf_cpu_map__intersect(cpus, evlist->core.all_cpus);
+		perf_cpu_map__put(cpus);
+		cpus = tmp;
+	}
 	evlist->core.has_user_cpus = !!target->cpu_list && !target->hybrid;
 
 	perf_evlist__set_maps(&evlist->core, cpus, threads);
-- 
2.35.1.1178.g4f1659d476-goog

