Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D62ABC2841
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbfI3VIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:08:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732270AbfI3VIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:08:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UIqk6E021897
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zwaV+OJ7JSXxFdO1J2IgI2KaYew1qxjuePxpHjuTrpc=;
 b=MV3UfvJrOvyzyMimWvTZySaEJCMSAMYzukYKN2pAHpHD6hj9t0j/l5g8CJ522M2tl3rT
 Vk7cG0dK/w72Vbgl2EcAAvrs+u5iYXCzSuLQQtsdL8tsBUffi/Q8Kj7JMs8H+CN5qLFZ
 yS2oDyNnDliAI3lSAmUsW4Bv6GZVdsu5MbA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vbm2uh1m9-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:21 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 30 Sep 2019 11:59:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0BF8986185A; Mon, 30 Sep 2019 11:59:13 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 6/6] selftests/bpf: add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro tests
Date:   Mon, 30 Sep 2019 11:58:55 -0700
Message-ID: <20190930185855.4115372-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190930185855.4115372-1-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_11:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate BPF_CORE_READ correctness and handling of up to 9 levels of
nestedness using cyclic task->(group_leader->)*->tgid chains.

Also add a test of maximum-dpeth BPF_CORE_READ_STR_INTO() macro.

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
index e5308026cfda..f318d39623b5 100644
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
 
 #define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
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

