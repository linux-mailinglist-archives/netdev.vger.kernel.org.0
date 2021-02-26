Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D314325A58
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhBYXo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:44:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232711AbhBYXo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:44:27 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PNZk2h002551
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3mEGsO0haNbHvy2sWt56CvAmLVAanMmXJKhfoJxZJLc=;
 b=XfWejFy66PNHTLrzN0aT4ME8d3YyRoY0SpnMA8eIJS89W44TQC4wW5Z+y6cmA84DBI7B
 3cTRDs2Sh8+R0rR4e5unNuRNMJ6uHzqslV4Dn3zHdHek2p6SBe9ddvtXAwKLvz6N9/37
 MdS4+DI9EHkwQcWx4esQ0KVEfXKvVqH5HZE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36xd17kg0v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:46 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 15:43:45 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 7C59F62E1BF5; Thu, 25 Feb 2021 15:43:41 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 bpf-next 3/6] selftests/bpf: add non-BPF_LSM test for task local storage
Date:   Thu, 25 Feb 2021 15:43:16 -0800
Message-ID: <20210225234319.336131-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210225234319.336131-1-songliubraving@fb.com>
References: <20210225234319.336131-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_15:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=990 impostorscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250179
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Task local storage is enabled for tracing programs. Add two tests for
task local storage without CONFIG_BPF_LSM.

The first test stores a value in sys_enter and read it back in sys_exit.

The second test checks whether the kernel allows allocating task local
storage in exit_creds() (which it should not).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/prog_tests/task_local_storage.c       | 69 +++++++++++++++++++
 .../selftests/bpf/progs/task_local_storage.c  | 64 +++++++++++++++++
 .../bpf/progs/task_local_storage_exit_creds.c | 32 +++++++++
 3 files changed, 165 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_sto=
rage.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_=
exit_creds.c

diff --git a/tools/testing/selftests/bpf/prog_tests/task_local_storage.c =
b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
new file mode 100644
index 0000000000000..dbb7525cdd567
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/task_local_storage.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#define _GNU_SOURCE         /* See feature_test_macros(7) */
+#include <unistd.h>
+#include <sys/syscall.h>   /* For SYS_xxx definitions */
+#include <sys/types.h>
+#include <test_progs.h>
+#include "task_local_storage.skel.h"
+#include "task_local_storage_exit_creds.skel.h"
+
+static void test_sys_enter_exit(void)
+{
+	struct task_local_storage *skel;
+	int err;
+
+	skel =3D task_local_storage__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	skel->bss->target_pid =3D syscall(SYS_gettid);
+
+	err =3D task_local_storage__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto out;
+
+	syscall(SYS_gettid);
+	syscall(SYS_gettid);
+
+	/* 3x syscalls: 1x attach and 2x gettid */
+	ASSERT_EQ(skel->bss->enter_cnt, 3, "enter_cnt");
+	ASSERT_EQ(skel->bss->exit_cnt, 3, "exit_cnt");
+	ASSERT_EQ(skel->bss->mismatch_cnt, 0, "mismatch_cnt");
+out:
+	task_local_storage__destroy(skel);
+}
+
+static void test_exit_creds(void)
+{
+	struct task_local_storage_exit_creds *skel;
+	int err;
+
+	skel =3D task_local_storage_exit_creds__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	err =3D task_local_storage_exit_creds__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
+		goto out;
+
+	/* trigger at least one exit_creds() */
+	if (CHECK_FAIL(system("ls > /dev/null")))
+		goto out;
+
+	/* sync rcu to make sure exit_creds() is called for "ls" */
+	kern_sync_rcu();
+	ASSERT_EQ(skel->bss->valid_ptr_count, 0, "valid_ptr_count");
+	ASSERT_NEQ(skel->bss->null_ptr_count, 0, "null_ptr_count");
+out:
+	task_local_storage_exit_creds__destroy(skel);
+}
+
+void test_task_local_storage(void)
+{
+	if (test__start_subtest("sys_enter_exit"))
+		test_sys_enter_exit();
+	if (test__start_subtest("exit_creds"))
+		test_exit_creds();
+}
diff --git a/tools/testing/selftests/bpf/progs/task_local_storage.c b/too=
ls/testing/selftests/bpf/progs/task_local_storage.c
new file mode 100644
index 0000000000000..80a0a20db88d2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/task_local_storage.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, long);
+} enter_id SEC(".maps");
+
+#define MAGIC_VALUE 0xabcd1234
+
+pid_t target_pid =3D 0;
+int mismatch_cnt =3D 0;
+int enter_cnt =3D 0;
+int exit_cnt =3D 0;
+
+SEC("tp_btf/sys_enter")
+int BPF_PROG(on_enter, struct pt_regs *regs, long id)
+{
+	struct task_struct *task;
+	long *ptr;
+
+	task =3D bpf_get_current_task_btf();
+	if (task->pid !=3D target_pid)
+		return 0;
+
+	ptr =3D bpf_task_storage_get(&enter_id, task, 0,
+				   BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!ptr)
+		return 0;
+
+	__sync_fetch_and_add(&enter_cnt, 1);
+	*ptr =3D MAGIC_VALUE + enter_cnt;
+
+	return 0;
+}
+
+SEC("tp_btf/sys_exit")
+int BPF_PROG(on_exit, struct pt_regs *regs, long id)
+{
+	struct task_struct *task;
+	long *ptr;
+
+	task =3D bpf_get_current_task_btf();
+	if (task->pid !=3D target_pid)
+		return 0;
+
+	ptr =3D bpf_task_storage_get(&enter_id, task, 0,
+				   BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!ptr)
+		return 0;
+
+	__sync_fetch_and_add(&exit_cnt, 1);
+	if (*ptr !=3D MAGIC_VALUE + exit_cnt)
+		__sync_fetch_and_add(&mismatch_cnt, 1);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/task_local_storage_exit_cr=
eds.c b/tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
new file mode 100644
index 0000000000000..81758c0aef993
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, __u64);
+} task_storage SEC(".maps");
+
+int valid_ptr_count =3D 0;
+int null_ptr_count =3D 0;
+
+SEC("fentry/exit_creds")
+int BPF_PROG(trace_exit_creds, struct task_struct *task)
+{
+	__u64 *ptr;
+
+	ptr =3D bpf_task_storage_get(&task_storage, task, 0,
+				   BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (ptr)
+		__sync_fetch_and_add(&valid_ptr_count, 1);
+	else
+		__sync_fetch_and_add(&null_ptr_count, 1);
+	return 0;
+}
--=20
2.24.1

