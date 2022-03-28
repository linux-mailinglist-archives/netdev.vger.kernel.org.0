Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77C4E8E1C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbiC1G0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiC1G0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:26:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC8522C4
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:30 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e689dfe112so110827677b3.20
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4TQ73I0e25XkGF6JYmSar5D4w+BV0D8V/TiHYSAl5KU=;
        b=rAbswlnujk8SJmxLde3al3arUpI/R7w91Rzm7Im3FFbuzIfrwxc+ukwRg2ubEFbel6
         u2xn9Xt+8UqLmVxVZDCy5Nby8rLxqJEd/CoGCk9U++oFpUs7RKCCFqA/YaPX4/GZKU5U
         w4zDDyta0qWgGM0toE5CfiZ51VV7n22L7WUbX6ZP1pmQMpV/LmnyXyL6MsHIdCuXlyuX
         z+SQAkei8tjNWFHynWVB1nY+gTAKs8lordMKynfqoAtLVgafdcegbc5TSy2occ4xSrIB
         kBaLqdF9P69Scb/0cyCCr6sUxseIuHLDaguZgdN1KxkbJ9A16IZ+UtqU0aR+e7aNrEl8
         vWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4TQ73I0e25XkGF6JYmSar5D4w+BV0D8V/TiHYSAl5KU=;
        b=mhN0RpLrCUfiTGzqfLWSIP5g1AZeSxIwihiVfGLKkMG+QWDxOT26byc5zmeg0OtWBc
         pwXe1WYeYip7chtoxzFUxP72xgnUYlVPmhray3R08NGV01ASo+EAoe4QNONFZW65zPEb
         K2eDRufLzLxS99RGbVpPBcTA6iSgIGWrMr2JatB7BX0HN4OjwYcDMASsmEO+/BrTF95h
         8kvzzX2vErICfpIdRL6cFNOutlFZdFJVG5qK0NpBALT4wV28ZDg7+uEKZn74pYkPtu2D
         J2Kr0BcPSgzsgV1djqu7VD4KLxA5KllfLa4qJ41PZeYsm58qqOybWcnZxByzQYnDv3Du
         r2VQ==
X-Gm-Message-State: AOAM5307GBQQu6BpX/ZHn3iE/1ICkZbt9GUn5S1JmBOx1PseeyQfuY1E
        QpKBixbubUAeP7qaS6dzxqtCc9SfItzN
X-Google-Smtp-Source: ABdhPJzzFACczXPpjcFkdPBG8L2RXqeBU42ZTsEkDl97YgxNOBZWCpXE1hi/ATJnf1wHmPGu6AqFFy8JjyPU
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:ef08:ed1b:261f:77fa])
 (user=irogers job=sendgmr) by 2002:a81:3a52:0:b0:2d7:549a:50fc with SMTP id
 h79-20020a813a52000000b002d7549a50fcmr24269495ywa.85.1648448669800; Sun, 27
 Mar 2022 23:24:29 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:24:13 -0700
In-Reply-To: <20220328062414.1893550-1-irogers@google.com>
Message-Id: <20220328062414.1893550-5-irogers@google.com>
Mime-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 4/5] perf stat: Avoid segv if core.user_cpus isn't set.
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

Passing null to perf_cpu_map__max doesn't make sense as there is no
valid max. Avoid this problem by null checking in
perf_stat_init_aggr_mode.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/builtin-stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5bee529f7656..ecd5cf4fd872 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1472,7 +1472,10 @@ static int perf_stat_init_aggr_mode(void)
 	 * taking the highest cpu number to be the size of
 	 * the aggregation translate cpumap.
 	 */
-	nr = perf_cpu_map__max(evsel_list->core.user_cpus).cpu;
+	if (evsel_list->core.user_cpus)
+		nr = perf_cpu_map__max(evsel_list->core.user_cpus).cpu;
+	else
+		nr = 0;
 	stat_config.cpus_aggr_map = cpu_aggr_map__empty_new(nr + 1);
 	return stat_config.cpus_aggr_map ? 0 : -ENOMEM;
 }
-- 
2.35.1.1021.g381101b075-goog

