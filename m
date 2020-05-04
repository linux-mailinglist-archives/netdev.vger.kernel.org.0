Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B622C1C32CF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgEDG0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:26:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727871AbgEDG0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 02:26:06 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0446DGeQ010006
        for <netdev@vger.kernel.org>; Sun, 3 May 2020 23:26:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=r+QlWEYNflWCNdVmiYu+b6UyF7j73snuUxeDEQNSo3I=;
 b=pz90+ua4Mb0+CTKgK+rhR6OIq7cnLL1NIJ0Ve8hAq3a0mSSS35VOmfor78Yg6KklUPbl
 3yg55rtXXkVXCJsR1xSOsaAch6peVusl6RJq2OsJWkiCM5Z5CtFAXXAvtIES+p2Vt9ob
 OD12X9EQxgj47PLbFAb+/LrPFUylrUL3SgU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srse3cpf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 23:26:04 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 3 May 2020 23:26:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B17C73702037; Sun,  3 May 2020 23:25:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 11/20] bpf: add task and task/file iterator targets
Date:   Sun, 3 May 2020 23:25:59 -0700
Message-ID: <20200504062559.2048228-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200504062547.2047304-1-yhs@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_02:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040054
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
 kernel/bpf/task_iter.c | 336 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 337 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/task_iter.c

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index b2b5eefc5254..37b2d8620153 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -2,7 +2,7 @@
 obj-y :=3D core.o
 CFLAGS_core.o +=3D $(call cc-disable-warning, override-init)
