Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD6382630
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhEQIGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:06:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3777 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbhEQIGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:06:46 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBRr13V7zmjFf;
        Mon, 17 May 2021 16:02:00 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 16:05:27 +0800
Received: from huawei.com (10.175.127.227) by dggema762-chm.china.huawei.com
 (10.1.198.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 17
 May 2021 16:05:26 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] perf stat: Fix error return code in bperf__load()
Date:   Mon, 17 May 2021 16:12:54 +0800
Message-ID: <20210517081254.1561564-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tools/perf/util/bpf_counter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
index ddb52f748c8e..843b20aa6688 100644
--- a/tools/perf/util/bpf_counter.c
+++ b/tools/perf/util/bpf_counter.c
@@ -522,6 +522,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
 	evsel->bperf_leader_link_fd = bpf_link_get_fd_by_id(entry.link_id);
 	if (evsel->bperf_leader_link_fd < 0 &&
 	    bperf_reload_leader_program(evsel, attr_map_fd, &entry))
+		err = -1;
 		goto out;
 
 	/*
@@ -550,6 +551,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
 	/* Step 2: load the follower skeleton */
 	evsel->follower_skel = bperf_follower_bpf__open();
 	if (!evsel->follower_skel) {
+		err = -1;
 		pr_err("Failed to open follower skeleton\n");
 		goto out;
 	}
-- 
2.25.4

