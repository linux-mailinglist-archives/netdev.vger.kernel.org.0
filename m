Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC32DB769
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgLPABZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61498 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgLOXiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 18:38:02 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFNWvVK008171
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=S+EA0I96zi5nkyHqlKPU2+dcHKzq+z+TYfraL6H8TQw=;
 b=fsmBOMLRlZJPayU3mlZBmXv2MmhyKt8yuV9cfhjQsFH0qNxX7LWQ1DDS42M5aTNrk/nR
 +Otb/UPr7DTgsMEGURv7EoLhfKNpQvVabBgZ1ts6fYCocfCFhpimoVXeB3+KNEd4L4P5
 NpJAOh0Qbo73NH8TFgMdfRMgkrERr6607Hc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ej69p7af-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:20 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 15:37:16 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 3AFB962E56FB; Tue, 15 Dec 2020 15:37:13 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: add test for bpf_iter_task_vma
Date:   Tue, 15 Dec 2020 15:37:02 -0800
Message-ID: <20201215233702.3301881-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201215233702.3301881-1-songliubraving@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_13:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test dumps information similar to /proc/pid/maps. The first line of
the output is compared against the /proc file to make sure they match.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++++++++++--
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 ++
 .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++++++
 3 files changed, 160 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 0e586368948dd..7afd3abae1899 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -7,6 +7,7 @@
 #include "bpf_iter_task.skel.h"
 #include "bpf_iter_task_stack.skel.h"
 #include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_task_vma.skel.h"
 #include "bpf_iter_task_btf.skel.h"
 #include "bpf_iter_tcp4.skel.h"
 #include "bpf_iter_tcp6.skel.h"
@@ -64,6 +65,22 @@ static void do_dummy_read(struct bpf_program *prog)
 	bpf_link__destroy(link);
 }