=20
-obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o
+obj-$(CONFIG_BPF_SYSCALL) +=3D syscall.o verifier.o inode.o helpers.o tn=
um.o bpf_iter.o map_iter.o task_iter.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o percpu_freelist.o bp=
f_lru_list.o lpm_trie.o map_in_map.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
new file mode 100644
index 000000000000..1ca258f6e9f4
--- /dev/null
+++ b/kernel/bpf/task_iter.c
@@ -0,0 +1,336 @@
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
+struct bpf_iter_seq_task_common {
+	struct pid_namespace *ns;
+};
+
+struct bpf_iter_seq_task_info {
+	struct bpf_iter_seq_task_common common;
+	struct task_struct *task;
+	u32 id;
+};
+
+static struct task_struct *task_seq_get_next(struct pid_namespace *ns, u=
32 *id)
+{
+	struct task_struct *task =3D NULL;
+	struct pid *pid;
+
+	rcu_read_lock();
+	pid =3D idr_get_next(&ns->idr, id);
+	if (pid)
+		task =3D get_pid_task(pid, PIDTYPE_PID);
+	rcu_read_unlock();
+
+	return task;
+}
+
+static void *task_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_task_info *info =3D seq->private;
+	struct task_struct *task;
+	u32 id =3D info->id;
+
+	task =3D task_seq_get_next(info->common.ns, &id);
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
+	struct bpf_iter_seq_task_info *info =3D seq->private;
+	struct task_struct *task;
+
+	++*pos;
+	++info->id;
+	task =3D task_seq_get_next(info->common.ns, &info->id);
+	if (!task)
+		return NULL;
+
+	put_task_struct(info->task);
+	info->task =3D task;
+	return task;
+}
+
+struct bpf_iter__task {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct task_struct *, task);
+};
+
+DEFINE_BPF_ITER_FUNC(task, struct bpf_iter_meta *meta, struct task_struc=
t *task)
+
+static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_iter__task ctx;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, in_stop);
+	if (prog) {
+		meta.seq =3D seq;
+		ctx.meta =3D &meta;
+		ctx.task =3D v;
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+	}
+
+	return 0;
+}
+
+static int task_seq_show(struct seq_file *seq, void *v)
+{
+	return __task_seq_show(seq, v, false);
+}
+
+static void task_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_task_info *info =3D seq->private;
+
+	if (!v)
+		__task_seq_show(seq, v, true);
+
+	if (info->task) {
+		put_task_struct(info->task);
+		info->task =3D NULL;
+	}
+}
+
+static const struct seq_operations task_seq_ops =3D {
+	.start	=3D task_seq_start,
+	.next	=3D task_seq_next,
+	.stop	=3D task_seq_stop,
+	.show	=3D task_seq_show,
+};
+
+struct bpf_iter_seq_task_file_info {
+	struct bpf_iter_seq_task_common common;
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
+
+		files =3D get_files_struct(tk);
+		put_task_struct(tk);
+		if (!files) {
+			sid =3D ++(*id);
+			*fd =3D 0;
+			goto again;
+		}
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
+	*fd =3D 0;
+	goto again;
+}
+
+static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_task_file_info *info =3D seq->private;
+	struct files_struct *files =3D NULL;
+	struct task_struct *task =3D NULL;
+	struct file *file;
+	u32 id =3D info->id;
+	int fd =3D info->fd;
+
+	file =3D task_file_seq_get_next(info->common.ns, &id, &fd, &task, &file=
s);
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
+	struct bpf_iter_seq_task_file_info *info =3D seq->private;
+	struct files_struct *files =3D info->files;
+	struct task_struct *task =3D info->task;
+	struct file *file;
+
+	++*pos;
+	++info->fd;
+	fput((struct file *)v);
+	file =3D task_file_seq_get_next(info->common.ns, &info->id, &info->fd,
+				      &task, &files);
+	if (!file) {
+		info->files =3D NULL;
+		return NULL;
+	}
+
+	info->task =3D task;
+	info->files =3D files;
+
+	return file;
+}
+
+struct bpf_iter__task_file {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct task_struct *, task);
+	u32 fd;
+	__bpf_md_ptr(struct file *, file);
+};
+
+DEFINE_BPF_ITER_FUNC(task_file, struct bpf_iter_meta *meta,
+		     struct task_struct *task, u32 fd,
+		     struct file *file)
+
+static int __task_file_seq_show(struct seq_file *seq, void *v, bool in_s=
top)
+{
+	struct bpf_iter_seq_task_file_info *info =3D seq->private;
+	struct bpf_iter__task_file ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret =3D 0;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, in_stop);
+	if (prog) {
+		ctx.meta =3D &meta;
+		ctx.task =3D info->task;
+		ctx.fd =3D info->fd;
+		ctx.file =3D v;
+		ret =3D bpf_iter_run_prog(prog, &ctx);
+	}
+
+	return ret;
+}
+
+static int task_file_seq_show(struct seq_file *seq, void *v)
+{
+	return __task_file_seq_show(seq, v, false);
+}
+
+static void task_file_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_task_file_info *info =3D seq->private;
+
+	if (!v)
+		__task_file_seq_show(seq, v, true);
+	else if (!IS_ERR(v))
+		fput((struct file *)v);
+
+	if (info->files) {
+		put_files_struct(info->files);
+		info->files =3D NULL;
+	}
+}
+
+/* The first field of task/task_file private data is
+ * struct bpf_iter_seq_task_common.
+ */
+static int init_seq_pidns(void *priv_data)
+{
+	struct bpf_iter_seq_task_common *common =3D priv_data;
+
+	common->ns =3D get_pid_ns(task_active_pid_ns(current));
+	return 0;
+}
+
+static void fini_seq_pidns(void *priv_data)
+{
+	struct bpf_iter_seq_task_common *common =3D priv_data;
+
+	put_pid_ns(common->ns);
+}
+
+static const struct seq_operations task_file_seq_ops =3D {
+	.start	=3D task_file_seq_start,
+	.next	=3D task_file_seq_next,
+	.stop	=3D task_file_seq_stop,
+	.show	=3D task_file_seq_show,
+};
+
+static int __init task_iter_init(void)
+{
+	struct bpf_iter_reg task_file_reg_info =3D {
+		.target			=3D "task_file",
+		.seq_ops		=3D &task_file_seq_ops,
+		.init_seq_private	=3D init_seq_pidns,
+		.fini_seq_private	=3D fini_seq_pidns,
+		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_file_info),
+	};
+	struct bpf_iter_reg task_reg_info =3D {
+		.target			=3D "task",
+		.seq_ops		=3D &task_seq_ops,
+		.init_seq_private	=3D init_seq_pidns,
+		.fini_seq_private	=3D fini_seq_pidns,
+		.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_info),
+	};
+	int ret;
+
+	ret =3D bpf_iter_reg_target(&task_reg_info);
+	if (ret)
+		return ret;
+
+	return bpf_iter_reg_target(&task_file_reg_info);
+}
+late_initcall(task_iter_init);
--=20
2.24.1

