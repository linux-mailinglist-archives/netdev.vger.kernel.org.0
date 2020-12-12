Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A992D8408
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 03:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437910AbgLLCtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 21:49:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437628AbgLLCtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 21:49:16 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BC2iTg6013075
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 18:48:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sHmJaFkqQHATn06pZpG76NPfxTsGeEkHjSkDPW+Q0fU=;
 b=Yk58fQyT+cOUoZ5rKOGaeEBycbxlp0Cz7fQjAYbFsCqca8cdKfntBQv5gdQpn8gEhC0X
 OAy3Vyz7uDGvMf0htFMJcmq8AJYLVQeRHavvrvxeMDCoaRnkPc8UVoa9NWyZ8SMN6spW
 hBjyFiZnI+iScrDo2xH6K6eTlmiJkaQ+gb0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35byu0eqcg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 18:48:35 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 18:48:32 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E8A3E62E50ED; Fri, 11 Dec 2020 18:48:26 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 1/4] bpf: introduce task_vma bpf_iter
Date:   Fri, 11 Dec 2020 18:48:07 -0800
Message-ID: <20201212024810.807616-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201212024810.807616-1-songliubraving@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_10:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce task_vma bpf_iter to print memory information of a process. It
can be used to print customized information similar to /proc/<pid>/maps.

task_vma iterator releases mmap_lock before calling the BPF program.
Therefore, we cannot pass vm_area_struct directly to the BPF program. A
new __vm_area_struct is introduced to keep key information of a vma. On
each iteration, task_vma gathers information in __vm_area_struct and
passes it to the BPF program.

If the vma maps to a file, task_vma also holds a reference to the file
while calling the BPF program.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpf.h      |   2 +-
 include/uapi/linux/bpf.h |   7 ++
 kernel/bpf/task_iter.c   | 193 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07cb5d15e7439..49dd1e29c8118 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
 	BPF_ITER_RESCHED	=3D BIT(0),
 };
