Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0003E136799
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgAJGlk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 01:41:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731623AbgAJGlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:41:39 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A6aYvu025286
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 22:41:38 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdtwdfdy0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:41:37 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 22:41:36 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 55A95760DBA; Thu,  9 Jan 2020 22:41:32 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 4/6] selftests/bpf: Add a test for a large global function
Date:   Thu, 9 Jan 2020 22:41:22 -0800
Message-ID: <20200110064124.1760511-5-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200110064124.1760511-1-ast@kernel.org>
References: <20200110064124.1760511-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=1 bulkscore=0 adultscore=0
 impostorscore=0 clxscore=1034 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100055
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

