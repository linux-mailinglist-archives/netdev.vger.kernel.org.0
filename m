Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCB3C93BF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfJBVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:51:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729594AbfJBVvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:51:10 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x92LnrTt028770
        for <netdev@vger.kernel.org>; Wed, 2 Oct 2019 14:51:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=pzzBOP9XCbc1KXJUBvFuHOCNtDmVCcr7DcjTOX9/77Y=;
 b=VlBmkHrsma9vMJ8VTsriS56m4eRWk1vqFGLaeRWgEa6073jcQcqgZDXs5qgb5F2W4m1m
 cIoxyGZpOuI/wv3M9D9jmr7z2gMOgDebORUbbHMRS9tUkMzl5qOrnVZFdMflPyS3+hJW
 yE8XL+bfFTcQ9W8oKPAdtbKuWJHklX/U20w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vcy1g9jww-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:51:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Oct 2019 14:51:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 79DF3861822; Wed,  2 Oct 2019 14:51:03 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 7/7] selftests/bpf: add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro tests
Date:   Wed, 2 Oct 2019 14:50:41 -0700
Message-ID: <20191002215041.1083058-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002215041.1083058-1-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_09:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=8 clxscore=1015 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910020173
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

