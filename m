Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC58E1A2C3B
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgDHXZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbgDHXZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:41 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NJKTa018375
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5F2Z4iqSTnHgo+Cx/qOQEe6NpjiSHpelhxgORxYYlvA=;
 b=DNq9QX8bBbsUqVfR+sW5hdhQpoEdyGujx9kP7v0RRvkGn/hqi3UbrTKtQxxVy1lQJO15
 /jUEruVEjgQONajwF4lnS/KgsEIVDm2A/aKBHIFAu2BNON652kANXMcofmJIJ10EU3uX
 UI1RuTSY14yK/TmXpOF2gg57998++EDAwZU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091jtypsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:41 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:40 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 977403700D98; Wed,  8 Apr 2020 16:25:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 15/16] tools/bpf: selftests: add dumper progs for bpf_map/task/task_file
Date:   Wed, 8 Apr 2020 16:25:38 -0700
Message-ID: <20200408232538.2676626-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080163
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
 .../selftests/bpf/progs/bpfdump_bpf_map.c     | 24 +++++++++++++++++++
 .../selftests/bpf/progs/bpfdump_task.c        | 21 ++++++++++++++++
 .../selftests/bpf/progs/bpfdump_task_file.c   | 24 +++++++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_task_file.c

diff --git a/tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c b/tools/=
testing/selftests/bpf/progs/bpfdump_bpf_map.c
new file mode 100644
index 000000000000..c85f5a330010
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_bpf_map.c
@@ -0,0 +1,24 @@
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
+int BPF_PROG(dump_bpf_map, struct bpf_map *map, struct seq_file *seq, u6=
4 seq_num)
+{
+	static const char banner[] =3D "      id   refcnt  usercnt  locked_vm\n=
";
+	static const char fmt1[] =3D "%8u %8ld ";
+	static const char fmt2[] =3D "%8ld %10lu\n";
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
index 000000000000..4d90ba97fbda
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_task.c
@@ -0,0 +1,21 @@
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
+int BPF_PROG(dump_tasks, struct task_struct *task, struct seq_file *seq,=
 u64 seq_num)
+{
+	static char const banner[] =3D "    tgid      gid\n";
+	static char const fmt[] =3D "%8d %8d\n";
+
+	if (seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	bpf_seq_printf(seq, fmt, sizeof(fmt), task->tgid, task->pid);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpfdump_task_file.c b/tool=
s/testing/selftests/bpf/progs/bpfdump_task_file.c
new file mode 100644
index 000000000000..5cf02c050e1f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_task_file.c
@@ -0,0 +1,24 @@
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
+int BPF_PROG(dump_tasks, struct task_struct *task, __u32 fd, struct file=
 *file,
+	     struct seq_file *seq, u64 seq_num)
+{
+	static char const banner[] =3D "    tgid      gid       fd      file\n"=
;
+	static char const fmt1[] =3D "%8d %8d";
+	static char const fmt2[] =3D " %8d %lx\n";
+
+	if (seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	bpf_seq_printf(seq, fmt1, sizeof(fmt1), task->tgid, task->pid);
+	bpf_seq_printf(seq, fmt2, sizeof(fmt2), fd, (long)file->f_op);
+	return 0;
+}
--=20
2.24.1

