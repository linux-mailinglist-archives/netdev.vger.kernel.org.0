Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54096CEF3B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbfJGWri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:47:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729615AbfJGWri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:47:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97MeZpi015587
        for <netdev@vger.kernel.org>; Mon, 7 Oct 2019 15:47:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=evTg7x0RDt/OY/iR2wRBoLaLY6CZo/8GOCOUGYUqiBw=;
 b=rg6xA2RqPKF2K3L8WD2UCrxCZYLB2e8o/a4YzPMrg/UgkYvJmiCsttATgShDjPNKMGea
 q74YJhcxyWtWIptt9OCTT2Din44iU4cCu3VTvfWNFUMoe6kUWK45cHKYue4oeoyj/MKJ
 zc5dOgeVOr9lfu6bPmFNFK5Wkybtbrkm5WU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vfaxpq6j4-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 15:47:36 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 7 Oct 2019 15:47:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CFD41861891; Mon,  7 Oct 2019 15:47:31 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 7/7] selftests/bpf: add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro tests
Date:   Mon, 7 Oct 2019 15:47:12 -0700
Message-ID: <20191007224712.1984401-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191007224712.1984401-1-andriin@fb.com>
References: <20191007224712.1984401-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_04:2019-10-07,2019-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=8 lowpriorityscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910070202
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate BPF_CORE_READ correctness and handling of up to 9 levels of
nestedness using cyclic task->(group_leader->)*->tgid chains.

Also add a test of maximum-dpeth BPF_CORE_READ_STR_INTO() macro.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  8 ++-
 .../selftests/bpf/progs/core_reloc_types.h    |  9 ++++
 .../bpf/progs/test_core_reloc_kernel.c        | 54 ++++++++++++++++++-
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index f3863f976a48..21a0dff66241 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -193,8 +193,12 @@ static struct core_reloc_test_case test_cases[] = {
 		.btf_src_file = NULL, /* load from /lib/modules/$(uname -r) */
 		.input = "",
 		.input_len = 0,
-		.output = "\1", /* true */
-		.output_len = 1,
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_kernel_output) {
+			.valid = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, },
+			.comm = "test_progs\0\0\0\0\0",
+			.comm_len = 11,
+		},
+		.output_len = sizeof(struct core_reloc_kernel_output),
 	},
 
 	/* validate BPF program can use multiple flavors to match against
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index f686a8138d90..9a6bdeb4894c 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -1,5 +1,14 @@
 #include <stdint.h>
 #include <stdbool.h>
+/*
+ * KERNEL
+ */
+
+struct core_reloc_kernel_output {
+	int valid[10];
+	char comm[16];
+	int comm_len;
+};
 
 /*
  * FLAVORS
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index 684a06cf41ea..5603a6384283 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -12,9 +12,17 @@ static volatile struct data {
 	char out[256];
 } data;
 
+struct core_reloc_kernel_output {
+	int valid[10];
+	char comm[16];
+	int comm_len;
+};
+
 struct task_struct {
 	int pid;
 	int tgid;
+	char comm[16];
+	struct task_struct *group_leader;
 };
 
 #define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*(dst)), src)
@@ -23,7 +31,9 @@ SEC("raw_tracepoint/sys_enter")
 int test_core_kernel(void *ctx)
 {
 	struct task_struct *task = (void *)bpf_get_current_task();
+	struct core_reloc_kernel_output *out = (void *)&data.out;
 	uint64_t pid_tgid = bpf_get_current_pid_tgid();
+	uint32_t real_tgid = (uint32_t)pid_tgid;
 	int pid, tgid;
 
 	if (CORE_READ(&pid, &task->pid) ||
@@ -31,7 +41,49 @@ int test_core_kernel(void *ctx)
 		return 1;
 
 	/* validate pid + tgid matches */
-	data.out[0] = (((uint64_t)pid << 32) | tgid) == pid_tgid;
+	out->valid[0] = (((uint64_t)pid << 32) | tgid) == pid_tgid;
+
+	/* test variadic BPF_CORE_READ macros */
+	out->valid[1] = BPF_CORE_READ(task,
+				      tgid) == real_tgid;
+	out->valid[2] = BPF_CORE_READ(task,
+				      group_leader,
+				      tgid) == real_tgid;
+	out->valid[3] = BPF_CORE_READ(task,
+				      group_leader, group_leader,
+				      tgid) == real_tgid;
+	out->valid[4] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      tgid) == real_tgid;
+	out->valid[5] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      group_leader,
+				      tgid) == real_tgid;
+	out->valid[6] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      group_leader, group_leader,
+				      tgid) == real_tgid;
+	out->valid[7] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      group_leader, group_leader, group_leader,
+				      tgid) == real_tgid;
+	out->valid[8] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      group_leader, group_leader, group_leader,
+				      group_leader,
+				      tgid) == real_tgid;
+	out->valid[9] = BPF_CORE_READ(task,
+				      group_leader, group_leader, group_leader,
+				      group_leader, group_leader, group_leader,
+				      group_leader, group_leader,
+				      tgid) == real_tgid;
+
+	/* test BPF_CORE_READ_STR_INTO() returns correct code and contents */
+	out->comm_len = BPF_CORE_READ_STR_INTO(
+		&out->comm, task,
+		group_leader, group_leader, group_leader, group_leader,
+		group_leader, group_leader, group_leader, group_leader,
+		comm);
 
 	return 0;
 }
-- 
2.17.1

