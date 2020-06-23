Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98A204A85
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbgFWHIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:08:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27598 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731068AbgFWHI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:08:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N74B7S029313
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=n7+ccP8jkYjwvnQfwcVf+CiZN1OfCu4uUc86RW/6OMQ=;
 b=Cxmm6F5Xgu9XPMOioiIWa58UL4l+B4I+1aLfMvGu6jVk+3mgPupnvD3bqJDwTajQtdRE
 Hd/cCCqe/bzGW0U6hfc9HKw0G3qXajCq3es9D3yXEnAeDKHqZzkBYOE6KHwbURlwoMO1
 fWkewyt9TOEMMD9lLIloRCe0m7/7ERjmD/I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31t2e8sntb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:08:27 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 00:08:26 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5CBD562E50B5; Tue, 23 Jun 2020 00:08:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] selftests/bpf: add bpf_iter test with bpf_get_task_stack_trace()
Date:   Tue, 23 Jun 2020 00:08:02 -0700
Message-ID: <20200623070802.2310018-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623070802.2310018-1-songliubraving@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=8 bulkscore=0 cotscore=-2147483648 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new test is similar to other bpf_iter tests.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 50 +++++++++++++++++++
 2 files changed, 67 insertions(+)
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
index 0000000000000..4fc939e0fca77
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
@@ -0,0 +1,50 @@
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
+	unsigned int i, num_entries;
+
+	if (task =3D=3D (void *)0)
+		return 0;
+
+	num_entries =3D bpf_get_task_stack_trace(task, entries, MAX_STACK_TRACE=
_DEPTH);
+
+	BPF_SEQ_PRINTF(seq, "pid: %8u\n", task->pid);
+
+	for (i =3D 0; i < MAX_STACK_TRACE_DEPTH; i++) {
+		if (num_entries > i)
+			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
+	}
+
+	BPF_SEQ_PRINTF(seq, "\n");
+
+	return 0;
+}
--=20
2.24.1

