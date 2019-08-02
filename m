Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124F78033D
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 01:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390496AbfHBXdu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Aug 2019 19:33:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390293AbfHBXdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 19:33:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72NU4Tl020723
        for <netdev@vger.kernel.org>; Fri, 2 Aug 2019 16:33:49 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u4rcf9j4g-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 16:33:49 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 16:33:48 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 392847601C2; Fri,  2 Aug 2019 16:33:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Date:   Fri, 2 Aug 2019 16:33:43 -0700
Message-ID: <20190802233344.863418-2-ast@kernel.org>
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
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020243
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that returns a 'random' number between [0, 2^20)
If state pruning is not working correctly for loop body the number of
processed insns will be 2^20 * num_of_insns_in_loop_body and the program
will be rejected.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/prog_tests/bpf_verif_scale.c          |  1 +
 tools/testing/selftests/bpf/progs/loop4.c     | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/loop4.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b4be96162ff4..757e39540eda 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -71,6 +71,7 @@ void test_bpf_verif_scale(void)
 
 		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "loop4.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 
 		/* partial unroll. 19k insn in a loop.
 		 * Total program size 20.8k insn.
diff --git a/tools/testing/selftests/bpf/progs/loop4.c b/tools/testing/selftests/bpf/progs/loop4.c
new file mode 100644
index 000000000000..3e7ee14fddbd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/loop4.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+SEC("socket")
+int combinations(volatile struct __sk_buff* skb)
+{
+	int ret = 0, i;
+
+#pragma nounroll
+	for (i = 0; i < 20; i++)
+		if (skb->len)
+			ret |= 1 << i;
+	return ret;
+}
-- 
2.20.0

