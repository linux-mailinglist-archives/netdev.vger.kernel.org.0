Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2751C1C2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379092AbiEEOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbiEEOBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:01:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ADE220E4;
        Thu,  5 May 2022 06:57:44 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KvFc53K4NzfbJY;
        Thu,  5 May 2022 21:56:37 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 5 May
 2022 21:57:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <christylee@fb.com>
CC:     <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] perf: Fix pass 0 to PTR_ERR
Date:   Thu, 5 May 2022 21:57:13 +0800
Message-ID: <20220505135713.18496-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to PTR_ERR will result in 0 (success), also move
evlist__find_evsel_by_str() behind for minor optimization.

Fixes: 924b1cd61148 ("perf: Stop using bpf_map__def() API")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 tools/perf/util/bpf-loader.c | 15 ++++++++-------
 tools/perf/util/bpf_map.c    |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index f8ad581ea247..b301ffc8c6e7 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -1253,21 +1253,22 @@ __bpf_map__config_event(struct bpf_map *map,
 			struct parse_events_term *term,
 			struct evlist *evlist)
 {
-	struct bpf_map_op *op;
 	const char *map_name = bpf_map__name(map);
-	struct evsel *evsel = evlist__find_evsel_by_str(evlist, term->val.str);
+	struct bpf_map_op *op;
+	struct evsel *evsel;
 
+	if (!map) {
+		pr_debug("Map '%s' is invalid\n", map_name);
+		return -BPF_LOADER_ERRNO__INTERNAL;
+	}
+
+	evsel = evlist__find_evsel_by_str(evlist, term->val.str);
 	if (!evsel) {
 		pr_debug("Event (for '%s') '%s' doesn't exist\n",
 			 map_name, term->val.str);
 		return -BPF_LOADER_ERRNO__OBJCONF_MAP_NOEVT;
 	}
 
-	if (!map) {
-		pr_debug("Map '%s' is invalid\n", map_name);
-		return PTR_ERR(map);
-	}
-
 	/*
 	 * No need to check key_size and value_size:
 	 * kernel has already checked them.
diff --git a/tools/perf/util/bpf_map.c b/tools/perf/util/bpf_map.c
index c863ae0c5cb5..c72aee6a91ee 100644
--- a/tools/perf/util/bpf_map.c
+++ b/tools/perf/util/bpf_map.c
@@ -36,7 +36,7 @@ int bpf_map__fprintf(struct bpf_map *map, FILE *fp)
 		return fd;
 
 	if (!map)
-		return PTR_ERR(map);
+		return -EINVAL;
 
 	err = -ENOMEM;
 	key = malloc(bpf_map__key_size(map));
-- 
2.17.1

