Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE9F8298D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbfHFCRw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 22:17:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731387AbfHFCRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:17:51 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x762GZlq026250
        for <netdev@vger.kernel.org>; Mon, 5 Aug 2019 19:17:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u6tc8984h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 19:17:50 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 5 Aug 2019 19:17:49 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9CA027601A6; Mon,  5 Aug 2019 19:17:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add loop test 5
Date:   Mon, 5 Aug 2019 19:17:44 -0700
Message-ID: <20190806021744.2953168-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190806021744.2953168-1-ast@kernel.org>
References: <20190806021744.2953168-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=941 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060026
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
 tools/testing/selftests/bpf/progs/loop5.c     | 32 +++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/loop5.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index e9e72d8d7aae..0caf8eafa9eb 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -72,6 +72,7 @@ void test_bpf_verif_scale(void)
 		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop4.o", BPF_PROG_TYPE_SCHED_CLS },
+		{ "loop5.o", BPF_PROG_TYPE_SCHED_CLS },
 
 		/* partial unroll. 19k insn in a loop.
 		 * Total program size 20.8k insn.
diff --git a/tools/testing/selftests/bpf/progs/loop5.c b/tools/testing/selftests/bpf/progs/loop5.c
new file mode 100644
index 000000000000..28d1d668f07c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/loop5.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
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
+	while (1) {
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

