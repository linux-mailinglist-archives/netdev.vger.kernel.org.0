Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264BA1AB1B0
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436927AbgDOT3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42818 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406962AbgDOT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJPM7s008538
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=I1YS1gEyALHVuQVFkEuG1LVeNLe7wTQz2x7vQOmKeck=;
 b=eYiGyKmD/ronn/VUqlb2QZIDY5OXKBmOWzHWfYZ7hya0enmWjD2UWofmjYqxi+XZKbnH
 s3wh95VlZDUeKkZOsa7Ae3uE7BsCakj2ZshVKBZ9CKStrSWebtjuv6eJT0la3pCqL/kd
 vRIj4UODV3g0vhyZzaptUeMzG1Bv9tiZaMk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7t7m78-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:27 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 533CA3700AF5; Wed, 15 Apr 2020 12:27:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 16/17] tools/bpf: selftests: add dumper progs for bpf_map/task/task_file
Date:   Wed, 15 Apr 2020 12:27:59 -0700
Message-ID: <20200415192759.4084166-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The implementation is arbitrary, just to show how the bpf programs
can be written for bpf_map/task/task_file. They can be costomized
for specific needs.

For example, for bpf_map, the dumper prints out:
  $ cat /sys/kernel/bpfdump/bpf_map/my1
      id   refcnt  usercnt  locked_vm
       3        2        0         20
       6        2        0         20
       9        2        0         20
      12        2        0         20
      13        2        0         20
      16        2        0         20
      19        2        0         20
      =3D=3D=3D END =3D=3D=3D

For task, the dumper prints out:
  $ cat /sys/kernel/bpfdump/task/my1
    tgid      gid
       1        1
       2        2
    ....
    1944     1944
    1948     1948
    1949     1949
    1953     1953
    =3D=3D=3D END =3D=3D=3D

For task/file, the dumper prints out:
  $ cat /sys/kernel/bpfdump/task/file/my1
    tgid      gid       fd      file
       1        1        0 ffffffff95c97600
       1        1        1 ffffffff95c97600
       1        1        2 ffffffff95c97600
    ....
    1895     1895      255 ffffffff95c8fe00
    1932     1932        0 ffffffff95c8fe00
    1932     1932        1 ffffffff95c8fe00
    1932     1932        2 ffffffff95c8fe00
    1932     1932        3 ffffffff95c185c0

This is able to print out all open files (fd and file->f_op), so user can=
 compare
f_op against a particular kernel file operations to find what it is.
For example, from /proc/kallsyms, we can find
  ffffffff95c185c0 r eventfd_fops
so we will know tgid 1932 fd 3 is an eventfd file descriptor.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/bpfdump_bpf_map.c     | 33 +++++++++++++++++++
 .../selftests/bpf/progs/bpfdump_task.c        | 29 ++++++++++++++++
 .../selftests/bpf/progs/bpfdump_task_file.c   | 30 +++++++++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task_file.c

diff --git a/tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c b/tools/=
testing/selftests/bpf/progs/bpfdump_bpf_map.c
new file mode 100644
index 000000000000..94e97a5358e9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+SEC("dump//sys/kernel/bpfdump/bpf_map")
+int dump_bpf_map(struct bpfdump__bpf_map *ctx)
+{
+	static const char banner[] =3D "      id   refcnt  usercnt  locked_vm\n=
";
+	static const char footer[] =3D "      =3D=3D=3D END =3D=3D=3D\n";
+	static const char fmt1[] =3D "%8u %8ld ";
+	static const char fmt2[] =3D "%8ld %10lu\n";
+	struct seq_file *seq =3D ctx->meta->seq;
+	__u64 seq_num =3D ctx->meta->seq_num;
+	struct bpf_map *map =3D ctx->map;
+
+	if (map =3D=3D (void *)0) {
+		bpf_seq_printf(seq, footer, sizeof(footer));
+		return 0;
+	}
+
+	if (seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	bpf_seq_printf(seq, fmt1, sizeof(fmt1), map->id, map->refcnt.counter);
+	bpf_seq_printf(seq, fmt2, sizeof(fmt2), map->usercnt.counter,
+		       map->memory.user->locked_vm.counter);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpfdump_task.c b/tools/tes=
ting/selftests/bpf/progs/bpfdump_task.c
new file mode 100644
index 000000000000..70c5b14934a2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_task.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+SEC("dump//sys/kernel/bpfdump/task")
+int dump_tasks(struct bpfdump__task *ctx)
+{
+	static char const banner[] =3D "    tgid      gid\n";
+	static char const footer[] =3D "=3D=3D=3D END =3D=3D=3D\n";
+	static char const fmt[] =3D "%8d %8d\n";
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+
+	if (task =3D=3D (void *)0) {
+		bpf_seq_printf(seq, footer, sizeof(footer));
+		return 0;
+	}
+
+	if (ctx->meta->seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	bpf_seq_printf(seq, fmt, sizeof(fmt), task->tgid, task->pid);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpfdump_task_file.c b/tool=
s/testing/selftests/bpf/progs/bpfdump_task_file.c
new file mode 100644
index 000000000000..95e3ff6f8a06
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_task_file.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+SEC("dump//sys/kernel/bpfdump/task/file")
+int dump_tasks(struct bpfdump__task_file *ctx)
+{
+	static char const banner[] =3D "    tgid      gid       fd      file\n"=
;
+	static char const fmt1[] =3D "%8d %8d";
+	static char const fmt2[] =3D " %8d %lx\n";
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	__u32 fd =3D ctx->fd;
+	struct file *file =3D ctx->file;
+
+	if (task =3D=3D (void *)0 || file =3D=3D (void *)0)
+		return 0;
+
+	if (ctx->meta->seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	bpf_seq_printf(seq, fmt1, sizeof(fmt1), task->tgid, task->pid);
+	bpf_seq_printf(seq, fmt2, sizeof(fmt2), fd, (long)file->f_op);
+	return 0;
+}
--=20
2.24.1

