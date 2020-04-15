Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E041AB1AB
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411888AbgDOT3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26252 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407088AbgDOT2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:30 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJSMjg024691
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RBprwb+UMJBDIW8xX3D2oQbC5+mlm0Pkg8v4GXg8aT8=;
 b=RKkulOCwRKILXM7BKNkmWCxgoAbM2W8v8xFKAzF3ODOMOYXX15roO4QFsABlMCQlUrrk
 Dde7hCvKRNLAxh1OlUsdI0mXpudXosQoFE53ADsopUMNS5Vv6dVQplusAA7iIZnVxJX0
 oPp48VK6l8429zsGHVFe8hWzXMRxEufcbCw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7gqkqw-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:28 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:57 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A638E3700AF5; Wed, 15 Apr 2020 12:27:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 09/17] bpf: add task and task/file targets
Date:   Wed, 15 Apr 2020 12:27:50 -0700
Message-ID: <20200415192750.4083488-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the tasks belonging to "current" pid namespace
are enumerated.

For task/file target, the bpf program will have access to
  struct task_struct *task
  u32 fd
  struct file *file
where fd/file is an open file for the task.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/Makefile    |   2 +-
 kernel/bpf/dump_task.c | 320 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 321 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/dump_task.c

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 4a1376ab2bea..7e2c73deabab 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_BPF_SYSCALL) +=3D reuseport_array.o
 endif
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_DEBUG_INFO_BTF) +=3D sysfs_btf.o
-obj-$(CONFIG_BPF_SYSCALL) +=3D dump.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D dump.o dump_task.o
 endif
 ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) +=3D bpf_struct_ops.o
diff --git a/kernel/bpf/dump_task.c b/kernel/bpf/dump_task.c
new file mode 100644
index 000000000000..cb0767f4d962
--- /dev/null
+++ b/kernel/bpf/dump_task.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Facebook */
+
+#include <linux/init.h>
+#include <linux/namei.h>
+#include <linux/pid_namespace.h>
+#include <linux/fs.h>
+#include <linux/fdtable.h>
+#include <linux/filter.h>
+
+struct bpfdump_seq_task_info {
+	struct pid_namespace *ns;
+	struct task_struct *task;
+	u32 id;
+};
+
+static struct task_struct *task_seq_get_next(struct pid_namespace *ns, u=
32 *id)
+{
+	struct task_struct *task;
+	struct pid *pid;
+
+	rcu_read_lock();
+	pid =3D idr_get_next(&ns->idr, id);
+	task =3D get_pid_task(pid, PIDTYPE_PID);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	return task;
+}
+
+static void *task_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpfdump_seq_task_info *info =3D seq->private;
+	struct task_struct *task;
+	u32 id =3D info->id + 1;
+
+	if (*pos =3D=3D 0)
+		info->ns =3D task_active_pid_ns(current);
+
+	task =3D task_seq_get_next(info->ns, &id);
+	if (!task)
+		return NULL;
+
+	++*pos;
+	info->task =3D task;
+	info->id =3D id;
+
+	return task;
+}
+
+static void *task_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpfdump_seq_task_info *info =3D seq->private;
+	struct task_struct *task;
+	u32 id =3D info->id + 1;
+
+	++*pos;
+	task =3D task_seq_get_next(info->ns, &id);
+	if (!task)
+		return NULL;
+
+	put_task_struct(info->task);
+	info->task =3D task;
+	info->id =3D id;
+	return task;
+}
+
+struct bpfdump__task {
+	struct bpf_dump_meta *meta;
+	struct task_struct *task;
+};
+
+int __init __bpfdump__task(struct bpf_dump_meta *meta, struct task_struc=
t *task)
+{
+	return 0;
+}
+
+static int task_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_dump_meta meta;
+	struct bpfdump__task ctx;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct bpfdump_seq_task_info),
+				 &meta.session_id, &meta.seq_num,
+				 v =3D=3D (void *)0);
+	if (prog) {
+		meta.seq =3D seq;
+		ctx.meta =3D &meta;
+		ctx.task =3D v;
+		ret =3D bpf_dump_run_prog(prog, &ctx);
+	}
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static void task_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpfdump_seq_task_info *info =3D seq->private;
+
+	if (!v)
+		task_seq_show(seq, v);
+
+	if (info->task) {
+		put_task_struct(info->task);
+		info->task =3D NULL;
+	}
+}
+
+static const struct seq_operations task_seq_ops =3D {
+        .start  =3D task_seq_start,
+        .next   =3D task_seq_next,
+        .stop   =3D task_seq_stop,
+        .show   =3D task_seq_show,
+};
+
+struct bpfdump_seq_task_file_info {
+	struct pid_namespace *ns;
+	struct task_struct *task;
+	struct files_struct *files;
+	u32 id;
+	u32 fd;
+};
+
+static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32=
 *id,
