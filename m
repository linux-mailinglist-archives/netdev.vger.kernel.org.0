Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FAA509F4D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383120AbiDUMKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351963AbiDUMKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:10:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F9B1F63A;
        Thu, 21 Apr 2022 05:07:44 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Kkbrh5NmtzhXXY;
        Thu, 21 Apr 2022 20:07:32 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 21 Apr
 2022 20:07:41 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>
CC:     <weiyongjun1@huawei.com>, <shaozhengchao@huawei.com>,
        <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] samples/bpf: detach xdp prog when program exits unexpectedly in xdp_rxq_info_user
Date:   Thu, 21 Apr 2022 20:09:25 +0800
Message-ID: <20220421120925.330160-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When xdp_rxq_info_user program exits unexpectedly, it doesn't detach xdp
prog of device, and other xdp prog can't be attached to the device. So
call init_exit() to detach xdp prog when program exits unexpectedly.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 samples/bpf/xdp_rxq_info_user.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index f2d90cba5164..6378007e085a 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -18,7 +18,7 @@ static const char *__doc__ = " XDP RX-queue info extract example\n\n"
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
-
+#include <limits.h>
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
@@ -44,6 +44,9 @@ static struct bpf_map *rx_queue_index_map;
 #define EXIT_FAIL_BPF		4
 #define EXIT_FAIL_MEM		5
 
+#define FAIL_MEM_SIG		INT_MAX
+#define FAIL_STAT_SIG		(INT_MAX - 1)
+
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"dev",		required_argument,	NULL, 'd' },
@@ -77,6 +80,12 @@ static void int_exit(int sig)
 			printf("program on interface changed, not removing\n");
 		}
 	}
+
+	if (sig == FAIL_MEM_SIG)
+		exit(EXIT_FAIL_MEM);
+	else if (sig == FAIL_STAT_SIG)
+		exit(EXIT_FAIL);
+
 	exit(EXIT_OK);
 }
 
@@ -141,7 +150,7 @@ static char* options2str(enum cfg_options_flags flag)
 	if (flag & READ_MEM)
 		return "read";
 	fprintf(stderr, "ERR: Unknown config option flags");
-	exit(EXIT_FAIL);
+	int_exit(FAIL_STAT_SIG);
 }
 
 static void usage(char *argv[])
@@ -174,7 +183,7 @@ static __u64 gettime(void)
 	res = clock_gettime(CLOCK_MONOTONIC, &t);
 	if (res < 0) {
 		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAIL);
+		int_exit(FAIL_STAT_SIG);
 	}
 	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
 }
@@ -202,7 +211,7 @@ static struct datarec *alloc_record_per_cpu(void)
 	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
-		exit(EXIT_FAIL_MEM);
+		int_exit(FAIL_MEM_SIG);
 	}
 	return array;
 }
@@ -215,7 +224,7 @@ static struct record *alloc_record_per_rxq(void)
 	array = calloc(nr_rxqs, sizeof(struct record));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
-		exit(EXIT_FAIL_MEM);
+		int_exit(FAIL_MEM_SIG);
 	}
 	return array;
 }
@@ -229,7 +238,7 @@ static struct stats_record *alloc_stats_record(void)
 	rec = calloc(1, sizeof(struct stats_record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
+		int_exit(FAIL_MEM_SIG);
 	}
 	rec->rxq = alloc_record_per_rxq();
 	for (i = 0; i < nr_rxqs; i++)
-- 
2.17.1

