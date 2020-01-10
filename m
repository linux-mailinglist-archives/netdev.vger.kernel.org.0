Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB33136793
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbgAJGld convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 01:41:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731533AbgAJGld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:41:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00A6dqJC017177
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 22:41:32 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xekk1r5ah-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:41:31 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 22:41:31 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 520D3760DBA; Thu,  9 Jan 2020 22:41:30 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/6] selftests/bpf: Add fexit-to-skb test for global funcs
Date:   Thu, 9 Jan 2020 22:41:21 -0800
Message-ID: <20200110064124.1760511-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110064124.1760511-1-ast@kernel.org>
References: <20200110064124.1760511-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=1 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple fexit prog type to skb prog type test when subprogram is a global
function.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  1 +
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 15 ++++++++++
 .../selftests/bpf/progs/test_pkt_access.c     | 28 +++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index b426bf2f97e4..7d3740d38965 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -98,6 +98,7 @@ static void test_target_yes_callees(void)
 		"fexit/test_pkt_access",
 		"fexit/test_pkt_access_subprog1",
 		"fexit/test_pkt_access_subprog2",
+		"fexit/test_pkt_access_subprog3",
 	};
 	test_fexit_bpf2bpf_common("./fexit_bpf2bpf.o",
 				  "./test_pkt_access.o",
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index 2d211ee98a1c..81d7b4aaf79e 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -79,4 +79,19 @@ int test_subprog2(struct args_subprog2 *ctx)
 	test_result_subprog2 = 1;
 	return 0;
 }
+
+__u64 test_result_subprog3 = 0;
+BPF_TRACE_3("fexit/test_pkt_access_subprog3", test_subprog3,
+	    int, val, struct sk_buff *, skb, int, ret)
+{
+	int len;
+
+	__builtin_preserve_access_index(({
+		len = skb->len;
+	}));
+	if (len != 74 || ret != 74 * val || val != 3)
+		return 0;
+	test_result_subprog3 = 1;
+	return 0;
+}
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/testing/selftests/bpf/progs/test_pkt_access.c
index 3a7b4b607ed3..b77cebf71e66 100644
--- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
+++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
@@ -47,6 +47,32 @@ int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
 	return skb->len * val;
 }
 
+#define MAX_STACK (512 - 2 * 32)
+
+__attribute__ ((noinline))
+int get_skb_len(struct __sk_buff *skb)
+{
+	volatile char buf[MAX_STACK] = {};
+
+	return skb->len;
+}
+
+int get_skb_ifindex(int, struct __sk_buff *skb, int);
+
+__attribute__ ((noinline))
+int test_pkt_access_subprog3(int val, struct __sk_buff *skb)
+{
+	return get_skb_len(skb) * get_skb_ifindex(val, skb, 1);
+}
+
+__attribute__ ((noinline))
+int get_skb_ifindex(int val, struct __sk_buff *skb, int var)
+{
+	volatile char buf[MAX_STACK] = {};
+
+	return skb->ifindex * val * var;
+}
+
 SEC("classifier/test_pkt_access")
 int test_pkt_access(struct __sk_buff *skb)
 {
@@ -82,6 +108,8 @@ int test_pkt_access(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 	if (test_pkt_access_subprog2(2, skb) != skb->len * 2)
 		return TC_ACT_SHOT;
+	if (test_pkt_access_subprog3(3, skb) != skb->len * 3 * skb->ifindex)
+		return TC_ACT_SHOT;
 	if (tcp) {
 		if (((void *)(tcp) + 20) > data_end || proto != 6)
 			return TC_ACT_SHOT;
-- 
2.23.0

