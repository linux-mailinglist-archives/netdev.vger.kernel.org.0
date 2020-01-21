Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9421434E3
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgAUAx7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jan 2020 19:53:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728668AbgAUAx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:53:58 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00L0qkkH015724
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 16:53:58 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xkxjt1821-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 16:53:57 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 20 Jan 2020 16:53:57 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B5A25760B6E; Mon, 20 Jan 2020 16:53:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: Add tests for program extensions
Date:   Mon, 20 Jan 2020 16:53:48 -0800
Message-ID: <20200121005348.2769920-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200121005348.2769920-1-ast@kernel.org>
References: <20200121005348.2769920-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_10:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add program extension tests that build on top of fexit_bpf2bpf tests.
Replace three global functions in previously loaded test_pkt_access.c program
with three new implementations:
int get_skb_len(struct __sk_buff *skb);
int get_constant(long val);
int get_skb_ifindex(int val, struct __sk_buff *skb, int var);
New function return the same results as original only if arguments match.

new_get_skb_ifindex() demonstrates that 'skb' argument doesn't have to be first
and only argument of BPF program. All normal skb based accesses are available.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 20 ++++++-
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 57 +++++++++++++++++++
 .../selftests/bpf/progs/test_pkt_access.c     |  8 ++-
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 7d3740d38965..db5c74d2ce6d 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -26,7 +26,7 @@ static void test_fexit_bpf2bpf_common(const char *obj_file,
 
 	link = calloc(sizeof(struct bpf_link *), prog_cnt);
 	prog = calloc(sizeof(struct bpf_program *), prog_cnt);
-	result = malloc(prog_cnt * sizeof(u64));
+	result = malloc((prog_cnt + 32 /* spare */) * sizeof(u64));
 	if (CHECK(!link || !prog || !result, "alloc_memory",
 		  "failed to alloc memory"))
 		goto close_prog;
@@ -106,8 +106,26 @@ static void test_target_yes_callees(void)
 				  prog_name);
 }
 
+static void test_func_replace(void)
+{
+	const char *prog_name[] = {
+		"fexit/test_pkt_access",
+		"fexit/test_pkt_access_subprog1",
+		"fexit/test_pkt_access_subprog2",
+		"fexit/test_pkt_access_subprog3",
+		"freplace/get_skb_len",
+		"freplace/get_skb_ifindex",
+		"freplace/get_constant",
+	};
+	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name);
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	test_target_no_callees();
 	test_target_yes_callees();
+	test_func_replace();
 }
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index ec5710767d13..c329fccf9842 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
+#include <linux/stddef.h>
+#include <linux/ipv6.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
 #include "bpf_trace_helpers.h"
 
 struct sk_buff {
@@ -94,4 +97,58 @@ int BPF_PROG(test_subprog3, int val, struct sk_buff *skb, int ret)
 	test_result_subprog3 = 1;
 	return 0;
 }
+
+__u64 test_get_skb_len = 0;
+SEC("freplace/get_skb_len")
+int new_get_skb_len(struct __sk_buff *skb)
+{
+	int len = skb->len;
+
+	if (len != 74)
+		return 0;
+	test_get_skb_len = 1;
+	return 74; /* original get_skb_len() returns skb->len */
+}
+
+__u64 test_get_skb_ifindex = 0;
+SEC("freplace/get_skb_ifindex")
+int new_get_skb_ifindex(int val, struct __sk_buff *skb, int var)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+	struct ipv6hdr ip6, *ip6p;
+	int ifindex = skb->ifindex;
+	__u32 eth_proto;
+	__u32 nh_off;
+
+	/* check that BPF extension can read packet via direct packet access */
+	if (data + 14 + sizeof(ip6) > data_end)
+		return 0;
+	ip6p = data + 14;
+
+	if (ip6p->nexthdr != 6 || ip6p->payload_len != __bpf_constant_htons(123))
+		return 0;
+
+	/* check that legacy packet access helper works too */
+	if (bpf_skb_load_bytes(skb, 14, &ip6, sizeof(ip6)) < 0)
+		return 0;
+	ip6p = &ip6;
+	if (ip6p->nexthdr != 6 || ip6p->payload_len != __bpf_constant_htons(123))
+		return 0;
+
+	if (ifindex != 1 || val != 3 || var != 1)
+		return 0;
+	test_get_skb_ifindex = 1;
+	return 3; /* original get_skb_ifindex() returns val * ifindex * var */
+}
+
+volatile __u64 test_get_constant = 0;
+SEC("freplace/get_constant")
+int new_get_constant(long val)
+{
+	if (val != 123)
+		return 0;
+	test_get_constant = 1;
+	return test_get_constant; /* original get_constant() returns val - 122 */
+}
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/testing/selftests/bpf/progs/test_pkt_access.c
index 7c9fcfd2b463..e72eba4a93d2 100644
--- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
+++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
@@ -57,12 +57,18 @@ int get_skb_len(struct __sk_buff *skb)
 	return skb->len;
 }
 
+__attribute__ ((noinline))
+int get_constant(long val)
+{
+	return val - 122;
+}
+
 int get_skb_ifindex(int, struct __sk_buff *skb, int);
 
 __attribute__ ((noinline))
 int test_pkt_access_subprog3(int val, struct __sk_buff *skb)
 {
-	return get_skb_len(skb) * get_skb_ifindex(val, skb, 1);
+	return get_skb_len(skb) * get_skb_ifindex(val, skb, get_constant(123));
 }
 
 __attribute__ ((noinline))
-- 
2.23.0

