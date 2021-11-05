Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8734446B30
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKEX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:26:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhKEX0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 19:26:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5N9KNf009086
        for <netdev@vger.kernel.org>; Fri, 5 Nov 2021 16:23:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CXo6sbG9kDq354u2mmhm81ZchGAqrxodhKBJm0b5BEs=;
 b=h8Nh9hrAkaOLQ+SF5W23qZkN+16kPQdrRaLod4mgcWtzJthkI71RoWK2bNIiSq/vDK08
 vp/7wvsln2y2aQvxB2+UuLqsI8UJlygeCQNd2pPRnwWnwi5ddLj6Q7sB32484oYWg+b7
 FbrlOD4cN4ZSApyZLSfpi26xMJvpHfK/rJk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c5e1c8257-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 16:23:54 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 5 Nov 2021 16:23:53 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C68971E1DC8D4; Fri,  5 Nov 2021 16:23:49 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>,
        <hengqi.chen@gmail.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v5 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Date:   Fri, 5 Nov 2021 16:23:30 -0700
Message-ID: <20211105232330.1936330-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105232330.1936330-1-songliubraving@fb.com>
References: <20211105232330.1936330-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: SCg0UVqLUlstamqTMcJzjt3ZAtGEvCx_
X-Proofpoint-ORIG-GUID: SCg0UVqLUlstamqTMcJzjt3ZAtGEvCx_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for bpf_find_vma in perf_event program and kprobe program. The
perf_event program is triggered from NMI context, so the second call of
bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
on the other hand, does not have this constraint.

Also add tests for illegal writes to task or vma from the callback
function. The verifier should reject both cases.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/find_vma.c       | 117 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/find_vma.c  |  69 +++++++++++
 .../selftests/bpf/progs/find_vma_fail1.c      |  29 +++++
 .../selftests/bpf/progs/find_vma_fail2.c      |  29 +++++
 4 files changed, 244 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c