+					   int *fd, struct task_struct **task,
+					   struct files_struct **fstruct)
+{
+	struct files_struct *files;
+	struct task_struct *tk;
+	u32 sid =3D *id;
+	int sfd;
+
+	/* If this function returns a non-NULL file object,
+	 * it held a reference to the files_struct and file.
+	 * Otherwise, it does not hold any reference.
+	 */
+again:
+	if (*fstruct) {
+		files =3D *fstruct;
+		sfd =3D *fd;
+	} else {
+		tk =3D task_seq_get_next(ns, &sid);
+		if (!tk)
+			return NULL;
+		files =3D get_files_struct(tk);
+		put_task_struct(tk);
+		if (!files)
+			return NULL;
+		*fstruct =3D files;
+		*task =3D tk;
+		if (sid =3D=3D *id) {
+			sfd =3D *fd;
+		} else {
+			*id =3D sid;
+			sfd =3D 0;
+		}
+	}
+
+	rcu_read_lock();
+	for (; sfd < files_fdtable(files)->max_fds; sfd++) {
+		struct file *f;
+
+		f =3D fcheck_files(files, sfd);
+		if (!f)
+			continue;
+
+		*fd =3D sfd;
+		get_file(f);
+		rcu_read_unlock();
+		return f;
+	}
+
+	/* the current task is done, go to the next task */
+	rcu_read_unlock();
+	put_files_struct(files);
+	*fstruct =3D NULL;
+	sid =3D ++(*id);
+	goto again;
+}
+
+static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpfdump_seq_task_file_info *info =3D seq->private;
+	struct files_struct *files =3D NULL;
+	struct task_struct *task =3D NULL;
+	struct file *file;
+	u32 id =3D info->id;
+	int fd =3D info->fd + 1;
+
+	if (*pos =3D=3D 0)
+		info->ns =3D task_active_pid_ns(current);
+
+	file =3D task_file_seq_get_next(info->ns, &id, &fd, &task, &files);
+	if (!file) {
+		info->files =3D NULL;
+		return NULL;
+	}
+
+	++*pos;
+	info->id =3D id;
+	info->fd =3D fd;
+	info->task =3D task;
+	info->files =3D files;
+
+	return file;
+}
+
+static void *task_file_seq_next(struct seq_file *seq, void *v, loff_t *p=
os)
+{
+	struct bpfdump_seq_task_file_info *info =3D seq->private;
+	struct files_struct *files =3D info->files;
+	struct task_struct *task =3D info->task;
+	int fd =3D info->fd + 1;
+	struct file *file;
+	u32 id =3D info->id;
+
+	++*pos;
+	fput((struct file *)v);
+	file =3D task_file_seq_get_next(info->ns, &id, &fd, &task, &files);
+	if (!file) {
+		info->files =3D NULL;
+		return NULL;
+	}
+
+	info->id =3D id;
+	info->fd =3D fd;
+	info->task =3D task;
+	info->files =3D files;
+
+	return file;
+}
+
+struct bpfdump__task_file {
+	struct bpf_dump_meta *meta;
+	struct task_struct *task;
+	u32 fd;
+	struct file *file;
+};
+
+int __init __bpfdump__task_file(struct bpf_dump_meta *meta,
+			      struct task_struct *task, u32 fd,
+			      struct file *file)
+{
+	return 0;
+}
+
+static int task_file_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpfdump_seq_task_file_info *info =3D seq->private;
+	struct bpfdump__task_file ctx;
+	struct bpf_dump_meta meta;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct bpfdump_seq_task_file_inf=
o),
+				 &meta.session_id, &meta.seq_num, v =3D=3D (void *)0);
+	if (prog) {
+		meta.seq =3D seq;
+		ctx.meta =3D &meta;
+		ctx.task =3D info->task;
+		ctx.fd =3D info->fd;
+		ctx.file =3D v;
+		ret =3D bpf_dump_run_prog(prog, &ctx);
+	}
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static void task_file_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpfdump_seq_task_file_info *info =3D seq->private;
+
+	if (v)
+		fput((struct file *)v);
+	else
+		task_file_seq_show(seq, v);
+
+	if (info->files) {
+		put_files_struct(info->files);
+		info->files =3D NULL;
+	}
+}
+
+static const struct seq_operations task_file_seq_ops =3D {
+        .start  =3D task_file_seq_start,
+        .next   =3D task_file_seq_next,
+        .stop   =3D task_file_seq_stop,
+        .show   =3D task_file_seq_show,
+};
+
+static int __init task_dump_init(void)
+{
+	struct bpf_dump_reg task_file_reg_info =3D {
+		.target			=3D "task/file",
+		.target_proto		=3D "__bpfdump__task_file",
+		.prog_ctx_type_name	=3D "bpfdump__task_file",
+		.seq_ops		=3D &task_file_seq_ops,
+		.seq_priv_size		=3D sizeof(struct bpfdump_seq_task_file_info),
+		.target_feature		=3D 0,
+	};
+	struct bpf_dump_reg task_reg_info =3D {
+		.target			=3D "task",
+		.target_proto		=3D "__bpfdump__task",
+		.prog_ctx_type_name	=3D "bpfdump__task",
+		.seq_ops		=3D &task_seq_ops,
+		.seq_priv_size		=3D sizeof(struct bpfdump_seq_task_info),
+		.target_feature		=3D 0,
+	};
+	int ret;
+
+	ret =3D bpf_dump_reg_target(&task_reg_info);
+	if (ret)
+		return ret;
+
+	return bpf_dump_reg_target(&task_file_reg_info);
+}
+late_initcall(task_dump_init);
--=20
2.24.1

