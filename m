Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7520E40C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390717AbgF2VUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:20:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729545AbgF2Sws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05T5qBlr008728
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:55:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LMXoHFeYD1SRI2JRp/FowRzsgayo8g+979xURW23qz8=;
 b=IBbygPifhYrbrDshoexHPwvlmW3AILeEaol5TYNFOaM9TG99uDrDYuHnK/LPA4DjeD5A
 8G0RETsEg6LEIAA8R7++5oAiuJpH3EEQlsxaxEY+FdZqAlYDn5YEllMstfN/3KJvT1mh
 IuJVPGOQ7T4pjH1ZZYMVw3nI0NKEbpYnge0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbjwtr-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 22:55:46 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 22:55:43 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B662762E5213; Sun, 28 Jun 2020 22:55:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 4/4] selftests/bpf: add bpf_iter test with bpf_get_task_stack()
Date:   Sun, 28 Jun 2020 22:55:30 -0700
Message-ID: <20200629055530.3244342-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200629055530.3244342-1-songliubraving@fb.com>
References: <20200629055530.3244342-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-29_04:2020-06-26,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=8 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new test is similar to other bpf_iter tests. It dumps all
/proc/<pid>/stack to a seq_file. Here is some example output:

pid:     2873 num_entries:        3
[<0>] worker_thread+0xc6/0x380
[<0>] kthread+0x135/0x150
[<0>] ret_from_fork+0x22/0x30

pid:     2874 num_entries:        9
[<0>] __bpf_get_stack+0x15e/0x250
[<0>] bpf_prog_22a400774977bb30_dump_task_stack+0x4a/0xb3c
[<0>] bpf_iter_run_prog+0x81/0x170
[<0>] __task_seq_show+0x58/0x80
[<0>] bpf_seq_read+0x1c3/0x3b0
[<0>] vfs_read+0x9e/0x170
[<0>] ksys_read+0xa7/0xe0
[<0>] do_syscall_64+0x4c/0xa0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Note: To print the output, it is necessary to modify the selftest.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 +++++++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 37 +++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 1e2e0fced6e81..fed42755416db 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -5,6 +5,7 @@
 #include "bpf_iter_netlink.skel.h"
 #include "bpf_iter_bpf_map.skel.h"
 #include "bpf_iter_task.skel.h"
+#include "bpf_iter_task_stack.skel.h"
 #include "bpf_iter_task_file.skel.h"
 #include "bpf_iter_tcp4.skel.h"
 #include "bpf_iter_tcp6.skel.h"
@@ -110,6 +111,20 @@ static void test_task(void)
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
@@ -452,6 +467,8 @@ void test_bpf_iter(void)
 		test_bpf_map();
 	if (test__start_subtest("task"))
 		test_task();
+	if (test__start_subtest("task_stack"))
+		test_task_stack();
 	if (test__start_subtest("task_file"))
 		test_task_file();
 	if (test__start_subtest("tcp4"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_task_stack.c
new file mode 100644
index 0000000000000..e40d32a2ed93d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+#define MAX_STACK_TRACE_DEPTH   64
+unsigned long entries[MAX_STACK_TRACE_DEPTH];
+#define SIZE_OF_ULONG (sizeof(unsigned long))
+
+SEC("iter/task")
+int dump_task_stack(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	long i, retlen;
+
+	if (task =3D=3D (void *)0)
+		return 0;
+
+	retlen =3D bpf_get_task_stack(task, entries,
+				    MAX_STACK_TRACE_DEPTH * SIZE_OF_ULONG, 0);
+	if (retlen < 0)
+		return 0;
+
+	BPF_SEQ_PRINTF(seq, "pid: %8u num_entries: %8u\n", task->pid,
+		       retlen / SIZE_OF_ULONG);
+	for (i =3D 0; i < MAX_STACK_TRACE_DEPTH; i++) {
+		if (retlen > i * SIZE_OF_ULONG)
+			BPF_SEQ_PRINTF(seq, "[<0>] %pB\n", (void *)entries[i]);
+	}
+	BPF_SEQ_PRINTF(seq, "\n");
+
+	return 0;
+}
--=20
2.24.1

