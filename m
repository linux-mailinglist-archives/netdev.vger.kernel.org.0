Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11382135345
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgAIGiC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Jan 2020 01:38:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38624 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728142AbgAIGiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:38:01 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0096aB6b032124
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 22:37:59 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcy1vsbst-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 22:37:59 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 22:37:57 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C45DE760FEC; Wed,  8 Jan 2020 22:37:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 5/7] selftests/bpf: Add a test for a large global function
Date:   Wed, 8 Jan 2020 22:37:43 -0800
Message-ID: <20200109063745.3154913-6-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200109063745.3154913-1-ast@kernel.org>
References: <20200109063745.3154913-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_01:2020-01-08,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 spamscore=0 mlxlogscore=996
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test results:
pyperf50 with always_inlined the same function five times: processed 46378 insns
pyperf50 with global function: processed 6102 insns

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c | 2 ++
 tools/testing/selftests/bpf/progs/pyperf.h               | 9 +++++++--
 tools/testing/selftests/bpf/progs/pyperf_global.c        | 5 +++++
 3 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_global.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index 9486c13af6b2..e9f2f12ba06b 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -48,6 +48,8 @@ void test_bpf_verif_scale(void)
 		{ "test_verif_scale2.o", BPF_PROG_TYPE_SCHED_CLS },
 		{ "test_verif_scale3.o", BPF_PROG_TYPE_SCHED_CLS },
 
+		{ "pyperf_global.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+
 		/* full unroll by llvm */
 		{ "pyperf50.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "pyperf100.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
index 71d383cc9b85..e186899954e9 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -154,7 +154,12 @@ struct {
 	__uint(value_size, sizeof(long long) * 127);
 } stackmap SEC(".maps");
 
-static __always_inline int __on_event(struct pt_regs *ctx)
+#ifdef GLOBAL_FUNC
+__attribute__((noinline))
+#else
+static __always_inline
+#endif
+int __on_event(struct bpf_raw_tracepoint_args *ctx)
 {
 	uint64_t pid_tgid = bpf_get_current_pid_tgid();
 	pid_t pid = (pid_t)(pid_tgid >> 32);
@@ -254,7 +259,7 @@ static __always_inline int __on_event(struct pt_regs *ctx)
 }
 
 SEC("raw_tracepoint/kfree_skb")
-int on_event(struct pt_regs* ctx)
+int on_event(struct bpf_raw_tracepoint_args* ctx)
 {
 	int i, ret = 0;
 	ret |= __on_event(ctx);
diff --git a/tools/testing/selftests/bpf/progs/pyperf_global.c b/tools/testing/selftests/bpf/progs/pyperf_global.c
new file mode 100644
index 000000000000..079e78a7562b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/pyperf_global.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define STACK_MAX_LEN 50
+#define GLOBAL_FUNC
+#include "pyperf.h"
-- 
2.23.0

