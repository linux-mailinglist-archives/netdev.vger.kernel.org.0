Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D373F2746
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfKGFrB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726730AbfKGFrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:01 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75hU2k000710
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:46:59 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6ug9m-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:46:59 -0800
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:46:57 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 745DA760BC0; Wed,  6 Nov 2019 21:46:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 05/17] selftest/bpf: Simple test for fentry/fexit
Date:   Wed, 6 Nov 2019 21:46:32 -0800
Message-ID: <20191107054644.1285697-6-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=3 spamscore=0 mlxlogscore=777
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple test for fentry and fexit programs around eth_type_trans.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/kfree_skb.c      | 42 +++++++++++++--
 tools/testing/selftests/bpf/progs/kfree_skb.c | 52 +++++++++++++++++++
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index 430b50de1583..2c2a569b7d3a 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -30,17 +30,20 @@ void test_kfree_skb(void)
 		.file = "./kfree_skb.o",
 	};
 
+	struct bpf_link *link = NULL, *link_fentry = NULL, *link_fexit = NULL;
+	struct bpf_program *prog, *fentry, *fexit;
 	struct bpf_object *obj, *obj2 = NULL;
 	struct perf_buffer_opts pb_opts = {};
 	struct perf_buffer *pb = NULL;
-	struct bpf_link *link = NULL;
-	struct bpf_map *perf_buf_map;
-	struct bpf_program *prog;
+	struct bpf_map *perf_buf_map, *global_data;
 	__u32 duration, retval;
 	int err, pkt_fd, kfree_skb_fd;
 	bool passed = false;
+	const int zero = 0;
+	bool test_ok[2];
 
-	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);
+	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &pkt_fd);
 	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
 		return;
 
@@ -51,9 +54,28 @@ void test_kfree_skb(void)
 	prog = bpf_object__find_program_by_title(obj2, "tp_btf/kfree_skb");
 	if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
 		goto close_prog;
+	fentry = bpf_object__find_program_by_title(obj2, "fentry/eth_type_trans");
+	if (CHECK(!fentry, "find_prog", "prog eth_type_trans not found\n"))
+		goto close_prog;
+	fexit = bpf_object__find_program_by_title(obj2, "fexit/eth_type_trans");
+	if (CHECK(!fexit, "find_prog", "prog eth_type_trans not found\n"))
+		goto close_prog;
+
+	global_data = bpf_object__find_map_by_name(obj2, "kfree_sk.bss");
+	if (CHECK(!global_data, "find global data", "not found\n"))
+		goto close_prog;
+
 	link = bpf_program__attach_raw_tracepoint(prog, NULL);
 	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
 		goto close_prog;
+	link_fentry = bpf_program__attach_trace(fentry);
+	if (CHECK(IS_ERR(link_fentry), "attach fentry", "err %ld\n",
+		  PTR_ERR(link_fentry)))
+		goto close_prog;
+	link_fexit = bpf_program__attach_trace(fexit);
+	if (CHECK(IS_ERR(link_fexit), "attach fexit", "err %ld\n",
+		  PTR_ERR(link_fexit)))
+		goto close_prog;
 
 	perf_buf_map = bpf_object__find_map_by_name(obj2, "perf_buf_map");
 	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
@@ -76,14 +98,26 @@ void test_kfree_skb(void)
 	err = perf_buffer__poll(pb, 100);
 	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
 		goto close_prog;
+
 	/* make sure kfree_skb program was triggered
 	 * and it sent expected skb into ring buffer
 	 */
 	CHECK_FAIL(!passed);
+
+	err = bpf_map_lookup_elem(bpf_map__fd(global_data), &zero, test_ok);
+	if (CHECK(err, "get_result",
+		  "failed to get output data: %d\n", err))
+		goto close_prog;
+
+	CHECK_FAIL(!test_ok[0] || !test_ok[1]);
 close_prog:
 	perf_buffer__free(pb);
 	if (!IS_ERR_OR_NULL(link))
 		bpf_link__destroy(link);
+	if (!IS_ERR_OR_NULL(link_fentry))
+		bpf_link__destroy(link_fentry);
+	if (!IS_ERR_OR_NULL(link_fexit))
+		bpf_link__destroy(link_fexit);
 	bpf_object__close(obj);
 	bpf_object__close(obj2);
 }
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index 489319ea1d6a..33fb87ebddee 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
 #include <linux/bpf.h>
+#include <stdbool.h>
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
 
@@ -101,3 +102,54 @@ int trace_kfree_skb(struct trace_kfree_skb *ctx)
 		       &ifindex, sizeof(ifindex));
 	return 0;
 }
+
+static volatile struct {
+	bool fentry_test_ok;
+	bool fexit_test_ok;
+} result;
+
+struct eth_type_trans_args {
+	struct sk_buff *skb;
+	struct net_device *dev;
+	unsigned short protocol; /* return value available to fexit progs */
+};
+
+SEC("fentry/eth_type_trans")
+int fentry_eth_type_trans(struct eth_type_trans_args *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	struct net_device *dev = ctx->dev;
+	int len, ifindex;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+		ifindex = dev->ifindex;
+	}));
+
+	/* fentry sees full packet including L2 header */
+	if (len != 74 || ifindex != 1)
+		return 0;
+	result.fentry_test_ok = true;
+	return 0;
+}
+
+SEC("fexit/eth_type_trans")
+int fexit_eth_type_trans(struct eth_type_trans_args *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	struct net_device *dev = ctx->dev;
+	int len, ifindex;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+		ifindex = dev->ifindex;
+	}));
+
+	/* fexit sees packet without L2 header that eth_type_trans should have
+	 * consumed.
+	 */
+	if (len != 60 || ctx->protocol != bpf_htons(0x86dd) || ifindex != 1)
+		return 0;
+	result.fexit_test_ok = true;
+	return 0;
+}
-- 
2.23.0