diff --git a/tools/testing/selftests/bpf/prog_tests/find_vma.c b/tools/te=
sting/selftests/bpf/prog_tests/find_vma.c
new file mode 100644
index 0000000000000..b74b3c0c555a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/find_vma.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include <test_progs.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "find_vma.skel.h"
+#include "find_vma_fail1.skel.h"
+#include "find_vma_fail2.skel.h"
+
+static void test_and_reset_skel(struct find_vma *skel, int expected_find=
_zero_ret)
+{
+	ASSERT_EQ(skel->bss->found_vm_exec, 1, "found_vm_exec");
+	ASSERT_EQ(skel->data->find_addr_ret, 0, "find_addr_ret");
+	ASSERT_EQ(skel->data->find_zero_ret, expected_find_zero_ret, "find_zero=
_ret");
+	ASSERT_OK_PTR(strstr(skel->bss->d_iname, "test_progs"), "find_test_prog=
s");
+
+	skel->bss->found_vm_exec =3D 0;
+	skel->data->find_addr_ret =3D -1;
+	skel->data->find_zero_ret =3D -1;
+	skel->bss->d_iname[0] =3D 0;
+}
+
+static int open_pe(void)
+{
+	struct perf_event_attr attr =3D {0};
+	int pfd;
+
+	/* create perf event */
+	attr.size =3D sizeof(attr);
+	attr.type =3D PERF_TYPE_HARDWARE;
+	attr.config =3D PERF_COUNT_HW_CPU_CYCLES;
+	attr.freq =3D 1;
+	attr.sample_freq =3D 4000;
+	pfd =3D syscall(__NR_perf_event_open, &attr, 0, -1, -1, PERF_FLAG_FD_CL=
OEXEC);
+
+	return pfd >=3D 0 ? pfd : -errno;
+}
+
+static void test_find_vma_pe(struct find_vma *skel)
+{
+	struct bpf_link *link =3D NULL;
+	volatile int j =3D 0;
+	int pfd, i;
+
+	pfd =3D open_pe();
+	if (pfd < 0) {
+		if (pfd =3D=3D -ENOENT || pfd =3D=3D -EOPNOTSUPP) {
+			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
+			test__skip();
+			goto cleanup;
+		}
+		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
+			goto cleanup;
+	}
+
+	link =3D bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
+	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
+		goto cleanup;
+
+	for (i =3D 0; i < 1000000; ++i)
+		++j;
+
+	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
+cleanup:
+	bpf_link__destroy(link);
+	close(pfd);
+}
+
+static void test_find_vma_kprobe(struct find_vma *skel)
+{
+	int err;
+
+	err =3D find_vma__attach(skel);
+	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
+		return;
+
+	getpgid(skel->bss->target_pid);
+	test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
+}
+
+static void test_illegal_write_vma(void)
+{
+	struct find_vma_fail1 *skel;
+
+	skel =3D find_vma_fail1__open_and_load();
+	if (!ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load"))
+		find_vma_fail1__destroy(skel);
+}
+
+static void test_illegal_write_task(void)
+{
+	struct find_vma_fail2 *skel;
+
+	skel =3D find_vma_fail2__open_and_load();
+	if (!ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load"))
+		find_vma_fail2__destroy(skel);
+}
+
+void serial_test_find_vma(void)
+{
+	struct find_vma *skel;
+
+	skel =3D find_vma__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
+		return;
+
+	skel->bss->target_pid =3D getpid();
+	skel->bss->addr =3D (__u64)(uintptr_t)test_find_vma_pe;
+
+	test_find_vma_pe(skel);
+	usleep(100000); /* allow the irq_work to finish */
+	test_find_vma_kprobe(skel);
+
+	find_vma__destroy(skel);
+	test_illegal_write_vma();
+	test_illegal_write_task();
+}
diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing=
/selftests/bpf/progs/find_vma.c
new file mode 100644
index 0000000000000..38034fb82530f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/find_vma.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct callback_ctx {
+	int dummy;
+};
+
+#define VM_EXEC		0x00000004
+#define DNAME_INLINE_LEN 32
+
+pid_t target_pid =3D 0;
+char d_iname[DNAME_INLINE_LEN] =3D {0};
+__u32 found_vm_exec =3D 0;
+__u64 addr =3D 0;
+int find_zero_ret =3D -1;
+int find_addr_ret =3D -1;
+
+static long check_vma(struct task_struct *task, struct vm_area_struct *v=
ma,
+		      struct callback_ctx *data)
+{
+	if (vma->vm_file)
+		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
+					  vma->vm_file->f_path.dentry->d_iname);
+
+	/* check for VM_EXEC */
+	if (vma->vm_flags & VM_EXEC)
+		found_vm_exec =3D 1;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_getpid(void)
+{
+	struct task_struct *task =3D bpf_get_current_task_btf();
+	struct callback_ctx data =3D {};
+
+	if (task->pid !=3D target_pid)
+		return 0;
+
+	find_addr_ret =3D bpf_find_vma(task, addr, check_vma, &data, 0);
+
+	/* this should return -ENOENT */
+	find_zero_ret =3D bpf_find_vma(task, 0, check_vma, &data, 0);
+	return 0;
+}
+
+SEC("perf_event")
+int handle_pe(void)
+{
+	struct task_struct *task =3D bpf_get_current_task_btf();
+	struct callback_ctx data =3D {};
+
+	if (task->pid !=3D target_pid)
+		return 0;
+
+	find_addr_ret =3D bpf_find_vma(task, addr, check_vma, &data, 0);
+
+	/* In NMI, this should return -EBUSY, as the previous call is using
+	 * the irq_work.
+	 */
+	find_zero_ret =3D bpf_find_vma(task, 0, check_vma, &data, 0);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/t=
esting/selftests/bpf/progs/find_vma_fail1.c
new file mode 100644
index 0000000000000..b3b326b8e2d1c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct callback_ctx {
+	int dummy;
+};
+
+static long write_vma(struct task_struct *task, struct vm_area_struct *v=
ma,
+		      struct callback_ctx *data)
+{
+	/* writing to vma, which is illegal */
+	vma->vm_flags |=3D 0x55;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_getpid(void)
+{
+	struct task_struct *task =3D bpf_get_current_task_btf();
+	struct callback_ctx data =3D {};
+
+	bpf_find_vma(task, 0, write_vma, &data, 0);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail2.c b/tools/t=
esting/selftests/bpf/progs/find_vma_fail2.c
new file mode 100644
index 0000000000000..9bcf3203e26b5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct callback_ctx {
+	int dummy;
+};
+
+static long write_task(struct task_struct *task, struct vm_area_struct *=
vma,
+		       struct callback_ctx *data)
+{
+	/* writing to task, which is illegal */
+	task->mm =3D NULL;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_getpid(void)
+{
+	struct task_struct *task =3D bpf_get_current_task_btf();
+	struct callback_ctx data =3D {};
+
+	bpf_find_vma(task, 0, write_task, &data, 0);
+	return 0;
+}
--=20
2.30.2

