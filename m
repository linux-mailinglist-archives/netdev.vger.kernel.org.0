Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D061D7104
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfJOIac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:30:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3758 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfJOIab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:30:31 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 88D9A3F44917A8B0B694;
        Tue, 15 Oct 2019 16:30:28 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 16:30:18 +0800
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@redhat.com>, <namhyung@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <ilubashe@akamai.com>, <ak@linux.intel.com>,
        <yeyunfeng@huawei.com>, <kan.liang@linux.intel.com>,
        <alexey.budankov@linux.intel.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <hushiyuan@huawei.com>,
        <linfeilong@huawei.com>
Subject: [PATCH] perf tools: fix resource leak of closedir() on the error
 paths
Message-ID: <cd5f7cd2-b80d-6add-20a1-32f4f43e0744@huawei.com>
Date:   Tue, 15 Oct 2019 16:30:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both build_mem_topology() and rm_rf_depth_pat() have resource leak of
closedir() on the error paths.

Fix this by calling closedir() before function returns.

Fixes: e2091cedd51b ("perf tools: Add MEM_TOPOLOGY feature to perf data file")
Fixes: cdb6b0235f17 ("perf tools: Add pattern name checking to rm_rf")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 tools/perf/util/header.c | 4 +++-
 tools/perf/util/util.c   | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 86d9396..becc2d1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1296,8 +1296,10 @@ static int build_mem_topology(struct memory_node *nodes, u64 size, u64 *cntp)
 			continue;

 		if (WARN_ONCE(cnt >= size,
-			      "failed to write MEM_TOPOLOGY, way too many nodes\n"))
+			"failed to write MEM_TOPOLOGY, way too many nodes\n")) {
+			closedir(dir);
 			return -1;
+		}

 		ret = memory_node__read(&nodes[cnt++], idx);
 	}
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 5eda6e1..ae56c76 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -154,8 +154,10 @@ static int rm_rf_depth_pat(const char *path, int depth, const char **pat)
 		if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
 			continue;

-		if (!match_pat(d->d_name, pat))
-			return -2;
+		if (!match_pat(d->d_name, pat)) {
+			ret =  -2;
+			break;
+		}

 		scnprintf(namebuf, sizeof(namebuf), "%s/%s",
 			  path, d->d_name);
-- 
2.7.4.huawei.3

