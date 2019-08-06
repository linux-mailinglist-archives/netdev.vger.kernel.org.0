Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2628298B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbfHFCRs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 22:17:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729921AbfHFCRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:17:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x762EeMN027684
        for <netdev@vger.kernel.org>; Mon, 5 Aug 2019 19:17:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6xqg8a1q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 19:17:47 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 5 Aug 2019 19:17:46 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 716287601A6; Mon,  5 Aug 2019 19:17:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/2] selftests/bpf: add loop test 4
Date:   Mon, 5 Aug 2019 19:17:43 -0700
Message-ID: <20190806021744.2953168-2-ast@kernel.org>
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
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060025
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_verif_scale.c |  1 +
 tools/testing/selftests/bpf/progs/loop4.c      | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/loop4.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index b4be96162ff4..e9e72d8d7aae 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -71,6 +71,7 @@ void test_bpf_verif_scale(void)
 
 		{ "loop1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "loop2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "loop4.o", BPF_PROG_TYPE_SCHED_CLS },
 
 		/* partial unroll. 19k insn in a loop.
 		 * Total program size 20.8k insn.
diff --git a/tools/testing/selftests/bpf/progs/loop4.c b/tools/testing/selftests/bpf/progs/loop4.c
new file mode 100644
index 000000000000..650859022771
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/loop4.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
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

