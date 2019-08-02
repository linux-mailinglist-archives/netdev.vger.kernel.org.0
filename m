Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FC280340
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390664AbfHBXdz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Aug 2019 19:33:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390534AbfHBXdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 19:33:54 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72NTMgD025559
        for <netdev@vger.kernel.org>; Fri, 2 Aug 2019 16:33:53 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u4t1bs4es-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 16:33:53 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 2 Aug 2019 16:33:51 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 444147601C2; Fri,  2 Aug 2019 16:33:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] selftests/bpf: add loop test 5
Date:   Fri, 2 Aug 2019 16:33:44 -0700
Message-ID: <20190802233344.863418-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190802233344.863418-1-ast@kernel.org>
References: <20190802233344.863418-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020243
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test with multiple exit conditions.
It's not an infinite loop only when the verifier can properly track
all math on variable 'i' through all possible ways of executing this loop.

barrier()s are needed to disable llvm optimization that combines multiple
branches into fewer branches.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
 tools/testing/selftests/bpf/progs/loop5.c     | 37 +++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/loop5.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index 757e39540eda..29615a4a9362 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -72,6 +72,7 @@ void test_bpf_verif_scale(void)
 		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "loop5.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* partial unroll. 19k insn in a loop.
 		 * Total program size 20.8k insn.
diff --git a/tools/testing/selftests/bpf/progs/loop5.c b/tools/testing/selftests/bpf/progs/loop5.c
new file mode 100644
index 000000000000..9d9817efe208
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/loop5.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+#define barrier() __asm__ __volatile__("": : :"memory")
+
+char _license[] SEC("license") = "GPL";
+
+SEC("socket")
+int while_true(volatile struct __sk_buff* skb)
+{
+	int i = 0;
+
+	while (true) {
+		if (skb->len)
+			i += 3;
+		else
+			i += 7;
+		if (i == 9)
+			break;
+		barrier();
+		if (i == 10)
+			break;
+		barrier();
+		if (i == 13)
+			break;
+		barrier();
+		if (i == 14)
+			break;
+	}
+	return i;
+}
-- 
2.20.0

