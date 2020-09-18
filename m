Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C351C26F1EF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgIRCyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgIRCHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A20DF23888;
        Fri, 18 Sep 2020 02:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394837;
        bh=uPu3azdMyxArLR0MygGlpcIAE+zcq00+IfHIF4qjxpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJR+uXWi6EOF6ctkHz/+jDw5GIzLmwVXqpsqFD25uLy66ib3cFclk3K4Rm7Vr29S8
         wxJLXg2xhUJiFeD4FVCWczHHbncpfbLkcq7HgflZEazg1NT2ohw7MWYtn7tf7o0pbf
         Svr6O5yM9ZgRcGUCAXJo5ngGQNRkKp/4/H76lM14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        kp singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 296/330] perf metricgroup: Free metric_events on error
Date:   Thu, 17 Sep 2020 22:00:36 -0400
Message-Id: <20200918020110.2063155-296-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit a159e2fe89b4d1f9fb54b0ae418b961e239bf617 ]

Avoid a simple memory leak.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: kp singh <kpsingh@chromium.org>
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200508053629.210324-10-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 940a6e7a68549..7753c3091478a 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -174,6 +174,7 @@ static int metricgroup__setup_events(struct list_head *groups,
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
 					eg->metric_name, eg->metric_expr);
+			free(metric_events);
 			continue;
 		}
 		for (i = 0; i < eg->idnum; i++)
@@ -181,11 +182,13 @@ static int metricgroup__setup_events(struct list_head *groups,
 		me = metricgroup__lookup(metric_events_list, evsel, true);
 		if (!me) {
 			ret = -ENOMEM;
+			free(metric_events);
 			break;
 		}
 		expr = malloc(sizeof(struct metric_expr));
 		if (!expr) {
 			ret = -ENOMEM;
+			free(metric_events);
 			break;
 		}
 		expr->metric_expr = eg->metric_expr;
-- 
2.25.1

