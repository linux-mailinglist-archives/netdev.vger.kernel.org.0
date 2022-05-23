Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0469531899
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbiEWRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243458AbiEWRiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 13:38:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DD8E1A7;
        Mon, 23 May 2022 10:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A22DB8121F;
        Mon, 23 May 2022 17:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7672AC34115;
        Mon, 23 May 2022 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327008;
        bh=F2f4cMvE+UbC/JsqRMOiptfgu/OZF1mHjuai93V0jlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIhcnARcX1NDyIbdJf3GTbeIEnJMZ1je0AaOa82+4+fA6r/pXTk6Wue26iChetEC3
         5PblxqAa9Eazp1lJr5mDLKckp6qBH9cX+2GYftRwC+cCiQD+pBthdQ37IVXlyzwCwq
         sl7Y/4ENTRPEfoeekGvpbglrsG7/PQN58Y0ucduY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        KP Singh <kpsingh@kernel.org>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 126/158] perf stat: Fix and validate CPU map inputs in synthetic PERF_RECORD_STAT events
Date:   Mon, 23 May 2022 19:04:43 +0200
Message-Id: <20220523165851.513336276@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 92d579ea3279aa87392b862df5810f0a7e30fcc6 ]

Stat events can come from disk and so need a degree of validation. They
contain a CPU which needs looking up via CPU map to access a counter.

Add the CPU to index translation, alongside validity checking.

Discussion thread:

  https://lore.kernel.org/linux-perf-users/CAP-5=fWQR=sCuiSMktvUtcbOLidEpUJLCybVF6=BRvORcDOq+g@mail.gmail.com/

Fixes: 7ac0089d138f80dc ("perf evsel: Pass cpu not cpu map index to synthesize")
Reported-by: Michael Petlan <mpetlan@redhat.com>
Suggested-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dave Marchevsky <davemarchevsky@fb.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Lv Ruyi <lv.ruyi@zte.com.cn>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lore.kernel.org/lkml/20220519032005.1273691-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index ee6f03481215..9c230b908b76 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -471,9 +471,10 @@ int perf_stat_process_counter(struct perf_stat_config *config,
 int perf_event__process_stat_event(struct perf_session *session,
 				   union perf_event *event)
 {
-	struct perf_counts_values count;
+	struct perf_counts_values count, *ptr;
 	struct perf_record_stat *st = &event->stat;
 	struct evsel *counter;
+	int cpu_map_idx;
 
 	count.val = st->val;
 	count.ena = st->ena;
@@ -484,8 +485,18 @@ int perf_event__process_stat_event(struct perf_session *session,
 		pr_err("Failed to resolve counter for stat event.\n");
 		return -EINVAL;
 	}
-
-	*perf_counts(counter->counts, st->cpu, st->thread) = count;
+	cpu_map_idx = perf_cpu_map__idx(evsel__cpus(counter), (struct perf_cpu){.cpu = st->cpu});
+	if (cpu_map_idx == -1) {
+		pr_err("Invalid CPU %d for event %s.\n", st->cpu, evsel__name(counter));
+		return -EINVAL;
+	}
+	ptr = perf_counts(counter->counts, cpu_map_idx, st->thread);
+	if (ptr == NULL) {
+		pr_err("Failed to find perf count for CPU %d thread %d on event %s.\n",
+			st->cpu, st->thread, evsel__name(counter));
+		return -EINVAL;
+	}
+	*ptr = count;
 	counter->supported = true;
 	return 0;
 }
-- 
2.35.1