=20
+static int read_fd_into_buffer(int fd, char *buf, int size)
+{
+	int bufleft =3D size;
+	int len;
+
+	do {
+		len =3D read(fd, buf, bufleft);
+		if (len > 0) {
+			buf +=3D len;
+			bufleft -=3D len;
+		}
+	} while (len > 0);
+
+	return len;
+}
+
 static void test_ipv6_route(void)
 {
 	struct bpf_iter_ipv6_route *skel;
@@ -177,7 +194,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel=
)
 {
 	struct bpf_program *prog =3D skel->progs.dump_task_struct;
 	struct bpf_iter_task_btf__bss *bss =3D skel->bss;
-	int iter_fd =3D -1, len =3D 0, bufleft =3D TASKBUFSZ;
+	int iter_fd =3D -1, err;
 	struct bpf_link *link;
 	char *buf =3D taskbuf;
 	int ret =3D 0;
@@ -190,14 +207,7 @@ static int do_btf_read(struct bpf_iter_task_btf *ske=
l)
 	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
 		goto free_link;
=20
-	do {
-		len =3D read(iter_fd, buf, bufleft);
-		if (len > 0) {
-			buf +=3D len;
-			bufleft -=3D len;
-		}
-	} while (len > 0);
-
+	err =3D read_fd_into_buffer(iter_fd, buf, TASKBUFSZ);
 	if (bss->skip) {
 		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
 		ret =3D 1;
@@ -205,7 +215,7 @@ static int do_btf_read(struct bpf_iter_task_btf *skel=
)
 		goto free_link;
 	}
=20
-	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+	if (CHECK(err < 0, "read", "read failed: %s\n", strerror(errno)))
 		goto free_link;
=20
 	CHECK(strstr(taskbuf, "(struct task_struct)") =3D=3D NULL,
@@ -1133,6 +1143,80 @@ static void test_buf_neg_offset(void)
 		bpf_iter_test_kern6__destroy(skel);
 }
=20
+#define CMP_BUFFER_SIZE 1024
+char task_vma_output[CMP_BUFFER_SIZE];
+char proc_maps_output[CMP_BUFFER_SIZE];
+
+/* remove \0 and \t from str, and only keep the first line */
+static void str_strip_first_line(char *str)
+{
+	char *dst =3D str, *src =3D str;
+
+	do {
+		if (*src =3D=3D ' ' || *src =3D=3D '\t')
+			src++;
+		else
+			*(dst++) =3D *(src++);
+
+	} while (*src !=3D '\0' && *src !=3D '\n');
+
+	*dst =3D '\0';
+}
+
+static void test_task_vma(void)
+{
+	int err, iter_fd =3D -1, proc_maps_fd =3D -1;
+	struct bpf_iter_task_vma *skel;
+	char maps_path[64];
+
+	skel =3D bpf_iter_task_vma__open();
+	if (CHECK(!skel, "bpf_iter_task_vma__open", "skeleton open failed\n"))
+		return;
+
+	skel->bss->pid =3D getpid();
+
+	err =3D bpf_iter_task_vma__load(skel);
+	if (CHECK(err, "bpf_iter_task_vma__load", "skeleton load failed\n"))
+		goto out;
+
+	do_dummy_read(skel->progs.proc_maps);
+
+	skel->links.proc_maps =3D bpf_program__attach_iter(
+		skel->progs.proc_maps, NULL);
+
+	if (CHECK(IS_ERR(skel->links.proc_maps), "bpf_program__attach_iter",
+		  "attach iterator failed\n"))
+		goto out;
+
+	/* read 1kB from bpf_iter */
+	iter_fd =3D bpf_iter_create(bpf_link__fd(skel->links.proc_maps));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto out;
+	err =3D read_fd_into_buffer(iter_fd, task_vma_output, CMP_BUFFER_SIZE);
+	if (CHECK(err < 0, "read_iter_fd", "read_iter_fd failed\n"))
+		goto out;
+
+	/* read 1kB from /proc/pid/maps */
+	snprintf(maps_path, 64, "/proc/%u/maps", skel->bss->pid);
+	proc_maps_fd =3D open(maps_path, O_RDONLY);
+	if (CHECK(proc_maps_fd < 0, "open_proc_maps", "open_proc_maps failed\n"=
))
+		goto out;
+	err =3D read_fd_into_buffer(proc_maps_fd, proc_maps_output, CMP_BUFFER_=
SIZE);
+	if (CHECK(err < 0, "read_prog_maps_fd", "read_prog_maps_fd failed\n"))
+		goto out;
+
+	/* strip and compare the first line of the two files */
+	str_strip_first_line(task_vma_output);
+	str_strip_first_line(proc_maps_output);
+
+	CHECK(strcmp(task_vma_output, proc_maps_output), "compare_output",
+	      "found mismatch\n");
+out:
+	close(proc_maps_fd);
+	close(iter_fd);
+	bpf_iter_task_vma__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -1149,6 +1233,8 @@ void test_bpf_iter(void)
 		test_task_stack();
 	if (test__start_subtest("task_file"))
 		test_task_file();
+	if (test__start_subtest("task_vma"))
+		test_task_vma();
 	if (test__start_subtest("task_btf"))
 		test_task_btf();
 	if (test__start_subtest("tcp4"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing=
/selftests/bpf/progs/bpf_iter.h
index 6a1255465fd6d..4dab0869c4fcb 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -7,6 +7,7 @@
 #define bpf_iter__netlink bpf_iter__netlink___not_used
 #define bpf_iter__task bpf_iter__task___not_used
 #define bpf_iter__task_file bpf_iter__task_file___not_used
+#define bpf_iter__task_vma bpf_iter__task_vma___not_used
 #define bpf_iter__tcp bpf_iter__tcp___not_used
 #define tcp6_sock tcp6_sock___not_used
 #define bpf_iter__udp bpf_iter__udp___not_used
@@ -26,6 +27,7 @@
 #undef bpf_iter__netlink
 #undef bpf_iter__task
 #undef bpf_iter__task_file
+#undef bpf_iter__task_vma
 #undef bpf_iter__tcp
 #undef tcp6_sock
 #undef bpf_iter__udp
@@ -67,6 +69,13 @@ struct bpf_iter__task_file {
 	struct file *file;
 } __attribute__((preserve_access_index));
=20
+struct bpf_iter__task_vma {
+	struct bpf_iter_meta *meta;
+	struct task_struct *task;
+	struct __vm_area_struct *vma;
+	struct file *file;
+} __attribute__((preserve_access_index));
+
 struct bpf_iter__bpf_map {
 	struct bpf_iter_meta *meta;
 	struct bpf_map *map;
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c b/tool=
s/testing/selftests/bpf/progs/bpf_iter_task_vma.c
new file mode 100644
index 0000000000000..ba87afe01024c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+/* Copied from mm.h */
+#define VM_READ		0x00000001
+#define VM_WRITE	0x00000002
+#define VM_EXEC		0x00000004
+#define VM_MAYSHARE	0x00000080
+
+/* Copied from kdev_t.h */
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+
+#define D_PATH_BUF_SIZE 1024
+char d_path_buf[D_PATH_BUF_SIZE];
+__u32 pid;
+
+SEC("iter.s/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
+{
+	struct __vm_area_struct *vma =3D ctx->vma;
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	struct file *file =3D ctx->file;
+	char perm_str[] =3D "----";
+
+	if (task =3D=3D (void *)0 || vma =3D=3D (void *)0 || task->pid !=3D pid=
)
+		return 0;
+
+	perm_str[0] =3D (vma->flags & VM_READ) ? 'r' : '-';
+	perm_str[1] =3D (vma->flags & VM_WRITE) ? 'w' : '-';
+	perm_str[2] =3D (vma->flags & VM_EXEC) ? 'x' : '-';
+	perm_str[3] =3D (vma->flags & VM_MAYSHARE) ? 's' : 'p';
+	BPF_SEQ_PRINTF(seq, "%08llx-%08llx %s ", vma->start, vma->end, perm_str=
);
+
+	if (file) {
+		__u32 dev =3D file->f_inode->i_sb->s_dev;
+
+		bpf_d_path(&file->f_path, d_path_buf, D_PATH_BUF_SIZE);
+
+		BPF_SEQ_PRINTF(seq, "%08llx ", vma->pgoff << 12);
+		BPF_SEQ_PRINTF(seq, "%02x:%02x %u", MAJOR(dev), MINOR(dev),
+			       file->f_inode->i_ino);
+		BPF_SEQ_PRINTF(seq, "\t%s\n", d_path_buf);
+	} else {
+		BPF_SEQ_PRINTF(seq, "%08llx 00:00 0\n", 0ULL);
+	}
+	return 0;
+}
--=20
2.24.1