=20
-#define BPF_ITER_CTX_ARG_MAX 2
+#define BPF_ITER_CTX_ARG_MAX 3
 struct bpf_iter_reg {
 	const char *target;
 	bpf_iter_attach_target_t attach_target;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 30b477a264827..c2db8a1d0cbd2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5151,4 +5151,11 @@ enum {
 	BTF_F_ZERO	=3D	(1ULL << 3),
 };
=20
+struct __vm_area_struct {
+	__u64 start;
+	__u64 end;
+	__u64 flags;
+	__u64 pgoff;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 0458a40edf10a..30e5475d0831e 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -304,9 +304,171 @@ static const struct seq_operations task_file_seq_op=
s =3D {
 	.show	=3D task_file_seq_show,
 };
=20
+struct bpf_iter_seq_task_vma_info {
+	/* The first field must be struct bpf_iter_seq_task_common.
+	 * this is assumed by {init, fini}_seq_pidns() callback functions.
+	 */
+	struct bpf_iter_seq_task_common common;
+	struct task_struct *task;
+	struct __vm_area_struct vma;
+	struct file *file;
+	u32 tid;
+};
+
+static struct __vm_area_struct *
+task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
+{
+	struct pid_namespace *ns =3D info->common.ns;
+	struct task_struct *curr_task;
+	struct vm_area_struct *vma;
+	u32 curr_tid =3D info->tid;
+	bool new_task =3D false;
+
+	/* If this function returns a non-NULL vma, it held a reference to
+	 * the task_struct. If info->file is non-NULL, it also holds a
+	 * reference to the file. Otherwise, it does not hold any
+	 * reference.
+	 */
+again:
+	if (info->task) {
+		curr_task =3D info->task;
+	} else {
+		curr_task =3D task_seq_get_next(ns, &curr_tid, true);
+		if (!curr_task) {
+			info->task =3D NULL;
+			return NULL;
+		}
+
+		if (curr_tid !=3D info->tid) {
+			info->tid =3D curr_tid;
+			new_task =3D true;
+		}
+
+		if (!curr_task->mm)
+			goto next_task;
+		info->task =3D curr_task;
+	}
+
+	mmap_read_lock(curr_task->mm);
+	if (new_task) {
+		vma =3D curr_task->mm->mmap;
+	} else {
+		/* We drop the lock between each iteration, so it is
+		 * necessary to use find_vma() to find the next vma. This
+		 * is similar to the mechanism in show_smaps_rollup().
+		 */
+		vma =3D find_vma(curr_task->mm, info->vma.end - 1);
+		/* same vma as previous iteration, use vma->next */
+		if (vma && (vma->vm_start =3D=3D info->vma.start))
+			vma =3D vma->vm_next;
+	}
+	if (!vma) {
+		mmap_read_unlock(curr_task->mm);
+		goto next_task;
+	}
+	info->task =3D curr_task;
+	info->vma.start =3D vma->vm_start;
+	info->vma.end =3D vma->vm_end;
+	info->vma.pgoff =3D vma->vm_pgoff;
+	info->vma.flags =3D vma->vm_flags;
+	if (vma->vm_file)
+		info->file =3D get_file(vma->vm_file);
+	mmap_read_unlock(curr_task->mm);
+	return &info->vma;
+
+next_task:
+	put_task_struct(curr_task);
+	info->task =3D NULL;
+	curr_tid =3D ++(info->tid);
+	goto again;
+}
+
+static void *task_vma_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+	struct __vm_area_struct *vma;
+
+	info->task =3D NULL;
+	vma =3D task_vma_seq_get_next(info);
+	if (vma && *pos =3D=3D 0)
+		++*pos;
+
+	return vma;
+}
+
+static void *task_vma_seq_next(struct seq_file *seq, void *v, loff_t *po=
s)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+
+	++*pos;
+	if (info->file) {
+		fput(info->file);
+		info->file =3D NULL;
+	}
+	return task_vma_seq_get_next(info);
+}
+
+struct bpf_iter__task_vma {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct task_struct *, task);
+	__bpf_md_ptr(struct __vm_area_struct *, vma);
+	__bpf_md_ptr(struct file *, file);
+};
+
+DEFINE_BPF_ITER_FUNC(task_vma, struct bpf_iter_meta *meta,
+		     struct task_struct *task, struct __vm_area_struct *vma,
+		     struct file *file)
+
+static int __task_vma_seq_show(struct seq_file *seq, bool in_stop)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+	struct bpf_iter__task_vma ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, in_stop);
+	if (!prog)
+		return 0;
+
+	ctx.meta =3D &meta;
+	ctx.task =3D info->task;
+	ctx.vma =3D &info->vma;
+	ctx.file =3D info->file;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int task_vma_seq_show(struct seq_file *seq, void *v)
+{
+	return __task_vma_seq_show(seq, false);
+}
+
+static void task_vma_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_seq_task_vma_info *info =3D seq->private;
+
+	if (!v) {
+		(void)__task_vma_seq_show(seq, true);
+	} else {
+		put_task_struct(info->task);
+		if (info->file) {
+			fput(info->file);
+			info->file =3D NULL;
+		}
+	}
+}
+
+static const struct seq_operations task_vma_seq_ops =3D {
+	.start	=3D task_vma_seq_start,
+	.next	=3D task_vma_seq_next,
+	.stop	=3D task_vma_seq_stop,
+	.show	=3D task_vma_seq_show,
+};
+
 BTF_ID_LIST(btf_task_file_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(struct, file)
+BTF_ID(struct, __vm_area_struct)
=20
 static const struct bpf_iter_seq_info task_seq_info =3D {
 	.seq_ops		=3D &task_seq_ops,
@@ -346,6 +508,28 @@ static struct bpf_iter_reg task_file_reg_info =3D {
 	.seq_info		=3D &task_file_seq_info,
 };
=20
+static const struct bpf_iter_seq_info task_vma_seq_info =3D {
+	.seq_ops		=3D &task_vma_seq_ops,
+	.init_seq_private	=3D init_seq_pidns,
+	.fini_seq_private	=3D fini_seq_pidns,
+	.seq_priv_size		=3D sizeof(struct bpf_iter_seq_task_vma_info),
+};
+
+static struct bpf_iter_reg task_vma_reg_info =3D {
+	.target			=3D "task_vma",
+	.feature		=3D BPF_ITER_RESCHED,
+	.ctx_arg_info_size	=3D 3,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__task_vma, task),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__task_vma, vma),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__task_vma, file),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		=3D &task_vma_seq_info,
+};
+
 static int __init task_iter_init(void)
 {
 	int ret;
@@ -357,6 +541,13 @@ static int __init task_iter_init(void)
=20
 	task_file_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
 	task_file_reg_info.ctx_arg_info[1].btf_id =3D btf_task_file_ids[1];
-	return bpf_iter_reg_target(&task_file_reg_info);
+	ret =3D  bpf_iter_reg_target(&task_file_reg_info);
+	if (ret)
+		return ret;
+
+	task_vma_reg_info.ctx_arg_info[0].btf_id =3D btf_task_file_ids[0];
+	task_vma_reg_info.ctx_arg_info[1].btf_id =3D btf_task_file_ids[2];
+	task_vma_reg_info.ctx_arg_info[2].btf_id =3D btf_task_file_ids[1];
+	return bpf_iter_reg_target(&task_vma_reg_info);
 }
 late_initcall(task_iter_init);
--=20
2.24.1

