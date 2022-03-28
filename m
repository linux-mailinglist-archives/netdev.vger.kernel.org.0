Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4C4E8E27
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiC1G0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiC1G0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:26:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B18F522D4
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e9eb7d669fso41436967b3.14
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9DdBX2SnvA0xmL5taueohrnj4hozmwadyqsEuZMg/sA=;
        b=JExcflpahLFCp46tCO+bVKhfqtpGsdrFCJs+A4n7LEj0S0oyM28aQpiH9N2I4o3EFq
         qv6yOpmEB4FHmzEJDFtrlj5POsxwk7ymhkoAZGKLNsnrUMmG7PhVKT+rNPkl7WrEnsRG
         r+DGYQwjH6ShFQ0BJbAPo3ulaNKd7bAJJW2F8mb0pcjRDO3zlwYg6zLaYLbBc17pLs+e
         1PgB6LDqxrfexhWFD9UWMtQIlMqoh3dCxy7XUyejsjPNhj1KacYCvXPRwTBhF+BOCrYj
         K0AonuWZtGaodLfoc3NG1ln7v73zS22G4J7e++zg1bmud/pqhRfzzj1pMmNSlD2pY85i
         UZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9DdBX2SnvA0xmL5taueohrnj4hozmwadyqsEuZMg/sA=;
        b=MA9sfdl2HPXq/rPP/OyeX8JO3C1xw0lUnm6HgQh4JqCUhlmNsi/3JSgckkMtUtxHdJ
         lxWJbumk0iKWHl66kHZDf1jfZUAnEfiGG0IWUip+im1jwmjDq0sIFGzZsX+XHUkSIqM/
         Ptrc7k3xfgsscIFH+OnHzxYuX/PqK7wqvviQNcmnbtbkI9nHkPyVVQ/6rviERUWRJRst
         WAwNmo528dxXb4/AhjubKvZgLxQhIYnucNvX0z4WG2n1Wysw/WmQfR/tfYXFe7r1TR8O
         uzWL9AVdXBEeMy6IQgp2GNFHF/xwPVFO97M+mevVthTPRI3N0fIlCsluHwukuIFeMEc3
         KH0w==
X-Gm-Message-State: AOAM530wtA53M8nk097VYkIASgUoe4NYwuldGi5Gx7gj7o+mUlSCOEBf
        PPqKQV8STQR2uLKD1DuifMCJnkOutR2l
X-Google-Smtp-Source: ABdhPJxPf/g6psmSnbUpwgPJRs5+zV2W469Tco/QieQGsDIBSkUvRLgEjG1Y+RiHh3KzGowWDsrlmJTLCwDJ
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:ef08:ed1b:261f:77fa])
 (user=irogers job=sendgmr) by 2002:a25:ec08:0:b0:633:9106:b10b with SMTP id
 j8-20020a25ec08000000b006339106b10bmr22130772ybh.62.1648448672235; Sun, 27
 Mar 2022 23:24:32 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:24:14 -0700
In-Reply-To: <20220328062414.1893550-1-irogers@google.com>
Message-Id: <20220328062414.1893550-6-irogers@google.com>
Mime-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 5/5] perf evlist: Respect all_cpus when setting user_cpus
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
evsel cpu maps. By default user_cpus is computed to be the online
CPUs. For uncore events, it is often the case currently that
all_cpus is a subset of user_cpus. Metrics printed without
aggregation and with metric-only, in print_no_aggr_metric,
iterate over user_cpus assuming every CPU has a metric to
print. For each CPU the prefix is printed, but then if the
evsel's cpus doesn't contain anything you get an empty line like
the following on a SkylakeX:

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
trailing newline, having user_cpus not be a subset of all_cpus is
preferential so that wasted work isn't done elsewhere user_cpus
is used. The change modifies user_cpus to be the intersection of
user specified CPUs, or default all online CPUs, with the CPUs
computed through the merge of all evsel cpu maps.

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
 tools/perf/util/evlist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d335fb713f5e..91bbb66b7e9a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1036,6 +1036,8 @@ int evlist__create_maps(struct evlist *evlist, struct target *target)
 	if (!cpus)
 		goto out_delete_threads;
 
+	if (evlist->core.all_cpus)
+		cpus = perf_cpu_map__intersect(cpus, evlist->core.all_cpus);
 	evlist->core.has_user_cpus = !!target->cpu_list && !target->hybrid;
 
 	perf_evlist__set_maps(&evlist->core, cpus, threads);
-- 
2.35.1.1021.g381101b075-goog

