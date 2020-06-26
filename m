Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79B920A9BE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgFZAN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:13:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725983AbgFZANy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:13:54 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05Q08iv3007909
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=r+we4rEQGEjTppL2F3NCUCIjsxEkkAqKC42zuTBexxU=;
 b=Nz8/QSqR5FwXfi+6cgwizBoqKg37ICgj6keks0i0qmI6lbdI/nI39C++KJi22vdFA/ik
 Yb3y+N2vnxoBCVr9Zc/7p98Ltu9rt+smRsmBA95q4BFu1Ozg/BHduF/ZdRH8TMZLuatc
 qQfqdUhR3XM4/5587WMnTR4ka69luqCCCpw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31ux1gjwfn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:52 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 17:13:51 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E77D262E4FA9; Thu, 25 Jun 2020 17:13:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: add bpf_iter test with bpf_get_task_stack()
Date:   Thu, 25 Jun 2020 17:13:32 -0700
Message-ID: <20200626001332.1554603-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626001332.1554603-1-songliubraving@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=8 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new test is similar to other bpf_iter tests.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 +++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 87c29dde1cf96..baa83328f810d 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -5,6 +5,7 @@
 #include "bpf_iter_netlink.skel.h"
 #include "bpf_iter_bpf_map.skel.h"
 #include "bpf_iter_task.skel.h"
+#include "bpf_iter_task_stack.skel.h"
 #include "bpf_iter_task_file.skel.h"
 #include "bpf_iter_test_kern1.skel.h"
 #include "bpf_iter_test_kern2.skel.h"
@@ -106,6 +107,20 @@ static void test_task(void)
 	bpf_iter_task__destroy(skel);
 }
=20
+static void test_task_stack(void)
+{
+	struct bpf_iter_task_stack *skel;
+
+	skel =3D bpf_iter_task_stack__open_and_load();
+	if (CHECK(!skel, "bpf_iter_task_stack__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_task_stack);
+
+	bpf_iter_task_stack__destroy(skel);
+}
+
 static void test_task_file(void)
 {
 	struct bpf_iter_task_file *skel;
@@ -392,6 +407,8 @@ void test_bpf_iter(void)
 		test_bpf_map();
 	if (test__start_subtest("task"))
 		test_task();
+	if (test__start_subtest("task_stack"))
+		test_task_stack();
 	if (test__start_subtest("task_file"))
 		test_task_file();
 	if (test__start_subtest("anon"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_task_stack.c
new file mode 100644
index 0000000000000..83aca5b1a7965
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+/* "undefine" structs in vmlinux.h, because we "override" them below */
+#define bpf_iter_meta bpf_iter_meta___not_used
+#define bpf_iter__task bpf_iter__task___not_used
+#include "vmlinux.h"
+#undef bpf_iter_meta
+#undef bpf_iter__task
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+/* bpf_get_task_stack needs a stackmap to work */
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(max_entries, 16384);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u64) * 20);
+} stackmap SEC(".maps");
+
+struct bpf_iter_meta {
+	struct seq_file *seq;
+	__u64 session_id;
+	__u64 seq_num;
+} __attribute__((preserve_access_index));
+
+struct bpf_iter__task {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+} __attribute__((preserve_access_index));
+
+#define MAX_STACK_TRACE_DEPTH   64
+unsigned long entries[MAX_STACK_TRACE_DEPTH];
+
+SEC("iter/task")
+int dump_task_stack(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	int i, retlen;
+
+	if (task =3D=3D (void *)0)
+		return 0;
+
+	retlen =3D bpf_get_task_stack(task, entries,
+				    MAX_STACK_TRACE_DEPTH * sizeof(unsigned long), 0);
+	if (retlen < 0)
+		return 0;
+
+	BPF_SEQ_PRINTF(seq, "pid: %8u num_entries: %8u\n", task->pid,
+		       retlen / sizeof(unsigned long));
+	for (i =3D 0; i < MAX_STACK_TRACE_DEPTH / sizeof(unsigned long); i++) {
+		if (retlen > i * sizeof(unsigned long))
+			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
+	}
+	BPF_SEQ_PRINTF(seq, "\n");
+
+	return 0;
+}
--=20
2.24.1

